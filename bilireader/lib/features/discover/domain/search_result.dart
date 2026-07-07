import 'package:flutter/foundation.dart';

import 'novel_summary.dart';

/// 一頁搜尋結果（規範 §5.0）。[usedSimplifiedFallback] 記錄本次是否用簡體 fallback；
/// [backendQuery] 為實際打後端的查詢字串（繁或簡），供**分頁沿用同一 variant**。
/// UI 仍以使用者輸入的繁體 display query 呈現。
@immutable
class SearchResult {
  const SearchResult({
    required this.items,
    required this.backendQuery,
    required this.usedSimplifiedFallback,
    required this.page,
  });

  final List<NovelSummary> items;
  final String backendQuery;
  final bool usedSimplifiedFallback;
  final int page;
}
