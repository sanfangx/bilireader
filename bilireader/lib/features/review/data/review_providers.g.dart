// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reviewRemoteDataSource)
final reviewRemoteDataSourceProvider = ReviewRemoteDataSourceProvider._();

final class ReviewRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          ReviewRemoteDataSource,
          ReviewRemoteDataSource,
          ReviewRemoteDataSource
        >
    with $Provider<ReviewRemoteDataSource> {
  ReviewRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<ReviewRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReviewRemoteDataSource create(Ref ref) {
    return reviewRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReviewRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReviewRemoteDataSource>(value),
    );
  }
}

String _$reviewRemoteDataSourceHash() =>
    r'6cc1e8134ceabde424c943f8348f9e67c21a1176';

@ProviderFor(reviewRepository)
final reviewRepositoryProvider = ReviewRepositoryProvider._();

final class ReviewRepositoryProvider
    extends
        $FunctionalProvider<
          ReviewRepository,
          ReviewRepository,
          ReviewRepository
        >
    with $Provider<ReviewRepository> {
  ReviewRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reviewRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reviewRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReviewRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ReviewRepository create(Ref ref) {
    return reviewRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReviewRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReviewRepository>(value),
    );
  }
}

String _$reviewRepositoryHash() => r'cd11018845220b82cfb21f8930f6e122dc71c112';
