// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 版塊清單（`circle/sections`）——供分類 chip 使用。

@ProviderFor(circleSections)
final circleSectionsProvider = CircleSectionsProvider._();

/// 版塊清單（`circle/sections`）——供分類 chip 使用。

final class CircleSectionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CircleSection>>,
          List<CircleSection>,
          FutureOr<List<CircleSection>>
        >
    with
        $FutureModifier<List<CircleSection>>,
        $FutureProvider<List<CircleSection>> {
  /// 版塊清單（`circle/sections`）——供分類 chip 使用。
  CircleSectionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'circleSectionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$circleSectionsHash();

  @$internal
  @override
  $FutureProviderElement<List<CircleSection>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CircleSection>> create(Ref ref) {
    return circleSections(ref);
  }
}

String _$circleSectionsHash() => r'1ce6c0d5a459501e3543d428eee1eac942c640af';

@ProviderFor(CircleFeedFilter)
final circleFeedFilterProvider = CircleFeedFilterProvider._();

final class CircleFeedFilterProvider
    extends $NotifierProvider<CircleFeedFilter, CircleTab> {
  CircleFeedFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'circleFeedFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$circleFeedFilterHash();

  @$internal
  @override
  CircleFeedFilter create() => CircleFeedFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CircleTab value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CircleTab>(value),
    );
  }
}

String _$circleFeedFilterHash() => r'15fcbfd239fe4524aec6caf81de7611cefebf20c';

abstract class _$CircleFeedFilter extends $Notifier<CircleTab> {
  CircleTab build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CircleTab, CircleTab>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CircleTab, CircleTab>,
              CircleTab,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(CircleFeedController)
final circleFeedControllerProvider = CircleFeedControllerProvider._();

final class CircleFeedControllerProvider
    extends $AsyncNotifierProvider<CircleFeedController, CircleFeedState> {
  CircleFeedControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'circleFeedControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$circleFeedControllerHash();

  @$internal
  @override
  CircleFeedController create() => CircleFeedController();
}

String _$circleFeedControllerHash() =>
    r'9fd020e6d57ab3a4aa175e14ab3e4337752637dc';

abstract class _$CircleFeedController extends $AsyncNotifier<CircleFeedState> {
  FutureOr<CircleFeedState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<CircleFeedState>, CircleFeedState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CircleFeedState>, CircleFeedState>,
              AsyncValue<CircleFeedState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 貼文詳情（`circle/detail`）。

@ProviderFor(circlePostDetail)
final circlePostDetailProvider = CirclePostDetailFamily._();

/// 貼文詳情（`circle/detail`）。

final class CirclePostDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<CirclePost>,
          CirclePost,
          FutureOr<CirclePost>
        >
    with $FutureModifier<CirclePost>, $FutureProvider<CirclePost> {
  /// 貼文詳情（`circle/detail`）。
  CirclePostDetailProvider._({
    required CirclePostDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'circlePostDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$circlePostDetailHash();

  @override
  String toString() {
    return r'circlePostDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<CirclePost> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<CirclePost> create(Ref ref) {
    final argument = this.argument as int;
    return circlePostDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CirclePostDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$circlePostDetailHash() => r'8d450e246cad587d7054976a0ed5e4eddb2436af';

/// 貼文詳情（`circle/detail`）。

final class CirclePostDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<CirclePost>, int> {
  CirclePostDetailFamily._()
    : super(
        retry: null,
        name: r'circlePostDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 貼文詳情（`circle/detail`）。

  CirclePostDetailProvider call(int topicId) =>
      CirclePostDetailProvider._(argument: topicId, from: this);

  @override
  String toString() => r'circlePostDetailProvider';
}

/// 貼文回覆（`circle/replies`，分頁累積）。

@ProviderFor(CircleRepliesController)
final circleRepliesControllerProvider = CircleRepliesControllerFamily._();

/// 貼文回覆（`circle/replies`，分頁累積）。
final class CircleRepliesControllerProvider
    extends
        $AsyncNotifierProvider<CircleRepliesController, CircleRepliesState> {
  /// 貼文回覆（`circle/replies`，分頁累積）。
  CircleRepliesControllerProvider._({
    required CircleRepliesControllerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'circleRepliesControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$circleRepliesControllerHash();

  @override
  String toString() {
    return r'circleRepliesControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CircleRepliesController create() => CircleRepliesController();

  @override
  bool operator ==(Object other) {
    return other is CircleRepliesControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$circleRepliesControllerHash() =>
    r'577db43e5feb577b73b38d24657802aa754e505f';

/// 貼文回覆（`circle/replies`，分頁累積）。

final class CircleRepliesControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          CircleRepliesController,
          AsyncValue<CircleRepliesState>,
          CircleRepliesState,
          FutureOr<CircleRepliesState>,
          int
        > {
  CircleRepliesControllerFamily._()
    : super(
        retry: null,
        name: r'circleRepliesControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 貼文回覆（`circle/replies`，分頁累積）。

  CircleRepliesControllerProvider call(int topicId) =>
      CircleRepliesControllerProvider._(argument: topicId, from: this);

  @override
  String toString() => r'circleRepliesControllerProvider';
}

/// 貼文回覆（`circle/replies`，分頁累積）。

abstract class _$CircleRepliesController
    extends $AsyncNotifier<CircleRepliesState> {
  late final _$args = ref.$arg as int;
  int get topicId => _$args;

  FutureOr<CircleRepliesState> build(int topicId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<CircleRepliesState>, CircleRepliesState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CircleRepliesState>, CircleRepliesState>,
              AsyncValue<CircleRepliesState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// 圈子互動（like / reply_like / publish / reply）。狀態變更端點（§7.0），僅供
/// 使用者操作、不做破壞性自動測試。成功後由呼叫端 invalidate 對應 provider。

@ProviderFor(CircleActions)
final circleActionsProvider = CircleActionsProvider._();

/// 圈子互動（like / reply_like / publish / reply）。狀態變更端點（§7.0），僅供
/// 使用者操作、不做破壞性自動測試。成功後由呼叫端 invalidate 對應 provider。
final class CircleActionsProvider
    extends $NotifierProvider<CircleActions, void> {
  /// 圈子互動（like / reply_like / publish / reply）。狀態變更端點（§7.0），僅供
  /// 使用者操作、不做破壞性自動測試。成功後由呼叫端 invalidate 對應 provider。
  CircleActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'circleActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$circleActionsHash();

  @$internal
  @override
  CircleActions create() => CircleActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$circleActionsHash() => r'84d917e0dc172372054d3b7d3d7340e93ce26911';

/// 圈子互動（like / reply_like / publish / reply）。狀態變更端點（§7.0），僅供
/// 使用者操作、不做破壞性自動測試。成功後由呼叫端 invalidate 對應 provider。

abstract class _$CircleActions extends $Notifier<void> {
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
