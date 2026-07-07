import 'package:freezed_annotation/freezed_annotation.dart';

part 'text_request_entity.freezed.dart';
part 'text_request_entity.g.dart';

/// 章節正文回應（`novel/getNovelText`，doc 05 / 資料模型 §5.1）。
///
/// `text` 為**未加密**的 HTML 片段（含 `<img>`、`<ruby>`、`<heimu>`、傍点 span 等，
/// 以 `\n` 分段）；伺服器多為簡體，顯示前須經 OpenCC（§5.0，於顯示層依設定套用）。
/// wire key = 欄位名（無 @SerializedName）；此處以 @JsonKey 對映小寫 wire。
@freezed
abstract class TextRequestEntity with _$TextRequestEntity {
  const factory TextRequestEntity({
    @JsonKey(name: 'articleid') @Default(0) int articleId,
    @JsonKey(name: 'chapterid') @Default(0) int chapterId,
    @JsonKey(name: 'chaptername') String? chapterName,
    String? text,
    @Default(<ChapterImageDto>[]) List<ChapterImageDto> images,
    @Default(false) bool isImage,
    @Default(0) int isbody,
  }) = _TextRequestEntity;

  factory TextRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$TextRequestEntityFromJson(json);
}

/// 章節插圖（`Path`，資料模型 §5.2）：`path` 圖片 URL、`aspectRatio` 寬高比。
@freezed
abstract class ChapterImageDto with _$ChapterImageDto {
  const factory ChapterImageDto({
    String? path,
    @JsonKey(name: 'aspectRatio') @Default(0.0) double aspectRatio,
  }) = _ChapterImageDto;

  factory ChapterImageDto.fromJson(Map<String, dynamic> json) =>
      _$ChapterImageDtoFromJson(json);
}
