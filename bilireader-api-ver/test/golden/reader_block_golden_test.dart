import 'package:bilireader/features/reader/domain/reader_block.dart';
import 'package:bilireader/features/reader/domain/reader_settings.dart';
import 'package:bilireader/features/reader/domain/reader_theme.dart';
import 'package:bilireader/features/reader/presentation/render/reader_block_view.dart';
import 'package:bilireader/features/reader/presentation/render/reader_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// F-25 鎖現狀：續段正文 `Opacity(0.4)` vs 一般段落的視覺對比。改透明度前先鎖，
/// 改後前後對照交 skeptic 對照設計稿核可（§9.4e golden 核可政策）。
void main() {
  testWidgets('閱讀器段落 golden：一般段 vs 續段（鎖 continuation 透明度）', (
    WidgetTester tester,
  ) async {
    final ReaderStyle style = ReaderStyle.from(
      const ReaderSettings(),
      kBuiltInReaderThemes.first,
    );
    ParagraphBlock para({required bool continuation}) => ParagraphBlock(
      articleId: 1,
      chapterId: 1,
      html: '這是一段正文，用來鎖定續段透明度的視覺基準。續段不縮排且較淡。',
      sourceOffset: 0,
      continuation: continuation,
    );

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: style.bgColor,
          body: ColoredBox(
            color: style.bgColor,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ReaderBlockView(
                    block: para(continuation: false),
                    style: style,
                  ),
                  ReaderBlockView(
                    block: para(continuation: true),
                    style: style,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Column),
      matchesGoldenFile('goldens/reader_block_continuation.png'),
    );
  });
}
