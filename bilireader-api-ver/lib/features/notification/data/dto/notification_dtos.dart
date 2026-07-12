import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_dtos.freezed.dart';
part 'notification_dtos.g.dart';

/// 系統通知 DTO（doc 10 §10.1 `AppNotification`）。wire key 為縮寫，直接以縮寫作欄位名
/// （免 @JsonKey）。`ncontent` 是 JSON 字串，於 repo 再解析成 [AppNotificationContentDto]。
@freezed
abstract class AppNotificationDto with _$AppNotificationDto {
  const factory AppNotificationDto({
    @Default(0) int notifyid,
    String? ntype,
    String? nstype,
    @Default(0) int fuid,
    String? funame,
    @Default(0) int isread,
    @Default(0) int addtime,
    @Default(0) int eid,
    String? ename,
    String? ncontent,
    String? modname,
    String? etype,
    @Default(0) int upptime,
  }) = _AppNotificationDto;

  factory AppNotificationDto.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationDtoFromJson(json);
}

/// 通知內容（`ncontent` 解析後，doc 10 §10.2）。
@freezed
abstract class AppNotificationContentDto with _$AppNotificationContentDto {
  const factory AppNotificationContentDto({
    String? action,
    int? articleId,
    String? body,
    int? fromUserId,
    String? fromUserName,
    int? postId,
    int? replyPid,
    String? subtype,
    String? title,
    int? topicId,
  }) = _AppNotificationContentDto;

  factory AppNotificationContentDto.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationContentDtoFromJson(json);
}

/// 通知分頁（doc 10 §10.3 `NotificationListData`；以 `unread` 取代 `pages`）。
@freezed
abstract class NotificationListDataDto with _$NotificationListDataDto {
  const factory NotificationListDataDto({
    @Default(<AppNotificationDto>[]) List<AppNotificationDto> list,
    @Default(1) int pageNum,
    @Default(20) int pageSize,
    @Default(0) int unread,
  }) = _NotificationListDataDto;

  factory NotificationListDataDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationListDataDtoFromJson(json);
}
