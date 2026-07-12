import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 除錯用 logging 攔截器（規範 §7.1、§7.3）。只在 debug build 掛載，且僅輸出
/// method / URI / 狀態碼；敏感 header 一律遮罩，不輸出 response body。
/// 正式環境不得輸出 token、密碼、簽章、Authorization 或個資。
class LoggingInterceptor extends Interceptor {
  const LoggingInterceptor();

  static const Set<String> _sensitive = <String>{
    'authorization',
    'token',
    'password',
    'passwd',
    'pwd',
    'pass',
    'secret',
    'signature',
    'nonce',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('[HTTP →] ${options.method} ${options.uri}');
      debugPrint('[HTTP →] headers: ${_redact(options.headers)}');
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      debugPrint(
        '[HTTP ←] ${response.statusCode} ${response.requestOptions.uri}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('[HTTP ✗] ${err.type} ${err.requestOptions.uri}');
    }
    handler.next(err);
  }

  Map<String, Object?> _redact(Map<String, dynamic> src) {
    return <String, Object?>{
      for (final MapEntry<String, dynamic> e in src.entries)
        e.key: _sensitive.contains(e.key.toLowerCase())
            ? '<redacted>'
            : e.value,
    };
  }
}
