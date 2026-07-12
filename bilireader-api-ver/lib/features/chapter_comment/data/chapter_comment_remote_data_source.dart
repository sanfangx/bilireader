import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/base_response.dart';
import '../../../core/network/error_mapper.dart';
import 'dto/chapter_comment_dtos.dart';

/// 章節評論端點（API.md §8.2 chapter_comment/*）。皆 Query；需登入。
class ChapterCommentRemoteDataSource {
  const ChapterCommentRemoteDataSource(this._dio);

  final Dio _dio;

  /// `chapter_comment/list`（Query articleId + chapterId + pageNum + pageSize）。
  Future<ChapterCommentListDataDto> list({
    required int articleId,
    required int chapterId,
    required int page,
    int pageSize = ApiConstants.defaultPageSize,
  }) => _listCall(ApiPaths.chapterCommentList, <String, dynamic>{
    'articleId': articleId,
    'chapterId': chapterId,
    'pageNum': page,
    'pageSize': pageSize,
  });

  /// `chapter_comment/my`（Query articleId + chapterId）。
  Future<ChapterCommentListDataDto> mine({
    required int articleId,
    required int chapterId,
    required int page,
    int pageSize = ApiConstants.defaultPageSize,
  }) => _listCall(ApiPaths.chapterCommentMy, <String, dynamic>{
    'articleId': articleId,
    'chapterId': chapterId,
    'pageNum': page,
    'pageSize': pageSize,
  });

  /// `chapter_comment/add`（Query articleId + chapterId + content + isSpoiler）→ {commentId}。
  Future<int> add({
    required int articleId,
    required int chapterId,
    required String content,
    required bool isSpoiler,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.chapterCommentAdd,
      queryParameters: <String, dynamic>{
        'articleId': articleId,
        'chapterId': chapterId,
        'content': content,
        'isSpoiler': isSpoiler ? 1 : 0,
      },
    );
    final BaseResponse<int> base = _base(resp, (Object? d) {
      final Object? v = _map(d)['commentId'];
      return v is num ? v.toInt() : int.tryParse('${v ?? ''}') ?? 0;
    });
    _ensure(base);
    return base.data ?? 0;
  }

  /// `chapter_comment/delete`（Query commentId）。
  Future<void> delete(int commentId) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.chapterCommentDelete,
      queryParameters: <String, dynamic>{'commentId': commentId},
    );
    _ensure(_base(resp, (Object? d) => d));
  }

  /// `chapter_comment/like`（Query commentId + type）。
  Future<ChapterCommentReactionDto> like({
    required int commentId,
    required int type,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.chapterCommentLike,
      queryParameters: <String, dynamic>{'commentId': commentId, 'type': type},
    );
    final BaseResponse<ChapterCommentReactionDto> base = _base(
      resp,
      (Object? d) => ChapterCommentReactionDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const ChapterCommentReactionDto();
  }

  // ---- helpers ----

  Future<ChapterCommentListDataDto> _listCall(
    String path,
    Map<String, dynamic> query,
  ) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      path,
      queryParameters: query,
    );
    final BaseResponse<ChapterCommentListDataDto> base = _base(
      resp,
      (Object? d) => ChapterCommentListDataDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const ChapterCommentListDataDto();
  }

  Map<String, dynamic> _map(Object? d) =>
      d is Map<String, dynamic> ? d : const <String, dynamic>{};

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
