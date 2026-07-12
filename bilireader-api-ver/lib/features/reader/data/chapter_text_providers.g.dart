// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_text_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chapterTextRemoteDataSource)
final chapterTextRemoteDataSourceProvider =
    ChapterTextRemoteDataSourceProvider._();

final class ChapterTextRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ChapterTextRemoteDataSource,
          ChapterTextRemoteDataSource,
          ChapterTextRemoteDataSource
        >
    with $Provider<ChapterTextRemoteDataSource> {
  ChapterTextRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chapterTextRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chapterTextRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ChapterTextRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChapterTextRemoteDataSource create(Ref ref) {
    return chapterTextRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChapterTextRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChapterTextRemoteDataSource>(value),
    );
  }
}

String _$chapterTextRemoteDataSourceHash() =>
    r'17d51db33eb736e90848586aac6e8dc7ca921901';

@ProviderFor(chapterTextRepository)
final chapterTextRepositoryProvider = ChapterTextRepositoryProvider._();

final class ChapterTextRepositoryProvider
    extends
        $FunctionalProvider<
          ChapterTextRepository,
          ChapterTextRepository,
          ChapterTextRepository
        >
    with $Provider<ChapterTextRepository> {
  ChapterTextRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chapterTextRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chapterTextRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChapterTextRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChapterTextRepository create(Ref ref) {
    return chapterTextRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChapterTextRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChapterTextRepository>(value),
    );
  }
}

String _$chapterTextRepositoryHash() =>
    r'3d7cb37d1575930d8713a8c154b7d01148b01a69';
