import 'package:freezed_annotation/freezed_annotation.dart';

import 'reader_anchor.dart';

part 'reading_progress.freezed.dart';
part 'reading_progress.g.dart';

/// 每本書一筆的「繼續閱讀位置」（規範 §5.5）。書架的「繼續閱讀」觀察此狀態；
/// 閱讀器更新後書架應能即時顯示最新章節與文字片段。與可多筆的 Bookmark 分開建模。
@freezed
abstract class ReadingProgress with _$ReadingProgress {
  const factory ReadingProgress({
    required int ownerUid,
    required ReaderAnchor anchor,
    @Default('') String articleName,
    @Default('') String poster,
    @Default(0) int updatedAt,
  }) = _ReadingProgress;

  factory ReadingProgress.fromJson(Map<String, dynamic> json) =>
      _$ReadingProgressFromJson(json);
}
