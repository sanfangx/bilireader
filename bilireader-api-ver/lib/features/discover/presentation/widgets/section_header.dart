import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// 區塊標題列（設計稿 `.sec-h`）：粗體標題 + 右側次要動作（更多 / 換一批）。
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          // 設計 `.sec-h b` 用 var(--disp)：區塊標題為 serif（與書名/貼文標題一致）。
          style: AppTypography.titleMedium.copyWith(
            fontFamily: AppTypography.fontSerif,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (actionLabel != null && onAction != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              minimumSize: const Size(0, 36),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              foregroundColor: AppColors.acc,
            ),
            child: Text(actionLabel!, style: AppTypography.bodySmall),
          ),
      ],
    );
  }
}
