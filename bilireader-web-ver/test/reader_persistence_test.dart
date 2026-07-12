import 'package:bilireader_app/core/storage/database/app_database.dart';
import 'package:bilireader_app/features/reader/data/bookmark_local_data_source.dart';
import 'package:bilireader_app/features/reader/data/reading_progress_local_data_source.dart';
import 'package:bilireader_app/features/reader/domain/bookmark.dart';
import 'package:bilireader_app/features/reader/domain/reader_anchor.dart';
import 'package:bilireader_app/features/reader/domain/reading_progress.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// 忠實移植 Step 6.5：進度/書籤持久層（domain ↔ drift row，透過真實 anchorJson 路徑）。
void main() {
  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  const ReaderAnchor anchor = ReaderAnchor(
    articleId: 2013,
    chapterId: 5,
    chapterName: '第五章',
    sourceTextOffset: 120,
    visibleTextOffset: 118,
    blockIndex: 7,
    textQuote: '眼前是懸崖',
    progressInChapter: 0.42,
    createdAt: 111,
    updatedAt: 222,
  );

  group('ReadingProgress', () {
    test('save → get round-trip：拆欄位 + anchorJson 完整還原', () async {
      final ReadingProgressLocalDataSource ds =
          ReadingProgressLocalDataSource(db.readingProgressDao);
      const ReadingProgress p = ReadingProgress(
        ownerUid: 7,
        anchor: anchor,
        articleName: '無職轉生',
        poster: 'https://tw.linovelib.com/p.jpg',
        updatedAt: 999,
      );
      await ds.save(p);

      final ReadingProgress? got = await ds.get(7, 2013);
      expect(got, isNotNull);
      expect(got!.anchor, anchor); // 完整 anchor round-trip
      expect(got.anchor.sourceTextOffset, 120);
      expect(got.anchor.progressInChapter, 0.42);
      expect(got.articleName, '無職轉生');
      expect(got.poster, 'https://tw.linovelib.com/p.jpg');
      expect(got.updatedAt, 999);
    });

    test('每本一筆 upsert（同 owner+article 覆蓋）', () async {
      final ReadingProgressLocalDataSource ds =
          ReadingProgressLocalDataSource(db.readingProgressDao);
      await ds.save(const ReadingProgress(
          ownerUid: 7, anchor: anchor, articleName: 'a', updatedAt: 1));
      await ds.save(ReadingProgress(
          ownerUid: 7,
          anchor: anchor.copyWith(sourceTextOffset: 500),
          articleName: 'a',
          updatedAt: 2));
      final List<ReadingProgress> all = await ds.getAll(7);
      expect(all.length, 1); // 未新增，覆蓋
      expect(all.single.anchor.sourceTextOffset, 500);
    });

    test('watchAll 串流即時反映寫入', () async {
      final ReadingProgressLocalDataSource ds =
          ReadingProgressLocalDataSource(db.readingProgressDao);
      final Future<List<ReadingProgress>> firstNonEmpty = ds
          .watchAll(7)
          .firstWhere((List<ReadingProgress> l) => l.isNotEmpty);
      await ds.save(const ReadingProgress(
          ownerUid: 7, anchor: anchor, articleName: 'a', updatedAt: 1));
      final List<ReadingProgress> emitted = await firstNonEmpty;
      expect(emitted.single.articleName, 'a');
    });

    test('owner 隔離：不同 uid 互不可見', () async {
      final ReadingProgressLocalDataSource ds =
          ReadingProgressLocalDataSource(db.readingProgressDao);
      await ds.save(const ReadingProgress(
          ownerUid: 7, anchor: anchor, articleName: 'a', updatedAt: 1));
      expect(await ds.get(8, 2013), isNull);
      expect(await ds.get(7, 2013), isNotNull);
    });
  });

  group('Bookmark', () {
    test('save → getForBook → delete', () async {
      final BookmarkLocalDataSource ds =
          BookmarkLocalDataSource(db.bookmarkDao);
      const Bookmark b = Bookmark(
        ownerUid: 3,
        anchor: anchor,
        articleName: '無職轉生',
        poster: 'p',
      );
      final int id = await ds.save(b);
      expect(id, greaterThan(0));

      final List<Bookmark> list = await ds.getForBook(3, 2013);
      expect(list.length, 1);
      expect(list.single.id, id);
      expect(list.single.anchor, anchor);
      expect(list.single.articleName, '無職轉生');

      await ds.delete(id);
      expect((await ds.getForBook(3, 2013)).length, 0);
    });

    test('多書籤 + owner 隔離 + clearOwner', () async {
      final BookmarkLocalDataSource ds =
          BookmarkLocalDataSource(db.bookmarkDao);
      await ds.save(const Bookmark(ownerUid: 3, anchor: anchor, articleName: 'a'));
      await ds.save(Bookmark(
          ownerUid: 3,
          anchor: anchor.copyWith(sourceTextOffset: 300),
          articleName: 'a'));
      await ds.save(const Bookmark(ownerUid: 9, anchor: anchor, articleName: 'b'));

      expect((await ds.getForBook(3, 2013)).length, 2);
      expect((await ds.getAll(9)).length, 1);

      await ds.clearOwner(3);
      expect((await ds.getForBook(3, 2013)).length, 0);
      expect((await ds.getAll(9)).length, 1); // 別的 owner 不受影響
    });
  });
}
