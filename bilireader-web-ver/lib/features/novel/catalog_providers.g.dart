// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 目錄 **cache-first**：drift `ChapterCatalogs` 有值先回（章節目錄不常變、手動下拉才刷）；
/// 未命中才打網路並寫回。曾快取者斷網也能離線瀏覽目錄（尤其已下載書）。
///
/// 強制重整：呼叫端 `deleteCatalog(articleId)` + `ref.invalidate` → 重跑即 cache miss 走網路。

@ProviderFor(novelCatalog)
final novelCatalogProvider = NovelCatalogFamily._();

/// 目錄 **cache-first**：drift `ChapterCatalogs` 有值先回（章節目錄不常變、手動下拉才刷）；
/// 未命中才打網路並寫回。曾快取者斷網也能離線瀏覽目錄（尤其已下載書）。
///
/// 強制重整：呼叫端 `deleteCatalog(articleId)` + `ref.invalidate` → 重跑即 cache miss 走網路。

final class NovelCatalogProvider
    extends $FunctionalProvider<AsyncValue<Catalog>, Catalog, FutureOr<Catalog>>
    with $FutureModifier<Catalog>, $FutureProvider<Catalog> {
  /// 目錄 **cache-first**：drift `ChapterCatalogs` 有值先回（章節目錄不常變、手動下拉才刷）；
  /// 未命中才打網路並寫回。曾快取者斷網也能離線瀏覽目錄（尤其已下載書）。
  ///
  /// 強制重整：呼叫端 `deleteCatalog(articleId)` + `ref.invalidate` → 重跑即 cache miss 走網路。
  NovelCatalogProvider._({
    required NovelCatalogFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'novelCatalogProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$novelCatalogHash();

  @override
  String toString() {
    return r'novelCatalogProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Catalog> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Catalog> create(Ref ref) {
    final argument = this.argument as String;
    return novelCatalog(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NovelCatalogProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$novelCatalogHash() => r'4a5707024fa667824dc87c00a928595a10562236';

/// 目錄 **cache-first**：drift `ChapterCatalogs` 有值先回（章節目錄不常變、手動下拉才刷）；
/// 未命中才打網路並寫回。曾快取者斷網也能離線瀏覽目錄（尤其已下載書）。
///
/// 強制重整：呼叫端 `deleteCatalog(articleId)` + `ref.invalidate` → 重跑即 cache miss 走網路。

final class NovelCatalogFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Catalog>, String> {
  NovelCatalogFamily._()
    : super(
        retry: null,
        name: r'novelCatalogProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 目錄 **cache-first**：drift `ChapterCatalogs` 有值先回（章節目錄不常變、手動下拉才刷）；
  /// 未命中才打網路並寫回。曾快取者斷網也能離線瀏覽目錄（尤其已下載書）。
  ///
  /// 強制重整：呼叫端 `deleteCatalog(articleId)` + `ref.invalidate` → 重跑即 cache miss 走網路。

  NovelCatalogProvider call(String novelId) =>
      NovelCatalogProvider._(argument: novelId, from: this);

  @override
  String toString() => r'novelCatalogProvider';
}
