import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common_widgets/app_bottom_sheet.dart';
import '../../../core/common_widgets/app_segmented_control.dart';
import '../../../core/common_widgets/bili_empty_view.dart';
import '../../../core/common_widgets/bili_error_view.dart';
import '../../../core/common_widgets/bili_list_footer.dart';
import '../../../core/common_widgets/bili_loading_view.dart';
import '../../../core/common_widgets/user_avatar.dart';
import '../../../core/network/api_result.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/text/relative_time.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/text/tw_error.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../discover/domain/novel_summary.dart';
import '../../discover/presentation/novel_detail_providers.dart';
import '../domain/review_entities.dart';
import '../domain/review_options.dart';
import 'review_controllers.dart';

/// 書評列表頁（設計稿「書評列表 Reviews」）。每本書的全部書評 + 排序 + 寫書評 FAB。
/// 書評無每則評分欄位，故不顯示星等（§No Mock Data）；精華以標記呈現。
class BookReviewListPage extends ConsumerStatefulWidget {
  const BookReviewListPage({required this.articleId, super.key});

  final int articleId;

  @override
  ConsumerState<BookReviewListPage> createState() => _BookReviewListPageState();
}

class _BookReviewListPageState extends ConsumerState<BookReviewListPage> {
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
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 320) {
      ref
          .read(reviewListControllerProvider(widget.articleId).notifier)
          .loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final BookReviewSort sort = ref.watch(reviewSortProvider);
    final AsyncValue<ReviewListState> list = ref.watch(
      reviewListControllerProvider(widget.articleId),
    );
    final NovelSummary? novel = ref
        .watch(novelDetailProvider(widget.articleId))
        .value;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('書友評論')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.acc,
        foregroundColor: AppColors.btxt,
        onPressed: () => _openComposer(context),
        icon: const Icon(Icons.edit_outlined, size: 18),
        label: Text(
          '寫書評',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.btxt,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      // F-14：下拉刷新（保留列表，不閃 loading）。
      body: RefreshIndicator(
        color: AppColors.acc,
        backgroundColor: AppColors.surf,
        onRefresh: () => ref
            .read(reviewListControllerProvider(widget.articleId).notifier)
            .refresh(),
        child: CustomScrollView(
          controller: _scroll,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
            if (novel != null)
              SliverToBoxAdapter(child: _Subtitle(novel: novel)),
            SliverToBoxAdapter(
              child: _SortBar(sort: sort, count: list.value?.total),
            ),
            ..._body(list),
            const SliverToBoxAdapter(child: SizedBox(height: 84)),
          ],
        ),
      ),
    );
  }

  List<Widget> _body(AsyncValue<ReviewListState> list) {
    return <Widget>[
      list.when(
        loading: () => const SliverToBoxAdapter(
          child: SizedBox(height: 240, child: BiliLoadingView(message: '載入書評')),
        ),
        error: (Object e, StackTrace _) => SliverToBoxAdapter(
          child: SizedBox(
            height: 260,
            child: BiliErrorView(
              message: twErrorMessage(ref.read(chineseConverterProvider), e),
              onRetry: () => ref.invalidate(
                reviewListControllerProvider(widget.articleId),
              ),
            ),
          ),
        ),
        data: (ReviewListState s) {
          if (s.reviews.isEmpty) {
            return const SliverToBoxAdapter(
              child: SizedBox(
                height: 260,
                child: BiliEmptyView(
                  message: '還沒有書評',
                  icon: Icons.rate_review_outlined,
                  detail: '成為第一個評論這本書的人。',
                ),
              ),
            );
          }
          // F-24/F-15/F-30：尾端三態。
          final BiliListFooterState? footer = BiliListFooter.stateOf(
            loadingMore: s.loadingMore,
            loadMoreError: s.loadMoreError,
            hasMore: s.hasMore,
          );
          return SliverList.builder(
            itemCount: s.reviews.length + (footer == null ? 0 : 1),
            itemBuilder: (BuildContext context, int i) {
              if (i >= s.reviews.length) {
                return BiliListFooter(
                  state: footer!,
                  onRetry: () => ref
                      .read(
                        reviewListControllerProvider(widget.articleId).notifier,
                      )
                      .retryLoadMore(),
                );
              }
              return _ReviewCard(
                review: s.reviews[i],
                articleId: widget.articleId,
              );
            },
          );
        },
      ),
    ];
  }

  Future<void> _openComposer(BuildContext context) async {
    final bool? posted = await showAppBottomSheet<bool>(
      context: context,
      title: '寫書評',
      child: _ReviewComposer(articleId: widget.articleId),
    );
    if (posted ?? false) {
      ref.invalidate(reviewListControllerProvider(widget.articleId));
    }
  }
}

/// `.rvl-sub`：書名 · 作者 著。
class _Subtitle extends StatelessWidget {
  const _Subtitle({required this.novel});

  final NovelSummary novel;

  @override
  Widget build(BuildContext context) {
    final String author = (novel.author ?? '').trim();
    final String text = author.isEmpty
        ? novel.title
        : '${novel.title} · $author 著';
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        12,
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.bodySmall.copyWith(fontSize: 11),
      ),
    );
  }
}

/// `.rvl-bar`：排序 seg（最新 / 最熱）+ 書評數。
class _SortBar extends ConsumerWidget {
  const _SortBar({required this.sort, required this.count});

  final BookReviewSort sort;
  final int? count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        12,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            width: 150,
            child: AppSegmentedControl(
              segments: <String>[
                for (final BookReviewSort s in BookReviewSort.values) s.label,
              ],
              selectedIndex: BookReviewSort.values.indexOf(sort),
              onChanged: (int i) => ref
                  .read(reviewSortProvider.notifier)
                  .select(BookReviewSort.values[i]),
            ),
          ),
          if (count != null)
            Text(
              '$count 條',
              style: AppTypography.mono.copyWith(
                fontSize: 11,
                color: AppColors.mut,
              ),
            ),
        ],
      ),
    );
  }
}

/// `.rvl-card`：書評卡（無星等）。點按進入書評詳情。
class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review, required this.articleId});

  final BookReview review;
  final int articleId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        AppRoutes.bookReviewName,
        pathParameters: <String, String>{'topicId': '${review.topicId}'},
        // F-07：帶上來源書 articleId，返回列表時可單筆同步讚/回覆數。
        queryParameters: <String, String>{'articleId': '$articleId'},
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: 14,
        ),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.line)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                UserAvatar(url: review.avatarUrl),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    review.authorName.isEmpty ? '匿名' : review.authorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 12,
                      color: AppColors.txt,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (review.isGood) const _GoodBadge(),
              ],
            ),
            const SizedBox(height: 9),
            Text(
              review.content,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.readerBody.copyWith(
                fontSize: 12,
                height: 1.68,
              ),
            ),
            const SizedBox(height: 9),
            Row(
              children: <Widget>[
                Text(
                  '▲ ${review.likeNum}',
                  style: AppTypography.mono.copyWith(
                    fontSize: 10,
                    color: AppColors.acc,
                  ),
                ),
                _dot(),
                Text(
                  '回覆 ${review.replies}',
                  style: AppTypography.mono.copyWith(
                    fontSize: 10,
                    color: AppColors.mut,
                  ),
                ),
                if (relativeTimeFromSeconds(review.posttime).isNotEmpty) ...[
                  _dot(),
                  Text(
                    relativeTimeFromSeconds(review.posttime),
                    style: AppTypography.mono.copyWith(
                      fontSize: 10,
                      color: AppColors.mut,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dot() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Text(
      '·',
      style: AppTypography.mono.copyWith(fontSize: 10, color: AppColors.mut),
    ),
  );
}

class _GoodBadge extends StatelessWidget {
  const _GoodBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.accBorder),
        borderRadius: AppRadius.pillAll,
      ),
      child: Text(
        '精華',
        style: AppTypography.bodySmall.copyWith(
          fontSize: 9,
          color: AppColors.acc,
        ),
      ),
    );
  }
}

/// 寫書評 composer（`book_review/add`）。含劇透標記。§7.0 僅使用者觸發。
class _ReviewComposer extends ConsumerStatefulWidget {
  const _ReviewComposer({required this.articleId});

  final int articleId;

  @override
  ConsumerState<_ReviewComposer> createState() => _ReviewComposerState();
}

class _ReviewComposerState extends ConsumerState<_ReviewComposer> {
  final TextEditingController _content = TextEditingController();
  bool _spoiler = false;
  bool _posting = false;

  @override
  void dispose() {
    _content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: TextField(
            controller: _content,
            maxLines: 5,
            minLines: 3,
            enabled: !_posting,
            style: AppTypography.bodyMedium.copyWith(
              fontSize: 13,
              color: AppColors.txt,
            ),
            decoration: const InputDecoration.collapsed(
              hintText: '分享你對這本書的看法…',
              hintStyle: AppTypography.bodySmall,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Switch(
              value: _spoiler,
              activeThumbColor: AppColors.acc,
              onChanged: _posting
                  ? null
                  : (bool v) => setState(() => _spoiler = v),
            ),
            const SizedBox(width: 4),
            const Text('含劇透', style: AppTypography.bodySmall),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 46,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.acc,
              foregroundColor: AppColors.btxt,
              disabledBackgroundColor: AppColors.cov,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
            ),
            onPressed: _posting ? null : _post,
            child: _posting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.btxt,
                    ),
                  )
                : Text(
                    '發表書評',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.btxt,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _post() async {
    final String content = _content.text.trim();
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    if (content.isEmpty) {
      messenger.showSnackBar(const SnackBar(content: Text('書評內容不可為空')));
      return;
    }
    setState(() => _posting = true);
    final ApiResult<int> result = await ref
        .read(reviewActionsProvider.notifier)
        .add(
          articleId: widget.articleId,
          content: content,
          isSpoiler: _spoiler,
        );
    if (!mounted) {
      return;
    }
    final NavigatorState navigator = Navigator.of(context);
    switch (result) {
      case ApiSuccess<int>():
        messenger.showSnackBar(const SnackBar(content: Text('已發表書評')));
        navigator.pop(true);
      case ApiFailure<int>(:final error):
        setState(() => _posting = false);
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              twErrorMessage(ref.read(chineseConverterProvider), error),
            ),
          ),
        );
    }
  }
}
