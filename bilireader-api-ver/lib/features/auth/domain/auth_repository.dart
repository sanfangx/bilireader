import '../../../core/network/api_result.dart';
import 'register_captcha.dart';
import 'user_info.dart';

/// 認證 repository 介面（規範 §4.2 domain contract）。login 內部完成
/// challenge→proof→login→存 token→getUserInfo→存 uid/groupid（規範 §7.3）。
abstract interface class AuthRepository {
  /// challenge-based 登入；成功後已保存 session 並回傳使用者資訊。
  Future<ApiResult<UserInfo>> login({
    required String uname,
    required String pass,
  });

  /// 取得目前登入者資訊（需已有 token）。
  Future<ApiResult<UserInfo>> getUserInfo();

  /// 登出：呼叫 logout 端點（best-effort），**無論成功與否都清本地登入態**。
  Future<void> logout();

  /// 取得註冊圖形驗證碼（base64）。
  Future<ApiResult<RegisterCaptcha>> loadCaptcha();

  /// 註冊（成功即自動登入，保存 session 並回傳使用者資訊）。
  Future<ApiResult<UserInfo>> register({
    required String uname,
    required String nickname,
    required String pass,
    required String email,
    required String captchaId,
    required String captcha,
  });
}
