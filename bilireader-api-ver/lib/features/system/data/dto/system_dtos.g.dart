// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SignInResponseDto _$SignInResponseDtoFromJson(Map<String, dynamic> json) =>
    _SignInResponseDto(
      points: (json['points'] as num?)?.toInt() ?? 3,
      totalScore: (json['totalScore'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SignInResponseDtoToJson(_SignInResponseDto instance) =>
    <String, dynamic>{
      'points': instance.points,
      'totalScore': instance.totalScore,
    };

_VersionLogItemDto _$VersionLogItemDtoFromJson(Map<String, dynamic> json) =>
    _VersionLogItemDto(
      versionName: json['versionName'] as String?,
      updateContent: json['updateContent'] as String?,
      current: json['current'] as bool? ?? false,
    );

Map<String, dynamic> _$VersionLogItemDtoToJson(_VersionLogItemDto instance) =>
    <String, dynamic>{
      'versionName': instance.versionName,
      'updateContent': instance.updateContent,
      'current': instance.current,
    };

_AppStartupAnnouncementDto _$AppStartupAnnouncementDtoFromJson(
  Map<String, dynamic> json,
) => _AppStartupAnnouncementDto(
  bid: (json['bid'] as num?)?.toInt(),
  title: json['title'] as String?,
  content: json['content'] as String?,
  actionText: json['actionText'] as String?,
  actionUrl: json['actionUrl'] as String?,
  dismissKey: json['dismissKey'] as String?,
  description: json['description'] as String?,
  latestVersionName: json['latestVersionName'] as String?,
  latestVersionCode: (json['latestVersionCode'] as num?)?.toInt(),
  latestUpdateContent: json['latestUpdateContent'] as String?,
);

Map<String, dynamic> _$AppStartupAnnouncementDtoToJson(
  _AppStartupAnnouncementDto instance,
) => <String, dynamic>{
  'bid': instance.bid,
  'title': instance.title,
  'content': instance.content,
  'actionText': instance.actionText,
  'actionUrl': instance.actionUrl,
  'dismissKey': instance.dismissKey,
  'description': instance.description,
  'latestVersionName': instance.latestVersionName,
  'latestVersionCode': instance.latestVersionCode,
  'latestUpdateContent': instance.latestUpdateContent,
};

_FeedbackSubmitResponseDto _$FeedbackSubmitResponseDtoFromJson(
  Map<String, dynamic> json,
) => _FeedbackSubmitResponseDto(
  reportId: (json['reportId'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$FeedbackSubmitResponseDtoToJson(
  _FeedbackSubmitResponseDto instance,
) => <String, dynamic>{'reportId': instance.reportId};
