import 'package:flutter/widgets.dart';

/// 圓角 token（對齊設計稿：封面 10 / 按鈕 14 / 卡片 18 / 大表面 22）。
class AppRadius {
  AppRadius._();

  static const double xs = 6;
  static const double sm = 10; // 封面 / 小圖
  static const double md = 14; // 按鈕 / 輸入框
  static const double lg = 18; // 卡片 / 統計列
  static const double xl = 22; // bottom sheet / 大表面
  static const double pill = 999; // 膠囊

  static BorderRadius all(double r) => BorderRadius.circular(r);
  static const BorderRadius pillR = BorderRadius.all(Radius.circular(pill));
}
