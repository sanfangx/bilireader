import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_capsule_button.dart';

/// 全域錯誤狀態元件（規範 §11 Phase 1 步驟 8、§5.2）。提供繁中訊息與重試入口，
/// 禁止各頁只顯示 raw error string。
class BiliErrorView extends StatelessWidget {
  const BiliErrorView({this.message, this.onRetry, super.key});

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screen),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline, color: AppColors.mut, size: 40),
            const SizedBox(height: AppSpacing.md),
            Text(
              message ?? '發生錯誤，請稍後再試',
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              AppCapsuleButton(
                label: '重試',
                icon: Icons.refresh,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
