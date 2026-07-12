// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(systemRemoteDataSource)
final systemRemoteDataSourceProvider = SystemRemoteDataSourceProvider._();

final class SystemRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          SystemRemoteDataSource,
          SystemRemoteDataSource,
          SystemRemoteDataSource
        >
    with $Provider<SystemRemoteDataSource> {
  SystemRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'systemRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$systemRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<SystemRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SystemRemoteDataSource create(Ref ref) {
    return systemRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SystemRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SystemRemoteDataSource>(value),
    );
  }
}

String _$systemRemoteDataSourceHash() =>
    r'2fe9cb63094c56c39a848254fb43b84b5126fe07';

@ProviderFor(systemRepository)
final systemRepositoryProvider = SystemRepositoryProvider._();

final class SystemRepositoryProvider
    extends
        $FunctionalProvider<
          SystemRepository,
          SystemRepository,
          SystemRepository
        >
    with $Provider<SystemRepository> {
  SystemRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'systemRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$systemRepositoryHash();

  @$internal
  @override
  $ProviderElement<SystemRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SystemRepository create(Ref ref) {
    return systemRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SystemRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SystemRepository>(value),
    );
  }
}

String _$systemRepositoryHash() => r'fb3ea2c6956a4f60715471f12d6520319b90f76a';
