import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widgets/bili_error_view.dart';
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
import '../data/review_providers.dart';
import '../domain/review_entities.dart';
import 'review_controllers.dart';

/// 書評詳情頁（設計稿「書評詳情 Review」）。書評本體（含 rvd-rb 讚/倒讚）+ 回覆列表
/// + 底部回覆列。書評無每則評分，故不顯示星等（§No Mock Data）。互動為 §7.0 端點。
class BookReviewDetailPage extends ConsumerWidget {
  const BookReviewDetailPage({
    required this.topicId,
    this.articleId,
    super.key,
  });

  final int topicId;

  /// 來源書評列表的 articleId（列表以此為 key）。傳入時，詳情內讚/回覆成功後對
  /// `reviewListControllerProvider(articleId)` 做單筆 upsert，令返回列表計數同步且不重置
  /// 捲動/分頁（UX F-07，體驗不變量#1）。null 時退化為僅同步詳情。
  final int? articleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<BookReview> review = ref.watch(
      reviewDetailProvider(topicId),
    );
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('書評詳情')),
      body: review.when(
        loading: () => const BiliLoadingView(message: '載入書評'),
        error: (Object e, StackTrace _) => BiliErrorView(
          message: twErrorMessage(ref.read(chineseConverterProvider), e),
          onRetry: () => ref.invalidate(reviewDetailProvider(topicId)),
        ),
        data: (BookReview r) => Column(
          children: <Widget>[
            Expanded(
              child: _Body(review: r, articleId: articleId),
            ),
            _ReplyBar(topicId: topicId, articleId: articleId),
          ],
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.review, this.articleId});

  final BookReview review;
  final int? articleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<ReviewRepliesState> replies = ref.watch(
      reviewRepliesControllerProvider(review.topicId),
    );
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        _ReviewHead(review: review, articleId: articleId),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            12,
            AppSpacing.screen,
            4,
          ),
          child: Text(
            '回覆 · ${review.replies}',
            style: AppTypography.bodySmall.copyWith(
              fontSize: 12,
              color: AppColors.txt,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        replies.when(
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
          data: (ReviewRepliesState s) => Column(
            children: <Widget>[
              if (s.replies.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Text('還沒有回覆', style: AppTypography.bodySmall),
                )
              else
                for (final BookReviewReply r in s.replies) _ReplyRow(reply: r),
              if (s.hasMore)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: TextButton(
                    onPressed: () => ref
                        .read(
                          reviewRepliesControllerProvider(
                            review.topicId,
                          ).notifier,
                        )
                        .loadMore(),
                    child: Text(
                      s.loadingMore ? '載入中…' : '查看更多回覆',
                      style: const TextStyle(color: AppColors.acc),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}

/// `.rvd-h`：書評本體 + rvd-rb 讚/倒讚膠囊。
class _ReviewHead extends ConsumerWidget {
  const _ReviewHead({required this.review, this.articleId});

  final BookReview review;
  final int? articleId;

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
              UserAvatar(url: review.avatarUrl, size: 42),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      review.authorName.isEmpty ? '匿名' : review.authorName,
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _meta(review),
                      style: AppTypography.bodySmall.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
              if (review.isGood) const _GoodBadge(),
            ],
          ),
          const SizedBox(height: 12),
          if (review.isSpoiler)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '⚠ 含劇透',
                style: AppTypography.bodySmall.copyWith(color: AppColors.acc),
              ),
            ),
          Text(
            review.content,
            style: AppTypography.readerBody.copyWith(fontSize: 13, height: 1.8),
          ),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              ReactionPill(
                icon: Icons.thumb_up_alt_outlined,
                label: review.likeNum > 0 ? '讚 ${review.likeNum}' : '讚',
                selected: review.myReaction == Reaction.like,
                onTap: () => _react(ref, Reaction.like),
              ),
              const SizedBox(width: 10),
              ReactionPill(
                icon: Icons.thumb_down_alt_outlined,
                label: review.badNum > 0 ? '倒讚 ${review.badNum}' : '倒讚',
                selected: review.myReaction == Reaction.bad,
                onTap: () => _react(ref, Reaction.bad),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _react(WidgetRef ref, Reaction target) async {
    final int type = target.toggledRequestValue(review.myReaction);
    final ApiResult<ReactionCounts> result = await ref
        .read(reviewRepositoryProvider)
        .like(topicId: review.topicId, type: type);
    if (result is ApiSuccess<ReactionCounts>) {
      ref.invalidate(reviewDetailProvider(review.topicId));
      // F-07：書評列表單筆同步（不整列重抓 → 返回列表保捲動/分頁，不變量#1）。
      if (articleId != null) {
        ref
            .read(reviewListControllerProvider(articleId!).notifier)
            .applyStats(
              review.topicId,
              likeNum: result.data.likeNum,
              badNum: result.data.badNum,
              myReaction: result.data.myReaction,
            );
      }
    }
  }

  String _meta(BookReview r) {
    final String lv = (r.authorLevel ?? '').trim();
    final String time = relativeTimeFromSeconds(r.posttime);
    return <String>[
      if (lv.isNotEmpty) lv,
      if (time.isNotEmpty) time,
    ].join(' · ');
  }
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

/// `.ccrow`：回覆列。
class _ReplyRow extends ConsumerWidget {
  const _ReplyRow({required this.reply});

  final BookReviewReply reply;

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
        .read(reviewRepositoryProvider)
        .replyLike(postId: reply.postId, type: type);
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
  const _ReplyBar({required this.topicId, this.articleId});

  final int topicId;
  final int? articleId;

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
                  decoration: const InputDecoration.collapsed(
                    hintText: '回覆這則書評…',
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
    final ApiResult<BookReviewReply> result = await ref
        .read(reviewActionsProvider.notifier)
        .reply(topicId: widget.topicId, posttext: text);
    if (!mounted) {
      return;
    }
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    switch (result) {
      case ApiSuccess<BookReviewReply>():
        _controller.clear();
        ref
          ..invalidate(reviewRepliesControllerProvider(widget.topicId))
          ..invalidate(reviewDetailProvider(widget.topicId));
        // F-07：書評列表回覆數 +1（單筆同步，不整列重抓 → 不變量#1）。
        if (widget.articleId != null) {
          ref
              .read(reviewListControllerProvider(widget.articleId!).notifier)
              .applyStats(widget.topicId, repliesDelta: 1);
        }
        messenger.showSnackBar(const SnackBar(content: Text('已回覆')));
      case ApiFailure<BookReviewReply>(:final error):
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
