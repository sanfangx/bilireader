import 'dart:async';

import 'package:bilireader/core/ws/app_web_socket.dart';
import 'package:bilireader/core/ws/socket_event.dart';

/// 測試用假 socket：不開任何網路連線，可用 [emit] 手動推事件驗證訂閱者反應。
class FakeAppWebSocket extends AppWebSocket {
  FakeAppWebSocket()
    : super(url: 'ws://test.invalid', tokenProvider: () => null);

  final StreamController<SocketEvent> _controller =
      StreamController<SocketEvent>.broadcast();

  int connectCount = 0;
  int resetReconnectCount = 0;

  @override
  Stream<SocketEvent> get events => _controller.stream;

  @override
  void connect() {
    connectCount++;
  }

  @override
  void resetBackoffAndReconnect() {
    resetReconnectCount++;
  }

  @override
  void disconnect() {}

  @override
  void dispose() {
    _controller.close();
  }

  /// 推一則事件給所有訂閱者。
  void emit(String type, {Map<String, dynamic> data = const {}}) {
    _controller.add(SocketEvent(type: type, data: data));
  }
}
