import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/network/base_response.dart';
import '../../../core/network/error_mapper.dart';
import 'dto/login_challenge_response.dart';
import 'dto/login_response.dart';
import 'dto/register_captcha_response.dart';
import 'dto/user_entity.dart';

/// 認證端點呼叫（規範 §7.0、API.md）。全部 POST；回應以 BaseResponse 解封，
/// 非 200 或 data 為 null 拋 [ErrorMapper] 產生的 AppError。
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<LoginChallengeResponse> challenge(String uname) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.loginChallenge,
      data: <String, dynamic>{'uname': uname},
    );
    return _unwrap(resp, LoginChallengeResponse.fromJson);
  }

  Future<LoginResponse> login({
    required String uname,
    required String pass,
    required String challengeId,
    required String proof,
    required String nonce,
    required int timestampMs,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.login,
      data: <String, dynamic>{
        'uname': uname,
        'pass': pass,
        'challengeId': challengeId,
        'proof': proof,
        'nonce': nonce,
        'timestamp': timestampMs,
      },
    );
    return _unwrap(resp, LoginResponse.fromJson);
  }

  Future<UserEntity> getUserInfo() async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.getUserInfo,
    );
    return _unwrap(resp, UserEntity.fromJson);
  }

  /// best-effort；呼叫端無論成功與否都清本地（規範 §7.3）。
  Future<void> logout() async {
    await _dio.post<dynamic>(ApiPaths.logout);
  }

  Future<RegisterCaptchaResponse> loadCaptcha() async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.registerCaptcha,
    );
    return _unwrap(resp, RegisterCaptchaResponse.fromJson);
  }

  Future<LoginResponse> register({
    required String uname,
    required String name,
    required String pass,
    required String email,
    required String captchaId,
    required String captcha,
    required String deviceId,
  }) async {
    final Response<dynamic> resp = await _dio.post<dynamic>(
      ApiPaths.register,
      data: <String, dynamic>{
        'uname': uname,
        'name': name,
        'pass': pass,
        'email': email,
        'captchaId': captchaId,
        'captcha': captcha,
        'deviceId': deviceId,
      },
    );
    return _unwrap(resp, LoginResponse.fromJson);
  }

  T _unwrap<T>(
    Response<dynamic> resp,
    T Function(Map<String, dynamic> json) fromJson,
  ) {
    final Object? body = resp.data;
    final Map<String, dynamic> map = body is Map<String, dynamic>
        ? body
        : const <String, dynamic>{};
    final BaseResponse<T> base = BaseResponse<T>.fromJson(
      map,
      (Object? d) => fromJson(d! as Map<String, dynamic>),
    );
    if (base.code != ApiConstants.codeSuccess) {
      throw ErrorMapper.fromBusinessCode(
        code: base.code,
        serverMessage: base.message,
      );
    }
    final T? data = base.data;
    if (data == null) {
      throw ErrorMapper.emptyData();
    }
    return data;
  }
}
