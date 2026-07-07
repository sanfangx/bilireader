import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';

import '../../../core/media/image_pick_service.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/app_error.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/social/reaction.dart';
import '../../../core/text/chinese_converter.dart';
import '../domain/circle_entities.dart';
import '../domain/circle_repository.dart';
import 'circle_remote_data_source.dart';
import 'dto/circle_dtos.dart';

/// [CircleRepository] 實作。DTO→domain；顯示文字轉繁（§5.0）。清單不快取（下拉即時）。
class CircleRepositoryImpl implements CircleRepository {
  CircleRepositoryImpl({
    required CircleRemoteDataSource remote,
    required ChineseConverter converter,
  }) : _remote = remote,
       _converter = converter;

  final CircleRemoteDataSource _remote;
  final ChineseConverter _converter;

  @override
  Future<ApiResult<List<CircleSection>>> sections() => _guard(() async {
    final List<CircleSectionDto> list = await _remote.sections();
    return list.map(_section).toList();
  });

  @override
  Future<ApiResult<CircleFeed>> list({
    String category = 'latest',
    int? sectionId,
    String? keyword,
    int page = 1,
  }) => _guard(() async {
    final CircleFeedDataDto d = await _remote.list(
      category: category,
      sectionId: sectionId,
      keyword: keyword,
      page: page,
    );
    return CircleFeed(
      posts: d.list.map(_post).toList(),
      pageNum: d.pageNum,
      pages: d.pages,
      total: d.total,
    );
  });

  @override
  Future<ApiResult<CirclePost>> detail(int topicId) =>
      _guard(() async => _post(await _remote.detail(topicId)));

  @override
  Future<ApiResult<CircleReplyPage>> replies({
    required int topicId,
    int page = 1,
  }) => _guard(() async {
    final CircleRepliesDataDto d = await _remote.replies(
      topicId: topicId,
      page: page,
    );
    return CircleReplyPage(
      replies: d.list.map(_reply).toList(),
      pageNum: d.pageNum,
      pages: d.pages,
    );
  });

  @override
  Future<ApiResult<ReactionCounts>> like({
    required int topicId,
    required int type,
  }) => _guard(
    () async => _counts(await _remote.like(topicId: topicId, type: type)),
  );

  @override
  Future<ApiResult<ReactionCounts>> replyLike({
    required int postId,
    required int type,
  }) => _guard(
    () async => _counts(await _remote.replyLike(postId: postId, type: type)),
  );

  @override
  Future<ApiResult<int>> publish({
    required int sectionId,
    required String title,
    required String content,
    List<XFile> images = const <XFile>[],
  }) => _guard(
    () async => _remote.publish(
      sectionId: sectionId,
      title: title,
      content: content,
      images: await ImagePickService.toMultipartList(images, field: 'images'),
    ),
  );

  @override
  Future<ApiResult<CircleReply>> reply({
    required int topicId,
    required String posttext,
    int? replyPid,
    List<XFile> images = const <XFile>[],
  }) => _guard(() async {
    final CircleReplyDto d = await _remote.reply(
      topicId: topicId,
      posttext: posttext,
      replyPid: replyPid,
      images: await ImagePickService.toMultipartList(images, field: 'images'),
    );
    return _reply(d);
  });

  // ---- mapping ----

  CirclePost _post(CircleFeedItemDto e) => CirclePost(
    topicId: e.topicId ?? e.id,
    title: _tw(e.title),
    content: _tw(e.content),
    authorName: _tw(e.author),
    authorLevel: e.authorLevel,
    avatarUrl: e.avatarUrl,
    sectionName: _twNullable(e.sectionName),
    likeNum: e.likeNum,
    badNum: e.badNum,
    myReaction: Reaction.fromValue(e.myReaction),
    replies: e.replies,
    views: e.views,
    postTime: e.postTime,
    imageUrls: _images(e.attachmentUrls, e.attachmentUrl),
    articleId: e.articleId,
    articleName: _twNullable(e.articleName),
  );

  CircleSection _section(CircleSectionDto e) => CircleSection(
    sectionId: e.sectionId,
    sectionName: _tw(e.sectionName),
    categoryName: _tw(e.categoryName),
    postCount: e.postCount,
    topicCount: e.topicCount,
  );

  CircleReply _reply(CircleReplyDto e) => CircleReply(
    postId: e.postid,
    posttext: _tw(e.posttext),
    posterName: _tw(e.poster),
    posterLevel: e.posterLevel,
    avatarUrl: e.avatarUrl,
    likeNum: e.likeNum,
    badNum: e.badNum,
    myReaction: Reaction.fromValue(e.myReaction),
    posttime: e.posttime,
    replyToPoster: _twNullable(e.replyToPoster),
    imageUrls: _images(e.attachmentUrls, e.attachmentUrl),
  );

  ReactionCounts _counts(CircleReactionDto e) => ReactionCounts(
    likeNum: e.likeNum,
    badNum: e.badNum,
    myReaction: Reaction.fromValue(e.myReaction),
  );

  List<String> _images(List<String>? urls, String? single) {
    if (urls != null && urls.isNotEmpty) {
      return urls.where((String u) => u.isNotEmpty).toList();
    }
    if (single != null && single.isNotEmpty) {
      return <String>[single];
    }
    return const <String>[];
  }

  String _tw(String? text) =>
      (text == null || text.isEmpty) ? '' : _converter.toTraditionalTw(text);

  String? _twNullable(String? text) =>
      (text == null || text.isEmpty) ? text : _converter.toTraditionalTw(text);

  Future<ApiResult<T>> _guard<T>(Future<T> Function() body) async {
    try {
      await _converter.ensureLoaded();
      return ApiSuccess<T>(await body());
    } on DioException catch (e) {
      return ApiFailure<T>(ErrorMapper.fromDio(e));
    } on AppError catch (e) {
      return ApiFailure<T>(e);
    } on Object catch (e) {
      return ApiFailure<T>(ErrorMapper.parse(e));
    }
  }
}
