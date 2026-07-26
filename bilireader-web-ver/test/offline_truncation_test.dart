import 'dart:convert';
import 'dart:io';

import 'package:bilireader_app/core/offline/offline_store.dart';
import 'package:bilireader_app/features/reader/content_block.dart';
import 'package:flutter_test/flutter_test.dart';

/// 迴歸測試：離線檔的截斷自癒（P0-2 的復原半邊）。
///
/// 坑：截斷偵測原本只加在 `ChapterTextRepository`（線上擷取寫回 + 讀取），
/// 離線下載器直接寫檔並標 `ok: true`，兩端規則不對稱。於是在「不受信任的網路環境」
/// 下載的書，每章都是約 1/3 的殘缺正文，UI 顯示「下載完成」，但讀取端一律拒用
/// → 使用者得到一本「顯示已下載、離線卻一章都打不開」的書，且毫無徵兆。
///
/// 下載端加閘門後不會再產生新的壞檔，但**既有的壞檔仍在**，且原本兩個自救入口
/// （單章「重新擷取」、我的頁「清除章節快取」）都只清 drift，對離線檔零作用。
/// 故 `contentFor` 命中截斷檔時就地作廢：標回未完成 + 刪內容檔 → 下次「繼續下載」重抓。
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory root;
  final OfflineStore store = OfflineStore.instance;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('offline_trunc_test');
  });

  tearDown(() async {
    if (root.existsSync()) await root.delete(recursive: true);
  });

  /// 建立一本「已下載完成」的離線書，第 0 章內容為 [blocks]。
  Future<void> seed(String novelId, List<Map<String, String>> blocks) async {
    final Directory dir = Directory('${root.path}/$novelId');
    await dir.create(recursive: true);
    final OfflineManifest m = OfflineManifest(
      novelId: novelId,
      title: '測試書',
      coverUrl: null,
      updatedAt: 1,
      status: OfflineStatus.done,
      chapters: <OfflineChapterMeta>[
        OfflineChapterMeta(
          0,
          '第一章',
          true,
          'https://tw.linovelib.com/novel/$novelId/70001.html',
          false,
        ),
      ],
    );
    await File('${dir.path}/manifest.json')
        .writeAsString(jsonEncode(m.toJson()));
    await File('${dir.path}/ch_0.json').writeAsString(jsonEncode(blocks));
    await store.initAtForTest(root);
  }

  test('完整的離線章節照常回傳（自癒不得誤傷正常內容）', () async {
    await seed('9001', <Map<String, String>>[
      <String, String>{'t': 'p', 'v': '第一段正文。'},
      <String, String>{'t': 'p', 'v': '第二段正文。'},
      <String, String>{'t': 'p', 'v': '最後一段正文。'},
    ]);

    final ChapterContent? c = await store.contentFor(9001, 70001);
    expect(c, isNotNull);
    expect(c!.blocks.length, 3);
    expect(File('${root.path}/9001/ch_0.json').existsSync(), isTrue);
  });

  test('終端截斷的離線章節：回 null、標回未完成、刪內容檔', () async {
    await seed('9002', <Map<String, String>>[
      <String, String>{'t': 'p', 'v': '正文開頭。'},
      <String, String>{'t': 'p', 'v': '正文中段。'},
      <String, String>{'t': 'p', 'v': '（內容加載失敗！請重載或更換瀏覽器）'},
    ]);

    final ChapterContent? c = await store.contentFor(9002, 70001);

    expect(c, isNull, reason: '截斷檔不得當成有效離線內容回傳');
    // 標回未完成 → 下載管理看得出「需要繼續下載」，續傳會重抓這一章。
    final OfflineManifest back = OfflineManifest.fromJson(
      jsonDecode(File('${root.path}/9002/manifest.json').readAsStringSync())
          as Map<String, dynamic>,
    );
    expect(back.chapters.single.ok, isFalse);
    expect(back.status, OfflineStatus.paused);
    expect(back.okCount, 0);
    // 內容檔刪除 → 不會再被讀到，也不佔空間。
    expect(File('${root.path}/9002/ch_0.json').existsSync(), isFalse);
  });

  test('鐵律：標記落在中段視為誘餌，照常回傳（不得封鎖好章節）', () async {
    await seed('9003', <Map<String, String>>[
      <String, String>{'t': 'p', 'v': '正文開頭。'},
      <String, String>{'t': 'p', 'v': '（內容加載失敗！請重載或更換瀏覽器）'},
      <String, String>{'t': 'p', 'v': '之後還有很多正文。'},
      <String, String>{'t': 'p', 'v': '再一段。'},
      <String, String>{'t': 'p', 'v': '結尾正常。'},
    ]);

    final ChapterContent? c = await store.contentFor(9003, 70001);

    expect(c, isNotNull,
        reason: '中段標記是站方誘餌，只認終端截斷——見 chapter_text_assembler 的鐵律註解');
    expect(File('${root.path}/9003/ch_0.json').existsSync(), isTrue);
  });
}
