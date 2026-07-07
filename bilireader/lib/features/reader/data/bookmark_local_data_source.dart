import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/storage/database/app_database.dart';
import '../domain/bookmark.dart';
import '../domain/reader_anchor.dart';

/// 書籤本地資料來源（規範 §5.5、§7.5）。entity ↔ drift row 轉換；完整 [ReaderAnchor]
/// 以 JSON 保存於 `anchor_json`，另攤平核心索引欄位（owner/article/chapter/offset）。
class BookmarkLocalDataSource {
  const BookmarkLocalDataSource(this._dao);

  final BookmarkDao _dao;

  Future<int> save(Bookmark bookmark) {
    final ReaderAnchor anchor = bookmark.anchor;
    return _dao.insertBookmark(
      BookmarkRowsCompanion.insert(
        ownerUid: bookmark.ownerUid,
        articleId: anchor.articleId,
        chapterId: anchor.chapterId,
        sourceTextOffset: anchor.sourceTextOffset,
        anchorJson: jsonEncode(anchor.toJson()),
        textQuote: Value<String>(anchor.textQuote),
        chapterName: Value<String>(anchor.chapterName),
        articleName: Value<String>(bookmark.articleName),
        poster: Value<String>(bookmark.poster),
        createdAt: Value<int>(anchor.createdAt),
        updatedAt: Value<int>(anchor.updatedAt),
      ),
    );
  }

  Future<List<Bookmark>> getForBook(int ownerUid, int articleId) async {
    final List<BookmarkRow> rows = await _dao.getBookmarks(ownerUid, articleId);
    return rows.map(_toEntity).toList();
  }

  Future<List<Bookmark>> getAll(int ownerUid) async {
    final List<BookmarkRow> rows = await _dao.getAllBookmarks(ownerUid);
    return rows.map(_toEntity).toList();
  }

  Future<void> delete(int id) => _dao.deleteBookmark(id);

  Future<void> clearOwner(int ownerUid) => _dao.clearOwner(ownerUid);

  Bookmark _toEntity(BookmarkRow row) {
    return Bookmark(
      id: row.id,
      ownerUid: row.ownerUid,
      articleName: row.articleName,
      poster: row.poster,
      anchor: ReaderAnchor.fromJson(
        jsonDecode(row.anchorJson) as Map<String, dynamic>,
      ),
    );
  }
}
