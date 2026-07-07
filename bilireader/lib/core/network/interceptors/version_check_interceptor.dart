import 'package:dio/dio.dart';

import '../../constants/api_constants.dart';

/// 強制更新攔截器（規範 §7.0，對照 VersionCheckInterceptor）。
/// HTTP 狀態 501 或 body `code == 501` 觸發不可忽略的強制更新流程（[_onForceUpdate]）。
/// 需同時檢查 onResponse 與 onError（Dio 可能把非 2xx 視為 error）。只觸發一次。
class VersionCheckInterceptor extends Interceptor {
  VersionCheckInterceptor(this._onForceUpdate);

  final void Function() _onForceUpdate;
  bool _triggered = false;

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (_requiresUpdate(response.statusCode, response.data)) {
      _fire();
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_requiresUpdate(err.response?.statusCode, err.response?.data)) {
      _fire();
    }
    handler.next(err);
  }

  bool _requiresUpdate(int? statusCode, Object? body) {
    if (statusCode == ApiConstants.codeUpdateRequired) {
      return true;
    }
    if (body is Map) {
      final Object? code = body['code'];
      if (code is num && code.toInt() == ApiConstants.codeUpdateRequired) {
        return true;
      }
    }
    return false;
  }

  void _fire() {
    if (_triggered) {
      return;
    }
    _triggered = true;
    _onForceUpdate();
  }
}
