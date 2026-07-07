import 'package:freezed_annotation/freezed_annotation.dart';

part 'circle_dtos.freezed.dart';
part 'circle_dtos.g.dart';

/// 圈子貼文 DTO（doc 10 §9.1 `CircleFeedItem`，wire = 駝峰）。
@freezed
abstract class CircleFeedItemDto with _$CircleFeedItemDto {
  const factory CircleFeedItemDto({
    @Default(0) int id,
    int? topicId,
    String? title,
    String? content,
    String? author,
    int? authorId,
    String? authorLevel,
    int? avatar,
    String? avatarUrl,
    int? sectionId,
    String? sectionName,
    String? category,
    String? tag,
    @Default(0) int likeNum,
    @Default(0) int badNum,
    @Default(0) int myReaction,
    @Default(0) int replies,
    @Default(0) int views,
    @Default(0) int postTime,
    @Default(0) int score,
    int? articleId,
    String? articleName,
    String? attachmentUrl,
    List<String>? attachmentUrls,
    int? islock,
    String? type,
  }) = _CircleFeedItemDto;

  factory CircleFeedItemDto.fromJson(Map<String, dynamic> json) =>
      _$CircleFeedItemDtoFromJson(json);
}

/// 圈子貼文分頁 DTO（doc 10 §9.2 `CircleFeedData`）。
@freezed
abstract class CircleFeedDataDto with _$CircleFeedDataDto {
  const factory CircleFeedDataDto({
    String? category,
    @Default(<CircleFeedItemDto>[]) List<CircleFeedItemDto> list,
    @Default(1) int pageNum,
    @Default(20) int pageSize,
    @Default(1) int pages,
    int? sectionId,
    @Default(0) int total,
  }) = _CircleFeedDataDto;

  factory CircleFeedDataDto.fromJson(Map<String, dynamic> json) =>
      _$CircleFeedDataDtoFromJson(json);
}

/// 版塊 DTO（doc 10 §9.3 `CircleSectionItem`）。
@freezed
abstract class CircleSectionDto with _$CircleSectionDto {
  const factory CircleSectionDto({
    @Default(0) int sectionId,
    @Default('') String sectionName,
    @Default('') String categoryName,
    @Default(0) int postCount,
    @Default(0) int topicCount,
  }) = _CircleSectionDto;

  factory CircleSectionDto.fromJson(Map<String, dynamic> json) =>
      _$CircleSectionDtoFromJson(json);
}

/// 圈子回覆 DTO（doc 10 §9.4 `CircleReplyItem`，wire 多為小寫）。
@freezed
abstract class CircleReplyDto with _$CircleReplyDto {
  const factory CircleReplyDto({
    @Default(0) int postid,
    @Default(0) int topicid,
    String? posttext,
    String? poster,
    String? posterLevel,
    @Default(0) int posterid,
    int? avatar,
    String? avatarUrl,
    @Default(0) int likeNum,
    @Default(0) int badNum,
    @Default(0) int myReaction,
    @Default(0) int posttime,
    @Default(0) int replypid,
    @Default(0) int replyppid,
    @Default(0) int depth,
    String? replyToPoster,
    String? subject,
    String? topicTitle,
    String? attachmentUrl,
    List<String>? attachmentUrls,
  }) = _CircleReplyDto;

  factory CircleReplyDto.fromJson(Map<String, dynamic> json) =>
      _$CircleReplyDtoFromJson(json);
}

/// 回覆分頁 DTO（doc 10 §9.5 `CircleRepliesData` = PageData）。
@freezed
abstract class CircleRepliesDataDto with _$CircleRepliesDataDto {
  const factory CircleRepliesDataDto({
    @Default(<CircleReplyDto>[]) List<CircleReplyDto> list,
    @Default(1) int pageNum,
    @Default(20) int pageSize,
    @Default(1) int pages,
    @Default(0) int total,
  }) = _CircleRepliesDataDto;

  factory CircleRepliesDataDto.fromJson(Map<String, dynamic> json) =>
      _$CircleRepliesDataDtoFromJson(json);
}

/// 反應結果 DTO（`circle/like`、`circle/reply_like`，doc 10 §9.5 `CircleReactionResult`）。
@freezed
abstract class CircleReactionDto with _$CircleReactionDto {
  const factory CircleReactionDto({
    @Default(0) int likeNum,
    @Default(0) int badNum,
    @Default(0) int myReaction,
    @Default(0) int type,
  }) = _CircleReactionDto;

  factory CircleReactionDto.fromJson(Map<String, dynamic> json) =>
      _$CircleReactionDtoFromJson(json);
}
