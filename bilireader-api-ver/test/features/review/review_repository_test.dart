import 'dart:io';

import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/social/reaction.dart';
import 'package:bilireader/core/text/chinese_converter.dart';
import 'package:bilireader/features/review/data/dto/review_dtos.dart';
import 'package:bilireader/features/review/data/review_remote_data_source.dart';
import 'package:bilireader/features/review/data/review_repository_impl.dart';
import 'package:bilireader/features/review/domain/review_entities.dart';
import 'package:bilireader/features/review/domain/review_options.dart';
import 'package:flutter_test/flutter_test.dart';

/// 以固定 DTO 回應驗證書評 repository 映射與 OpenCC 轉繁；不觸網。
class _FakeReviewRemote implements ReviewRemoteDataSource {
  BookReviewListDataDto listData = const BookReviewListDataDto();
  BookReviewItemDto item = const BookReviewItemDto();
  BookReviewItemDto mineItem = const BookReviewItemDto();
  BookReviewRepliesDataDto replyData = const BookReviewRepliesDataDto();
  ReviewReactionDto reaction = const ReviewReactionDto();

  @override
  Future<BookReviewListDataDto> list({
    required int articleId,
    required BookReviewSort sort,
    required int page,
    int pageSize = 20,
  }) async => listData;

  @override
  Future<BookReviewItemDto> detail(int topicId) async => item;

  @override
  Future<BookReviewItemDto> mine(int articleId) async => mineItem;

  @override
  Future<BookReviewRepliesDataDto> replies({
    required int topicId,
    required int page,
    int pageSize = 20,
  }) async => replyData;

  @override
  Future<int> add({
    required int articleId,
    required String content,
    required bool isSpoiler,
  }) async => 999;

  @override
  Future<void> delete(int topicId) async {}

  @override
  Future<BookReplyItemDto> reply({
    required int topicId,
    required String posttext,
    int? replyPid,
  }) async => const BookReplyItemDto(postid: 1);

  @override
  Future<ReviewReactionDto> like({
    required int topicId,
    required int type,
  }) async => reaction;

  @override
  Future<ReviewReactionDto> replyLike({
    required int postId,
    required int type,
  }) async => reaction;
}

void main() {
  late ChineseConverter converter;

  setUpAll(() async {
    converter = ChineseConverter(loader: (String k) => File(k).readAsString());
    await converter.ensureLoaded();
  });

  ReviewRepositoryImpl build(_FakeReviewRemote remote) =>
      ReviewRepositoryImpl(remote: remote, converter: converter);

  test('list：DTO → BookReview，文字轉繁 + reaction/精華/劇透映射', () async {
    final _FakeReviewRemote remote = _FakeReviewRemote()
      ..listData = const BookReviewListDataDto(
        list: <BookReviewItemDto>[
          BookReviewItemDto(
            topicid: 7,
            poster: '张三',
            content: '这本书节奏明快',
            likeNum: 32,
            myReaction: 1,
            replies: 4,
            isgood: 1,
            ispoiler: 1,
          ),
        ],
        pages: 2,
        total: 1204,
      );
    final BookReviewPage page =
        ((await build(remote).list(articleId: 1)) as ApiSuccess<BookReviewPage>)
            .data;
    final BookReview r = page.reviews.single;
    expect(r.topicId, 7);
    expect(r.authorName, '張三');
    expect(r.content, '這本書節奏明快');
    expect(r.myReaction, Reaction.like);
    expect(r.isGood, isTrue);
    expect(r.isSpoiler, isTrue);
    expect(page.total, 1204);
    expect(page.hasMore, isTrue);
  });

  test('mine：topicid 0 → null（未寫過書評）', () async {
    final _FakeReviewRemote remote = _FakeReviewRemote()
      ..mineItem = const BookReviewItemDto();
    expect(
      ((await build(remote).mine(1)) as ApiSuccess<BookReview?>).data,
      isNull,
    );

    remote.mineItem = const BookReviewItemDto(topicid: 5, content: '好书');
    final BookReview? mine =
        ((await build(remote).mine(1)) as ApiSuccess<BookReview?>).data;
    expect(mine?.topicId, 5);
    expect(mine?.content, '好書');
  });

  test('like 映射 → ReactionCounts', () async {
    final _FakeReviewRemote remote = _FakeReviewRemote()
      ..reaction = const ReviewReactionDto(likeNum: 33, myReaction: 1);
    final ReactionCounts rc =
        ((await build(remote).like(topicId: 7, type: 1))
                as ApiSuccess<ReactionCounts>)
            .data;
    expect(rc.likeNum, 33);
    expect(rc.myReaction, Reaction.like);
  });
}
