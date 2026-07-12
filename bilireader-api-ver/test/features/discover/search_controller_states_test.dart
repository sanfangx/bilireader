import 'dart:async';

import 'package:bilireader/core/di/infra_providers.dart';
import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/network/app_error.dart';
import 'package:bilireader/features/discover/data/search_providers.dart';
import 'package:bilireader/features/discover/domain/novel_summary.dart';
import 'package:bilireader/features/discover/domain/search_repository.dart';
import 'package:bilireader/features/discover/domain/search_result.dart';
import 'package:bilireader/features/discover/presentation/search_controllers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 可程式化的搜尋 repo：依 search() 呼叫序回傳預設 ApiResult；記錄呼叫。
class _ProgSearchRepo implements SearchRepository {
  _ProgSearchRepo(this._responses);

  final List<ApiResult<SearchResult>> _responses;
  int calls = 0;
  final List<int> pages = <int>[];

  @override
  Future<ApiResult<SearchResult>> search({
    required String query,
    int page = 1,
    SearchResult? previous,
    CancelToken? cancelToken,
  }) async {
    pages.add(page);
    final ApiResult<SearchResult> r = _responses[calls];
    calls++;
    return r;
  }

  @override
  Future<ApiResult<SearchResult>> searchByTag({
    required String tag,
    String? sortBy,
    int page = 1,
    SearchResult? previous,
    CancelToken? cancelToken,
  }) async => throw UnimplementedError();

  @override
  Future<ApiResult<SearchResult>> filter({
    required List<String> tags,
    bool fullFlagOnly = false,
    int? minWords,
    String? sortBy,
    int page = 1,
    SearchResult? previous,
    CancelToken? cancelToken,
  }) async => throw UnimplementedError();
}

SearchResult _page(int n, {int count = 20}) => SearchResult(
  items: List<NovelSummary>.generate(
    count,
    (int i) => NovelSummary(articleId: n * 100 + i, title: '書$n-$i'),
  ),
  backendQuery: 'q',
  usedSimplifiedFallback: false,
  page: n,
);

Future<ProviderContainer> _container(_ProgSearchRepo repo) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final ProviderContainer c = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      searchRepositoryProvider.overrideWithValue(repo),
    ],
  );
  addTearDown(c.dispose);
  c.listen(searchResultsControllerProvider, (_, _) {});
  return c;
}

void main() {
  test(
    'F-15：loadMore 失敗 → loadMoreError（非 hasMore=false）；retry 成功清旗標',
    () async {
      final _ProgSearchRepo repo = _ProgSearchRepo(<ApiResult<SearchResult>>[
        ApiSuccess<SearchResult>(_page(1)), // submit
        const ApiFailure<SearchResult>(
          AppError(kind: AppErrorKind.network, message: '離線'),
        ), // loadMore 失敗
        ApiSuccess<SearchResult>(_page(2)), // retryLoadMore 成功
      ]);
      final ProviderContainer c = await _container(repo);
      final SearchResultsController ctl = c.read(
        searchResultsControllerProvider.notifier,
      );

      await ctl.submit('查詢');
      SearchViewState s = c.read(searchResultsControllerProvider)!.requireValue;
      expect(s.items.length, 20);
      expect(s.hasMore, isTrue);

      await ctl.loadMore();
      s = c.read(searchResultsControllerProvider)!.requireValue;
      expect(s.loadMoreError, isTrue); // 顯示重試，不靜默
      expect(s.hasMore, isTrue); // 仍可續載（非誤判到底）
      expect(s.items.length, 20); // 未追加

      await ctl.retryLoadMore();
      s = c.read(searchResultsControllerProvider)!.requireValue;
      expect(s.loadMoreError, isFalse);
      expect(s.items.length, 40);
    },
  );

  test('F-31：同 query 載入中重複送出 → 只打一次', () async {
    final Completer<ApiResult<SearchResult>> gate =
        Completer<ApiResult<SearchResult>>();
    final _GatedRepo repo = _GatedRepo(gate.future);
    final ProviderContainer c = await _container2(repo);
    final SearchResultsController ctl = c.read(
      searchResultsControllerProvider.notifier,
    );

    final Future<void> first = ctl.submit('阿貓');
    await Future<void>.delayed(Duration.zero);
    final Future<void> dup = ctl.submit('阿貓'); // 載入中重複 → 應忽略
    await dup;
    expect(repo.calls, 1); // 只打一次

    gate.complete(ApiSuccess<SearchResult>(_page(1)));
    await first;
    expect(
      c.read(searchResultsControllerProvider)!.requireValue.items.length,
      20,
    );
  });

  test('F-14：refresh 保留列表、不進 AsyncLoading（不閃 loading）', () async {
    final _ProgSearchRepo repo = _ProgSearchRepo(<ApiResult<SearchResult>>[
      ApiSuccess<SearchResult>(_page(1, count: 5)), // submit
      ApiSuccess<SearchResult>(_page(9, count: 8)), // refresh
    ]);
    final ProviderContainer c = await _container(repo);
    final SearchResultsController ctl = c.read(
      searchResultsControllerProvider.notifier,
    );

    await ctl.submit('查詢');
    expect(
      c.read(searchResultsControllerProvider)!.requireValue.items.length,
      5,
    );

    final Future<void> r = ctl.refresh();
    // refresh 期間不得轉為 AsyncLoading（列表保持可見）。
    expect(c.read(searchResultsControllerProvider), isA<AsyncData<Object?>>());
    await r;
    // 完成後以新結果取代。
    expect(
      c.read(searchResultsControllerProvider)!.requireValue.items.length,
      8,
    );
  });

  test('F-16：被取消的結果不進錯誤態（保持 loading，靜默）', () async {
    final _ProgSearchRepo repo = _ProgSearchRepo(<ApiResult<SearchResult>>[
      const ApiFailure<SearchResult>(
        AppError(kind: AppErrorKind.cancelled, message: ''),
      ),
    ]);
    final ProviderContainer c = await _container(repo);
    final SearchResultsController ctl = c.read(
      searchResultsControllerProvider.notifier,
    );

    await ctl.submit('會被取消');
    // 取消結果靜默 → 不進 error（維持 loading，等新查詢接手）。
    expect(
      c.read(searchResultsControllerProvider),
      isA<AsyncLoading<Object?>>(),
    );
    expect(c.read(searchResultsControllerProvider)!.hasError, isFalse);
  });
}

/// 單一 gated 回應的 repo（測 F-31 併發去重）。
class _GatedRepo implements SearchRepository {
  _GatedRepo(this._future);
  final Future<ApiResult<SearchResult>> _future;
  int calls = 0;

  @override
  Future<ApiResult<SearchResult>> search({
    required String query,
    int page = 1,
    SearchResult? previous,
    CancelToken? cancelToken,
  }) {
    calls++;
    return _future;
  }

  @override
  Future<ApiResult<SearchResult>> searchByTag({
    required String tag,
    String? sortBy,
    int page = 1,
    SearchResult? previous,
    CancelToken? cancelToken,
  }) async => throw UnimplementedError();

  @override
  Future<ApiResult<SearchResult>> filter({
    required List<String> tags,
    bool fullFlagOnly = false,
    int? minWords,
    String? sortBy,
    int page = 1,
    SearchResult? previous,
    CancelToken? cancelToken,
  }) async => throw UnimplementedError();
}

Future<ProviderContainer> _container2(SearchRepository repo) async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final ProviderContainer c = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      searchRepositoryProvider.overrideWithValue(repo),
    ],
  );
  addTearDown(c.dispose);
  c.listen(searchResultsControllerProvider, (_, _) {});
  return c;
}
