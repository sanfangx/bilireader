// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 全域認證狀態（keepAlive）。以 [AuthSessionManager] 為本地 session 來源。
/// 啟動時載入儲存的 token/uid/groupid；登入/登出/401·666 失效時更新（規範 §6.3）。

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

/// 全域認證狀態（keepAlive）。以 [AuthSessionManager] 為本地 session 來源。
/// 啟動時載入儲存的 token/uid/groupid；登入/登出/401·666 失效時更新（規範 §6.3）。
final class AuthControllerProvider
    extends $NotifierProvider<AuthController, AuthSnapshot> {
  /// 全域認證狀態（keepAlive）。以 [AuthSessionManager] 為本地 session 來源。
  /// 啟動時載入儲存的 token/uid/groupid；登入/登出/401·666 失效時更新（規範 §6.3）。
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthSnapshot value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthSnapshot>(value),
    );
  }
}

String _$authControllerHash() => r'40d9855a2b78578f8f0bbb57f7c82c010d5a0d11';

/// 全域認證狀態（keepAlive）。以 [AuthSessionManager] 為本地 session 來源。
/// 啟動時載入儲存的 token/uid/groupid；登入/登出/401·666 失效時更新（規範 §6.3）。

abstract class _$AuthController extends $Notifier<AuthSnapshot> {
  AuthSnapshot build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AuthSnapshot, AuthSnapshot>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthSnapshot, AuthSnapshot>,
              AuthSnapshot,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
