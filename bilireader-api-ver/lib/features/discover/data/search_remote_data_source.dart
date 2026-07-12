import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/base_response.dart';
import '../../../core/network/error_mapper.dart';
import 'dto/novel_response_entity.dart';

/// 搜尋端點呼叫（API.md：`novel/searchNovel`，Body `searchKey` + query `pageNum`/`pageSize`）。
/// 空結果回空 list（非錯誤）；fallback 由 repository 判斷。
class SearchRemoteDataSource {
  const SearchRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<NovelResponseEntity>> searchNovel({
    required String searchKey,
    required int pageNum,
    int pageSize = ApiConstants.searchPageSize,
    CancelToken? cancelToken,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.searchNovel,
      queryParameters: <String, dynamic>{
        'pageNum': pageNum,
        'pageSize': pageSize,
      },
      data: <String, dynamic>{'searchKey': searchKey},
      cancelToken: cancelToken,
    );
    return _unwrapList(resp);
  }

  /// 依標籤篩選（同 `novel/searchNovel`，Body 用 `tagName` + 可選 `sortBy`）。
  /// [tagName] 為後端查詢用文字條件（可能為簡體 fallback）。
  Future<List<NovelResponseEntity>> searchByTag({
    required String tagName,
    String? sortBy,
    required int pageNum,
    int pageSize = ApiConstants.searchPageSize,
    CancelToken? cancelToken,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.searchNovel,
      queryParameters: <String, dynamic>{
        'pageNum': pageNum,
        'pageSize': pageSize,
      },
      data: <String, dynamic>{'tagName': tagName, 'sortBy': ?sortBy},
      cancelToken: cancelToken,
    );
    return _unwrapList(resp);
  }

  /// 文庫多條件篩選（`novel/searchNovel`，Body：`tagNames[]` + 可選 `filterFullFlag`/
  /// `minWords`/`sortBy`）。[tagNames] 為後端查詢文字條件（可能為簡體 fallback）。
  Future<List<NovelResponseEntity>> filterNovel({
    required List<String> tagNames,
    int? filterFullFlag,
    int? minWords,
    String? sortBy,
    required int pageNum,
    int pageSize = ApiConstants.searchPageSize,
    CancelToken? cancelToken,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.searchNovel,
      queryParameters: <String, dynamic>{
        'pageNum': pageNum,
        'pageSize': pageSize,
      },
      data: <String, dynamic>{
        if (tagNames.isNotEmpty) 'tagNames': tagNames,
        'filterFullFlag': ?filterFullFlag,
        'minWords': ?minWords,
        'sortBy': ?sortBy,
      },
      cancelToken: cancelToken,
    );
    return _unwrapList(resp);
  }

  List<NovelResponseEntity> _unwrapList(Response<dynamic> resp) {
    final Object? body = resp.data;
    final Map<String, dynamic> map = body is Map<String, dynamic>
        ? body
        : const <String, dynamic>{};
    final BaseResponse<List<NovelResponseEntity>> base =
        BaseResponse<List<NovelResponseEntity>>.fromJson(
          map,
          (Object? d) => (d! as List<dynamic>)
              .whereType<Map<String, dynamic>>()
              .map(NovelResponseEntity.fromJson)
              .toList(),
        );
    if (base.code != ApiConstants.codeSuccess) {
      throw ErrorMapper.fromBusinessCode(
        code: base.code,
        serverMessage: base.message,
      );
    }
    return base.data ?? const <NovelResponseEntity>[];
  }
}
