import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/storage/database/app_database.dart';
import '../domain/reader_anchor.dart';
import '../domain/reading_progress.dart';
import '../domain/reading_progress_repository.dart';

/// 閱讀進度本地資料來源（規範 §5.5）。每本一筆 upsert；提供 watch 供書架即時更新。
class ReadingProgressLocalDataSource {
  const ReadingProgressLocalDataSource(this._dao);

  final ReadingProgressDao _dao;

  Future<void> save(ReadingProgress progress) async {
    final ReaderAnchor anchor = progress.anchor;
    await _dao.upsertProgress(
      ReadingProgressRowsCompanion.insert(
        ownerUid: progress.ownerUid,
        articleId: anchor.articleId,
        chapterId: anchor.chapterId,
        sourceTextOffset: anchor.sourceTextOffset,
        anchorJson: jsonEncode(anchor.toJson()),
        textQuote: Value<String>(anchor.textQuote),
        chapterName: Value<String>(anchor.chapterName),
        articleName: Value<String>(progress.articleName),
        poster: Value<String>(progress.poster),
        updatedAt: Value<int>(progress.updatedAt),
      ),
    );
    // LRU 裁剪：每位使用者最多保留最近 N 本書進度（§5.5「明確策略」，使用者決策）。
    await _dao.pruneToRecent(progress.ownerUid, kMaxReadingProgressEntries);
  }

  Future<ReadingProgress?> get(int ownerUid, int articleId) async {
    final ReadingProgressRow? row = await _dao.getProgress(ownerUid, articleId);
    return row == null ? null : _toEntity(row);
  }

  Future<List<ReadingProgress>> getAll(int ownerUid) async {
    final List<ReadingProgressRow> rows = await _dao.getAllProgress(ownerUid);
    return rows.map(_toEntity).toList();
  }

  /// 書架「繼續閱讀」觀察此串流；閱讀器寫入後即時刷新（規範 §5.5、§6.2）。
  Stream<List<ReadingProgress>> watchAll(int ownerUid) {
    return _dao
        .watchAllProgress(ownerUid)
        .map((List<ReadingProgressRow> rows) => rows.map(_toEntity).toList());
  }

  ReadingProgress _toEntity(ReadingProgressRow row) {
    return ReadingProgress(
      ownerUid: row.ownerUid,
      articleName: row.articleName,
      poster: row.poster,
      updatedAt: row.updatedAt,
      anchor: ReaderAnchor.fromJson(
        jsonDecode(row.anchorJson) as Map<String, dynamic>,
      ),
    );
  }
}
