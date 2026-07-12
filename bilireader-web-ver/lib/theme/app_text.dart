import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// 字型 — 對齊設計稿：
/// - 標題 / 品牌：Noto Serif TC（--disp）
/// - 內文 / UI：Noto Sans TC（--sans）
/// - 數字 / 英文點綴：Space Grotesk（--mono）
class AppText {
  AppText._();

  /// 襯線標題（書名、品牌、章名）
  static TextStyle serif({
    double size = 16,
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.txt,
    double? letterSpacing,
    double? height,
  }) =>
      GoogleFonts.notoSerifTc(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );

  /// 無襯線內文 / UI
  static TextStyle sans({
    double size = 13,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.txt,
    double? letterSpacing,
    double? height,
  }) =>
      GoogleFonts.notoSansTc(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );

  /// 等寬點綴（頁碼、英文標、數字）
  static TextStyle mono({
    double size = 11,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.mut,
    double? letterSpacing,
  }) =>
      GoogleFonts.spaceGrotesk(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
      );
}
