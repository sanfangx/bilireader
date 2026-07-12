import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../discover/data/dto/novel_response_entity.dart';

part 'author_dtos.freezed.dart';
part 'author_dtos.g.dart';

/// 我的作品清單（`AuthorNovelListData`）：`list` 為共用的 [NovelResponseEntity]，`total`。
@freezed
abstract class AuthorNovelListDataDto with _$AuthorNovelListDataDto {
  const factory AuthorNovelListDataDto({
    @Default(<NovelResponseEntity>[]) List<NovelResponseEntity> list,
    @Default(0) int total,
  }) = _AuthorNovelListDataDto;

  factory AuthorNovelListDataDto.fromJson(Map<String, dynamic> json) =>
      _$AuthorNovelListDataDtoFromJson(json);
}

/// 作者章節列（`AuthorChapterRow`）。wire = 欄位名（全小寫）。
@freezed
abstract class AuthorChapterRowDto with _$AuthorChapterRowDto {
  const factory AuthorChapterRowDto({
    @Default(0) int chapterid,
    @Default(0) int articleid,
    @Default(0) int volumeid,
    String? chaptername,
    @Default(0) int chapterorder,
    @Default(0) int chaptertype,
    @Default(0) int words,
  }) = _AuthorChapterRowDto;

  factory AuthorChapterRowDto.fromJson(Map<String, dynamic> json) =>
      _$AuthorChapterRowDtoFromJson(json);
}

/// 卷元素（`AuthorChapterTreeData.volumes` 為 `List<ChapterRequestEntity>`；卷 id =
/// `chapterid`、卷名 = `chaptername`，反編譯確認）。
@freezed
abstract class AuthorVolumeDto with _$AuthorVolumeDto {
  const factory AuthorVolumeDto({
    @Default(0) int chapterid,
    String? chaptername,
  }) = _AuthorVolumeDto;

  factory AuthorVolumeDto.fromJson(Map<String, dynamic> json) =>
      _$AuthorVolumeDtoFromJson(json);
}

/// 作品完整章節樹（`AuthorChapterTreeData`）：`volumes`（卷）+ `flat`（扁平章節）。
@freezed
abstract class AuthorChapterTreeDataDto with _$AuthorChapterTreeDataDto {
  const factory AuthorChapterTreeDataDto({
    @Default(0) int articleid,
    String? articlename,
    @Default(<AuthorVolumeDto>[]) List<AuthorVolumeDto> volumes,
    @Default(<AuthorChapterRowDto>[]) List<AuthorChapterRowDto> flat,
  }) = _AuthorChapterTreeDataDto;

  factory AuthorChapterTreeDataDto.fromJson(Map<String, dynamic> json) =>
      _$AuthorChapterTreeDataDtoFromJson(json);
}

/// 作者端章節正文（`AuthorChapterTextData`）。
@freezed
abstract class AuthorChapterTextDataDto with _$AuthorChapterTextDataDto {
  const factory AuthorChapterTextDataDto({
    @Default(0) int articleid,
    @Default(0) int chapterid,
    String? chaptername,
    @Default(1) int isbody,
    String? text,
  }) = _AuthorChapterTextDataDto;

  factory AuthorChapterTextDataDto.fromJson(Map<String, dynamic> json) =>
      _$AuthorChapterTextDataDtoFromJson(json);
}

/// 草稿（`AuthorDraftItem`）。
@freezed
abstract class AuthorDraftItemDto with _$AuthorDraftItemDto {
  const factory AuthorDraftItemDto({
    @Default(0) int draftid,
    @Default(0) int articleid,
    @Default(0) int volumeid,
    String? chaptername,
    String? chaptercontent,
    @Default(0) int words,
    @Default(0) int lastupdate,
    @Default(0) int ispub,
    @Default(1) int isbody,
  }) = _AuthorDraftItemDto;

  factory AuthorDraftItemDto.fromJson(Map<String, dynamic> json) =>
      _$AuthorDraftItemDtoFromJson(json);
}

/// 插圖上傳結果（`ChapterAttachUploadData`）。`attachId` 為駝峰（反編譯 `@SerializedName`）。
@freezed
abstract class ChapterAttachUploadDataDto with _$ChapterAttachUploadDataDto {
  const factory ChapterAttachUploadDataDto({
    @Default(0) int attachId,
    String? previewUrl,
    String? insertHtml,
    String? insertToken,
    String? fileName,
    @Default(0) int size,
  }) = _ChapterAttachUploadDataDto;

  factory ChapterAttachUploadDataDto.fromJson(Map<String, dynamic> json) =>
      _$ChapterAttachUploadDataDtoFromJson(json);
}
