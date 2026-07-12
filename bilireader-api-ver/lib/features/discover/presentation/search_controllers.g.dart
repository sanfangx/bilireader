// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 熱門搜尋關鍵字（`novel/hotSearch`，已轉繁）。

@ProviderFor(hotSearchKeywords)
final hotSearchKeywordsProvider = HotSearchKeywordsProvider._();

/// 熱門搜尋關鍵字（`novel/hotSearch`，已轉繁）。

final class HotSearchKeywordsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// 熱門搜尋關鍵字（`novel/hotSearch`，已轉繁）。
  HotSearchKeywordsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hotSearchKeywordsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hotSearchKeywordsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return hotSearchKeywords(ref);
  }
}

String _$hotSearchKeywordsHash() => r'ed33434170ad0d5ffe163b3560c6333e788a8d91';

/// 本機搜尋歷史（規範：搜尋歷史為本機 SharedPreferences，非 API）。
/// 以繁體保存使用者輸入；最多 [_maxHistory] 筆，最新在前。

@ProviderFor(SearchHistory)
final searchHistoryProvider = SearchHistoryProvider._();

/// 本機搜尋歷史（規範：搜尋歷史為本機 SharedPreferences，非 API）。
/// 以繁體保存使用者輸入；最多 [_maxHistory] 筆，最新在前。
final class SearchHistoryProvider
    extends $NotifierProvider<SearchHistory, List<String>> {
  /// 本機搜尋歷史（規範：搜尋歷史為本機 SharedPreferences，非 API）。
  /// 以繁體保存使用者輸入；最多 [_maxHistory] 筆，最新在前。
  SearchHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchHistoryHash();

  @$internal
  @override
  SearchHistory create() => SearchHistory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$searchHistoryHash() => r'aea987a56212eac7aec7b5598fbc609c5b738fe7';

/// 本機搜尋歷史（規範：搜尋歷史為本機 SharedPreferences，非 API）。
/// 以繁體保存使用者輸入；最多 [_maxHistory] 筆，最新在前。

abstract class _$SearchHistory extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 搜尋結果控制器：`submit` 打第一頁（含繁→簡 fallback），`loadMore` 沿用 variant。
///
/// F-16：每次 `submit` 以 [CancelToken] 取消尚在飛行的舊查詢，避免快速換 query 時
/// 舊回應覆蓋新狀態；被取消的結果（`AppErrorKind.cancelled`，§7.0 靜默）不進錯誤態。
/// F-31：同一 query 已在載入中則忽略重複送出。

@ProviderFor(SearchResultsController)
final searchResultsControllerProvider = SearchResultsControllerProvider._();

/// 搜尋結果控制器：`submit` 打第一頁（含繁→簡 fallback），`loadMore` 沿用 variant。
///
/// F-16：每次 `submit` 以 [CancelToken] 取消尚在飛行的舊查詢，避免快速換 query 時
/// 舊回應覆蓋新狀態；被取消的結果（`AppErrorKind.cancelled`，§7.0 靜默）不進錯誤態。
/// F-31：同一 query 已在載入中則忽略重複送出。
final class SearchResultsControllerProvider
    extends
        $NotifierProvider<
          SearchResultsController,
          AsyncValue<SearchViewState>?
        > {
  /// 搜尋結果控制器：`submit` 打第一頁（含繁→簡 fallback），`loadMore` 沿用 variant。
  ///
  /// F-16：每次 `submit` 以 [CancelToken] 取消尚在飛行的舊查詢，避免快速換 query 時
  /// 舊回應覆蓋新狀態；被取消的結果（`AppErrorKind.cancelled`，§7.0 靜默）不進錯誤態。
  /// F-31：同一 query 已在載入中則忽略重複送出。
  SearchResultsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchResultsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchResultsControllerHash();

  @$internal
  @override
  SearchResultsController create() => SearchResultsController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<SearchViewState>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<SearchViewState>?>(value),
    );
  }
}

String _$searchResultsControllerHash() =>
    r'94163808bd4a3aa8ba9239280377cf9b03f5b966';

/// 搜尋結果控制器：`submit` 打第一頁（含繁→簡 fallback），`loadMore` 沿用 variant。
///
/// F-16：每次 `submit` 以 [CancelToken] 取消尚在飛行的舊查詢，避免快速換 query 時
/// 舊回應覆蓋新狀態；被取消的結果（`AppErrorKind.cancelled`，§7.0 靜默）不進錯誤態。
/// F-31：同一 query 已在載入中則忽略重複送出。

abstract class _$SearchResultsController
    extends $Notifier<AsyncValue<SearchViewState>?> {
  AsyncValue<SearchViewState>? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<SearchViewState>?, AsyncValue<SearchViewState>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<SearchViewState>?,
                AsyncValue<SearchViewState>?
              >,
              AsyncValue<SearchViewState>?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
