import 'dart:async';

import 'package:bilireader/core/storage/in_flight_deduper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('同一 key 併發只執行一次，完成後移除且可再次執行', () async {
    final InFlightDeduper<String, int> deduper = InFlightDeduper<String, int>();
    int calls = 0;
    final Completer<int> completer = Completer<int>();

    Future<int> task() {
      calls++;
      return completer.future;
    }

    final Future<int> f1 = deduper.run('k', task);
    final Future<int> f2 = deduper.run('k', task);
    expect(calls, 1);
    expect(deduper.isInFlight('k'), isTrue);

    completer.complete(42);
    expect(await f1, 42);
    expect(await f2, 42);
    await Future<void>.delayed(Duration.zero);
    expect(deduper.isInFlight('k'), isFalse);

    final int f3 = await deduper.run('k', () async => 7);
    expect(f3, 7);
    expect(calls, 1);
  });

  test('不同 key 各自執行', () async {
    final InFlightDeduper<int, int> deduper = InFlightDeduper<int, int>();
    expect(await deduper.run(1, () async => 10), 10);
    expect(await deduper.run(2, () async => 20), 20);
  });
}
