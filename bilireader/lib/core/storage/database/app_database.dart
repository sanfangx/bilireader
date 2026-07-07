import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

/// App 本地資料庫（規範 §7.5）。整合章節/目錄永久快取、私訊 owner-scoped 快取、
/// 書籤與閱讀進度。章節/目錄/私訊為可重建快取；書籤/進度為使用者資料。
@DriftDatabase(
  tables: <Type>[
    ChapterContents,
    ChapterCatalogs,
    PrivateMessages,
    ConversationSyncs,
    BookmarkRows,
    ReadingProgressRows,
  ],
  daos: <Type>[
    ChapterCacheDao,
    BookmarkDao,
    ReadingProgressDao,
    PrivateMessageDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// 正式環境：開啟 app documents 目錄下的資料庫檔。
  AppDatabase.open() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) => m.createAll(),
    onUpgrade: (Migrator m, int from, int to) async {
      // 規範 §7.5：schema 變更必須提供 migration，不得破壞既有資料。
      // 快取表（章節/目錄/私訊）可視情況 drop+rebuild；使用者資料
      // （bookmarks/reading_progress）必須逐步 migrate 保留。v1 初版，尚無升級步驟。
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

/// 章節正文與目錄的永久快取存取（doc 06；guard：article/chapter id 必須 > 0）。
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

  /// 依 updated_at 由新到舊回傳所有已快取目錄的 articleId。
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

/// 手動書籤存取（規範 §5.5、§7.5）。
@DriftAccessor(tables: <Type>[BookmarkRows])
class BookmarkDao extends DatabaseAccessor<AppDatabase>
    with _$BookmarkDaoMixin {
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

/// 閱讀進度存取（每本一筆，規範 §5.5）。提供 watch 供書架即時更新。
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

  /// 書架「繼續閱讀」觀察此串流，閱讀器寫入後即時刷新（規範 §5.5、§6.2）。
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
  /// 避免逐本累積無限成長（§5.5「明確策略」，使用者決策）。
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

/// 私訊 owner-scoped 快取存取（doc 06）。
@DriftAccessor(tables: <Type>[PrivateMessages, ConversationSyncs])
class PrivateMessageDao extends DatabaseAccessor<AppDatabase>
    with _$PrivateMessageDaoMixin {
  PrivateMessageDao(super.db);

  Future<void> upsertMessages(List<PrivateMessagesCompanion> rows) async {
    await batch((Batch b) {
      for (final PrivateMessagesCompanion row in rows) {
        b.insert(privateMessages, row, mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<List<PrivateMessageRow>> getMessages(int ownerUid, int peerId) {
    return _conversationQuery(ownerUid, peerId).get();
  }

  /// 觀察某對話的訊息（私訊對話頁即時更新：WS 收訊 upsert 後串流自動刷新，§5.5/doc 06）。
  Stream<List<PrivateMessageRow>> watchMessages(int ownerUid, int peerId) {
    return _conversationQuery(ownerUid, peerId).watch();
  }

  SimpleSelectStatement<PrivateMessages, PrivateMessageRow> _conversationQuery(
    int ownerUid,
    int peerId,
  ) {
    return select(privateMessages)
      ..where(
        (PrivateMessages t) =>
            t.ownerUid.equals(ownerUid) & t.peerId.equals(peerId),
      )
      ..orderBy(<OrderClauseGenerator<PrivateMessages>>[
        (PrivateMessages t) => OrderingTerm.asc(t.postDate),
        (PrivateMessages t) => OrderingTerm.asc(t.messageId),
      ]);
  }

  Future<void> markSynced(int ownerUid, int peerId, int nowMs) async {
    await into(conversationSyncs).insert(
      ConversationSyncsCompanion.insert(
        ownerUid: ownerUid,
        peerId: peerId,
        lastSyncAt: nowMs,
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  Future<bool> shouldSync(
    int ownerUid,
    int peerId, {
    required int maxAgeMs,
    required int nowMs,
  }) async {
    final ConversationSyncRow? row =
        await (select(conversationSyncs)
              ..where(
                (ConversationSyncs t) =>
                    t.ownerUid.equals(ownerUid) & t.peerId.equals(peerId),
              )
              ..limit(1))
            .getSingleOrNull();
    if (row == null) {
      return true;
    }
    return nowMs - row.lastSyncAt >= maxAgeMs;
  }

  /// 登出 / 401 / 666：清該 owner 的所有私訊與同步紀錄（doc 06 clearOwner）。
  Future<void> clearOwner(int ownerUid) async {
    await (delete(
      privateMessages,
    )..where((PrivateMessages t) => t.ownerUid.equals(ownerUid))).go();
    await (delete(
      conversationSyncs,
    )..where((ConversationSyncs t) => t.ownerUid.equals(ownerUid))).go();
  }
}
