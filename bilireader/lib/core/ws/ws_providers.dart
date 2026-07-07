import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../auth/auth_session_manager.dart';
import '../constants/api_constants.dart';
import '../di/infra_providers.dart';
import 'app_web_socket.dart';

part 'ws_providers.g.dart';

/// WS 連線送出的版本 header（與 REST VersionInterceptor 一致；doc 08 另列裝置 header，
/// 但認證僅靠 raw Authorization，裝置 header 於 REST 亦未送，故對齊 REST 只送版本）。
Map<String, String> _versionHeaders() => <String, String>{
  ApiConstants.headerVersionCode: ApiConstants.appVersionCode,
  ApiConstants.headerVersionName: ApiConstants.appVersionName,
};

/// 通知通道（`wss://.../notice`）。keepAlive：整個 App 生命週期共用一條連線。
@Riverpod(keepAlive: true)
AppWebSocket noticeSocket(Ref ref) {
  final AuthSessionManager session = ref.watch(authSessionManagerProvider);
  final AppWebSocket socket = AppWebSocket(
    url: ApiConstants.noticeWsUrl,
    tokenProvider: () => session.currentToken,
    extraHeaders: _versionHeaders(),
  );
  ref.onDispose(socket.dispose);
  return socket;
}

/// 私訊通道（`wss://.../chat`）。keepAlive。
@Riverpod(keepAlive: true)
AppWebSocket chatSocket(Ref ref) {
  final AuthSessionManager session = ref.watch(authSessionManagerProvider);
  final AppWebSocket socket = AppWebSocket(
    url: ApiConstants.chatWsUrl,
    tokenProvider: () => session.currentToken,
    extraHeaders: _versionHeaders(),
  );
  ref.onDispose(socket.dispose);
  return socket;
}
