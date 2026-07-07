import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common_widgets/app_chip.dart';
import '../../../core/common_widgets/bili_error_view.dart';
import '../../../core/common_widgets/bili_skeleton.dart';
import '../../../core/common_widgets/brand_header.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/text/tw_error.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../domain/novel_summary.dart';
import '../domain/ranking_options.dart';
import 'discover_home_providers.dart';
import 'widgets/carousel_banner.dart';
import 'widgets/novel_card.dart';
import 'widgets/rank_row.dart';
import 'widgets/search_entry_bar.dart';
import 'widgets/section_header.dart';

/// 書城首頁（規範 §2.2、doc 09 §3）。組成：搜尋入口 + 輪播 + 題材 chip +
/// 強力推薦（橫向）+ 點擊榜（直式）。各區塊獨立載入，一區失敗不拖累全頁；
/// 下拉刷新強制重載（對應原生 forceRefresh 繞過 10 分鐘快取）。
class DiscoverPage extends ConsumerWidget {
  const DiscoverPage({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref
      ..invalidate(homeCarouselProvider)
      ..invalidate(homeTagsProvider)
      ..invalidate(homeStrongRecProvider)
      ..invalidate(homeClickRankProvider);
    // 等待重載完成後結束 refresh 動畫；個別失敗由各區塊自行以錯誤態呈現。
    await Future.wait<void>(<Future<void>>[
      _ignoreError(ref.read(homeCarouselProvider.future)),
      _ignoreError(ref.read(homeStrongRecProvider.future)),
      _ignoreError(ref.read(homeClickRankProvider.future)),
    ]);
  }

  Future<void> _ignoreError<T>(Future<T> future) =>
      future.then<void>((_) {}, onError: (Object _, StackTrace _) {});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      key: const Key('page_discover'),
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () => _refresh(ref),
          child: CustomScrollView(
            slivers: <Widget>[
              // `.htop`：書城品牌標頭（與圈子共用 BrandHeader，四分頁標題一致）。
              const SliverToBoxAdapter(
                child: BrandHeader(
                  title: '書城',
                  subtitle: 'BILI · 輕小說',
                  trailing: BrandIconButton(
                    icon: Icons.menu,
                    semanticLabel: '選單',
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  0,
                  AppSpacing.screen,
                  AppSpacing.xl,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(<Widget>[
                    const SearchEntryBar(),
                    const SizedBox(height: AppSpacing.lg),
                    _carousel(ref),
                    const SizedBox(height: AppSpacing.lg),
                    _tags(context, ref),
                    const SizedBox(height: AppSpacing.xl),
                    _HorizontalSection(
                      title: '強力推薦',
                      state: ref.watch(homeStrongRecProvider),
                      onMore: () => context.pushNamed(AppRoutes.rankingName),
                      onRetry: () => ref.invalidate(homeStrongRecProvider),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _clickRank(context, ref),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _carousel(WidgetRef ref) {
    final AsyncValue<List<dynamic>> state = ref.watch(homeCarouselProvider);
    return state.when(
      loading: () => Semantics(
        label: '載入中',
        container: true,
        child: const BiliSkeletonBox(height: 180, radius: AppRadius.banner),
      ),
      error: (Object e, StackTrace _) => _SectionError(
        height: 180,
        error: e,
        onRetry: () => ref.invalidate(homeCarouselProvider),
      ),
      data: (List<dynamic> slides) => slides.isEmpty
          ? const SizedBox.shrink()
          : CarouselBanner(slides: slides.cast()),
    );
  }

  Widget _tags(BuildContext context, WidgetRef ref) {
    return ref
        .watch(homeTagsProvider)
        .maybeWhen(
          data: (List<String> tags) {
            if (tags.isEmpty) {
              return const SizedBox.shrink();
            }
            final List<String> shown = tags.take(12).toList();
            return SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: shown.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (BuildContext context, int i) => AppChip(
                  label: shown[i],
                  onTap: () => context.pushNamed(
                    AppRoutes.tagName,
                    queryParameters: <String, String>{'tag': shown[i]},
                  ),
                ),
              ),
            );
          },
          orElse: () => const SizedBox.shrink(),
        );
  }

  Widget _clickRank(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<NovelSummary>> state = ref.watch(
      homeClickRankProvider,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionHeader(
          title: '點擊榜',
          actionLabel: '更多',
          onAction: () => context.pushNamed(
            AppRoutes.rankingName,
            queryParameters: <String, String>{
              'type': '${RankingType.click.value}',
            },
          ),
        ),
        state.when(
          loading: () => const RankListSkeleton(count: 3),
          error: (Object e, StackTrace _) => _SectionError(
            height: 160,
            error: e,
            onRetry: () => ref.invalidate(homeClickRankProvider),
          ),
          data: (List<NovelSummary> items) => items.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  children: <Widget>[
                    for (final (int i, NovelSummary n) in items.take(8).indexed)
                      RankRow(rank: i + 1, novel: n),
                  ],
                ),
        ),
      ],
    );
  }
}

/// 橫向書卡區塊（標題 + 更多 + 橫向捲動）。
class _HorizontalSection extends ConsumerWidget {
  const _HorizontalSection({
    required this.title,
    required this.state,
    required this.onMore,
    required this.onRetry,
  });

  final String title;
  final AsyncValue<List<NovelSummary>> state;
  final VoidCallback onMore;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionHeader(title: title, actionLabel: '更多', onAction: onMore),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          // 封面 124 + 8 + 書名(11.5×1.5) + 2 + 作者(10×1.5) ≈ 166，留緩衝防溢位。
          height: 178,
          child: state.when(
            loading: () => const HorizontalBooksSkeleton(),
            error: (Object e, StackTrace _) => BiliErrorView(
              message: twErrorMessage(ref.read(chineseConverterProvider), e),
              onRetry: onRetry,
            ),
            data: (List<NovelSummary> items) => items.isEmpty
                ? const SizedBox.shrink()
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppSpacing.md),
                    itemBuilder: (BuildContext context, int i) =>
                        NovelCard(novel: items[i]),
                  ),
          ),
        ),
      ],
    );
  }
}

/// 區塊層級的錯誤盒（固定高度 + 重試），server 訊息經 OpenCC 轉繁。
class _SectionError extends ConsumerWidget {
  const _SectionError({
    required this.height,
    required this.error,
    required this.onRetry,
  });

  final double height;
  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: height,
      child: BiliErrorView(
        message: twErrorMessage(ref.read(chineseConverterProvider), error),
        onRetry: onRetry,
      ),
    );
  }
}
