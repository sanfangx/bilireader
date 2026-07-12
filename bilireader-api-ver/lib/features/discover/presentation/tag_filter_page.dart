import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widgets/app_chip.dart';
import '../../../core/common_widgets/bili_empty_view.dart';
import '../../../core/common_widgets/bili_error_view.dart';
import '../../../core/common_widgets/bili_list_footer.dart';
import '../../../core/common_widgets/bili_loading_view.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/text/tw_error.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../domain/ranking_options.dart';
import 'tag_controllers.dart';
import 'widgets/novel_list_tile.dart';

/// 文庫·篩選頁（doc 09 §10.3、design「文庫·篩選」）。題材多選 `.fo` + 狀態/字數 +
/// 排序 `.sortc` + 結果 `.lbook`。標題以繁體顯示，繁體無結果由 repository 自動簡體
/// fallback（規範 §5.0）。路由帶入的 tag 作為初始選中題材。
class TagFilterPage extends ConsumerStatefulWidget {
  const TagFilterPage({required this.tag, super.key});

  final String tag;

  @override
  ConsumerState<TagFilterPage> createState() => _TagFilterPageState();
}

class _TagFilterPageState extends ConsumerState<TagFilterPage> {
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(filterControllerProvider.notifier).configure(widget.tag);
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
      ref.read(filterControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<FilterViewState> state = ref.watch(
      filterControllerProvider,
    );
    final FilterController controller = ref.read(
      filterControllerProvider.notifier,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('文庫 · 篩選')),
      body: state.when(
        loading: () => Column(
          children: <Widget>[
            _FilterPanel(view: _empty, controller: controller),
            const Expanded(child: BiliLoadingView()),
          ],
        ),
        error: (Object e, StackTrace _) => Column(
          children: <Widget>[
            _FilterPanel(view: _empty, controller: controller),
            Expanded(
              child: BiliErrorView(
                message: twErrorMessage(ref.read(chineseConverterProvider), e),
                onRetry: controller.reload,
              ),
            ),
          ],
        ),
        data: (FilterViewState view) {
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
            child: CustomScrollView(
              controller: _scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: _FilterPanel(view: view, controller: controller),
                ),
                if (view.items.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: BiliEmptyView(
                      message: '沒有符合條件的作品',
                      icon: Icons.filter_alt_off_outlined,
                      detail: '調整題材或篩選條件試試',
                    ),
                  )
                else
                  SliverList.separated(
                    itemCount: view.items.length + (footer == null ? 0 : 1),
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, color: AppColors.line),
                    itemBuilder: (BuildContext context, int i) {
                      if (i >= view.items.length) {
                        return BiliListFooter(
                          state: footer!,
                          onRetry: controller.retryLoadMore,
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screen,
                        ),
                        child: NovelListTile(novel: view.items[i]),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  static const FilterViewState _empty = FilterViewState();
}

/// 篩選面板：題材多選 + 狀態/字數 + 排序（設計稿 `.fgrp`/`.fopts`/`.sortrow`）。
class _FilterPanel extends ConsumerWidget {
  const _FilterPanel({required this.view, required this.controller});

  final FilterViewState view;
  final FilterController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<String>> tags = ref.watch(filterTagsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: AppSpacing.sm),
        _groupLabel('題材 TAGS'),
        tags.maybeWhen(
          data: (List<String> all) => _wrap(<Widget>[
            for (final String t in all.take(24))
              _FilterOption(
                label: t,
                selected: view.selectedTags.contains(t),
                onTap: () => controller.toggleTag(t),
              ),
          ]),
          orElse: () => const SizedBox(height: 28),
        ),
        const SizedBox(height: AppSpacing.md),
        _groupLabel('狀態 / 字數'),
        _wrap(<Widget>[
          _FilterOption(
            label: '僅完結',
            selected: view.fullFlagOnly,
            onTap: () => controller.setFullFlagOnly(!view.fullFlagOnly),
          ),
          for (final WordFilter w in WordFilter.values.where(
            (WordFilter e) => e != WordFilter.any,
          ))
            _FilterOption(
              label: w.label,
              selected: view.wordFilter == w,
              onTap: () => controller.setWordFilter(
                view.wordFilter == w ? WordFilter.any : w,
              ),
            ),
        ]),
        const SizedBox(height: AppSpacing.md),
        // 排序（設計稿 .sortrow / .sortc 膠囊，即共用 AppChip）。
        SizedBox(
          height: 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            itemCount: NovelSortBy.values.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (BuildContext context, int i) {
              final NovelSortBy s = NovelSortBy.values[i];
              return AppChip(
                label: s.label,
                selected: s == view.sortBy,
                onTap: () => controller.setSort(s),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const Divider(height: 1, color: AppColors.line),
      ],
    );
  }

  Widget _groupLabel(String text) => Padding(
    padding: const EdgeInsets.fromLTRB(
      AppSpacing.screen,
      0,
      AppSpacing.screen,
      9,
    ),
    child: Text(
      text,
      style: AppTypography.mono.copyWith(
        color: AppColors.mut,
        fontSize: 9,
        letterSpacing: 1,
      ),
    ),
  );

  Widget _wrap(List<Widget> children) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
    child: Wrap(spacing: 7, runSpacing: 7, children: children),
  );
}

/// 方角多選膠囊（設計稿 `.fo`：radius 8、surf 底；`.fo.on` 金字/描邊/cov 底）。
class _FilterOption extends StatelessWidget {
  const _FilterOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.cov : AppColors.surf,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: selected ? AppColors.accBorderStrong : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xs),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: selected ? AppColors.acc : AppColors.mut,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}
