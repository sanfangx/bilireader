// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 全域 [AppDatabase]。正式環境開啟檔案型資料庫；測試以 override 本 provider。

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

/// 全域 [AppDatabase]。正式環境開啟檔案型資料庫；測試以 override 本 provider。

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// 全域 [AppDatabase]。正式環境開啟檔案型資料庫；測試以 override 本 provider。
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'62dc9c6bda0456996a564a580e16faff71656a47';

@ProviderFor(chapterCacheDao)
final chapterCacheDaoProvider = ChapterCacheDaoProvider._();

final class ChapterCacheDaoProvider
    extends
        $FunctionalProvider<ChapterCacheDao, ChapterCacheDao, ChapterCacheDao>
    with $Provider<ChapterCacheDao> {
  ChapterCacheDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chapterCacheDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chapterCacheDaoHash();

  @$internal
  @override
  $ProviderElement<ChapterCacheDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChapterCacheDao create(Ref ref) {
    return chapterCacheDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChapterCacheDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChapterCacheDao>(value),
    );
  }
}

String _$chapterCacheDaoHash() => r'689c61e1d5419510adf98937869da24fdfacf77b';

@ProviderFor(bookmarkDao)
final bookmarkDaoProvider = BookmarkDaoProvider._();

final class BookmarkDaoProvider
    extends $FunctionalProvider<BookmarkDao, BookmarkDao, BookmarkDao>
    with $Provider<BookmarkDao> {
  BookmarkDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookmarkDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookmarkDaoHash();

  @$internal
  @override
  $ProviderElement<BookmarkDao> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BookmarkDao create(Ref ref) {
    return bookmarkDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookmarkDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookmarkDao>(value),
    );
  }
}

String _$bookmarkDaoHash() => r'd799aee29190c286283db73ea645e26f248195ab';

@ProviderFor(readingProgressDao)
final readingProgressDaoProvider = ReadingProgressDaoProvider._();

final class ReadingProgressDaoProvider
    extends
        $FunctionalProvider<
          ReadingProgressDao,
          ReadingProgressDao,
          ReadingProgressDao
        >
    with $Provider<ReadingProgressDao> {
  ReadingProgressDaoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'readingProgressDaoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$readingProgressDaoHash();

  @$internal
  @override
  $ProviderElement<ReadingProgressDao> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReadingProgressDao create(Ref ref) {
    return readingProgressDao(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReadingProgressDao value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReadingProgressDao>(value),
    );
  }
}

String _$readingProgressDaoHash() =>
    r'ef75db253318f9e31cba794593e158215c23abe0';
