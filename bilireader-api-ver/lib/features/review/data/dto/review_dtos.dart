import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_dtos.freezed.dart';
part 'review_dtos.g.dart';

/// 書評 DTO（doc 10 §7.1 `BookReviewItem`）。BookReviewItem 無「每則評分」欄位，
/// 故顯示層不呈現星等（§No Mock Data）；精華以 [isgood] 呈現。
@freezed
abstract class BookReviewItemDto with _$BookReviewItemDto {
  const factory BookReviewItemDto({
    @Default(0) int topicid,
    @Default(0) int articleid,
    int? avatar,
    String? avatarUrl,
    String? poster,
    String? posterLevel,
    String? title,
    String? content,
    @Default(0) int likeNum,
    @Default(0) int badNum,
    @Default(0) int myReaction,
    @Default(0) int replies,
    @Default(0) int posttime,
    @Default(0) int ispoiler,
    @Default(0) int isgood,
    @Default(0) int istop,
    @Default(0) int views,
  }) = _BookReviewItemDto;

  factory BookReviewItemDto.fromJson(Map<String, dynamic> json) =>
      _$BookReviewItemDtoFromJson(json);
}

/// 書評回覆 DTO（doc 10 §7.3 `BookReplyItem`）。
@freezed
abstract class BookReplyItemDto with _$BookReplyItemDto {
  const factory BookReplyItemDto({
    @Default(0) int postid,
    int? avatar,
    String? avatarUrl,
    String? poster,
    String? posterLevel,
    String? posttext,
    @Default(0) int likeNum,
    @Default(0) int badNum,
    @Default(0) int myReaction,
    @Default(0) int posttime,
    String? replyToPoster,
    @Default(0) int topicid,
  }) = _BookReplyItemDto;

  factory BookReplyItemDto.fromJson(Map<String, dynamic> json) =>
      _$BookReplyItemDtoFromJson(json);
}

/// 書評分頁（`BookReviewListData = PageData<BookReviewItem>`）。
@freezed
abstract class BookReviewListDataDto with _$BookReviewListDataDto {
  const factory BookReviewListDataDto({
    @Default(<BookReviewItemDto>[]) List<BookReviewItemDto> list,
    @Default(1) int pageNum,
    @Default(20) int pageSize,
    @Default(1) int pages,
    @Default(0) int total,
  }) = _BookReviewListDataDto;

  factory BookReviewListDataDto.fromJson(Map<String, dynamic> json) =>
      _$BookReviewListDataDtoFromJson(json);
}

/// 書評回覆分頁（`BookReviewRepliesData = PageData<BookReplyItem>`）。
@freezed
abstract class BookReviewRepliesDataDto with _$BookReviewRepliesDataDto {
  const factory BookReviewRepliesDataDto({
    @Default(<BookReplyItemDto>[]) List<BookReplyItemDto> list,
    @Default(1) int pageNum,
    @Default(20) int pageSize,
    @Default(1) int pages,
    @Default(0) int total,
  }) = _BookReviewRepliesDataDto;

  factory BookReviewRepliesDataDto.fromJson(Map<String, dynamic> json) =>
      _$BookReviewRepliesDataDtoFromJson(json);
}

/// 反應結果 DTO（`book_review/like`、`reply_like`，{likeNum,badNum,myReaction,type}）。
@freezed
abstract class ReviewReactionDto with _$ReviewReactionDto {
  const factory ReviewReactionDto({
    @Default(0) int likeNum,
    @Default(0) int badNum,
    @Default(0) int myReaction,
    @Default(0) int type,
  }) = _ReviewReactionDto;

  factory ReviewReactionDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewReactionDtoFromJson(json);
}
