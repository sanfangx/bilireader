import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/reader_layout_metrics.dart';
import '../../domain/reader_settings.dart';
import '../../domain/reader_theme.dart';

/// 由 [ReaderSettings] + [ReaderTheme] 推導的閱讀器渲染樣式（design「閱讀器 .prose」+ doc 05 §8）。
///
/// 供內容渲染（`ReaderSpanBuilder` / block widgets）與分頁量測（⑨e3 `TextPainterBlockMeasurer`）
/// **共用**，確保「量測＝渲染」（§7.3）。字級/行距來自設定；顏色來自主題。
@immutable
class ReaderStyle {
  const ReaderStyle({
    required this.fontSizePx,
    required this.lineExtraPx,
    required this.paragraphTopPad,
    required this.paragraphBotPad,
    required this.textColor,
    required this.bgColor,
    required this.rubyColor,
    required this.emphasisColor,
    required this.heimuColor,
    this.smallReductionPx = 4,
    this.fontFamily = AppTypography.fontSerif,
  });

  /// 由設定 + 主題建立。
  factory ReaderStyle.from(ReaderSettings s, ReaderTheme t) {
    final Color tc = Color(t.textColor);
    return ReaderStyle(
      fontFamily: s.fontFamily.family,
      fontSizePx: s.fontSize,
      lineExtraPx: s.lineSpacingDp.toDouble(),
      // §8：段距 → top/bottom padding。
      paragraphTopPad: (s.paragraphSpacingDp * 1.6 * 1.4).ceilToDouble(),
      paragraphBotPad: (s.paragraphSpacingDp * 0.8 * 1.4).ceilToDouble(),
      textColor: tc,
      bgColor: Color(t.bgColor),
      // design .prose ruby rt = var(--acc) 金色。
      rubyColor: AppColors.acc,
      // §6.3 傍点 #555555 / §6.2 黑幕 #252525 皆假設深色 App；主題化閱讀器改用「文字色」
      // 衍生（自適應各主題），避免夜間主題上不可見。
      emphasisColor: tc.withValues(alpha: 0.5),
      heimuColor: tc,
    );
  }

  /// 供分頁量測用（顏色無關；字級/行距/family 取自 [ReaderLayoutMetrics]）。
  factory ReaderStyle.forMeasure(ReaderLayoutMetrics m) => ReaderStyle(
    fontFamily: m.fontFamily,
    fontSizePx: m.fontSizePx,
    lineExtraPx: m.lineExtraPx,
    paragraphTopPad: m.textTopPadding,
    paragraphBotPad: m.textBottomPadding,
    textColor: const Color(0xFF000000),
    bgColor: const Color(0xFFFFFFFF),
    rubyColor: const Color(0xFF000000),
    emphasisColor: const Color(0xFF000000),
    heimuColor: const Color(0xFF000000),
    smallReductionPx: m.smallReductionPx,
  );

  /// 正文字級（邏輯 px）。
  final double fontSizePx;

  /// 行距 extra（邏輯 px；透過 [strut] 的 leading 疊加於自然行高，對應 §7.3 setLineSpacing）。
  final double lineExtraPx;

  final double paragraphTopPad;
  final double paragraphBotPad;

  final Color textColor;
  final Color bgColor;

  /// ruby 注音色（design：金色）。
  final Color rubyColor;

  /// 傍点色。
  final Color emphasisColor;

  /// 黑幕遮罩色。
  final Color heimuColor;

  /// `<small>` 縮減 px（`smallTextScale` 用）。
  final double smallReductionPx;

  final String fontFamily;

  /// 正文基礎 [TextStyle]（serif、字級、文字色、design .prose letter-spacing .01em）。行距交給 [strut]。
  TextStyle get baseTextStyle => TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSizePx,
    color: textColor,
    letterSpacing: 0.01 * fontSizePx,
  );

  /// 行距 strut：leading 疊加 [lineExtraPx]（＝自然行高 + extra，對應 StaticLayout setLineSpacing(extra,1.0)）。
  StrutStyle get strut => StrutStyle(
    fontFamily: fontFamily,
    fontSize: fontSizePx,
    leading: fontSizePx <= 0 ? 0 : lineExtraPx / fontSizePx,
  );

  @override
  bool operator ==(Object other) =>
      other is ReaderStyle &&
      other.fontSizePx == fontSizePx &&
      other.lineExtraPx == lineExtraPx &&
      other.paragraphTopPad == paragraphTopPad &&
      other.paragraphBotPad == paragraphBotPad &&
      other.textColor == textColor &&
      other.bgColor == bgColor &&
      other.rubyColor == rubyColor &&
      other.emphasisColor == emphasisColor &&
      other.heimuColor == heimuColor &&
      other.smallReductionPx == smallReductionPx &&
      other.fontFamily == fontFamily;

  @override
  int get hashCode => Object.hash(
    fontSizePx,
    lineExtraPx,
    paragraphTopPad,
    paragraphBotPad,
    textColor,
    bgColor,
    rubyColor,
    emphasisColor,
    heimuColor,
    smallReductionPx,
    fontFamily,
  );
}
