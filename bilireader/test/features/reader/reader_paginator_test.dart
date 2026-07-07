import 'package:bilireader/features/reader/domain/reader_block.dart';
import 'package:bilireader/features/reader/domain/reader_inline_node.dart';
import 'package:bilireader/features/reader/domain/reader_inline_parser.dart';
import 'package:bilireader/features/reader/domain/reader_layout_metrics.dart';
import 'package:bilireader/features/reader/domain/reader_paginator.dart';
import 'package:flutter_test/flutter_test.dart';

/// 確定性量測：每個可見字 [charHeight] px；findFitting 依線性高度回推可見 offset。
class _FakeMeasurer implements BlockMeasurer {
  const _FakeMeasurer();

  final double charHeight = 10;
  final double titleHeight = 20;

  static const ReaderInlineParser _p = ReaderInlineParser();
  int _vlen(String s) => visibleText(_p.parse(s)).length;

  @override
  double measureParagraph(String displayHtml, ReaderLayoutMetrics m) =>
      _vlen(displayHtml) * charHeight;

  @override
  double measureTitle(String title, ReaderLayoutMetrics m) => titleHeight;

  @override
  int findFittingVisibleOffset(
    String displayHtml,
    ReaderLayoutMetrics m,
    double maxHeight,
  ) => (maxHeight / charHeight).floor().clamp(0, _vlen(displayHtml));
}

ReaderLayoutMetrics metrics({double height = 1000}) => ReaderLayoutMetrics(
  fontSizePx: 20,
  lineExtraPx: 8,
  paragraphDp: 8, // topPad=18, botPad=9
  availableWidth: 300,
  availableHeight: height,
);

ParagraphBlock para(String html) =>
    ParagraphBlock(articleId: 1, chapterId: 1, html: html, sourceOffset: 0);

void main() {
  const ReaderPaginator paginator = ReaderPaginator(_FakeMeasurer());

  test('空 → 空頁', () {
    expect(paginator.paginate(<ReaderBlock>[], metrics()), isEmpty);
  });

  test('貪婪裝箱：滿了才換頁', () {
    // 每段 est = 5*10 + 18 + 9 = 77。avail=200 → 2 段/頁。
    final List<List<ReaderBlock>> pages = paginator.paginate(<ReaderBlock>[
      para('abc'),
      para('abc'),
      para('abc'),
    ], metrics(height: 200));
    expect(pages.length, 2);
    expect(pages[0].length, 2);
    expect(pages[1].length, 1);
  });

  test('圖片獨佔一頁，並封存前面內容', () {
    final List<ReaderBlock> blocks = <ReaderBlock>[
      para('abc'),
      const ImageBlock(
        articleId: 1,
        chapterId: 1,
        url: 'u',
        aspectRatio: 1,
        sourceOffset: 0,
      ),
      para('abc'),
    ];
    final List<List<ReaderBlock>> pages = paginator.paginate(blocks, metrics());
    expect(pages.length, 3);
    expect(pages[0].single, isA<ParagraphBlock>());
    expect(pages[1].single, isA<ImageBlock>());
    expect(pages[2].single, isA<ParagraphBlock>());
  });

  test('章名開新頁（前面有內容時）', () {
    final List<List<ReaderBlock>> pages = paginator.paginate(<ReaderBlock>[
      para('abc'),
      const ChapterTitleBlock(articleId: 1, chapterId: 1, title: '第二章'),
      para('abc'),
    ], metrics());
    expect(pages.length, 2);
    expect(pages[0].single, isA<ParagraphBlock>());
    expect(pages[1].first, isA<ChapterTitleBlock>());
    expect(pages[1].length, 2); // 章名 + 後段同頁
  });

  test('章評/末尾各獨佔一頁', () {
    final List<List<ReaderBlock>> pages = paginator.paginate(<ReaderBlock>[
      const ChapterCommentBlock(articleId: 1, chapterId: 1),
      const ReaderEndBlock(articleId: 1, chapterId: 1),
    ], metrics());
    expect(pages.length, 2);
    expect(pages[0].single, isA<ChapterCommentBlock>());
    expect(pages[1].single, isA<ReaderEndBlock>());
  });

  test('超長段（空頁）切分成多頁，內容與續段旗標正確', () {
    // avail=100：avail1=100-18=82 → 每頁最多 8 可見字。
    final List<List<ReaderBlock>> pages = paginator.paginate(<ReaderBlock>[
      para('abcdefghij'), // 10 字
    ], metrics(height: 100));
    expect(pages.length, greaterThan(1));
    // 串接各頁段落 html，應還原原文（不含首段縮排）。
    final StringBuffer sb = StringBuffer();
    bool firstPara = true;
    for (final List<ReaderBlock> page in pages) {
      for (final ReaderBlock b in page) {
        if (b is ParagraphBlock) {
          sb.write(b.html);
          // 第一段 continuation=false，其餘=true。
          if (!firstPara) expect(b.continuation, isTrue);
          firstPara = false;
        }
      }
    }
    expect(sb.toString(), 'abcdefghij');
  });
}
