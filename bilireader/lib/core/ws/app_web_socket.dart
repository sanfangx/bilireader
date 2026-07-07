import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as ws_status;

import 'socket_event.dart';

/// 單一 WebSocket 連線管理（doc 08）。負責握手（raw `Authorization` header，無 Bearer）、
/// 傳輸層 25s ping、指數退避重連（1/2/4/8/16→封頂 30s）、事件解碼與送出。
///
/// notice / chat 兩通道各自持有一個實例（URL 不同）。純邏輯 + web_socket_channel，
/// 不依賴 Riverpod/UI，便於以 fake channel 測試。
class AppWebSocket {
  AppWebSocket({
    required this.url,
    required this.tokenProvider,
    this.extraHeaders = const <String, String>{},
    this.pingInterval = const Duration(seconds: 25),
    IOWebSocketChannel Function(
      Uri url,
      Map<String, dynamic> headers,
      Duration ping,
    )?
    connector,
  }) : _connector = connector ?? _defaultConnect;

  final String url;

  /// 目前 token 來源（AuthSessionManager.currentToken）；null/空 → 不連線。
  final String? Function() tokenProvider;

  /// 額外 header（App-Version-Name / X-Device-Model / X-OS-Version）。
  final Map<String, String> extraHeaders;
  final Duration pingInterval;

  final IOWebSocketChannel Function(Uri, Map<String, dynamic>, Duration)
  _connector;

  IOWebSocketChannel? _channel;
  StreamSubscription<dynamic>? _sub;
  Timer? _reconnectTimer;
  int _attempt = 0;
  bool _active = false;

  final StreamController<SocketEvent> _events =
      StreamController<SocketEvent>.broadcast();

  /// 已解碼的事件串流（broadcast）。
  Stream<SocketEvent> get events => _events.stream;

  /// 連線狀態（供 UI 顯示）。
  final ValueNotifier<SocketStatus> status = ValueNotifier<SocketStatus>(
    SocketStatus.idle,
  );

  static IOWebSocketChannel _defaultConnect(
    Uri url,
    Map<String, dynamic> headers,
    Duration ping,
  ) => IOWebSocketChannel.connect(url, headers: headers, pingInterval: ping);

  /// 開始連線並在斷線時自動重連（需有 token）。
  void connect() {
    _active = true;
    _open();
  }

  void _open() {
    _cancelReconnect();
    // 冪等：連線前先拆除任何既有 channel/subscription。避免已連線時重入 connect()/_open()
    // （通知/私訊頁每次 build 皆呼叫 connect()）孤兒化前一條連線——舊 _sub 仍推事件進共享
    // _events → 重複/跨連線事件。重連路徑上 channel 已為 null，此呼叫為 no-op。
    _teardownChannel();
    final String? token = tokenProvider();
    if (token == null || token.isEmpty) {
      status.value = SocketStatus.disconnected;
      // 仍在重連循環中但目前無 token（如尚未登入 / 剛登出）：排程稍後再試，
      // 以便重新登入後自動接上；否則會永久卡在 disconnected（審查發現的高風險）。
      if (_active) {
        _scheduleReconnect();
      }
      return;
    }
    status.value = SocketStatus.connecting;
    try {
      final IOWebSocketChannel channel = _connector(
        Uri.parse(url),
        <String, dynamic>{'Authorization': token, ...extraHeaders},
        pingInterval,
      );
      _channel = channel;
      _sub = channel.stream.listen(
        (Object? data) {
          if (status.value != SocketStatus.connected) {
            status.value = SocketStatus.connected;
            _attempt = 0;
          }
          final SocketEvent? event = SocketEvent.tryParse(data);
          if (event != null && !_events.isClosed) {
            _events.add(event);
          }
        },
        onError: (Object _, StackTrace _) => _onDisconnect(),
        onDone: _onDisconnect,
        cancelOnError: true,
      );
    } on Object {
      _onDisconnect();
    }
  }

  void _onDisconnect() {
    status.value = SocketStatus.disconnected;
    _teardownChannel();
    if (_active) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _cancelReconnect();
    final int capped = _attempt > 5 ? 5 : _attempt; // 2^5=32 → 封頂 30s
    final int base = 1 << capped;
    final int delaySec = base >= 30 ? 30 : base; // 1,2,4,8,16,30
    _attempt++;
    _reconnectTimer = Timer(Duration(seconds: delaySec), () {
      if (_active) {
        _open();
      }
    });
  }

  /// 網路恢復：重置退避並立即重連。
  void resetBackoffAndReconnect() {
    _attempt = 0;
    if (_active) {
      _open();
    }
  }

  /// 送出一則 frame（僅在已連線時）。
  void send(Map<String, dynamic> payload) {
    if (status.value == SocketStatus.connected) {
      _channel?.sink.add(jsonEncode(payload));
    }
  }

  /// 主動關閉且不再重連。
  void disconnect() {
    _active = false;
    _cancelReconnect();
    _teardownChannel();
    status.value = SocketStatus.idle;
  }

  void _teardownChannel() {
    _sub?.cancel();
    _sub = null;
    _channel?.sink.close(ws_status.normalClosure);
    _channel = null;
  }

  void _cancelReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  void dispose() {
    disconnect();
    status.dispose();
    unawaited(_events.close());
  }
}
