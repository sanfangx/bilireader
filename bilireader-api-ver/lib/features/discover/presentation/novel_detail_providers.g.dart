// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novel_detail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 小說詳情（`novel/getNovelInfo`，計瀏覽）。失敗以 `AsyncError(AppError)` 呈現。

@ProviderFor(novelDetail)
final novelDetailProvider = NovelDetailFamily._();

/// 小說詳情（`novel/getNovelInfo`，計瀏覽）。失敗以 `AsyncError(AppError)` 呈現。

final class NovelDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<NovelSummary>,
          NovelSummary,
          FutureOr<NovelSummary>
        >
    with $FutureModifier<NovelSummary>, $FutureProvider<NovelSummary> {
  /// 小說詳情（`novel/getNovelInfo`，計瀏覽）。失敗以 `AsyncError(AppError)` 呈現。
  NovelDetailProvider._({
    required NovelDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'novelDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$novelDetailHash();

  @override
  String toString() {
    return r'novelDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<NovelSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<NovelSummary> create(Ref ref) {
    final argument = this.argument as int;
    return novelDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is NovelDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$novelDetailHash() => r'3e21bef24d0aa7f983bd4d984e47f8cfd0433990';

/// 小說詳情（`novel/getNovelInfo`，計瀏覽）。失敗以 `AsyncError(AppError)` 呈現。

final class NovelDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<NovelSummary>, int> {
  NovelDetailFamily._()
    : super(
        retry: null,
        name: r'novelDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 小說詳情（`novel/getNovelInfo`，計瀏覽）。失敗以 `AsyncError(AppError)` 呈現。

  NovelDetailProvider call(int articleId) =>
      NovelDetailProvider._(argument: articleId, from: this);

  @override
  String toString() => r'novelDetailProvider';
}

/// 也在看推薦（`novel/alsoReading`）。獨立 provider，失敗不影響主詳情。

@ProviderFor(alsoReading)
final alsoReadingProvider = AlsoReadingFamily._();

/// 也在看推薦（`novel/alsoReading`）。獨立 provider，失敗不影響主詳情。

final class AlsoReadingProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NovelSummary>>,
          List<NovelSummary>,
          FutureOr<List<NovelSummary>>
        >
    with
        $FutureModifier<List<NovelSummary>>,
        $FutureProvider<List<NovelSummary>> {
  /// 也在看推薦（`novel/alsoReading`）。獨立 provider，失敗不影響主詳情。
  AlsoReadingProvider._({
    required AlsoReadingFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'alsoReadingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$alsoReadingHash();

  @override
  String toString() {
    return r'alsoReadingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<NovelSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NovelSummary>> create(Ref ref) {
    final argument = this.argument as int;
    return alsoReading(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AlsoReadingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$alsoReadingHash() => r'babf7caddf93ecbde58954da81bd7e56ef8f8d78';

/// 也在看推薦（`novel/alsoReading`）。獨立 provider，失敗不影響主詳情。

final class AlsoReadingFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<NovelSummary>>, int> {
  AlsoReadingFamily._()
    : super(
        retry: null,
        name: r'alsoReadingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 也在看推薦（`novel/alsoReading`）。獨立 provider，失敗不影響主詳情。

  AlsoReadingProvider call(int articleId) =>
      AlsoReadingProvider._(argument: articleId, from: this);

  @override
  String toString() => r'alsoReadingProvider';
}

/// 章節目錄（`novel/getchapter`，永久快取優先，需登入）。

@ProviderFor(novelCatalog)
final novelCatalogProvider = NovelCatalogFamily._();

/// 章節目錄（`novel/getchapter`，永久快取優先，需登入）。

final class NovelCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<NovelCatalog>,
          NovelCatalog,
          FutureOr<NovelCatalog>
        >
    with $FutureModifier<NovelCatalog>, $FutureProvider<NovelCatalog> {
  /// 章節目錄（`novel/getchapter`，永久快取優先，需登入）。
  NovelCatalogProvider._({
    required NovelCatalogFamily super.from,
    required int super.argument,
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
  $FutureProviderElement<NovelCatalog> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<NovelCatalog> create(Ref ref) {
    final argument = this.argument as int;
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

String _$novelCatalogHash() => r'50604d9897edb57c2895dd8a97db917ffe49b354';

/// 章節目錄（`novel/getchapter`，永久快取優先，需登入）。

final class NovelCatalogFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<NovelCatalog>, int> {
  NovelCatalogFamily._()
    : super(
        retry: null,
        name: r'novelCatalogProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 章節目錄（`novel/getchapter`，永久快取優先，需登入）。

  NovelCatalogProvider call(int articleId) =>
      NovelCatalogProvider._(argument: articleId, from: this);

  @override
  String toString() => r'novelCatalogProvider';
}
