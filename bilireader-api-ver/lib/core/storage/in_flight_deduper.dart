/// In-flight 請求去重（規範 §7.1、§7.5）。同一 key 的併發請求只實際執行一次，
/// 其餘呼叫等待同一個 Future，結果 fan-out。對照原生 chapter/catalog/text 的
/// `inFlight*Requests` 機制。
class InFlightDeduper<K, T> {
  final Map<K, Future<T>> _inFlight = <K, Future<T>>{};

  /// 若 [key] 已在執行中，回傳既有 Future；否則以 [task] 啟動並登記。
  Future<T> run(K key, Future<T> Function() task) {
    final Future<T>? existing = _inFlight[key];
    if (existing != null) {
      return existing;
    }
    final Future<T> future = task();
    _inFlight[key] = future;
    // 完成（含失敗）後移除；清理鏈的錯誤已由呼叫端持有的 future 處理，故忽略。
    future.whenComplete(() => _inFlight.remove(key)).ignore();
    return future;
  }

  bool isInFlight(K key) => _inFlight.containsKey(key);
}
