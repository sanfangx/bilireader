import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_result.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/router/auth_controller.dart';
import '../../../core/ws/ws_providers.dart';
import '../../reader/reading_progress_providers.dart'
    show currentOwnerUidProvider;
import '../data/message_providers.dart';
import '../domain/message_entities.dart';
import 'unread_center.dart';

part 'message_controllers.g.dart';

/// 私訊需登入（doc 09 §7 loginRequiredPages 含 messages）；未登入短路（§6.3）。
void _requireLogin(Ref ref) {
  if (!ref.watch(authControllerProvider).isLoggedIn) {
    throw ErrorMapper.fromBusinessCode(code: ApiConstants.codeTokenInvalid);
  }
}

/// 目前登入者 uid（isMine 判斷 + owner-scoped 快取 key）。
@riverpod
Future<int> currentUid(Ref ref) async {
  _requireLogin(ref);
  final int? uid = await ref.watch(currentOwnerUidProvider.future);
  if (uid == null) {
    throw ErrorMapper.fromBusinessCode(code: ApiConstants.codeTokenInvalid);
  }
  return uid;
}

/// 私訊會話列表（`message/conversations`）。
@riverpod
Future<List<Conversation>> conversations(Ref ref) async {
  _requireLogin(ref);
  return (await ref.watch(messageRepositoryProvider).conversations())
      .dataOrThrow();
}

/// 某對話的訊息串流（觀察 owner-scoped 本地快取，即時）。
///
/// build 時：連 chat WebSocket、抓 REST 歷史 upsert 快取、標記已讀、監聽 WS 收訊
/// 寫入快取；最後 yield 快取串流。WS 收到本對話新訊即時反映（doc 08、§5.5）。
@riverpod
Stream<List<ChatMessage>> chatMessages(Ref ref, int peerId) async* {
  _requireLogin(ref);
  final int uid = await ref.watch(currentUidProvider.future);
  final repo = ref.read(messageRepositoryProvider);

  repo.connectChat();
  final StreamSubscription<void> sub = ref
      .watch(chatSocketProvider)
      .events
      .listen((event) {
        if (event.type == 'chat_message' || event.type == 'chat_ack') {
          unawaited(repo.cacheIncoming(ownerUid: uid, data: event.data));
        }
      });
  bool disposed = false;
  ref.onDispose(() {
    disposed = true;
    sub.cancel();
  });

  // REST 歷史 → 快取（不阻塞串流；失敗不致命，仍顯示既有快取）。
  await repo.syncHistory(ownerUid: uid, peerId: peerId);

  // F-11：進對話即「樂觀」把該會話未讀從全域未讀中心遞減（章評模式：先本地套用，
  // socket 稍後以權威值校正）；未讀數取自已載會話列表，標記失敗則回滾。
  int peerUnread = 0;
  final List<Conversation>? convos = ref.read(conversationsProvider).value;
  if (convos != null) {
    for (final Conversation c in convos) {
      if (c.peerId == peerId) {
        peerUnread = c.unreadCount;
        break;
      }
    }
  }
  if (peerUnread > 0) {
    ref.read(unreadCenterProvider.notifier).decrementChat(peerUnread);
  }

  // F-03：標記已讀成功後同步會話列表未讀數（§6.2）；不阻塞訊息串流。
  // 已離開對話（provider 已 dispose）則不 invalidate，避免對失效 ref 操作。
  unawaited(
    repo.markRead(peerId).then((ApiResult<void> r) {
      if (disposed) {
        return;
      }
      if (r is ApiSuccess<void>) {
        ref.invalidate(conversationsProvider);
      } else if (peerUnread > 0) {
        // F-11 回滾：標記失敗 → 把樂觀遞減的未讀補回。
        ref.read(unreadCenterProvider.notifier).incrementChat(peerUnread);
      }
    }),
  );

  yield* repo.watchConversation(ownerUid: uid, peerId: peerId);
}

/// 私訊互動（送訊）。§7.0：狀態變更端點，僅使用者操作、不做破壞性自動測試。
@riverpod
class MessageActions extends _$MessageActions {
  @override
  void build() {}

  /// 送出訊息（WebSocket）。回傳 clientMessageId。
  String send({
    required int toUserId,
    required String content,
    int? quoteMessageId,
  }) => ref
      .read(messageRepositoryProvider)
      .send(
        toUserId: toUserId,
        content: content,
        quoteMessageId: quoteMessageId,
      );

  Future<ApiResult<void>> markRead(int peerId) =>
      ref.read(messageRepositoryProvider).markRead(peerId);
}
