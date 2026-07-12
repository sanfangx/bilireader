import 'package:dio/dio.dart';

import '../app_config.dart';
import '../models/novel_summary.dart';
import 'offsite_search.dart';

/// Path B：以 dio 直抓 DuckDuckGo 無 JS HTML 端點做站外搜尋。
/// 免 WebView、不閃、即時，且重用「搜尋引擎 site: 反查書籍」策略。
///
/// 被擋（連線失敗 / 非 200 / anomaly / 非預期頁）→ 丟 [OffsiteSearchBlocked]，
/// 交由呼叫端退到 Path A（WebView，可解 captcha / 用 Google）。
/// 合法 0 筆結果**不**丟例外（回空清單 → 呼叫端顯空態）。
class OffsiteSearchService {
  OffsiteSearchService._();
  static final OffsiteSearchService instance = OffsiteSearchService._();

  /// 專用 dio：**不掛** linovelib 攔截器（限流 / Auth / CF 都是 linovelib 專屬，
  /// 且不可把 linovelib 的 cookie/cf_clearance 帶去第三方 DDG）。只帶瀏覽器 UA。
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 12),
      receiveTimeout: const Duration(seconds: 15),
      followRedirects: true,
      maxRedirects: 3,
      responseType: ResponseType.plain,
      validateStatus: (_) => true,
      headers: {
        'User-Agent': AppConfig.userAgent,
        'Accept':
            'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Language': 'zh-TW,zh;q=0.9,en;q=0.8',
      },
    ),
  );

  Future<List<NovelSummary>> search(String query, {int limit = 25}) async {
    final Response<String> res;
    try {
      res = await _dio.getUri<String>(OffsiteSearch.ddgHtmlUrl(query));
    } catch (e) {
      throw OffsiteSearchBlocked('DDG 連線失敗：$e');
    }
    if ((res.statusCode ?? 0) != 200) {
      throw OffsiteSearchBlocked('DDG HTTP ${res.statusCode}');
    }
    final body = res.data ?? '';
    if (OffsiteSearch.looksBlocked(body)) {
      throw OffsiteSearchBlocked('DDG anomaly/challenge');
    }
    final results = OffsiteSearch.parseResults(body, limit: limit);
    // 0 筆且沒有結果容器 → DDG 回了非預期頁（重導/JS 牆），退 Path A；
    // 有結果容器的 0 筆 = 真的沒這本書 → 回空清單顯空態。
    if (results.isEmpty && !OffsiteSearch.hasResultsContainer(body)) {
      throw OffsiteSearchBlocked('DDG 非預期頁（無結果容器）');
    }
    return results;
  }
}
