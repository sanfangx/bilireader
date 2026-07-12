import 'package:flutter/material.dart';

/// 設計色票 — 對齊 `ui_design.dc.html` 的 CSS 變數（.ph）。
/// 深色 + 香檳金主題（墨海 / 嗶哩）。
class AppColors {
  AppColors._();

  static const Color bg = Color(0xFF15110D); // --bg   底色
  static const Color surf = Color(0xFF211A13); // --surf 卡片/表面
  static const Color cov = Color(0xFF2A2118); // --cov  封面斜紋底
  static const Color txt = Color(0xFFECE3D4); // --txt  主要文字
  static const Color mut = Color(0xFF9A8C78); // --mut  次要/灰文字
  static const Color acc = Color(0xFFCAA15C); // --acc  金（強調）
  static const Color btxt = Color(0xFF1A140C); // --btxt 金底上的深字
  static const Color rtxt = Color(0xFFDED3C2); // --rtxt 內文閱讀色
  static const Color line = Color(0x12FFFFFF); // --line rgba(255,255,255,.07) 分隔線

  // ── 語意色（延伸：徽章 / 狀態 / 遮罩）──
  static const Color ok = Color(0xFF3FBF86); // 成功 / 已驗證（統一散落的硬編 0xFF3FBF86）
  static const Color danger = Color(0xFFE0555A); // 錯誤 / 危險
  static const Color badgeRed = Color(0xFFE0555A); // 未讀紅點
  static const Color hotOrange = Color(0xFFE08A3C); // 熱門 / 排行標記
  static const Color scrim = Color(0x99000000); // 遮罩 / 半透明底

  // ── acc 金色透明變體（膠囊填色 / 邊框 / 光暈）──
  static final Color accSoft = acc.withValues(alpha: 0.12); // 選中膠囊填色
  static final Color accBorder = acc.withValues(alpha: 0.35); // 邊框
  static final Color accGlow = acc.withValues(alpha: 0.30); // 光暈
}
