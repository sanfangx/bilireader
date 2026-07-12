import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/social/reaction.dart';
import 'package:bilireader/features/chapter_comment/data/chapter_comment_providers.dart';
import 'package:bilireader/features/chapter_comment/domain/chapter_comment_entities.dart';
import 'package:bilireader/features/chapter_comment/domain/chapter_comment_repository.dart';
import 'package:bilireader/features/chapter_comment/presentation/chapter_comment_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRepo implements ChapterCommentRepository {
  @override
  Future<ApiResult<ChapterCommentPage>> list({
    required int articleId,
    required int chapterId,
    int page = 1,
  }) async => const ApiSuccess<ChapterCommentPage>(
    ChapterCommentPage(
      comments: <ChapterComment>[
        ChapterComment(
          commentId: 1,
          content: '這章的反轉太神了',
          commenterName: '聽風的人',
          commenterLevel: 'Lv8',
          likeNum: 42,
          isHot: true,
          addtime: '2 小時前',
        ),
        ChapterComment(
          commentId: 2,
          content: '兇手其實是管家啦',
          commenterName: '檸檬不酸',
          isSpoiler: true,
          likeNum: 18,
          addtime: '5 小時前',
        ),
      ],
      pageNum: 1,
      pages: 1,
      total: 2,
    ),
  );

  @override
  Future<ApiResult<ChapterCommentPage>> mine({
    required int articleId,
    required int chapterId,
    int page = 1,
  }) async => list(articleId: articleId, chapterId: chapterId, page: page);

  @override
  Future<ApiResult<int>> add({
    required int articleId,
    required int chapterId,
    required String content,
    bool isSpoiler = false,
  }) async => const ApiSuccess<int>(3);

  @override
  Future<ApiResult<void>> delete(int commentId) async =>
      const ApiSuccess<void>(null);

  @override
  Future<ApiResult<ReactionCounts>> like({
    required int commentId,
    required int type,
  }) async => const ApiSuccess<ReactionCounts>(ReactionCounts());
}

void main() {
  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          chapterCommentRepositoryProvider.overrideWithValue(_FakeRepo()),
        ],
        child: const MaterialApp(
          home: ChapterCommentPanel(
            articleId: 1,
            chapterId: 2,
            chapterName: '第三章 雨夜',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('渲染評論列表：計數/名稱/等級/熱門旗標', (WidgetTester tester) async {
    await pump(tester);
    expect(find.text('共 2 則'), findsOneWidget);
    expect(find.text('聽風的人'), findsOneWidget);
    expect(find.textContaining('這章的反轉太神了'), findsOneWidget);
    expect(find.text('Lv8'), findsOneWidget);
    expect(find.text('熱門'), findsOneWidget);
  });

  testWidgets('劇透評論先遮罩，點擊揭露原文', (WidgetTester tester) async {
    await pump(tester);
    // 未揭露：遮罩顯示、原文不顯示。
    expect(find.text('⚠ 劇透內容 · 點擊顯示'), findsOneWidget);
    expect(find.text('兇手其實是管家啦'), findsNothing);
    // 點擊揭露。
    await tester.tap(find.text('⚠ 劇透內容 · 點擊顯示'));
    await tester.pump();
    expect(find.text('兇手其實是管家啦'), findsOneWidget);
  });
}
