import 'dart:convert';

import 'package:bilireader/core/di/infra_providers.dart';
import 'package:bilireader/features/discover/presentation/search_controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> boot(Map<String, Object> seed) async {
  SharedPreferences.setMockInitialValues(seed);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final ProviderContainer c = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
  addTearDown(c.dispose);
  return c;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('F-34：add 後帶 updatedAt（約當下），state 只暴露查詢字串', () async {
    final ProviderContainer c = await boot(<String, Object>{});
    final int before = DateTime.now().millisecondsSinceEpoch;
    await c.read(searchHistoryProvider.notifier).add('無職轉生');
    final int after = DateTime.now().millisecondsSinceEpoch;

    expect(c.read(searchHistoryProvider), <String>['無職轉生']);
    final List<SearchHistoryEntry> entries = c
        .read(searchHistoryProvider.notifier)
        .entries();
    expect(entries.single.query, '無職轉生');
    expect(entries.single.updatedAt, inInclusiveRange(before, after));
  });

  test('F-34：同 query 二次 add → 去重且移到列首、updatedAt 更新', () async {
    final ProviderContainer c = await boot(<String, Object>{});
    final SearchHistory h = c.read(searchHistoryProvider.notifier);
    await h.add('A');
    await h.add('B');
    await h.add('A'); // 重複 → 去重 + 移列首
    expect(c.read(searchHistoryProvider), <String>['A', 'B']);
    final List<SearchHistoryEntry> e = h.entries();
    expect(e.map((SearchHistoryEntry x) => x.query), <String>['A', 'B']);
    expect(e.first.updatedAt, greaterThanOrEqualTo(e.last.updatedAt));
  });

  test('F-34：超過 10 筆截斷', () async {
    final ProviderContainer c = await boot(<String, Object>{});
    final SearchHistory h = c.read(searchHistoryProvider.notifier);
    for (int i = 0; i < 13; i++) {
      await h.add('q$i');
    }
    expect(c.read(searchHistoryProvider).length, 10);
    expect(c.read(searchHistoryProvider).first, 'q12'); // 最新在前
  });

  test('F-34：舊版 List<String> 自動遷移（updatedAt=0），且清舊鍵', () async {
    final ProviderContainer c = await boot(<String, Object>{
      'search_history': <String>['舊查詢1', '舊查詢2'],
    });
    // build 讀舊鍵 → 暴露查詢字串。
    expect(c.read(searchHistoryProvider), <String>['舊查詢1', '舊查詢2']);
    expect(c.read(searchHistoryProvider.notifier).entries().first.updatedAt, 0);

    // 一次 add 後遷移落地到新鍵、舊鍵清除。
    await c.read(searchHistoryProvider.notifier).add('新查詢');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getStringList('search_history'), isNull); // 舊鍵已清
    expect(prefs.getString('search_history_v2'), isNotNull); // 新鍵 JSON
    final List<Object?> decoded =
        jsonDecode(prefs.getString('search_history_v2')!) as List<Object?>;
    expect(decoded.first, containsPair('q', '新查詢'));
  });

  test('F-34：remove 單筆 / clear 全部', () async {
    final ProviderContainer c = await boot(<String, Object>{});
    final SearchHistory h = c.read(searchHistoryProvider.notifier);
    await h.add('A');
    await h.add('B');
    await h.remove('A');
    expect(c.read(searchHistoryProvider), <String>['B']);
    await h.clear();
    expect(c.read(searchHistoryProvider), <String>[]);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('search_history_v2'), isNull);
  });
}
