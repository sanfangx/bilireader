import 'package:flutter/material.dart';

/// 全域顏色 token。唯一視覺來源為 `design/bilireader_ui_design.html`
/// （單一深色主題：暖黑棕底 + 金色強調）。規範 §5.1：色值必須集中於此，
/// 不得在 Widget 內散落。原始 CSS 變數以註解對照。
abstract final class AppColors {
  // 核心 CSS 變數 --------------------------------------------------------
  /// `--bg`：App 背景（暖黑棕）。
  static const Color bg = Color(0xFF15110D);

  /// `--surf`：卡片 / 輸入框 / 未選中膠囊底。
  static const Color surf = Color(0xFF211A13);

  /// `--cov`：封面底 / 抬升面 / 選中的次要膠囊底。
  static const Color cov = Color(0xFF2A2118);

  /// `--txt`：主要文字（暖白）。
  static const Color txt = Color(0xFFECE3D4);

  /// `--mut`：次要文字 / 圖示。
  static const Color mut = Color(0xFF9A8C78);

  /// `--acc`：金色強調（主按鈕 / active / 連結）。
  static const Color acc = Color(0xFFCAA15C);

  /// `--btxt`：金色底上的深色文字。
  static const Color btxt = Color(0xFF1A140C);

  /// `--rtxt`：閱讀正文文字（比 --txt 略暖）。
  static const Color rtxt = Color(0xFFDED3C2);

  /// `--line`：髮絲分隔線 `rgba(255,255,255,.07)`。
  static const Color line = Color(0x12FFFFFF);

  // 金色 alpha 衍生（RGB 同 --acc #caa15c）------------------------------
  /// `rgba(202,161,92,.6)`：FAB 金色光暈。
  static const Color accGlow = Color(0x99CAA15C);

  /// `rgba(202,161,92,.5)`：選中膠囊 / 強調邊框。
  static const Color accBorderStrong = Color(0x80CAA15C);

  /// `rgba(202,161,92,.4)`：一般金色邊框。
  static const Color accBorder = Color(0x66CAA15C);

  /// `rgba(202,161,92,.3)`：柔和金色邊框。
  static const Color accBorderSoft = Color(0x4DCAA15C);

  /// `rgba(202,161,92,.28)`：極柔金色邊框。
  static const Color accBorderFaint = Color(0x47CAA15C);

  /// `rgba(202,161,92,.14)`：金色填色 / splash。
  static const Color accFill = Color(0x24CAA15C);

  // 語意色 ---------------------------------------------------------------
  /// 通知紅點 / 計數徽章 `#e5484d`。
  static const Color badgeRed = Color(0xFFE5484D);

  /// 熱門橘 `#e0894a`。
  static const Color hotOrange = Color(0xFFE0894A);

  /// 登出紅 `#cd8676`。
  static const Color logoutRed = Color(0xFFCD8676);

  /// 破壞性動作（刪除書籤等）強調色 `#cf7a6a`。
  static const Color danger = Color(0xFFCF7A6A);

  /// 黑幕 / 劇透遮罩 `#2b2b2b`。
  static const Color heimu = Color(0xFF2B2B2B);

  /// 模態遮罩 / barrier `rgba(0,0,0,.5)`（底部彈窗、對話框背幕）。
  static const Color scrim = Color(0x80000000);
}
