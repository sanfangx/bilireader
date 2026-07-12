// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 註冊圖形驗證碼（`user/register/captcha`，Base64 圖）。`invalidate` 以刷新——
/// 點圖重取 / 註冊失敗後（驗證碼單次有效，比照原生 RegisterActivity）。

@ProviderFor(registerCaptcha)
final registerCaptchaProvider = RegisterCaptchaProvider._();

/// 註冊圖形驗證碼（`user/register/captcha`，Base64 圖）。`invalidate` 以刷新——
/// 點圖重取 / 註冊失敗後（驗證碼單次有效，比照原生 RegisterActivity）。

final class RegisterCaptchaProvider
    extends
        $FunctionalProvider<
          AsyncValue<RegisterCaptcha>,
          RegisterCaptcha,
          FutureOr<RegisterCaptcha>
        >
    with $FutureModifier<RegisterCaptcha>, $FutureProvider<RegisterCaptcha> {
  /// 註冊圖形驗證碼（`user/register/captcha`，Base64 圖）。`invalidate` 以刷新——
  /// 點圖重取 / 註冊失敗後（驗證碼單次有效，比照原生 RegisterActivity）。
  RegisterCaptchaProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerCaptchaProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerCaptchaHash();

  @$internal
  @override
  $FutureProviderElement<RegisterCaptcha> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RegisterCaptcha> create(Ref ref) {
    return registerCaptcha(ref);
  }
}

String _$registerCaptchaHash() => r'b977e9147354c20b350e5f61602a5cd4d1b3c10e';

/// 註冊流程狀態（比照 [LoginController]）。`AsyncValue<void>`：idle=data(null)、
/// 進行中=loading、失敗=error(AppError)。成功即**自動登入**（repository 已存 token），
/// 刷新全域認證狀態；失敗則刷新驗證碼（單次有效）。

@ProviderFor(RegisterController)
final registerControllerProvider = RegisterControllerProvider._();

/// 註冊流程狀態（比照 [LoginController]）。`AsyncValue<void>`：idle=data(null)、
/// 進行中=loading、失敗=error(AppError)。成功即**自動登入**（repository 已存 token），
/// 刷新全域認證狀態；失敗則刷新驗證碼（單次有效）。
final class RegisterControllerProvider
    extends $AsyncNotifierProvider<RegisterController, void> {
  /// 註冊流程狀態（比照 [LoginController]）。`AsyncValue<void>`：idle=data(null)、
  /// 進行中=loading、失敗=error(AppError)。成功即**自動登入**（repository 已存 token），
  /// 刷新全域認證狀態；失敗則刷新驗證碼（單次有效）。
  RegisterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'registerControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$registerControllerHash();

  @$internal
  @override
  RegisterController create() => RegisterController();
}

String _$registerControllerHash() =>
    r'095783d83654c15b27758c1b219576fed915a667';

/// 註冊流程狀態（比照 [LoginController]）。`AsyncValue<void>`：idle=data(null)、
/// 進行中=loading、失敗=error(AppError)。成功即**自動登入**（repository 已存 token），
/// 刷新全域認證狀態；失敗則刷新驗證碼（單次有效）。

abstract class _$RegisterController extends $AsyncNotifier<void> {
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
