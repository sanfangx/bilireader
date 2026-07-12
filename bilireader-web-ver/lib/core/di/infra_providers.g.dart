// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'infra_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 全域 [SharedPreferences]。SharedPreferences 為非同步初始化，故此 provider 於 `main()` 以
/// `overrideWithValue` 注入（對齊 api-ver）。未 override 直接讀取即拋錯，提示啟動接線遺漏。

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// 全域 [SharedPreferences]。SharedPreferences 為非同步初始化，故此 provider 於 `main()` 以
/// `overrideWithValue` 注入（對齊 api-ver）。未 override 直接讀取即拋錯，提示啟動接線遺漏。

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  /// 全域 [SharedPreferences]。SharedPreferences 為非同步初始化，故此 provider 於 `main()` 以
  /// `overrideWithValue` 注入（對齊 api-ver）。未 override 直接讀取即拋錯，提示啟動接線遺漏。
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
