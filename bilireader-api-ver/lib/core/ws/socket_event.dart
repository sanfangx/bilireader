import 'dart:convert';

/// 一則 WebSocket 事件（doc 08 §3）。frame 為 JSON 物件，含 `type` 與可選 `data`。
/// chat 通道另有 `clientMessageId`（ACK 對應）與 `replay`（重播/同步）旗標。
class SocketEvent {
  const SocketEvent({
    required this.type,
    this.data = const <String, dynamic>{},
    this.clientMessageId,
    this.replay = false,
  });

  final String type;
  final Map<String, dynamic> data;
  final String? clientMessageId;
  final bool replay;

  /// 由原始 frame 字串解析；非合法 JSON 物件回傳 null（忽略該 frame）。
  static SocketEvent? tryParse(Object? raw) {
    if (raw is! String || raw.isEmpty) {
      return null;
    }
    final Object? decoded;
    try {
      decoded = jsonDecode(raw);
    } on FormatException {
      return null;
    }
    if (decoded is! Map<String, dynamic>) {
      return null;
    }
    final Object? type = decoded['type'];
    if (type is! String || type.isEmpty) {
      return null;
    }
    final Object? data = decoded['data'];
    return SocketEvent(
      type: type,
      data: data is Map<String, dynamic> ? data : const <String, dynamic>{},
      clientMessageId: decoded['clientMessageId'] as String?,
      replay: decoded['replay'] as bool? ?? false,
    );
  }
}

/// 連線狀態（供 UI 顯示「連線中/已連線/已斷線」）。
enum SocketStatus { idle, connecting, connected, disconnected }
