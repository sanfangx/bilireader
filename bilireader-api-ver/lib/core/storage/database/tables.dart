import 'package:drift/drift.dart';

/// drift 資料表定義（規範 §7.5，對照 doc 06）。表名/欄位/PK/索引與原生 SQLite 對齊。

/// 章節正文永久快取（`novel_read_cache.db` → `novel_chapter_content`）。
/// 永久保存、無 TTL；寫入衝突 replace。PK(article_id, chapter_id)。
@DataClassName('ChapterContentRow')
class ChapterContents extends Table {
  IntColumn get articleId => integer()();
  IntColumn get chapterId => integer()();

  /// TextRequestEntity 的 JSON。
  TextColumn get payload => text()();

  /// 毫秒時間戳；僅供排序，不做過期判斷。
  IntColumn get updatedAt => integer()();

  @override
  String get tableName => 'novel_chapter_content';

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{articleId, chapterId};
}

/// 章節目錄永久快取（`novel_chapter_catalog`）。PK article_id。
@DataClassName('ChapterCatalogRow')
class ChapterCatalogs extends Table {
  IntColumn get articleId => integer()();
  TextColumn get articleName => text()();

  /// List&lt;ChapterRequestEntity&gt; 的 JSON。
  TextColumn get payload => text()();
  IntColumn get updatedAt => integer()();

  @override
  String get tableName => 'novel_chapter_catalog';

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{articleId};
}

/// 私訊 owner-scoped 快取（`private_chat.db` → `private_message`）。
/// `owner_uid` 為資料隔離鍵；PK(owner_uid, message_id)。
@DataClassName('PrivateMessageRow')
@TableIndex(
  name: 'idx_private_message_peer',
  columns: <Symbol>{#ownerUid, #peerId, #postDate},
)
class PrivateMessages extends Table {
  IntColumn get ownerUid => integer()();
  IntColumn get messageId => integer()();
  IntColumn get peerId => integer()();
  IntColumn get fromId => integer().nullable()();
  IntColumn get toId => integer().nullable()();
  TextColumn get fromName => text().nullable()();
  TextColumn get toName => text().nullable()();
  TextColumn get content => text().nullable()();
  IntColumn get quoteMessageId => integer().withDefault(const Constant(0))();
  IntColumn get quoteFromId => integer().withDefault(const Constant(0))();
  TextColumn get quoteFromName => text().withDefault(const Constant(''))();
  TextColumn get quoteContent => text().withDefault(const Constant(''))();
  IntColumn get postDate => integer().withDefault(const Constant(0))();
  TextColumn get title => text().nullable()();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();

  @override
  String get tableName => 'private_message';

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{ownerUid, messageId};
}

/// 私訊會話同步游標（`conversation_sync`）。PK(owner_uid, peer_id)。
@DataClassName('ConversationSyncRow')
class ConversationSyncs extends Table {
  IntColumn get ownerUid => integer()();
  IntColumn get peerId => integer()();
  IntColumn get lastSyncAt => integer()();

  @override
  String get tableName => 'conversation_sync';

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{ownerUid, peerId};
}

/// 手動書籤（多筆，規範 §5.5、§7.5）。保存完整 ReaderAnchor JSON 與書級中繼資料；
/// 核心索引 owner_uid+article_id+chapter_id+source_text_offset。
@DataClassName('BookmarkRow')
@TableIndex(
  name: 'idx_bookmarks_anchor',
  columns: <Symbol>{#ownerUid, #articleId, #chapterId, #sourceTextOffset},
)
class BookmarkRows extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ownerUid => integer()();
  IntColumn get articleId => integer()();
  IntColumn get chapterId => integer()();
  IntColumn get sourceTextOffset => integer()();
  TextColumn get anchorJson => text()();
  TextColumn get textQuote => text().withDefault(const Constant(''))();
  TextColumn get chapterName => text().withDefault(const Constant(''))();
  TextColumn get articleName => text().withDefault(const Constant(''))();
  TextColumn get poster => text().withDefault(const Constant(''))();
  IntColumn get createdAt => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();

  @override
  String get tableName => 'bookmarks';
}

/// 閱讀進度（每本一筆，規範 §5.5）。PK(owner_uid, article_id)。
@DataClassName('ReadingProgressRow')
class ReadingProgressRows extends Table {
  IntColumn get ownerUid => integer()();
  IntColumn get articleId => integer()();
  IntColumn get chapterId => integer()();
  IntColumn get sourceTextOffset => integer()();
  TextColumn get anchorJson => text()();
  TextColumn get textQuote => text().withDefault(const Constant(''))();
  TextColumn get chapterName => text().withDefault(const Constant(''))();
  TextColumn get articleName => text().withDefault(const Constant(''))();
  TextColumn get poster => text().withDefault(const Constant(''))();
  IntColumn get updatedAt => integer().withDefault(const Constant(0))();

  @override
  String get tableName => 'reading_progress';

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{ownerUid, articleId};
}
