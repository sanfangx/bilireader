import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookshelf_item.freezed.dart';
part 'bookshelf_item.g.dart';

/// 書架條目 DTO（doc 10 §6.1 `BookshelfItem`）。wire key = 欄位名（無 `@SerializedName`）。
/// 時間欄位（joindate/lastupdate/lastvisit）為秒級 int；`poster` 為封面 URL。
@freezed
abstract class BookshelfItem with _$BookshelfItem {
  const factory BookshelfItem({
    @Default(0) int caseid,
    @Default(0) int articleid,
    String? articlename,
    String? author,
    String? poster,
    @Default(0) int classid,
    @Default(0) int chapterid,
    String? chaptername,
    @Default(0) int chapterorder,
    @Default(0) int pageid,
    @Default(0) int progress,
    @Default(0) int joindate,
    @Default(0) int lastupdate,
    @Default(0) int lastvisit,
    String? lastchapter,
    @Default(0) int lastchapterid,
    @Default(0) int words,
    @Default(0) int allvote,
    @Default(0) int goodnum,
    String? intro,
  }) = _BookshelfItem;

  factory BookshelfItem.fromJson(Map<String, dynamic> json) =>
      _$BookshelfItemFromJson(json);
}
