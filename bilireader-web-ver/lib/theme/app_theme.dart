import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// App 全域主題（深色金）。
class AppTheme {
  AppTheme._();

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: base.colorScheme.copyWith(
        surface: AppColors.surf, // 修正：原本誤設為 bg，卡片/表面與底色無層次
        onSurface: AppColors.txt,
        primary: AppColors.acc,
        secondary: AppColors.acc,
        onPrimary: AppColors.btxt,
        error: AppColors.danger,
      ),
      textTheme: GoogleFonts.notoSansTcTextTheme(base.textTheme).apply(
        bodyColor: AppColors.txt,
        displayColor: AppColors.txt,
      ),
      dividerColor: AppColors.line,
      dividerTheme: const DividerThemeData(
        color: AppColors.line,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.mut),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bg,
        foregroundColor: AppColors.txt,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      splashColor: AppColors.acc.withValues(alpha: 0.10),
      highlightColor: Colors.transparent,
    );
  }
}
