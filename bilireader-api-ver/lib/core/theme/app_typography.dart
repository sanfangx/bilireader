import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 字體與文字樣式 token（規範 §5.1）。三個字族對照設計稿：
/// - [fontSans] Noto Sans TC：UI 文字。
/// - [fontSerif] Noto Serif TC：標題與閱讀正文。
/// - [fontMono] Space Grotesk：數字、時間、eyebrow。
///
/// 三者皆為可變字體，字重由 [TextStyle.fontWeight] 驅動 `wght` 軸。
abstract final class AppTypography {
  static const String fontSans = 'NotoSansTC';
  static const String fontSerif = 'NotoSerifTC';
  static const String fontMono = 'SpaceGrotesk';

  // 標題（serif）--------------------------------------------------------
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontSerif,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    height: 1.22,
    color: AppColors.txt,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontSerif,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.25,
    color: AppColors.txt,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: fontSerif,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.3,
    color: AppColors.txt,
  );

  // 標題 / 內文（sans）-------------------------------------------------
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontSans,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    color: AppColors.txt,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontSans,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.txt,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontSans,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.6,
    color: AppColors.txt,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontSans,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.6,
    color: AppColors.txt,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontSans,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.mut,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontSans,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.txt,
  );

  // 數字 / eyebrow（mono）---------------------------------------------
  static const TextStyle mono = TextStyle(
    fontFamily: fontMono,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.mut,
  );

  static const TextStyle eyebrow = TextStyle(
    fontFamily: fontMono,
    fontSize: 10.5,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
    color: AppColors.mut,
  );

  // 閱讀正文（serif 16.5 / 行高 2.15）---------------------------------
  static const TextStyle readerBody = TextStyle(
    fontFamily: fontSerif,
    fontSize: 16.5,
    height: 2.15,
    color: AppColors.rtxt,
  );

  /// 對映到 Material [TextTheme] 的常用 slot，讓內建 Widget 也走設計字體。
  static TextTheme buildTextTheme() {
    return const TextTheme(
      displayLarge: displayLarge,
      displayMedium: displayMedium,
      headlineSmall: headline,
      titleLarge: titleLarge,
      titleMedium: titleMedium,
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
    );
  }
}
