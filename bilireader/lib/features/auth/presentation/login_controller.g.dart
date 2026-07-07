// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 登入流程狀態（規範 §6.1）。`AsyncValue<void>`：idle=data(null)、進行中=loading、
/// 失敗=error(AppError)。成功後刷新全域認證狀態。

@ProviderFor(LoginController)
final loginControllerProvider = LoginControllerProvider._();

/// 登入流程狀態（規範 §6.1）。`AsyncValue<void>`：idle=data(null)、進行中=loading、
/// 失敗=error(AppError)。成功後刷新全域認證狀態。
final class LoginControllerProvider
    extends $AsyncNotifierProvider<LoginController, void> {
  /// 登入流程狀態（規範 §6.1）。`AsyncValue<void>`：idle=data(null)、進行中=loading、
  /// 失敗=error(AppError)。成功後刷新全域認證狀態。
  LoginControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginControllerHash();

  @$internal
  @override
  LoginController create() => LoginController();
}

String _$loginControllerHash() => r'494102a4f5765f2d74aab200dad700ad48bdfe84';

/// 登入流程狀態（規範 §6.1）。`AsyncValue<void>`：idle=data(null)、進行中=loading、
/// 失敗=error(AppError)。成功後刷新全域認證狀態。

abstract class _$LoginController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
