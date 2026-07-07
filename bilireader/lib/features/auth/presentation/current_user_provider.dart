import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_result.dart';
import '../../../core/router/auth_controller.dart';
import '../data/auth_providers.dart';
import '../domain/user_info.dart';

part 'current_user_provider.g.dart';

/// 目前登入者資訊（規範 §4.2 app-level provider）。未登入回 null；隨認證狀態變化重取。
/// 供「我的」等頁面以 app-level 方式消費，避免 feature 間直接耦合。
@riverpod
Future<UserInfo?> currentUser(Ref ref) async {
  final AuthSnapshot auth = ref.watch(authControllerProvider);
  if (!auth.isLoggedIn) {
    return null;
  }
  final ApiResult<UserInfo> result = await ref
      .read(authRepositoryProvider)
      .getUserInfo();
  return switch (result) {
    ApiSuccess<UserInfo>(:final UserInfo data) => data,
    ApiFailure<UserInfo>() => null,
  };
}
