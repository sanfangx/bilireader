// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 文庫可選標籤（`novel/tags`，已轉繁）。供篩選頁的題材多選來源。

@ProviderFor(filterTags)
final filterTagsProvider = FilterTagsProvider._();

/// 文庫可選標籤（`novel/tags`，已轉繁）。供篩選頁的題材多選來源。

final class FilterTagsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// 文庫可選標籤（`novel/tags`，已轉繁）。供篩選頁的題材多選來源。
  FilterTagsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filterTagsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filterTagsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return filterTags(ref);
  }
}

String _$filterTagsHash() => r'4db45b740be83b083bd873d23aa34fbc67da0dd6';

/// 文庫篩選控制器（doc 09 §10.3）。以 `novel/searchNovel` 帶 `tagNames[]` + 完結/字數/
/// 排序篩選；repository 對題材做繁→簡 fallback（規範 §5.0）。任一條件變更重載第一頁。

@ProviderFor(FilterController)
final filterControllerProvider = FilterControllerProvider._();

/// 文庫篩選控制器（doc 09 §10.3）。以 `novel/searchNovel` 帶 `tagNames[]` + 完結/字數/
/// 排序篩選；repository 對題材做繁→簡 fallback（規範 §5.0）。任一條件變更重載第一頁。
final class FilterControllerProvider
    extends $NotifierProvider<FilterController, AsyncValue<FilterViewState>> {
  /// 文庫篩選控制器（doc 09 §10.3）。以 `novel/searchNovel` 帶 `tagNames[]` + 完結/字數/
  /// 排序篩選；repository 對題材做繁→簡 fallback（規範 §5.0）。任一條件變更重載第一頁。
  FilterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filterControllerHash();

  @$internal
  @override
  FilterController create() => FilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<FilterViewState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<FilterViewState>>(value),
    );
  }
}

String _$filterControllerHash() => r'aa757c8df17a66c38a594cb09f64fcf2e97878f0';

/// 文庫篩選控制器（doc 09 §10.3）。以 `novel/searchNovel` 帶 `tagNames[]` + 完結/字數/
/// 排序篩選；repository 對題材做繁→簡 fallback（規範 §5.0）。任一條件變更重載第一頁。

abstract class _$FilterController
    extends $Notifier<AsyncValue<FilterViewState>> {
  AsyncValue<FilterViewState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<FilterViewState>, AsyncValue<FilterViewState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<FilterViewState>,
                AsyncValue<FilterViewState>
              >,
              AsyncValue<FilterViewState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
