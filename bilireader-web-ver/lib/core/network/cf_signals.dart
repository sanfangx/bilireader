import 'package:dio/dio.dart';

/// Cloudflare / 限流訊號的**單一判定來源**。
///
/// [AuthInterceptor]（判 session 失效）與 [RetryInterceptor]（判可否退避重試）共用，
/// 避免兩處判別邏輯漂移——這是「統一 CF 復原器」的核心：challenge 與 transient
/// 的界線只在這裡定義一次。
class CfSignals {
  CfSignals._();

  /// 真正的「CF 挑戰 / 登入態失效」——需重新過人機驗證或重登，
  /// **不可**用退避重試解決（重試只會白費配額並拖延使用者重新驗證）。
  static bool looksLikeChallenge(Response response) {
    final int code = response.statusCode ?? 0;
    final String body = response.data is String ? response.data as String : '';

    // 跟隨重導後最終落在 login.php → 登入態失效。
    if (response.realUri.toString().contains('/login.php')) return true;

    // Cloudflare 挑戰特徵（cf_clearance 失效 / 需重新過驗證）。
    if (response.headers.value('cf-mitigated') != null) return true;
    if (code == 403 && body.contains('_cf_chl_opt')) return true;
    if (code == 503 && body.contains('Cloudflare')) return true;
    if ((code == 403 || code == 503) &&
        (body.contains('Just a moment') ||
            body.contains('challenge-platform'))) {
      return true;
    }
    return false;
  }

  /// 暫時性、可退避重試的狀態碼（純限流 429 / 閘道抖動 502·504 / 服務暫停 503）。
  ///
  /// 注意：503 也可能是 CF 挑戰頁——呼叫端**必須**先以 [looksLikeChallenge] 排除，
  /// 再用本判定決定是否重試（挑戰不重試、純限流才重試）。
  static bool isTransientStatus(int code) =>
      code == 429 || code == 502 || code == 503 || code == 504;

  /// 綜合判定：此 response 是否為「應退避重試的暫時性失敗」
  /// （暫時性狀態碼 **且非** 真正 CF 挑戰）。
  static bool isRetriableResponse(Response response) {
    final int code = response.statusCode ?? 0;
    return isTransientStatus(code) && !looksLikeChallenge(response);
  }
}
