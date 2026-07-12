import 'package:flutter/foundation.dart';

/// 書架成員變動事件匯流排（極輕量 ChangeNotifier）。
///
/// 加入/移除書架是無狀態網路呼叫（`addToShelf`/`removeFromShelf`），本身不通知任何
/// listenable；但書架分頁常駐於 IndexedStack（State 不重建）、「我的」收藏數是一次性
/// future，導致在詳情頁加/移書後這些畫面讀舊快照。任何成功的書架寫入呼叫 [bumped]，
/// 監聽者（書架頁 / 我的頁）即可重抓，達成跨頁一致。
class ShelfEvents extends ChangeNotifier {
  ShelfEvents._();
  static final ShelfEvents instance = ShelfEvents._();

  /// 書架成員（收藏/分組）已變動 → 通知監聽者重抓。
  void bumped() => notifyListeners();
}
