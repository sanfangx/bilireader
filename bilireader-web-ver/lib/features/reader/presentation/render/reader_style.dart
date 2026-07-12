import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../theme/app_colors.dart';
import '../../domain/reader_layout_metrics.dart';
import '../../domain/reader_settings.dart';
import '../../domain/reader_theme.dart';

/// 由 [ReaderSettings] + [ReaderTheme] 推導的閱讀器渲染樣式（design「閱讀器 .prose」+ doc 05 §8）。
///
/// 供內容渲染（`ReaderSpanBuilder` / block widgets）與分頁量測（⑨e3 `TextPainterBlockMeasurer`）
/// **共用**，確保「量測＝渲染」（§7.3）。字級/行距來自設定；顏色來自主題。
///
/// web 適配（忠實移植自 api-ver `presentation/render/reader_style.dart`）：
/// 1. 顏色 import 從 api-ver `core/theme/app_colors.dart` 改為 web-ver `theme/app_colors.dart`
///    （`AppColors.acc` 金色符號在兩版同名同值 0xFFCAA15C）。
/// 2. api-ver 依賴的 `AppTypography`（web-ver 無此檔）以本檔內 [_fontSerif]/[_fontSans]
///    常數取代（值即 'NotoSerifTC'/'NotoSansTC'，與 web-ver [ReaderFontFamily].family 一致）。
/// 3. [baseTextStyle]/[strut] 的字型**不可**用裸 `fontFamily` 字串（web-ver 探查裁定：
///    `TextStyle(fontFamily:'NotoSerifTC')` 無法解析為 Noto，會退化系統字型 → 量測偏差、
///    翻頁溢出）。改用 google_fonts 工廠（`GoogleFonts.notoSerifTc/notoSansTc`）取得 TextStyle，
///    strut 則沿用其解析後的 fontFamily（含 fallback），確保量測＝渲染一致。
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
    this.fontFamily = _fontSerif,
  });

  /// web 適配：取代 api-ver 的 `AppTypography.fontSerif` / `AppTypography.fontSans`
  /// （web-ver 無 `AppTypography`）。值對齊 [ReaderFontFamily] 各項的 family 字串。
  static const String _fontSerif = 'NotoSerifTC';
  static const String _fontSans = 'NotoSansTC';
  static const String _fontRounded = 'RoundedTC';

  /// 由設定 + 主題建立。
  factory ReaderStyle.from(ReaderSettings s, ReaderTheme t) {
    // web 適配：api-ver `ReaderTheme.textColor/bgColor` 為 ARGB int，渲染層轉 [Color]。
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

  /// 正文字型家族名（'NotoSerifTC' / 'NotoSansTC'）。
  ///
  /// web 適配：此字串**不**直接餵給 `TextStyle.fontFamily`（無法解析），僅作為
  /// [_resolveFont] 選擇 google_fonts 工廠的鍵；同時保留於 ==/hashCode 以維持相等語意。
  final String fontFamily;

  /// 正文基礎 [TextStyle]（serif、字級、文字色、design .prose letter-spacing .01em）。行距交給 [strut]。
  ///
  /// web 適配：改由 google_fonts 工廠產生（見 [_resolveFont]），而非裸 `fontFamily` 字串。
  TextStyle get baseTextStyle => _resolveFont(
    fontFamily,
    fontSize: fontSizePx,
    color: textColor,
    letterSpacing: 0.01 * fontSizePx,
  );

  /// 行距 strut：leading 疊加 [lineExtraPx]（＝自然行高 + extra，對應 StaticLayout setLineSpacing(extra,1.0)）。
  ///
  /// web 適配：fontFamily/fontFamilyFallback 一律取自 [baseTextStyle]（google_fonts 解析後的
  /// 變體名 + 裸名 fallback），不用裸 'NotoSerifTC' 字串，確保 strut 量測與內文渲染同字型。
  StrutStyle get strut {
    final TextStyle base = baseTextStyle;
    return StrutStyle(
      fontFamily: base.fontFamily,
      fontFamilyFallback: base.fontFamilyFallback,
      fontSize: fontSizePx,
      leading: fontSizePx <= 0 ? 0 : lineExtraPx / fontSizePx,
    );
  }

  /// web 適配：把字型家族名映到對應 [TextStyle]。
  ///
  /// - 'NotoSansTC'（黑體）→ [GoogleFonts.notoSansTc]（動態載入，裸名無法解析）。
  /// - 'RoundedTC'（圓體）→ **bundled asset**（pubspec fonts 宣告，裸 fontFamily 可直接解析；
  ///   對齊 api-ver 的 RoundedTC.ttf）。
  /// - 'NotoSerifTC'（明體）與未知值 → [GoogleFonts.notoSerifTc]（對齊 [ReaderFontFamily.fromWire]
  ///   對未知值退回明體的既定行為）。
  ///
  /// 不指定 fontWeight（同 api-ver `baseTextStyle` 之預設 w400）；google_fonts 會將實際
  /// fontFamily 設為變體後綴名（如 'NotoSerifTC_regular'），並把裸名放入 fontFamilyFallback。
  static TextStyle _resolveFont(
    String family, {
    required double fontSize,
    required Color color,
    required double letterSpacing,
  }) {
    switch (family) {
      case _fontSans: // 'NotoSansTC'
        return GoogleFonts.notoSansTc(
          fontSize: fontSize,
          color: color,
          letterSpacing: letterSpacing,
        );
      case _fontRounded: // 'RoundedTC'（bundled；CJK 缺字退回黑體）
        return TextStyle(
          fontFamily: _fontRounded,
          fontFamilyFallback: GoogleFonts.notoSansTc().fontFamily != null
              ? <String>[GoogleFonts.notoSansTc().fontFamily!]
              : null,
          fontSize: fontSize,
          color: color,
          letterSpacing: letterSpacing,
        );
      case _fontSerif: // 'NotoSerifTC'
      default:
        return GoogleFonts.notoSerifTc(
          fontSize: fontSize,
          color: color,
          letterSpacing: letterSpacing,
        );
    }
  }

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
