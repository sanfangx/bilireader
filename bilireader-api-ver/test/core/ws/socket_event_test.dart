import 'package:bilireader/core/ws/socket_event.dart';
import 'package:flutter_test/flutter_test.dart';

/// WS frame 解析（doc 08 §3）：合法 JSON 物件 → SocketEvent；其餘 → null（忽略）。
void main() {
  test('解析 chat_message frame（type + data + clientMessageId + replay）', () {
    final SocketEvent? e = SocketEvent.tryParse(
      '{"type":"chat_message","clientMessageId":"abc","replay":true,'
      '"data":{"messageid":9,"content":"hi"}}',
    );
    expect(e, isNotNull);
    expect(e!.type, 'chat_message');
    expect(e.clientMessageId, 'abc');
    expect(e.replay, isTrue);
    expect(e.data['messageid'], 9);
    expect(e.data['content'], 'hi');
  });

  test('無 data 時 data 為空 map、replay 預設 false', () {
    final SocketEvent? e = SocketEvent.tryParse('{"type":"notice_unread"}');
    expect(e!.type, 'notice_unread');
    expect(e.data, isEmpty);
    expect(e.replay, isFalse);
  });

  test('非法/非物件/缺 type 一律回 null', () {
    expect(SocketEvent.tryParse('not json'), isNull);
    expect(SocketEvent.tryParse('[1,2,3]'), isNull);
    expect(SocketEvent.tryParse('{"data":{}}'), isNull); // 缺 type
    expect(SocketEvent.tryParse(''), isNull);
    expect(SocketEvent.tryParse(null), isNull);
    expect(SocketEvent.tryParse(42), isNull);
  });
}
