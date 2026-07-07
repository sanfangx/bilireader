import 'package:flutter/painting.dart';

/// 圓角 token（規範 §5.1、§5.1.1）。膠囊型 `pill = 999` 是設計稿高頻語言，
/// 不得散落在畫面檔以 `borderRadius: 999` 硬寫。
abstract final class AppRadius {
  /// 膠囊 / pill（chip、segmented、reaction pill、pill CTA、FAB）。
  static const double pill = 999;

  /// 首頁輪播 Banner（設計稿 `.caro` radius 22）。
  static const double banner = 22;

  /// 大面板 / bottom sheet 頂角。
  static const double xl = 26;

  /// 卡片 / 詳情封面 / 搜尋框 / 統計盒 / 主 CTA（設計稿 `.dtcov`/`.hsearch`/
  /// `.dtstats`/`.pri` 皆為 16）。
  static const double card = 16;

  /// 卡片 / 對話框（設計稿部分面板 18）。
  static const double lg = 18;

  /// 主要按鈕 / 搜尋框 / 動作卡（設計稿 `.srbox`/`.dactc`/`.dsec` 為 14）。
  static const double button = 14;

  static const double md = 12;

  /// 清單書封（設計稿 `.lbcov` radius 10）。
  static const double sm = 10;

  /// 方角多選膠囊（設計稿 `.fo` radius 8）。
  static const double xs = 8;

  /// 小型狀態徽章（level / hot）。
  static const double badge = 6;
  static const double badgeSm = 4;

  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
  static const BorderRadius buttonAll = BorderRadius.all(
    Radius.circular(button),
  );
  static const BorderRadius cardAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius badgeAll = BorderRadius.all(Radius.circular(badge));
}
