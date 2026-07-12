import 'package:html/parser.dart' as html_parser;

import '../models/novel_summary.dart';

/// 站外搜尋被搜尋引擎擋下（非 200 / anomaly / 逾時 / 非預期頁）→ 呼叫端據此退到
/// Path A（WebView）。與「合法 0 筆結果」區分：0 筆不丟此例外。
class OffsiteSearchBlocked implements Exception {
  OffsiteSearchBlocked(this.message);
  final String message;
  @override
  String toString() => 'OffsiteSearchBlocked: $message';
}

/// 站外搜尋純邏輯（linovelib 無原生搜尋，改用搜尋引擎 `site:tw.linovelib.com`）。
///
/// 只含 URL 構造 / HTML 解析 / 去重 / 標題清洗 / 封面推導 —— 與網路 I/O 分離，供單元測試。
/// 實地研究（2026-07-12 真實 Chrome）結論：DuckDuckGo 無 JS HTML 端點最穩（免 captcha、
/// 可純 dio 抓）；Google 可用但需 JS（走 Path A WebView）；Bing 直接 captcha 排除。
class OffsiteSearch {
  OffsiteSearch._();

  static const String _site = 'site:tw.linovelib.com';

  /// DuckDuckGo 無 JS HTML 端點（Path B：dio 直抓）。
  static Uri ddgHtmlUrl(String query) => Uri.parse(
    'https://html.duckduckgo.com/html/',
  ).replace(queryParameters: {'q': '$query $_site'});

  /// Google 搜尋（Path A：WebView，需 JS）。
  static Uri googleUrl(String query) => Uri.parse(
    'https://www.google.com/search',
  ).replace(queryParameters: {'q': '$query $_site'});

  /// novelId → 封面相對路徑：`/files/article/image/{id//1000}/{id}/{id}s.jpg`
  /// （JieqiCMS getdir：floor(id/1000) 分片；實測 2013→群組2、4325→群組4）。
  /// 非數字 id 回 null（交由 NetworkCover 顯佔位圖）。
  static String? coverPathForId(String id) {
    final n = int.tryParse(id);
    if (n == null || n < 0) return null;
    return '/files/article/image/${n ~/ 1000}/$n/${n}s.jpg';
  }

  /// 清洗搜尋結果標題：
  /// - 切掉第一個底線之後的中繼資料（DDG 標題如「書名_作者作品_文庫_嗶哩輕小說」）。
  /// - 去尾綴「(小說)線上看」（Google/DDG 標題常見）。
  static String cleanTitle(String raw) {
    var t = raw.trim();
    final us = t.indexOf('_');
    if (us > 0) t = t.substring(0, us).trim();
    t = t.replaceFirst(RegExp(r'(小說)?線上看$'), '').trim();
    return t;
  }

  /// 由 novelId + 原始標題組出 [NovelSummary]（供 DDG 解析與 WebView 擷取共用）。
  static NovelSummary summaryFor(String id, String rawTitle) => NovelSummary(
    id: id,
    title: cleanTitle(rawTitle),
    coverPath: coverPathForId(id),
  );

  // 從 href 抓 novelId：相容直接連結 `/novel/123` 與 DDG url-encoded `novel%2F123`。
  static final RegExp _novelId = RegExp(r'novel(?:/|%2F|%2f)(\d+)');
  // anchor 文字若「本身就是連結」→ 是顯示 URL 的 anchor，非書名，跳過。
  static final RegExp _looksLikeUrl = RegExp(
    r'linovelib\.com|https?://',
    caseSensitive: false,
  );

  /// 從搜尋結果頁 HTML 解析書籍清單（依 novelId 去重、保留相關性順序）。
  ///
  /// 選擇器無關（掃全部 `<a>`）以抗引擎改版：
  /// - href 抓 novelId（相容 DDG 的 `//duckduckgo.com/l/?uddg=...%2Fnovel%2F{id}...`）。
  /// - 同一本書會以 `.html`/`/catalog`/`/vol_x`/章節等多變體出現 → 依 id 去重。
  /// - 跳過文字是 URL 的 anchor（DDG 每筆另有顯示 URL 的 anchor，非書名）與空文字。
  static List<NovelSummary> parseResults(String htmlStr, {int limit = 25}) {
    final doc = html_parser.parse(htmlStr);
    final out = <NovelSummary>[];
    final seen = <String>{};
    for (final a in doc.querySelectorAll('a')) {
      final raw = a.attributes['href'] ?? '';
      final m = _novelId.firstMatch(raw);
      if (m == null) continue;
      final id = m.group(1)!;
      if (seen.contains(id)) continue;
      final text = a.text.trim();
      if (text.isEmpty || _looksLikeUrl.hasMatch(text)) continue;
      final title = cleanTitle(text);
      if (title.isEmpty) continue;
      seen.add(id);
      out.add(summaryFor(id, text));
      if (out.length >= limit) break;
    }
    return out;
  }

  /// DDG 是否回了「被擋 / 非預期頁」（anomaly、空 body）。與合法 0 筆結果區分。
  static bool looksBlocked(String body) {
    if (body.trim().isEmpty) return true;
    return body.contains('anomaly-modal') ||
        body.contains('Unfortunately, bots use DuckDuckGo too') ||
        body.contains('If this error persists');
  }

  /// body 是否為「真的搜尋結果頁」（含結果容器或明確的無結果標記）。
  /// 用來區分「DDG 正常回頁但 0 筆（→ 顯空態）」與「DDG 回了非預期頁（→ 退 Path A）」。
  static bool hasResultsContainer(String body) =>
      body.contains('result__a') ||
      body.contains('results_links') ||
      body.contains('result__body') ||
      body.contains('No results') ||
      body.contains('沒有找到');
}
