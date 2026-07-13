import 'dart:async';
import 'dart:collection';

/// 全域出站請求限流器（單例）。所有走 dio 的 tw.linovelib.com 請求都經過它，
/// 以最小間隔 [gap] 序列化派發（FIFO），避免高頻突刺觸發 Cloudflare 限流。
///
/// 設計取捨：
/// - **Completer 喚醒排隊者，非忙等輪詢**（比參考專案 bili_novel_packer 的
///   Scheduler 1ms busy-wait 省電）。
/// - gap 預設偏「**互動友善**」而非參考專案的批次下載速率（15/分＝4 秒）——單一
///   互動請求（點書、翻頁）不該被硬塞 4 秒延遲。真正的封面圖並發突刺走
///   `Image.network`（**不經此限流器**），屬 follow-up：需自訂 ImageProvider /
///   CacheManager 才能治理。實際 gap 值待 Phase 0 對 CF 限流門檻實測後微調。
/// - [pause] / [resume] 供 CF 退避時暫停整個來源。
class RateLimiter {
  RateLimiter({this.gap = const Duration(milliseconds: 400)});

  /// 全域 HTML/API 限流器（封面圖不經此處，見類別註解）。
  static final RateLimiter global = RateLimiter();

  /// 兩次派發之間的最小間隔。
  final Duration gap;
  final Queue<Completer<void>> _waiters = Queue<Completer<void>>();
  DateTime? _lastDispatch;
  bool _paused = false;
  Timer? _timer;

  /// 目前排隊中的請求數。
  int get pending => _waiters.length;

  bool get isPaused => _paused;

  /// 排隊取得放行時槽後執行 [action]。
  Future<T> run<T>(Future<T> Function() action) async {
    await acquire();
    return action();
  }

  /// 僅取得放行時槽（呼叫端自行執行後續，供攔截器使用）。
  Future<void> acquire() {
    final c = Completer<void>();
    _waiters.add(c);
    _schedule();
    return c.future;
  }

  void _schedule() {
    if (_paused || _timer != null || _waiters.isEmpty) return;
    final now = DateTime.now();
    final earliest = _lastDispatch == null ? now : _lastDispatch!.add(gap);
    final wait =
        earliest.isAfter(now) ? earliest.difference(now) : Duration.zero;
    _timer = Timer(wait, _dispatch);
  }

  void _dispatch() {
    _timer = null;
    if (_paused || _waiters.isEmpty) return;
    _lastDispatch = DateTime.now();
    _waiters.removeFirst().complete();
    _schedule(); // 排下一個。
  }

  /// CF / 限流退避：暫停派發（進行中的請求不受影響）。
  void pause() {
    _paused = true;
    _timer?.cancel();
    _timer = null;
  }

  /// 恢復派發。
  void resume() {
    if (!_paused) return;
    _paused = false;
    _schedule();
  }
}
