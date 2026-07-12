import 'package:flutter/widgets.dart';

/// 動效 token（時長 / 曲線）。集中命名讓轉場一致。
class AppMotion {
  AppMotion._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);

  /// 頁面級過渡（路由切換、仿真翻頁補間）。閱讀器移植新增（對齊 api-ver）。
  static const Duration page = Duration(milliseconds: 320);

  /// 一般進出場曲線。
  static const Curve standard = Curves.easeInOutCubic;

  /// 強調（進場）曲線。
  static const Curve emphasized = Curves.easeOutCubic;

  /// reduce-motion 查詢：使用者於系統無障礙設定要求「移除動畫」時回 true。閱讀器移植新增。
  static bool reduceMotion(BuildContext context) =>
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  /// 依 reduce-motion 決定時長：開啟時折為 [Duration.zero]，否則回 [base]。閱讀器移植新增。
  static Duration durationOf(BuildContext context, Duration base) =>
      reduceMotion(context) ? Duration.zero : base;
}
