// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PrivateConversationDto _$PrivateConversationDtoFromJson(
  Map<String, dynamic> json,
) => _PrivateConversationDto(
  peerId: (json['peerId'] as num?)?.toInt() ?? 0,
  peerName: json['peerName'] as String?,
  peerAvatar: (json['peerAvatar'] as num?)?.toInt(),
  peerAvatarUrl: json['peerAvatarUrl'] as String?,
  lastContent: json['lastContent'] as String?,
  lastFromId: (json['lastFromId'] as num?)?.toInt() ?? 0,
  lastFromName: json['lastFromName'] as String?,
  lastMessageId: (json['lastMessageId'] as num?)?.toInt() ?? 0,
  lastPostdate: (json['lastPostdate'] as num?)?.toInt() ?? 0,
  unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PrivateConversationDtoToJson(
  _PrivateConversationDto instance,
) => <String, dynamic>{
  'peerId': instance.peerId,
  'peerName': instance.peerName,
  'peerAvatar': instance.peerAvatar,
  'peerAvatarUrl': instance.peerAvatarUrl,
  'lastContent': instance.lastContent,
  'lastFromId': instance.lastFromId,
  'lastFromName': instance.lastFromName,
  'lastMessageId': instance.lastMessageId,
  'lastPostdate': instance.lastPostdate,
  'unreadCount': instance.unreadCount,
};

_PrivateMessageDto _$PrivateMessageDtoFromJson(Map<String, dynamic> json) =>
    _PrivateMessageDto(
      messageid: (json['messageid'] as num?)?.toInt() ?? 0,
      fromid: (json['fromid'] as num?)?.toInt() ?? 0,
      fromname: json['fromname'] as String?,
      toid: (json['toid'] as num?)?.toInt() ?? 0,
      toname: json['toname'] as String?,
      content: json['content'] as String?,
      postdate: (json['postdate'] as num?)?.toInt() ?? 0,
      isread: (json['isread'] as num?)?.toInt() ?? 0,
      title: json['title'] as String?,
      quoteMessageId: (json['quoteMessageId'] as num?)?.toInt() ?? 0,
      quoteFromid: (json['quoteFromid'] as num?)?.toInt() ?? 0,
      quoteFromname: json['quoteFromname'] as String?,
      quoteContent: json['quoteContent'] as String?,
    );

Map<String, dynamic> _$PrivateMessageDtoToJson(_PrivateMessageDto instance) =>
    <String, dynamic>{
      'messageid': instance.messageid,
      'fromid': instance.fromid,
      'fromname': instance.fromname,
      'toid': instance.toid,
      'toname': instance.toname,
      'content': instance.content,
      'postdate': instance.postdate,
      'isread': instance.isread,
      'title': instance.title,
      'quoteMessageId': instance.quoteMessageId,
      'quoteFromid': instance.quoteFromid,
      'quoteFromname': instance.quoteFromname,
      'quoteContent': instance.quoteContent,
    };

_PrivateConversationListDataDto _$PrivateConversationListDataDtoFromJson(
  Map<String, dynamic> json,
) => _PrivateConversationListDataDto(
  list:
      (json['list'] as List<dynamic>?)
          ?.map(
            (e) => PrivateConversationDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <PrivateConversationDto>[],
  pageNum: (json['pageNum'] as num?)?.toInt() ?? 1,
  pageSize: (json['pageSize'] as num?)?.toInt() ?? 20,
  unread: (json['unread'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PrivateConversationListDataDtoToJson(
  _PrivateConversationListDataDto instance,
) => <String, dynamic>{
  'list': instance.list,
  'pageNum': instance.pageNum,
  'pageSize': instance.pageSize,
  'unread': instance.unread,
};

_PrivateMessageHistoryDataDto _$PrivateMessageHistoryDataDtoFromJson(
  Map<String, dynamic> json,
) => _PrivateMessageHistoryDataDto(
  list:
      (json['list'] as List<dynamic>?)
          ?.map((e) => PrivateMessageDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PrivateMessageDto>[],
  pageNum: (json['pageNum'] as num?)?.toInt() ?? 1,
  pageSize: (json['pageSize'] as num?)?.toInt() ?? 30,
  unread: (json['unread'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PrivateMessageHistoryDataDtoToJson(
  _PrivateMessageHistoryDataDto instance,
) => <String, dynamic>{
  'list': instance.list,
  'pageNum': instance.pageNum,
  'pageSize': instance.pageSize,
  'unread': instance.unread,
};
