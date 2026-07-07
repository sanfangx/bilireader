import '../../../core/network/api_result.dart';
import '../../../core/social/reaction.dart';
import 'chapter_comment_entities.dart';

/// 章節評論 repository（API.md §8.2 chapter_comment/*）。需登入。文字轉繁（§5.0）。
///
/// 以 (articleId, chapterId) 為範圍。list/my 為讀取；add/delete/like 為狀態變更端點
/// （§7.0），僅供實際使用者操作、不做破壞性自動測試。皆為 Query 編碼（無需 BNUP2）。
/// presentation（閱讀器內嵌評論面板）隨 Phase 5 閱讀器建置。
abstract interface class ChapterCommentRepository {
  /// 章節評論列表（`chapter_comment/list`）。
  Future<ApiResult<ChapterCommentPage>> list({
    required int articleId,
    required int chapterId,
    int page,
  });

  /// 我在此章的評論（`chapter_comment/my`）。
  Future<ApiResult<ChapterCommentPage>> mine({
    required int articleId,
    required int chapterId,
    int page,
  });

  /// 新增章節評論（`chapter_comment/add`）。回傳新 commentId。
  Future<ApiResult<int>> add({
    required int articleId,
    required int chapterId,
    required String content,
    bool isSpoiler,
  });

  /// 刪除章節評論（`chapter_comment/delete`）。
  Future<ApiResult<void>> delete(int commentId);

  /// 章節評論按讚/倒讚（`chapter_comment/like`）。type：讚1/倒讚2/取消0。
  Future<ApiResult<ReactionCounts>> like({
    required int commentId,
    required int type,
  });
}
