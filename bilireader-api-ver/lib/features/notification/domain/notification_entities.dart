import 'package:flutter/foundation.dart';

/// 通知分類分頁（設計稿「消息中心」chips）。doc 09 給了 interaction_notices / post_notices；
/// 「系統」的 wire 值 doc 未列，依語意推得 `system`（伺服器不識別時退回預設，不致錯誤）。
enum NotificationTab {
  interaction('interaction_notices', '互動通知'),
  post('post_notices', '貼文通知'),
  system('system', '系統');

  const NotificationTab(this.type, this.label);

  final String type;
  final String label;

  static const NotificationTab defaultValue = NotificationTab.interaction;
}

/// 通知種類（決定 `.nt-ic` 圖示）。由 `ntype`/`nstype` 關鍵字最佳推斷；未知歸 other。
enum NotificationKind { like, reply, flower, system, other }

/// 系統通知（顯示用；文字已轉繁，§5.0）。
@immutable
class AppNotification {
  const AppNotification({
    required this.notifyId,
    required this.kind,
    required this.headline,
    this.body = '',
    this.fromUserName,
    this.addTime = 0,
    this.isRead = false,
    this.topicId,
    this.articleId,
  });

  final int notifyId;
  final NotificationKind kind;

  /// 主標題（伺服器 content.title，否則以發文者名組合）。
  final String headline;

  /// 次要內容 / 引用（content.body 或書評標題）。
  final String body;
  final String? fromUserName;
  final int addTime;
  final bool isRead;
  final int? topicId;
  final int? articleId;

  /// 更新已讀狀態（其餘欄位不變）。供「全部已讀」就地標記，避免整列重抓而閃 loading /
  /// 掉捲動位置（UX F-08，體驗不變量#1）。
  AppNotification copyWith({bool? isRead}) => AppNotification(
    notifyId: notifyId,
    kind: kind,
    headline: headline,
    body: body,
    fromUserName: fromUserName,
    addTime: addTime,
    isRead: isRead ?? this.isRead,
    topicId: topicId,
    articleId: articleId,
  );
}

/// 一頁通知 + 未讀數。`NotificationListData` 無 `pages`，故以是否滿頁判斷 hasMore。
@immutable
class NotificationPage {
  const NotificationPage({
    required this.items,
    required this.pageNum,
    required this.unread,
    required this.hasMore,
  });

  final List<AppNotification> items;
  final int pageNum;
  final int unread;
  final bool hasMore;
}
