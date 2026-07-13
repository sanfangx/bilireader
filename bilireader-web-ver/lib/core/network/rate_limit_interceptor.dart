import 'package:dio/dio.dart';

import 'rate_limiter.dart';

/// 讓每個 dio 請求先經全域限流器取得放行時槽，再送出。
///
/// 放在攔截器鏈**最前**（onRequest 依序執行），確保所有出站 HTML/API 請求
/// 都受全域限流治理——這是每個 dio 域的驗收條件。
class RateLimitInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await RateLimiter.global.acquire();
    handler.next(options);
  }
}
