import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/base_response.dart';
import '../../../core/network/error_mapper.dart';
import '../domain/ranking_options.dart';
import 'dto/carousel_item.dart';
import 'dto/novel_response_entity.dart';

/// 書城首頁 / 榜單 / 詳情 / 推薦 / 熱門詞 / 標籤端點（BookApiService，API.md §8.2）。
/// 幾乎全為 POST；清單端點 `data == null` 視為空清單（非錯誤），
/// 單一物件端點 `data == null` 才視為「數據為空」錯誤（規範 §7.0）。
class BookRemoteDataSource {
  const BookRemoteDataSource(this._dio);

  final Dio _dio;

  /// `novel/getCarousel`（無參數）。
  Future<List<CarouselItem>> carousel() async {
    final Response<dynamic> resp = await _dio.post<dynamic>(ApiPaths.carousel);
    return _unwrapList(resp, CarouselItem.fromJson);
  }

  /// `novel/getRanking`（Body page/limit/type/period?/sort?）。
  Future<List<NovelResponseEntity>> ranking({
    required RankingType type,
    RankingPeriod? period,
    NewBookSort? sort,
    int page = ApiConstants.firstPage,
    int limit = ApiConstants.rankingPageSize,
  }) async {
    final Map<String, dynamic> body = <String, dynamic>{
      'page': page,
      'limit': limit,
      'type': type.value,
      if (period != null) 'period': period.value,
      if (sort != null) 'sort': sort.value,
    };
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.ranking,
      data: body,
    );
    return _unwrapList(resp, NovelResponseEntity.fromJson);
  }

  /// `novel/getweekhot`（Body page/limit）。
  Future<List<NovelResponseEntity>> weekHot({
    int page = ApiConstants.firstPage,
    int limit = ApiConstants.homeSectionLimit,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.weekHot,
      data: <String, dynamic>{'page': page, 'limit': limit},
    );
    return _unwrapList(resp, NovelResponseEntity.fromJson);
  }

  /// `novel/getNovelInfo`（Body articleid + query countVisit）。
  Future<NovelResponseEntity> novelInfo(
    int articleId, {
    bool countVisit = true,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.novelInfo,
      queryParameters: countVisit ? <String, dynamic>{'countVisit': 1} : null,
      data: <String, dynamic>{'articleid': articleId},
    );
    return _unwrapObject(resp, NovelResponseEntity.fromJson);
  }

  /// `novel/sameAuthor`（Body articleid）。
  Future<List<NovelResponseEntity>> sameAuthor(int articleId) =>
      _articleList(ApiPaths.sameAuthor, articleId);

  /// `novel/sameTranslator`（Body articleid）。
  Future<List<NovelResponseEntity>> sameTranslator(int articleId) =>
      _articleList(ApiPaths.sameTranslator, articleId);

  /// `novel/alsoReading`（Body articleid）。
  Future<List<NovelResponseEntity>> alsoReading(int articleId) =>
      _articleList(ApiPaths.alsoReading, articleId);

  /// `novel/hotSearch`（Query limit）。
  Future<List<String>> hotSearch({
    int limit = ApiConstants.hotSearchLimit,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.hotSearch,
      queryParameters: <String, dynamic>{'limit': limit},
    );
    return _unwrapStringList(resp);
  }

  /// `novel/tags`（無參數）。
  Future<List<String>> tags() async {
    final Response<dynamic> resp = await _dio.post<dynamic>(ApiPaths.novelTags);
    return _unwrapStringList(resp);
  }

  Future<List<NovelResponseEntity>> _articleList(
    String path,
    int articleId,
  ) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      path,
      data: <String, dynamic>{'articleid': articleId},
    );
    return _unwrapList(resp, NovelResponseEntity.fromJson);
  }

  // ---- 解析 helpers ----

  List<T> _unwrapList<T>(
    Response<dynamic> resp,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final BaseResponse<List<T>> base = _base(
      resp,
      (Object? d) => (d! as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(fromJson)
          .toList(),
    );
    _ensureCode(base);
    return base.data ?? <T>[];
  }

  List<String> _unwrapStringList(Response<dynamic> resp) {
    final BaseResponse<List<String>> base = _base(
      resp,
      (Object? d) => (d! as List<dynamic>).whereType<String>().toList(),
    );
    _ensureCode(base);
    return base.data ?? const <String>[];
  }

  T _unwrapObject<T>(
    Response<dynamic> resp,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final BaseResponse<T> base = _base(
      resp,
      (Object? d) => fromJson(d! as Map<String, dynamic>),
    );
    if (!base.isSuccess) {
      throw ErrorMapper.fromBusinessCode(
        code: base.code,
        serverMessage: base.message,
      );
    }
    return base.data as T;
  }

  BaseResponse<T> _base<T>(
    Response<dynamic> resp,
    T Function(Object? data) fromData,
  ) {
    final Object? body = resp.data;
    final Map<String, dynamic> map = body is Map<String, dynamic>
        ? body
        : const <String, dynamic>{};
    return BaseResponse<T>.fromJson(map, fromData);
  }

  void _ensureCode<T>(BaseResponse<T> base) {
    if (base.code != ApiConstants.codeSuccess) {
      throw ErrorMapper.fromBusinessCode(
        code: base.code,
        serverMessage: base.message,
      );
    }
  }
}
