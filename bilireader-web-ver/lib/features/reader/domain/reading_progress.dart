import 'package:freezed_annotation/freezed_annotation.dart';

import 'reader_anchor.dart';

part 'reading_progress.freezed.dart';
part 'reading_progress.g.dart';

/// 每本書一筆的「繼續閱讀位置」。書架的「繼續閱讀」觀察此狀態；閱讀器更新後書架即時刷新。
/// 與可多筆的 [Bookmark] 分開建模。忠實移植自 api-ver。
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
