// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 目前登入者 uid（isMine 判斷 + owner-scoped 快取 key）。

@ProviderFor(currentUid)
final currentUidProvider = CurrentUidProvider._();

/// 目前登入者 uid（isMine 判斷 + owner-scoped 快取 key）。

final class CurrentUidProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// 目前登入者 uid（isMine 判斷 + owner-scoped 快取 key）。
  CurrentUidProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUidProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUidHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return currentUid(ref);
  }
}

String _$currentUidHash() => r'27c4758b929cf89f4f893bc6ce59c4c9042cf717';

/// 私訊會話列表（`message/conversations`）。

@ProviderFor(conversations)
final conversationsProvider = ConversationsProvider._();

/// 私訊會話列表（`message/conversations`）。

final class ConversationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Conversation>>,
          List<Conversation>,
          FutureOr<List<Conversation>>
        >
    with
        $FutureModifier<List<Conversation>>,
        $FutureProvider<List<Conversation>> {
  /// 私訊會話列表（`message/conversations`）。
  ConversationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conversationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conversationsHash();

  @$internal
  @override
  $FutureProviderElement<List<Conversation>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Conversation>> create(Ref ref) {
    return conversations(ref);
  }
}

String _$conversationsHash() => r'b7a5ee37d4fd82b432ff9ec9ce8c1b6b41997b72';

/// 某對話的訊息串流（觀察 owner-scoped 本地快取，即時）。
///
/// build 時：連 chat WebSocket、抓 REST 歷史 upsert 快取、標記已讀、監聽 WS 收訊
/// 寫入快取；最後 yield 快取串流。WS 收到本對話新訊即時反映（doc 08、§5.5）。

@ProviderFor(chatMessages)
final chatMessagesProvider = ChatMessagesFamily._();

/// 某對話的訊息串流（觀察 owner-scoped 本地快取，即時）。
///
/// build 時：連 chat WebSocket、抓 REST 歷史 upsert 快取、標記已讀、監聽 WS 收訊
/// 寫入快取；最後 yield 快取串流。WS 收到本對話新訊即時反映（doc 08、§5.5）。

final class ChatMessagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChatMessage>>,
          List<ChatMessage>,
          Stream<List<ChatMessage>>
        >
    with
        $FutureModifier<List<ChatMessage>>,
        $StreamProvider<List<ChatMessage>> {
  /// 某對話的訊息串流（觀察 owner-scoped 本地快取，即時）。
  ///
  /// build 時：連 chat WebSocket、抓 REST 歷史 upsert 快取、標記已讀、監聽 WS 收訊
  /// 寫入快取；最後 yield 快取串流。WS 收到本對話新訊即時反映（doc 08、§5.5）。
  ChatMessagesProvider._({
    required ChatMessagesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'chatMessagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatMessagesHash();

  @override
  String toString() {
    return r'chatMessagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<ChatMessage>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ChatMessage>> create(Ref ref) {
    final argument = this.argument as int;
    return chatMessages(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ChatMessagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatMessagesHash() => r'169c81951e8b3905af10d32b7275102e25bfd113';

/// 某對話的訊息串流（觀察 owner-scoped 本地快取，即時）。
///
/// build 時：連 chat WebSocket、抓 REST 歷史 upsert 快取、標記已讀、監聽 WS 收訊
/// 寫入快取；最後 yield 快取串流。WS 收到本對話新訊即時反映（doc 08、§5.5）。

final class ChatMessagesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<ChatMessage>>, int> {
  ChatMessagesFamily._()
    : super(
        retry: null,
        name: r'chatMessagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 某對話的訊息串流（觀察 owner-scoped 本地快取，即時）。
  ///
  /// build 時：連 chat WebSocket、抓 REST 歷史 upsert 快取、標記已讀、監聽 WS 收訊
  /// 寫入快取；最後 yield 快取串流。WS 收到本對話新訊即時反映（doc 08、§5.5）。

  ChatMessagesProvider call(int peerId) =>
      ChatMessagesProvider._(argument: peerId, from: this);

  @override
  String toString() => r'chatMessagesProvider';
}

/// 私訊互動（送訊）。§7.0：狀態變更端點，僅使用者操作、不做破壞性自動測試。

@ProviderFor(MessageActions)
final messageActionsProvider = MessageActionsProvider._();

/// 私訊互動（送訊）。§7.0：狀態變更端點，僅使用者操作、不做破壞性自動測試。
final class MessageActionsProvider
    extends $NotifierProvider<MessageActions, void> {
  /// 私訊互動（送訊）。§7.0：狀態變更端點，僅使用者操作、不做破壞性自動測試。
  MessageActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'messageActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$messageActionsHash();

  @$internal
  @override
  MessageActions create() => MessageActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$messageActionsHash() => r'89b1316e9749d929b8083fd5583500b99e56eb1a';

/// 私訊互動（送訊）。§7.0：狀態變更端點，僅使用者操作、不做破壞性自動測試。

abstract class _$MessageActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
