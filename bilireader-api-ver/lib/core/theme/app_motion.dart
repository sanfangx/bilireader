import 'package:flutter/widgets.dart';

/// 動效 token（規範 §5.1.2「一致的進場、退場、切換與層級過渡」）。動畫時長不得
/// 散落為畫面檔的字面 `Duration`；一律引用此處。透過 [durationOf] 讓 reduce-motion
/// （`MediaQuery.disableAnimations`，F-22）自動折為 [Duration.zero]。
abstract final class AppMotion {
  /// 小型狀態切換（膠囊選中、圖示淡入、頁碼點、工具列淡入淡出）。
  static const Duration fast = Duration(milliseconds: 150);

  /// 一般過渡（loading→content 淡入、面板展開）。
  static const Duration normal = Duration(milliseconds: 240);

  /// 頁面級過渡（路由切換、仿真翻頁補間）。
  static const Duration page = Duration(milliseconds: 320);

  /// Material 3 standard easing（進出對稱的一般過渡）。
  static const Curve standard = Cubic(0.2, 0.0, 0.0, 1.0);

  /// Material 3 emphasized easing（強調型、較長的過渡；Flutter 內建對應曲線）。
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;

  /// reduce-motion 查詢：使用者於系統無障礙設定要求「移除動畫」時回 true（F-22）。
  static bool reduceMotion(BuildContext context) =>
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  /// 依 reduce-motion 決定時長：開啟時折為 [Duration.zero]（等同停用動畫），
  /// 否則回 [base]。動畫消費點以此取代直接引用時長常數。
  static Duration durationOf(BuildContext context, Duration base) =>
      reduceMotion(context) ? Duration.zero : base;
}
