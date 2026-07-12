import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_result.dart';
import '../data/discover_providers.dart';
import '../domain/novel_summary.dart';
import '../domain/ranking_options.dart';

part 'ranking_controllers.g.dart';

/// 榜單畫面狀態（型別 / 週期 / 新書排序 + 分頁累積）。
@immutable
class RankingViewState {
  const RankingViewState({
    required this.type,
    required this.period,
    required this.sort,
    this.items = const <NovelSummary>[],
    this.page = ApiConstants.firstPage,
    this.hasMore = true,
    this.loadingMore = false,
    this.loadMoreError = false,
  });

  final RankingType type;
  final RankingPeriod period;
  final NewBookSort sort;
  final List<NovelSummary> items;
  final int page;
  final bool hasMore;
  final bool loadingMore;

  /// F-15：載入更多失敗（尾端顯示重試而非靜默停止）。
  final bool loadMoreError;

  RankingViewState copyWith({
    RankingType? type,
    RankingPeriod? period,
    NewBookSort? sort,
    List<NovelSummary>? items,
    int? page,
    bool? hasMore,
    bool? loadingMore,
    bool? loadMoreError,
  }) => RankingViewState(
    type: type ?? this.type,
    period: period ?? this.period,
    sort: sort ?? this.sort,
    items: items ?? this.items,
    page: page ?? this.page,
    hasMore: hasMore ?? this.hasMore,
    loadingMore: loadingMore ?? this.loadingMore,
    loadMoreError: loadMoreError ?? this.loadMoreError,
  );
}

/// 榜單控制器（doc 09 §10.2）。切換型別 / 週期 / 排序會重載第一頁；
/// 只在對應型別送出 period（type∈{1,4,6}）或 sort（type==2），其餘不送（doc 11 §5.2）。
@riverpod
class RankingController extends _$RankingController {
  RankingType _type = RankingType.defaultValue;
  RankingPeriod _period = RankingPeriod.defaultValue;
  NewBookSort _sort = NewBookSort.defaultValue;

  bool _configured = false;

  @override
  AsyncValue<RankingViewState> build() =>
      const AsyncValue<RankingViewState>.loading();

  /// 由頁面帶入路由的初始型別；只在首次 configure 時載入，避免重複打第一頁。
  void configure(RankingType type) {
    if (_configured) {
      return;
    }
    _configured = true;
    _type = type;
    _loadFirst();
  }

  void setType(RankingType type) {
    if (type == _type) {
      return;
    }
    _type = type;
    _loadFirst();
  }

  void setPeriod(RankingPeriod period) {
    if (period == _period) {
      return;
    }
    _period = period;
    _loadFirst();
  }

  void setSort(NewBookSort sort) {
    if (sort == _sort) {
      return;
    }
    _sort = sort;
    _loadFirst();
  }

  /// 重試：以目前型別 / 週期 / 排序重載第一頁（錯誤態用）。
  void reload() => _loadFirst();

  /// F-14 下拉刷新：重抓第一頁但**保留現有列表**（不進 AsyncLoading，避免整頁閃 loading /
  /// 掉捲動；RefreshIndicator 自身顯示轉圈）。僅在已有結果時有效；刷新失敗保留舊資料。
  Future<void> refresh() async {
    final AsyncValue<RankingViewState> current = state;
    if (current is! AsyncData<RankingViewState>) {
      return;
    }
    final ApiResult<List<NovelSummary>> result = await _fetch(
      ApiConstants.firstPage,
    );
    switch (result) {
      case ApiSuccess<List<NovelSummary>>(:final List<NovelSummary> data):
        state = AsyncValue<RankingViewState>.data(
          RankingViewState(
            type: _type,
            period: _period,
            sort: _sort,
            items: data,
            hasMore: data.length >= ApiConstants.rankingPageSize,
          ),
        );
      case ApiFailure<List<NovelSummary>>():
        return; // 刷新失敗：保留現有列表，不改動狀態（與 search 一致）。
    }
  }

  /// F-15：載入更多失敗後由尾端「點擊重試」呼叫。
  Future<void> retryLoadMore() async {
    final AsyncValue<RankingViewState> current = state;
    if (current is! AsyncData<RankingViewState>) {
      return;
    }
    final RankingViewState view = current.value;
    if (view.loadingMore || !view.hasMore) {
      return;
    }
    await _fetchMore(view.copyWith(loadMoreError: false));
  }

  Future<void> _loadFirst() async {
    state = const AsyncValue<RankingViewState>.loading();
    final ApiResult<List<NovelSummary>> result = await _fetch(
      ApiConstants.firstPage,
    );
    switch (result) {
      case ApiSuccess<List<NovelSummary>>(:final List<NovelSummary> data):
        state = AsyncValue<RankingViewState>.data(
          RankingViewState(
            type: _type,
            period: _period,
            sort: _sort,
            items: data,
            hasMore: data.length >= ApiConstants.rankingPageSize,
          ),
        );
      case ApiFailure<List<NovelSummary>>(:final error):
        state = AsyncValue<RankingViewState>.error(error, StackTrace.current);
    }
  }

  Future<void> loadMore() async {
    final AsyncValue<RankingViewState> current = state;
    if (current is! AsyncData<RankingViewState>) {
      return;
    }
    final RankingViewState view = current.value;
    if (!view.hasMore || view.loadingMore || view.loadMoreError) {
      return;
    }
    await _fetchMore(view);
  }

  Future<void> _fetchMore(RankingViewState view) async {
    state = AsyncValue<RankingViewState>.data(
      view.copyWith(loadingMore: true, loadMoreError: false),
    );
    final ApiResult<List<NovelSummary>> result = await _fetch(view.page + 1);
    final AsyncValue<RankingViewState> now = state;
    // 載入期間被 refresh/換條件換掉（items 參照改變）→ 丟棄本次分頁結果（審查發現的競態）。
    // 但須清掉 loadingMore，否則卡在假 loading、分頁死掉（不變量#1）。
    if (now is! AsyncData<RankingViewState> ||
        !identical(now.value.items, view.items)) {
      if (now is AsyncData<RankingViewState> && now.value.loadingMore) {
        state = AsyncValue<RankingViewState>.data(
          now.value.copyWith(loadingMore: false),
        );
      }
      return;
    }
    switch (result) {
      case ApiSuccess<List<NovelSummary>>(:final List<NovelSummary> data):
        state = AsyncValue<RankingViewState>.data(
          now.value.copyWith(
            items: <NovelSummary>[...now.value.items, ...data],
            page: now.value.page + 1,
            hasMore: data.length >= ApiConstants.rankingPageSize,
            loadingMore: false,
          ),
        );
      case ApiFailure<List<NovelSummary>>():
        // F-15：失敗 → 標記 loadMoreError（尾端顯示重試），不靜默 hasMore=false。
        state = AsyncValue<RankingViewState>.data(
          now.value.copyWith(loadingMore: false, loadMoreError: true),
        );
    }
  }

  Future<ApiResult<List<NovelSummary>>> _fetch(int page) => ref
      .read(bookRepositoryProvider)
      .ranking(
        type: _type,
        period: _type.showsPeriod ? _period : null,
        sort: _type.showsNewBookSort ? _sort : null,
        page: page,
      );
}
