import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/router/auth_controller.dart';
import 'package:bilireader/core/ws/ws_providers.dart';
import 'package:bilireader/features/message/data/message_providers.dart';
import 'package:bilireader/features/message/domain/message_entities.dart';
import 'package:bilireader/features/message/domain/message_repository.dart';
import 'package:bilireader/features/message/presentation/message_controllers.dart';
import 'package:bilireader/features/message/presentation/unread_center.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/fake_socket.dart';

class _LoggedInAuth extends AuthController {
  @override
  AuthSnapshot build() => const AuthSnapshot(isLoggedIn: true, groupId: 2);
}

class _LoggedOutAuth extends AuthController {
  @override
  AuthSnapshot build() => const AuthSnapshot(isLoggedIn: false);
}

/// 只實作 conversations（記次數），其餘丟 UnimplementedError（本測試不呼叫）。
class _CountingMsgRepo implements MessageRepository {
  int conversationsCalls = 0;

  @override
  Future<ApiResult<List<Conversation>>> conversations({int page = 1}) async {
    conversationsCalls++;
    return const ApiSuccess<List<Conversation>>(<Conversation>[]);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError(invocation.memberName.toString());
}

Future<void> _tick() => Future<void>.delayed(Duration.zero);

void main() {
  group('F-02/F-11 UnreadCenter：socket → 合併未讀 + 樂觀增減', () {
    test('未登入 → total 0，socket 不連', () {
      final FakeAppWebSocket notice = FakeAppWebSocket();
      final FakeAppWebSocket chat = FakeAppWebSocket();
      final ProviderContainer container = ProviderContainer(
        overrides: [
          authControllerProvider.overrideWith(_LoggedOutAuth.new),
          noticeSocketProvider.overrideWithValue(notice),
          chatSocketProvider.overrideWithValue(chat),
        ],
      );
      addTearDown(container.dispose);
      final ProviderSubscription<UnreadState> sub = container.listen(
        unreadCenterProvider,
        (_, _) {},
      );
      addTearDown(sub.close);

      expect(container.read(unreadCenterProvider).total, 0);
      expect(notice.connectCount, 0);
      expect(chat.connectCount, 0);
    });

    test('notice_unread / chat_unread → 分別更新，total = 合併', () async {
      final FakeAppWebSocket notice = FakeAppWebSocket();
      final FakeAppWebSocket chat = FakeAppWebSocket();
      final ProviderContainer container = ProviderContainer(
        overrides: [
          authControllerProvider.overrideWith(_LoggedInAuth.new),
          noticeSocketProvider.overrideWithValue(notice),
          chatSocketProvider.overrideWithValue(chat),
        ],
      );
      addTearDown(container.dispose);
      final ProviderSubscription<UnreadState> sub = container.listen(
        unreadCenterProvider,
        (_, _) {},
      );
      addTearDown(sub.close);

      // 登入 → 兩 socket 皆連線。
      expect(container.read(unreadCenterProvider).total, 0);
      expect(notice.connectCount, 1);
      expect(chat.connectCount, 1);

      notice.emit('notice_unread', data: <String, dynamic>{'unread': 5});
      await _tick();
      expect(container.read(unreadCenterProvider).notice, 5);
      expect(container.read(unreadCenterProvider).total, 5);

      chat.emit('chat_unread', data: <String, dynamic>{'unread': 3});
      await _tick();
      expect(container.read(unreadCenterProvider).chat, 3);
      expect(container.read(unreadCenterProvider).total, 8);

      // chat_connected 亦帶 unread（doc 08 §3.1）。
      chat.emit('chat_connected', data: <String, dynamic>{'unread': 1});
      await _tick();
      expect(container.read(unreadCenterProvider).chat, 1);
      expect(container.read(unreadCenterProvider).total, 6);
    });

    test('data.unread 缺值/非數字 → 不動狀態（Never-Guess 防禦）', () async {
      final FakeAppWebSocket notice = FakeAppWebSocket();
      final FakeAppWebSocket chat = FakeAppWebSocket();
      final ProviderContainer container = ProviderContainer(
        overrides: [
          authControllerProvider.overrideWith(_LoggedInAuth.new),
          noticeSocketProvider.overrideWithValue(notice),
          chatSocketProvider.overrideWithValue(chat),
        ],
      );
      addTearDown(container.dispose);
      final ProviderSubscription<UnreadState> sub = container.listen(
        unreadCenterProvider,
        (_, _) {},
      );
      addTearDown(sub.close);

      notice.emit('notice_unread', data: <String, dynamic>{'unread': 4});
      await _tick();
      notice.emit('notice_unread'); // 無 data.unread
      await _tick();
      expect(container.read(unreadCenterProvider).notice, 4); // 維持
    });

    test(
      'F-11：decrementChat / incrementChat / clearNotice 樂觀增減（下限 0）',
      () async {
        final FakeAppWebSocket notice = FakeAppWebSocket();
        final FakeAppWebSocket chat = FakeAppWebSocket();
        final ProviderContainer container = ProviderContainer(
          overrides: [
            authControllerProvider.overrideWith(_LoggedInAuth.new),
            noticeSocketProvider.overrideWithValue(notice),
            chatSocketProvider.overrideWithValue(chat),
          ],
        );
        addTearDown(container.dispose);
        final ProviderSubscription<UnreadState> sub = container.listen(
          unreadCenterProvider,
          (_, _) {},
        );
        addTearDown(sub.close);

        chat.emit('chat_unread', data: <String, dynamic>{'unread': 3});
        notice.emit('notice_unread', data: <String, dynamic>{'unread': 2});
        await _tick();

        final UnreadCenter center = container.read(
          unreadCenterProvider.notifier,
        );
        center.decrementChat(2);
        expect(container.read(unreadCenterProvider).chat, 1);
        center.decrementChat(5); // 不會低於 0
        expect(container.read(unreadCenterProvider).chat, 0);
        center.incrementChat(4); // 回滾補回
        expect(container.read(unreadCenterProvider).chat, 4);

        center.decrementNotice(1);
        expect(container.read(unreadCenterProvider).notice, 1);
        center.incrementNotice(1); // 回滾
        expect(container.read(unreadCenterProvider).notice, 2);

        center.clearNotice();
        expect(container.read(unreadCenterProvider).notice, 0);
      },
    );
  });

  group('F-04 UnreadCenter：chat_message → invalidate 會話列表', () {
    test('收到 chat_message → conversationsProvider 重抓（refetch）', () async {
      final FakeAppWebSocket notice = FakeAppWebSocket();
      final FakeAppWebSocket chat = FakeAppWebSocket();
      final _CountingMsgRepo repo = _CountingMsgRepo();
      final ProviderContainer container = ProviderContainer(
        overrides: [
          authControllerProvider.overrideWith(_LoggedInAuth.new),
          noticeSocketProvider.overrideWithValue(notice),
          chatSocketProvider.overrideWithValue(chat),
          messageRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);
      // 讓未讀中心與會話列表都活著（有訂閱者）。
      final ProviderSubscription<UnreadState> s1 = container.listen(
        unreadCenterProvider,
        (_, _) {},
      );
      addTearDown(s1.close);
      final ProviderSubscription<AsyncValue<List<Conversation>>> s2 = container
          .listen(conversationsProvider, (_, _) {});
      addTearDown(s2.close);

      await container.read(conversationsProvider.future);
      expect(repo.conversationsCalls, 1);

      chat.emit('chat_message', data: <String, dynamic>{'messageid': 1});
      await _tick();
      // invalidate 後，被訂閱的 provider 會重抓。
      await container.read(conversationsProvider.future);
      expect(repo.conversationsCalls, 2);
    });
  });
}
