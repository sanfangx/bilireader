import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/base_response.dart';
import '../../../core/network/error_mapper.dart';
import 'dto/circle_dtos.dart';

/// 圈子端點（API.md §8.2 circle/*）。Query 用 `queryParameters`；publish/reply 走
/// Multipart（FormData），由 UploadSignatureInterceptor 依路徑自動加 BNUP2 簽章。需登入。
class CircleRemoteDataSource {
  const CircleRemoteDataSource(this._dio);

  final Dio _dio;

  /// `circle/sections`（無參數）→ List。
  Future<List<CircleSectionDto>> sections() async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.circleSections,
    );
    final BaseResponse<List<CircleSectionDto>> base = _base(
      resp,
      (Object? d) => (d is List<dynamic> ? d : const <dynamic>[])
          .whereType<Map<String, dynamic>>()
          .map(CircleSectionDto.fromJson)
          .toList(),
    );
    _ensure(base);
    return base.data ?? const <CircleSectionDto>[];
  }

  /// `circle/list`（Query category/sectionId?/pageNum/pageSize/keyword?）。
  Future<CircleFeedDataDto> list({
    required String category,
    int? sectionId,
    String? keyword,
    required int page,
    int pageSize = ApiConstants.defaultPageSize,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.circleList,
      queryParameters: <String, dynamic>{
        'category': category,
        'sectionId': ?sectionId,
        'keyword': ?keyword,
        'pageNum': page,
        'pageSize': pageSize,
      },
    );
    final BaseResponse<CircleFeedDataDto> base = _base(
      resp,
      (Object? d) => CircleFeedDataDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const CircleFeedDataDto();
  }

  /// `circle/detail`（Query topicId）→ CircleFeedItem。
  Future<CircleFeedItemDto> detail(int topicId) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.circleDetail,
      queryParameters: <String, dynamic>{'topicId': topicId},
    );
    final BaseResponse<CircleFeedItemDto> base = _base(
      resp,
      (Object? d) => CircleFeedItemDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const CircleFeedItemDto();
  }

  /// `circle/replies`（Query topicId/pageNum/pageSize）。
  Future<CircleRepliesDataDto> replies({
    required int topicId,
    required int page,
    int pageSize = ApiConstants.defaultPageSize,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.circleReplies,
      queryParameters: <String, dynamic>{
        'topicId': topicId,
        'pageNum': page,
        'pageSize': pageSize,
      },
    );
    final BaseResponse<CircleRepliesDataDto> base = _base(
      resp,
      (Object? d) => CircleRepliesDataDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const CircleRepliesDataDto();
  }

  /// `circle/like`（Query topicId/type）。
  Future<CircleReactionDto> like({required int topicId, required int type}) =>
      _reaction(ApiPaths.circleLike, <String, dynamic>{
        'topicId': topicId,
        'type': type,
      });

  /// `circle/reply_like`（Query postId/type）。
  Future<CircleReactionDto> replyLike({
    required int postId,
    required int type,
  }) => _reaction(ApiPaths.circleReplyLike, <String, dynamic>{
    'postId': postId,
    'type': type,
  });

  /// `circle/publish`（Query sectionId/title + Multipart content；BNUP2🔒）→ {topicId}。
  Future<int> publish({
    required int sectionId,
    required String title,
    required String content,
    List<MultipartFile> images = const <MultipartFile>[],
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.circlePublish,
      queryParameters: <String, dynamic>{
        'sectionId': sectionId,
        'title': title,
      },
      data: FormData.fromMap(<String, dynamic>{
        'content': content,
        if (images.isNotEmpty) 'images': images,
      }),
    );
    final BaseResponse<int> base = _base(resp, (Object? d) {
      final Object? v = _map(d)['topicId'];
      return v is num ? v.toInt() : int.tryParse('${v ?? ''}') ?? 0;
    });
    _ensure(base);
    return base.data ?? 0;
  }

  /// `circle/reply`（Query topicId/replyPid? + Multipart posttext；BNUP2🔒）→ {reply}。
  Future<CircleReplyDto> reply({
    required int topicId,
    required String posttext,
    int? replyPid,
    List<MultipartFile> images = const <MultipartFile>[],
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.circleReply,
      queryParameters: <String, dynamic>{
        'topicId': topicId,
        'replyPid': ?replyPid,
      },
      data: FormData.fromMap(<String, dynamic>{
        'posttext': posttext,
        if (images.isNotEmpty) 'images': images,
      }),
    );
    final BaseResponse<CircleReplyDto> base = _base(resp, (Object? d) {
      final Map<String, dynamic> m = _map(d);
      final Object? nested = m['reply'];
      return nested is Map<String, dynamic>
          ? CircleReplyDto.fromJson(nested)
          : CircleReplyDto.fromJson(m);
    });
    _ensure(base);
    return base.data ?? const CircleReplyDto();
  }

  // ---- helpers ----

  Future<CircleReactionDto> _reaction(
    String path,
    Map<String, dynamic> query,
  ) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      path,
      queryParameters: query,
    );
    final BaseResponse<CircleReactionDto> base = _base(
      resp,
      (Object? d) => CircleReactionDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const CircleReactionDto();
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
