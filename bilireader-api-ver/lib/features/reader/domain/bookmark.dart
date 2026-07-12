import 'package:freezed_annotation/freezed_annotation.dart';

import 'reader_anchor.dart';

part 'bookmark.freezed.dart';
part 'bookmark.g.dart';

/// 使用者主動保存的閱讀位置（規範 §5.5）。可多筆；每筆保存完整 [ReaderAnchor]
/// 與書級中繼資料。與「每本一筆」的 ReadingProgress 分開建模。
@freezed
abstract class Bookmark with _$Bookmark {
  const factory Bookmark({
    required int ownerUid,
    required ReaderAnchor anchor,
    @Default('') String articleName,
    @Default('') String poster,

    /// 本地列 id（新建時為 null，寫入後由 DB 指派）。
    int? id,
  }) = _Bookmark;

  factory Bookmark.fromJson(Map<String, dynamic> json) =>
      _$BookmarkFromJson(json);
}
