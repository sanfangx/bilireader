// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_controllers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 榜單控制器（doc 09 §10.2）。切換型別 / 週期 / 排序會重載第一頁；
/// 只在對應型別送出 period（type∈{1,4,6}）或 sort（type==2），其餘不送（doc 11 §5.2）。

@ProviderFor(RankingController)
final rankingControllerProvider = RankingControllerProvider._();

/// 榜單控制器（doc 09 §10.2）。切換型別 / 週期 / 排序會重載第一頁；
/// 只在對應型別送出 period（type∈{1,4,6}）或 sort（type==2），其餘不送（doc 11 §5.2）。
final class RankingControllerProvider
    extends $NotifierProvider<RankingController, AsyncValue<RankingViewState>> {
  /// 榜單控制器（doc 09 §10.2）。切換型別 / 週期 / 排序會重載第一頁；
  /// 只在對應型別送出 period（type∈{1,4,6}）或 sort（type==2），其餘不送（doc 11 §5.2）。
  RankingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rankingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rankingControllerHash();

  @$internal
  @override
  RankingController create() => RankingController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<RankingViewState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<RankingViewState>>(value),
    );
  }
}

String _$rankingControllerHash() => r'44e929d5f1ed1ee166aad380823da9b4e3da40b7';

/// 榜單控制器（doc 09 §10.2）。切換型別 / 週期 / 排序會重載第一頁；
/// 只在對應型別送出 period（type∈{1,4,6}）或 sort（type==2），其餘不送（doc 11 §5.2）。

abstract class _$RankingController
    extends $Notifier<AsyncValue<RankingViewState>> {
  AsyncValue<RankingViewState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<RankingViewState>, AsyncValue<RankingViewState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<RankingViewState>,
                AsyncValue<RankingViewState>
              >,
              AsyncValue<RankingViewState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
