import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_result.dart';
import '../../../core/network/app_error.dart';
import '../../../core/router/auth_controller.dart';
import '../data/auth_providers.dart';
import '../domain/register_captcha.dart';
import '../domain/user_info.dart';

part 'register_controller.g.dart';

/// 註冊圖形驗證碼（`user/register/captcha`，Base64 圖）。`invalidate` 以刷新——
/// 點圖重取 / 註冊失敗後（驗證碼單次有效，比照原生 RegisterActivity）。
@riverpod
Future<RegisterCaptcha> registerCaptcha(Ref ref) async {
  final ApiResult<RegisterCaptcha> res = await ref
      .read(authRepositoryProvider)
      .loadCaptcha();
  return switch (res) {
    ApiSuccess<RegisterCaptcha>(:final RegisterCaptcha data) => data,
    ApiFailure<RegisterCaptcha>(:final AppError error) => throw error,
  };
}

/// 註冊流程狀態（比照 [LoginController]）。`AsyncValue<void>`：idle=data(null)、
/// 進行中=loading、失敗=error(AppError)。成功即**自動登入**（repository 已存 token），
/// 刷新全域認證狀態；失敗則刷新驗證碼（單次有效）。
@riverpod
class RegisterController extends _$RegisterController {
  @override
  FutureOr<void> build() {}

  Future<bool> submit({
    required String uname,
    required String nickname,
    required String pass,
    required String email,
    required String captchaId,
    required String captcha,
  }) async {
    state = const AsyncValue<void>.loading();
    final ApiResult<UserInfo> result = await ref
        .read(authRepositoryProvider)
        .register(
          uname: uname,
          nickname: nickname,
          pass: pass,
          email: email,
          captchaId: captchaId,
          captcha: captcha,
        );
    switch (result) {
      case ApiSuccess<UserInfo>():
        await ref.read(authControllerProvider.notifier).refresh();
        state = const AsyncValue<void>.data(null);
        return true;
      case ApiFailure<UserInfo>(:final AppError error):
        state = AsyncValue<void>.error(error, StackTrace.current);
        // 失敗（含驗證碼錯／已被使用）→ 刷新驗證碼供重試。
        ref.invalidate(registerCaptchaProvider);
        return false;
    }
  }
}
