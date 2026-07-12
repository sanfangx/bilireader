import 'package:bilireader_app/core/storage/database/app_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// 忠實移植 Step 1：drift reader 資料層 round-trip（in-memory DB，驗證 schema/DAO 實際能跑）。
void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  test('章節快取 round-trip + id guard', () async {
    await db.chapterCacheDao.saveChapterContent(
        articleId: 2013, chapterId: 317878, payload: '{"blocks":[]}', updatedAt: 100);
    final row = await db.chapterCacheDao.getChapterContent(2013, 317878);
    expect(row, isNotNull);
    expect(row!.payload, '{"blocks":[]}');
    expect(await db.chapterCacheDao.getChapterContent(0, 1), isNull); // guard id<=0
  });

  test('進度 upsert + LRU pruneToRecent 只留最新 2 本', () async {
    for (var i = 1; i <= 4; i++) {
      await db.readingProgressDao.upsertProgress(
        ReadingProgressRowsCompanion.insert(
          ownerUid: 1,
          articleId: i,
          chapterId: 0,
          sourceTextOffset: 0,
          anchorJson: '{}',
          updatedAt: Value(i * 10),
        ),
      );
    }
    expect((await db.readingProgressDao.getAllProgress(1)).length, 4);
    await db.readingProgressDao.pruneToRecent(1, 2);
    final kept = await db.readingProgressDao.getAllProgress(1);
    expect(kept.length, 2);
    expect(kept.map((r) => r.articleId).toSet(), <int>{3, 4});
  });

  test('書籤 insert / 查 / 刪', () async {
    final id = await db.bookmarkDao.insertBookmark(
      BookmarkRowsCompanion.insert(
        ownerUid: 1,
        articleId: 2013,
        chapterId: 317878,
        sourceTextOffset: 42,
        anchorJson: '{"charOffset":42}',
        chapterName: const Value('序章'),
        updatedAt: const Value(5),
      ),
    );
    var marks = await db.bookmarkDao.getBookmarks(1, 2013);
    expect(marks.length, 1);
    expect(marks.first.chapterName, '序章');
    await db.bookmarkDao.deleteBookmark(id);
    expect(await db.bookmarkDao.getBookmarks(1, 2013), isEmpty);
  });
}
