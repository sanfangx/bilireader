import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/app_error.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/storage/in_flight_deduper.dart';
import '../../../core/storage/ttl_memory_cache.dart';
import '../../../core/text/chinese_converter.dart';
import '../domain/book_repository.dart';
import '../domain/carousel_slide.dart';
import '../domain/novel_summary.dart';
import '../domain/ranking_options.dart';
import 'book_remote_data_source.dart';
import 'novel_mapper.dart';

/// [BookRepository] 實作：呼叫 [BookRemoteDataSource]，以 [NovelMapper] 轉繁映射，
/// 並套用 10 分鐘記憶體快取（規範 §7.5，對應原生 `Cached*`）。詳情另做 in-flight dedupe。
class BookRepositoryImpl implements BookRepository {
  BookRepositoryImpl({
    required BookRemoteDataSource remote,
    required ChineseConverter converter,
    int Function()? clockMs,
  }) : _remote = remote,
       _mapper = NovelMapper(converter),
       _converter = converter,
       _clockMs = clockMs;

  final BookRemoteDataSource _remote;
  final NovelMapper _mapper;
  final ChineseConverter _converter;
  final int Function()? _clockMs;

  final TtlMemoryCache<String, List<CarouselSlide>> _carouselCache =
      TtlMemoryCache<String, List<CarouselSlide>>(
        ttlMs: ApiConstants.readCacheTtlMs,
      );
  final TtlMemoryCache<String, List<NovelSummary>> _listCache =
      TtlMemoryCache<String, List<NovelSummary>>(
        ttlMs: ApiConstants.readCacheTtlMs,
      );
  final TtlMemoryCache<int, NovelSummary> _detailCache =
      TtlMemoryCache<int, NovelSummary>(ttlMs: ApiConstants.readCacheTtlMs);
  final TtlMemoryCache<String, List<String>> _stringCache =
      TtlMemoryCache<String, List<String>>(ttlMs: ApiConstants.readCacheTtlMs);
  final InFlightDeduper<int, NovelSummary> _detailDedupe =
      InFlightDeduper<int, NovelSummary>();

  @override
  Future<ApiResult<List<CarouselSlide>>> carousel() => _guard(() async {
    final List<CarouselSlide>? cached = _carouselCache.get(
      'carousel',
      nowMs: _now(),
    );
    if (cached != null) {
      return cached;
    }
    final List<CarouselSlide> slides = (await _remote.carousel())
        .map(_mapper.toCarouselSlide)
        .toList();
    _carouselCache.put('carousel', slides, nowMs: _now());
    return slides;
  });

  @override
  Future<ApiResult<List<NovelSummary>>> ranking({
    required RankingType type,
    RankingPeriod? period,
    NewBookSort? sort,
    int page = ApiConstants.firstPage,
    int limit = ApiConstants.rankingPageSize,
  }) {
    final String key =
        'ranking|${type.value}|${period?.value}|${sort?.value}|$page|$limit';
    return _guardList(
      key,
      () => _remote.ranking(
        type: type,
        period: period,
        sort: sort,
        page: page,
        limit: limit,
      ),
    );
  }

  @override
  Future<ApiResult<List<NovelSummary>>> weekHot({
    int page = ApiConstants.firstPage,
    int limit = ApiConstants.homeSectionLimit,
  }) => _guardList(
    'weekhot|$page|$limit',
    () => _remote.weekHot(page: page, limit: limit),
  );

  @override
  Future<ApiResult<NovelSummary>> novelDetail(
    int articleId, {
    bool countVisit = true,
  }) => _guard(() async {
    final NovelSummary? cached = _detailCache.get(articleId, nowMs: _now());
    if (cached != null) {
      return cached;
    }
    final NovelSummary detail = await _detailDedupe.run(
      articleId,
      () async => _mapper.toSummary(
        await _remote.novelInfo(articleId, countVisit: countVisit),
      ),
    );
    _detailCache.put(articleId, detail, nowMs: _now());
    return detail;
  });

  @override
  Future<ApiResult<List<NovelSummary>>> sameAuthor(int articleId) =>
      _guardList('sameAuthor|$articleId', () => _remote.sameAuthor(articleId));

  @override
  Future<ApiResult<List<NovelSummary>>> sameTranslator(int articleId) =>
      _guardList(
        'sameTranslator|$articleId',
        () => _remote.sameTranslator(articleId),
      );

  @override
  Future<ApiResult<List<NovelSummary>>> alsoReading(int articleId) =>
      _guardList(
        'alsoReading|$articleId',
        () => _remote.alsoReading(articleId),
      );

  @override
  Future<ApiResult<List<String>>> hotSearch({
    int limit = ApiConstants.hotSearchLimit,
  }) => _guard(() async {
    final String key = 'hotSearch|$limit';
    final List<String>? cached = _stringCache.get(key, nowMs: _now());
    if (cached != null) {
      return cached;
    }
    final List<String> words = _mapper.toTwList(
      await _remote.hotSearch(limit: limit),
    );
    _stringCache.put(key, words, nowMs: _now());
    return words;
  });

  @override
  Future<ApiResult<List<String>>> tags() => _guard(() async {
    final List<String>? cached = _stringCache.get('tags', nowMs: _now());
    if (cached != null) {
      return cached;
    }
    final List<String> tags = _mapper.toTwList(await _remote.tags());
    _stringCache.put('tags', tags, nowMs: _now());
    return tags;
  });

  /// 清單型端點共用：快取 → 呼叫 → 轉繁映射 → 快取。
  Future<ApiResult<List<NovelSummary>>> _guardList(
    String cacheKey,
    Future<List<dynamic>> Function() fetch,
  ) => _guard(() async {
    final List<NovelSummary>? cached = _listCache.get(cacheKey, nowMs: _now());
    if (cached != null) {
      return cached;
    }
    final List<NovelSummary> items = _mapper.toSummaries(
      (await fetch()).cast(),
    );
    _listCache.put(cacheKey, items, nowMs: _now());
    return items;
  });

  Future<ApiResult<T>> _guard<T>(Future<T> Function() body) async {
    try {
      await _converter.ensureLoaded();
      return ApiSuccess<T>(await body());
    } on DioException catch (e) {
      return ApiFailure<T>(ErrorMapper.fromDio(e));
    } on AppError catch (e) {
      return ApiFailure<T>(e);
    } on Object catch (e) {
      // 解析等非預期錯誤：分類為 parse，不讓 raw error 流入 UI（規範 §7.2）。
      return ApiFailure<T>(ErrorMapper.parse(e));
    }
  }

  int _now() => _clockMs?.call() ?? DateTime.now().millisecondsSinceEpoch;
}
