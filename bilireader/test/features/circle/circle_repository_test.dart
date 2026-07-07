import 'dart:io';

import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/social/reaction.dart';
import 'package:bilireader/core/text/chinese_converter.dart';
import 'package:bilireader/features/circle/data/circle_remote_data_source.dart';
import 'package:bilireader/features/circle/data/circle_repository_impl.dart';
import 'package:bilireader/features/circle/data/dto/circle_dtos.dart';
import 'package:bilireader/features/circle/domain/circle_entities.dart';
import 'package:dio/dio.dart' show MultipartFile;
import 'package:flutter_test/flutter_test.dart';

/// 以固定 DTO 回應驗證圈子 repository 映射與 OpenCC 轉繁；不觸網。
class _FakeCircleRemote implements CircleRemoteDataSource {
  CircleFeedDataDto feed = const CircleFeedDataDto();
  List<CircleSectionDto> sectionList = const <CircleSectionDto>[];
  CircleFeedItemDto post = const CircleFeedItemDto();
  CircleRepliesDataDto replyPage = const CircleRepliesDataDto();
  CircleReactionDto reaction = const CircleReactionDto();

  @override
  Future<List<CircleSectionDto>> sections() async => sectionList;

  @override
  Future<CircleFeedDataDto> list({
    required String category,
    int? sectionId,
    String? keyword,
    required int page,
    int pageSize = 20,
  }) async => feed;

  @override
  Future<CircleFeedItemDto> detail(int topicId) async => post;

  @override
  Future<CircleRepliesDataDto> replies({
    required int topicId,
    required int page,
    int pageSize = 20,
  }) async => replyPage;

  @override
  Future<CircleReactionDto> like({
    required int topicId,
    required int type,
  }) async => reaction;

  @override
  Future<CircleReactionDto> replyLike({
    required int postId,
    required int type,
  }) async => reaction;

  @override
  Future<int> publish({
    required int sectionId,
    required String title,
    required String content,
    List<MultipartFile> images = const <MultipartFile>[],
  }) async => 555;

  @override
  Future<CircleReplyDto> reply({
    required int topicId,
    required String posttext,
    int? replyPid,
    List<MultipartFile> images = const <MultipartFile>[],
  }) async => const CircleReplyDto(postid: 1);
}

void main() {
  late ChineseConverter converter;

  setUpAll(() async {
    converter = ChineseConverter(loader: (String k) => File(k).readAsString());
    await converter.ensureLoaded();
  });

  CircleRepositoryImpl build(_FakeCircleRemote remote) =>
      CircleRepositoryImpl(remote: remote, converter: converter);

  test('list：DTO → CirclePost，文字轉繁 + reaction/圖片映射', () async {
    final _FakeCircleRemote remote = _FakeCircleRemote()
      ..feed = const CircleFeedDataDto(
        list: <CircleFeedItemDto>[
          CircleFeedItemDto(
            id: 9,
            topicId: 42,
            title: '软件推荐',
            content: '这本书很好看',
            author: '张三',
            sectionName: '推书',
            likeNum: 128,
            badNum: 3,
            myReaction: 1,
            replies: 42,
            views: 1200,
            attachmentUrls: <String>['https://img/a.jpg', ''],
          ),
        ],
        pages: 3,
        total: 50,
      );
    final CircleFeed feed =
        ((await build(remote).list()) as ApiSuccess<CircleFeed>).data;

    final CirclePost p = feed.posts.single;
    expect(p.topicId, 42);
    expect(p.title, '軟體推薦'); // 软件推荐 → 軟體推薦
    expect(p.content, '這本書很好看');
    expect(p.authorName, '張三');
    expect(p.sectionName, '推書');
    expect(p.myReaction, Reaction.like);
    expect(p.imageUrls, <String>['https://img/a.jpg']); // 空字串濾除
    expect(feed.hasMore, isTrue); // page 1 < pages 3
  });

  test('detail：topicId 缺省時退回 id', () async {
    final _FakeCircleRemote remote = _FakeCircleRemote()
      ..post = const CircleFeedItemDto(id: 77, title: 'x', myReaction: 2);
    final CirclePost p =
        ((await build(remote).detail(77)) as ApiSuccess<CirclePost>).data;
    expect(p.topicId, 77);
    expect(p.myReaction, Reaction.bad);
  });

  test('sections + like 映射', () async {
    final _FakeCircleRemote remote = _FakeCircleRemote()
      ..sectionList = const <CircleSectionDto>[
        CircleSectionDto(sectionId: 1, sectionName: '综合讨论'),
      ]
      ..reaction = const CircleReactionDto(
        likeNum: 9,
        badNum: 1,
        myReaction: 1,
      );

    final List<CircleSection> secs =
        ((await build(remote).sections()) as ApiSuccess<List<CircleSection>>)
            .data;
    expect(secs.single.sectionName, '綜合討論');

    final ReactionCounts rc =
        ((await build(remote).like(topicId: 42, type: 1))
                as ApiSuccess<ReactionCounts>)
            .data;
    expect(rc.likeNum, 9);
    expect(rc.myReaction, Reaction.like);
  });
}
