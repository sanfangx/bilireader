import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/app_error.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/storage/ttl_memory_cache.dart';
import '../../../core/text/chinese_converter.dart';
import '../domain/novel_summary.dart';
import '../domain/search_repository.dart';
import '../domain/search_result.dart';
import 'novel_mapper.dart';
import 'search_remote_data_source.dart';

/// 後端查詢文字條件的種類：關鍵字（searchKey）或標籤（tagName）。
enum _QueryKind { keyword, tag }

/// [SearchRepository] 實作，含 §5.0 OpenCC 搜尋 fallback（關鍵字與標籤共用）：
/// 1. 先用繁體文字條件打後端。
/// 2. 若成功但結果為空，且繁→簡有變化，則以簡體條件自動 fallback 重試**一次**。
/// 3. 分頁沿用先前成功的 backend variant（不重做 fallback）。
/// 4. 只轉換文字查詢欄位（searchKey / tagName），不轉 page/pageSize/sortBy；
///    結果顯示欄位轉回繁體。
/// 5. 快取 key 以「種類 + backend variant + sortBy + page」區分，避免互相覆蓋。
/// 6. 不記錄使用者完整搜尋字串（無 log）。
class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl({
    required SearchRemoteDataSource remote,
    required ChineseConverter converter,
    TtlMemoryCache<String, SearchResult>? cache,
    int Function()? clockMs,
  }) : _remote = remote,
       _converter = converter,
       _mapper = NovelMapper(converter),
       _cache =
           cache ??
           TtlMemoryCache<String, SearchResult>(
             ttlMs: ApiConstants.readCacheTtlMs,
           ),
       _clockMs = clockMs;

  final SearchRemoteDataSource _remote;
  final ChineseConverter _converter;
  final NovelMapper _mapper;
  final TtlMemoryCache<String, SearchResult> _cache;
  final int Function()? _clockMs;

  @override
  Future<ApiResult<SearchResult>> search({
    required String query,
    int page = 1,
    SearchResult? previous,
    CancelToken? cancelToken,
  }) => _runWithFallback(
    text: query,
    kind: _QueryKind.keyword,
    page: page,
    previous: previous,
    cancelToken: cancelToken,
  );

  @override
  Future<ApiResult<SearchResult>> searchByTag({
    required String tag,
    String? sortBy,
    int page = 1,
    SearchResult? previous,
    CancelToken? cancelToken,
  }) => _runWithFallback(
    text: tag,
    kind: _QueryKind.tag,
    sortBy: sortBy,
    page: page,
    previous: previous,
    cancelToken: cancelToken,
  );

  @override
  Future<ApiResult<SearchResult>> filter({
    required List<String> tags,
    bool fullFlagOnly = false,
    int? minWords,
    String? sortBy,
    int page = 1,
    SearchResult? previous,
    CancelToken? cancelToken,
  }) async {
    try {
      await _converter.ensureLoaded();
      final int? fullFlag = fullFlagOnly ? 1 : null;

      Future<SearchResult> fetch(List<String> backendTags, bool simplified) =>
          _filterFetch(
            tags: backendTags,
            fullFlag: fullFlag,
            minWords: minWords,
            sortBy: sortBy,
            page: page,
            usedSimplifiedFallback: simplified,
            cancelToken: cancelToken,
          );

      // 分頁：沿用先前成功的 variant（繁 or 簡）。
      if (previous != null) {
        final List<String> backend = previous.usedSimplifiedFallback
            ? tags.map(_converter.toSimplified).toList()
            : tags;
        return ApiSuccess<SearchResult>(
          await fetch(backend, previous.usedSimplifiedFallback),
        );
      }

      // 首次：先繁體標籤。
      final SearchResult tc = await fetch(tags, false);
      // 無文字條件（純狀態/字數）或已有結果 → 不做 fallback。
      if (tags.isEmpty || tc.items.isNotEmpty) {
        return ApiSuccess<SearchResult>(tc);
      }
      final List<String> simp = tags.map(_converter.toSimplified).toList();
      if (_sameList(simp, tags)) {
        return ApiSuccess<SearchResult>(tc);
      }
      return ApiSuccess<SearchResult>(await fetch(simp, true));
    } on DioException catch (e) {
      return ApiFailure<SearchResult>(ErrorMapper.fromDio(e));
    } on AppError catch (e) {
      return ApiFailure<SearchResult>(e);
    } on Object catch (e) {
      return ApiFailure<SearchResult>(ErrorMapper.parse(e));
    }
  }

  Future<SearchResult> _filterFetch({
    required List<String> tags,
    required int? fullFlag,
    required int? minWords,
    required String? sortBy,
    required int page,
    required bool usedSimplifiedFallback,
    CancelToken? cancelToken,
  }) async {
    final String cacheKey =
        'filter|${tags.join(",")}|$fullFlag|$minWords|${sortBy ?? ''}|$page';
    final SearchResult? cached = _cache.get(cacheKey, nowMs: _now());
    if (cached != null) {
      return cached;
    }
    final List<NovelSummary> items = _mapper.toSummaries(
      await _remote.filterNovel(
        tagNames: tags,
        filterFullFlag: fullFlag,
        minWords: minWords,
        sortBy: sortBy,
        pageNum: page,
        cancelToken: cancelToken,
      ),
    );
    final SearchResult result = SearchResult(
      items: items,
      backendQuery: tags.join(','),
      usedSimplifiedFallback: usedSimplifiedFallback,
      page: page,
    );
    _cache.put(cacheKey, result, nowMs: _now());
    return result;
  }

  static bool _sameList(List<String> a, List<String> b) {
    if (a.length != b.length) {
      return false;
    }
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }

  /// 繁→簡 fallback 通用流程（規範 §5.0）。
  Future<ApiResult<SearchResult>> _runWithFallback({
    required String text,
    required _QueryKind kind,
    String? sortBy,
    required int page,
    SearchResult? previous,
    CancelToken? cancelToken,
  }) async {
    try {
      await _converter.ensureLoaded();

      // 分頁：沿用先前成功的 backend variant，不重做 fallback。
      if (previous != null) {
        final SearchResult r = await _fetch(
          kind: kind,
          backendText: previous.backendQuery,
          sortBy: sortBy,
          page: page,
          usedSimplifiedFallback: previous.usedSimplifiedFallback,
          cancelToken: cancelToken,
        );
        return ApiSuccess<SearchResult>(r);
      }

      // 首次：先繁體條件。
      final SearchResult tc = await _fetch(
        kind: kind,
        backendText: text,
        sortBy: sortBy,
        page: page,
        usedSimplifiedFallback: false,
        cancelToken: cancelToken,
      );
      if (tc.items.isNotEmpty) {
        return ApiSuccess<SearchResult>(tc);
      }

      // 空結果 → 繁→簡 fallback（最多一次）。
      final String simplified = _converter.toSimplified(text);
      if (simplified == text) {
        return ApiSuccess<SearchResult>(tc);
      }
      final SearchResult fb = await _fetch(
        kind: kind,
        backendText: simplified,
        sortBy: sortBy,
        page: page,
        usedSimplifiedFallback: true,
        cancelToken: cancelToken,
      );
      return ApiSuccess<SearchResult>(fb);
    } on DioException catch (e) {
      return ApiFailure<SearchResult>(ErrorMapper.fromDio(e));
    } on AppError catch (e) {
      return ApiFailure<SearchResult>(e);
    } on Object catch (e) {
      return ApiFailure<SearchResult>(ErrorMapper.parse(e));
    }
  }

  Future<SearchResult> _fetch({
    required _QueryKind kind,
    required String backendText,
    String? sortBy,
    required int page,
    required bool usedSimplifiedFallback,
    CancelToken? cancelToken,
  }) async {
    final String cacheKey = '${kind.name}|$backendText|${sortBy ?? ''}|$page';
    final SearchResult? cached = _cache.get(cacheKey, nowMs: _now());
    if (cached != null) {
      return cached;
    }

    final List<NovelSummary> items = _mapper.toSummaries(switch (kind) {
      _QueryKind.keyword => await _remote.searchNovel(
        searchKey: backendText,
        pageNum: page,
        cancelToken: cancelToken,
      ),
      _QueryKind.tag => await _remote.searchByTag(
        tagName: backendText,
        sortBy: sortBy,
        pageNum: page,
        cancelToken: cancelToken,
      ),
    });
    final SearchResult result = SearchResult(
      items: items,
      backendQuery: backendText,
      usedSimplifiedFallback: usedSimplifiedFallback,
      page: page,
    );
    _cache.put(cacheKey, result, nowMs: _now());
    return result;
  }

  int _now() => _clockMs?.call() ?? DateTime.now().millisecondsSinceEpoch;
}
