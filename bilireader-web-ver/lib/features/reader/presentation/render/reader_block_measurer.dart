import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/reader_layout_metrics.dart';
import '../../domain/reader_paginator.dart';
import '../../inline/reader_inline_parser.dart';
import 'reader_span_builder.dart';
import 'reader_style.dart';

/// [BlockMeasurer] 的 `TextPainter` 實作（分頁器用；與渲染共用 `ReaderSpanBuilder`+`ReaderStyle`，
/// §7.3）。忠實移植自 api-ver（唯字型與 parser import 改 web-ver 版）。
///
/// 量測用 [ReaderSpanBuilder.buildPlain]（純文字、無 WidgetSpan）：字元 offset 對齊「可見字」
/// 空間、高度含行距 strut。ruby 注音/傍点圓點的**額外高度**於量測略估，故展示層對頁高留安全邊界。
class TextPainterBlockMeasurer implements BlockMeasurer {
  const TextPainterBlockMeasurer();

  static const ReaderInlineParser _parser = ReaderInlineParser();
  static const ReaderSpanBuilder _builder = ReaderSpanBuilder();

  double _w(ReaderLayoutMetrics m) =>
      m.availableWidth < 1 ? 1 : m.availableWidth;

  @override
  double measureParagraph(String displayHtml, ReaderLayoutMetrics m) {
    final ReaderStyle style = ReaderStyle.forMeasure(m);
    final TextPainter tp = TextPainter(
      text: _builder.buildPlain(_parser.parse(displayHtml), style),
      textDirection: TextDirection.ltr,
      strutStyle: style.strut,
    )..layout(maxWidth: _w(m));
    final double h = tp.height;
    tp.dispose(); // TextPainter 持有原生 ui.Paragraph；分頁反覆量測須顯式釋放。
    return h;
  }

  @override
  double measureTitle(String title, ReaderLayoutMetrics m) {
    final double w = (m.availableWidth - ReaderLayoutMetrics.titleWidthInset)
        .clamp(1.0, double.infinity);
    final TextPainter tp = TextPainter(
      // web 適配：api-ver 用 TextStyle(fontFamily: AppTypography.fontSerif)；web-ver 無
      // AppTypography、且裸 family 名無法解析（見 ReaderStyle 註）→ 改 GoogleFonts.notoSerifTc。
      text: TextSpan(
        text: title,
        style: GoogleFonts.notoSerifTc(
          fontSize: m.chapterTitleSizePx,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: w);
    final double h = tp.height;
    tp.dispose();
    return h;
  }

  @override
  int findFittingVisibleOffset(
    String displayHtml,
    ReaderLayoutMetrics m,
    double maxHeight,
  ) {
    if (maxHeight <= 0) return 0;
    final ReaderStyle style = ReaderStyle.forMeasure(m);
    final TextPainter tp = TextPainter(
      text: _builder.buildPlain(_parser.parse(displayHtml), style),
      textDirection: TextDirection.ltr,
      strutStyle: style.strut,
    )..layout(maxWidth: _w(m));

    int fit = 0;
    for (final LineMetrics line in tp.computeLineMetrics()) {
      final double bottom = line.baseline + line.descent;
      if (bottom > maxHeight) break;
      final int end = tp
          .getPositionForOffset(Offset(_w(m), line.baseline))
          .offset;
      if (end > fit) fit = end;
    }
    tp.dispose();
    return fit;
  }
}
