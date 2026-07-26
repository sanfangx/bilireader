// 私有注入依賴以具名參數傳入，只能用 `: _x = x`（Dart 不允許 `this._x` 具名形參）；
// prefer_initializing_formals 對此為誤報。與 api-ver ChapterTextRepositoryImpl 同一慣用法。
// ignore_for_file: prefer_initializing_formals
import 'dart:convert';

import '../../../core/storage/database/app_database.dart';
import '../content_block.dart';
import '../domain/chapter_text.dart';
import 'chapter_content_source.dart';
import 'chapter_text_assembler.dart';

/// 章節無法取得（多為 VIP 鎖章 / 空章 / 擷取失敗）。**不寫入快取**，由展示層提示登入或重試。
class ChapterUnavailableException implements Exception {
  const ChapterUnavailableException(
    this.articleId,
    this.chapterId, [
    this.reason = 'empty',
  ]);

  final int articleId;
  final int chapterId;
  final String reason;

  @override
  String toString() =>
      'ChapterUnavailableException($articleId:$chapterId, $reason)';
}

/// 站方只送出**截斷**的正文（約 1/3 段落 + 「內容加載失敗」標記）。**不寫入快取**。
///
/// 觸發條件是「請求不受站方信任」。2026-07-25 逐項實測**排除**了：UA（行動/桌機/iPhone）、
/// Referer、Accept 三件組、Sec-Fetch、HTTP/1.1 vs 2、以及 **cookie 整體**——同一個 Chrome
/// 用 `credentials:'omit'`（完全不送 cookie，故也不送 cf_clearance）照樣拿到完整內容。
/// 剩下的分野是**用戶端指紋**（TLS/JA3、HTTP2 設定、header 順序）。
/// 故：重試同一個用戶端多半無效，補 cookie 也無效；真 WebView 才是可行路徑。
///
/// **這個例外只代表「不可信任到足以永久保存」，不代表「不可閱讀」**：截斷的那 1/3 是
/// 真實正文，讀一部分遠好過完全讀不到。故一併帶出 [partial] 供展示層在使用者**明確
/// 選擇**後渲染（僅此一次、不落快取）。若不帶出，站方的一串字就等同於封鎖章節——那正是
/// convention「Never pre-block chapters based on HTML markers」明令禁止的失敗模式。
class ChapterContentTruncatedException implements Exception {
  const ChapterContentTruncatedException(
    this.articleId,
    this.chapterId,
    this.partial,
  );

  final int articleId;
  final int chapterId;

  /// 已擷取到的（不完整）正文。展示層可據此提供「仍要閱讀」的降級路徑。
  final ChapterText partial;

  @override
  String toString() =>
      'ChapterContentTruncatedException($articleId:$chapterId, '
      'partialBlocks=${partial.text.length})';
}

/// web 版章節正文倉儲。忠實對映 api-ver `ChapterTextRepositoryImpl`：
/// drift `ChapterContents` 永久快取優先（§7.5），未命中才用 [ChapterContentSource] 擷取並
/// 寫回；in-flight dedupe 合併同章並發。**快取存合成後整章 HTML**（OpenCC 不適用 tw 站）。
///
/// 與 api-ver 的差異（web 適配）：內容源為 WebView 擷取（需章節 [url]）而非 readpai
/// getNovelText；VIP/空章以 [hasRenderableContent] 偵測並拋 [ChapterUnavailableException]、
/// 不污染快取；回傳 [ChapterText]（切塊交由展示層的 `ReaderContentBuilder`），失敗以例外表達。
/// 離線下載內容查找（由組合根注入 `OfflineStore.contentFor`；測試可注入假函式）。
/// 回 null 表示該章未下載 → 走 drift 快取/線上擷取。
typedef OfflineChapterLookup =
    Future<ChapterContent?> Function(int articleId, int chapterId);

class ChapterTextRepository {
  ChapterTextRepository({
    required ChapterContentSource source,
    required ChapterCacheDao cacheDao,
    OfflineChapterLookup? offlineLookup,
    int Function()? clockMs,
  }) : _source = source,
       _cacheDao = cacheDao,
       _offlineLookup = offlineLookup,
       _clockMs = clockMs;

  final ChapterContentSource _source;
  final ChapterCacheDao _cacheDao;
  final OfflineChapterLookup? _offlineLookup;
  final int Function()? _clockMs;

  static const ChapterTextAssembler _assembler = ChapterTextAssembler();

  final Map<String, Future<ChapterText>> _inFlight =
      <String, Future<ChapterText>>{};

  /// 永久快取優先；未命中擷取（dedupe）並寫回。VIP/空章拋 [ChapterUnavailableException]。
  Future<ChapterText> getChapterText({
    required int articleId,
    required int chapterId,
    required String url,
    String chapterName = '',
  }) {
    final String key = '$articleId:$chapterId';
    final Future<ChapterText>? pending = _inFlight[key];
    if (pending != null) {
      return pending;
    }
    final Future<ChapterText> task = _load(
      articleId: articleId,
      chapterId: chapterId,
      url: url,
      chapterName: chapterName,
    );
    _inFlight[key] = task;
    return task.whenComplete(() => _inFlight.remove(key));
  }

  Future<bool> isCached({
    required int articleId,
    required int chapterId,
  }) async =>
      (await _cacheDao.getChapterContent(articleId, chapterId)) != null;

  Future<ChapterText> _load({
    required int articleId,
    required int chapterId,
    required String url,
    required String chapterName,
  }) async {
    // 0) 離線下載內容**最優先**（純本機、斷網可讀、圖片為本機路徑）。
    //    不寫 drift：本機絕對路徑不可持久化（iOS 容器路徑會變），且內容已在本機無需再快取。
    final ChapterContent? offline = await _offlineLookup?.call(
      articleId,
      chapterId,
    );
    // 截斷的離線檔（在偵測上線前下載的）不可用 → 略過，改走快取/線上重抓。
    if (offline != null &&
        hasRenderableContent(offline) &&
        !looksTruncated(offline)) {
      return _assembler.assemble(
        articleId: articleId,
        chapterId: chapterId,
        chapterName: chapterName,
        content: offline,
      );
    }
    // 1) drift 永久快取。
    final ChapterContentRow? row = await _cacheDao.getChapterContent(
      articleId,
      chapterId,
    );
    if (row != null) {
      // **自癒**：偵測上線前存下的截斷內容已固化在快取裡，使用者重開多少次都是殘缺的。
      // 命中即就地刪除並改走線上重抓，不必等使用者自己去清整個快取。
      //
      // 判定必須用與寫入端**相同**的「只認終端」語意（見 assembledTailLooksTruncated）：
      // 若改成掃整份 payload，中段帶標記的章節會寫得進去卻讀不出來 → 每次開啟都刪快取
      // 重抓，永遠命不中；且掃 payload 連 chapterName 都算，誤判面更大。
      final ChapterText cached = _decode(articleId, chapterId, row.payload);
      if (assembledTailLooksTruncated(cached.text)) {
        await _cacheDao.deleteChapterContent(articleId, chapterId);
      } else {
        return cached;
      }
    }
    final ChapterContent content = await _source.load(url);
    if (!hasRenderableContent(content)) {
      throw ChapterUnavailableException(articleId, chapterId);
    }
    final ChapterText text = _assembler.assemble(
      articleId: articleId,
      chapterId: chapterId,
      chapterName: chapterName,
      content: content,
    );
    // 「非空」不等於「完整」：截斷版帶著數十段真內文，會通過上面的空內容檢查。
    // 必須在 saveChapterContent 之前擋掉，否則殘缺內容永久固化。
    // 但**照樣把已擷取的部分交出去**——擋的是快取，不是使用者的閱讀權（見例外註解）。
    if (looksTruncated(content)) {
      throw ChapterContentTruncatedException(articleId, chapterId, text);
    }
    await _cacheDao.saveChapterContent(
      articleId: articleId,
      chapterId: chapterId,
      payload: _encode(text),
      updatedAt: _now(),
    );
    return text;
  }

  String _encode(ChapterText t) => jsonEncode(<String, dynamic>{
    'name': t.chapterName,
    'text': t.text,
    'images': t.images
        .map(
          (ChapterImage i) =>
              <String, dynamic>{'u': i.url, 'a': i.aspectRatio},
        )
        .toList(),
    'isImage': t.isImage,
    'isbody': t.isbody,
  });

  ChapterText _decode(int articleId, int chapterId, String payload) {
    final Map<String, dynamic> j =
        jsonDecode(payload) as Map<String, dynamic>;
    return ChapterText(
      articleId: articleId,
      chapterId: chapterId,
      chapterName: j['name'] as String? ?? '',
      text: j['text'] as String? ?? '',
      images: (j['images'] as List<dynamic>? ?? const <dynamic>[])
          .map((dynamic e) {
            final Map<String, dynamic> m = e as Map<String, dynamic>;
            return ChapterImage(
              url: m['u'] as String? ?? '',
              aspectRatio: (m['a'] as num?)?.toDouble() ?? 0.0,
            );
          })
          .toList(),
      isImage: j['isImage'] as bool? ?? false,
      isbody: j['isbody'] as int? ?? 0,
    );
  }

  int _now() => _clockMs?.call() ?? DateTime.now().millisecondsSinceEpoch;
}
