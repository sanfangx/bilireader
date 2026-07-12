import 'dart:convert';

import 'package:bilireader_app/core/models/catalog.dart';
import 'package:bilireader_app/core/storage/database/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// #3 目錄 drift 快取：Catalog 序列化 round-trip + ChapterCatalogs 存取。
void main() {
  test('Catalog toJson/fromJson round-trip 保卷/章/vip/url', () {
    final Catalog cat = Catalog(volumes: [
      Volume(name: '第一卷 幼年期', coverPath: '/files/x.jpg', chapters: const [
        Chapter(title: '插圖'),
        Chapter(title: '序章', url: 'https://tw.linovelib.com/novel/2013/1.html'),
        Chapter(
            title: 'VIP章',
            url: 'https://tw.linovelib.com/novel/2013/9.html',
            vip: true),
      ]),
      Volume(name: '第二卷', chapters: const [Chapter(title: '尾聲')]),
    ]);

    final Catalog back =
        Catalog.fromJson(jsonDecode(jsonEncode(cat.toJson())) as Map<String, dynamic>);

    expect(back.volumes.length, 2);
    expect(back.chapterCount, 4);
    expect(back.volumes.first.name, '第一卷 幼年期');
    expect(back.volumes.first.coverPath, '/files/x.jpg');
    final List<Chapter> ch = back.volumes.first.chapters;
    expect(ch[0].title, '插圖');
    expect(ch[0].url, isNull);
    expect(ch[1].url, 'https://tw.linovelib.com/novel/2013/1.html');
    expect(ch[1].id, '1'); // url→id 仍可解析
    expect(ch[2].vip, isTrue);
    expect(back.volumes[1].chapters.single.title, '尾聲');
  });

  test('ChapterCatalogs 存取：saveCatalog → getCatalog payload round-trip', () async {
    final AppDatabase db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final Catalog cat = Catalog(volumes: [
      Volume(name: 'v', chapters: const [Chapter(title: 'c', url: 'u')]),
    ]);
    await db.chapterCacheDao.saveCatalog(
      articleId: 2013,
      articleName: '無職轉生',
      payload: jsonEncode(cat.toJson()),
      updatedAt: 100,
    );
    final row = await db.chapterCacheDao.getCatalog(2013);
    expect(row, isNotNull);
    final Catalog restored =
        Catalog.fromJson(jsonDecode(row!.payload) as Map<String, dynamic>);
    expect(restored.volumes.single.chapters.single.title, 'c');
    // 刪除後 → null（供強制重整）。
    await db.chapterCacheDao.deleteCatalog(2013);
    expect(await db.chapterCacheDao.getCatalog(2013), isNull);
  });

  test('flattened()：閱讀順序攤平 + 每章貼所屬卷名（供閱讀器目錄分卷）', () {
    final Catalog cat = Catalog(volumes: [
      Volume(name: '1 幼年期', chapters: const [
        Chapter(title: '插圖'),
        Chapter(title: '序章', url: 'https://tw.linovelib.com/novel/2013/1.html'),
      ]),
      Volume(name: '2 少年期', chapters: const [
        Chapter(title: '第一話'),
        Chapter(title: '終章', vip: true),
      ]),
    ]);

    final List<Chapter> flat = cat.flattened();

    // 攤平順序＝閱讀順序（卷內、跨卷皆遞進）。
    expect(flat.map((c) => c.title).toList(), ['插圖', '序章', '第一話', '終章']);
    // 每章貼上所屬卷名。
    expect(flat.map((c) => c.volumeName).toList(),
        ['1 幼年期', '1 幼年期', '2 少年期', '2 少年期']);
    // 原欄位保留（url/vip）。
    expect(flat[1].url, 'https://tw.linovelib.com/novel/2013/1.html');
    expect(flat[3].vip, isTrue);
    // 空卷名 → volumeName 為 null（不會誤插空白分隔）。
    final Catalog noName = Catalog(volumes: [
      Volume(name: '', chapters: const [Chapter(title: 'x')]),
    ]);
    expect(noName.flattened().single.volumeName, isNull);
  });
}
