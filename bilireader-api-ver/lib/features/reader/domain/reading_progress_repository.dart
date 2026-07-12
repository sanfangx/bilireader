import 'reading_progress.dart';

/// 「繼續閱讀」本機進度的 LRU 上限：每位使用者最多保留最近 [kMaxReadingProgressEntries]
/// 本書的進度，超出即刪最舊（依 updatedAt）。避免逐本累積無限成長（使用者決策），
/// 同時維持 §5.5「每本書一筆」與書架 grid 逐本本機進度% 顯示（§5.5「明確策略」）。
const int kMaxReadingProgressEntries = 30;

/// 閱讀進度 repository 介面（規範 §5.5、§6.2）。
///
/// 書架「繼續閱讀」觀察 [watchAll]；閱讀器寫入進度後，書架不需等路由 pop 即可
/// 即時刷新最新章節與繁體文字片段。所有資料僅存本地（bookmarks/history/progress
/// storage），不呼叫 `bookcase/updateProgress` 做雲端同步（規範 §5.4、§6.2）。
abstract interface class ReadingProgressRepository {
  /// 觀察某使用者的所有「繼續閱讀」進度（依 updatedAt 由新到舊）。
  Stream<List<ReadingProgress>> watchAll(int ownerUid);

  /// 一次性取回所有進度。
  Future<List<ReadingProgress>> getAll(int ownerUid);

  /// 取回單本書的進度（無則 null）。
  Future<ReadingProgress?> get(int ownerUid, int articleId);

  /// 每本一筆 upsert（翻頁/滾動停下/章節切換/pause/dispose 時保存）。
  Future<void> save(ReadingProgress progress);
}
