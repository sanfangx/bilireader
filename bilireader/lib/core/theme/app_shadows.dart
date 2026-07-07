import 'package:flutter/material.dart';

import 'app_colors.dart';

/// 陰影 token（規範 §5.1）。對照設計稿的 FAB 金色光暈、bottom sheet 與對話框陰影。
abstract final class AppShadows {
  /// FAB：金色光暈 + 背景色外環（`0 10px 26px -8px rgba(202,161,92,.6), 0 0 0 5px --bg`）。
  static const List<BoxShadow> fab = <BoxShadow>[
    BoxShadow(
      color: AppColors.accGlow,
      blurRadius: 26,
      spreadRadius: -8,
      offset: Offset(0, 10),
    ),
    BoxShadow(color: AppColors.bg, spreadRadius: 5),
  ];

  /// Bottom sheet（`0 -22px 50px rgba(0,0,0,.5)`）。
  static const List<BoxShadow> sheet = <BoxShadow>[
    BoxShadow(color: Color(0x80000000), blurRadius: 50, offset: Offset(0, -22)),
  ];

  /// 對話框（`0 30px 60px rgba(0,0,0,.6)`）。
  static const List<BoxShadow> dialog = <BoxShadow>[
    BoxShadow(color: Color(0x99000000), blurRadius: 60, offset: Offset(0, 30)),
  ];
}
