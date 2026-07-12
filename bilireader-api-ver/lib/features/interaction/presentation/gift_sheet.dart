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
import '../domain/gift_models.dart';
import 'interaction_controllers.dart';

/// 開啟送花抽屜（設計稿「送鮮花 · 打賞作者」）。`gift/balance` + `gift/send`。
Future<void> showGiftSheet(BuildContext context, {required int articleId}) {
  return showAppBottomSheet<void>(
    context: context,
    title: '送鮮花 · 打賞作者',
    child: _GiftSheetBody(articleId: articleId),
  );
}

const List<int> _quickAmounts = <int>[1, 5, 10, 52, 99];

class _GiftSheetBody extends ConsumerStatefulWidget {
  const _GiftSheetBody({required this.articleId});

  final int articleId;

  @override
  ConsumerState<_GiftSheetBody> createState() => _GiftSheetBodyState();
}

class _GiftSheetBodyState extends ConsumerState<_GiftSheetBody> {
  int _count = 5;
  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<GiftBalance> balance = ref.watch(giftBalanceProvider);
    return balance.when(
      loading: () => const SizedBox(
        height: 220,
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.acc,
            strokeWidth: 2,
          ),
        ),
      ),
      error: (Object e, StackTrace _) => SizedBox(
        height: 220,
        child: BiliErrorView(
          message: twErrorMessage(ref.read(chineseConverterProvider), e),
          onRetry: () => ref.invalidate(giftBalanceProvider),
        ),
      ),
      data: _buildContent,
    );
  }

  Widget _buildContent(GiftBalance bal) {
    final int cost = _count * bal.flowerUnitPrice;
    final bool enough = _count <= bal.flowerStock;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // `.gf-bal`
        Row(
          children: <Widget>[
            _BalanceBox(value: bal.egold, label: '輕嗶哩幣'),
            const SizedBox(width: 9),
            _BalanceBox(value: bal.score, label: '積分'),
            const SizedBox(width: 9),
            _BalanceBox(value: bal.flowerStock, label: '鮮花庫存'),
          ],
        ),
        const SizedBox(height: 16),
        // `.gf-flower` stepper
        Container(
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _StepButton(
                icon: Icons.remove,
                onTap: _count > 1 ? () => setState(() => _count--) : null,
              ),
              const SizedBox(width: 22),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '$_count',
                    style: AppTypography.mono.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: AppColors.txt,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '朵鮮花',
                    style: AppTypography.bodySmall.copyWith(fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(width: 22),
              _StepButton(
                icon: Icons.add,
                onTap: () => setState(() => _count++),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        // `.gf-quick`
        Row(
          children: <Widget>[
            for (int i = 0; i < _quickAmounts.length; i++) ...<Widget>[
              if (i > 0) const SizedBox(width: 8),
              Expanded(
                child: _QuickChip(
                  amount: _quickAmounts[i],
                  selected: _count == _quickAmounts[i],
                  onTap: () => setState(() => _count = _quickAmounts[i]),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        // `.gf-send`
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
            onPressed: (!enough || _sending) ? null : () => _send(bal),
            child: _sending
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.btxt,
                    ),
                  )
                : Text(
                    enough ? '❀ 送出 $_count 朵鮮花' : '鮮花庫存不足',
                    style: AppTypography.labelLarge.copyWith(
                      color: enough ? AppColors.btxt : AppColors.mut,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 12),
        // `.gf-cost`
        Text(
          enough ? '消耗 $cost 輕嗶哩幣 · 庫存不足可用積分兌換' : '庫存不足；可於官方 App 以輕嗶哩幣或積分兌換鮮花',
          textAlign: TextAlign.center,
          style: AppTypography.bodySmall.copyWith(fontSize: 10.5),
        ),
      ],
    );
  }

  Future<void> _send(GiftBalance bal) async {
    setState(() => _sending = true);
    final ApiResult<GiftSendResult> result = await ref
        .read(interactionMutationsProvider.notifier)
        .sendGift(articleId: widget.articleId, count: _count);
    if (!mounted) {
      return;
    }
    final NavigatorState navigator = Navigator.of(context);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final String message = switch (result) {
      ApiSuccess<GiftSendResult>(:final GiftSendResult data) =>
        '已送出 $_count 朵鮮花，該書累計 ${data.novelAllFlower} 朵',
      ApiFailure<GiftSendResult>(:final error) => twErrorMessage(
        ref.read(chineseConverterProvider),
        error,
      ),
    };
    if (result is ApiSuccess<GiftSendResult>) {
      navigator.pop();
    } else {
      setState(() => _sending = false);
    }
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}

/// `.gf-b`：餘額格。
class _BalanceBox extends StatelessWidget {
  const _BalanceBox({required this.value, required this.label});

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
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
        child: Column(
          children: <Widget>[
            Text(
              _formatThousands(value),
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

/// `.gf-flower .step`：圓形加減鈕。
class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.4 : 1,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(side: BorderSide(color: AppColors.line)),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 36,
            height: 36,
            child: Icon(icon, size: 18, color: AppColors.acc),
          ),
        ),
      ),
    );
  }
}

/// `.gf-quick span`：快選數量。
class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.amount,
    required this.selected,
    required this.onTap,
  });

  final int amount;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // 視覺（底色 / 圓角 / 選中描邊）放 DecoratedBox；Material 只負責透明底 + ripple。
    // 不可同時給 Material `shape` 與 `borderRadius`（assertion 崩潰）。
    return DecoratedBox(
      decoration: BoxDecoration(
        color: selected ? AppColors.cov : AppColors.bg,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: selected ? Border.all(color: AppColors.acc) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          onTap: onTap,
          child: SizedBox(
            height: 32,
            child: Center(
              child: Text(
                '$amount',
                style: AppTypography.bodySmall.copyWith(
                  color: selected ? AppColors.acc : AppColors.mut,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _formatThousands(int value) {
  final String s = value.toString();
  final StringBuffer buffer = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(s[i]);
  }
  return buffer.toString();
}
