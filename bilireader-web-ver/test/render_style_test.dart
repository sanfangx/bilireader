import 'package:bilireader_app/features/reader/domain/reader_layout_metrics.dart';
import 'package:bilireader_app/features/reader/domain/reader_settings.dart';
import 'package:bilireader_app/features/reader/domain/reader_theme.dart';
import 'package:bilireader_app/features/reader/presentation/render/reader_style.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// 忠實移植 Step 5：ReaderStyle 由 ReaderSettings + ReaderTheme 推導的**純數值/顏色**（不觸
/// google_fonts 的 baseTextStyle/strut，故無網路依賴、確定性）。
///
/// 註：buildPlain==visibleText 的量測不變式由 render/reader_span_builder.dart 逐行忠實移植
/// api-ver（其 buildPlain 邏輯即 TextRun→text / RubyRun→base / HeimuRun→遞迴 / br→\n，與
/// web-ver inline/visibleText 同構）+ analyze 保證；此處聚焦 web 適配的樣式推導。
void main() {
  group('ReaderStyle.from（設定 + 主題）', () {
    const ReaderTheme night = ReaderTheme(
      id: 'builtin_night',
      name: '夜間',
      builtIn: true,
      textColor: 0xFFCCC6BC,
      bgColor: 0xFF121212,
    );

    test('§8 段距 → top/bottom padding：ceil(dp·1.6·1.4) / ceil(dp·0.8·1.4)', () {
      const ReaderSettings s = ReaderSettings(paragraphSpacingDp: 8);
      final ReaderStyle st = ReaderStyle.from(s, night);
      expect(st.paragraphTopPad, (8 * 1.6 * 1.4).ceilToDouble()); // 18
      expect(st.paragraphBotPad, (8 * 0.8 * 1.4).ceilToDouble()); // 9
    });

    test('顏色：主題 ARGB int → Color；ruby 金色；傍点=文字色半透明；黑幕=文字色', () {
      const ReaderSettings s = ReaderSettings();
      final ReaderStyle st = ReaderStyle.from(s, night);
      expect(st.textColor, const Color(0xFFCCC6BC));
      expect(st.bgColor, const Color(0xFF121212));
      expect(st.rubyColor, const Color(0xFFCAA15C)); // AppColors.acc 金色
      expect(st.emphasisColor, const Color(0xFFCCC6BC).withValues(alpha: 0.5));
      expect(st.heimuColor, const Color(0xFFCCC6BC));
    });

    test('字型家族名對映 ReaderFontFamily.family', () {
      expect(
        ReaderStyle.from(
          const ReaderSettings(fontFamily: ReaderFontFamily.serif),
          night,
        ).fontFamily,
        'NotoSerifTC',
      );
      expect(
        ReaderStyle.from(
          const ReaderSettings(fontFamily: ReaderFontFamily.sans),
          night,
        ).fontFamily,
        'NotoSansTC',
      );
      // 圓體 → RoundedTC（bundled asset，對齊 api-ver）。
      expect(
        ReaderStyle.from(
          const ReaderSettings(fontFamily: ReaderFontFamily.rounded),
          night,
        ).fontFamily,
        'RoundedTC',
      );
    });

    test('字級/行距直接取自設定', () {
      const ReaderSettings s = ReaderSettings(fontSize: 24, lineSpacingDp: 12);
      final ReaderStyle st = ReaderStyle.from(s, night);
      expect(st.fontSizePx, 24);
      expect(st.lineExtraPx, 12);
    });
  });

  group('ReaderStyle.forMeasure（量測用）', () {
    test('取自 ReaderLayoutMetrics，顏色為量測占位（黑/白）', () {
      const ReaderLayoutMetrics m = ReaderLayoutMetrics(
        fontSizePx: 20,
        lineExtraPx: 8,
        paragraphDp: 8,
        availableWidth: 300,
        availableHeight: 1000,
      );
      final ReaderStyle st = ReaderStyle.forMeasure(m);
      expect(st.fontSizePx, 20);
      expect(st.lineExtraPx, 8);
      expect(st.paragraphTopPad, m.textTopPadding);
      expect(st.paragraphBotPad, m.textBottomPadding);
      expect(st.smallReductionPx, m.smallReductionPx);
      expect(st.fontFamily, m.fontFamily); // 'NotoSerifTC'
      expect(st.textColor, const Color(0xFF000000));
      expect(st.bgColor, const Color(0xFFFFFFFF));
    });
  });

  test('== / hashCode 隨欄位變化', () {
    const ReaderTheme t = ReaderTheme(
      id: 'x',
      name: 'x',
      builtIn: true,
      textColor: 0xFF111111,
      bgColor: 0xFF222222,
    );
    final ReaderStyle a =
        ReaderStyle.from(const ReaderSettings(fontSize: 20), t);
    final ReaderStyle b =
        ReaderStyle.from(const ReaderSettings(fontSize: 20), t);
    final ReaderStyle c =
        ReaderStyle.from(const ReaderSettings(fontSize: 22), t);
    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a, isNot(c));
  });
}
