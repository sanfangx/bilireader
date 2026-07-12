import 'package:dio/dio.dart';

import '../../auth/auth_session_manager.dart';
import '../../constants/api_constants.dart';

/// Authorization 攔截器（規範 §7.0，對照 AuthorizationInterceptor）。
/// 掛上原始 token 作為 `Authorization`（**不加 `Bearer ` 前綴**）；token 為空則
/// 不加此 header（匿名請求）。必須排在 UploadSignatureInterceptor 之前。
class AuthorizationInterceptor extends Interceptor {
  const AuthorizationInterceptor(this._session);

  final AuthSessionManager _session;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 送出前確保啟動時 token 已由儲存載入完成，避免冷啟動競態送出無 Authorization
    // 的請求而自招 401、進而清掉已保存的 token（規範 §6.3、§7.3）。首次之後為
    // 已完成的 future，成本可忽略。
    await _session.ensureLoaded();
    final String? token = _session.currentToken;
    if (token != null && token.isNotEmpty) {
      options.headers[ApiConstants.headerAuthorization] = token;
    }
    handler.next(options);
  }
}
