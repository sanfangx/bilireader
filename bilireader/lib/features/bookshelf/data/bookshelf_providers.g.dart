// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookshelf_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bookcaseRemoteDataSource)
final bookcaseRemoteDataSourceProvider = BookcaseRemoteDataSourceProvider._();

final class BookcaseRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          BookcaseRemoteDataSource,
          BookcaseRemoteDataSource,
          BookcaseRemoteDataSource
        >
    with $Provider<BookcaseRemoteDataSource> {
  BookcaseRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookcaseRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookcaseRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<BookcaseRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BookcaseRemoteDataSource create(Ref ref) {
    return bookcaseRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookcaseRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookcaseRemoteDataSource>(value),
    );
  }
}

String _$bookcaseRemoteDataSourceHash() =>
    r'c0009fd61cc108f4b94364de629573000642cfd8';

@ProviderFor(bookcaseRepository)
final bookcaseRepositoryProvider = BookcaseRepositoryProvider._();

final class BookcaseRepositoryProvider
    extends
        $FunctionalProvider<
          BookcaseRepository,
          BookcaseRepository,
          BookcaseRepository
        >
    with $Provider<BookcaseRepository> {
  BookcaseRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookcaseRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookcaseRepositoryHash();

  @$internal
  @override
  $ProviderElement<BookcaseRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BookcaseRepository create(Ref ref) {
    return bookcaseRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookcaseRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookcaseRepository>(value),
    );
  }
}

String _$bookcaseRepositoryHash() =>
    r'2d0b7528127c3186650dd59aeb3636d83545ba22';
