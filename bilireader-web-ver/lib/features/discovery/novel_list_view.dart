import 'package:flutter/material.dart';

import '../../core/discovery/paged_list_controller.dart';
import '../../core/models/novel_summary.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/list_states.dart';
import '../../widgets/network_cover.dart';
import '../novel/novel_detail_page.dart';

/// 書目卡片(對齊設計稿 .lbook):封面 + 評分 + 書名 + 作者 + 標籤 + 字數。
class NovelCard extends StatelessWidget {
  const NovelCard({super.key, required this.novel, this.showRank = false});

  final NovelSummary novel;
  final bool showRank;

  @override
  Widget build(BuildContext context) {
    final top3 = (novel.rank ?? 99) <= 3;
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => NovelDetailPage(id: novel.id)),
      ),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showRank)
              SizedBox(
                width: 22,
                child: Text('${novel.rank ?? ''}',
                    style: AppText.mono(
                        size: 16,
                        weight: FontWeight.w700,
                        color: top3 ? AppColors.acc : AppColors.mut)),
              ),
            NetworkCover(url: novel.coverUrl, width: 54, height: 76, radius: 10),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(novel.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.serif(size: 14, color: AppColors.txt)),
                  const SizedBox(height: 4),
                  Text(novel.author ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.sans(size: 10.5, color: AppColors.mut)),
                  const SizedBox(height: 6),
                  if (novel.intro != null && novel.intro!.isNotEmpty)
                    Text(novel.intro!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.sans(
                            size: 10.5, color: AppColors.mut, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 分頁書目清單：由 [PagedListController] 驅動——首屏骨架/空/錯誤態、
/// 尾端捲動載入更多（三態）、下拉刷新（保列表）。
///
/// 控制器生命週期由呼叫端（頁面）持有；本 widget 只負責渲染與觸發
/// [PagedListController.loadMore] / [PagedListController.refresh]。
class PagedNovelListView extends StatefulWidget {
  const PagedNovelListView({
    super.key,
    required this.controller,
    this.showRank = false,
    this.header,
    this.emptyMessage = '沒有符合的作品',
  });

  final PagedListController<NovelSummary> controller;
  final bool showRank;
  final Widget? header;
  final String emptyMessage;

  @override
  State<PagedNovelListView> createState() => _PagedNovelListViewState();
}

class _PagedNovelListViewState extends State<PagedNovelListView> {
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll.removeListener(_onScroll);
    _scroll.dispose();
    super.dispose();
  }

  /// 下拉刷新 + 失敗提示：刷新失敗但保留了舊清單時，snackbar 明示「顯示的是舊資料」，
  /// 不讓使用者誤以為刷新成功（修正舊版刷新失敗無任何回饋）。
  Future<void> _refresh() async {
    await widget.controller.refresh();
    if (!mounted) return;
    if (widget.controller.refreshFailed) {
      widget.controller.clearRefreshFailed();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('重新整理失敗，顯示的是舊資料')));
    }
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    // 尾端載入失敗時不因捲動自動重試（避免在底部抖動狂打）→ 需點 footer 明確重試。
    if (widget.controller.loadMoreError) return;
    final ScrollPosition p = _scroll.position;
    if (p.pixels >= p.maxScrollExtent - 400) {
      widget.controller.loadMore(); // 控制器自帶去重/進行中防護。
    }
  }

  /// 首頁若短到撐不滿視口（無法捲動）→ 捲動事件永遠不觸發 loadMore，會卡在
  /// hasMore=true 卻載不到下一頁。故 layout 後補一次檢查：不可捲動且還有更多就續抓。
  void _scheduleFillCheck() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      final PagedListController<NovelSummary> c = widget.controller;
      if (c.status == PageStatus.ready &&
          c.hasMore &&
          !c.loadingMore &&
          !c.loadMoreError &&
          _scroll.position.maxScrollExtent <= 0) {
        c.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final PagedListController<NovelSummary> c = widget.controller;
        switch (c.status) {
          // 刷新中（keepWhileLoading）仍有舊資料 → 續顯清單（F-14），冷啟才顯骨架。
          case PageStatus.loading:
            return c.items.isEmpty ? const ListSkeleton() : _list(c);
          // 刷新失敗但手上有舊資料 → 保留清單（可再下拉重試），只有全空才顯錯誤頁。
          case PageStatus.error:
            return c.items.isEmpty
                ? _refreshable(ListErrorView(onRetry: c.load))
                : _list(c);
          case PageStatus.empty:
            return _refreshable(
                ListEmptyView(icon: Icons.filter_alt_off_outlined,
                    message: widget.emptyMessage));
          case PageStatus.ready:
            _scheduleFillCheck();
            return _list(c);
        }
      },
    );
  }

  /// 讓空/錯誤態也能下拉刷新：撐滿視口的單格可捲動內容。
  Widget _refreshable(Widget child) {
    return RefreshIndicator(
      color: AppColors.acc,
      backgroundColor: AppColors.surf,
      onRefresh: _refresh,
      child: LayoutBuilder(
        builder: (context, constraints) => ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: constraints.maxHeight,
              child: Center(child: child),
            ),
          ],
        ),
      ),
    );
  }

  Widget _list(PagedListController<NovelSummary> c) {
    final List<NovelSummary> books = c.items;
    final bool hasHeader = widget.header != null;
    // items + header + 尾端 footer。
    final int count = books.length + (hasHeader ? 1 : 0) + 1;
    return RefreshIndicator(
      color: AppColors.acc,
      backgroundColor: AppColors.surf,
      onRefresh: _refresh,
      child: ListView.builder(
        controller: _scroll,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: count,
        itemBuilder: (context, i) {
          if (hasHeader && i == 0) return widget.header!;
          final int idx = i - (hasHeader ? 1 : 0);
          if (idx < books.length) {
            return NovelCard(novel: books[idx], showRank: widget.showRank);
          }
          // 尾端 footer。
          return ListFooter(
            loadingMore: c.loadingMore,
            error: c.loadMoreError,
            hasMore: c.hasMore,
            isEmpty: books.isEmpty,
            onRetry: c.retryLoadMore,
          );
        },
      ),
    );
  }
}
