// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ws_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 通知通道（`wss://.../notice`）。keepAlive：整個 App 生命週期共用一條連線。

@ProviderFor(noticeSocket)
final noticeSocketProvider = NoticeSocketProvider._();

/// 通知通道（`wss://.../notice`）。keepAlive：整個 App 生命週期共用一條連線。

final class NoticeSocketProvider
    extends $FunctionalProvider<AppWebSocket, AppWebSocket, AppWebSocket>
    with $Provider<AppWebSocket> {
  /// 通知通道（`wss://.../notice`）。keepAlive：整個 App 生命週期共用一條連線。
  NoticeSocketProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'noticeSocketProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$noticeSocketHash();

  @$internal
  @override
  $ProviderElement<AppWebSocket> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppWebSocket create(Ref ref) {
    return noticeSocket(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppWebSocket value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppWebSocket>(value),
    );
  }
}

String _$noticeSocketHash() => r'c019bc24306d44881c6cbb24124f6c6543fe4082';

/// 私訊通道（`wss://.../chat`）。keepAlive。

@ProviderFor(chatSocket)
final chatSocketProvider = ChatSocketProvider._();

/// 私訊通道（`wss://.../chat`）。keepAlive。

final class ChatSocketProvider
    extends $FunctionalProvider<AppWebSocket, AppWebSocket, AppWebSocket>
    with $Provider<AppWebSocket> {
  /// 私訊通道（`wss://.../chat`）。keepAlive。
  ChatSocketProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatSocketProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatSocketHash();

  @$internal
  @override
  $ProviderElement<AppWebSocket> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppWebSocket create(Ref ref) {
    return chatSocket(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppWebSocket value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppWebSocket>(value),
    );
  }
}

String _$chatSocketHash() => r'7a341df70db68e5564568860d4826388f2e8695b';
