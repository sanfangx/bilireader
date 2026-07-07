// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(circleRemoteDataSource)
final circleRemoteDataSourceProvider = CircleRemoteDataSourceProvider._();

final class CircleRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          CircleRemoteDataSource,
          CircleRemoteDataSource,
          CircleRemoteDataSource
        >
    with $Provider<CircleRemoteDataSource> {
  CircleRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'circleRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$circleRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<CircleRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CircleRemoteDataSource create(Ref ref) {
    return circleRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CircleRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CircleRemoteDataSource>(value),
    );
  }
}

String _$circleRemoteDataSourceHash() =>
    r'749d947a956f6bc7d7bd2b1e94505a7b21741a8d';

@ProviderFor(circleRepository)
final circleRepositoryProvider = CircleRepositoryProvider._();

final class CircleRepositoryProvider
    extends
        $FunctionalProvider<
          CircleRepository,
          CircleRepository,
          CircleRepository
        >
    with $Provider<CircleRepository> {
  CircleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'circleRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$circleRepositoryHash();

  @$internal
  @override
  $ProviderElement<CircleRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CircleRepository create(Ref ref) {
    return circleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CircleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CircleRepository>(value),
    );
  }
}

String _$circleRepositoryHash() => r'166c4369a3e40c7ec36dd5465cc4c5593f563e6b';
