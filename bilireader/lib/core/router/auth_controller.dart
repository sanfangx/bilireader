import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../di/infra_providers.dart';

part 'auth_controller.g.dart';

/// 認證狀態快照。groupId 語意見 apk/docs（1=管理員、5=作者、6=用愛發電）。
@immutable
class AuthSnapshot {
  const AuthSnapshot({required this.isLoggedIn, this.groupId});

  final bool isLoggedIn;
  final int? groupId;

  /// 是否具作者專區權限（規範 §2.2 / doc 09）。
  bool get canAccessAuthorZone =>
      isLoggedIn && (groupId == 1 || groupId == 5 || groupId == 6);
}

/// 全域認證狀態（keepAlive）。以 [AuthSessionManager] 為本地 session 來源。
/// 啟動時載入儲存的 token/uid/groupid；登入/登出/401·666 失效時更新（規範 §6.3）。
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  AuthSnapshot build() {
    unawaited(_restore());
    return const AuthSnapshot(isLoggedIn: false);
  }

  Future<void> _restore() async {
    final data = await ref.read(authSessionManagerProvider).load();
    state = AuthSnapshot(isLoggedIn: data.isLoggedIn, groupId: data.groupId);
  }

  /// 登入 / 登出 / 註冊後由 auth feature 呼叫，重新從 session 載入狀態。
  Future<void> refresh() => _restore();

  /// 登入 / 註冊成功後保存 session（Phase 4 認證流程呼叫）。
  Future<void> markLoggedIn({
    required String token,
    int? uid,
    int? groupId,
  }) async {
    await ref
        .read(authSessionManagerProvider)
        .persist(token: token, uid: uid, groupId: groupId);
    state = AuthSnapshot(isLoggedIn: true, groupId: groupId);
  }

  /// 登出：無論 server 是否成功都清本地登入態（規範 §7.3）。
  Future<void> logout() async {
    await ref.read(authSessionManagerProvider).clear();
    state = const AuthSnapshot(isLoggedIn: false);
  }

  /// 401/666 集中處理（規範 §6.3）：5 秒 debounce 清 token/uid/groupid，並更新狀態。
  Future<void> onAuthFailure(int code) async {
    final bool cleared = await ref
        .read(authSessionManagerProvider)
        .clearWithDebounce(nowMs: DateTime.now().millisecondsSinceEpoch);
    if (cleared) {
      state = const AuthSnapshot(isLoggedIn: false);
    }
  }
}
