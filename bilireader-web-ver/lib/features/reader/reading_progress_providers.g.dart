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

/// 閱讀進度 repository（本地）。書架「繼續閱讀」與閱讀器共用同一 seam。

@ProviderFor(readingProgressRepository)
final readingProgressRepositoryProvider = ReadingProgressRepositoryProvider._();

/// 閱讀進度 repository（本地）。書架「繼續閱讀」與閱讀器共用同一 seam。

final class ReadingProgressRepositoryProvider
    extends
        $FunctionalProvider<
          ReadingProgressRepository,
          ReadingProgressRepository,
          ReadingProgressRepository
        >
    with $Provider<ReadingProgressRepository> {
  /// 閱讀進度 repository（本地）。書架「繼續閱讀」與閱讀器共用同一 seam。
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

/// 書籤本地資料來源（drift）。閱讀器書籤面板與加入/移除共用。

@ProviderFor(bookmarkLocalDataSource)
final bookmarkLocalDataSourceProvider = BookmarkLocalDataSourceProvider._();

/// 書籤本地資料來源（drift）。閱讀器書籤面板與加入/移除共用。

final class BookmarkLocalDataSourceProvider
    extends
        $FunctionalProvider<
          BookmarkLocalDataSource,
          BookmarkLocalDataSource,
          BookmarkLocalDataSource
        >
    with $Provider<BookmarkLocalDataSource> {
  /// 書籤本地資料來源（drift）。閱讀器書籤面板與加入/移除共用。
  BookmarkLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookmarkLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookmarkLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<BookmarkLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BookmarkLocalDataSource create(Ref ref) {
    return bookmarkLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookmarkLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookmarkLocalDataSource>(value),
    );
  }
}

String _$bookmarkLocalDataSourceHash() =>
    r'e71525e0f9913a09b756d58814d94ed547896447';

/// 書架「繼續閱讀」串流：觀察本地 reading progress，閱讀器寫入後即時刷新。

@ProviderFor(continueReading)
final continueReadingProvider = ContinueReadingProvider._();

/// 書架「繼續閱讀」串流：觀察本地 reading progress，閱讀器寫入後即時刷新。

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
  /// 書架「繼續閱讀」串流：觀察本地 reading progress，閱讀器寫入後即時刷新。
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

String _$continueReadingHash() => r'c54810ad771eeedacad69492dc46ed73174bcf86';
