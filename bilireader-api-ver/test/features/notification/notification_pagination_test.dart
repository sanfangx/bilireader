import 'dart:async';

import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/network/app_error.dart';
import 'package:bilireader/core/router/auth_controller.dart';
import 'package:bilireader/core/ws/ws_providers.dart';
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

/// 依 page 回傳預設結果的通知 repo（驗 F-14/F-15 分頁四態）。
class _PagedNotifRepo implements NotificationRepository {
  _PagedNotifRepo(this.byPage);
  final Map<int, ApiResult<NotificationPage>> byPage;

  @override
  Future<ApiResult<NotificationPage>> list({
    required NotificationTab tab,
    int page = 1,
  }) async =>
      byPage[page] ??
      const ApiFailure<NotificationPage>(
        AppError(kind: AppErrorKind.network, message: '離線'),
      );

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

/// page 1 立即回、page 2 由 [gate] 控制 —— 重現「載入更多進行中被 markReadLocal
/// 改寫 items 參照」的競態（HIGH：守門早退須清 loadingMore）。
class _GatedNotifRepo implements NotificationRepository {
  _GatedNotifRepo(this.page1, this.page2);
  final NotificationPage page1;
  final NotificationPage page2;
  final Completer<void> gate = Completer<void>();

  @override
  Future<ApiResult<NotificationPage>> list({
    required NotificationTab tab,
    int page = 1,
  }) async {
    if (page == 1) {
      return ApiSuccess<NotificationPage>(page1);
    }
    if (!gate.isCompleted) {
      await gate.future;
    }
    return ApiSuccess<NotificationPage>(page2);
  }

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

NotificationPage _pg(int page, int count, {required bool hasMore}) =>
    NotificationPage(
      items: List<AppNotification>.generate(
        count,
        (int i) => AppNotification(
          notifyId: page * 100 + i,
          kind: NotificationKind.like,
          headline: '通知 $page-$i',
        ),
      ),
      pageNum: page,
      unread: 0,
      hasMore: hasMore,
    );

void main() {
  final provider = notificationListControllerProvider(
    NotificationTab.interaction,
  );

  Future<ProviderContainer> boot(
    Map<int, ApiResult<NotificationPage>> byPage,
  ) async {
    final ProviderContainer c = ProviderContainer(
      overrides: [
        authControllerProvider.overrideWith(_LoggedInAuth.new),
        noticeSocketProvider.overrideWithValue(FakeAppWebSocket()),
        chatSocketProvider.overrideWithValue(FakeAppWebSocket()),
        notificationRepositoryProvider.overrideWithValue(
          _PagedNotifRepo(byPage),
        ),
      ],
    );
    addTearDown(c.dispose);
    c.listen(provider, (_, _) {});
    await c.read(provider.future);
    return c;
  }

  test(
    'F-15：loadMore 失敗 → loadMoreError（非 hasMore=false）；retry 成功清旗標',
    () async {
      final ProviderContainer c = await boot(<int, ApiResult<NotificationPage>>{
        1: ApiSuccess<NotificationPage>(_pg(1, 20, hasMore: true)),
        2: const ApiFailure<NotificationPage>(
          AppError(kind: AppErrorKind.network, message: '離線'),
        ),
      });
      await c.read(provider.notifier).loadMore();
      NotificationListState s = c.read(provider).requireValue;
      expect(s.loadMoreError, isTrue);
      expect(s.hasMore, isTrue);
      expect(s.items.length, 20);

      // retry：讓 page 2 這次成功。
      final _PagedNotifRepo repo =
          c.read(notificationRepositoryProvider) as _PagedNotifRepo;
      repo.byPage[2] = ApiSuccess<NotificationPage>(_pg(2, 10, hasMore: false));
      await c.read(provider.notifier).retryLoadMore();
      s = c.read(provider).requireValue;
      expect(s.loadMoreError, isFalse);
      expect(s.items.length, 30);
      expect(s.hasMore, isFalse);
    },
  );

  test('F-14：refresh 保留列表、不進 AsyncLoading', () async {
    final ProviderContainer c = await boot(<int, ApiResult<NotificationPage>>{
      1: ApiSuccess<NotificationPage>(_pg(1, 5, hasMore: true)),
    });
    expect(c.read(provider).requireValue.items.length, 5);

    // 讓刷新回傳新的一頁。
    final _PagedNotifRepo repo =
        c.read(notificationRepositoryProvider) as _PagedNotifRepo;
    repo.byPage[1] = ApiSuccess<NotificationPage>(_pg(1, 8, hasMore: false));
    final Future<void> r = c.read(provider.notifier).refresh();
    // 刷新期間維持 AsyncData（列表不消失）。
    expect(c.read(provider), isA<AsyncData<NotificationListState>>());
    await r;
    expect(c.read(provider).requireValue.items.length, 8);
  });

  test('HIGH：markReadLocal 於 loadMore 進行中不得卡死分頁（守門早退清 loadingMore）', () async {
    final _GatedNotifRepo repo = _GatedNotifRepo(
      _pg(1, 20, hasMore: true),
      _pg(2, 10, hasMore: false),
    );
    final ProviderContainer c = ProviderContainer(
      overrides: [
        authControllerProvider.overrideWith(_LoggedInAuth.new),
        noticeSocketProvider.overrideWithValue(FakeAppWebSocket()),
        chatSocketProvider.overrideWithValue(FakeAppWebSocket()),
        notificationRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(c.dispose);
    c.listen(provider, (_, _) {});
    await c.read(provider.future);

    // 觸發 loadMore（不 await）→ 進到 await gate、loadingMore=true。
    final Future<void> f = c.read(provider.notifier).loadMore();
    await Future<void>.delayed(Duration.zero);
    expect(c.read(provider).requireValue.loadingMore, isTrue);

    // 載入中標記某則已讀 → 改變 items 參照（樂觀同步）。
    final int id = c.read(provider).requireValue.items.first.notifyId;
    await c.read(provider.notifier).markReadLocal(id);

    // 釋放 gate → page2 落地，但守門偵測 items 參照已變 → 丟棄該頁。
    repo.gate.complete();
    await f;

    final NotificationListState s = c.read(provider).requireValue;
    // 關鍵：loadingMore 必須被清（否則分頁永久卡假 loading）。
    expect(
      s.loadingMore,
      isFalse,
      reason: '守門早退未清 loadingMore → 分頁死掉（此測試守護 HIGH 修正）',
    );
    expect(s.items.length, 20, reason: 'items 參照已被 markReadLocal 換掉 → 丟棄本次分頁');
    expect(s.items.first.isRead, isTrue, reason: '樂觀已讀保留');

    // 證明分頁未死：再次 loadMore 應成功累積到 30。
    await c.read(provider.notifier).loadMore();
    expect(c.read(provider).requireValue.items.length, 30);
  });
}
