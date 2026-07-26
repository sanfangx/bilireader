import 'package:dio/dio.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

import '../app_config.dart';
import '../models/book_review.dart';
import '../models/catalog.dart';
import '../models/novel_detail.dart';
import '../models/novel_summary.dart';
import '../models/topic.dart';
import '../models/user_profile.dart';
import 'api_client.dart';
import 'auth_interceptor.dart';
import 'cf_signals.dart';

/// 目錄頁抓到了，但**不是一份目錄**（限流頁／CF 挑戰頁／站方改版）。
///
/// 存在的意義是把「錯誤」與「這本書沒有章節」分開。回空目錄會讓下游把失敗當成合法值：
/// 書架續讀曾因此 `clamp(0, -1)` 拋 ArgumentError 並 pop 掉 AppShell 根路由（黑畫面），
/// 整本下載則產生 0 章空書——兩者都毫無徵兆。
class CatalogUnavailableException implements Exception {
  const CatalogUnavailableException();
  @override
  String toString() => 'CatalogUnavailableException（目錄頁無 .volume-chapters 容器）';
}

/// linovelib 內容 API（探索/列表頁皆為開放 HTML，dio 直抓 + 解析）。
/// 注意：章節「內文」之後改用 WebView 渲染擷取（處理段落打亂），此處只做列表/詳情。
class LinovelibApi {
  LinovelibApi._();
  static final LinovelibApi instance = LinovelibApi._();

  final _dio = ApiClient.instance.dio;

  /// 分頁列表用：把「暫時性 HTTP 錯誤 / CF 挑戰」轉成例外，別讓它被當成
  /// 「空頁」靜默吞掉（dio `validateStatus:(_)=>true` → 429/503 是正常 Response）。
  /// 一般 200（含真的沒有結果）與 404（超出範圍頁）不丟，交由解析/去重判到底。
  void _assertListable(Response<String> res) {
    final int code = res.statusCode ?? 0;
    if (CfSignals.isTransientStatus(code) || CfSignals.looksLikeChallenge(res)) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
        message: '列表載入失敗（HTTP $code）',
      );
    }
  }

  /// 排行榜：/top/{metric}/{page}.html
  /// metric 例：monthvisit 月點擊 / monthvote 推薦 / monthflower 鮮花 / goodnum 收藏 / newhot 新書
  Future<List<NovelSummary>> ranking({
    String metric = 'monthvisit',
    int page = 1,
    bool full = false,
    CancelToken? cancelToken,
  }) async {
    final base = full ? '/topfull' : '/top';
    final res = await _dio.get<String>(
      '$base/$metric/$page.html',
      cancelToken: cancelToken,
    );
    _assertListable(res);
    return _parseBookList(res.data ?? '');
  }

  /// 文庫：/wenku/{order}_{tagid}_{isfull}_{anime}_{rgroupid}_0_0_{words}_{page}_0.html
  Future<List<NovelSummary>> library({
    String order = 'monthvisit',
    int tagid = 0,
    int rgroupid = 0,
    int isfull = 0,
    int words = 0,
    int page = 1,
    CancelToken? cancelToken,
  }) async {
    final path =
        '/wenku/${order}_${tagid}_${isfull}_0_${rgroupid}_0_0_${words}_${page}_0.html';
    final res = await _dio.get<String>(path, cancelToken: cancelToken);
    _assertListable(res);
    return _parseBookList(res.data ?? '');
  }

  /// 書籍詳情：/novel/{id}.html
  Future<NovelDetail> novelDetail(String id) async {
    final res = await _dio.get<String>('/novel/$id.html');
    // 少了這道，限流／CF 頁會解析成「每個欄位都是空字串」的詳情，畫面看起來像
    // 一本沒有書名沒有簡介的書，而不是一次可重試的失敗。
    _assertListable(res);
    final doc = html_parser.parse(res.data ?? '');
    final img = doc.querySelector('.book-layout img');
    final metas = doc.querySelectorAll('.book-meta');

    String? wordCount, status;
    bool animated = false;
    String? lastUpdate;
    for (final m in metas) {
      final t = m.text.replaceAll(RegExp(r'\s+'), ' ').trim();
      if (t.contains('萬字') || t.contains('万字')) {
        final parts = t.split('|').map((e) => e.trim()).toList();
        if (parts.isNotEmpty) wordCount = parts[0];
        if (parts.length > 1) status = parts[1];
        animated = t.contains('動畫') || t.contains('动画');
      } else if (t.contains('更新')) {
        lastUpdate = t.replaceFirst(RegExp(r'^最[后後]更新[·:：]?\s*'), '');
      }
    }

    final tags = doc
        .querySelectorAll('.book-cell .book-meta span em, .book-meta em')
        .map((e) => e.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    return NovelDetail(
      id: id,
      title: doc.querySelector('.book-title')?.text.trim() ?? '',
      author: doc.querySelector('.book-rand-a span')?.text.trim(),
      coverPath: img?.attributes['src'] ?? img?.attributes['data-src'],
      summary: (doc.querySelector('#bookSummary content') ??
              doc.querySelector('#bookSummary'))
          ?.text
          .trim(),
      score: doc.querySelector('.score-num')?.text.trim(),
      wordCount: wordCount,
      status: status,
      animated: animated,
      lastUpdate: lastUpdate,
      tags: tags,
      shelved: parseShelvedFlag(doc),
    );
  }

  /// 從詳情頁 DOM 解析「已在書架」（純函式，供測試）。官網收藏鈕：已收藏
  /// `#a_delbookcase`（「已收藏」）、未收藏 `#a_addbookcase`（「書架」）；
  /// 未登入時無此鈕 → false。（2026-07-12 真實 Chrome 實地確認。）
  static bool parseShelvedFlag(dom.Document doc) =>
      doc.getElementById('a_delbookcase') != null;

  /// 目錄：/novel/{id}/catalog
  Future<Catalog> catalog(String id) async {
    final res = await _dio.get<String>('/novel/$id/catalog');
    _assertListable(res);
    return parseCatalog(res.data ?? '');
  }

  /// 目錄頁 HTML → [Catalog]（純函式，供測試；與 [parseReviewList] 等同慣例）。
  ///
  /// **拿不到目錄容器時拋例外，而不是回空目錄**：站方限流/CF 挑戰頁同樣是合法 HTML，
  /// 解析不到 `.volume-chapters` 就回「空目錄」等於把**錯誤偽裝成沒有資料**，
  /// 而下游全都把空目錄當合法值處理——書架續讀曾因此 `clamp(0, -1)` 拋 ArgumentError
  /// 並把 AppShell 根路由 pop 掉（黑畫面），下載則產生 0 章空書。
  ///
  /// 容器存在但沒有章節 → 照常回空目錄（那才是「這本真的還沒有章節」）。
  /// 取捨：若站方改版換掉此 class，會變成每次都「目錄載入失敗」而非靜默空目錄——
  /// 刻意選擇**大聲失敗**，靜默的空目錄正是本專案吃過大虧的失敗模式。
  static Catalog parseCatalog(String html) {
    final doc = html_parser.parse(html);
    if (doc.querySelector('.volume-chapters') == null) {
      throw const CatalogUnavailableException();
    }
    final volumes = <Volume>[];
    Volume? current;

    for (final li in doc.querySelectorAll('.volume-chapters > li')) {
      final cls = li.className;
      if (cls.contains('chapter-bar')) {
        current = Volume(name: li.text.trim());
        volumes.add(current);
      } else if (cls.contains('volume-cover')) {
        final cimg = li.querySelector('img');
        current?.coverPath = cimg?.attributes['src'] ?? cimg?.attributes['data-src'];
      } else if (cls.contains('jsChapter')) {
        final a = li.querySelector('a');
        var href = a?.attributes['href'];
        final vip = _isVipChapter(li);
        String? url;
        if (href != null && !href.contains('javascript')) {
          url = href.startsWith('http') ? href : '${AppConfig.origin}$href';
        }
        (current ??= _ensureVolume(volumes)).chapters.add(
              Chapter(title: a?.text.trim() ?? li.text.trim(), url: url, vip: vip),
            );
      }
    }
    return Catalog(volumes: volumes);
  }

  /// 書評列表：`/reviews_{aid}_{page}.html`（開放 HTML，唯讀爬取）。
  /// 每頁約 30 則；回傳空清單表示無更多（供分頁停止）。
  Future<List<BookReview>> reviews(String novelId, {int page = 1}) async {
    final res = await _dio.get<String>('/reviews_${novelId}_$page.html');
    // 少了這道，429／CF 頁會被解析成空清單，而呼叫端把「空頁」當成「已到底」
    // → 永久停止分頁，且使用者看不出是失敗（錯誤被偽裝成沒有資料）。
    _assertListable(res);
    return parseReviewList(res.data ?? '');
  }

  /// 圈子（社群貼文）列表：`/alltopics`（第 1 頁）/ `/alltopics_{page}`（後續，唯讀爬取）。
  Future<List<Topic>> topics({int page = 1}) async {
    final path = page <= 1 ? '/alltopics' : '/alltopics_$page';
    final res = await _dio.get<String>(path);
    _assertListable(res); // 同 reviews：空頁 ≠ 到底（見該處註解）
    return parseTopicList(res.data ?? '');
  }

  static Volume _ensureVolume(List<Volume> volumes) {
    if (volumes.isEmpty) volumes.add(Volume(name: ''));
    return volumes.last;
  }

  static bool _isVipChapter(dom.Element li) {
    if (RegExp(r'\bvip\b', caseSensitive: false).hasMatch(li.className)) {
      return true;
    }
    // 鎖頭圖示 / vip 標記類別
    return li.querySelector('.vip, .chapter-lock, [class*=lock], [class*=vip]') !=
        null;
  }

  // 章節 URL 取章 id：/novel/6/1403.html 或 /novel/6/1403_2.html → "1403"
  static String? _chapterCid(String url) =>
      RegExp(r'/(\d+)(?:_\d+)?\.html').firstMatch(url)?.group(1);

  /// 從某章節 URL 順著 `ReadParams.url_next` 跨過該章所有分頁，回傳「下一章」的絕對 URL。
  /// （`url_next` 在頁面原始 HTML 的內嵌 script，dio 直抓即可，不需 WebView。）失敗回 null。
  Future<String?> resolveNextChapterUrl(String fromUrl) async {
    var url = fromUrl;
    final baseCid = _chapterCid(url);
    for (int i = 0; i < 25; i++) {
      String html;
      try {
        final res = await _dio.get<String>(url);
        html = res.data ?? '';
      } catch (_) {
        return null;
      }
      final m =
          RegExp(r'''url_next\s*[:=]\s*['"]([^'"]+)['"]''').firstMatch(html);
      final next = m?.group(1)?.trim() ?? '';
      if (next.isEmpty ||
          next.contains('catalog') ||
          next.contains('javascript')) {
        return null;
      }
      final abs = next.startsWith('http') ? next : '${AppConfig.origin}$next';
      if (_chapterCid(abs) != baseCid) return abs; // 跨章 → 即為下一章
      url = abs; // 同章下一分頁，繼續往後找章界
    }
    return null;
  }

  /// 解析「壞連結」章節（站方目錄給 `javascript:cid(...)` 假連結、url==null、非 VIP）的真實 URL：
  /// 從前面最近一個有真實 URL 的章節，沿閱讀鏈 `url_next` 往後串接到 index。
  Future<String?> resolveBrokenChapterUrl(List<Chapter> flat, int index) async {
    if (index < 0 || index >= flat.length) return null;
    if (flat[index].url != null) return flat[index].url;
    int p = index - 1;
    while (p >= 0 && flat[p].url == null) {
      p--;
    }
    if (p < 0) return null; // 前面找不到可用起點
    String? cur = flat[p].url;
    for (int k = p; k < index && cur != null; k++) {
      cur = await resolveNextChapterUrl(cur);
    }
    return cur;
  }

  /// 我的書架：`/bookcase.php?classid={0-5}&sortorder={lastupdate|joindate}`（需登入 cookie）。
  /// classid 對應網站原生固定分組（見 `ShelfClass`）；未登入會 302→login.php（解析不到→空清單）。
  Future<List<NovelSummary>> bookcase({
    int classid = 0,
    String sortorder = 'lastupdate',
  }) async {
    final res = await _dio.get<String>(
      '/bookcase.php',
      queryParameters: {
        'classid': classid,
        'sortorder': sortorder,
        // cache-buster：實測移除/移動後立即重抓會拿到快取的舊清單（CF/Jieqi 頁快取），
        // 以時間戳參數繞過（PHP 端忽略未知參數）。
        '_': DateTime.now().millisecondsSinceEpoch,
      },
    );
    // 少了這道，限流／CF 頁會解析成空清單 → 書架顯示「空空如也」，**而且那個空清單
    // 會被寫進分組快取覆蓋掉原本正確的資料**。空書架是合法狀態（故不另做結構檢查），
    // 但「抓失敗」必須與「真的沒有收藏」分得開。
    _assertListable(res);
    final doc = html_parser.parse(res.data ?? '');
    final out = <NovelSummary>[];
    final seen = <String>{};
    for (final box in doc.querySelectorAll('div.rel')) {
      final a = box.querySelector('a[href*="/novel/"]');
      final m = RegExp(r'/novel/(\d+)').firstMatch(a?.attributes['href'] ?? '');
      final img = box.querySelector('img');
      if (a == null || m == null || img == null) continue;
      final id = m.group(1)!;
      if (seen.contains(id)) continue;
      seen.add(id);
      final title =
          (box.querySelector('.book-title-x, .book-title')?.text ?? a.text)
              .trim();
      out.add(NovelSummary(
        id: id,
        title: title,
        coverPath: img.attributes['data-src'] ?? img.attributes['src'],
      ));
    }
    return out;
  }

  /// 使用者中心：`/user.php`（需登入 cookie）。解析暱稱 / 頭像 / 會員等級。
  ///
  /// 回 null = 未登入（被導回 login.php）/ 空回應 / 解析不到任何關鍵欄位。
  /// 頭像路徑 `/files/system/avatar/{seg}/{id}s.jpg` 是實測已知且高度特異的規則，
  /// 以正則抓最穩、並由檔名反推 userId；暱稱 / 等級的 CSS 選擇器尚未逐一實測
  /// （🔶 需以真實 /user.php DOM 校準），故用多重 fallback + 防呆，抓不到退回 null。
  Future<UserProfile?> userProfile() async {
    final Response<String> res;
    try {
      res = await _dio.get<String>(
        '/user.php',
        // best-effort 身分抓取：遇 CF 挑戰不得把剛登入的 session 誤標過期。
        options: Options(
          extra: <String, dynamic>{AuthInterceptor.suppressExpiryKey: true},
        ),
      );
    } catch (_) {
      return null;
    }
    if ((res.statusCode ?? 0) != 200) return null;
    // 未登入 → 被導回 login.php（dio 已跟隨重導）。
    if (res.realUri.toString().contains('/login.php')) return null;
    return parseUserProfileHtml(res.data ?? '');
  }

  /// 從 `/user.php` 的 HTML 解析 [UserProfile]（純函式，與網路 I/O 分離、供測試）。
  /// 抓不到任何關鍵欄位（userId/暱稱/頭像）回 null。
  ///
  /// 頭像路徑 `/files/system/avatar/{seg}/{id}s.jpg` 是實測已知且高度特異的規則，
  /// 以正則抓最穩、並由檔名反推 userId；暱稱 / 等級的 CSS 選擇器尚未逐一實測
  /// （🔶 需以真實 /user.php DOM 校準），故用多重 fallback，抓不到退回 null 欄位。
  static UserProfile? parseUserProfileHtml(String body) {
    if (body.isEmpty) return null;

    // 頭像 + userId：/files/system/avatar/436/436700s.jpg（s=小圖 / l=大圖）
    String? avatarUrl;
    String? userId;
    final avatarM = RegExp(
      r'/files/system/avatar/\d+/(\d+)[sl]?\.(?:jpg|jpeg|png|gif)',
      caseSensitive: false,
    ).firstMatch(body);
    if (avatarM != null) {
      userId = avatarM.group(1);
      final path = avatarM.group(0)!;
      avatarUrl = path.startsWith('http') ? path : '${AppConfig.origin}$path';
    }

    final doc = html_parser.parse(body);
    // 暱稱（多重 fallback，🔶 待真實 DOM 校準）。
    final nickname = _firstText(doc, const <String>[
      '.user-name', '.username', '.uname', '#username',
      '.member-name', '.user-info .name', '.userinfo .name',
    ]);
    // 會員等級。
    final levelLabel = _firstText(doc, const <String>[
      '.user-level', '.member-level', '.vip-level', '.level', '.grade',
    ]);
    final isVip = levelLabel?.toUpperCase().contains('VIP') ?? false;

    final profile = UserProfile(
      userId: userId,
      nickname: nickname,
      avatarUrl: avatarUrl,
      levelLabel: levelLabel,
      isVip: isVip,
    );
    return profile.isEmpty ? null : profile;
  }

  /// 依序試多個選擇器，回第一個非空文字。
  static String? _firstText(dom.Document doc, List<String> selectors) {
    for (final sel in selectors) {
      final t = doc.querySelector(sel)?.text.trim();
      if (t != null && t.isNotEmpty) return t;
    }
    return null;
  }

  /// 加入書架：`POST /modules/article/addbookcase.php?bid={novelId}`（bid 走 query、body 空）。
  /// 實地確認自官網 `toggleBookcaseStatus`（2026-07-12 真實 Chrome）：加入用 `?bid=`、
  /// 移除用 `?did=`，皆 POST、按小說 id、免 CSRF token。
  Future<bool> addToShelf(String id) async {
    final res = await _dio.post<String>(
      '/modules/article/addbookcase.php',
      queryParameters: {'bid': id},
      options: Options(
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'Referer': '${AppConfig.origin}/novel/$id.html',
        },
      ),
    );
    return _shelfOk(res);
  }

  /// 移除書架：`POST /modules/article/addbookcase.php?did={novelId}`（did 走 query、body 空）。
  /// **修正**：舊版打不存在的 `delbookcase.php`；官網移除實為同一支 addbookcase.php 帶 `?did=`。
  Future<bool> removeFromShelf(String id) async {
    final res = await _dio.post<String>(
      '/modules/article/addbookcase.php',
      queryParameters: {'did': id},
      options: Options(
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'Referer': '${AppConfig.origin}/bookcase.php',
        },
      ),
    );
    return _shelfOk(res);
  }

  /// 指派收藏分組（移動到某分組）：`POST /modules/article/addbookcase.php`
  /// body（form）`checkid={novelId}&newclassid={classid}&act=move`。
  /// 實地確認自官網 `selectGroup`（2026-07-12）。classid 需已在書架的書。
  Future<bool> assignShelfGroup(String novelId, int classid) async {
    final res = await _dio.post<String>(
      '/modules/article/addbookcase.php',
      data: {
        'checkid': novelId,
        'newclassid': '$classid',
        'act': 'move',
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'Referer': '${AppConfig.origin}/bookcase.php',
        },
      ),
    );
    return _shelfOk(res);
  }

  /// 送出書籍評分：POST /modules/article/rating.php（form: id + score 1~5）。
  /// 需登入。成功判定沿用 [_actionOk]（200 且非登入導向）。
  /// 這是 api-ver 互動域中唯一 web 端完全可行的動作（gift/vote 不做）。
  Future<bool> submitRating(String id, int score) async {
    final res = await _dio.post<String>(
      '/modules/article/rating.php',
      data: {'id': id, 'score': score.clamp(1, 5)},
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'Referer': '${AppConfig.origin}/novel/$id.html',
        },
      ),
    );
    return _actionOk(res);
  }

  /// 書架操作的成功判定（同 [_actionOk]）。
  bool _shelfOk(Response<String> res) => _actionOk(res);

  /// 動作型端點（書架 / 評分）的成功判定。JieqiCMS 這些動作成功回傳 `jieqi_showmessage`
  /// 模板頁，`<title>處理成功…</title>` / `<h2>處理成功</h2>`（2026-07-12 實地擷取 add `?bid=`、
  /// remove `?did=`、move `act=move` 三者回應皆如此）；失敗回「處理失敗」或錯誤 / 登入頁。
  /// 以**正向成功標記**判定——舊版「200 且非登入即成功」對任何 200（含伺服器錯誤頁）都偽陽。
  static bool actionOkBody(int? statusCode, String body) {
    if ((statusCode ?? 0) != 200) return false;
    // 登入導向 / 明確失敗 → 失敗（先於成功標記檢查，避免「未成功」之類誤判）。
    if (body.contains('login.php') ||
        body.contains('請登') ||
        body.contains('登錄') ||
        body.contains('登录') ||
        body.contains('失敗') ||
        body.contains('失败')) {
      return false;
    }
    // 正向成功標記（showmessage 的「處理成功」；兼容其他「…成功」訊息）。
    return body.contains('成功');
  }

  bool _actionOk(Response<String> res) =>
      actionOkBody(res.statusCode, res.data ?? '');

  /// 解析 li.book-li 書目列表（排行/文庫共用同一結構）。
  List<NovelSummary> _parseBookList(String htmlStr) {
    final doc = html_parser.parse(htmlStr);
    final out = <NovelSummary>[];
    for (final li in doc.querySelectorAll('li.book-li')) {
      final a =
          li.querySelector('a.book-layout') ?? li.querySelector('a[href*="/novel/"]');
      final href = a?.attributes['href'] ?? '';
      final m = RegExp(r'/novel/(\d+)').firstMatch(href);
      if (m == null) continue;
      final img = li.querySelector('img');
      final cover = img?.attributes['data-src'] ?? img?.attributes['src'];
      final tags = li
          .querySelectorAll('.book-meta em, .tag, .book-tags a')
          .map((e) => e.text.trim())
          .where((t) => t.isNotEmpty)
          .take(3)
          .toList();
      out.add(
        NovelSummary(
          id: m.group(1)!,
          title: li.querySelector('.book-title')?.text.trim() ?? '',
          author: li.querySelector('.book-meta')?.text.trim(),
          intro: li.querySelector('.book-intro')?.text.trim(),
          coverPath: cover,
          rank: int.tryParse(li.querySelector('.top-number')?.text.trim() ?? ''),
          tags: tags,
        ),
      );
    }
    return out;
  }
}
