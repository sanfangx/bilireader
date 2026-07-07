import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/discover_providers.dart';
import '../domain/carousel_slide.dart';
import '../domain/novel_summary.dart';
import '../domain/ranking_options.dart';

part 'discover_home_providers.g.dart';

/// 書城首頁各區塊資料 provider（規範 §6.1）。每區塊獨立 `FutureProvider`，
/// 一個失敗不拖累全頁；失敗以 `AsyncError(AppError)` 呈現（UI 用 `BiliErrorView`）。
/// 對應原生「可視區才載入」策略：Widget 進入畫面才 `watch`。

/// 首頁輪播 Banner。
@riverpod
Future<List<CarouselSlide>> homeCarousel(Ref ref) async =>
    (await ref.watch(bookRepositoryProvider).carousel()).dataOrThrow();

/// 題材篩選 chip 列來源（所有可用標籤）。
@riverpod
Future<List<String>> homeTags(Ref ref) async =>
    (await ref.watch(bookRepositoryProvider).tags()).dataOrThrow();

/// 強力推薦（榜單 type=0 今日推薦，橫向書卡；doc 09 §3.2 強推=type 0）。
@riverpod
Future<List<NovelSummary>> homeStrongRec(Ref ref) async =>
    (await ref
            .watch(bookRepositoryProvider)
            .ranking(type: RankingType.todayRecommend))
        .dataOrThrow();

/// 點擊榜（榜單 type=1 週榜，直式；doc 09 §3.2）。
@riverpod
Future<List<NovelSummary>> homeClickRank(Ref ref) async =>
    (await ref
            .watch(bookRepositoryProvider)
            .ranking(type: RankingType.click, period: RankingPeriod.week))
        .dataOrThrow();
