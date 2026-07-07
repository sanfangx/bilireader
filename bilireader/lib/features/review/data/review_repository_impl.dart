import 'package:dio/dio.dart';

import '../../../core/network/api_result.dart';
import '../../../core/network/app_error.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/social/reaction.dart';
import '../../../core/text/chinese_converter.dart';
import '../domain/review_entities.dart';
import '../domain/review_options.dart';
import '../domain/review_repository.dart';
import 'dto/review_dtos.dart';
import 'review_remote_data_source.dart';

/// [ReviewRepository] 實作。DTO→domain；顯示文字轉繁（§5.0）。清單不快取。
class ReviewRepositoryImpl implements ReviewRepository {
  ReviewRepositoryImpl({
    required ReviewRemoteDataSource remote,
    required ChineseConverter converter,
  }) : _remote = remote,
       _converter = converter;

  final ReviewRemoteDataSource _remote;
  final ChineseConverter _converter;

  @override
  Future<ApiResult<BookReviewPage>> list({
    required int articleId,
    BookReviewSort sort = BookReviewSort.defaultValue,
    int page = 1,
  }) => _guard(() async {
    final BookReviewListDataDto d = await _remote.list(
      articleId: articleId,
      sort: sort,
      page: page,
    );
    return BookReviewPage(
      reviews: d.list.map(_review).toList(),
      pageNum: d.pageNum,
      pages: d.pages,
      total: d.total,
    );
  });

  @override
  Future<ApiResult<BookReview>> detail(int topicId) =>
      _guard(() async => _review(await _remote.detail(topicId)));

  @override
  Future<ApiResult<BookReview?>> mine(int articleId) => _guard(() async {
    final BookReviewItemDto d = await _remote.mine(articleId);
    return d.topicid > 0 ? _review(d) : null;
  });

  @override
  Future<ApiResult<BookReviewReplyList>> replies({
    required int topicId,
    int page = 1,
  }) => _guard(() async {
    final BookReviewRepliesDataDto d = await _remote.replies(
      topicId: topicId,
      page: page,
    );
    return BookReviewReplyList(
      replies: d.list.map(_reply).toList(),
      pageNum: d.pageNum,
      pages: d.pages,
    );
  });

  @override
  Future<ApiResult<int>> add({
    required int articleId,
    required String content,
    bool isSpoiler = false,
  }) => _guard(
    () => _remote.add(
      articleId: articleId,
      content: content,
      isSpoiler: isSpoiler,
    ),
  );

  @override
  Future<ApiResult<void>> delete(int topicId) =>
      _guard(() => _remote.delete(topicId));

  @override
  Future<ApiResult<BookReviewReply>> reply({
    required int topicId,
    required String posttext,
    int? replyPid,
  }) => _guard(() async {
    final BookReplyItemDto d = await _remote.reply(
      topicId: topicId,
      posttext: posttext,
      replyPid: replyPid,
    );
    return _reply(d);
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

  // ---- mapping ----

  BookReview _review(BookReviewItemDto e) => BookReview(
    topicId: e.topicid,
    content: _tw(e.content),
    authorName: _tw(e.poster),
    title: _twNullable(e.title),
    authorLevel: e.posterLevel,
    avatarUrl: e.avatarUrl,
    likeNum: e.likeNum,
    badNum: e.badNum,
    myReaction: Reaction.fromValue(e.myReaction),
    replies: e.replies,
    posttime: e.posttime,
    isSpoiler: e.ispoiler == 1,
    isGood: e.isgood == 1,
    isTop: e.istop == 1,
  );

  BookReviewReply _reply(BookReplyItemDto e) => BookReviewReply(
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
  );

  ReactionCounts _counts(ReviewReactionDto e) => ReactionCounts(
    likeNum: e.likeNum,
    badNum: e.badNum,
    myReaction: Reaction.fromValue(e.myReaction),
  );

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
