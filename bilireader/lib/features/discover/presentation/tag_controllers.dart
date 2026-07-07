import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/app_error.dart';
import '../data/discover_providers.dart';
import '../data/search_providers.dart';
import '../domain/novel_summary.dart';
import '../domain/ranking_options.dart';
import '../domain/search_result.dart';

part 'tag_controllers.g.dart';

/// 文庫可選標籤（`novel/tags`，已轉繁）。供篩選頁的題材多選來源。
@riverpod
Future<List<String>> filterTags(Ref ref) async =>
    (await ref.watch(bookRepositoryProvider).tags()).dataOrThrow();

/// 字數篩選選項（設計稿 `.fo`：20萬+ / 50萬+）。
enum WordFilter {
  any('不限', null),
  w200k('20萬+', 200000),
  w500k('50萬+', 500000);

  const WordFilter(this.label, this.minWords);

  final String label;
  final int? minWords;
}

/// 文庫篩選畫面狀態（多選題材 + 完結 + 字數 + 排序 + 分頁）。
@immutable
class FilterViewState {
  const FilterViewState({
    this.selectedTags = const <String>{},
    this.fullFlagOnly = false,
    this.wordFilter = WordFilter.any,
    this.sortBy = NovelSortBy.defaultValue,
    this.items = const <NovelSummary>[],
    this.previous,
    this.hasMore = true,
    this.loadingMore = false,
    this.loadMoreError = false,
  });

  final Set<String> selectedTags;
  final bool fullFlagOnly;
  final WordFilter wordFilter;
  final NovelSortBy sortBy;
  final List<NovelSummary> items;
  final SearchResult? previous;
  final bool hasMore;
  final bool loadingMore;

  /// F-15：載入更多失敗（尾端顯示重試而非靜默停止）。
  final bool loadMoreError;

  FilterViewState copyWith({
    Set<String>? selectedTags,
    bool? fullFlagOnly,
    WordFilter? wordFilter,
    NovelSortBy? sortBy,
    List<NovelSummary>? items,
    SearchResult? previous,
    bool? hasMore,
    bool? loadingMore,
    bool? loadMoreError,
  }) => FilterViewState(
    selectedTags: selectedTags ?? this.selectedTags,
    fullFlagOnly: fullFlagOnly ?? this.fullFlagOnly,
    wordFilter: wordFilter ?? this.wordFilter,
    sortBy: sortBy ?? this.sortBy,
    items: items ?? this.items,
    previous: previous ?? this.previous,
    hasMore: hasMore ?? this.hasMore,
    loadingMore: loadingMore ?? this.loadingMore,
    loadMoreError: loadMoreError ?? this.loadMoreError,
  );
}

/// 文庫篩選控制器（doc 09 §10.3）。以 `novel/searchNovel` 帶 `tagNames[]` + 完結/字數/
/// 排序篩選；repository 對題材做繁→簡 fallback（規範 §5.0）。任一條件變更重載第一頁。
@riverpod
class FilterController extends _$FilterController {
  Set<String> _tags = <String>{};
  bool _fullFlagOnly = false;
  WordFilter _word = WordFilter.any;
  NovelSortBy _sortBy = NovelSortBy.defaultValue;
  bool _configured = false;
  CancelToken? _token;

  @override
  AsyncValue<FilterViewState> build() {
    ref.onDispose(() => _token?.cancel('disposed'));
    return const AsyncValue<FilterViewState>.loading();
  }

  /// 由路由帶入的初始題材（僅首次）。
  void configure(String initialTag) {
    if (_configured) {
      return;
    }
    _configured = true;
    if (initialTag.isNotEmpty) {
      _tags = <String>{initialTag};
    }
    _loadFirst();
  }

  void toggleTag(String tag) {
    _tags = <String>{..._tags};
    if (!_tags.remove(tag)) {
      _tags.add(tag);
    }
    _loadFirst();
  }

  void setFullFlagOnly(bool value) {
    if (value == _fullFlagOnly) {
      return;
    }
    _fullFlagOnly = value;
    _loadFirst();
  }

  void setWordFilter(WordFilter value) {
    if (value == _word) {
      return;
    }
    _word = value;
    _loadFirst();
  }

  void setSort(NovelSortBy value) {
    if (value == _sortBy) {
      return;
    }
    _sortBy = value;
    _loadFirst();
  }

  void reload() => _loadFirst();

  FilterViewState get _base => FilterViewState(
    selectedTags: _tags,
    fullFlagOnly: _fullFlagOnly,
    wordFilter: _word,
    sortBy: _sortBy,
  );

  Future<void> _loadFirst() async {
    state = const AsyncValue<FilterViewState>.loading();
    // F-16：條件變更即取消舊查詢，避免舊回應覆蓋新條件的結果。
    _token?.cancel('filter changed');
    final CancelToken token = CancelToken();
    _token = token;
    final ApiResult<SearchResult> result = await ref
        .read(searchRepositoryProvider)
        .filter(
          tags: _tags.toList(),
          fullFlagOnly: _fullFlagOnly,
          minWords: _word.minWords,
          sortBy: _sortBy.value,
          cancelToken: token,
        );
    if (_token != token) {
      return; // 已被更新的條件取代 → 丟棄。
    }
    switch (result) {
      case ApiSuccess<SearchResult>(:final SearchResult data):
        state = AsyncValue<FilterViewState>.data(
          _base.copyWith(
            items: data.items,
            previous: data,
            hasMore: data.items.length >= ApiConstants.searchPageSize,
          ),
        );
      case ApiFailure<SearchResult>(:final error):
        if (error.kind == AppErrorKind.cancelled) {
          return; // F-16：取消靜默（新條件的 loading 已接手）。
        }
        state = AsyncValue<FilterViewState>.error(error, StackTrace.current);
    }
  }

  /// F-14 下拉刷新：重抓第一頁但**保留現有列表**（不進 AsyncLoading，避免整頁閃 loading /
  /// 掉捲動）。僅在已有結果時有效；刷新失敗保留舊資料。
  Future<void> refresh() async {
    final AsyncValue<FilterViewState> current = state;
    if (current is! AsyncData<FilterViewState>) {
      return;
    }
    final CancelToken token = CancelToken();
    _token = token;
    final ApiResult<SearchResult> result = await ref
        .read(searchRepositoryProvider)
        .filter(
          tags: _tags.toList(),
          fullFlagOnly: _fullFlagOnly,
          minWords: _word.minWords,
          sortBy: _sortBy.value,
          cancelToken: token,
        );
    if (_token != token) {
      return;
    }
    switch (result) {
      case ApiSuccess<SearchResult>(:final SearchResult data):
        state = AsyncValue<FilterViewState>.data(
          _base.copyWith(
            items: data.items,
            previous: data,
            hasMore: data.items.length >= ApiConstants.searchPageSize,
          ),
        );
      case ApiFailure<SearchResult>():
        return; // 刷新失敗：保留現有列表，不改動狀態（與 search 一致）。
    }
  }

  Future<void> loadMore() async {
    final AsyncValue<FilterViewState> current = state;
    if (current is! AsyncData<FilterViewState>) {
      return;
    }
    final FilterViewState view = current.value;
    if (!view.hasMore ||
        view.loadingMore ||
        view.loadMoreError ||
        view.previous == null) {
      return;
    }
    await _fetchMore(view);
  }

  /// F-15：載入更多失敗後由尾端「點擊重試」呼叫。
  Future<void> retryLoadMore() async {
    final AsyncValue<FilterViewState> current = state;
    if (current is! AsyncData<FilterViewState>) {
      return;
    }
    final FilterViewState view = current.value;
    if (view.loadingMore || view.previous == null) {
      return;
    }
    await _fetchMore(view.copyWith(loadMoreError: false));
  }

  Future<void> _fetchMore(FilterViewState view) async {
    state = AsyncValue<FilterViewState>.data(
      view.copyWith(loadingMore: true, loadMoreError: false),
    );
    final CancelToken token = _token ??= CancelToken();
    final ApiResult<SearchResult> result = await ref
        .read(searchRepositoryProvider)
        .filter(
          tags: _tags.toList(),
          fullFlagOnly: _fullFlagOnly,
          minWords: _word.minWords,
          sortBy: _sortBy.value,
          page: view.previous!.page + 1,
          previous: view.previous,
          cancelToken: token,
        );
    final AsyncValue<FilterViewState> now = state;
    // 載入期間被 refresh/換條件換掉（items 參照改變）→ 丟棄本次分頁結果（審查發現的競態）。
    // 但須清掉 loadingMore，否則卡在假 loading、分頁死掉（不變量#1）。
    if (now is! AsyncData<FilterViewState> ||
        !identical(now.value.items, view.items)) {
      if (now is AsyncData<FilterViewState> && now.value.loadingMore) {
        state = AsyncValue<FilterViewState>.data(
          now.value.copyWith(loadingMore: false),
        );
      }
      return;
    }
    switch (result) {
      case ApiSuccess<SearchResult>(:final SearchResult data):
        state = AsyncValue<FilterViewState>.data(
          now.value.copyWith(
            items: <NovelSummary>[...now.value.items, ...data.items],
            previous: data,
            hasMore: data.items.length >= ApiConstants.searchPageSize,
            loadingMore: false,
          ),
        );
      case ApiFailure<SearchResult>(:final error):
        if (error.kind == AppErrorKind.cancelled) {
          // 被取消：清掉 loadingMore（避免卡假 loading），不標錯誤（F-16）。
          state = AsyncValue<FilterViewState>.data(
            now.value.copyWith(loadingMore: false),
          );
          return;
        }
        state = AsyncValue<FilterViewState>.data(
          now.value.copyWith(loadingMore: false, loadMoreError: true),
        );
    }
  }
}
