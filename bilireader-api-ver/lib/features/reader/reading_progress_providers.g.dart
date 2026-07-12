// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_progress_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 閱讀進度本地資料來源（drift）。

@ProviderFor(readingProgressLocalDataSource)
final readingProgressLocalDataSourceProvider =
    ReadingProgressLocalDataSourceProvider._();

/// 閱讀進度本地資料來源（drift）。

final class ReadingProgressLocalDataSourceProvider
    extends
        $FunctionalProvider<
          ReadingProgressLocalDataSource,
          ReadingProgressLocalDataSource,
          ReadingProgressLocalDataSource
        >
    with $Provider<ReadingProgressLocalDataSource> {
  /// 閱讀進度本地資料來源（drift）。
  ReadingProgressLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readingProgressLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readingProgressLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<ReadingProgressLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReadingProgressLocalDataSource create(Ref ref) {
    return readingProgressLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReadingProgressLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReadingProgressLocalDataSource>(
        value,
      ),
    );
  }
}

String _$readingProgressLocalDataSourceHash() =>
    r'99f8a3da9253e1d4e97fa19c62c94bca7c61c874';

/// 閱讀進度 repository（本地）。書架「繼續閱讀」與閱讀器共用同一 seam（§5.5）。

@ProviderFor(readingProgressRepository)
final readingProgressRepositoryProvider = ReadingProgressRepositoryProvider._();

/// 閱讀進度 repository（本地）。書架「繼續閱讀」與閱讀器共用同一 seam（§5.5）。

final class ReadingProgressRepositoryProvider
    extends
        $FunctionalProvider<
          ReadingProgressRepository,
          ReadingProgressRepository,
          ReadingProgressRepository
        >
    with $Provider<ReadingProgressRepository> {
  /// 閱讀進度 repository（本地）。書架「繼續閱讀」與閱讀器共用同一 seam（§5.5）。
  ReadingProgressRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readingProgressRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readingProgressRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReadingProgressRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReadingProgressRepository create(Ref ref) {
    return readingProgressRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReadingProgressRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReadingProgressRepository>(value),
    );
  }
}

String _$readingProgressRepositoryHash() =>
    r'b3c5d319aab2bc7208634cbe460f25ad05a0cf22';

/// 目前登入使用者 uid（owner-scoped 本地資料的 key）。未登入為 null。
/// 依賴 [authControllerProvider]，登入/登出/401·666 後自動重讀（§6.3）。

@ProviderFor(currentOwnerUid)
final currentOwnerUidProvider = CurrentOwnerUidProvider._();

/// 目前登入使用者 uid（owner-scoped 本地資料的 key）。未登入為 null。
/// 依賴 [authControllerProvider]，登入/登出/401·666 後自動重讀（§6.3）。

final class CurrentOwnerUidProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  /// 目前登入使用者 uid（owner-scoped 本地資料的 key）。未登入為 null。
  /// 依賴 [authControllerProvider]，登入/登出/401·666 後自動重讀（§6.3）。
  CurrentOwnerUidProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentOwnerUidProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentOwnerUidHash();

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    return currentOwnerUid(ref);
  }
}

String _$currentOwnerUidHash() => r'4a5d99fcddf4cd180fc244b0cd71a21d2912e146';

/// 書架「繼續閱讀」串流：觀察本地 reading progress，閱讀器寫入後即時刷新（§5.5、§6.2）。
/// 未登入時回傳空清單。

@ProviderFor(continueReading)
final continueReadingProvider = ContinueReadingProvider._();

/// 書架「繼續閱讀」串流：觀察本地 reading progress，閱讀器寫入後即時刷新（§5.5、§6.2）。
/// 未登入時回傳空清單。

final class ContinueReadingProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ReadingProgress>>,
          List<ReadingProgress>,
          Stream<List<ReadingProgress>>
        >
    with
        $FutureModifier<List<ReadingProgress>>,
        $StreamProvider<List<ReadingProgress>> {
  /// 書架「繼續閱讀」串流：觀察本地 reading progress，閱讀器寫入後即時刷新（§5.5、§6.2）。
  /// 未登入時回傳空清單。
  ContinueReadingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'continueReadingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$continueReadingHash();

  @$internal
  @override
  $StreamProviderElement<List<ReadingProgress>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ReadingProgress>> create(Ref ref) {
    return continueReading(ref);
  }
}

String _$continueReadingHash() => r'677a850e4116f6463b9f954c137389b682798c15';
