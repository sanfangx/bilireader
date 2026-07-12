import 'dart:io';

import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/social/reaction.dart';
import 'package:bilireader/core/text/chinese_converter.dart';
import 'package:bilireader/features/chapter_comment/data/chapter_comment_remote_data_source.dart';
import 'package:bilireader/features/chapter_comment/data/chapter_comment_repository_impl.dart';
import 'package:bilireader/features/chapter_comment/data/dto/chapter_comment_dtos.dart';
import 'package:bilireader/features/chapter_comment/domain/chapter_comment_entities.dart';
import 'package:flutter_test/flutter_test.dart';

/// 以固定 DTO 回應驗證章評 repository 映射與 OpenCC 轉繁；不觸網。
class _FakeChapterCommentRemote implements ChapterCommentRemoteDataSource {
  ChapterCommentListDataDto listData = const ChapterCommentListDataDto();
  ChapterCommentReactionDto reaction = const ChapterCommentReactionDto();

  @override
  Future<ChapterCommentListDataDto> list({
    required int articleId,
    required int chapterId,
    required int page,
    int pageSize = 20,
  }) async => listData;

  @override
  Future<ChapterCommentListDataDto> mine({
    required int articleId,
    required int chapterId,
    required int page,
    int pageSize = 20,
  }) async => listData;

  @override
  Future<int> add({
    required int articleId,
    required int chapterId,
    required String content,
    required bool isSpoiler,
  }) async => 321;

  @override
  Future<void> delete(int commentId) async {}

  @override
  Future<ChapterCommentReactionDto> like({
    required int commentId,
    required int type,
  }) async => reaction;
}

void main() {
  late ChineseConverter converter;

  setUpAll(() async {
    converter = ChineseConverter(loader: (String k) => File(k).readAsString());
    await converter.ensureLoaded();
  });

  ChapterCommentRepositoryImpl build(_FakeChapterCommentRemote remote) =>
      ChapterCommentRepositoryImpl(remote: remote, converter: converter);

  test('list：DTO → ChapterComment，轉繁 + cmt 欄位 + 旗標 + addtime→相對時間', () async {
    // 迴歸：欄位名須用真實章評模型 `cmtname/cmtcontent/cmtLevel/addtime`（反編譯 ChapterCommentItem），
    // 非 BookReplyItem 的 poster/posttext（前一版誤用 → 姓名/內容全空白）。
    final _FakeChapterCommentRemote remote = _FakeChapterCommentRemote()
      ..listData = const ChapterCommentListDataDto(
        list: <ChapterCommentItemDto>[
          ChapterCommentItemDto(
            id: 88, // like/delete 用的主鍵
            cmtid: 5, // 另一序號，不得誤當 commentId
            cmtcontent: '这段写得真好',
            cmtname: '读者甲',
            cmtLevel: 'Lv3',
            likeNum: 12,
            myReaction: 1,
            ispoiler: 1,
            ishot: 1,
            parentid: 7,
            addtime: '1709337600', // epoch 秒（字串）
          ),
        ],
        pages: 2,
        total: 30,
      );
    final ChapterCommentPage page =
        ((await build(remote).list(articleId: 1, chapterId: 2))
                as ApiSuccess<ChapterCommentPage>)
            .data;
    final ChapterComment c = page.comments.single;
    expect(c.commentId, 88); // = id（非 cmtid=5）——like/delete 正確性
    expect(c.content, '這段寫得真好'); // cmtcontent 轉繁
    expect(c.commenterName, '讀者甲'); // cmtname 轉繁
    expect(c.commenterLevel, 'Lv3');
    expect(c.myReaction, Reaction.like);
    expect(c.isSpoiler, isTrue);
    expect(c.isHot, isTrue);
    expect(c.parentId, 7);
    expect(c.addtime, isNotNull); // addtime 數值 → 相對時間字串
    expect(c.addtime, isNotEmpty);
    expect(page.hasMore, isTrue);
  });

  test('addtime 為空/未提供 → null；非數值日期字串可解析為相對時間', () async {
    final _FakeChapterCommentRemote remote = _FakeChapterCommentRemote()
      ..listData = const ChapterCommentListDataDto(
        list: <ChapterCommentItemDto>[
          ChapterCommentItemDto(id: 9, cmtname: 'x', cmtcontent: 'y'),
          ChapterCommentItemDto(
            id: 10,
            cmtname: 'x',
            cmtcontent: 'y',
            addtime: '2024-03-02 00:00:00',
          ),
        ],
      );
    final ChapterCommentPage page =
        ((await build(remote).list(articleId: 1, chapterId: 2))
                as ApiSuccess<ChapterCommentPage>)
            .data;
    expect(page.comments[0].commentId, 9);
    expect(page.comments[0].addtime, isNull); // 無 addtime → null
    expect(page.comments[1].addtime, isNotNull); // 日期字串 → 相對時間
    expect(page.comments[1].addtime, isNotEmpty);
  });

  test('DTO.fromJson 寬鬆型別：catid/cmtid 為「字串」不得整筆解析失敗（真實 bug）', () {
    // 迴歸（實測 ADB 型別診斷）：真實回應 catid/cmtid 以「字串」回傳；嚴格 `as int` 會拋 →
    // 整筆 list 解析失敗 → 面板「載入失敗」。另 addtime/cmtLevel 若為數字亦須容忍。寬鬆轉換器覆蓋。
    final ChapterCommentItemDto dto = ChapterCommentItemDto.fromJson(
      <String, dynamic>{
        'id': 12345,
        'catid': '3', // 字串（非 int）——真實 bug 主因
        'cmtid': '5', // 字串（非 int）
        'cmtname': '讀者乙',
        'cmtcontent': '內容',
        'addtime': 1709337600, // 數字（非字串）——亦須容忍
        'cmtLevel': 7, // 數字（非字串）
        'likeNum': 3,
        'avatar': 42,
        'avatarUrl': 'https://x/y.png',
      },
    );
    expect(dto.id, 12345);
    expect(dto.catid, 3); // 字串 → int
    expect(dto.cmtid, 5); // 字串 → int
    expect(dto.addtime, '1709337600'); // 數字 → 字串
    expect(dto.cmtLevel, '7');
    expect(dto.cmtname, '讀者乙');
    expect(dto.likeNum, 3);
  });

  test('like 映射 → ReactionCounts', () async {
    final _FakeChapterCommentRemote remote = _FakeChapterCommentRemote()
      ..reaction = const ChapterCommentReactionDto(likeNum: 13, myReaction: 1);
    final ReactionCounts rc =
        ((await build(remote).like(commentId: 88, type: 1))
                as ApiSuccess<ReactionCounts>)
            .data;
    expect(rc.likeNum, 13);
    expect(rc.myReaction, Reaction.like);
  });
}
