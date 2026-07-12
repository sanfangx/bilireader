import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:uuid/uuid.dart';

import '../../../core/network/api_result.dart';
import '../../../core/network/app_error.dart';
import '../../../core/network/error_mapper.dart';
import '../../../core/storage/database/app_database.dart';
import '../../../core/text/chinese_converter.dart';
import '../../../core/ws/app_web_socket.dart';
import '../domain/message_entities.dart';
import '../domain/message_repository.dart';
import 'dto/message_dtos.dart';
import 'message_remote_data_source.dart';

/// [MessageRepository] 實作。會話 REST；對話訊息 REST→owner-scoped drift 快取（寫入時
/// 轉繁，§5.0），UI 觀察快取串流；WS 收訊 upsert（以 messageId 去重）；送訊走 chatSocket。
class MessageRepositoryImpl implements MessageRepository {
  MessageRepositoryImpl({
    required MessageRemoteDataSource remote,
    required PrivateMessageDao dao,
    required AppWebSocket chatSocket,
    required ChineseConverter converter,
    Uuid? uuid,
  }) : _remote = remote,
       _dao = dao,
       _chat = chatSocket,
       _converter = converter,
       _uuid = uuid ?? const Uuid();

  final MessageRemoteDataSource _remote;
  final PrivateMessageDao _dao;
  final AppWebSocket _chat;
  final ChineseConverter _converter;
  final Uuid _uuid;

  @override
  void connectChat() => _chat.connect();

  @override
  Future<ApiResult<List<Conversation>>> conversations({int page = 1}) =>
      _guard(() async {
        final PrivateConversationListDataDto d = await _remote.conversations(
          page: page,
        );
        return d.list
            .map(
              (PrivateConversationDto c) => Conversation(
                peerId: c.peerId,
                peerName: _tw(c.peerName),
                avatarUrl: c.peerAvatarUrl,
                lastContent: _tw(c.lastContent),
                lastPostdate: c.lastPostdate,
                unreadCount: c.unreadCount,
              ),
            )
            .toList();
      });

  @override
  Future<ApiResult<int>> unreadCount() => _guard(_remote.unreadCount);

  @override
  Future<ApiResult<void>> syncHistory({
    required int ownerUid,
    required int peerId,
    int page = 1,
  }) => _guard(() async {
    final PrivateMessageHistoryDataDto d = await _remote.history(
      peerId: peerId,
      page: page,
    );
    await _converter.ensureLoaded();
    await _dao.upsertMessages(
      d.list
          .map(
            (PrivateMessageDto m) =>
                _companion(m, ownerUid: ownerUid, peerId: peerId),
          )
          .toList(),
    );
  });

  @override
  Stream<List<ChatMessage>> watchConversation({
    required int ownerUid,
    required int peerId,
  }) {
    return _dao
        .watchMessages(ownerUid, peerId)
        .map((List<PrivateMessageRow> rows) => rows.map(_toMessage).toList());
  }

  @override
  Future<void> cacheIncoming({
    required int ownerUid,
    required Map<String, dynamic> data,
  }) async {
    // 盡力而為的快取寫入：解析 / DB 失敗不得外拋（呼叫端為 fire-and-forget 的 WS
    // 監聽），否則會變成未處理的非同步例外（審查發現）。
    try {
      final PrivateMessageDto dto = PrivateMessageDto.fromJson(data);
      if (dto.messageid == 0) {
        return; // 尚無伺服器 messageId（本地暫存），略過
      }
      final int peerId = dto.fromid == ownerUid ? dto.toid : dto.fromid;
      // peerId 無效或指向自己（畸形訊息）→ 不建立自我會話。
      if (peerId == 0 || peerId == ownerUid) {
        return;
      }
      await _converter.ensureLoaded();
      await _dao.upsertMessages(<PrivateMessagesCompanion>[
        _companion(dto, ownerUid: ownerUid, peerId: peerId),
      ]);
    } on Object {
      // 忽略單則快取失敗；不影響串流與其他訊息。
    }
  }

  @override
  String send({
    required int toUserId,
    required String content,
    int? quoteMessageId,
  }) {
    final String clientMessageId = _uuid.v4();
    _chat.send(<String, dynamic>{
      'type': 'chat_message',
      'toUserId': toUserId,
      'content': content,
      'clientMessageId': clientMessageId,
      if (quoteMessageId != null && quoteMessageId > 0)
        'quoteMessageId': quoteMessageId,
    });
    return clientMessageId;
  }

  @override
  Future<ApiResult<void>> markRead(int peerId) =>
      _guard(() => _remote.markRead(peerId));

  @override
  Future<ApiResult<void>> block(int peerId) =>
      _guard(() => _remote.block(peerId));

  // ---- mapping ----

  PrivateMessagesCompanion _companion(
    PrivateMessageDto m, {
    required int ownerUid,
    required int peerId,
  }) => PrivateMessagesCompanion.insert(
    ownerUid: ownerUid,
    messageId: m.messageid,
    peerId: peerId,
    fromId: Value<int?>(m.fromid),
    toId: Value<int?>(m.toid),
    fromName: Value<String?>(_twNullable(m.fromname)),
    toName: Value<String?>(_twNullable(m.toname)),
    content: Value<String?>(_twNullable(m.content)),
    quoteMessageId: Value<int>(m.quoteMessageId),
    quoteFromId: Value<int>(m.quoteFromid),
    quoteFromName: Value<String>(_tw(m.quoteFromname)),
    quoteContent: Value<String>(_tw(m.quoteContent)),
    postDate: Value<int>(m.postdate),
    title: Value<String?>(m.title),
    isRead: Value<bool>(m.isread == 1),
  );

  ChatMessage _toMessage(PrivateMessageRow r) => ChatMessage(
    messageId: r.messageId,
    fromId: r.fromId ?? 0,
    content: r.content ?? '',
    fromName: r.fromName,
    postDate: r.postDate,
    isRead: r.isRead,
    quoteContent: r.quoteContent.isEmpty ? null : r.quoteContent,
    quoteFromName: r.quoteFromName.isEmpty ? null : r.quoteFromName,
  );

  String _tw(String? text) =>
      (text == null || text.isEmpty) ? '' : _converter.toTraditionalTw(text);

  String? _twNullable(String? text) =>
      (text == null || text.isEmpty) ? text : _converter.toTraditionalTw(text);

  Future<ApiResult<T>> _guard<T>(Future<T> Function() body) async {
    try {
      await _converter.ensureLoaded();
      return ApiSuccess<T>(await body());
    } on DioException catch (e) {
      return ApiFailure<T>(ErrorMapper.fromDio(e));
    } on AppError catch (e) {
      return ApiFailure<T>(e);
    } on Object catch (e) {
      return ApiFailure<T>(ErrorMapper.parse(e));
    }
  }
}
