import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/base_response.dart';
import '../../../core/network/error_mapper.dart';
import '../domain/review_options.dart';
import 'dto/review_dtos.dart';

/// 書評端點（API.md §8.2 book_review/*）。皆 Query（用 `queryParameters`）；需登入。
class ReviewRemoteDataSource {
  const ReviewRemoteDataSource(this._dio);

  final Dio _dio;

  Future<BookReviewListDataDto> list({
    required int articleId,
    required BookReviewSort sort,
    required int page,
    int pageSize = ApiConstants.defaultPageSize,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.bookReviewList,
      queryParameters: <String, dynamic>{
        'articleId': articleId,
        'pageNum': page,
        'pageSize': pageSize,
        'sortBy': sort.value,
      },
    );
    final BaseResponse<BookReviewListDataDto> base = _base(
      resp,
      (Object? d) => BookReviewListDataDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const BookReviewListDataDto();
  }

  Future<BookReviewItemDto> detail(int topicId) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.bookReviewDetail,
      queryParameters: <String, dynamic>{'topicId': topicId},
    );
    return _reviewItem(resp);
  }

  Future<BookReviewItemDto> mine(int articleId) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.bookReviewMy,
      queryParameters: <String, dynamic>{'articleId': articleId},
    );
    return _reviewItem(resp);
  }

  Future<BookReviewRepliesDataDto> replies({
    required int topicId,
    required int page,
    int pageSize = ApiConstants.defaultPageSize,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.bookReviewReplies,
      queryParameters: <String, dynamic>{
        'topicId': topicId,
        'pageNum': page,
        'pageSize': pageSize,
      },
    );
    final BaseResponse<BookReviewRepliesDataDto> base = _base(
      resp,
      (Object? d) => BookReviewRepliesDataDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const BookReviewRepliesDataDto();
  }

  Future<int> add({
    required int articleId,
    required String content,
    required bool isSpoiler,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.bookReviewAdd,
      queryParameters: <String, dynamic>{
        'articleId': articleId,
        'content': content,
        'isSpoiler': isSpoiler ? 1 : 0,
      },
    );
    final BaseResponse<int> base = _base(resp, (Object? d) {
      final Object? v = _map(d)['topicid'] ?? _map(d)['topicId'];
      return v is num ? v.toInt() : int.tryParse('${v ?? ''}') ?? 0;
    });
    _ensure(base);
    return base.data ?? 0;
  }

  Future<void> delete(int topicId) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.bookReviewDelete,
      queryParameters: <String, dynamic>{'topicId': topicId},
    );
    _ensure(_base(resp, (Object? d) => d));
  }

  Future<BookReplyItemDto> reply({
    required int topicId,
    required String posttext,
    int? replyPid,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.bookReviewReply,
      queryParameters: <String, dynamic>{
        'topicId': topicId,
        'posttext': posttext,
        'replyPid': ?replyPid,
      },
    );
    final BaseResponse<BookReplyItemDto> base = _base(resp, (Object? d) {
      final Map<String, dynamic> m = _map(d);
      final Object? nested = m['reply'];
      return nested is Map<String, dynamic>
          ? BookReplyItemDto.fromJson(nested)
          : BookReplyItemDto.fromJson(m);
    });
    _ensure(base);
    return base.data ?? const BookReplyItemDto();
  }

  Future<ReviewReactionDto> like({required int topicId, required int type}) =>
      _reaction(ApiPaths.bookReviewLike, <String, dynamic>{
        'topicId': topicId,
        'type': type,
      });

  Future<ReviewReactionDto> replyLike({
    required int postId,
    required int type,
  }) => _reaction(ApiPaths.bookReviewReplyLike, <String, dynamic>{
    'postId': postId,
    'type': type,
  });

  // ---- helpers ----

  Future<ReviewReactionDto> _reaction(
    String path,
    Map<String, dynamic> query,
  ) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      path,
      queryParameters: query,
    );
    final BaseResponse<ReviewReactionDto> base = _base(
      resp,
      (Object? d) => ReviewReactionDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const ReviewReactionDto();
  }

  BookReviewItemDto _reviewItem(Response<dynamic> resp) {
    final BaseResponse<BookReviewItemDto> base = _base(
      resp,
      (Object? d) => BookReviewItemDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const BookReviewItemDto();
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
