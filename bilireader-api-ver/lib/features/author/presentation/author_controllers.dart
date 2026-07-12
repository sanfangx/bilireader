import 'package:cross_file/cross_file.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/router/auth_controller.dart';
import '../data/author_providers.dart';
import '../domain/author_entities.dart';

part 'author_controllers.g.dart';

/// 作者專區入口閘門（§11 ⑦，doc 09）：需登入且 groupid ∈ {1,5,6}。未過閘門短路，
/// 避免對受保護端點打出必然失敗的請求（§6.3）。
void _requireAuthor(Ref ref) {
  if (!ref.watch(authControllerProvider).canAccessAuthorZone) {
    throw ErrorMapper.fromBusinessCode(code: ApiConstants.codeTokenInvalid);
  }
}

/// 我的作品清單（`author/novel/list`）。
@riverpod
Future<List<AuthorNovel>> myNovels(Ref ref) async {
  _requireAuthor(ref);
  return (await ref.watch(authorRepositoryProvider).myNovels()).dataOrThrow();
}

/// 某作品的章節樹（`author/chapter/tree`）。
@riverpod
Future<AuthorChapterTree> authorChapterTree(Ref ref, int articleId) async {
  _requireAuthor(ref);
  return (await ref.watch(authorRepositoryProvider).chapterTree(articleId))
      .dataOrThrow();
}

/// 作者寫入動作（草稿 / 發佈 / 章節 / 卷 / 封面 / 插圖）。皆為狀態變更端點（§7.0），
/// 僅供實際使用者操作、不做破壞性自動測試。成功後由呼叫端 invalidate 對應 provider。
@riverpod
class AuthorActions extends _$AuthorActions {
  @override
  void build() {}

  Future<ApiResult<AuthorChapterText>> loadChapterText({
    required int articleId,
    required int chapterId,
  }) => ref
      .read(authorRepositoryProvider)
      .chapterText(articleId: articleId, chapterId: chapterId);

  Future<ApiResult<AuthorDraft>> saveDraft({
    int? draftId,
    required int articleId,
    required int volumeId,
    required String chapterName,
    required String chapterContent,
  }) => ref
      .read(authorRepositoryProvider)
      .saveDraft(
        draftId: draftId,
        articleId: articleId,
        volumeId: volumeId,
        chapterName: chapterName,
        chapterContent: chapterContent,
      );

  Future<ApiResult<AuthorChapter>> publishDirect({
    required int articleId,
    required int volumeId,
    required String chapterName,
    required String content,
  }) => ref
      .read(authorRepositoryProvider)
      .publishDirect(
        articleId: articleId,
        volumeId: volumeId,
        chapterName: chapterName,
        content: content,
      );

  Future<ApiResult<AuthorChapter>> publishFromDraft(int draftId) =>
      ref.read(authorRepositoryProvider).publishFromDraft(draftId);

  Future<ApiResult<void>> updateChapter({
    required int articleId,
    required int chapterId,
    required String chapterName,
    required String content,
  }) => ref
      .read(authorRepositoryProvider)
      .updateChapter(
        articleId: articleId,
        chapterId: chapterId,
        chapterName: chapterName,
        content: content,
      );

  Future<ApiResult<void>> deleteChapter({
    required int articleId,
    required int chapterId,
  }) => ref
      .read(authorRepositoryProvider)
      .deleteChapter(articleId: articleId, chapterId: chapterId);

  Future<ApiResult<AuthorChapter>> createVolume({
    required int articleId,
    required String volumeName,
    XFile? cover,
  }) => ref
      .read(authorRepositoryProvider)
      .createVolume(articleId: articleId, volumeName: volumeName, cover: cover);

  Future<ApiResult<ChapterAttachResult>> uploadIllustration({
    required int articleId,
    int? chapterId,
    int? draftId,
    required XFile file,
  }) => ref
      .read(authorRepositoryProvider)
      .uploadIllustration(
        articleId: articleId,
        chapterId: chapterId,
        draftId: draftId,
        file: file,
      );
}
