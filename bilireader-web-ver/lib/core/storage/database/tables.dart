import 'package:drift/drift.dart';

/// drift 資料表定義（忠實移植自 api-ver `core/storage/database/tables.dart`）。
/// 只含**閱讀器**相關表：章節/目錄快取、書籤、閱讀進度；
/// 私訊表（PrivateMessages/ConversationSyncs）不移植（web 端即時私訊不可行）。

/// 章節正文永久快取。永久保存、無 TTL；寫入衝突 replace。PK(article_id, chapter_id)。
/// web-ver：payload 存 WebView 擷取結果（章節內容）的 JSON。
@DataClassName('ChapterContentRow')
class ChapterContents extends Table {
  IntColumn get articleId => integer()();
  IntColumn get chapterId => integer()();

  /// 章節內容序列化 JSON。
  TextColumn get payload => text()();

  /// 毫秒時間戳；僅供排序，不做過期判斷。
  IntColumn get updatedAt => integer()();

  @override
  String get tableName => 'novel_chapter_content';

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{articleId, chapterId};
}

/// 章節目錄永久快取。PK article_id。
@DataClassName('ChapterCatalogRow')
class ChapterCatalogs extends Table {
  IntColumn get articleId => integer()();
  TextColumn get articleName => text()();

  /// 目錄（卷/章樹）序列化 JSON。
  TextColumn get payload => text()();
  IntColumn get updatedAt => integer()();

  @override
  String get tableName => 'novel_chapter_catalog';

  @override
  Set<Column<Object>> get primaryKey => <Column<Object>>{articleId};
}

/// 手動書籤（多筆）。保存完整 ReaderAnchor JSON 與書級中繼資料；
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

/// 閱讀進度（每本一筆）。PK(owner_uid, article_id)。
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
