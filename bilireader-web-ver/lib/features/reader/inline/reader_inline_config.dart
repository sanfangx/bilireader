/// 行內解析的站方 class 對應設定。
///
/// api-ver(readpai) 用 `<heimu>` 標籤與 `underdot/oversesame/overdot` class；
/// tw.linovelib（JieqiCMS）的黑幕/傍点很可能用不同的 `<span class=...>`。
/// **這些 class 名待以真實章節 innerHTML 抽樣校正**（見 _plan.md 增量 2/6 的驗證步驟：
/// 用 WebView console 對 `#acontent` 抽樣）；屆時改這裡一行即可，不動解析邏輯。
class ReaderInlineConfig {
  const ReaderInlineConfig({
    this.heimuClasses = const <String>{'heimu', 'hidden', 'spoiler'},
    this.underDotClasses = const <String>{'underdot', 'dot', 'zhuozhongdot'},
    this.overSesameClasses = const <String>{'oversesame', 'sesame'},
    this.overDotClasses = const <String>{'overdot'},
  });

  /// span/font 的 class 命中此集合 → 視為黑幕（劇透遮罩）。
  final Set<String> heimuClasses;

  /// 傍点（字下圓點）。
  final Set<String> underDotClasses;

  /// 傍点（字上芝麻點）。
  final Set<String> overSesameClasses;

  /// 傍点（字上圓點）。
  final Set<String> overDotClasses;

  static const ReaderInlineConfig defaults = ReaderInlineConfig();
}
