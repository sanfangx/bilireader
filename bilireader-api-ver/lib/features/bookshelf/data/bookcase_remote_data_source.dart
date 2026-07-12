import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/base_response.dart';
import '../../../core/network/error_mapper.dart';
import '../domain/bookcase_options.dart';
import 'dto/bookshelf_item.dart';

/// 書架端點（UserApiService，API.md §8.1）。皆為 POST；需登入。
class BookcaseRemoteDataSource {
  const BookcaseRemoteDataSource(this._dio);

  final Dio _dio;

  /// `bookcase/list`（Body classid + sortorder）。空清單非錯誤。
  Future<List<BookshelfItem>> list({
    required BookcaseClass classFilter,
    required BookshelfSort sort,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.bookcaseList,
      data: <String, dynamic>{
        'classid': classFilter.value,
        'sortorder': sort.value,
      },
    );
    final BaseResponse<List<BookshelfItem>> base = _base(
      resp,
      (Object? d) => (d! as List<dynamic>)
          .whereType<Map<String, dynamic>>()
          .map(BookshelfItem.fromJson)
          .toList(),
    );
    _ensure(base);
    return base.data ?? const <BookshelfItem>[];
  }

  /// `bookcase/add`。回傳成功訊息字串。
  Future<String> add({
    required int articleId,
    required String articleName,
    required int classId,
    int? chapterId,
    String? chapterName,
    int? chapterOrder,
    int? pageId,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.bookcaseAdd,
      data: <String, dynamic>{
        'articleid': articleId,
        'articlename': articleName,
        'classid': classId,
        'chapterid': ?chapterId,
        'chaptername': ?chapterName,
        'chapterorder': ?chapterOrder,
        'pageid': ?pageId,
      },
    );
    return _string(resp);
  }

  /// `bookcase/delete`（Body caseid）。
  Future<String> delete(int caseId) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.bookcaseDelete,
      data: <String, dynamic>{'caseid': caseId},
    );
    return _string(resp);
  }

  /// `bookcase/updateClass`（Body caseid + classid）。
  Future<String> updateClass({
    required int caseId,
    required int classId,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.bookcaseUpdateClass,
      data: <String, dynamic>{'caseid': caseId, 'classid': classId},
    );
    return _string(resp);
  }

  /// `bookcase/check`（Body articleid）。回傳原始 Map 供 repository 解讀是否已收藏。
  Future<Map<String, dynamic>> check(int articleId) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.bookcaseCheck,
      data: <String, dynamic>{'articleid': articleId},
    );
    final BaseResponse<Map<String, dynamic>> base = _base(
      resp,
      (Object? d) => d is Map<String, dynamic> ? d : const <String, dynamic>{},
    );
    _ensure(base);
    return base.data ?? const <String, dynamic>{};
  }

  // ---- helpers ----

  String _string(Response<dynamic> resp) {
    final BaseResponse<String> base = _base(
      resp,
      (Object? d) => d?.toString() ?? '',
    );
    if (base.code != ApiConstants.codeSuccess) {
      throw ErrorMapper.fromBusinessCode(
        code: base.code,
        serverMessage: base.message,
      );
    }
    return base.data ?? base.message;
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

  void _ensure<T>(BaseResponse<T> base) {
    if (base.code != ApiConstants.codeSuccess) {
      throw ErrorMapper.fromBusinessCode(
        code: base.code,
        serverMessage: base.message,
      );
    }
  }
}
