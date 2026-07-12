import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/base_response.dart';
import '../../../core/network/error_mapper.dart';
import '../../discover/data/dto/novel_response_entity.dart';
import 'dto/author_dtos.dart';

/// 作者專區端點（API.md §8.3；欄位/編碼以反編譯 `AuthorApiService` 為準）。全部需登入。
///
/// 編碼：Query（`queryParameters`）、Body（JSON `data`）、Form（x-www-form-urlencoded）、
/// Multipart🔒（`FormData`，由 UploadSignatureInterceptor 依路徑自動加 BNUP2 簽章）。
/// 註：反編譯確認 App 無 `novel/create` 呼叫，故不提供建立新作品。
class AuthorRemoteDataSource {
  const AuthorRemoteDataSource(this._dio);

  final Dio _dio;

  // ---- 讀取 ----

  Future<AuthorNovelListDataDto> listMyNovels({
    required int page,
    int pageSize = ApiConstants.defaultPageSize,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.authorNovelList,
      queryParameters: <String, dynamic>{'pageNum': page, 'pageSize': pageSize},
    );
    final BaseResponse<AuthorNovelListDataDto> base = _base(
      resp,
      (Object? d) => AuthorNovelListDataDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const AuthorNovelListDataDto();
  }

  Future<AuthorChapterTreeDataDto> chapterTree(int articleId) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.authorChapterTree,
      queryParameters: <String, dynamic>{'articleid': articleId},
    );
    final BaseResponse<AuthorChapterTreeDataDto> base = _base(
      resp,
      (Object? d) => AuthorChapterTreeDataDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const AuthorChapterTreeDataDto();
  }

  Future<AuthorChapterTextDataDto> chapterText({
    required int articleId,
    required int chapterId,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.authorChapterText,
      queryParameters: <String, dynamic>{
        'articleid': articleId,
        'chapterid': chapterId,
      },
    );
    final BaseResponse<AuthorChapterTextDataDto> base = _base(
      resp,
      (Object? d) => AuthorChapterTextDataDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const AuthorChapterTextDataDto();
  }

  Future<List<AuthorDraftItemDto>> listDrafts(int articleId) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.authorDraftList,
      queryParameters: <String, dynamic>{'articleid': articleId},
    );
    final BaseResponse<List<AuthorDraftItemDto>> base = _base(resp, (
      Object? d,
    ) {
      final List<dynamic> list = d is List ? d : const <dynamic>[];
      return list
          .whereType<Map<String, dynamic>>()
          .map(AuthorDraftItemDto.fromJson)
          .toList();
    });
    _ensure(base);
    return base.data ?? const <AuthorDraftItemDto>[];
  }

  // ---- 作品（狀態變更，§7.0）----

  Future<NovelResponseEntity> updateNovel({
    required int articleId,
    required String articleName,
    required String intro,
    required String keywords,
    required int rGroup,
    required int fullFlag,
    required int progress,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.authorNovelUpdate,
      data: <String, dynamic>{
        'articleid': articleId,
        'articlename': articleName,
        'intro': intro,
        'keywords': keywords,
        'rgroup': rGroup,
        'fullflag': fullFlag,
        'progress': progress,
      },
    );
    final BaseResponse<NovelResponseEntity> base = _base(
      resp,
      (Object? d) => NovelResponseEntity.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const NovelResponseEntity();
  }

  Future<void> deleteNovel(int articleId) => _delete(
    ApiPaths.authorNovelDelete,
    <String, dynamic>{'articleid': articleId},
  );

  /// `author/novel/cover`（Multipart🔒）。反編譯確認 App 僅傳 `coverSmall` part
  /// （大圖 part 為 null）；檔名 `{articleId}s.jpg`。
  Future<void> updateNovelCover({
    required int articleId,
    required MultipartFile coverSmall,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.authorNovelCover,
      queryParameters: <String, dynamic>{'articleid': articleId},
      data: FormData.fromMap(<String, dynamic>{'coverSmall': coverSmall}),
    );
    _ensure(_base(resp, (Object? d) => d));
  }

  // ---- 卷（狀態變更，§7.0）----

  /// `author/volume/create`（Query articleid/volumeName + 可選封面 part `cover`；🔒）。
  Future<AuthorChapterRowDto> createVolume({
    required int articleId,
    required String volumeName,
    MultipartFile? cover,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.authorVolumeCreate,
      queryParameters: <String, dynamic>{
        'articleid': articleId,
        'volumeName': volumeName,
      },
      data: cover == null
          ? null
          : FormData.fromMap(<String, dynamic>{'cover': cover}),
    );
    final BaseResponse<AuthorChapterRowDto> base = _base(
      resp,
      (Object? d) => AuthorChapterRowDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const AuthorChapterRowDto();
  }

  Future<void> updateVolume({
    required int articleId,
    required int volumeId,
    required String volumeName,
  }) => _delete(ApiPaths.authorVolumeUpdate, <String, dynamic>{
    'articleid': articleId,
    'volumeId': volumeId,
    'volumeName': volumeName,
  });

  Future<void> deleteVolume({required int articleId, required int volumeId}) =>
      _delete(ApiPaths.authorVolumeDelete, <String, dynamic>{
        'articleid': articleId,
        'volumeId': volumeId,
      });

  /// `author/volume/cover`（Query articleid/volumeId + 封面 part `cover`；🔒）。
  Future<void> updateVolumeCover({
    required int articleId,
    required int volumeId,
    required MultipartFile cover,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.authorVolumeCover,
      queryParameters: <String, dynamic>{
        'articleid': articleId,
        'volumeId': volumeId,
      },
      data: FormData.fromMap(<String, dynamic>{'cover': cover}),
    );
    _ensure(_base(resp, (Object? d) => d));
  }

  // ---- 章節（狀態變更，§7.0）----

  /// `author/chapter/publishDirect`（Body）→ AuthorChapterRow。
  Future<AuthorChapterRowDto> publishDirect({
    required int articleId,
    required int volumeId,
    required String chapterName,
    required String content,
    required int isBody,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.authorChapterPublishDirect,
      data: <String, dynamic>{
        'articleid': articleId,
        'volumeId': volumeId,
        'chaptername': chapterName,
        'content': content,
        'isbody': isBody,
      },
    );
    return _chapterRow(resp);
  }

  /// `author/chapter/publish`（Query draftid）→ AuthorChapterRow。
  Future<AuthorChapterRowDto> publishFromDraft(int draftId) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.authorChapterPublish,
      queryParameters: <String, dynamic>{'draftid': draftId},
    );
    return _chapterRow(resp);
  }

  /// `author/chapter/update`（Form，x-www-form-urlencoded）。
  Future<void> updateChapter({
    required int articleId,
    required int chapterId,
    required String chapterName,
    required String content,
    required int isBody,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.authorChapterUpdate,
      data: <String, dynamic>{
        'articleid': articleId,
        'chapterid': chapterId,
        'chaptername': chapterName,
        'content': content,
        'isbody': isBody,
      },
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
    _ensure(_base(resp, (Object? d) => d));
  }

  Future<void> deleteChapter({
    required int articleId,
    required int chapterId,
  }) => _delete(ApiPaths.authorChapterDelete, <String, dynamic>{
    'articleid': articleId,
    'chapterid': chapterId,
  });

  Future<void> moveChapter({
    required int articleId,
    required int chapterId,
    required int targetVolumeId,
  }) => _delete(ApiPaths.authorChapterMove, <String, dynamic>{
    'articleid': articleId,
    'chapterid': chapterId,
    'targetVolumeId': targetVolumeId,
  });

  /// `author/chapter/attach/upload`（Query articleid/chapterid?/draftid? + 圖檔 part
  /// `file`；Multipart🔒）→ ChapterAttachUploadData。
  Future<ChapterAttachUploadDataDto> uploadIllustration({
    required int articleId,
    int? chapterId,
    int? draftId,
    required MultipartFile file,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.authorChapterAttachUpload,
      queryParameters: <String, dynamic>{
        'articleid': articleId,
        'chapterid': ?chapterId,
        'draftid': ?draftId,
      },
      data: FormData.fromMap(<String, dynamic>{'file': file}),
    );
    final BaseResponse<ChapterAttachUploadDataDto> base = _base(
      resp,
      (Object? d) => ChapterAttachUploadDataDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const ChapterAttachUploadDataDto();
  }

  Future<void> deleteIllustration({
    required int articleId,
    int? chapterId,
    int? draftId,
    required int attachId,
  }) => _delete(ApiPaths.authorChapterAttachDelete, <String, dynamic>{
    'articleid': articleId,
    'chapterid': ?chapterId,
    'draftid': ?draftId,
    'attachid': attachId,
  });

  // ---- 草稿（狀態變更，§7.0）----

  /// `author/draft/save`（Body）。[draftId] 為 null 時新建。
  Future<AuthorDraftItemDto> saveDraft({
    int? draftId,
    required int articleId,
    required int volumeId,
    required String chapterName,
    required String chapterContent,
    required int isBody,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.authorDraftSave,
      data: <String, dynamic>{
        'draftid': ?draftId,
        'articleid': articleId,
        'volumeid': volumeId,
        'chaptername': chapterName,
        'chaptercontent': chapterContent,
        'isbody': isBody,
      },
    );
    final BaseResponse<AuthorDraftItemDto> base = _base(
      resp,
      (Object? d) => AuthorDraftItemDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const AuthorDraftItemDto();
  }

  Future<void> deleteDraft(int draftId) => _delete(
    ApiPaths.authorDraftDelete,
    <String, dynamic>{'draftid': draftId},
  );

  // ---- helpers ----

  AuthorChapterRowDto _chapterRow(Response<dynamic> resp) {
    final BaseResponse<AuthorChapterRowDto> base = _base(
      resp,
      (Object? d) => AuthorChapterRowDto.fromJson(_map(d)),
    );
    _ensure(base);
    return base.data ?? const AuthorChapterRowDto();
  }

  Future<void> _delete(String path, Map<String, dynamic> query) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      path,
      queryParameters: query,
    );
    _ensure(_base(resp, (Object? d) => d));
  }

  Map<String, dynamic> _map(Object? d) =>
      d is Map<String, dynamic> ? d : const <String, dynamic>{};

  BaseResponse<T> _base<T>(
    Response<dynamic> resp,
    T Function(Object? data) fromData,
  ) {
    final Object? body = resp.data;
    final Map<String, dynamic> map = body is Map<String, dynamic>
        ? body
        : const <String, dynamic>{};
    return BaseResponse<T>.fromJson(map, fromData);
  }

  void _ensure<T>(BaseResponse<T> base) {
    if (base.code != ApiConstants.codeSuccess) {
      throw ErrorMapper.fromBusinessCode(
        code: base.code,
        serverMessage: base.message,
      );
    }
  }
}
