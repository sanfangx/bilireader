import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/router/auth_controller.dart';
import '../../../core/ws/ws_providers.dart';
import '../../message/presentation/unread_center.dart';
import '../data/notification_providers.dart';
import '../domain/notification_entities.dart';

part 'notification_controllers.g.dart';

/// 通知需登入（doc 09 §7 loginRequiredPages 含 messages/notices）；未登入短路（§6.3）。
void _requireLogin(Ref ref) {
  if (!ref.watch(authControllerProvider).isLoggedIn) {
    throw ErrorMapper.fromBusinessCode(code: ApiConstants.codeTokenInvalid);
  }
}

/// 目前通知分類分頁。
@riverpod
class NotificationTabState extends _$NotificationTabState {
  @override
  NotificationTab build() => NotificationTab.defaultValue;

  void select(NotificationTab tab) {
    if (tab != state) {
      state = tab;
    }
  }
}

/// 通知列表狀態（分頁累積 + 未讀數）。
@immutable
class NotificationListState {
  const NotificationListState({
    this.items = const <AppNotification>[],
    this.unread = 0,
    this.page = ApiConstants.firstPage,
    this.hasMore = true,
    this.loadingMore = false,
    this.loadMoreError = false,
    this.hasNew = false,
  });

  final List<AppNotification> items;
  final int unread;
  final int page;
  final bool hasMore;
  final bool loadingMore;

  /// F-15：載入更多失敗（尾端顯示重試而非靜默停止）。
  final bool loadMoreError;

  /// F-06：停留頁面時收到新通知（socket 'notification'）→ 顯示「有新通知」提示條，
  /// 由使用者點擊才刷新（避免整列重抓打斷瀏覽、掉捲動；不變量#1）。
  final bool hasNew;

  NotificationListState copyWith({
    List<AppNotification>? items,
    int? unread,
    int? page,
    bool? hasMore,
    bool? loadingMore,
    bool? loadMoreError,
    bool? hasNew,
  }) => NotificationListState(
    items: items ?? this.items,
    unread: unread ?? this.unread,
    page: page ?? this.page,
    hasMore: hasMore ?? this.hasMore,
    loadingMore: loadingMore ?? this.loadingMore,
    loadMoreError: loadMoreError ?? this.loadMoreError,
    hasNew: hasNew ?? this.hasNew,
  );
}

/// 通知列表（依分類）。連上 notice WebSocket；收到新通知/未讀變更即刷新（doc 08）。
@riverpod
class NotificationListController extends _$NotificationListController {
  @override
  Future<NotificationListState> build(NotificationTab tab) async {
    _requireLogin(ref);
    // 連上通知通道並即時反映事件。socket 為 keepAlive。F-06：不再一律 invalidateSelf
    // （會把使用者拉回第 1 頁、掉捲動），改為區分事件型別：
    //   - notice_unread：只就地更新未讀數（data.unread 有文件依據，doc 08 §3.2）。
    //   - notification：只標記 hasNew（顯示頂部提示條，點擊才刷新）；不解析其未文件化的內容。
    final socket = ref.watch(noticeSocketProvider)..connect();
    final StreamSubscription<void> sub = socket.events.listen((event) {
      final AsyncValue<NotificationListState> current = state;
      if (current is! AsyncData<NotificationListState>) {
        return;
      }
      switch (event.type) {
        case 'notice_unread':
        case 'notice_connected':
          final int? u = (event.data['unread'] as num?)?.toInt();
          if (u != null) {
            state = AsyncData<NotificationListState>(
              current.value.copyWith(unread: u < 0 ? 0 : u),
            );
          }
        case 'notification':
          state = AsyncData<NotificationListState>(
            current.value.copyWith(hasNew: true),
          );
      }
    });
    ref.onDispose(sub.cancel);

    final NotificationPage p =
        (await ref
                .read(notificationRepositoryProvider)
                .list(tab: tab, page: ApiConstants.firstPage))
            .dataOrThrow();
    return NotificationListState(
      items: p.items,
      unread: p.unread,
      page: p.pageNum,
      hasMore: p.hasMore,
    );
  }

  /// F-14 下拉刷新：重抓第一頁但**保留現有列表**（不進 AsyncLoading，避免整頁閃 loading /
  /// 掉捲動）。僅在已有結果時有效；刷新成功→全新第一頁（hasNew 隨之清除），
  /// 刷新失敗→保留舊資料與 hasNew（banner 留存可再試）。
  Future<void> refresh() async {
    final AsyncValue<NotificationListState> current = state;
    if (current is! AsyncData<NotificationListState>) {
      return;
    }
    final ApiResult<NotificationPage> result = await ref
        .read(notificationRepositoryProvider)
        .list(tab: tab, page: ApiConstants.firstPage);
    // 刷新成功→全新第一頁（hasNew 隨之清除）；失敗→保留現有列表與 hasNew（不變量#1）。
    if (result is ApiSuccess<NotificationPage>) {
      final NotificationPage p = result.data;
      // 邊界：載入期間 socket 又推來新通知（build listener 設 hasNew=true）→ 保留該旗標，
      // 否則刷新會把「有更新於本頁之後」的提示吞掉（審查發現的時序邊界）。
      final AsyncValue<NotificationListState> now = state;
      final bool hasNew =
          now is AsyncData<NotificationListState> && now.value.hasNew;
      state = AsyncData<NotificationListState>(
        NotificationListState(
          items: p.items,
          unread: p.unread,
          page: p.pageNum,
          hasMore: p.hasMore,
          hasNew: hasNew,
        ),
      );
    }
  }

  Future<void> loadMore() async {
    final AsyncValue<NotificationListState> current = state;
    if (current is! AsyncData<NotificationListState>) {
      return;
    }
    final NotificationListState view = current.value;
    if (!view.hasMore || view.loadingMore || view.loadMoreError) {
      return;
    }
    await _fetchMore(view);
  }

  /// F-15：載入更多失敗後由尾端「點擊重試」呼叫。
  Future<void> retryLoadMore() async {
    final AsyncValue<NotificationListState> current = state;
    if (current is! AsyncData<NotificationListState>) {
      return;
    }
    if (current.value.loadingMore) {
      return;
    }
    await _fetchMore(current.value.copyWith(loadMoreError: false));
  }

  Future<void> _fetchMore(NotificationListState view) async {
    state = AsyncData<NotificationListState>(
      view.copyWith(loadingMore: true, loadMoreError: false),
    );
    final ApiResult<NotificationPage> result = await ref
        .read(notificationRepositoryProvider)
        .list(tab: tab, page: view.page + 1);
    final AsyncValue<NotificationListState> now = state;
    // 載入期間被 refresh/markRead 換掉（items 參照改變）→ 丟棄本次分頁結果（審查發現的競態）。
    // 但須清掉 loadingMore，否則卡在假 loading、分頁死掉（不變量#1）。
    if (now is! AsyncData<NotificationListState> ||
        !identical(now.value.items, view.items)) {
      if (now is AsyncData<NotificationListState> && now.value.loadingMore) {
        state = AsyncData<NotificationListState>(
          now.value.copyWith(loadingMore: false),
        );
      }
      return;
    }
    // 以 now.value 為基底（items 與 view 相同，但載入期間 socket 可能更新了 unread/hasNew：
    // notice_unread/notification 事件保留 items 參照故通過 guard）→ 保留這些更新，不回吐舊值。
    switch (result) {
      case ApiSuccess<NotificationPage>(:final NotificationPage data):
        state = AsyncData<NotificationListState>(
          now.value.copyWith(
            items: <AppNotification>[...now.value.items, ...data.items],
            page: data.pageNum,
            hasMore: data.hasMore,
            loadingMore: false,
          ),
        );
      case ApiFailure<NotificationPage>():
        // F-15：失敗 → 標記 loadMoreError（尾端顯示重試），不靜默 hasMore=false。
        state = AsyncData<NotificationListState>(
          now.value.copyWith(loadingMore: false, loadMoreError: true),
        );
    }
  }

  /// 全部標為已讀（`notification/read_all`）。成功後**就地**把本分頁所有通知標為已讀、
  /// 未讀數歸零——**不** invalidateSelf（此頁即當前可見清單，重抓會閃 loading 並掉捲動位置，
  /// 違反不變量#1，UX F-08）。回傳 ApiResult 供頁面顯示成功/失敗回饋（不變量#3）。
  Future<ApiResult<void>> markAllRead() async {
    final ApiResult<void> result = await ref
        .read(notificationRepositoryProvider)
        .readAll(tab: tab);
    if (result is ApiSuccess<void>) {
      final AsyncValue<NotificationListState> current = state;
      if (current is AsyncData<NotificationListState>) {
        final NotificationListState view = current.value;
        state = AsyncData<NotificationListState>(
          view.copyWith(
            items: <AppNotification>[
              for (final AppNotification n in view.items)
                n.isRead ? n : n.copyWith(isRead: true),
            ],
            unread: 0,
            // F-06：全部已讀後「有新通知」提示條也應消失（審查發現）。
            hasNew: false,
          ),
        );
      }
      // F-11：樂觀清零全域未讀中心的通知數（socket 稍後推 notice_unread=0 校正）。
      ref.read(unreadCenterProvider.notifier).clearNotice();
    }
    return result;
  }

  /// 單則標為已讀（`notification/read`）。就地把該筆標為已讀、未讀 -1，並樂觀遞減全域
  /// 未讀中心——**不** invalidate 整列（否則閃 loading、掉捲動；不變量#1，F-06 審查發現）。
  /// 背景送出 API；失敗僅回滾未讀中心（列表已讀狀態影響小，維持樂觀）。
  Future<void> markReadLocal(int notifyId) async {
    final AsyncValue<NotificationListState> current = state;
    if (current is! AsyncData<NotificationListState>) {
      return;
    }
    final NotificationListState view = current.value;
    final int idx = view.items.indexWhere(
      (AppNotification n) => n.notifyId == notifyId,
    );
    if (idx < 0 || view.items[idx].isRead) {
      return;
    }
    final List<AppNotification> items = <AppNotification>[...view.items];
    items[idx] = items[idx].copyWith(isRead: true);
    state = AsyncData<NotificationListState>(
      view.copyWith(
        items: items,
        unread: view.unread > 0 ? view.unread - 1 : 0,
      ),
    );
    ref.read(unreadCenterProvider.notifier).decrementNotice(1);

    final ApiResult<void> r = await ref
        .read(notificationRepositoryProvider)
        .read(notifyId);
    if (r is ApiFailure<void>) {
      ref.read(unreadCenterProvider.notifier).incrementNotice(1);
    }
  }
}
