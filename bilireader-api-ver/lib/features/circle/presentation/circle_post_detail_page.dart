import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widgets/bili_error_view.dart';
import '../../../core/common_widgets/bili_list_footer.dart';
import '../../../core/common_widgets/bili_loading_view.dart';
import '../../../core/common_widgets/reaction_pill.dart';
import '../../../core/common_widgets/user_avatar.dart';
import '../../../core/network/api_result.dart';
import '../../../core/social/reaction.dart';
import '../../../core/text/relative_time.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/text/tw_error.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../data/circle_providers.dart';
import '../domain/circle_entities.dart';
import 'circle_controllers.dart';

/// 貼文詳情頁（設計稿「貼文詳情 Post」）。貼文本體 + 回覆列表 + 底部回覆輸入列。
/// 讚/倒讚與回覆為狀態變更端點（§7.0），僅由使用者操作。回覆走 Multipart🔒（BNUP2）。
class CirclePostDetailPage extends ConsumerWidget {
  const CirclePostDetailPage({required this.topicId, super.key});

  final int topicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<CirclePost> post = ref.watch(
      circlePostDetailProvider(topicId),
    );
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('貼文')),
      // F-14：下拉刷新期間/失敗保留已載貼文（skipLoadingOnReload + skipError → 不閃）。
      body: post.when(
        skipLoadingOnReload: true,
        skipError: true,
        loading: () => const BiliLoadingView(message: '載入貼文'),
        error: (Object e, StackTrace _) => BiliErrorView(
          message: twErrorMessage(ref.read(chineseConverterProvider), e),
          onRetry: () => ref.invalidate(circlePostDetailProvider(topicId)),
        ),
        data: (CirclePost p) => Column(
          children: <Widget>[
            Expanded(child: _Body(post: p)),
            _ReplyBar(topicId: topicId, toName: p.authorName),
          ],
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.post});

  final CirclePost post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<CircleRepliesState> replies = ref.watch(
      circleRepliesControllerProvider(post.topicId),
    );
    // F-14：下拉刷新貼文詳情 + 回覆列表（保留現有內容，不閃 loading）。
    return RefreshIndicator(
      color: AppColors.acc,
      backgroundColor: AppColors.surf,
      onRefresh: () async {
        ref.invalidate(circlePostDetailProvider(post.topicId));
        await ref
            .read(circleRepliesControllerProvider(post.topicId).notifier)
            .refresh();
        await ref.read(circlePostDetailProvider(post.topicId).future);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: <Widget>[
          _PostContent(post: post),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              12,
              AppSpacing.screen,
              4,
            ),
            child: Text(
              '全部回覆 · ${post.replies}',
              style: AppTypography.bodySmall.copyWith(
                fontSize: 12,
                color: AppColors.txt,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          replies.when(
            // 刷新/回覆後重抓時保留已載回覆，不閃 spinner（不變量#1）。
            skipLoadingOnReload: true,
            skipError: true,
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 28),
              child: Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.acc,
                  ),
                ),
              ),
            ),
            error: (Object e, StackTrace _) => Padding(
              padding: const EdgeInsets.all(AppSpacing.screen),
              child: Text(
                twErrorMessage(ref.read(chineseConverterProvider), e),
                style: AppTypography.bodySmall,
              ),
            ),
            data: (CircleRepliesState s) => Column(
              children: <Widget>[
                if (s.replies.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Text('還沒有回覆，來搶頭香', style: AppTypography.bodySmall),
                  )
                else
                  for (final CircleReply r in s.replies) _ReplyRow(reply: r),
                // F-15/F-24/F-30：載入更多四態——載入中 spinner / 失敗+重試 /
                // 尚有更多則「查看更多」按鈕 / 已載完且有回覆則「已無更多」。
                if (s.loadingMore)
                  const BiliListFooter(state: BiliListFooterState.loading)
                else if (s.loadMoreError)
                  BiliListFooter(
                    state: BiliListFooterState.error,
                    onRetry: () => ref
                        .read(
                          circleRepliesControllerProvider(
                            post.topicId,
                          ).notifier,
                        )
                        .retryLoadMore(),
                  )
                else if (s.hasMore)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: TextButton(
                      onPressed: () => ref
                          .read(
                            circleRepliesControllerProvider(
                              post.topicId,
                            ).notifier,
                          )
                          .loadMore(),
                      child: const Text(
                        '查看更多回覆',
                        style: TextStyle(color: AppColors.acc),
                      ),
                    ),
                  )
                else if (s.replies.isNotEmpty)
                  const BiliListFooter(state: BiliListFooterState.end),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// `.pd-post`：貼文本體 + 讚/倒讚 pill。
class _PostContent extends ConsumerWidget {
  const _PostContent({required this.post});

  final CirclePost post;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        4,
        AppSpacing.screen,
        14,
      ),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              UserAvatar(url: post.avatarUrl),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      post.authorName.isEmpty ? '匿名' : post.authorName,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _meta(post),
                      style: AppTypography.mono.copyWith(
                        fontSize: 9.5,
                        color: AppColors.mut,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (post.title.isNotEmpty) ...<Widget>[
            Text(
              post.title,
              style: AppTypography.headline.copyWith(fontSize: 17, height: 1.3),
            ),
            const SizedBox(height: 8),
          ],
          if (post.content.isNotEmpty)
            Text(
              post.content,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 12.5,
                height: 1.72,
                color: AppColors.rtxt,
              ),
            ),
          if (post.imageUrls.isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            _DetailImages(urls: post.imageUrls),
          ],
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              ReactionPill(
                icon: Icons.thumb_up_alt_outlined,
                label: post.likeNum > 0 ? '${post.likeNum}' : '讚',
                semanticLabel: '讚',
                selected: post.myReaction == Reaction.like,
                onTap: () => _react(ref, Reaction.like),
              ),
              const SizedBox(width: 10),
              ReactionPill(
                icon: Icons.thumb_down_alt_outlined,
                label: post.badNum > 0 ? '${post.badNum}' : '',
                semanticLabel: '倒讚',
                selected: post.myReaction == Reaction.bad,
                onTap: () => _react(ref, Reaction.bad),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _react(WidgetRef ref, Reaction target) async {
    final int type = target.toggledRequestValue(post.myReaction);
    final ApiResult<ReactionCounts> result = await ref
        .read(circleRepositoryProvider)
        .like(topicId: post.topicId, type: type);
    if (result is ApiSuccess<ReactionCounts>) {
      ref.invalidate(circlePostDetailProvider(post.topicId));
      // F-05：動態列表同步（單筆 upsert，不整列重抓 → 返回 feed 保捲動/分頁，不變量#1）。
      ref
          .read(circleFeedControllerProvider.notifier)
          .applyReaction(post.topicId, result.data);
    }
  }

  String _meta(CirclePost p) {
    final String lv = (p.authorLevel ?? '').trim();
    final String sec = (p.sectionName ?? '').trim();
    final String time = relativeTimeFromSeconds(p.postTime);
    return <String>[
      if (lv.isNotEmpty) lv,
      if (sec.isNotEmpty) sec,
      if (time.isNotEmpty) time,
    ].join(' · ');
  }
}

class _DetailImages extends StatelessWidget {
  const _DetailImages({required this.urls});

  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: <Widget>[
        for (final String u in urls)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: UserAvatar(url: u, size: 78),
          ),
      ],
    );
  }
}

/// `.ccrow`：回覆列。
class _ReplyRow extends ConsumerWidget {
  const _ReplyRow({required this.reply});

  final CircleReply reply;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screen,
        vertical: 13,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UserAvatar(url: reply.avatarUrl, size: 32),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      reply.posterName.isEmpty ? '匿名' : reply.posterName,
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 12,
                        color: AppColors.txt,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if ((reply.posterLevel ?? '').isNotEmpty) ...<Widget>[
                      const SizedBox(width: 7),
                      _LevelTag(label: reply.posterLevel!),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  reply.posttext,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 12,
                    height: 1.62,
                    color: AppColors.rtxt,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    _MiniStat(
                      glyph: '▲',
                      value: reply.likeNum,
                      on: reply.myReaction == Reaction.like,
                      onTap: () => _reactReply(ref, Reaction.like),
                    ),
                    const SizedBox(width: 16),
                    _MiniStat(
                      glyph: '▽',
                      value: reply.badNum,
                      on: reply.myReaction == Reaction.bad,
                      onTap: () => _reactReply(ref, Reaction.bad),
                    ),
                    const Spacer(),
                    Text(
                      relativeTimeFromSeconds(reply.posttime),
                      style: AppTypography.mono.copyWith(
                        fontSize: 9.5,
                        color: AppColors.mut,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _reactReply(WidgetRef ref, Reaction target) async {
    final int type = target.toggledRequestValue(reply.myReaction);
    await ref
        .read(circleRepositoryProvider)
        .replyLike(postId: reply.postId, type: type);
    // 回覆列表以 topicid 分頁載入；簡化起見不做本地樂觀更新（下拉/重進刷新）。
  }
}

class _LevelTag extends StatelessWidget {
  const _LevelTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.accBorder),
        borderRadius: BorderRadius.circular(AppRadius.badgeSm),
      ),
      child: Text(
        label,
        style: AppTypography.mono.copyWith(fontSize: 8, color: AppColors.acc),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.glyph,
    required this.value,
    required this.on,
    required this.onTap,
  });

  final String glyph;
  final int value;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = on ? AppColors.acc : AppColors.mut;
    return InkWell(
      onTap: onTap,
      child: Row(
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
      ),
    );
  }
}

/// `.ccinput`：底部回覆輸入列。
class _ReplyBar extends ConsumerStatefulWidget {
  const _ReplyBar({required this.topicId, required this.toName});

  final int topicId;
  final String toName;

  @override
  ConsumerState<_ReplyBar> createState() => _ReplyBarState();
}

class _ReplyBarState extends ConsumerState<_ReplyBar> {
  final TextEditingController _controller = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
        decoration: const BoxDecoration(
          color: AppColors.bg,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: AppColors.surf,
                  borderRadius: AppRadius.pillAll,
                ),
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: _controller,
                  enabled: !_sending,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.txt),
                  decoration: InputDecoration.collapsed(
                    hintText: '回覆 ${widget.toName}…',
                    hintStyle: AppTypography.bodySmall,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _sending
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.acc,
                    ),
                  )
                : TextButton(
                    onPressed: _send,
                    child: const Text(
                      '送出',
                      style: TextStyle(
                        color: AppColors.acc,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _send() async {
    final String text = _controller.text.trim();
    if (text.isEmpty) {
      return;
    }
    setState(() => _sending = true);
    final ApiResult<CircleReply> result = await ref
        .read(circleActionsProvider.notifier)
        .reply(topicId: widget.topicId, posttext: text);
    if (!mounted) {
      return;
    }
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    switch (result) {
      case ApiSuccess<CircleReply>():
        _controller.clear();
        ref
          ..invalidate(circleRepliesControllerProvider(widget.topicId))
          ..invalidate(circlePostDetailProvider(widget.topicId));
        messenger.showSnackBar(const SnackBar(content: Text('已回覆')));
      case ApiFailure<CircleReply>(:final error):
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              twErrorMessage(ref.read(chineseConverterProvider), error),
            ),
          ),
        );
    }
    if (mounted) {
      setState(() => _sending = false);
    }
  }
}
