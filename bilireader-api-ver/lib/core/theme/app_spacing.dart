/// 間距 token（規範 §5.1）。設計稿畫面水平 padding 一致為 22px，
/// 其餘為觀察到的常見 gap 階梯。數值單位為邏輯像素。
abstract final class AppSpacing {
  /// 畫面水平 padding（設計稿一致 22px）。
  static const double screen = 22;

  static const double xxs = 4;
  static const double xs = 6;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 22;
  static const double huge = 26;

  /// 卡片內側 padding。
  static const double cardPadding = 12;
}
