import 'dart:io';

import 'package:bilireader/core/network/api_result.dart';
import 'package:bilireader/core/storage/database/app_database.dart';
import 'package:bilireader/core/text/chinese_converter.dart';
import 'package:bilireader/core/ws/app_web_socket.dart';
import 'package:bilireader/features/message/data/dto/message_dtos.dart';
import 'package:bilireader/features/message/data/message_remote_data_source.dart';
import 'package:bilireader/features/message/data/message_repository_impl.dart';
import 'package:bilireader/features/message/domain/message_entities.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeMessageRemote implements MessageRemoteDataSource {
  PrivateConversationListDataDto convos =
      const PrivateConversationListDataDto();
  PrivateMessageHistoryDataDto hist = const PrivateMessageHistoryDataDto();

  @override
  Future<PrivateConversationListDataDto> conversations({
    required int page,
    int pageSize = 20,
  }) async => convos;

  @override
  Future<PrivateMessageHistoryDataDto> history({
    required int peerId,
    required int page,
    int pageSize = 30,
  }) async => hist;

  @override
  Future<int> unreadCount() async => 0;

  @override
  Future<void> markRead(int peerId) async {}

  @override
  Future<void> block(int peerId) async {}
}

void main() {
  late ChineseConverter converter;
  late AppDatabase db;
  late _FakeMessageRemote remote;
  late MessageRepositoryImpl repo;

  const int owner = 100;
  const int peer = 200;

  setUpAll(() async {
    converter = ChineseConverter(loader: (String k) => File(k).readAsString());
    await converter.ensureLoaded();
  });

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    remote = _FakeMessageRemote();
    repo = MessageRepositoryImpl(
      remote: remote,
      dao: db.privateMessageDao,
      chatSocket: AppWebSocket(url: 'ws://x', tokenProvider: () => null),
      converter: converter,
    );
  });

  tearDown(() async => db.close());

  test('conversations：DTO → Conversation，文字轉繁', () async {
    remote.convos = const PrivateConversationListDataDto(
      list: <PrivateConversationDto>[
        PrivateConversationDto(
          peerId: peer,
          peerName: '星海拾贝',
          lastContent: '那本我也在追',
          unreadCount: 3,
        ),
      ],
    );
    final List<Conversation> list =
        ((await repo.conversations()) as ApiSuccess<List<Conversation>>).data;
    expect(list.single.peerName, '星海拾貝');
    expect(list.single.lastContent, '那本我也在追');
    expect(list.single.unreadCount, 3);
  });

  test('syncHistory → owner-scoped 快取，watchConversation 反映（轉繁）', () async {
    remote.hist = const PrivateMessageHistoryDataDto(
      list: <PrivateMessageDto>[
        PrivateMessageDto(
          messageid: 1,
          fromid: peer,
          toid: owner,
          content: '这段真好',
          postdate: 10,
        ),
        PrivateMessageDto(
          messageid: 2,
          fromid: owner,
          toid: peer,
          content: '谢谢',
          postdate: 20,
        ),
      ],
    );
    await repo.syncHistory(ownerUid: owner, peerId: peer);
    final List<ChatMessage> msgs = await repo
        .watchConversation(ownerUid: owner, peerId: peer)
        .first;
    expect(msgs.length, 2);
    expect(msgs.first.content, '這段真好'); // asc by postDate + 轉繁
    expect(msgs.last.fromId, owner);
  });

  test('cacheIncoming：peerId 由方向推得 + messageId 去重', () async {
    // 對方傳來（fromid=peer, toid=owner）→ peer=peer。
    await repo.cacheIncoming(
      ownerUid: owner,
      data: const <String, dynamic>{
        'messageid': 5,
        'fromid': peer,
        'toid': owner,
        'content': '在吗',
      },
    );
    // 同 messageId 再收一次（WS 重播）→ 去重，仍 1 筆。
    await repo.cacheIncoming(
      ownerUid: owner,
      data: const <String, dynamic>{
        'messageid': 5,
        'fromid': peer,
        'toid': owner,
        'content': '在吗',
      },
    );
    final List<ChatMessage> msgs = await repo
        .watchConversation(ownerUid: owner, peerId: peer)
        .first;
    expect(msgs.length, 1);
    expect(msgs.single.content, '在嗎');
    expect(msgs.single.fromId, peer);
  });

  test('cacheIncoming：自我訊息（from==to==owner）不建立會話', () async {
    await repo.cacheIncoming(
      ownerUid: owner,
      data: const <String, dynamic>{
        'messageid': 7,
        'fromid': owner,
        'toid': owner,
        'content': 'self',
      },
    );
    expect(await db.privateMessageDao.getMessages(owner, owner), isEmpty);
  });

  test('cacheIncoming：畸形資料不外拋（best-effort）', () async {
    // content 型別錯誤等畸形資料不應讓 fire-and-forget 的 WS 監聽炸掉。
    await expectLater(
      repo.cacheIncoming(
        ownerUid: owner,
        data: const <String, dynamic>{'messageid': 'not-an-int'},
      ),
      completes,
    );
  });
}
