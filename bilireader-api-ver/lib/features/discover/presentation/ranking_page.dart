import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widgets/app_chip.dart';
import '../../../core/common_widgets/app_segmented_control.dart';
import '../../../core/common_widgets/bili_empty_view.dart';
import '../../../core/common_widgets/bili_error_view.dart';
import '../../../core/common_widgets/bili_list_footer.dart';
import '../../../core/common_widgets/bili_skeleton.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/text/tw_error.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../domain/ranking_options.dart';
import 'ranking_controllers.dart';
import 'widgets/rank_row.dart';

/// 排行榜頁（doc 09 §10.2）。榜別 chip + 週期 segmented（或新書排序 chip）+ 分頁榜單。
class RankingPage extends ConsumerStatefulWidget {
  const RankingPage({this.initialType = RankingType.defaultValue, super.key});

  final RankingType initialType;

  @override
  ConsumerState<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends ConsumerState<RankingPage> {
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(rankingControllerProvider.notifier)
          .configure(widget.initialType);
    });
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 320) {
      ref.read(rankingControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<RankingViewState> state = ref.watch(
      rankingControllerProvider,
    );
    final RankingController controller = ref.read(
      rankingControllerProvider.notifier,
    );
    // 目前選中的型別：優先取已載入狀態，否則用初始型別。
    final RankingType currentType =
        state.asData?.value.type ?? widget.initialType;

    return Scaffold(
      appBar: AppBar(title: const Text('排行榜')),
      body: Column(
        children: <Widget>[
          _typeChips(controller, currentType),
          _filterBar(state, controller, currentType),
          const Divider(height: 1, color: AppColors.line),
          Expanded(child: _list(state, controller)),
        ],
      ),
    );
  }

  Widget _typeChips(RankingController controller, RankingType current) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: AppSpacing.sm,
        ),
        itemCount: RankingType.tabs.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (BuildContext context, int i) {
          final RankingType t = RankingType.tabs[i];
          return AppChip(
            label: t.label,
            selected: t == current,
            onTap: () => controller.setType(t),
          );
        },
      ),
    );
  }

  Widget _filterBar(
    AsyncValue<RankingViewState> state,
    RankingController controller,
    RankingType type,
  ) {
    if (type.showsPeriod) {
      final RankingPeriod period =
          state.asData?.value.period ?? RankingPeriod.defaultValue;
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.sm,
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 200,
            child: AppSegmentedControl(
              segments: RankingPeriod.values
                  .map((RankingPeriod p) => p.label)
                  .toList(),
              selectedIndex: RankingPeriod.values.indexOf(period),
              onChanged: (int i) =>
                  controller.setPeriod(RankingPeriod.values[i]),
            ),
          ),
        ),
      );
    }
    if (type.showsNewBookSort) {
      final NewBookSort sort =
          state.asData?.value.sort ?? NewBookSort.defaultValue;
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          AppSpacing.sm,
        ),
        child: Row(
          children: <Widget>[
            for (final NewBookSort s in NewBookSort.values) ...<Widget>[
              AppChip(
                label: s.label,
                selected: s == sort,
                onTap: () => controller.setSort(s),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
          ],
        ),
      );
    }
    return const SizedBox(height: AppSpacing.xs);
  }

  Widget _list(
    AsyncValue<RankingViewState> state,
    RankingController controller,
  ) {
    return state.when(
      // F-29：骨架佔位（對齊榜單列形狀），取代置中轉圈。
      loading: () => const SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.screen),
        child: RankListSkeleton(count: 8),
      ),
      error: (Object e, StackTrace _) => BiliErrorView(
        message: twErrorMessage(ref.read(chineseConverterProvider), e),
        onRetry: controller.reload,
      ),
      data: (RankingViewState view) {
        if (view.items.isEmpty) {
          return const BiliEmptyView(
            message: '暫無榜單資料',
            icon: Icons.leaderboard_outlined,
          );
        }
        // F-24/F-15/F-30：尾端三態。
        final BiliListFooterState? footer = BiliListFooter.stateOf(
          loadingMore: view.loadingMore,
          loadMoreError: view.loadMoreError,
          hasMore: view.hasMore,
        );
        // F-14：下拉刷新（保留列表，不閃 loading）。
        return RefreshIndicator(
          color: AppColors.acc,
          backgroundColor: AppColors.surf,
          onRefresh: controller.refresh,
          child: ListView.builder(
            controller: _scroll,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            itemCount: view.items.length + (footer == null ? 0 : 1),
            itemBuilder: (BuildContext context, int i) {
              if (i >= view.items.length) {
                return BiliListFooter(
                  state: footer!,
                  onRetry: controller.retryLoadMore,
                );
              }
              return RankRow(rank: i + 1, novel: view.items[i]);
            },
          ),
        );
      },
    );
  }
}
