// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_comment_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chapterCommentRemoteDataSource)
final chapterCommentRemoteDataSourceProvider =
    ChapterCommentRemoteDataSourceProvider._();

final class ChapterCommentRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ChapterCommentRemoteDataSource,
          ChapterCommentRemoteDataSource,
          ChapterCommentRemoteDataSource
        >
    with $Provider<ChapterCommentRemoteDataSource> {
  ChapterCommentRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chapterCommentRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chapterCommentRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ChapterCommentRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChapterCommentRemoteDataSource create(Ref ref) {
    return chapterCommentRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChapterCommentRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChapterCommentRemoteDataSource>(
        value,
      ),
    );
  }
}

String _$chapterCommentRemoteDataSourceHash() =>
    r'e7ecd0d1852b7bbd86606654ad4a588fdc0c9d20';

@ProviderFor(chapterCommentRepository)
final chapterCommentRepositoryProvider = ChapterCommentRepositoryProvider._();

final class ChapterCommentRepositoryProvider
    extends
        $FunctionalProvider<
          ChapterCommentRepository,
          ChapterCommentRepository,
          ChapterCommentRepository
        >
    with $Provider<ChapterCommentRepository> {
  ChapterCommentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chapterCommentRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chapterCommentRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChapterCommentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ChapterCommentRepository create(Ref ref) {
    return chapterCommentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChapterCommentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChapterCommentRepository>(value),
    );
  }
}

String _$chapterCommentRepositoryHash() =>
    r'40cf5018b962ec0c559fd90e5c1139dbaaafbe49';
