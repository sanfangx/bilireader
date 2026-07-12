import 'dart:convert';

import 'package:bilireader_app/core/offline/offline_store.dart';
import 'package:flutter_test/flutter_test.dart';

/// 下載暫停/停止/續傳：manifest 生命週期狀態持久化契約（跨 App 重啟續傳的依據）。
void main() {
  OfflineManifest make(OfflineStatus st, {int total = 3, int ok = 1}) =>
      OfflineManifest(
        novelId: '2013',
        title: '無職轉生',
        coverUrl: '/files/x.jpg',
        updatedAt: 100,
        status: st,
        chapters: List.generate(
          total,
          (i) => OfflineChapterMeta(i, '第$i章', i < ok,
              'https://tw.linovelib.com/novel/2013/$i.html', false),
        ),
      );

  OfflineManifest roundTrip(OfflineManifest m) =>
      OfflineManifest.fromJson(jsonDecode(jsonEncode(m.toJson())) as Map<String, dynamic>);

  test('status round-trip：四種下載狀態皆保留', () {
    for (final st in OfflineStatus.values) {
      expect(roundTrip(make(st)).status, st, reason: 'status $st 應 round-trip');
    }
  });

  test('okCount + 章節 round-trip', () {
    final back = roundTrip(make(OfflineStatus.paused, total: 5, ok: 2));
    expect(back.chapters.length, 5);
    expect(back.okCount, 2);
    expect(back.chapters[0].ok, isTrue);
    expect(back.chapters[4].ok, isFalse);
  });

  test('章節卷名 vol round-trip（離線閱讀器目錄分卷的依據）', () {
    final m = OfflineManifest(
      novelId: '2013',
      title: '無職轉生',
      coverUrl: null,
      updatedAt: 1,
      chapters: [
        OfflineChapterMeta(0, '插圖', true, 'u0', false, vol: '1 幼年期'),
        OfflineChapterMeta(1, '序章', true, 'u1', false, vol: '1 幼年期'),
        OfflineChapterMeta(2, '第一話', false, 'u2', false), // 舊/無卷名 → 保持 null
      ],
    );
    final back = roundTrip(m);
    expect(back.chapters[0].vol, '1 幼年期');
    expect(back.chapters[1].vol, '1 幼年期');
    expect(back.chapters[2].vol, isNull);
  });

  test('舊 manifest 無 st 欄位：全完成→done、部分完成→active（自動續傳修復卡死書）', () {
    Map<String, dynamic> legacy({required int total, required int ok}) => {
          'id': '2013',
          't': '無職轉生',
          'cv': null,
          'ts': 1,
          // 故意不含 'st'
          'ch': List.generate(
              total, (i) => {'i': i, 't': '第$i章', 'ok': i < ok, 'u': 'u$i', 'vip': false}),
        };
    expect(OfflineManifest.fromJson(legacy(total: 3, ok: 3)).status,
        OfflineStatus.done);
    expect(OfflineManifest.fromJson(legacy(total: 3, ok: 1)).status,
        OfflineStatus.active);
    // 空清單不誤判為完成。
    expect(OfflineManifest.fromJson(legacy(total: 0, ok: 0)).status,
        OfflineStatus.active);
  });
}
