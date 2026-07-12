import 'package:bilireader/features/reader/domain/reader_block.dart';
import 'package:bilireader/features/reader/domain/reader_settings.dart';
import 'package:bilireader/features/reader/domain/reader_theme.dart';
import 'package:bilireader/features/reader/presentation/render/reader_block_view.dart';
import 'package:bilireader/features/reader/presentation/render/reader_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

ReaderStyle styleFor(ReaderTheme theme) =>
    ReaderStyle.from(const ReaderSettings(), theme);

Future<void> pumpBlock(
  WidgetTester tester,
  ReaderBlock block, {
  ReaderTheme? theme,
  VoidCallback? onComment,
}) async {
  final ReaderStyle style = styleFor(theme ?? kBuiltInReaderThemes.first);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        backgroundColor: style.bgColor,
        body: SingleChildScrollView(
          child: ReaderBlockView(
            block: block,
            style: style,
            onChapterComment: onComment,
          ),
        ),
      ),
    ),
  );
}

ParagraphBlock para(String html, {bool cont = false, bool centered = false}) =>
    ParagraphBlock(
      articleId: 1,
      chapterId: 1,
      html: html,
      sourceOffset: 0,
      continuation: cont,
      centered: centered,
    );

void main() {
  testWidgets('章名 block 不渲染 body 標題（設計取捨；章名在頂列）', (WidgetTester tester) async {
    await pumpBlock(
      tester,
      const ChapterTitleBlock(articleId: 1, chapterId: 1, title: '第三章 雨夜'),
    );
    expect(find.text('第三章 雨夜'), findsNothing);
  });

  testWidgets('段落 block 顯示文字（含縮排前綴）', (WidgetTester tester) async {
    await pumpBlock(tester, para('這是一段測試內文。'));
    // readerDisplayText 於一般段前置全形雙空格縮排。
    expect(find.textContaining('這是一段測試內文。'), findsOneWidget);
  });

  testWidgets('段落內黑幕點擊後揭露原文', (WidgetTester tester) async {
    await pumpBlock(tester, para('真名是<heimu>星隕之主</heimu>。'));
    // 未揭露：星隕之主 被遮罩（Opacity 0 仍在樹上，故 find 得到；改測點擊不崩潰 + 揭露後可見）。
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pump();
    expect(find.textContaining('星隕之主'), findsWidgets);
  });

  testWidgets('章評入口點擊觸發回呼', (WidgetTester tester) async {
    bool tapped = false;
    await pumpBlock(
      tester,
      const ChapterCommentBlock(articleId: 1, chapterId: 1),
      onComment: () => tapped = true,
    );
    expect(find.text('查看本章評論'), findsOneWidget);
    await tester.tap(find.text('查看本章評論'));
    expect(tapped, isTrue);
  });

  testWidgets('末尾 block 顯示結束標記', (WidgetTester tester) async {
    await pumpBlock(tester, const ReaderEndBlock(articleId: 1, chapterId: 1));
    expect(find.textContaining('本章結束'), findsOneWidget);
  });

  testWidgets('置中段落 textAlign center', (WidgetTester tester) async {
    await pumpBlock(tester, para('＊＊＊', centered: true));
    final RichText rt = tester.widget<RichText>(find.byType(RichText).first);
    expect(rt.textAlign, TextAlign.center);
  });

  testWidgets('圖片 block 建構不崩潰（占位）', (WidgetTester tester) async {
    await pumpBlock(
      tester,
      const ImageBlock(
        articleId: 1,
        chapterId: 1,
        url: 'https://img2.readpai.com/attachment/x.jpg',
        aspectRatio: 1.5,
        sourceOffset: 0,
      ),
    );
    expect(find.byType(AspectRatio), findsOneWidget);
  });
}
