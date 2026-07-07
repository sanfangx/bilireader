import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../auth/auth_session_manager.dart';
import '../constants/api_constants.dart';
import 'interceptors/auth_failure_interceptor.dart';
import 'interceptors/authorization_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/upload_signature_interceptor.dart';
import 'interceptors/version_check_interceptor.dart';
import 'interceptors/version_interceptor.dart';

/// 建立 App 的 Dio client（規範 §7.1）。Base URL / timeout / 攔截器鏈集中於此。
///
/// 攔截器順序符合原始行為（規範 §7.0）：
/// Logging(debug only) → Version → VersionCheck → Authorization → UploadSignature，
/// 另加集中處理 401/666 的 AuthFailure（規範 §6.3）。
Dio buildDioClient({
  required AuthSessionManager session,
  required void Function() onForceUpdate,
  required void Function(int code) onAuthFailure,
  String? Function()? acceptLanguageResolver,
}) {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      sendTimeout: ApiConstants.sendTimeout,
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(const LoggingInterceptor());
  }
  dio.interceptors.add(
    VersionInterceptor(acceptLanguageResolver: acceptLanguageResolver),
  );
  dio.interceptors.add(VersionCheckInterceptor(onForceUpdate));
  dio.interceptors.add(AuthorizationInterceptor(session));
  dio.interceptors.add(UploadSignatureInterceptor());
  dio.interceptors.add(AuthFailureInterceptor(onAuthFailure));

  return dio;
}
