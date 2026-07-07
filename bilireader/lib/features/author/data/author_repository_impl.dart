import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';

import '../../../core/media/image_pick_service.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/app_error.dart';
import '../../../core/network/error_mapper.dart';
import '../../discover/data/dto/novel_response_entity.dart';
import '../domain/author_entities.dart';
import '../domain/author_repository.dart';
import 'author_remote_data_source.dart';
import 'dto/author_dtos.dart';

/// [AuthorRepository] 實作。DTO→domain 映射。
///
/// 重要：作者「自己的」內容（作品名 / 簡介 / 章節名 / 卷名 / 正文 / 草稿）**一律保留原文、
/// 不做 OpenCC 轉繁**——因為這些內容會經編輯器回存伺服器，若轉繁會永久改寫作者的原始
/// 簡體稿件（§5.0 僅針對「被閱讀消費」的文字，不含作者可回存的稿件）。上傳走 image_pick。
class AuthorRepositoryImpl implements AuthorRepository {
  const AuthorRepositoryImpl(this._remote);

  final AuthorRemoteDataSource _remote;

  @override
  Future<ApiResult<List<AuthorNovel>>> myNovels({int page = 1}) =>
      _guard(() async {
        final AuthorNovelListDataDto d = await _remote.listMyNovels(page: page);
        return d.list.map(_novel).toList();
      });

  @override
  Future<ApiResult<AuthorChapterTree>> chapterTree(int articleId) =>
      _guard(() async {
        final AuthorChapterTreeDataDto d = await _remote.chapterTree(articleId);
        return AuthorChapterTree(
          articleId: d.articleid,
          articleName: d.articlename ?? '',
          volumes: d.volumes
              .map(
                (AuthorVolumeDto v) => AuthorVolume(
                  volumeId: v.chapterid,
                  volumeName: v.chaptername ?? '',
                ),
              )
              .toList(),
          flat: d.flat.map(_chapter).toList(),
        );
      });

  @override
  Future<ApiResult<AuthorChapterText>> chapterText({
    required int articleId,
    required int chapterId,
  }) => _guard(() async {
    final AuthorChapterTextDataDto d = await _remote.chapterText(
      articleId: articleId,
      chapterId: chapterId,
    );
    return AuthorChapterText(
      articleId: d.articleid,
      chapterId: d.chapterid,
      chapterName: d.chaptername ?? '',
      text: d.text ?? '',
      isBody: d.isbody,
    );
  });

  @override
  Future<ApiResult<List<AuthorDraft>>> drafts(int articleId) => _guard(
    () async {
      final List<AuthorDraftItemDto> list = await _remote.listDrafts(articleId);
      return list.map(_draft).toList();
    },
  );

  @override
  Future<ApiResult<AuthorNovel>> updateNovel({
    required int articleId,
    required String articleName,
    required String intro,
    required String keywords,
    required int rGroup,
    required int fullFlag,
    required int progress,
  }) => _guard(() async {
    final NovelResponseEntity e = await _remote.updateNovel(
      articleId: articleId,
      articleName: articleName,
      intro: intro,
      keywords: keywords,
      rGroup: rGroup,
      fullFlag: fullFlag,
      progress: progress,
    );
    return _novel(e);
  });

  @override
  Future<ApiResult<void>> deleteNovel(int articleId) =>
      _guard(() => _remote.deleteNovel(articleId));

  @override
  Future<ApiResult<void>> updateNovelCover({
    required int articleId,
    required XFile coverSmall,
  }) => _guard(() async {
    await _remote.updateNovelCover(
      articleId: articleId,
      coverSmall: await ImagePickService.toMultipart(
        coverSmall,
        field: 'coverSmall',
      ),
    );
  });

  @override
  Future<ApiResult<AuthorChapter>> createVolume({
    required int articleId,
    required String volumeName,
    XFile? cover,
  }) => _guard(() async {
    final AuthorChapterRowDto d = await _remote.createVolume(
      articleId: articleId,
      volumeName: volumeName,
      cover: cover == null
          ? null
          : await ImagePickService.toMultipart(cover, field: 'cover'),
    );
    return _chapter(d);
  });

  @override
  Future<ApiResult<void>> updateVolume({
    required int articleId,
    required int volumeId,
    required String volumeName,
  }) => _guard(
    () => _remote.updateVolume(
      articleId: articleId,
      volumeId: volumeId,
      volumeName: volumeName,
    ),
  );

  @override
  Future<ApiResult<void>> deleteVolume({
    required int articleId,
    required int volumeId,
  }) => _guard(
    () => _remote.deleteVolume(articleId: articleId, volumeId: volumeId),
  );

  @override
  Future<ApiResult<void>> updateVolumeCover({
    required int articleId,
    required int volumeId,
    required XFile cover,
  }) => _guard(() async {
    await _remote.updateVolumeCover(
      articleId: articleId,
      volumeId: volumeId,
      cover: await ImagePickService.toMultipart(cover, field: 'cover'),
    );
  });

  @override
  Future<ApiResult<AuthorChapter>> publishDirect({
    required int articleId,
    required int volumeId,
    required String chapterName,
    required String content,
    int isBody = 1,
  }) => _guard(() async {
    final AuthorChapterRowDto d = await _remote.publishDirect(
      articleId: articleId,
      volumeId: volumeId,
      chapterName: chapterName,
      content: content,
      isBody: isBody,
    );
    return _chapter(d);
  });

  @override
  Future<ApiResult<AuthorChapter>> publishFromDraft(int draftId) =>
      _guard(() async => _chapter(await _remote.publishFromDraft(draftId)));

  @override
  Future<ApiResult<void>> updateChapter({
    required int articleId,
    required int chapterId,
    required String chapterName,
    required String content,
    int isBody = 1,
  }) => _guard(
    () => _remote.updateChapter(
      articleId: articleId,
      chapterId: chapterId,
      chapterName: chapterName,
      content: content,
      isBody: isBody,
    ),
  );

  @override
  Future<ApiResult<void>> deleteChapter({
    required int articleId,
    required int chapterId,
  }) => _guard(
    () => _remote.deleteChapter(articleId: articleId, chapterId: chapterId),
  );

  @override
  Future<ApiResult<void>> moveChapter({
    required int articleId,
    required int chapterId,
    required int targetVolumeId,
  }) => _guard(
    () => _remote.moveChapter(
      articleId: articleId,
      chapterId: chapterId,
      targetVolumeId: targetVolumeId,
    ),
  );

  @override
  Future<ApiResult<ChapterAttachResult>> uploadIllustration({
    required int articleId,
    int? chapterId,
    int? draftId,
    required XFile file,
  }) => _guard(() async {
    final ChapterAttachUploadDataDto d = await _remote.uploadIllustration(
      articleId: articleId,
      chapterId: chapterId,
      draftId: draftId,
      file: await ImagePickService.toMultipart(file, field: 'file'),
    );
    return ChapterAttachResult(
      attachId: d.attachId,
      previewUrl: d.previewUrl,
      insertHtml: d.insertHtml,
      insertToken: d.insertToken,
      fileName: d.fileName,
      size: d.size,
    );
  });

  @override
  Future<ApiResult<void>> deleteIllustration({
    required int articleId,
    int? chapterId,
    int? draftId,
    required int attachId,
  }) => _guard(
    () => _remote.deleteIllustration(
      articleId: articleId,
      chapterId: chapterId,
      draftId: draftId,
      attachId: attachId,
    ),
  );

  @override
  Future<ApiResult<AuthorDraft>> saveDraft({
    int? draftId,
    required int articleId,
    required int volumeId,
    required String chapterName,
    required String chapterContent,
    int isBody = 1,
  }) => _guard(() async {
    final AuthorDraftItemDto d = await _remote.saveDraft(
      draftId: draftId,
      articleId: articleId,
      volumeId: volumeId,
      chapterName: chapterName,
      chapterContent: chapterContent,
      isBody: isBody,
    );
    return _draft(d);
  });

  @override
  Future<ApiResult<void>> deleteDraft(int draftId) =>
      _guard(() => _remote.deleteDraft(draftId));

  // ---- mapping（作者自有內容保留原文，不轉繁）----

  AuthorNovel _novel(NovelResponseEntity e) => AuthorNovel(
    articleId: e.articleId,
    title: e.articleName ?? '',
    coverUrl: e.cover,
    intro: e.intro,
    keywords: e.keywords,
    isFinished: e.isFinished,
    progress: e.progress,
    rGroup: e.rGroup,
    fullFlag: e.fullFlag,
    words: e.words,
    voteCount: e.allVote,
    flowerCount: e.allFlower,
    goodNum: e.goodNum,
    totalVisits: e.allVisit,
  );

  AuthorChapter _chapter(AuthorChapterRowDto d) => AuthorChapter(
    chapterId: d.chapterid,
    articleId: d.articleid,
    volumeId: d.volumeid,
    chapterName: d.chaptername ?? '',
    chapterOrder: d.chapterorder,
    chapterType: d.chaptertype,
    words: d.words,
  );

  AuthorDraft _draft(AuthorDraftItemDto d) => AuthorDraft(
    draftId: d.draftid,
    articleId: d.articleid,
    volumeId: d.volumeid,
    chapterName: d.chaptername ?? '',
    chapterContent: d.chaptercontent ?? '',
    words: d.words,
    lastUpdate: d.lastupdate,
    isPub: d.ispub == 1,
    isBody: d.isbody,
  );

  Future<ApiResult<T>> _guard<T>(Future<T> Function() body) async {
    try {
      return ApiSuccess<T>(await body());
    } on DioException catch (e) {
      return ApiFailure<T>(ErrorMapper.fromDio(e));
    } on AppError catch (e) {
      return ApiFailure<T>(e);
    } on Object catch (e) {
      return ApiFailure<T>(ErrorMapper.parse(e));
    }
  }
}
