import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import 'search_controllers.dart';
import 'widgets/novel_list_tile.dart';

/// 搜尋頁（doc 09 §10.1）。搜尋前顯示熱門詞 + 本機歷史；送出後顯示分頁結果。
/// 繁體 query 無結果會由 repository 自動以 OpenCC 轉簡 fallback 一次（規範 §5.0）；
/// 使用者不會看到簡體 query。UI 文案全繁中。
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    _input.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 320) {
      ref.read(searchResultsControllerProvider.notifier).loadMore();
    }
  }

  void _submit(String query) {
    if (query.trim().isEmpty) {
      return;
    }
    _input.text = query;
    FocusScope.of(context).unfocus();
    ref.read(searchResultsControllerProvider.notifier).submit(query);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<SearchViewState>? results = ref.watch(
      searchResultsControllerProvider,
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _header(context),
            Expanded(
              child: results == null
                  ? _PreSearchView(onPick: _submit)
                  : _ResultsView(
                      state: results,
                      scroll: _scroll,
                      onRetry: () => _submit(_input.text),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// 設計稿 `.srh`：膠囊搜尋框 `.srbox`（surf/42/radius14）+ 文字鈕「取消」。
  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        6,
        AppSpacing.screen,
        16,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 42,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.surf,
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.search, color: AppColors.mut, size: 18),
                  const SizedBox(width: 9),
                  Expanded(
                    child: TextField(
                      key: const Key('search_input'),
                      controller: _input,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onSubmitted: _submit,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.txt,
                      ),
                      cursorColor: AppColors.acc,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        hintText: '搜尋書名、作者、標籤',
                        hintStyle: AppTypography.bodySmall.copyWith(
                          color: AppColors.mut,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).unfocus();
              if (context.canPop()) {
                context.pop();
              }
            },
            child: Text(
              '取消',
              style: AppTypography.bodySmall.copyWith(color: AppColors.acc),
            ),
          ),
        ],
      ),
    );
  }
}

/// 搜尋前：熱門搜尋 + 本機歷史。
class _PreSearchView extends ConsumerWidget {
  const _PreSearchView({required this.onPick});

  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<String>> hot = ref.watch(hotSearchKeywordsProvider);
    final List<String> history = ref.watch(searchHistoryProvider);
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
      children: <Widget>[
        const _BlockTitle('熱門搜尋'),
        const SizedBox(height: AppSpacing.md),
        hot.when(
          loading: () => const SizedBox(height: 40, child: BiliLoadingView()),
          error: (Object e, StackTrace _) => Text(
            twErrorMessage(ref.read(chineseConverterProvider), e),
            style: AppTypography.bodySmall.copyWith(color: AppColors.mut),
          ),
          data: (List<String> words) => words.isEmpty
              ? Text(
                  '暫無熱門關鍵字',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.mut),
                )
              // 設計稿 .htag：txt 色膠囊；前兩名 .fire 以金色強調。
              : Wrap(
                  spacing: 9,
                  runSpacing: 9,
                  children: <Widget>[
                    for (final (int i, String w) in words.indexed)
                      _HotTag(label: w, fire: i < 2, onTap: () => onPick(w)),
                  ],
                ),
        ),
        if (history.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.xl),
          _BlockTitle(
            '搜尋歷史',
            trailing: GestureDetector(
              key: const Key('search_clear_history'),
              onTap: () => ref.read(searchHistoryProvider.notifier).clear(),
              child: Text(
                '清除',
                style: AppTypography.bodySmall.copyWith(color: AppColors.mut),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              for (final String h in history)
                _HistoryChip(
                  label: h,
                  onTap: () => onPick(h),
                  onRemove: () =>
                      ref.read(searchHistoryProvider.notifier).remove(h),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _HistoryChip extends StatelessWidget {
  const _HistoryChip({
    required this.label,
    required this.onTap,
    required this.onRemove,
  });

  final String label;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surf,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(left: 14, right: 8, top: 6, bottom: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                label,
                style: AppTypography.bodySmall.copyWith(color: AppColors.mut),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onRemove,
                child: const Icon(Icons.close, size: 15, color: AppColors.mut),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 區塊標題（設計稿 `.sblk h5`：txt 色、粗體 12，右側可放次要動作）。
class _BlockTitle extends StatelessWidget {
  const _BlockTitle(this.title, {this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.txt,
            fontWeight: FontWeight.w600,
          ),
        ),
        ?trailing,
      ],
    );
  }
}

/// 熱門搜尋膠囊（設計稿 `.htag`：surf 底、txt 色；`.fire` 前兩名金色）。
class _HotTag extends StatelessWidget {
  const _HotTag({required this.label, required this.fire, required this.onTap});

  final String label;
  final bool fire;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surf,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.pill),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: fire ? AppColors.acc : AppColors.txt,
            ),
          ),
        ),
      ),
    );
  }
}

/// 結果態：loading / error / empty / content（含 load-more 三態 + 下拉刷新）。
class _ResultsView extends ConsumerWidget {
  const _ResultsView({
    required this.state,
    required this.scroll,
    required this.onRetry,
  });

  final AsyncValue<SearchViewState> state;
  final ScrollController scroll;

  /// 錯誤態 / 空態的重試（重新送出當前 query）。
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return state.when(
      loading: () => const BiliLoadingView(message: '搜尋中'),
      error: (Object e, StackTrace _) => BiliErrorView(
        message: twErrorMessage(ref.read(chineseConverterProvider), e),
        onRetry: onRetry,
      ),
      data: (SearchViewState view) {
        if (view.items.isEmpty) {
          // F-24：統一空狀態元件（icon + 標題 + 動作）。
          return BiliEmptyView(
            message: '找不到相關作品',
            icon: Icons.search_off,
            detail: '換個關鍵字或標籤試試',
            actionLabel: '重新搜尋',
            onAction: onRetry,
          );
        }
        // F-24/F-15/F-30：列表尾端三態（載入中 / 失敗+重試 / 已無更多）。
        final BiliListFooterState? footer = BiliListFooter.stateOf(
          loadingMore: view.loadingMore,
          loadMoreError: view.loadMoreError,
          hasMore: view.hasMore,
        );
        // F-14：下拉刷新（重抓當前 query 第一頁）。
        return RefreshIndicator(
          color: AppColors.acc,
          backgroundColor: AppColors.surf,
          onRefresh: () =>
              ref.read(searchResultsControllerProvider.notifier).refresh(),
          child: ListView.separated(
            controller: scroll,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            itemCount: view.items.length + (footer == null ? 0 : 1),
            separatorBuilder: (BuildContext context, int i) =>
                i >= view.items.length - 1
                ? const SizedBox.shrink()
                : const Divider(height: 1, color: AppColors.line),
            itemBuilder: (BuildContext context, int i) {
              if (i >= view.items.length) {
                return BiliListFooter(
                  state: footer!,
                  onRetry: () => ref
                      .read(searchResultsControllerProvider.notifier)
                      .retryLoadMore(),
                );
              }
              return NovelListTile(novel: view.items[i]);
            },
          ),
        );
      },
    );
  }
}
