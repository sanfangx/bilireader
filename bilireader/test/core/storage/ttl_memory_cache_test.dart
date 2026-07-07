import 'package:bilireader/core/storage/ttl_memory_cache.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TtlMemoryCache', () {
    test('TTL 內命中，過期後 miss 並移除', () {
      final TtlMemoryCache<String, int> cache = TtlMemoryCache<String, int>(
        ttlMs: 600000,
      );
      cache.put('a', 1, nowMs: 0);
      expect(cache.get('a', nowMs: 500000), 1);
      expect(cache.get('a', nowMs: 700000), isNull);
      // 過期讀取已移除，再查仍為 null。
      expect(cache.get('a', nowMs: 700001), isNull);
    });

    test('remove 與 clear', () {
      final TtlMemoryCache<int, String> cache = TtlMemoryCache<int, String>(
        ttlMs: 1000,
      );
      cache.put(1, 'x', nowMs: 0);
      cache.remove(1);
      expect(cache.get(1, nowMs: 0), isNull);

      cache.put(2, 'y', nowMs: 0);
      cache.clear();
      expect(cache.get(2, nowMs: 0), isNull);
    });
  });
}
