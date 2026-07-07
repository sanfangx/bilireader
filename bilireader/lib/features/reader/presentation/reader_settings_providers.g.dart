// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reader_settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(readerSettingsStore)
final readerSettingsStoreProvider = ReaderSettingsStoreProvider._();

final class ReaderSettingsStoreProvider
    extends
        $FunctionalProvider<
          ReaderSettingsStore,
          ReaderSettingsStore,
          ReaderSettingsStore
        >
    with $Provider<ReaderSettingsStore> {
  ReaderSettingsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readerSettingsStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readerSettingsStoreHash();

  @$internal
  @override
  $ProviderElement<ReaderSettingsStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReaderSettingsStore create(Ref ref) {
    return readerSettingsStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReaderSettingsStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReaderSettingsStore>(value),
    );
  }
}

String _$readerSettingsStoreHash() =>
    r'cff21974da1e7f820a01defd74e0d0317107e89d';

/// 閱讀器「字體·排版 + 行為」設定（即時更新 + 本機持久化）。變更後 ⑨e 觸發重排。

@ProviderFor(ReaderSettingsController)
final readerSettingsControllerProvider = ReaderSettingsControllerProvider._();

/// 閱讀器「字體·排版 + 行為」設定（即時更新 + 本機持久化）。變更後 ⑨e 觸發重排。
final class ReaderSettingsControllerProvider
    extends $NotifierProvider<ReaderSettingsController, ReaderSettings> {
  /// 閱讀器「字體·排版 + 行為」設定（即時更新 + 本機持久化）。變更後 ⑨e 觸發重排。
  ReaderSettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readerSettingsControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readerSettingsControllerHash();

  @$internal
  @override
  ReaderSettingsController create() => ReaderSettingsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReaderSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReaderSettings>(value),
    );
  }
}

String _$readerSettingsControllerHash() =>
    r'3ff481d40b5eb50533545f91a375f98a61427bef';

/// 閱讀器「字體·排版 + 行為」設定（即時更新 + 本機持久化）。變更後 ⑨e 觸發重排。

abstract class _$ReaderSettingsController extends $Notifier<ReaderSettings> {
  ReaderSettings build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ReaderSettings, ReaderSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReaderSettings, ReaderSettings>,
              ReaderSettings,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 閱讀主題（內建 4 + 自訂 ≤5；套用/新增/刪除 + 本機持久化）。

@ProviderFor(ReaderThemeController)
final readerThemeControllerProvider = ReaderThemeControllerProvider._();

/// 閱讀主題（內建 4 + 自訂 ≤5；套用/新增/刪除 + 本機持久化）。
final class ReaderThemeControllerProvider
    extends $NotifierProvider<ReaderThemeController, ReaderThemeState> {
  /// 閱讀主題（內建 4 + 自訂 ≤5；套用/新增/刪除 + 本機持久化）。
  ReaderThemeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readerThemeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readerThemeControllerHash();

  @$internal
  @override
  ReaderThemeController create() => ReaderThemeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReaderThemeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReaderThemeState>(value),
    );
  }
}

String _$readerThemeControllerHash() =>
    r'0e03be0db54e1ab308bc5aa000a3e5fff774d9cf';

/// 閱讀主題（內建 4 + 自訂 ≤5；套用/新增/刪除 + 本機持久化）。

abstract class _$ReaderThemeController extends $Notifier<ReaderThemeState> {
  ReaderThemeState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ReaderThemeState, ReaderThemeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReaderThemeState, ReaderThemeState>,
              ReaderThemeState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
