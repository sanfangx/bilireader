import 'package:bilireader_app/features/reader/domain/reader_block.dart';
import 'package:bilireader_app/features/reader/domain/reader_layout_metrics.dart';
import 'package:bilireader_app/features/reader/domain/reader_paginator.dart';
import 'package:bilireader_app/features/reader/inline/reader_inline_node.dart';
import 'package:bilireader_app/features/reader/inline/reader_inline_parser.dart';
import 'package:flutter_test/flutter_test.dart';

/// 迴歸測試：`paginateIndexed` 回報的「每頁首個 block 的原始索引」必須落在
/// **原始 blocks 的索引空間**，不得因長段被切分而膨脹。
///
/// 坑：`ReaderAnchor.blockIndex` 是垂直捲動與翻頁模式**共用**的位置錨點。
/// 舊作法在展示層以「逐頁累加分頁後 block 數」當前綴和，但分頁器會把長段切成多個
/// `ParagraphBlock`，於是分頁後的索引空間比原始的大——每多切一次就多偏移 1。
/// 後果是靜默的：翻頁模式存下的 blockIndex 偏大，回到捲動模式還原時位置越跑越後面，
/// 而且沒有任何錯誤徵兆。
class _FakeMeasurer implements BlockMeasurer {
  const _FakeMeasurer();

  static const double charHeight = 10;
  static const ReaderInlineParser _p = ReaderInlineParser();

  int _vlen(String s) => visibleText(_p.parse(s)).length;

  @override
  double measureParagraph(String displayHtml, ReaderLayoutMetrics m) =>
      _vlen(displayHtml) * charHeight;

  @override
  double measureTitle(String title, ReaderLayoutMetrics m) => 20;

  @override
  int findFittingVisibleOffset(
    String displayHtml,
    ReaderLayoutMetrics m,
    double maxHeight,
  ) => (maxHeight / charHeight).floor().clamp(0, _vlen(displayHtml));
}

ReaderLayoutMetrics metrics({required double height}) => ReaderLayoutMetrics(
  fontSizePx: 20,
  lineExtraPx: 8,
  paragraphDp: 8,
  availableWidth: 300,
  availableHeight: height,
);

ParagraphBlock para(String text, {int offset = 0}) => ParagraphBlock(
  articleId: 1,
  chapterId: 1,
  html: text,
  sourceOffset: offset,
);

void main() {
  const ReaderPaginator paginator = ReaderPaginator(_FakeMeasurer());

  test('每頁起始索引都是合法的原始 blocks 索引（不因切分而膨脹）', () {
    // 中間那段長到必然被切成好幾頁。
    final List<ReaderBlock> blocks = <ReaderBlock>[
      para('短段一'),
      para('長' * 300, offset: 10),
      para('短段二', offset: 400),
      para('短段三', offset: 500),
    ];

    final ({List<List<ReaderBlock>> pages, List<int> pageStartOriginIndex})
    r = paginator.paginateIndexed(blocks, metrics(height: 200));

    expect(r.pages.length, greaterThan(blocks.length),
        reason: '長段必須真的被切成多頁，否則這個測試沒驗到東西');
    expect(r.pageStartOriginIndex.length, r.pages.length);

    for (final int i in r.pageStartOriginIndex) {
      expect(i, inInclusiveRange(0, blocks.length - 1),
          reason: '起始索引超出原始 blocks 範圍 → 錨點已落到膨脹後的索引空間');
    }
    // 非遞減：閱讀順序不會倒退。
    for (int i = 1; i < r.pageStartOriginIndex.length; i++) {
      expect(r.pageStartOriginIndex[i],
          greaterThanOrEqualTo(r.pageStartOriginIndex[i - 1]));
    }
    // 最後一頁的頁首必為最後一個 block。
    expect(r.pageStartOriginIndex.last, blocks.length - 1);
  });

  test('被切成多頁的 block：那幾頁共用同一個原始索引', () {
    final List<ReaderBlock> blocks = <ReaderBlock>[
      para('前'),
      para('長' * 300, offset: 10),
      para('後', offset: 400),
    ];

    final ({List<List<ReaderBlock>> pages, List<int> pageStartOriginIndex})
    r = paginator.paginateIndexed(blocks, metrics(height: 200));

    final int repeats =
        r.pageStartOriginIndex.where((int i) => i == 1).length;
    expect(repeats, greaterThan(1),
        reason: '長段跨多頁時，這些頁的起始索引都應指向同一個原始 block（index 1）');
    expect(r.pageStartOriginIndex.first, 0);
    // 註：不是每個 block 都會「成為某頁的頁首」——短段可能被塞進前一段切片的尾巴，
    // 那一頁的頁首仍是被切的那個長段。故不斷言相異索引數 == blocks.length。

    // 明確釘住「舊作法會錯多少」：以分頁後 block 數累加的前綴和，最後一頁會算成 ≥ 段數，
    // 遠大於正確答案 1。這個斷言在有人改回累加法時會立刻失敗。
    final List<int> naivePrefixSum = <int>[];
    int acc = 0;
    for (final List<ReaderBlock> p in r.pages) {
      naivePrefixSum.add(acc);
      acc += p.length;
    }
    expect(naivePrefixSum.last, greaterThan(blocks.length),
        reason: '前提檢查：舊作法在此情境確實會超出原始索引範圍');
    expect(r.pageStartOriginIndex.last, lessThan(blocks.length));
    expect(r.pageStartOriginIndex.last, isNot(naivePrefixSum.last));
  });

  test('沒有任何切分時，與「逐頁累加」的舊作法一致（不改變既有行為）', () {
    final List<ReaderBlock> blocks = <ReaderBlock>[
      para('一'),
      para('二', offset: 10),
      para('三', offset: 20),
    ];
    // 每頁只塞得下一段。
    final ({List<List<ReaderBlock>> pages, List<int> pageStartOriginIndex})
    r = paginator.paginateIndexed(blocks, metrics(height: 40));

    expect(r.pages.length, blocks.length);
    expect(r.pageStartOriginIndex, <int>[0, 1, 2]);
  });

  test('paginate() 舊 API 的分頁結果不受影響', () {
    final List<ReaderBlock> blocks = <ReaderBlock>[
      para('前'),
      para('長' * 120, offset: 10),
      para('後', offset: 200),
    ];
    final ReaderLayoutMetrics m = metrics(height: 200);
    expect(paginator.paginate(blocks, m), paginator.paginateIndexed(blocks, m).pages);
  });
}
