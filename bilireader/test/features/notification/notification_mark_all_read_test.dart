import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/network/app_error.dart';
import 'package:bilireader/core/router/auth_controller.dart';
import 'package:bilireader/core/ws/app_web_socket.dart';
import 'package:bilireader/core/ws/ws_providers.dart';
import 'package:bilireader/features/notification/data/notification_providers.dart';
import 'package:bilireader/features/notification/domain/notification_entities.dart';
import 'package:bilireader/features/notification/domain/notification_repository.dart';
import 'package:bilireader/features/notification/presentation/notification_controllers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// 強制登入態，讓 `_requireLogin` 通過，且不觸及 session 儲存。
class _LoggedInAuth extends AuthController {
  @override
  AuthSnapshot build() => const AuthSnapshot(isLoggedIn: true, groupId: 2);
}

class _FakeNotifRepo implements NotificationRepository {
  _FakeNotifRepo(this._page, {this.readAllOk = true});

  final NotificationPage _page;
  final bool readAllOk;

  @override
  Future<ApiResult<NotificationPage>> list({
    required NotificationTab tab,
    int page = 1,
  }) async => ApiSuccess<NotificationPage>(_page);

  @override
  Future<ApiResult<int>> unreadCount({NotificationTab? tab}) async =>
      const ApiSuccess<int>(0);

  @override
  Future<ApiResult<void>> readAll({NotificationTab? tab}) async => readAllOk
      ? const ApiSuccess<void>(null)
      : const ApiFailure<void>(
          AppError(kind: AppErrorKind.network, message: '離線'),
        );

  @override
  Future<ApiResult<void>> read(int notifyId) async =>
      const ApiSuccess<void>(null);
}

AppNotification _n(int id, {bool isRead = false}) => AppNotification(
  notifyId: id,
  kind: NotificationKind.like,
  headline: '通知 $id',
  body: '內容 $id',
  fromUserName: '使用者$id',
  addTime: 1700000000 + id,
  isRead: isRead,
);

/// 不連線的假 socket（token 為 null → connect() 不開任何網路連線）。
AppWebSocket _fakeSocket() =>
    AppWebSocket(url: 'ws://test.invalid', tokenProvider: () => null);

Future<ProviderContainer> _seed(
  NotificationPage page, {
  bool readAllOk = true,
}) async {
  final ProviderContainer container = ProviderContainer(
    overrides: [
      authControllerProvider.overrideWith(_LoggedInAuth.new),
      noticeSocketProvider.overrideWithValue(_fakeSocket()),
      // markAllRead 現會 clearNotice() 觸及 unread_center（讀兩 socket）。
      chatSocketProvider.overrideWithValue(_fakeSocket()),
      notificationRepositoryProvider.overrideWithValue(
        _FakeNotifRepo(page, readAllOk: readAllOk),
      ),
    ],
  );
  addTearDown(container.dispose);
  await container.read(
    notificationListControllerProvider(NotificationTab.interaction).future,
  );
  return container;
}

void main() {
  group('F-08 markAllRead：就地標記已讀，不重抓（不變量#1）', () {
    const NotificationPage page = NotificationPage(
      items: <AppNotification>[],
      pageNum: 1,
      unread: 3,
      hasMore: false,
    );

    test('成功 → 所有項目 isRead=true、unread=0，清單長度/順序保留、狀態不轉 loading', () async {
      final NotificationPage seeded = NotificationPage(
        items: <AppNotification>[_n(1), _n(2, isRead: true), _n(3)],
        pageNum: page.pageNum,
        unread: page.unread,
        hasMore: page.hasMore,
      );
      final ProviderContainer container = await _seed(seeded);
      final provider = notificationListControllerProvider(
        NotificationTab.interaction,
      );

      final ApiResult<void> r = await container
          .read(provider.notifier)
          .markAllRead();
      expect(r, isA<ApiSuccess<void>>());

      // 全程維持 AsyncData（沒有 invalidateSelf → 不會閃 loading）。
      final AsyncValue<NotificationListState> after = container.read(provider);
      expect(after, isA<AsyncData<NotificationListState>>());
      final NotificationListState s = after.requireValue;
      expect(s.items.map((AppNotification n) => n.notifyId), <int>[1, 2, 3]);
      expect(s.items.every((AppNotification n) => n.isRead), isTrue);
      expect(s.unread, 0);
    });

    test('失敗 → 不改動狀態（仍有未讀）', () async {
      final NotificationPage seeded = NotificationPage(
        items: <AppNotification>[_n(1)],
        pageNum: page.pageNum,
        unread: page.unread,
        hasMore: page.hasMore,
      );
      final ProviderContainer container = await _seed(seeded, readAllOk: false);
      final provider = notificationListControllerProvider(
        NotificationTab.interaction,
      );

      final ApiResult<void> r = await container
          .read(provider.notifier)
          .markAllRead();
      expect(r, isA<ApiFailure<void>>());
      final NotificationListState s = container.read(provider).requireValue;
      expect(s.items.single.isRead, isFalse);
      expect(s.unread, 3);
    });
  });
}
