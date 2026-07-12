import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// App 本地資料庫（忠實移植自 api-ver，只保留閱讀器需要的表/DAO）。
/// 章節/目錄為可重建快取；書籤/進度為使用者資料。
@DriftDatabase(
  tables: <Type>[
    ChapterContents,
    ChapterCatalogs,
    BookmarkRows,
    ReadingProgressRows,
  ],
  daos: <Type>[
    ChapterCacheDao,
    BookmarkDao,
    ReadingProgressDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  AppDatabase.open() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) => m.createAll(),
        onUpgrade: (Migrator m, int from, int to) async {
          // schema 變更需提供 migration：快取表（章節/目錄）可 drop+rebuild；
          // 使用者資料（bookmarks/reading_progress）須逐步 migrate 保留。v1 初版。
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final File file = File(p.join(dir.path, 'bilireader.db'));
    return NativeDatabase.createInBackground(file);
  });
}

/// 章節正文與目錄的永久快取存取（guard：article/chapter id 必須 > 0）。
@DriftAccessor(tables: <Type>[ChapterContents, ChapterCatalogs])
class ChapterCacheDao extends DatabaseAccessor<AppDatabase>
    with _$ChapterCacheDaoMixin {
  ChapterCacheDao(super.db);

  Future<ChapterContentRow?> getChapterContent(
    int articleId,
    int chapterId,
  ) async {
    if (articleId <= 0 || chapterId <= 0) {
      return null;
    }
    return (select(chapterContents)
          ..where(
            (ChapterContents t) =>
                t.articleId.equals(articleId) & t.chapterId.equals(chapterId),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> saveChapterContent({
    required int articleId,
    required int chapterId,
    required String payload,
    required int updatedAt,
  }) async {
    if (articleId <= 0 || chapterId <= 0) {
      return;
    }
    await into(chapterContents).insert(
      ChapterContentsCompanion.insert(
        articleId: articleId,
        chapterId: chapterId,
        payload: payload,
        updatedAt: updatedAt,
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<void> deleteChapterContent(int articleId, int chapterId) async {
    await (delete(chapterContents)..where(
          (ChapterContents t) =>
              t.articleId.equals(articleId) & t.chapterId.equals(chapterId),
        ))
        .go();
  }

  Future<ChapterCatalogRow?> getCatalog(int articleId) async {
    if (articleId <= 0) {
      return null;
    }
    return (select(chapterCatalogs)
          ..where((ChapterCatalogs t) => t.articleId.equals(articleId))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> saveCatalog({
    required int articleId,
    required String articleName,
    required String payload,
    required int updatedAt,
  }) async {
    if (articleId <= 0) {
      return;
    }
    await into(chapterCatalogs).insert(
      ChapterCatalogsCompanion.insert(
        articleId: Value(articleId),
        articleName: articleName,
        payload: payload,
        updatedAt: updatedAt,
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<void> deleteCatalog(int articleId) async {
    await (delete(
      chapterCatalogs,
    )..where((ChapterCatalogs t) => t.articleId.equals(articleId))).go();
  }

  Future<List<int>> getAllCatalogArticleIds() async {
    final List<ChapterCatalogRow> rows =
        await (select(chapterCatalogs)
              ..orderBy(<OrderClauseGenerator<ChapterCatalogs>>[
                (ChapterCatalogs t) => OrderingTerm.desc(t.updatedAt),
              ]))
            .get();
    return rows.map((ChapterCatalogRow r) => r.articleId).toList();
  }
}

/// 手動書籤存取。
@DriftAccessor(tables: <Type>[BookmarkRows])
class BookmarkDao extends DatabaseAccessor<AppDatabase> with _$BookmarkDaoMixin {
  BookmarkDao(super.db);

  Future<int> insertBookmark(BookmarkRowsCompanion companion) =>
      into(bookmarkRows).insert(companion);

  Future<List<BookmarkRow>> getBookmarks(int ownerUid, int articleId) {
    return (select(bookmarkRows)
          ..where(
            (BookmarkRows t) =>
                t.ownerUid.equals(ownerUid) & t.articleId.equals(articleId),
          )
          ..orderBy(<OrderClauseGenerator<BookmarkRows>>[
            (BookmarkRows t) => OrderingTerm.desc(t.updatedAt),
          ]))
        .get();
  }

  Future<List<BookmarkRow>> getAllBookmarks(int ownerUid) {
    return (select(bookmarkRows)
          ..where((BookmarkRows t) => t.ownerUid.equals(ownerUid))
          ..orderBy(<OrderClauseGenerator<BookmarkRows>>[
            (BookmarkRows t) => OrderingTerm.desc(t.updatedAt),
          ]))
        .get();
  }

  Future<void> deleteBookmark(int id) async {
    await (delete(
      bookmarkRows,
    )..where((BookmarkRows t) => t.id.equals(id))).go();
  }

  Future<void> clearOwner(int ownerUid) async {
    await (delete(
      bookmarkRows,
    )..where((BookmarkRows t) => t.ownerUid.equals(ownerUid))).go();
  }
}

/// 閱讀進度存取（每本一筆）。提供 watch 供書架即時更新。
@DriftAccessor(tables: <Type>[ReadingProgressRows])
class ReadingProgressDao extends DatabaseAccessor<AppDatabase>
    with _$ReadingProgressDaoMixin {
  ReadingProgressDao(super.db);

  Future<void> upsertProgress(ReadingProgressRowsCompanion companion) async {
    await into(
      readingProgressRows,
    ).insert(companion, mode: InsertMode.insertOrReplace);
  }

  Future<ReadingProgressRow?> getProgress(int ownerUid, int articleId) async {
    if (ownerUid <= 0 || articleId <= 0) {
      return null;
    }
    return (select(readingProgressRows)
          ..where(
            (ReadingProgressRows t) =>
                t.ownerUid.equals(ownerUid) & t.articleId.equals(articleId),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<ReadingProgressRow>> getAllProgress(int ownerUid) {
    return (select(readingProgressRows)
          ..where((ReadingProgressRows t) => t.ownerUid.equals(ownerUid))
          ..orderBy(<OrderClauseGenerator<ReadingProgressRows>>[
            (ReadingProgressRows t) => OrderingTerm.desc(t.updatedAt),
          ]))
        .get();
  }

  /// 書架「繼續閱讀」觀察此串流，閱讀器寫入後即時刷新。
  Stream<List<ReadingProgressRow>> watchAllProgress(int ownerUid) {
    return (select(readingProgressRows)
          ..where((ReadingProgressRows t) => t.ownerUid.equals(ownerUid))
          ..orderBy(<OrderClauseGenerator<ReadingProgressRows>>[
            (ReadingProgressRows t) => OrderingTerm.desc(t.updatedAt),
          ]))
        .watch();
  }

  Future<void> clearOwner(int ownerUid) async {
    await (delete(
      readingProgressRows,
    )..where((ReadingProgressRows t) => t.ownerUid.equals(ownerUid))).go();
  }

  /// LRU 裁剪：只保留該使用者最近 [keep] 本書的進度（依 updatedAt 由新到舊），其餘刪除。
  Future<void> pruneToRecent(int ownerUid, int keep) async {
    if (keep <= 0) {
      return;
    }
    final List<ReadingProgressRow> rows =
        await (select(readingProgressRows)
              ..where((ReadingProgressRows t) => t.ownerUid.equals(ownerUid))
              ..orderBy(<OrderClauseGenerator<ReadingProgressRows>>[
                (ReadingProgressRows t) => OrderingTerm.desc(t.updatedAt),
              ]))
            .get();
    if (rows.length <= keep) {
      return;
    }
    final List<int> staleArticleIds = rows
        .skip(keep)
        .map((ReadingProgressRow r) => r.articleId)
        .toList();
    await (delete(readingProgressRows)..where(
          (ReadingProgressRows t) =>
              t.ownerUid.equals(ownerUid) & t.articleId.isIn(staleArticleIds),
        ))
        .go();
  }
}
