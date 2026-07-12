import 'package:bilireader/features/reader/domain/reader_layout_metrics.dart';
import 'package:bilireader/features/reader/presentation/render/reader_block_measurer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const TextPainterBlockMeasurer m = TextPainterBlockMeasurer();
  const ReaderLayoutMetrics metrics = ReaderLayoutMetrics(
    fontSizePx: 20,
    lineExtraPx: 8,
    paragraphDp: 8,
    availableWidth: 300,
    availableHeight: 400,
  );

  test('measureParagraph 回傳正高度', () {
    expect(
      m.measureParagraph('　　這是一段測試內文，內容足夠長以換行呈現多列。', metrics),
      greaterThan(0),
    );
  });

  test('measureTitle 回傳正高度', () {
    expect(m.measureTitle('第一章 雨夜來客', metrics), greaterThan(0));
  });

  test('findFittingVisibleOffset：高度越大可容納越多、且 >0', () {
    final String long = '一' * 400;
    final int small = m.findFittingVisibleOffset(long, metrics, 60);
    final int big = m.findFittingVisibleOffset(long, metrics, 400);
    expect(small, greaterThan(0));
    expect(big, greaterThanOrEqualTo(small));
    expect(big, lessThanOrEqualTo(long.length));
  });

  test('findFittingVisibleOffset：maxHeight<=0 → 0', () {
    expect(m.findFittingVisibleOffset('內文', metrics, 0), 0);
  });
}
