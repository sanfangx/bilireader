import '../../../core/network/api_result.dart';
import 'bookcase_options.dart';
import 'bookshelf_entry.dart';

/// 書架 repository 介面（規範 §4.2）。所有顯示文字已於實作層轉繁（§5.0）。
/// 需登入；未登入的處理由 presentation 決定（顯示登入引導）。
abstract interface class BookcaseRepository {
  /// 取書架清單（`bookcase/list`，Body classid + sortorder）。
  Future<ApiResult<List<BookshelfEntry>>> list({
    BookcaseClass classFilter,
    BookshelfSort sort,
  });

  /// 加入書架（`bookcase/add`）。回傳成功訊息字串。
  Future<ApiResult<String>> add({
    required int articleId,
    required String articleName,
    BookcaseClass classFilter,
    int? chapterId,
    String? chapterName,
    int? chapterOrder,
    int? pageId,
  });

  /// 從書架移除（`bookcase/delete`，Body caseid）。
  Future<ApiResult<String>> delete(int caseId);

  /// 變更收藏分類（`bookcase/updateClass`，Body caseid + classid）。
  Future<ApiResult<String>> updateClass({
    required int caseId,
    required BookcaseClass classFilter,
  });

  /// 檢查是否已在書架（`bookcase/check`，Body articleid）。
  Future<ApiResult<bool>> check(int articleId);
}
