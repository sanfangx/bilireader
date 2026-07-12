import 'package:dio/dio.dart';

import '../app_config.dart';
import 'auth_interceptor.dart';
import 'rate_limit_interceptor.dart';
import 'retry_interceptor.dart';

/// 共用 dio。帳號 API 回的是 themed HTML（非 JSON），故 responseType=plain、
/// validateStatus 全收（由 AuthInterceptor 判 CF 挑戰 / 302）。
class ApiClient {
  ApiClient._() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.origin,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 30),
        followRedirects: true,
        maxRedirects: 5,
        responseType: ResponseType.plain,
        validateStatus: (_) => true,
        headers: const {'Accept': '*/*'},
      ),
    );
    dio.interceptors.addAll(<Interceptor>[
      // 順序重要：先限流取得放行時槽，再由 Auth 掛 UA/Cookie 並判 CF 挑戰，
      // 最後由 Retry 對暫時性失敗（429/502/504/逾時）退避重送整條鏈。
      RateLimitInterceptor(),
      AuthInterceptor(),
      RetryInterceptor(dio),
    ]);
  }

  static final ApiClient instance = ApiClient._();
  late final Dio dio;
}
