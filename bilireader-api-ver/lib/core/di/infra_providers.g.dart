// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'infra_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 於 `main()` 以 `overrideWithValue` 注入（SharedPreferences 為非同步初始化）。

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// 於 `main()` 以 `overrideWithValue` 注入（SharedPreferences 為非同步初始化）。

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  /// 於 `main()` 以 `overrideWithValue` 注入（SharedPreferences 為非同步初始化）。
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'39b568fe29dfd4ddff760e26d24e04d107524fba';

@ProviderFor(flutterSecureStorage)
final flutterSecureStorageProvider = FlutterSecureStorageProvider._();

final class FlutterSecureStorageProvider
    extends
        $FunctionalProvider<
          FlutterSecureStorage,
          FlutterSecureStorage,
          FlutterSecureStorage
        >
    with $Provider<FlutterSecureStorage> {
  FlutterSecureStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'flutterSecureStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$flutterSecureStorageHash();

  @$internal
  @override
  $ProviderElement<FlutterSecureStorage> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FlutterSecureStorage create(Ref ref) {
    return flutterSecureStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FlutterSecureStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FlutterSecureStorage>(value),
    );
  }
}

String _$flutterSecureStorageHash() =>
    r'9dabaf04e2265a8783e07e01e36c360bb77ca3d3';

@ProviderFor(tokenStore)
final tokenStoreProvider = TokenStoreProvider._();

final class TokenStoreProvider
    extends $FunctionalProvider<TokenStore, TokenStore, TokenStore>
    with $Provider<TokenStore> {
  TokenStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenStoreHash();

  @$internal
  @override
  $ProviderElement<TokenStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TokenStore create(Ref ref) {
    return tokenStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TokenStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TokenStore>(value),
    );
  }
}

String _$tokenStoreHash() => r'dac34fc57982bfe2191977db19679830b6a65a22';

@ProviderFor(sessionStore)
final sessionStoreProvider = SessionStoreProvider._();

final class SessionStoreProvider
    extends $FunctionalProvider<SessionStore, SessionStore, SessionStore>
    with $Provider<SessionStore> {
  SessionStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionStoreHash();

  @$internal
  @override
  $ProviderElement<SessionStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SessionStore create(Ref ref) {
    return sessionStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionStore>(value),
    );
  }
}

String _$sessionStoreHash() => r'0daa9084993e8182f398b19b7137fa2df745862e';

@ProviderFor(authSessionManager)
final authSessionManagerProvider = AuthSessionManagerProvider._();

final class AuthSessionManagerProvider
    extends
        $FunctionalProvider<
          AuthSessionManager,
          AuthSessionManager,
          AuthSessionManager
        >
    with $Provider<AuthSessionManager> {
  AuthSessionManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authSessionManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authSessionManagerHash();

  @$internal
  @override
  $ProviderElement<AuthSessionManager> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthSessionManager create(Ref ref) {
    return authSessionManager(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthSessionManager value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthSessionManager>(value),
    );
  }
}

String _$authSessionManagerHash() =>
    r'166320950ab4295d25e50b2a012798b989047392';

/// 強制更新旗標（規範 §7.0 501）。UI（Phase 8）觀察此狀態顯示不可取消更新對話框。

@ProviderFor(ForceUpdateController)
final forceUpdateControllerProvider = ForceUpdateControllerProvider._();

/// 強制更新旗標（規範 §7.0 501）。UI（Phase 8）觀察此狀態顯示不可取消更新對話框。
final class ForceUpdateControllerProvider
    extends $NotifierProvider<ForceUpdateController, bool> {
  /// 強制更新旗標（規範 §7.0 501）。UI（Phase 8）觀察此狀態顯示不可取消更新對話框。
  ForceUpdateControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'forceUpdateControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$forceUpdateControllerHash();

  @$internal
  @override
  ForceUpdateController create() => ForceUpdateController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$forceUpdateControllerHash() =>
    r'f615d5ec88d1bddbdea744b10dd3a5c61f614510';

/// 強制更新旗標（規範 §7.0 501）。UI（Phase 8）觀察此狀態顯示不可取消更新對話框。

abstract class _$ForceUpdateController extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
