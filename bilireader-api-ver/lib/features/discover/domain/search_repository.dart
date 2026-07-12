import 'package:dio/dio.dart';

import '../../../core/network/api_result.dart';
import 'search_result.dart';

/// 小說搜尋 repository 介面（規範 §5.0 fallback）。
///
/// 所有查詢皆可帶 [CancelToken]（UX F-16）：使用者快速換 query/翻頁時，呼叫端取消
/// 舊請求；被取消的結果映為 `AppErrorKind.cancelled`（空訊息，§7.0 靜默），呼叫端
/// 不得將其視為列表錯誤。
abstract interface class SearchRepository {
  /// 搜尋。[query] 為使用者輸入的繁體字串。首頁（[previous] 為 null）會做
  /// 繁→簡 OpenCC fallback；分頁（[previous] 非 null）沿用其 backend query variant。
  Future<ApiResult<SearchResult>> search({
    required String query,
    int page,
    SearchResult? previous,
    CancelToken? cancelToken,
  });

  /// 依標籤篩選（`novel/searchNovel` 帶 `tagName`）。[tag] 為使用者選擇的繁體標籤；
  /// 同樣做繁→簡 OpenCC fallback，[sortBy] 為後端排序值（不轉換）。
  Future<ApiResult<SearchResult>> searchByTag({
    required String tag,
    String? sortBy,
    int page,
    SearchResult? previous,
    CancelToken? cancelToken,
  });

  /// 文庫多條件篩選（`novel/searchNovel` 帶 `tagNames[]` + 完結/字數/排序）。
  /// [tags] 為使用者選擇的繁體標籤（做繁→簡 fallback）；[fullFlagOnly] 僅完結；
  /// [minWords] 最少字數；[sortBy] 後端排序值（皆不轉換）。
  Future<ApiResult<SearchResult>> filter({
    required List<String> tags,
    bool fullFlagOnly,
    int? minWords,
    String? sortBy,
    int page,
    SearchResult? previous,
    CancelToken? cancelToken,
  });
}
