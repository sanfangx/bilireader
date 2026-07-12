import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common_widgets/app_capsule_button.dart';
import '../../../core/common_widgets/bili_empty_view.dart';
import '../../../core/common_widgets/bili_error_view.dart';
import '../../../core/common_widgets/bili_list_footer.dart';
import '../../../core/common_widgets/bili_loading_view.dart';
import '../../../core/common_widgets/brand_header.dart';
import '../../../core/common_widgets/user_avatar.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/router/auth_controller.dart';
import '../../../core/social/reaction.dart';
import '../../../core/text/relative_time.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/text/tw_error.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../domain/circle_entities.dart';
import 'circle_controllers.dart';

/// 圈子分頁（規範 §2.2、設計稿「圈子 Quanzi」）。未登入顯示登入引導（社群 posts
/// 需登入，doc 09 §7）；已登入顯示分類 chips + 貼文列表，右上 ✎ 進入發文。
class CirclePage extends ConsumerWidget {
  const CirclePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthSnapshot auth = ref.watch(authControllerProvider);
    return Scaffold(
      key: const Key('page_circle'),
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: auth.isLoggedIn ? const _CircleFeedView() : const _LoginGuide(),
      ),
    );
  }
}

class _LoginGuide extends StatelessWidget {
  const _LoginGuide();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screen),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.forum_outlined, color: AppColors.mut, size: 48),
            const SizedBox(height: AppSpacing.md),
            const Text('尚未登入', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              '登入後即可瀏覽書友圈、發表貼文與互動。',
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCapsuleButton(
              label: '前往登入',
              shape: AppButtonShape.capsule,
              onPressed: () => context.pushNamed(AppRoutes.loginName),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleFeedView extends ConsumerStatefulWidget {
  const _CircleFeedView();

  @override
  ConsumerState<_CircleFeedView> createState() => _CircleFeedViewState();
}

class _CircleFeedViewState extends ConsumerState<_CircleFeedView> {
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
      ref.read(circleFeedControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final CircleTab tab = ref.watch(circleFeedFilterProvider);
    final AsyncValue<CircleFeedState> feed = ref.watch(
      circleFeedControllerProvider,
    );

    return RefreshIndicator(
      color: AppColors.acc,
      backgroundColor: AppColors.surf,
      // F-14 下拉刷新：走非閃爍的 refresh()（重抓第 1 頁但保留現有列表、保捲動），
      // 不 invalidate（會進 AsyncLoading → 整頁閃 loading；不變量#1）。
      onRefresh: () =>
          ref.read(circleFeedControllerProvider.notifier).refresh(),
      child: CustomScrollView(
        controller: _scroll,
        // F-14：即使空列表/內容不滿一屏也能下拉刷新（否則 maxScrollExtent==0，RefreshIndicator 無法觸發）。
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          const SliverToBoxAdapter(child: _CircleHeader()),
          SliverToBoxAdapter(child: _CategoryChips(tab: tab)),
          ..._body(feed),
        ],
      ),
    );
  }

  List<Widget> _body(AsyncValue<CircleFeedState> feed) {
    return <Widget>[
      feed.when(
        // F-14：刷新時保留現有列表（含刷新失敗），不回到整頁 loading/error（不變量#1）。
        skipLoadingOnReload: true,
        skipError: true,
        loading: () => const SliverToBoxAdapter(
          child: SizedBox(height: 260, child: BiliLoadingView(message: '載入圈子')),
        ),
        error: (Object e, StackTrace _) => SliverToBoxAdapter(
          child: SizedBox(
            height: 280,
            child: BiliErrorView(
              message: twErrorMessage(ref.read(chineseConverterProvider), e),
              onRetry: () => ref.invalidate(circleFeedControllerProvider),
            ),
          ),
        ),
        data: (CircleFeedState s) {
          if (s.posts.isEmpty) {
            return const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 60),
                child: BiliEmptyView(
                  icon: Icons.forum_outlined,
                  message: '這個分類還沒有貼文',
                  detail: '成為第一個發文的人吧。',
                ),
              ),
            );
          }
          final BiliListFooterState? footer = BiliListFooter.stateOf(
            loadingMore: s.loadingMore,
            loadMoreError: s.loadMoreError,
            hasMore: s.hasMore,
          );
          final int tail = footer == null ? 0 : 1;
          return SliverList.builder(
            itemCount: s.posts.length + tail,
            itemBuilder: (BuildContext context, int i) {
              if (i >= s.posts.length) {
                return BiliListFooter(
                  state: footer!,
                  onRetry: () => ref
                      .read(circleFeedControllerProvider.notifier)
                      .retryLoadMore(),
                );
              }
              return _PostCard(post: s.posts[i]);
            },
          );
        },
      ),
    ];
  }
}

/// `.htop`：品牌（圈子 / QUANZI · 書友圈）+ ✎ 發文入口。共用 [BrandHeader]（與書城一致）。
class _CircleHeader extends StatelessWidget {
  const _CircleHeader();

  @override
  Widget build(BuildContext context) {
    return BrandHeader(
      title: '圈子',
      subtitle: 'QUANZI · 書友圈',
      trailing: BrandIconButton(
        icon: Icons.edit_outlined,
        semanticLabel: '發表貼文',
        onTap: () => context.pushNamed(AppRoutes.circlePublishName),
      ),
    );
  }
}

/// `.chips`：「最新」+ 版塊（`circle/sections`）。
class _CategoryChips extends ConsumerWidget {
  const _CategoryChips({required this.tab});

  final CircleTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<CircleSection>> sections = ref.watch(
      circleSectionsProvider,
    );
    final List<CircleSection> list = sections.value ?? const <CircleSection>[];
    // 設計 `.chips` padding-bottom:10 —— 膠囊列與下方貼文之間留白，避免緊貼。
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 32,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(
            left: AppSpacing.screen,
            right: AppSpacing.screen,
          ),
          children: <Widget>[
            _Chip(
              label: '最新',
              selected: tab.sectionId == null,
              onTap: () =>
                  ref.read(circleFeedFilterProvider.notifier).selectLatest(),
            ),
            for (final CircleSection s in list) ...<Widget>[
              const SizedBox(width: 8),
              _Chip(
                label: s.sectionName,
                selected: tab.sectionId == s.sectionId,
                onTap: () => ref
                    .read(circleFeedFilterProvider.notifier)
                    .selectSection(s.sectionId),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
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
      color: selected ? AppColors.acc : AppColors.surf,
      borderRadius: AppRadius.pillAll,
      child: InkWell(
        borderRadius: AppRadius.pillAll,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            widthFactor: 1,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: selected ? AppColors.btxt : AppColors.mut,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `.post`：圈子貼文卡。點按進入貼文詳情。
class _PostCard extends StatelessWidget {
  const _PostCard({required this.post});

  final CirclePost post;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        AppRoutes.circlePostName,
        pathParameters: <String, String>{'topicId': '${post.topicId}'},
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          14,
          AppSpacing.screen,
          14,
        ),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                UserAvatar(url: post.avatarUrl),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        post.authorName.isEmpty ? '匿名' : post.authorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 12.5,
                          color: AppColors.txt,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _meta(post),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.mono.copyWith(
                          fontSize: 9.5,
                          color: AppColors.mut,
                        ),
                      ),
                    ],
                  ),
                ),
                if (post.sectionName != null && post.sectionName!.isNotEmpty)
                  _SectionTag(label: post.sectionName!),
              ],
            ),
            const SizedBox(height: 9),
            if (post.title.isNotEmpty) ...<Widget>[
              Text(
                post.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleMedium.copyWith(
                  fontFamily: AppTypography.fontSerif,
                  fontSize: 14.5,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 6),
            ],
            if (post.content.isNotEmpty)
              Text(
                post.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 12,
                  height: 1.6,
                ),
              ),
            if (post.imageUrls.isNotEmpty) ...<Widget>[
              const SizedBox(height: 10),
              _PostThumbs(urls: post.imageUrls),
            ],
            const SizedBox(height: 10),
            _PostFooter(post: post),
          ],
        ),
      ),
    );
  }

  String _meta(CirclePost p) {
    final String lv = (p.authorLevel ?? '').trim();
    final String time = relativeTimeFromSeconds(p.postTime);
    return <String>[
      if (lv.isNotEmpty) lv,
      if (time.isNotEmpty) time,
    ].join(' · ');
  }
}

/// `.post-sec`：版塊小標籤。
class _SectionTag extends StatelessWidget {
  const _SectionTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.accBorder),
        borderRadius: AppRadius.pillAll,
      ),
      child: Text(
        label,
        style: AppTypography.bodySmall.copyWith(
          fontSize: 9,
          color: AppColors.acc,
        ),
      ),
    );
  }
}

/// `.post-imgs`：最多 3 張 62×62 縮圖。
class _PostThumbs extends StatelessWidget {
  const _PostThumbs({required this.urls});

  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    final List<String> shown = urls.take(3).toList();
    return Row(
      children: <Widget>[
        for (int i = 0; i < shown.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(width: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: UserAvatar(url: shown[i], size: 62),
          ),
        ],
      ],
    );
  }
}

/// `.post-ft`：▲讚 ▽倒讚 💬回覆 + 瀏覽數。
class _PostFooter extends StatelessWidget {
  const _PostFooter({required this.post});

  final CirclePost post;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _Stat(
          glyph: '▲',
          value: post.likeNum,
          on: post.myReaction == Reaction.like,
        ),
        const SizedBox(width: 18),
        _Stat(
          glyph: '▽',
          value: post.badNum,
          on: post.myReaction == Reaction.bad,
        ),
        const SizedBox(width: 18),
        _Stat(glyph: '💬', value: post.replies),
        const Spacer(),
        Text(
          '${post.views} 瀏覽',
          style: AppTypography.mono.copyWith(
            fontSize: 9.5,
            color: AppColors.mut,
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.glyph, required this.value, this.on = false});

  final String glyph;
  final int value;
  final bool on;

  @override
  Widget build(BuildContext context) {
    final Color color = on ? AppColors.acc : AppColors.mut;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(glyph, style: TextStyle(fontSize: 11, color: color)),
        if (value > 0) ...<Widget>[
          const SizedBox(width: 5),
          Text(
            '$value',
            style: AppTypography.mono.copyWith(fontSize: 11, color: color),
          ),
        ],
      ],
    );
  }
}
