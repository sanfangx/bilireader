import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_result.dart';
import '../../../core/network/app_error.dart';
import '../../../core/router/auth_controller.dart';
import '../data/auth_providers.dart';
import '../domain/user_info.dart';

part 'login_controller.g.dart';

/// 登入流程狀態（規範 §6.1）。`AsyncValue<void>`：idle=data(null)、進行中=loading、
/// 失敗=error(AppError)。成功後刷新全域認證狀態。
@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {}

  Future<bool> submit({required String uname, required String pass}) async {
    state = const AsyncValue<void>.loading();
    final ApiResult<UserInfo> result = await ref
        .read(authRepositoryProvider)
        .login(uname: uname, pass: pass);
    switch (result) {
      case ApiSuccess<UserInfo>():
        await ref.read(authControllerProvider.notifier).refresh();
        state = const AsyncValue<void>.data(null);
        return true;
      case ApiFailure<UserInfo>(:final AppError error):
        state = AsyncValue<void>.error(error, StackTrace.current);
        return false;
    }
  }
}
