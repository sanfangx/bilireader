// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CircleFeedItemDto _$CircleFeedItemDtoFromJson(Map<String, dynamic> json) =>
    _CircleFeedItemDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      topicId: (json['topicId'] as num?)?.toInt(),
      title: json['title'] as String?,
      content: json['content'] as String?,
      author: json['author'] as String?,
      authorId: (json['authorId'] as num?)?.toInt(),
      authorLevel: json['authorLevel'] as String?,
      avatar: (json['avatar'] as num?)?.toInt(),
      avatarUrl: json['avatarUrl'] as String?,
      sectionId: (json['sectionId'] as num?)?.toInt(),
      sectionName: json['sectionName'] as String?,
      category: json['category'] as String?,
      tag: json['tag'] as String?,
      likeNum: (json['likeNum'] as num?)?.toInt() ?? 0,
      badNum: (json['badNum'] as num?)?.toInt() ?? 0,
      myReaction: (json['myReaction'] as num?)?.toInt() ?? 0,
      replies: (json['replies'] as num?)?.toInt() ?? 0,
      views: (json['views'] as num?)?.toInt() ?? 0,
      postTime: (json['postTime'] as num?)?.toInt() ?? 0,
      score: (json['score'] as num?)?.toInt() ?? 0,
      articleId: (json['articleId'] as num?)?.toInt(),
      articleName: json['articleName'] as String?,
      attachmentUrl: json['attachmentUrl'] as String?,
      attachmentUrls: (json['attachmentUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      islock: (json['islock'] as num?)?.toInt(),
      type: json['type'] as String?,
    );

Map<String, dynamic> _$CircleFeedItemDtoToJson(_CircleFeedItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topicId': instance.topicId,
      'title': instance.title,
      'content': instance.content,
      'author': instance.author,
      'authorId': instance.authorId,
      'authorLevel': instance.authorLevel,
      'avatar': instance.avatar,
      'avatarUrl': instance.avatarUrl,
      'sectionId': instance.sectionId,
      'sectionName': instance.sectionName,
      'category': instance.category,
      'tag': instance.tag,
      'likeNum': instance.likeNum,
      'badNum': instance.badNum,
      'myReaction': instance.myReaction,
      'replies': instance.replies,
      'views': instance.views,
      'postTime': instance.postTime,
      'score': instance.score,
      'articleId': instance.articleId,
      'articleName': instance.articleName,
      'attachmentUrl': instance.attachmentUrl,
      'attachmentUrls': instance.attachmentUrls,
      'islock': instance.islock,
      'type': instance.type,
    };

_CircleFeedDataDto _$CircleFeedDataDtoFromJson(Map<String, dynamic> json) =>
    _CircleFeedDataDto(
      category: json['category'] as String?,
      list:
          (json['list'] as List<dynamic>?)
              ?.map(
                (e) => CircleFeedItemDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <CircleFeedItemDto>[],
      pageNum: (json['pageNum'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
      pages: (json['pages'] as num?)?.toInt() ?? 1,
      sectionId: (json['sectionId'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CircleFeedDataDtoToJson(_CircleFeedDataDto instance) =>
    <String, dynamic>{
      'category': instance.category,
      'list': instance.list,
      'pageNum': instance.pageNum,
      'pageSize': instance.pageSize,
      'pages': instance.pages,
      'sectionId': instance.sectionId,
      'total': instance.total,
    };

_CircleSectionDto _$CircleSectionDtoFromJson(Map<String, dynamic> json) =>
    _CircleSectionDto(
      sectionId: (json['sectionId'] as num?)?.toInt() ?? 0,
      sectionName: json['sectionName'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? '',
      postCount: (json['postCount'] as num?)?.toInt() ?? 0,
      topicCount: (json['topicCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CircleSectionDtoToJson(_CircleSectionDto instance) =>
    <String, dynamic>{
      'sectionId': instance.sectionId,
      'sectionName': instance.sectionName,
      'categoryName': instance.categoryName,
      'postCount': instance.postCount,
      'topicCount': instance.topicCount,
    };

_CircleReplyDto _$CircleReplyDtoFromJson(Map<String, dynamic> json) =>
    _CircleReplyDto(
      postid: (json['postid'] as num?)?.toInt() ?? 0,
      topicid: (json['topicid'] as num?)?.toInt() ?? 0,
      posttext: json['posttext'] as String?,
      poster: json['poster'] as String?,
      posterLevel: json['posterLevel'] as String?,
      posterid: (json['posterid'] as num?)?.toInt() ?? 0,
      avatar: (json['avatar'] as num?)?.toInt(),
      avatarUrl: json['avatarUrl'] as String?,
      likeNum: (json['likeNum'] as num?)?.toInt() ?? 0,
      badNum: (json['badNum'] as num?)?.toInt() ?? 0,
      myReaction: (json['myReaction'] as num?)?.toInt() ?? 0,
      posttime: (json['posttime'] as num?)?.toInt() ?? 0,
      replypid: (json['replypid'] as num?)?.toInt() ?? 0,
      replyppid: (json['replyppid'] as num?)?.toInt() ?? 0,
      depth: (json['depth'] as num?)?.toInt() ?? 0,
      replyToPoster: json['replyToPoster'] as String?,
      subject: json['subject'] as String?,
      topicTitle: json['topicTitle'] as String?,
      attachmentUrl: json['attachmentUrl'] as String?,
      attachmentUrls: (json['attachmentUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$CircleReplyDtoToJson(_CircleReplyDto instance) =>
    <String, dynamic>{
      'postid': instance.postid,
      'topicid': instance.topicid,
      'posttext': instance.posttext,
      'poster': instance.poster,
      'posterLevel': instance.posterLevel,
      'posterid': instance.posterid,
      'avatar': instance.avatar,
      'avatarUrl': instance.avatarUrl,
      'likeNum': instance.likeNum,
      'badNum': instance.badNum,
      'myReaction': instance.myReaction,
      'posttime': instance.posttime,
      'replypid': instance.replypid,
      'replyppid': instance.replyppid,
      'depth': instance.depth,
      'replyToPoster': instance.replyToPoster,
      'subject': instance.subject,
      'topicTitle': instance.topicTitle,
      'attachmentUrl': instance.attachmentUrl,
      'attachmentUrls': instance.attachmentUrls,
    };

_CircleRepliesDataDto _$CircleRepliesDataDtoFromJson(
  Map<String, dynamic> json,
) => _CircleRepliesDataDto(
  list:
      (json['list'] as List<dynamic>?)
          ?.map((e) => CircleReplyDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <CircleReplyDto>[],
  pageNum: (json['pageNum'] as num?)?.toInt() ?? 1,
  pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
  pages: (json['pages'] as num?)?.toInt() ?? 1,
  total: (json['total'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$CircleRepliesDataDtoToJson(
  _CircleRepliesDataDto instance,
) => <String, dynamic>{
  'list': instance.list,
  'pageNum': instance.pageNum,
  'pageSize': instance.pageSize,
  'pages': instance.pages,
  'total': instance.total,
};

_CircleReactionDto _$CircleReactionDtoFromJson(Map<String, dynamic> json) =>
    _CircleReactionDto(
      likeNum: (json['likeNum'] as num?)?.toInt() ?? 0,
      badNum: (json['badNum'] as num?)?.toInt() ?? 0,
      myReaction: (json['myReaction'] as num?)?.toInt() ?? 0,
      type: (json['type'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$CircleReactionDtoToJson(_CircleReactionDto instance) =>
    <String, dynamic>{
      'likeNum': instance.likeNum,
      'badNum': instance.badNum,
      'myReaction': instance.myReaction,
      'type': instance.type,
    };
