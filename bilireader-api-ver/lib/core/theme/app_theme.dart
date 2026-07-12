import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// 建立 App 的深色主題（規範 §5.1）。唯一視覺來源為設計稿的單一深色主題；
/// 不使用 Flutter 預設藍色主題。閱讀器另有專屬主題（Phase 5），不在此定義。
ThemeData buildDarkTheme() {
  final ColorScheme scheme = const ColorScheme.dark().copyWith(
    primary: AppColors.acc,
    onPrimary: AppColors.btxt,
    secondary: AppColors.acc,
    onSecondary: AppColors.btxt,
    surface: AppColors.surf,
    onSurface: AppColors.txt,
    error: AppColors.badgeRed,
    onError: Colors.white,
    outline: AppColors.line,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.bg,
    canvasColor: AppColors.bg,
    fontFamily: AppTypography.fontSans,
    textTheme: AppTypography.buildTextTheme(),
    dividerTheme: const DividerThemeData(
      color: AppColors.line,
      thickness: 1,
      space: 1,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      foregroundColor: AppColors.txt,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: AppTypography.titleLarge,
    ),
    iconTheme: const IconThemeData(color: AppColors.mut),
    splashColor: AppColors.accFill,
    highlightColor: AppColors.accFill,
  );
}
