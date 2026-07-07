import 'package:bilireader/core/storage/database/app_database.dart';
import 'package:bilireader/features/reader/data/bookmark_local_data_source.dart';
import 'package:bilireader/features/reader/data/reading_progress_local_data_source.dart';
import 'package:bilireader/features/reader/domain/bookmark.dart';
import 'package:bilireader/features/reader/domain/reader_anchor.dart';
import 'package:bilireader/features/reader/domain/reading_progress.dart';
import 'package:bilireader/features/reader/domain/reading_progress_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

ReaderAnchor _anchor({int article = 1, int chapter = 2, int offset = 300}) {
  return ReaderAnchor(
    articleId: article,
    chapterId: chapter,
    chapterName: '第二章',
    sourceTextOffset: offset,
    textQuote: '這是繁體中文的錨點文字片段',
    progressInChapter: 0.42,
    createdAt: 111,
    updatedAt: 222,
  );
}

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('BookmarkLocalDataSource', () {
    test('保存完整 ReaderAnchor 並讀回一致', () async {
      final BookmarkLocalDataSource ds = BookmarkLocalDataSource(
        db.bookmarkDao,
      );
      final int id = await ds.save(
        Bookmark(
          ownerUid: 7,
          anchor: _anchor(),
          articleName: '測試書',
          poster: 'p.png',
        ),
      );
      expect(id, greaterThan(0));

      final List<Bookmark> list = await ds.getForBook(7, 1);
      expect(list.length, 1);
      final Bookmark b = list.first;
      expect(b.ownerUid, 7);
      expect(b.articleName, '測試書');
      expect(b.poster, 'p.png');
      expect(b.anchor.sourceTextOffset, 300);
      expect(b.anchor.textQuote, '這是繁體中文的錨點文字片段');
      expect(b.anchor.progressInChapter, 0.42);
      expect(b.anchor.chapterName, '第二章');
    });

    test('clearOwner 只清該 owner', () async {
      final BookmarkLocalDataSource ds = BookmarkLocalDataSource(
        db.bookmarkDao,
      );
      await ds.save(Bookmark(ownerUid: 7, anchor: _anchor()));
      await ds.save(Bookmark(ownerUid: 8, anchor: _anchor()));
      await ds.clearOwner(7);
      expect(await ds.getAll(7), isEmpty);
      expect((await ds.getAll(8)).length, 1);
    });
  });

  group('ReadingProgressLocalDataSource', () {
    test('每本一筆 upsert（後寫覆蓋）', () async {
      final ReadingProgressLocalDataSource ds = ReadingProgressLocalDataSource(
        db.readingProgressDao,
      );
      await ds.save(
        ReadingProgress(
          ownerUid: 7,
          anchor: _anchor(offset: 100),
          articleName: '書',
          updatedAt: 100,
        ),
      );
      await ds.save(
        ReadingProgress(
          ownerUid: 7,
          anchor: _anchor(offset: 500),
          articleName: '書',
          updatedAt: 200,
        ),
      );

      final ReadingProgress? p = await ds.get(7, 1);
      expect(p, isNotNull);
      expect(p!.anchor.sourceTextOffset, 500);
      expect((await ds.getAll(7)).length, 1);
    });

    test('watch 於寫入後即時發射（書架繼續閱讀）', () async {
      final ReadingProgressLocalDataSource ds = ReadingProgressLocalDataSource(
        db.readingProgressDao,
      );
      final List<int> emissions = <int>[];
      final sub = ds
          .watchAll(7)
          .listen((List<ReadingProgress> list) => emissions.add(list.length));

      await Future<void>.delayed(Duration.zero);
      await ds.save(
        ReadingProgress(ownerUid: 7, anchor: _anchor(), updatedAt: 1),
      );
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await sub.cancel();

      expect(emissions.last, 1);
    });

    test('LRU 裁剪：超過上限只保留最近 N 本（最舊者被刪）', () async {
      final ReadingProgressLocalDataSource ds = ReadingProgressLocalDataSource(
        db.readingProgressDao,
      );
      // 存入上限 + 2 本，updatedAt 遞增（i 越大越新；articleId = i）。
      const int over = kMaxReadingProgressEntries + 2;
      for (int i = 1; i <= over; i++) {
        await ds.save(
          ReadingProgress(
            ownerUid: 7,
            anchor: _anchor(article: i, offset: i),
            articleName: '書$i',
            updatedAt: i,
          ),
        );
      }

      // 只保留最近 N 本；最舊兩本（article 1、2）被刪；最新者仍在。
      expect((await ds.getAll(7)).length, kMaxReadingProgressEntries);
      expect(await ds.get(7, 1), isNull);
      expect(await ds.get(7, 2), isNull);
      expect(await ds.get(7, 3), isNotNull);
      expect(await ds.get(7, over), isNotNull);
    });

    test('LRU 裁剪只影響該 owner', () async {
      final ReadingProgressLocalDataSource ds = ReadingProgressLocalDataSource(
        db.readingProgressDao,
      );
      // owner 8 只有 1 本，不應被 owner 7 的裁剪波及。
      await ds.save(
        ReadingProgress(
          ownerUid: 8,
          anchor: _anchor(article: 999),
          updatedAt: 1,
        ),
      );
      for (int i = 1; i <= kMaxReadingProgressEntries + 5; i++) {
        await ds.save(
          ReadingProgress(
            ownerUid: 7,
            anchor: _anchor(article: i),
            updatedAt: i,
          ),
        );
      }
      expect((await ds.getAll(7)).length, kMaxReadingProgressEntries);
      expect((await ds.getAll(8)).length, 1);
    });
  });
}
