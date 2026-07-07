// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 目前通知分類分頁。

@ProviderFor(NotificationTabState)
final notificationTabStateProvider = NotificationTabStateProvider._();

/// 目前通知分類分頁。
final class NotificationTabStateProvider
    extends $NotifierProvider<NotificationTabState, NotificationTab> {
  /// 目前通知分類分頁。
  NotificationTabStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'notificationTabStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$notificationTabStateHash();

  @$internal
  @override
  NotificationTabState create() => NotificationTabState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NotificationTab value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NotificationTab>(value),
    );
  }
}

String _$notificationTabStateHash() =>
    r'3270ee661a846d6f988dae3b17e05cd26569b4ea';

/// 目前通知分類分頁。

abstract class _$NotificationTabState extends $Notifier<NotificationTab> {
  NotificationTab build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<NotificationTab, NotificationTab>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NotificationTab, NotificationTab>,
              NotificationTab,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 通知列表（依分類）。連上 notice WebSocket；收到新通知/未讀變更即刷新（doc 08）。

@ProviderFor(NotificationListController)
final notificationListControllerProvider = NotificationListControllerFamily._();

/// 通知列表（依分類）。連上 notice WebSocket；收到新通知/未讀變更即刷新（doc 08）。
final class NotificationListControllerProvider
    extends
        $AsyncNotifierProvider<
          NotificationListController,
          NotificationListState
        > {
  /// 通知列表（依分類）。連上 notice WebSocket；收到新通知/未讀變更即刷新（doc 08）。
  NotificationListControllerProvider._({
    required NotificationListControllerFamily super.from,
    required NotificationTab super.argument,
  }) : super(
         retry: null,
         name: r'notificationListControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$notificationListControllerHash();

  @override
  String toString() {
    return r'notificationListControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  NotificationListController create() => NotificationListController();

  @override
  bool operator ==(Object other) {
    return other is NotificationListControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$notificationListControllerHash() =>
    r'515d4da6896ef41fa42859c3cb6572df6cfd001d';

/// 通知列表（依分類）。連上 notice WebSocket；收到新通知/未讀變更即刷新（doc 08）。

final class NotificationListControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          NotificationListController,
          AsyncValue<NotificationListState>,
          NotificationListState,
          FutureOr<NotificationListState>,
          NotificationTab
        > {
  NotificationListControllerFamily._()
    : super(
        retry: null,
        name: r'notificationListControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 通知列表（依分類）。連上 notice WebSocket；收到新通知/未讀變更即刷新（doc 08）。

  NotificationListControllerProvider call(NotificationTab tab) =>
      NotificationListControllerProvider._(argument: tab, from: this);

  @override
  String toString() => r'notificationListControllerProvider';
}

/// 通知列表（依分類）。連上 notice WebSocket；收到新通知/未讀變更即刷新（doc 08）。

abstract class _$NotificationListController
    extends $AsyncNotifier<NotificationListState> {
  late final _$args = ref.$arg as NotificationTab;
  NotificationTab get tab => _$args;

  FutureOr<NotificationListState> build(NotificationTab tab);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<NotificationListState>, NotificationListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<NotificationListState>,
                NotificationListState
              >,
              AsyncValue<NotificationListState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
