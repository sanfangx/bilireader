import 'package:cross_file/cross_file.dart';

import '../../../core/network/api_result.dart';
import 'author_entities.dart';

/// 作者專區 repository（API.md §8.3）。需登入且 groupid ∈ {1,5,6}（入口閘門於 UI）。
///
/// 讀取（myNovels/chapterTree/chapterText/drafts）可安全查詢；其餘皆為狀態變更端點
/// （§7.0），僅供實際使用者操作、不做破壞性自動測試。封面/插圖上傳為 Multipart🔒
/// （BNUP2 簽章）。顯示文字於實作層轉繁（§5.0）。App 無 `novel/create`，故不提供建立作品。
abstract interface class AuthorRepository {
  /// 我的作品清單（`author/novel/list`）。
  Future<ApiResult<List<AuthorNovel>>> myNovels({int page});

  /// 作品章節樹（`author/chapter/tree`）。
  Future<ApiResult<AuthorChapterTree>> chapterTree(int articleId);

  /// 章節正文（作者端，`author/chapter/text`）。
  Future<ApiResult<AuthorChapterText>> chapterText({
    required int articleId,
    required int chapterId,
  });

  /// 草稿清單（`author/draft/list`）。
  Future<ApiResult<List<AuthorDraft>>> drafts(int articleId);

  // ---- 狀態變更（§7.0） ----

  /// 更新作品資料（`author/novel/update`）。
  Future<ApiResult<AuthorNovel>> updateNovel({
    required int articleId,
    required String articleName,
    required String intro,
    required String keywords,
    required int rGroup,
    required int fullFlag,
    required int progress,
  });

  /// 刪除作品（`author/novel/delete`）。
  Future<ApiResult<void>> deleteNovel(int articleId);

  /// 上傳作品封面（`author/novel/cover`，Multipart🔒；僅小圖 part）。
  Future<ApiResult<void>> updateNovelCover({
    required int articleId,
    required XFile coverSmall,
  });

  /// 新增卷（`author/volume/create`，Multipart🔒，封面可選）。
  Future<ApiResult<AuthorChapter>> createVolume({
    required int articleId,
    required String volumeName,
    XFile? cover,
  });

  /// 更新卷名（`author/volume/update`）。
  Future<ApiResult<void>> updateVolume({
    required int articleId,
    required int volumeId,
    required String volumeName,
  });

  /// 刪除卷（`author/volume/delete`）。
  Future<ApiResult<void>> deleteVolume({
    required int articleId,
    required int volumeId,
  });

  /// 上傳卷封面（`author/volume/cover`，Multipart🔒）。
  Future<ApiResult<void>> updateVolumeCover({
    required int articleId,
    required int volumeId,
    required XFile cover,
  });

  /// 直接發佈新章節（`author/chapter/publishDirect`）。
  Future<ApiResult<AuthorChapter>> publishDirect({
    required int articleId,
    required int volumeId,
    required String chapterName,
    required String content,
    int isBody,
  });

  /// 由草稿發佈章節（`author/chapter/publish`）。
  Future<ApiResult<AuthorChapter>> publishFromDraft(int draftId);

  /// 更新既有章節（`author/chapter/update`，Form）。
  Future<ApiResult<void>> updateChapter({
    required int articleId,
    required int chapterId,
    required String chapterName,
    required String content,
    int isBody,
  });

  /// 刪除章節（`author/chapter/delete`）。
  Future<ApiResult<void>> deleteChapter({
    required int articleId,
    required int chapterId,
  });

  /// 移動章節到另一卷（`author/chapter/move`）。
  Future<ApiResult<void>> moveChapter({
    required int articleId,
    required int chapterId,
    required int targetVolumeId,
  });

  /// 上傳章節插圖（`author/chapter/attach/upload`，Multipart🔒）。回 insertToken/insertHtml。
  Future<ApiResult<ChapterAttachResult>> uploadIllustration({
    required int articleId,
    int? chapterId,
    int? draftId,
    required XFile file,
  });

  /// 刪除插圖附件（`author/chapter/attach/delete`）。
  Future<ApiResult<void>> deleteIllustration({
    required int articleId,
    int? chapterId,
    int? draftId,
    required int attachId,
  });

  /// 新增/更新草稿（`author/draft/save`）。[draftId] 為 null 時新建。
  Future<ApiResult<AuthorDraft>> saveDraft({
    int? draftId,
    required int articleId,
    required int volumeId,
    required String chapterName,
    required String chapterContent,
    int isBody,
  });

  /// 刪除草稿（`author/draft/delete`）。
  Future<ApiResult<void>> deleteDraft(int draftId);
}
