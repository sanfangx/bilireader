import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/di/infra_providers.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/app_error.dart';
import '../data/discover_providers.dart';
import '../data/search_providers.dart';
import '../domain/novel_summary.dart';
import '../domain/search_result.dart';

part 'search_controllers.g.dart';

/// 熱門搜尋關鍵字（`novel/hotSearch`，已轉繁）。
@riverpod
Future<List<String>> hotSearchKeywords(Ref ref) async =>
    (await ref.watch(bookRepositoryProvider).hotSearch()).dataOrThrow();

/// 搜尋歷史一筆：查詢字串 + 更新時間戳（F-34，epoch ms）。本機保存（SharedPreferences，非 API）。
typedef SearchHistoryEntry = ({String query, int updatedAt});

/// 以繁體保存使用者輸入；最多 [_maxHistory] 筆，最新在前。
///
/// F-34：改以 JSON 保存 `updatedAt` 時間戳（供日後「最近優先」以外的整理）；state 仍暴露
/// 查詢字串清單（UI 視覺零變化）。舊版 `List<String>` 自動遷移（updatedAt 補 0）。
@riverpod
class SearchHistory extends _$SearchHistory {
  static const String _keyV2 = 'search_history_v2'; // JSON: [{q,t}]
  static const String _keyLegacy = 'search_history'; // 舊版 List<String>
  static const int _maxHistory = 10;

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  List<String> build() => _loadEntries(
    ref.watch(sharedPreferencesProvider),
  ).map((SearchHistoryEntry e) => e.query).toList();

  /// 讀出歷史（新版 JSON 優先；缺則遷移舊版 `List<String>`，updatedAt 補 0）。最新在前、上限 [_maxHistory]。
  List<SearchHistoryEntry> _loadEntries(SharedPreferences prefs) {
    final String? raw = prefs.getString(_keyV2);
    if (raw != null && raw.isNotEmpty) {
      try {
        final Object? decoded = jsonDecode(raw);
        if (decoded is List) {
          return decoded
              .whereType<Map<String, Object?>>()
              .map(
                (Map<String, Object?> m) => (
                  query: (m['q'] as String?) ?? '',
                  updatedAt: (m['t'] as num?)?.toInt() ?? 0,
                ),
              )
              .where((SearchHistoryEntry e) => e.query.isNotEmpty)
              .take(_maxHistory)
              .toList();
        }
      } on Object {
        // 壞資料 → 當空清單，不阻斷。
      }
      return const <SearchHistoryEntry>[];
    }
    // 遷移：舊版 List<String>（時間未知 → updatedAt=0）。
    final List<String>? legacy = prefs.getStringList(_keyLegacy);
    if (legacy == null) return const <SearchHistoryEntry>[];
    return legacy
        .where((String q) => q.isNotEmpty)
        .take(_maxHistory)
        .map((String q) => (query: q, updatedAt: 0))
        .toList();
  }

  Future<void> _persist(List<SearchHistoryEntry> entries) async {
    final String json = jsonEncode(
      entries
          .map(
            (SearchHistoryEntry e) => <String, Object?>{
              'q': e.query,
              't': e.updatedAt,
            },
          )
          .toList(),
    );
    await _prefs.setString(_keyV2, json);
    await _prefs.remove(_keyLegacy); // 遷移完成，清舊鍵。
    state = entries.map((SearchHistoryEntry e) => e.query).toList();
  }

  Future<void> add(String query) async {
    final String q = query.trim();
    if (q.isEmpty) {
      return;
    }
    final int now = DateTime.now().millisecondsSinceEpoch;
    final List<SearchHistoryEntry> next = <SearchHistoryEntry>[
      (query: q, updatedAt: now),
      ..._loadEntries(_prefs).where((SearchHistoryEntry e) => e.query != q),
    ].take(_maxHistory).toList();
    await _persist(next);
  }

  Future<void> remove(String query) async {
    final List<SearchHistoryEntry> next = _loadEntries(
      _prefs,
    ).where((SearchHistoryEntry e) => e.query != query).toList();
    await _persist(next);
  }

  /// F-34：讀目前歷史的時間戳（供日後排序/顯示；UI 目前未用）。
  List<SearchHistoryEntry> entries() => _loadEntries(_prefs);

  Future<void> clear() async {
    await _prefs.remove(_keyV2);
    await _prefs.remove(_keyLegacy);
    state = const <String>[];
  }
}

/// 搜尋結果分頁狀態（規範 §5.0 fallback 由 repository 處理；此處管理分頁與載入態）。
@immutable
class SearchViewState {
  const SearchViewState({
    required this.query,
    this.items = const <NovelSummary>[],
    this.previous,
    this.hasMore = true,
    this.loadingMore = false,
    this.loadMoreError = false,
  });

  final String query;
  final List<NovelSummary> items;

  /// 上一頁成功結果（供分頁沿用同一 backend variant，規範 §5.0）。
  final SearchResult? previous;
  final bool hasMore;
  final bool loadingMore;

  /// F-15：載入更多失敗（非取消）。true → 列表尾端顯示「載入失敗，點擊重試」而非
  /// 靜默停止；重試由 [SearchResultsController.retryLoadMore] 清旗標後重抓。
  final bool loadMoreError;

  SearchViewState copyWith({
    List<NovelSummary>? items,
    SearchResult? previous,
    bool? hasMore,
    bool? loadingMore,
    bool? loadMoreError,
  }) => SearchViewState(
    query: query,
    items: items ?? this.items,
    previous: previous ?? this.previous,
    hasMore: hasMore ?? this.hasMore,
    loadingMore: loadingMore ?? this.loadingMore,
    loadMoreError: loadMoreError ?? this.loadMoreError,
  );
}

/// 搜尋結果控制器：`submit` 打第一頁（含繁→簡 fallback），`loadMore` 沿用 variant。
///
/// F-16：每次 `submit` 以 [CancelToken] 取消尚在飛行的舊查詢，避免快速換 query 時
/// 舊回應覆蓋新狀態；被取消的結果（`AppErrorKind.cancelled`，§7.0 靜默）不進錯誤態。
/// F-31：同一 query 已在載入中則忽略重複送出。
@riverpod
class SearchResultsController extends _$SearchResultsController {
  CancelToken? _token;

  @override
  AsyncValue<SearchViewState>? build() {
    ref.onDispose(() => _token?.cancel('disposed'));
    return null;
  }

  Future<void> submit(String query) async {
    final String q = query.trim();
    if (q.isEmpty) {
      _token?.cancel('cleared');
      _token = null;
      state = null;
      return;
    }
    // F-31：同 query 正在載入 → 忽略重複送出（下拉刷新從 data 態觸發，不受此擋）。
    final AsyncValue<SearchViewState>? cur = state;
    if (cur is AsyncLoading<SearchViewState> && _inFlightQuery == q) {
      return;
    }
    // F-16：取消舊查詢、換新 token。
    _token?.cancel('new query');
    final CancelToken token = CancelToken();
    _token = token;
    _inFlightQuery = q;

    state = const AsyncValue<SearchViewState>.loading();
    await ref.read(searchHistoryProvider.notifier).add(q);
    final ApiResult<SearchResult> result = await ref
        .read(searchRepositoryProvider)
        .search(query: q, cancelToken: token);
    // 已被更新的查詢取代 → 丟棄本次結果（避免舊回應覆蓋新狀態）。
    if (_token != token) {
      return;
    }
    switch (result) {
      case ApiSuccess<SearchResult>(:final SearchResult data):
        state = AsyncValue<SearchViewState>.data(
          SearchViewState(
            query: q,
            items: data.items,
            previous: data,
            hasMore: data.items.length >= ApiConstants.searchPageSize,
          ),
        );
      case ApiFailure<SearchResult>(:final error):
        // F-16：取消為靜默——不進錯誤態（新查詢的 loading 已接手）。
        if (error.kind == AppErrorKind.cancelled) {
          return;
        }
        state = AsyncValue<SearchViewState>.error(error, StackTrace.current);
    }
  }

  String? _inFlightQuery;

  /// F-14 下拉刷新：重抓當前 query 第一頁但**保留現有列表**——不進 AsyncLoading（否則
  /// `.when(loading:)` 會用整頁 spinner 蓋掉列表、掉捲動，違反不變量#1；RefreshIndicator
  /// 自身已顯示轉圈）。僅在已有結果（AsyncData）時有效；刷新失敗保留舊資料。
  Future<void> refresh() async {
    final AsyncValue<SearchViewState>? current = state;
    if (current is! AsyncData<SearchViewState>) {
      return;
    }
    final SearchViewState view = current.value;
    _token?.cancel('refresh');
    final CancelToken token = CancelToken();
    _token = token;
    _inFlightQuery = view.query;
    final ApiResult<SearchResult> result = await ref
        .read(searchRepositoryProvider)
        .search(query: view.query, cancelToken: token);
    if (_token != token) {
      return;
    }
    switch (result) {
      case ApiSuccess<SearchResult>(:final SearchResult data):
        state = AsyncValue<SearchViewState>.data(
          SearchViewState(
            query: view.query,
            items: data.items,
            previous: data,
            hasMore: data.items.length >= ApiConstants.searchPageSize,
          ),
        );
      case ApiFailure<SearchResult>():
        // 取消或失敗：保留現有列表，不覆蓋為錯誤頁（不變量#1）。
        return;
    }
  }

  Future<void> loadMore() async {
    final AsyncValue<SearchViewState>? current = state;
    if (current is! AsyncData<SearchViewState>) {
      return;
    }
    final SearchViewState view = current.value;
    // 有錯誤時不自動重抓（等使用者點重試）；其餘守門同前。
    if (!view.hasMore ||
        view.loadingMore ||
        view.loadMoreError ||
        view.previous == null) {
      return;
    }
    await _fetchMore(view);
  }

  /// F-15：載入更多失敗後由列表尾端「點擊重試」呼叫。
  Future<void> retryLoadMore() async {
    final AsyncValue<SearchViewState>? current = state;
    if (current is! AsyncData<SearchViewState>) {
      return;
    }
    final SearchViewState view = current.value;
    if (view.loadingMore || view.previous == null) {
      return;
    }
    await _fetchMore(view.copyWith(loadMoreError: false));
  }

  Future<void> _fetchMore(SearchViewState view) async {
    state = AsyncValue<SearchViewState>.data(
      view.copyWith(loadingMore: true, loadMoreError: false),
    );
    final CancelToken token = _token ??= CancelToken();
    final ApiResult<SearchResult> result = await ref
        .read(searchRepositoryProvider)
        .search(
          query: view.query,
          page: view.previous!.page + 1,
          previous: view.previous,
          cancelToken: token,
        );
    final AsyncValue<SearchViewState>? now = state;
    if (now is! AsyncData<SearchViewState>) {
      return; // 已被新查詢取代（loading/error）→ 不覆蓋。
    }
    // 若列表在載入期間被 refresh/新查詢換掉（items 參照改變），丟棄本次分頁結果，
    // 避免把舊查詢的第 N 頁併到新列表造成錯亂（審查發現的競態）。
    // 但須清掉 loadingMore，否則卡在假 loading、分頁死掉（不變量#1）。
    if (!identical(now.value.items, view.items)) {
      if (now.value.loadingMore) {
        state = AsyncValue<SearchViewState>.data(
          now.value.copyWith(loadingMore: false),
        );
      }
      return;
    }
    switch (result) {
      case ApiSuccess<SearchResult>(:final SearchResult data):
        state = AsyncValue<SearchViewState>.data(
          now.value.copyWith(
            items: <NovelSummary>[...now.value.items, ...data.items],
            previous: data,
            hasMore: data.items.length >= ApiConstants.searchPageSize,
            loadingMore: false,
          ),
        );
      case ApiFailure<SearchResult>(:final error):
        if (error.kind == AppErrorKind.cancelled) {
          // 被新查詢取消：靜默，但清掉 loadingMore（避免卡假 loading）。
          state = AsyncValue<SearchViewState>.data(
            now.value.copyWith(loadingMore: false),
          );
          return;
        }
        // F-15：失敗 → 標記 loadMoreError（尾端顯示重試），不靜默停止。
        state = AsyncValue<SearchViewState>.data(
          now.value.copyWith(loadingMore: false, loadMoreError: true),
        );
    }
  }
}
