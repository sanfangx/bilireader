// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_comment_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChapterCommentItemDto _$ChapterCommentItemDtoFromJson(
  Map<String, dynamic> json,
) => _ChapterCommentItemDto(
  id: json['id'] == null ? 0 : _looseInt(json['id']),
  catid: json['catid'] == null ? 0 : _looseInt(json['catid']),
  cmtid: json['cmtid'] == null ? 0 : _looseInt(json['cmtid']),
  userid: json['userid'] == null ? 0 : _looseInt(json['userid']),
  cmtname: _looseStr(json['cmtname']),
  cmtcontent: _looseStr(json['cmtcontent']),
  addtime: _looseStr(json['addtime']),
  likeNum: json['likeNum'] == null ? 0 : _looseInt(json['likeNum']),
  badNum: json['badNum'] == null ? 0 : _looseInt(json['badNum']),
  myReaction: json['myReaction'] == null ? 0 : _looseInt(json['myReaction']),
  ischeck: json['ischeck'] == null ? 0 : _looseInt(json['ischeck']),
  ishot: json['ishot'] == null ? 0 : _looseInt(json['ishot']),
  ispoiler: json['ispoiler'] == null ? 0 : _looseInt(json['ispoiler']),
  parentid: json['parentid'] == null ? 0 : _looseInt(json['parentid']),
  avatar: _looseIntN(json['avatar']),
  avatarUrl: _looseStr(json['avatarUrl']),
  cmtLevel: _looseStr(json['cmtLevel']),
);

Map<String, dynamic> _$ChapterCommentItemDtoToJson(
  _ChapterCommentItemDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'catid': instance.catid,
  'cmtid': instance.cmtid,
  'userid': instance.userid,
  'cmtname': instance.cmtname,
  'cmtcontent': instance.cmtcontent,
  'addtime': instance.addtime,
  'likeNum': instance.likeNum,
  'badNum': instance.badNum,
  'myReaction': instance.myReaction,
  'ischeck': instance.ischeck,
  'ishot': instance.ishot,
  'ispoiler': instance.ispoiler,
  'parentid': instance.parentid,
  'avatar': instance.avatar,
  'avatarUrl': instance.avatarUrl,
  'cmtLevel': instance.cmtLevel,
};

_ChapterCommentListDataDto _$ChapterCommentListDataDtoFromJson(
  Map<String, dynamic> json,
) => _ChapterCommentListDataDto(
  list:
      (json['list'] as List<dynamic>?)
          ?.map(
            (e) => ChapterCommentItemDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <ChapterCommentItemDto>[],
  pageNum: (json['pageNum'] as num?)?.toInt() ?? 1,
  pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
  pages: (json['pages'] as num?)?.toInt() ?? 1,
  total: (json['total'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ChapterCommentListDataDtoToJson(
  _ChapterCommentListDataDto instance,
) => <String, dynamic>{
  'list': instance.list,
  'pageNum': instance.pageNum,
  'pageSize': instance.pageSize,
  'pages': instance.pages,
  'total': instance.total,
};

_ChapterCommentReactionDto _$ChapterCommentReactionDtoFromJson(
  Map<String, dynamic> json,
) => _ChapterCommentReactionDto(
  likeNum: (json['likeNum'] as num?)?.toInt() ?? 0,
  badNum: (json['badNum'] as num?)?.toInt() ?? 0,
  myReaction: (json['myReaction'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ChapterCommentReactionDtoToJson(
  _ChapterCommentReactionDto instance,
) => <String, dynamic>{
  'likeNum': instance.likeNum,
  'badNum': instance.badNum,
  'myReaction': instance.myReaction,
};
