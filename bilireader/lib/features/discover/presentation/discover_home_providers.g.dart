// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 書城首頁各區塊資料 provider（規範 §6.1）。每區塊獨立 `FutureProvider`，
/// 一個失敗不拖累全頁；失敗以 `AsyncError(AppError)` 呈現（UI 用 `BiliErrorView`）。
/// 對應原生「可視區才載入」策略：Widget 進入畫面才 `watch`。
/// 首頁輪播 Banner。

@ProviderFor(homeCarousel)
final homeCarouselProvider = HomeCarouselProvider._();

/// 書城首頁各區塊資料 provider（規範 §6.1）。每區塊獨立 `FutureProvider`，
/// 一個失敗不拖累全頁；失敗以 `AsyncError(AppError)` 呈現（UI 用 `BiliErrorView`）。
/// 對應原生「可視區才載入」策略：Widget 進入畫面才 `watch`。
/// 首頁輪播 Banner。

final class HomeCarouselProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CarouselSlide>>,
          List<CarouselSlide>,
          FutureOr<List<CarouselSlide>>
        >
    with
        $FutureModifier<List<CarouselSlide>>,
        $FutureProvider<List<CarouselSlide>> {
  /// 書城首頁各區塊資料 provider（規範 §6.1）。每區塊獨立 `FutureProvider`，
  /// 一個失敗不拖累全頁；失敗以 `AsyncError(AppError)` 呈現（UI 用 `BiliErrorView`）。
  /// 對應原生「可視區才載入」策略：Widget 進入畫面才 `watch`。
  /// 首頁輪播 Banner。
  HomeCarouselProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeCarouselProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeCarouselHash();

  @$internal
  @override
  $FutureProviderElement<List<CarouselSlide>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CarouselSlide>> create(Ref ref) {
    return homeCarousel(ref);
  }
}

String _$homeCarouselHash() => r'c06e21f38b85d9e5fc183b2771857374ea319c37';

/// 題材篩選 chip 列來源（所有可用標籤）。

@ProviderFor(homeTags)
final homeTagsProvider = HomeTagsProvider._();

/// 題材篩選 chip 列來源（所有可用標籤）。

final class HomeTagsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// 題材篩選 chip 列來源（所有可用標籤）。
  HomeTagsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeTagsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeTagsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return homeTags(ref);
  }
}

String _$homeTagsHash() => r'1a9f16b5b252adddd5bc3da4ee6c3dbb02fa3dd3';

/// 強力推薦（榜單 type=0 今日推薦，橫向書卡；doc 09 §3.2 強推=type 0）。

@ProviderFor(homeStrongRec)
final homeStrongRecProvider = HomeStrongRecProvider._();

/// 強力推薦（榜單 type=0 今日推薦，橫向書卡；doc 09 §3.2 強推=type 0）。

final class HomeStrongRecProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NovelSummary>>,
          List<NovelSummary>,
          FutureOr<List<NovelSummary>>
        >
    with
        $FutureModifier<List<NovelSummary>>,
        $FutureProvider<List<NovelSummary>> {
  /// 強力推薦（榜單 type=0 今日推薦，橫向書卡；doc 09 §3.2 強推=type 0）。
  HomeStrongRecProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeStrongRecProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeStrongRecHash();

  @$internal
  @override
  $FutureProviderElement<List<NovelSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NovelSummary>> create(Ref ref) {
    return homeStrongRec(ref);
  }
}

String _$homeStrongRecHash() => r'd5523372bcd0c8b7537298c92ba5f6b6f1a0e451';

/// 點擊榜（榜單 type=1 週榜，直式；doc 09 §3.2）。

@ProviderFor(homeClickRank)
final homeClickRankProvider = HomeClickRankProvider._();

/// 點擊榜（榜單 type=1 週榜，直式；doc 09 §3.2）。

final class HomeClickRankProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NovelSummary>>,
          List<NovelSummary>,
          FutureOr<List<NovelSummary>>
        >
    with
        $FutureModifier<List<NovelSummary>>,
        $FutureProvider<List<NovelSummary>> {
  /// 點擊榜（榜單 type=1 週榜，直式；doc 09 §3.2）。
  HomeClickRankProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeClickRankProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeClickRankHash();

  @$internal
  @override
  $FutureProviderElement<List<NovelSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NovelSummary>> create(Ref ref) {
    return homeClickRank(ref);
  }
}

String _$homeClickRankHash() => r'92e6f7fce2388deeb64c2774db780b213d679db8';
