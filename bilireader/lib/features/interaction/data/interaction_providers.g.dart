// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interaction_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(interactionRemoteDataSource)
final interactionRemoteDataSourceProvider =
    InteractionRemoteDataSourceProvider._();

final class InteractionRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          InteractionRemoteDataSource,
          InteractionRemoteDataSource,
          InteractionRemoteDataSource
        >
    with $Provider<InteractionRemoteDataSource> {
  InteractionRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interactionRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interactionRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<InteractionRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InteractionRemoteDataSource create(Ref ref) {
    return interactionRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InteractionRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InteractionRemoteDataSource>(value),
    );
  }
}

String _$interactionRemoteDataSourceHash() =>
    r'ac7d5353cc9bf2bf37c7ab4381c8fb2b5ca5215f';

@ProviderFor(interactionRepository)
final interactionRepositoryProvider = InteractionRepositoryProvider._();

final class InteractionRepositoryProvider
    extends
        $FunctionalProvider<
          InteractionRepository,
          InteractionRepository,
          InteractionRepository
        >
    with $Provider<InteractionRepository> {
  InteractionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interactionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interactionRepositoryHash();

  @$internal
  @override
  $ProviderElement<InteractionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InteractionRepository create(Ref ref) {
    return interactionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InteractionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InteractionRepository>(value),
    );
  }
}

String _$interactionRepositoryHash() =>
    r'133b5abed27a408ae51e96b14494a5f2ea12f904';
