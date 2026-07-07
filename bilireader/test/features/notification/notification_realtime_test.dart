import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/router/auth_controller.dart';
import 'package:bilireader/core/ws/ws_providers.dart';
import 'package:bilireader/features/message/presentation/unread_center.dart';
import 'package:bilireader/features/notification/data/notification_providers.dart';
import 'package:bilireader/features/notification/domain/notification_entities.dart';
import 'package:bilireader/features/notification/domain/notification_repository.dart';
import 'package:bilireader/features/notification/presentation/notification_controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_socket.dart';

class _LoggedInAuth extends AuthController {
  @override
  AuthSnapshot build() => const AuthSnapshot(isLoggedIn: true, groupId: 2);
}

class _FakeNotifRepo implements NotificationRepository {
  _FakeNotifRepo(this._page);
  final NotificationPage _page;

  @override
  Future<ApiResult<NotificationPage>> list({
    required NotificationTab tab,
    int page = 1,
  }) async => ApiSuccess<NotificationPage>(_page);

  @override
  Future<ApiResult<int>> unreadCount({NotificationTab? tab}) async =>
      const ApiSuccess<int>(0);

  @override
  Future<ApiResult<void>> readAll({NotificationTab? tab}) async =>
      const ApiSuccess<void>(null);

  @override
  Future<ApiResult<void>> read(int notifyId) async =>
      const ApiSuccess<void>(null);
}

AppNotification _n(int id) => AppNotification(
  notifyId: id,
  kind: NotificationKind.like,
  headline: '通知 $id',
);

Future<void> _tick() => Future<void>.delayed(Duration.zero);

void main() {
  const NotificationPage seeded = NotificationPage(
    items: <AppNotification>[],
    pageNum: 1,
    unread: 2,
    hasMore: false,
  );

  Future<ProviderContainer> boot(FakeAppWebSocket notice) async {
    final NotificationPage page = NotificationPage(
      items: <AppNotification>[_n(1), _n(2)],
      pageNum: seeded.pageNum,
      unread: seeded.unread,
      hasMore: seeded.hasMore,
    );
    final ProviderContainer container = ProviderContainer(
      overrides: [
        authControllerProvider.overrideWith(_LoggedInAuth.new),
        noticeSocketProvider.overrideWithValue(notice),
        // markAllRead/markReadLocal 會觸及 unread_center（讀兩 socket）。
        chatSocketProvider.overrideWithValue(FakeAppWebSocket()),
        notificationRepositoryProvider.overrideWithValue(_FakeNotifRepo(page)),
      ],
    );
    addTearDown(container.dispose);
    // 讓 unread_center 存活（供 markReadLocal/markAllRead 的樂觀遞減斷言）。
    final ProviderSubscription<UnreadState> uc = container.listen(
      unreadCenterProvider,
      (_, _) {},
    );
    addTearDown(uc.close);
    // 保持 provider 存活（autoDispose；否則無訂閱者時 socket 監聽會被取消）。
    final ProviderSubscription<AsyncValue<NotificationListState>> sub =
        container.listen(
          notificationListControllerProvider(NotificationTab.interaction),
          (_, _) {},
        );
    addTearDown(sub.close);
    await container.read(
      notificationListControllerProvider(NotificationTab.interaction).future,
    );
    return container;
  }

  test('F-06：socket "notification" → hasNew=true，列表不重抓、不掉項', () async {
    final FakeAppWebSocket notice = FakeAppWebSocket();
    final ProviderContainer container = await boot(notice);
    final provider = notificationListControllerProvider(
      NotificationTab.interaction,
    );

    expect(container.read(provider).requireValue.hasNew, isFalse);

    notice.emit('notification', data: <String, dynamic>{'notifyid': 99});
    await _tick();

    final AsyncValue<NotificationListState> after = container.read(provider);
    // 仍是 AsyncData（沒有 invalidateSelf → 不閃 loading）。
    expect(after, isA<AsyncData<NotificationListState>>());
    expect(after.requireValue.hasNew, isTrue);
    // 列表不動（未整列重抓）。
    expect(after.requireValue.items.length, 2);
    expect(
      after.requireValue.items.map((AppNotification n) => n.notifyId),
      <int>[1, 2],
    );
  });

  test('F-06：socket "notice_unread" → 就地更新未讀數，不動列表/不設 hasNew', () async {
    final FakeAppWebSocket notice = FakeAppWebSocket();
    final ProviderContainer container = await boot(notice);
    final provider = notificationListControllerProvider(
      NotificationTab.interaction,
    );

    notice.emit('notice_unread', data: <String, dynamic>{'unread': 9});
    await _tick();

    final NotificationListState s = container.read(provider).requireValue;
    expect(s.unread, 9);
    expect(s.hasNew, isFalse);
    expect(s.items.length, 2);
  });

  test('F-06：全部已讀 → hasNew 重置 + 未讀中心通知清零（審查修正）', () async {
    final FakeAppWebSocket notice = FakeAppWebSocket();
    final ProviderContainer container = await boot(notice);
    final provider = notificationListControllerProvider(
      NotificationTab.interaction,
    );
    // 先讓未讀中心有 notice 未讀 + 頁面有 hasNew。
    notice.emit('notice_unread', data: <String, dynamic>{'unread': 2});
    notice.emit('notification', data: <String, dynamic>{'notifyid': 7});
    await _tick();
    expect(container.read(provider).requireValue.hasNew, isTrue);
    expect(container.read(unreadCenterProvider).notice, 2);

    await container.read(provider.notifier).markAllRead();

    final NotificationListState s = container.read(provider).requireValue;
    expect(s.hasNew, isFalse); // 提示條消失
    expect(s.unread, 0);
    expect(s.items.every((AppNotification n) => n.isRead), isTrue);
    expect(container.read(unreadCenterProvider).notice, 0); // 樂觀清零
  });

  test('F-06：單則已讀就地更新（不重抓）+ 未讀中心 -1', () async {
    final FakeAppWebSocket notice = FakeAppWebSocket();
    final ProviderContainer container = await boot(notice);
    final provider = notificationListControllerProvider(
      NotificationTab.interaction,
    );
    notice.emit('notice_unread', data: <String, dynamic>{'unread': 2});
    await _tick();

    await container.read(provider.notifier).markReadLocal(1);

    final NotificationListState s = container.read(provider).requireValue;
    // 仍是 AsyncData（未 invalidate → 不閃 loading）、列表長度不變。
    expect(container.read(provider), isA<AsyncData<NotificationListState>>());
    expect(s.items.length, 2);
    expect(s.items[0].isRead, isTrue);
    expect(s.items[1].isRead, isFalse);
    expect(s.unread, 1);
    expect(container.read(unreadCenterProvider).notice, 1); // 樂觀 -1
  });
}
