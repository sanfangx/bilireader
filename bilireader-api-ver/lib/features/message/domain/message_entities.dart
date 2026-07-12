import 'package:flutter/foundation.dart';

/// 私訊會話（列表項；顯示文字轉繁，§5.0）。
@immutable
class Conversation {
  const Conversation({
    required this.peerId,
    required this.peerName,
    this.avatarUrl,
    this.lastContent = '',
    this.lastPostdate = 0,
    this.unreadCount = 0,
  });

  final int peerId;
  final String peerName;
  final String? avatarUrl;
  final String lastContent;
  final int lastPostdate;
  final int unreadCount;
}

/// 一則私訊（對話頁氣泡；由本地快取列或 REST/WS DTO 映射）。
/// `isMine` 由呼叫端以 `fromId == 目前 uid` 判斷（out 氣泡）。
@immutable
class ChatMessage {
  const ChatMessage({
    required this.messageId,
    required this.fromId,
    required this.content,
    this.fromName,
    this.postDate = 0,
    this.isRead = false,
    this.quoteContent,
    this.quoteFromName,
  });

  final int messageId;
  final int fromId;
  final String content;
  final String? fromName;
  final int postDate;
  final bool isRead;
  final String? quoteContent;
  final String? quoteFromName;
}
