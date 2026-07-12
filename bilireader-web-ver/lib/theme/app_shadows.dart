import 'package:flutter/widgets.dart';

import 'app_colors.dart';

/// 陰影 token（深色主題用低調陰影 + 金色光暈）。
class AppShadows {
  AppShadows._();

  /// 卡片浮起陰影。
  static const List<BoxShadow> card = <BoxShadow>[
    BoxShadow(color: Color(0x40000000), blurRadius: 16, offset: Offset(0, 6)),
  ];

  /// 金色光暈（強調元件，如選中的膠囊 / 主按鈕）。
  static List<BoxShadow> glow(Color color, {double blur = 12, double alpha = 0.35}) =>
      <BoxShadow>[BoxShadow(color: color.withValues(alpha: alpha), blurRadius: blur)];

  /// 預設 acc 金色光暈。
  static List<BoxShadow> get accentGlow => glow(AppColors.acc);
}
