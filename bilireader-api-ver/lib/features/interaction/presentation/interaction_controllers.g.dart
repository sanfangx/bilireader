// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interaction_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 我對此書的評分（`rating/myRating`）。0 = 未評分。

@ProviderFor(myRating)
final myRatingProvider = MyRatingFamily._();

/// 我對此書的評分（`rating/myRating`）。0 = 未評分。

final class MyRatingProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// 我對此書的評分（`rating/myRating`）。0 = 未評分。
  MyRatingProvider._({
    required MyRatingFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'myRatingProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$myRatingHash();

  @override
  String toString() {
    return r'myRatingProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as int;
    return myRating(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MyRatingProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$myRatingHash() => r'd20fca81970c89776864f2c4a03b49a3857bf087';

/// 我對此書的評分（`rating/myRating`）。0 = 未評分。

final class MyRatingFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, int> {
  MyRatingFamily._()
    : super(
        retry: null,
        name: r'myRatingProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 我對此書的評分（`rating/myRating`）。0 = 未評分。

  MyRatingProvider call(int articleId) =>
      MyRatingProvider._(argument: articleId, from: this);

  @override
  String toString() => r'myRatingProvider';
}

/// 投票統計（`vote/getNovelVotes`）。

@ProviderFor(voteStats)
final voteStatsProvider = VoteStatsFamily._();

/// 投票統計（`vote/getNovelVotes`）。

final class VoteStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<VoteStats>,
          VoteStats,
          FutureOr<VoteStats>
        >
    with $FutureModifier<VoteStats>, $FutureProvider<VoteStats> {
  /// 投票統計（`vote/getNovelVotes`）。
  VoteStatsProvider._({
    required VoteStatsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'voteStatsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$voteStatsHash();

  @override
  String toString() {
    return r'voteStatsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<VoteStats> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<VoteStats> create(Ref ref) {
    final argument = this.argument as int;
    return voteStats(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is VoteStatsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$voteStatsHash() => r'6b149264e66d0a642fc88de3c5fecec577a610a6';

/// 投票統計（`vote/getNovelVotes`）。

final class VoteStatsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<VoteStats>, int> {
  VoteStatsFamily._()
    : super(
        retry: null,
        name: r'voteStatsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 投票統計（`vote/getNovelVotes`）。

  VoteStatsProvider call(int articleId) =>
      VoteStatsProvider._(argument: articleId, from: this);

  @override
  String toString() => r'voteStatsProvider';
}

/// 禮物餘額（`gift/balance`）。

@ProviderFor(giftBalance)
final giftBalanceProvider = GiftBalanceProvider._();

/// 禮物餘額（`gift/balance`）。

final class GiftBalanceProvider
    extends
        $FunctionalProvider<
          AsyncValue<GiftBalance>,
          GiftBalance,
          FutureOr<GiftBalance>
        >
    with $FutureModifier<GiftBalance>, $FutureProvider<GiftBalance> {
  /// 禮物餘額（`gift/balance`）。
  GiftBalanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'giftBalanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$giftBalanceHash();

  @$internal
  @override
  $FutureProviderElement<GiftBalance> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<GiftBalance> create(Ref ref) {
    return giftBalance(ref);
  }
}

String _$giftBalanceHash() => r'77efea786764bb8b449565f34b9920946bf38855';

/// 送花統計（`gift/novel_stat`）。

@ProviderFor(flowerStat)
final flowerStatProvider = FlowerStatFamily._();

/// 送花統計（`gift/novel_stat`）。

final class FlowerStatProvider
    extends
        $FunctionalProvider<
          AsyncValue<FlowerStat>,
          FlowerStat,
          FutureOr<FlowerStat>
        >
    with $FutureModifier<FlowerStat>, $FutureProvider<FlowerStat> {
  /// 送花統計（`gift/novel_stat`）。
  FlowerStatProvider._({
    required FlowerStatFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'flowerStatProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$flowerStatHash();

  @override
  String toString() {
    return r'flowerStatProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<FlowerStat> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<FlowerStat> create(Ref ref) {
    final argument = this.argument as int;
    return flowerStat(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FlowerStatProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$flowerStatHash() => r'5ff7c2b5a3c06960f97a4fb356187913e32d33fe';

/// 送花統計（`gift/novel_stat`）。

final class FlowerStatFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<FlowerStat>, int> {
  FlowerStatFamily._()
    : super(
        retry: null,
        name: r'flowerStatProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 送花統計（`gift/novel_stat`）。

  FlowerStatProvider call(int articleId) =>
      FlowerStatProvider._(argument: articleId, from: this);

  @override
  String toString() => r'flowerStatProvider';
}

/// 互動異動（評分 / 投票 / 送花）。皆為狀態變更端點（§7.0），僅供實際使用者操作，
/// 不做破壞性自動測試。成功後 invalidate 對應讀取 provider。

@ProviderFor(InteractionMutations)
final interactionMutationsProvider = InteractionMutationsProvider._();

/// 互動異動（評分 / 投票 / 送花）。皆為狀態變更端點（§7.0），僅供實際使用者操作，
/// 不做破壞性自動測試。成功後 invalidate 對應讀取 provider。
final class InteractionMutationsProvider
    extends $NotifierProvider<InteractionMutations, void> {
  /// 互動異動（評分 / 投票 / 送花）。皆為狀態變更端點（§7.0），僅供實際使用者操作，
  /// 不做破壞性自動測試。成功後 invalidate 對應讀取 provider。
  InteractionMutationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'interactionMutationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$interactionMutationsHash();

  @$internal
  @override
  InteractionMutations create() => InteractionMutations();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$interactionMutationsHash() =>
    r'4b922f9ad59e57c53797ae6d8e4a1bf95edef82e';

/// 互動異動（評分 / 投票 / 送花）。皆為狀態變更端點（§7.0），僅供實際使用者操作，
/// 不做破壞性自動測試。成功後 invalidate 對應讀取 provider。

abstract class _$InteractionMutations extends $Notifier<void> {
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
