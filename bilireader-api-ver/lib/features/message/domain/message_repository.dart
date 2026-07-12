import '../../../core/network/api_result.dart';
import 'message_entities.dart';

/// 私訊 repository（API.md §8.6 message/* + chat WebSocket，doc 08）。需登入。
///
/// 會話列表為 REST；對話訊息採「REST 歷史 + 本地 owner-scoped drift 快取合併」：
/// [syncHistory] 抓 REST 並 upsert 快取，UI 觀察 [watchConversation]；WS 收訊經
/// [cacheIncoming] upsert，串流即時刷新（§5.5、doc 06）。送訊走 WebSocket（[send]）。
/// send/markRead/block 為狀態變更端點（§7.0），僅使用者操作、不做破壞性自動測試。
abstract interface class MessageRepository {
  /// 會話列表（`message/conversations`）。
  Future<ApiResult<List<Conversation>>> conversations({int page});

  /// 未讀私訊數（`message/unread_count`）。
  Future<ApiResult<int>> unreadCount();

  /// 抓某對話的 REST 歷史並 upsert 到本地快取（不回傳；UI 觀察快取）。
  Future<ApiResult<void>> syncHistory({
    required int ownerUid,
    required int peerId,
    int page,
  });

  /// 觀察某對話的本地快取訊息（即時）。
  Stream<List<ChatMessage>> watchConversation({
    required int ownerUid,
    required int peerId,
  });

  /// 將一則 WS 收到 / 送出回音的訊息寫入本地快取（依 owner 分桶、以 messageId 去重）。
  Future<void> cacheIncoming({
    required int ownerUid,
    required Map<String, dynamic> data,
  });

  /// 送出私訊（WebSocket `chat_message`）。回傳 clientMessageId 供追蹤 ACK。
  String send({
    required int toUserId,
    required String content,
    int? quoteMessageId,
  });

  /// 標記與某人的私訊已讀（`message/read`）。
  Future<ApiResult<void>> markRead(int peerId);

  /// 封鎖對象（`message/block`）。
  Future<ApiResult<void>> block(int peerId);

  /// 確保 chat WebSocket 已連線（進入私訊時呼叫）。
  void connectChat();
}
