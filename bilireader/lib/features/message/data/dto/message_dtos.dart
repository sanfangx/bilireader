import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_dtos.freezed.dart';
part 'message_dtos.g.dart';

/// 私訊會話 DTO（doc 10 §10.4 `PrivateConversation`）。
@freezed
abstract class PrivateConversationDto with _$PrivateConversationDto {
  const factory PrivateConversationDto({
    @Default(0) int peerId,
    String? peerName,
    int? peerAvatar,
    String? peerAvatarUrl,
    String? lastContent,
    @Default(0) int lastFromId,
    String? lastFromName,
    @Default(0) int lastMessageId,
    @Default(0) int lastPostdate,
    @Default(0) int unreadCount,
  }) = _PrivateConversationDto;

  factory PrivateConversationDto.fromJson(Map<String, dynamic> json) =>
      _$PrivateConversationDtoFromJson(json);
}

/// 私訊訊息 DTO（doc 10 §10.5 `PrivateMessage`；wire key 多為小寫）。
/// REST history 與 WS chat_message/chat_ack 皆用此結構。
@freezed
abstract class PrivateMessageDto with _$PrivateMessageDto {
  const factory PrivateMessageDto({
    @Default(0) int messageid,
    @Default(0) int fromid,
    String? fromname,
    @Default(0) int toid,
    String? toname,
    String? content,
    @Default(0) int postdate,
    @Default(0) int isread,
    String? title,
    @Default(0) int quoteMessageId,
    @Default(0) int quoteFromid,
    String? quoteFromname,
    String? quoteContent,
  }) = _PrivateMessageDto;

  factory PrivateMessageDto.fromJson(Map<String, dynamic> json) =>
      _$PrivateMessageDtoFromJson(json);
}

/// 會話清單分頁（`PrivateConversationListData`）。
@freezed
abstract class PrivateConversationListDataDto
    with _$PrivateConversationListDataDto {
  const factory PrivateConversationListDataDto({
    @Default(<PrivateConversationDto>[]) List<PrivateConversationDto> list,
    @Default(1) int pageNum,
    @Default(20) int pageSize,
    @Default(0) int unread,
  }) = _PrivateConversationListDataDto;

  factory PrivateConversationListDataDto.fromJson(Map<String, dynamic> json) =>
      _$PrivateConversationListDataDtoFromJson(json);
}

/// 歷史訊息分頁（`PrivateMessageHistoryData`）。
@freezed
abstract class PrivateMessageHistoryDataDto
    with _$PrivateMessageHistoryDataDto {
  const factory PrivateMessageHistoryDataDto({
    @Default(<PrivateMessageDto>[]) List<PrivateMessageDto> list,
    @Default(1) int pageNum,
    @Default(30) int pageSize,
    @Default(0) int unread,
  }) = _PrivateMessageHistoryDataDto;

  factory PrivateMessageHistoryDataDto.fromJson(Map<String, dynamic> json) =>
      _$PrivateMessageHistoryDataDtoFromJson(json);
}
