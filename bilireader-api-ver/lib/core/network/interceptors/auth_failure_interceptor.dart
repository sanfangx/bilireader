import 'package:dio/dio.dart';

import '../../constants/api_constants.dart';

/// 401/666 集中處理攔截器（規範 §6.3）。偵測 body 業務碼 401/666 →
/// 觸發 [_onAuthFailure]（由 App 接上 debounce 清 token/uid/groupid + 導回登入）。
/// 同時檢查 onResponse 與 onError。
class AuthFailureInterceptor extends Interceptor {
  const AuthFailureInterceptor(this._onAuthFailure);

  final void Function(int code) _onAuthFailure;

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _check(response.data);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _check(err.response?.data);
    handler.next(err);
  }

  void _check(Object? body) {
    if (body is! Map) {
      return;
    }
    final Object? raw = body['code'];
    if (raw is! num) {
      return;
    }
    final int code = raw.toInt();
    if (code == ApiConstants.codeTokenInvalid ||
        code == ApiConstants.codeAccountBanned) {
      _onAuthFailure(code);
    }
  }
}
