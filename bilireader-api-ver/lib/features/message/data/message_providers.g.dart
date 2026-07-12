// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(messageRemoteDataSource)
final messageRemoteDataSourceProvider = MessageRemoteDataSourceProvider._();

final class MessageRemoteDataSourceProvider
    extends
        $FunctionalProvider<
          MessageRemoteDataSource,
          MessageRemoteDataSource,
          MessageRemoteDataSource
        >
    with $Provider<MessageRemoteDataSource> {
  MessageRemoteDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'messageRemoteDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$messageRemoteDataSourceHash();

  @$internal
  @override
  $ProviderElement<MessageRemoteDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MessageRemoteDataSource create(Ref ref) {
    return messageRemoteDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MessageRemoteDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MessageRemoteDataSource>(value),
    );
  }
}

String _$messageRemoteDataSourceHash() =>
    r'baefc6e8a4153547adaeaad961ac47425a5070b4';

@ProviderFor(messageRepository)
final messageRepositoryProvider = MessageRepositoryProvider._();

final class MessageRepositoryProvider
    extends
        $FunctionalProvider<
          MessageRepository,
          MessageRepository,
          MessageRepository
        >
    with $Provider<MessageRepository> {
  MessageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'messageRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$messageRepositoryHash();

  @$internal
  @override
  $ProviderElement<MessageRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MessageRepository create(Ref ref) {
    return messageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MessageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MessageRepository>(value),
    );
  }
}

String _$messageRepositoryHash() => r'4ba985625a047356237728949821fe2b064757ba';
