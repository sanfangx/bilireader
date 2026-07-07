/// 泛用記憶體快取（規範 §7.5：記憶體快取 TTL 10 分鐘）。採 cache-aside：
/// 讀取時若已過期則移除並回 `null`。[nowMs] 由呼叫端注入，便於測試。
///
/// 對照原生 `READ_CACHE_TTL_MS = 600000` 的 carousel/ranking/novelInfo/userInfo
/// 記憶體快取行為；章節正文/目錄不走此記憶體層（永久 SQLite 快取）。
class TtlMemoryCache<K, V> {
  TtlMemoryCache({required this.ttlMs});

  final int ttlMs;
  final Map<K, _CacheEntry<V>> _store = <K, _CacheEntry<V>>{};

  V? get(K key, {required int nowMs}) {
    final _CacheEntry<V>? entry = _store[key];
    if (entry == null) {
      return null;
    }
    if (nowMs - entry.cachedAtMs > ttlMs) {
      _store.remove(key);
      return null;
    }
    return entry.value;
  }

  void put(K key, V value, {required int nowMs}) {
    _store[key] = _CacheEntry<V>(value, nowMs);
  }

  void remove(K key) => _store.remove(key);

  void clear() => _store.clear();
}

class _CacheEntry<V> {
  const _CacheEntry(this.value, this.cachedAtMs);

  final V value;
  final int cachedAtMs;
}
