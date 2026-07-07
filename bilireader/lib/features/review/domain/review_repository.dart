import '../../../core/network/api_result.dart';
import '../../../core/social/reaction.dart';
import 'review_entities.dart';
import 'review_options.dart';

/// 書評 repository（API.md §8.2 book_review/*）。需登入。顯示文字轉繁（§5.0）。
///
/// 讀取（list/detail/my/replies）可安全查詢；add/delete/reply/like/replyLike 為
/// 狀態變更端點（§7.0），僅供實際使用者操作、不做破壞性自動測試。皆為 Query 編碼
/// （book_review/reply 為純文字，非 Multipart，無需 BNUP2）。
abstract interface class ReviewRepository {
  /// 某書的書評列表（`book_review/list`）。
  Future<ApiResult<BookReviewPage>> list({
    required int articleId,
    BookReviewSort sort,
    int page,
  });

  /// 書評詳情（`book_review/detail`）。
  Future<ApiResult<BookReview>> detail(int topicId);

  /// 我對此書的書評（`book_review/my`）；未寫過回 null。
  Future<ApiResult<BookReview?>> mine(int articleId);

  /// 某書評的回覆列表（`book_review/replies`，分頁）。
  Future<ApiResult<BookReviewReplyList>> replies({
    required int topicId,
    int page,
  });

  /// 新增書評（`book_review/add`）。回傳新 topicId。
  Future<ApiResult<int>> add({
    required int articleId,
    required String content,
    bool isSpoiler,
  });

  /// 刪除書評（`book_review/delete`）。
  Future<ApiResult<void>> delete(int topicId);

  /// 回覆書評（`book_review/reply`，純文字）。
  Future<ApiResult<BookReviewReply>> reply({
    required int topicId,
    required String posttext,
    int? replyPid,
  });

  /// 書評按讚/倒讚（`book_review/like`）。type：讚1/倒讚2/取消0。
  Future<ApiResult<ReactionCounts>> like({
    required int topicId,
    required int type,
  });

  /// 回覆按讚/倒讚（`book_review/reply_like`）。
  Future<ApiResult<ReactionCounts>> replyLike({
    required int postId,
    required int type,
  });
}
