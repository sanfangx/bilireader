import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widgets/app_bottom_sheet.dart';
import '../../../core/network/api_result.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/text/tw_error.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import 'interaction_controllers.dart';

/// 評分星數上限（`rating/submit` 伺服器實測範圍 1–5，doc 10「1~10 之類」為臆測）。
const int _maxStars = 5;

/// 開啟評分抽屜（`rating/submit`，1–5 星）。預帶「我的評分」。
Future<void> showRatingSheet(BuildContext context, {required int articleId}) {
  return showAppBottomSheet<void>(
    context: context,
    title: '為這本書評分',
    child: _RatingSheetBody(articleId: articleId),
  );
}

class _RatingSheetBody extends ConsumerStatefulWidget {
  const _RatingSheetBody({required this.articleId});

  final int articleId;

  @override
  ConsumerState<_RatingSheetBody> createState() => _RatingSheetBodyState();
}

class _RatingSheetBodyState extends ConsumerState<_RatingSheetBody> {
  int _selected = 0;
  bool _submitting = false;
  bool _initialised = false;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<int> mine = ref.watch(myRatingProvider(widget.articleId));
    // 首次載入到「我的評分」後預選（僅一次，之後尊重使用者手動選擇）；夾在 1–5。
    mine.whenData((int r) {
      if (!_initialised) {
        _initialised = true;
        if (r > 0) {
          _selected = r.clamp(1, _maxStars);
        }
      }
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          _selected == 0 ? '點選 1–5 星' : '$_selected 星',
          style: AppTypography.mono.copyWith(
            fontSize: 22,
            color: _selected == 0 ? AppColors.mut : AppColors.acc,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (int i = 1; i <= _maxStars; i++)
              _StarButton(
                filled: i <= _selected,
                onTap: _submitting ? null : () => setState(() => _selected = i),
              ),
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
            onPressed: (_selected == 0 || _submitting) ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.btxt,
                    ),
                  )
                : Text(
                    '送出評分',
                    style: AppTypography.labelLarge.copyWith(
                      color: AppColors.btxt,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    final ApiResult<int> result = await ref
        .read(interactionMutationsProvider.notifier)
        .submitRating(articleId: widget.articleId, rating: _selected);
    if (!mounted) {
      return;
    }
    final NavigatorState navigator = Navigator.of(context);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final String message = switch (result) {
      ApiSuccess<int>(:final int data) => '已評分 $data 星',
      ApiFailure<int>(:final error) => twErrorMessage(
        ref.read(chineseConverterProvider),
        error,
      ),
    };
    if (result is ApiSuccess<int>) {
      navigator.pop();
    } else {
      setState(() => _submitting = false);
    }
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}

/// 可點選的星（1–5）。已選（含以下）顯示實心金星，未選顯示空心。
class _StarButton extends StatelessWidget {
  const _StarButton({required this.filled, required this.onTap});

  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            filled ? Icons.star_rounded : Icons.star_border_rounded,
            size: 36,
            color: filled ? AppColors.acc : AppColors.mut,
          ),
        ),
      ),
    );
  }
}
