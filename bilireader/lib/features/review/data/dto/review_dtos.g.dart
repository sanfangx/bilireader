// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookReviewItemDto _$BookReviewItemDtoFromJson(Map<String, dynamic> json) =>
    _BookReviewItemDto(
      topicid: (json['topicid'] as num?)?.toInt() ?? 0,
      articleid: (json['articleid'] as num?)?.toInt() ?? 0,
      avatar: (json['avatar'] as num?)?.toInt(),
      avatarUrl: json['avatarUrl'] as String?,
      poster: json['poster'] as String?,
      posterLevel: json['posterLevel'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
      likeNum: (json['likeNum'] as num?)?.toInt() ?? 0,
      badNum: (json['badNum'] as num?)?.toInt() ?? 0,
      myReaction: (json['myReaction'] as num?)?.toInt() ?? 0,
      replies: (json['replies'] as num?)?.toInt() ?? 0,
      posttime: (json['posttime'] as num?)?.toInt() ?? 0,
      ispoiler: (json['ispoiler'] as num?)?.toInt() ?? 0,
      isgood: (json['isgood'] as num?)?.toInt() ?? 0,
      istop: (json['istop'] as num?)?.toInt() ?? 0,
      views: (json['views'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$BookReviewItemDtoToJson(_BookReviewItemDto instance) =>
    <String, dynamic>{
      'topicid': instance.topicid,
      'articleid': instance.articleid,
      'avatar': instance.avatar,
      'avatarUrl': instance.avatarUrl,
      'poster': instance.poster,
      'posterLevel': instance.posterLevel,
      'title': instance.title,
      'content': instance.content,
      'likeNum': instance.likeNum,
      'badNum': instance.badNum,
      'myReaction': instance.myReaction,
      'replies': instance.replies,
      'posttime': instance.posttime,
      'ispoiler': instance.ispoiler,
      'isgood': instance.isgood,
      'istop': instance.istop,
      'views': instance.views,
    };

_BookReplyItemDto _$BookReplyItemDtoFromJson(Map<String, dynamic> json) =>
    _BookReplyItemDto(
      postid: (json['postid'] as num?)?.toInt() ?? 0,
      avatar: (json['avatar'] as num?)?.toInt(),
      avatarUrl: json['avatarUrl'] as String?,
      poster: json['poster'] as String?,
      posterLevel: json['posterLevel'] as String?,
      posttext: json['posttext'] as String?,
      likeNum: (json['likeNum'] as num?)?.toInt() ?? 0,
      badNum: (json['badNum'] as num?)?.toInt() ?? 0,
      myReaction: (json['myReaction'] as num?)?.toInt() ?? 0,
      posttime: (json['posttime'] as num?)?.toInt() ?? 0,
      replyToPoster: json['replyToPoster'] as String?,
      topicid: (json['topicid'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$BookReplyItemDtoToJson(_BookReplyItemDto instance) =>
    <String, dynamic>{
      'postid': instance.postid,
      'avatar': instance.avatar,
      'avatarUrl': instance.avatarUrl,
      'poster': instance.poster,
      'posterLevel': instance.posterLevel,
      'posttext': instance.posttext,
      'likeNum': instance.likeNum,
      'badNum': instance.badNum,
      'myReaction': instance.myReaction,
      'posttime': instance.posttime,
      'replyToPoster': instance.replyToPoster,
      'topicid': instance.topicid,
    };

_BookReviewListDataDto _$BookReviewListDataDtoFromJson(
  Map<String, dynamic> json,
) => _BookReviewListDataDto(
  list:
      (json['list'] as List<dynamic>?)
          ?.map((e) => BookReviewItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <BookReviewItemDto>[],
  pageNum: (json['pageNum'] as num?)?.toInt() ?? 1,
  pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
  pages: (json['pages'] as num?)?.toInt() ?? 1,
  total: (json['total'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$BookReviewListDataDtoToJson(
  _BookReviewListDataDto instance,
) => <String, dynamic>{
  'list': instance.list,
  'pageNum': instance.pageNum,
  'pageSize': instance.pageSize,
  'pages': instance.pages,
  'total': instance.total,
};

_BookReviewRepliesDataDto _$BookReviewRepliesDataDtoFromJson(
  Map<String, dynamic> json,
) => _BookReviewRepliesDataDto(
  list:
      (json['list'] as List<dynamic>?)
          ?.map((e) => BookReplyItemDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <BookReplyItemDto>[],
  pageNum: (json['pageNum'] as num?)?.toInt() ?? 1,
  pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
  pages: (json['pages'] as num?)?.toInt() ?? 1,
  total: (json['total'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$BookReviewRepliesDataDtoToJson(
  _BookReviewRepliesDataDto instance,
) => <String, dynamic>{
  'list': instance.list,
  'pageNum': instance.pageNum,
  'pageSize': instance.pageSize,
  'pages': instance.pages,
  'total': instance.total,
};

_ReviewReactionDto _$ReviewReactionDtoFromJson(Map<String, dynamic> json) =>
    _ReviewReactionDto(
      likeNum: (json['likeNum'] as num?)?.toInt() ?? 0,
      badNum: (json['badNum'] as num?)?.toInt() ?? 0,
      myReaction: (json['myReaction'] as num?)?.toInt() ?? 0,
      type: (json['type'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ReviewReactionDtoToJson(_ReviewReactionDto instance) =>
    <String, dynamic>{
      'likeNum': instance.likeNum,
      'badNum': instance.badNum,
      'myReaction': instance.myReaction,
      'type': instance.type,
    };
