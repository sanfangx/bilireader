import 'package:dio/dio.dart';

import '../app_config.dart';
import '../session/auth_controller.dart';
import 'cf_signals.dart';

/// 每個請求帶上固定 UA + 收割到的 cookie；
/// 偵測 Cloudflare 挑戰 / 導回 login.php → 標記 session 逾期。
class AuthInterceptor extends Interceptor {
  /// `options.extra[suppressExpiryKey]=true` → 此請求即使遇 CF 挑戰也**不** markExpired。
  /// 供 best-effort 的 `/user.php` 身分抓取使用：抓不到頂多沒暱稱，不該把剛登入的
  /// session 誤標過期（登入成功→1.3s 跳登入過期頁的 bug）。
  static const String suppressExpiryKey = 'suppress_expiry';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['User-Agent'] = AppConfig.userAgent;
    options.headers.putIfAbsent('Accept-Language', () => 'zh-TW,zh;q=0.9');

    final cookie = AuthController.instance.session?.cookieHeader;
    options.headers['Cookie'] =
        (cookie != null && cookie.isNotEmpty) ? cookie : 'night=0';

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 只有真正的 CF 挑戰 / 落回 login.php 才 markExpired；純 429 / 短暫 403 屬限流，
    // 由 RetryInterceptor 退避重送，不把使用者踢去重登。判別集中在 CfSignals。
    if (!_suppressed(response.requestOptions) &&
        CfSignals.looksLikeChallenge(response)) {
      AuthController.instance.markExpired();
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final r = err.response;
    if (r != null &&
        !_suppressed(err.requestOptions) &&
        CfSignals.looksLikeChallenge(r)) {
      AuthController.instance.markExpired();
    }
    handler.next(err);
  }

  bool _suppressed(RequestOptions o) => o.extra[suppressExpiryKey] == true;
}
