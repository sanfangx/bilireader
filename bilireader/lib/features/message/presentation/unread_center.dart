import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/router/auth_controller.dart';
import '../../../core/ws/ws_providers.dart';
import 'message_controllers.dart';

part 'unread_center.g.dart';

/// 全域未讀狀態：私訊 + 互動通知，合併為 [total]（doc 08 §9 MessageUnreadCenter）。
@immutable
class UnreadState {
  const UnreadState({this.chat = 0, this.notice = 0});

  final int chat;
  final int notice;

  int get total => chat + notice;

  UnreadState copyWith({int? chat, int? notice}) =>
      UnreadState(chat: chat ?? this.chat, notice: notice ?? this.notice);
}

/// 全域未讀中心（doc 08 §9、doc 09 §1.2）。keepAlive：整個 App 生命週期共用，
/// 訂閱兩條 socket 的未讀事件，跨分頁廣播「私訊+通知」合併未讀，供 MainShell「我的」紅點。
///
/// - 未登入強制 0（doc 09 §1.2：`if (!isLogin) count = 0`）；socket 亦不連。
/// - 未讀以 socket 為主（doc 08 §9.1）：`*_connected`/`*_unread` 事件帶 `data.unread`。
///   'notification' 內容形狀未文件化（doc 08 §10）→ 不解析，只依賴有文件依據的 `*_unread`。
/// - F-04：收到 `chat_message` 一併 invalidate 會話列表（列表以 `skipLoadingOnReload` 不閃）。
@Riverpod(keepAlive: true)
class UnreadCenter extends _$UnreadCenter {
  @override
  UnreadState build() {
    // 未登入：歸零、確保 socket 斷開（doc 09 §1.2）。登入態變動時本 provider 會重建
    // （watch authController）。infra_providers 於登出 clear 時已 invalidate 兩 socket；
    // 此處再 disconnect 一次作防禦——避免任何排程時序下殘留 `_active` 的重連計時器。
    if (!ref.watch(authControllerProvider).isLoggedIn) {
      ref.read(noticeSocketProvider).disconnect();
      ref.read(chatSocketProvider).disconnect();
      return const UnreadState();
    }

    final notice = ref.watch(noticeSocketProvider)..connect();
    final chat = ref.watch(chatSocketProvider)..connect();

    final StreamSubscription<void> noticeSub = notice.events.listen((event) {
      if (event.type == 'notice_connected' || event.type == 'notice_unread') {
        final int? u = _unread(event.data);
        if (u != null) {
          state = state.copyWith(notice: u);
        }
      }
    });
    final StreamSubscription<void> chatSub = chat.events.listen((event) {
      switch (event.type) {
        case 'chat_connected':
        case 'chat_unread':
          final int? u = _unread(event.data);
          if (u != null) {
            state = state.copyWith(chat: u);
          }
        case 'chat_message':
          // F-04：新私訊 → 會話列表即時同步（message_list 用 skipLoadingOnReload → 不閃 loading）。
          ref.invalidate(conversationsProvider);
      }
    });
    ref.onDispose(() {
      noticeSub.cancel();
      chatSub.cancel();
    });

    return const UnreadState();
  }

  /// 防禦式解析 `data.unread`（形狀依 doc 08 §3.2；缺值/型別不符回 null，不臆測）。
  static int? _unread(Map<String, dynamic> data) {
    final int? u = (data['unread'] as num?)?.toInt();
    if (u == null) {
      return null;
    }
    return u < 0 ? 0 : u;
  }

  /// F-11：私訊已讀樂觀遞減（章評模式：先本地套用，socket 稍後以權威值校正）。
  /// 由呼叫端在標記已讀時樂觀呼叫；若標記失敗，呼叫端以 [incrementChat] 回滾。
  void decrementChat(int by) {
    if (by <= 0) {
      return;
    }
    final int next = state.chat - by;
    state = state.copyWith(chat: next < 0 ? 0 : next);
  }

  /// F-11 回滾：標記已讀失敗時把樂觀遞減的未讀補回。
  void incrementChat(int by) {
    if (by <= 0) {
      return;
    }
    state = state.copyWith(chat: state.chat + by);
  }

  /// F-11：單則通知已讀樂觀遞減（socket 稍後以權威值校正）。
  void decrementNotice(int by) {
    if (by <= 0) {
      return;
    }
    final int next = state.notice - by;
    state = state.copyWith(notice: next < 0 ? 0 : next);
  }

  /// F-11 回滾：單則已讀失敗時補回。
  void incrementNotice(int by) {
    if (by <= 0) {
      return;
    }
    state = state.copyWith(notice: state.notice + by);
  }

  /// F-11：通知「全部已讀」樂觀清零（socket 稍後推 notice_unread=0 校正）。
  void clearNotice() {
    if (state.notice != 0) {
      state = state.copyWith(notice: 0);
    }
  }
}
