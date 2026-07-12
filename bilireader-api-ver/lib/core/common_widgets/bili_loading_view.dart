import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// 全域載入狀態元件（規範 §11 Phase 1 步驟 8、§5.2）。所有 `AsyncValue.loading`
/// 一律使用此元件，禁止各 feature 頁手刻 `CircularProgressIndicator`。
class BiliLoadingView extends StatelessWidget {
  const BiliLoadingView({this.message, super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: AppColors.acc,
            ),
          ),
          if (message != null) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Text(message!, style: AppTypography.bodySmall),
          ],
        ],
      ),
    );
  }
}
