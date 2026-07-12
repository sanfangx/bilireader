import 'package:bilireader_app/core/network/rate_limiter.dart';
import 'package:flutter_test/flutter_test.dart';

/// 驗證全域限流器（切片② x-arch）：序列化派發、FIFO、pause/resume。
/// 只做「下限」時間判定（Timer 只會晚不會早），避免真實計時器的抖動造成 flaky。
void main() {
  group('RateLimiter', () {
    test('以最小間隔序列化派發，且維持 FIFO 順序', () async {
      final rl = RateLimiter(gap: const Duration(milliseconds: 50));
      final order = <int>[];
      final times = <int>[];
      final sw = Stopwatch()..start();
      final futures = <Future<void>>[
        for (var i = 0; i < 4; i++)
          rl.run(() async {
            order.add(i);
            times.add(sw.elapsedMilliseconds);
          }),
      ];
      await Future.wait(futures);

      expect(order, <int>[0, 1, 2, 3], reason: 'FIFO 順序');
      // 第 4 個派發至少在 3*gap（=150ms）之後；給容差取 120ms 下限。
      expect(times.last, greaterThanOrEqualTo(120));
    });

    test('pause 阻擋派發、resume 後恢復', () async {
      final rl = RateLimiter(gap: Duration.zero);
      rl.pause();
      var done = false;
      final f = rl.run(() async => done = true);
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(done, isFalse, reason: '暫停中不應派發');
      expect(rl.isPaused, isTrue);

      rl.resume();
      await f;
      expect(done, isTrue);
    });

    test('run 回傳 action 的結果', () async {
      final rl = RateLimiter(gap: Duration.zero);
      final v = await rl.run(() async => 42);
      expect(v, 42);
    });
  });
}
