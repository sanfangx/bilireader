import 'package:flutter/foundation.dart';

/// 分頁量測所需的版面度量（邏輯像素），對應反編譯 `ContentPaginator` + `ReaderTextSpacingKt`
/// （見 `apk/docs/flutter/05-閱讀器渲染管線.md` §7.1、§7.2、§8）。
///
/// 由 ⑨e 依「設定 + 內容區約束」建立並注入分頁器；此類只持有數值 + §8 padding 公式。
@immutable
class ReaderLayoutMetrics {
  const ReaderLayoutMetrics({
    required this.fontSizePx,
    required this.lineExtraPx,
    required this.paragraphDp,
    required this.availableWidth,
    required this.availableHeight,
    this.fontFamily = 'NotoSerifTC',
    this.chapterTitleSizePx = 24.0,
    this.smallReductionPx = 4.0,
  });

  /// 正文字型家族（量測＝渲染 §7.3：分頁量測須與內容渲染用同一字型）。
  final String fontFamily;

  /// 正文字級（`font_size`，邏輯 px）。
  final double fontSizePx;

  /// 行距 extra（`reader_line_spacing_extra_dp`，邏輯 px）。
  final double lineExtraPx;

  /// 段距設定（`reader_paragraph_spacing_dp`，4–28），供 [textTopPadding]/[textBottomPadding]。
  final int paragraphDp;

  /// 內容可用寬（＝圖片寬，§7.1 screenW-30dp）。
  final double availableWidth;

  /// 內容可用高（§7.1 screenH − 40 − 30 − 15 − 30 dp，或由 ⑨e 覆寫）。
  final double availableHeight;

  /// 章名字級（24sp 粗體）。
  final double chapterTitleSizePx;

  /// `<small>` 縮減 px（`READER_SMALL_TEXT_REDUCTION_SP`=4）。
  final double smallReductionPx;

  /// `readerTextTopPadding`：`ceil(padding·1.6·1.4)`。
  double get textTopPadding => (paragraphDp * 1.6 * 1.4).ceilToDouble();

  /// `readerTextBottomPadding`：`ceil(padding·0.8·1.4)`。
  double get textBottomPadding => (paragraphDp * 0.8 * 1.4).ceilToDouble();

  // 固定 dp 高度（邏輯 px），對應 estimateItemHeight（§7.2）。
  static const double adEndHeight = 60;
  static const double commentHeight = 60;
  static const double imageExtra = 24;
  static const double imageDefaultHeight = 200;
  static const double titleExtra = 10;
  static const double titleWidthInset = 10;
}
