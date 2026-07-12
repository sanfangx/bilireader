import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widgets/app_bottom_sheet.dart';
import '../../../core/common_widgets/bili_error_view.dart';
import '../../../core/network/api_result.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/text/tw_error.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../domain/vote_stats.dart';
import 'interaction_controllers.dart';

/// 開啟推薦票抽屜（`vote/getNovelVotes` + `vote/addVote`）。今日已投則停用。
Future<void> showVoteSheet(BuildContext context, {required int articleId}) {
  return showAppBottomSheet<void>(
    context: context,
    title: '投推薦票',
    child: _VoteSheetBody(articleId: articleId),
  );
}

class _VoteSheetBody extends ConsumerStatefulWidget {
  const _VoteSheetBody({required this.articleId});

  final int articleId;

  @override
  ConsumerState<_VoteSheetBody> createState() => _VoteSheetBodyState();
}

class _VoteSheetBodyState extends ConsumerState<_VoteSheetBody> {
  bool _voting = false;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<VoteStats> stats = ref.watch(
      voteStatsProvider(widget.articleId),
    );
    return stats.when(
      loading: () => const SizedBox(
        height: 180,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.acc,
            strokeWidth: 2,
          ),
        ),
      ),
      error: (Object e, StackTrace _) => SizedBox(
        height: 180,
        child: BiliErrorView(
          message: twErrorMessage(ref.read(chineseConverterProvider), e),
          onRetry: () => ref.invalidate(voteStatsProvider(widget.articleId)),
        ),
      ),
      data: _buildContent,
    );
  }

  Widget _buildContent(VoteStats s) {
    final bool voted = s.todayVoted;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          children: <Widget>[
            _StatBox(value: s.allVote, label: '總推薦'),
            const SizedBox(width: 9),
            _StatBox(value: s.dayVote, label: '今日'),
            const SizedBox(width: 9),
            _StatBox(value: s.weekVote, label: '本週'),
            const SizedBox(width: 9),
            _StatBox(value: s.monthVote, label: '本月'),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.acc,
              foregroundColor: AppColors.btxt,
              disabledBackgroundColor: AppColors.cov,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
            ),
            onPressed: (voted || _voting) ? null : _vote,
            child: _voting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.btxt,
                    ),
                  )
                : Text(
                    voted ? '今日已投票' : '投出推薦票',
                    style: AppTypography.labelLarge.copyWith(
                      color: voted ? AppColors.mut : AppColors.btxt,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _vote() async {
    setState(() => _voting = true);
    final ApiResult<String> result = await ref
        .read(interactionMutationsProvider.notifier)
        .addVote(articleId: widget.articleId);
    if (!mounted) {
      return;
    }
    final NavigatorState navigator = Navigator.of(context);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final String message = switch (result) {
      ApiSuccess<String>(:final String data) => data.isEmpty ? '投票成功' : data,
      ApiFailure<String>(:final error) => twErrorMessage(
        ref.read(chineseConverterProvider),
        error,
      ),
    };
    if (result is ApiSuccess<String>) {
      navigator.pop();
    } else {
      setState(() => _voting = false);
    }
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}

/// 推薦票統計格（同送花餘額格視覺）。
class _StatBox extends StatelessWidget {
  const _StatBox({required this.value, required this.label});

  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 6),
        child: Column(
          children: <Widget>[
            Text(
              '$value',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.mono.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.acc,
              ),
            ),
            const SizedBox(height: 3),
            Text(label, style: AppTypography.bodySmall.copyWith(fontSize: 9)),
          ],
        ),
      ),
    );
  }
}
