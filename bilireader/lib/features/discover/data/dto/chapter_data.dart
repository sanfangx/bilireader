import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter_data.freezed.dart';
part 'chapter_data.g.dart';

/// 目錄回應外層（doc 10 §4.1 `ChapterData`）。
/// wire = 欄位名（無 `@SerializedName`）：`articleid`、`articlename`、`chapters`。
@freezed
abstract class ChapterData with _$ChapterData {
  const factory ChapterData({
    @Default(0) int articleid,
    String? articlename,
    @Default(<ChapterRequestEntity>[]) List<ChapterRequestEntity> chapters,
  }) = _ChapterData;

  factory ChapterData.fromJson(Map<String, dynamic> json) =>
      _$ChapterDataFromJson(json);
}

/// 目錄樹狀節點（doc 10 §4.3 `ChapterRequestEntity`）：**遞迴結構**，
/// 一個「卷」是 `ChapterRequestEntity`，其 `chapterList` 裝子章節（也是本型別）。
/// wire = 欄位名：`articleid`、`chapterid`、`chaptername`、`chaptertype`、`words`、
/// `cover`、`chapterList`。`chaptertype` 區分卷/章/特殊。
@freezed
abstract class ChapterRequestEntity with _$ChapterRequestEntity {
  const ChapterRequestEntity._();

  const factory ChapterRequestEntity({
    @Default(0) int articleid,
    @Default(0) int chapterid,
    String? chaptername,
    @Default(0) int chaptertype,
    @Default(0) int words,
    String? cover,
    List<ChapterRequestEntity>? chapterList,
  }) = _ChapterRequestEntity;

  factory ChapterRequestEntity.fromJson(Map<String, dynamic> json) =>
      _$ChapterRequestEntityFromJson(json);

  /// 是否為卷（含子章節）。
  bool get isVolume => chapterList != null && chapterList!.isNotEmpty;
}
