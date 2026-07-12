import '../../../core/network/api_result.dart';
import 'chapter_text.dart';

/// 章節正文 repository（`getNovelText`，§5.4、§7.5）。永久快取優先 → in-flight dedupe →
/// 網路 → 寫入永久快取。回傳原文（顯示層再 OpenCC）。需登入（正文端點）。
abstract interface class ChapterTextRepository {
  /// 取章節正文；預設先讀本機永久快取，未命中才打網路並寫回快取。
  Future<ApiResult<ChapterText>> getChapterText({
    required int articleId,
    required int chapterId,
  });

  /// 單章下載至永久快取（目錄頁「下載」用）。已快取則略過網路。
  Future<ApiResult<void>> downloadChapter({
    required int articleId,
    required int chapterId,
  });

  /// 該章是否已在本機永久快取。
  Future<bool> isCached({required int articleId, required int chapterId});
}
