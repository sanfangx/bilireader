// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotificationDto _$AppNotificationDtoFromJson(Map<String, dynamic> json) =>
    _AppNotificationDto(
      notifyid: (json['notifyid'] as num?)?.toInt() ?? 0,
      ntype: json['ntype'] as String?,
      nstype: json['nstype'] as String?,
      fuid: (json['fuid'] as num?)?.toInt() ?? 0,
      funame: json['funame'] as String?,
      isread: (json['isread'] as num?)?.toInt() ?? 0,
      addtime: (json['addtime'] as num?)?.toInt() ?? 0,
      eid: (json['eid'] as num?)?.toInt() ?? 0,
      ename: json['ename'] as String?,
      ncontent: json['ncontent'] as String?,
      modname: json['modname'] as String?,
      etype: json['etype'] as String?,
      upptime: (json['upptime'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AppNotificationDtoToJson(_AppNotificationDto instance) =>
    <String, dynamic>{
      'notifyid': instance.notifyid,
      'ntype': instance.ntype,
      'nstype': instance.nstype,
      'fuid': instance.fuid,
      'funame': instance.funame,
      'isread': instance.isread,
      'addtime': instance.addtime,
      'eid': instance.eid,
      'ename': instance.ename,
      'ncontent': instance.ncontent,
      'modname': instance.modname,
      'etype': instance.etype,
      'upptime': instance.upptime,
    };

_AppNotificationContentDto _$AppNotificationContentDtoFromJson(
  Map<String, dynamic> json,
) => _AppNotificationContentDto(
  action: json['action'] as String?,
  articleId: (json['articleId'] as num?)?.toInt(),
  body: json['body'] as String?,
  fromUserId: (json['fromUserId'] as num?)?.toInt(),
  fromUserName: json['fromUserName'] as String?,
  postId: (json['postId'] as num?)?.toInt(),
  replyPid: (json['replyPid'] as num?)?.toInt(),
  subtype: json['subtype'] as String?,
  title: json['title'] as String?,
  topicId: (json['topicId'] as num?)?.toInt(),
);

Map<String, dynamic> _$AppNotificationContentDtoToJson(
  _AppNotificationContentDto instance,
) => <String, dynamic>{
  'action': instance.action,
  'articleId': instance.articleId,
  'body': instance.body,
  'fromUserId': instance.fromUserId,
  'fromUserName': instance.fromUserName,
  'postId': instance.postId,
  'replyPid': instance.replyPid,
  'subtype': instance.subtype,
  'title': instance.title,
  'topicId': instance.topicId,
};

_NotificationListDataDto _$NotificationListDataDtoFromJson(
  Map<String, dynamic> json,
) => _NotificationListDataDto(
  list:
      (json['list'] as List<dynamic>?)
          ?.map((e) => AppNotificationDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AppNotificationDto>[],
  pageNum: (json['pageNum'] as num?)?.toInt() ?? 1,
  pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
  unread: (json['unread'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$NotificationListDataDtoToJson(
  _NotificationListDataDto instance,
) => <String, dynamic>{
  'list': instance.list,
  'pageNum': instance.pageNum,
  'pageSize': instance.pageSize,
  'unread': instance.unread,
};
