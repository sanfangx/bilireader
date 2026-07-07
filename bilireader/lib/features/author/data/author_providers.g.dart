// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authorRemoteDataSource)
final authorRemoteDataSourceProvider = AuthorRemoteDataSourceProvider._();

final class AuthorRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          AuthorRemoteDataSource,
          AuthorRemoteDataSource,
          AuthorRemoteDataSource
        >
    with $Provider<AuthorRemoteDataSource> {
  AuthorRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authorRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authorRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<AuthorRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthorRemoteDataSource create(Ref ref) {
    return authorRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthorRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthorRemoteDataSource>(value),
    );
  }
}

String _$authorRemoteDataSourceHash() =>
    r'efcbf0c7930aee513a32737ba2dd1f5bcb2e41d6';

@ProviderFor(authorRepository)
final authorRepositoryProvider = AuthorRepositoryProvider._();

final class AuthorRepositoryProvider
    extends
        $FunctionalProvider<
          AuthorRepository,
          AuthorRepository,
          AuthorRepository
        >
    with $Provider<AuthorRepository> {
  AuthorRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authorRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authorRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthorRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthorRepository create(Ref ref) {
    return authorRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthorRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthorRepository>(value),
    );
  }
}

String _$authorRepositoryHash() => r'ddef3e3d53607d78f6537ab71367b8aedbef7173';
