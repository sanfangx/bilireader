import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'app_capsule_button.dart';

/// 全域空狀態元件（規範 §5.2）。統一各頁分散的空狀態文案與樣式（UX F-24）：
/// icon + 標題 + 可選次要說明 + 可選動作。與 [BiliLoadingView]/[BiliErrorView] 同構，
/// 使 loading / error / empty 三態視覺一致。
///
/// 設計稿無此元件 → 視覺預設＝比照 `BiliErrorView`（置中、mut 色 icon 40、bodyMedium
/// 標題），動作用既有 `AppCapsuleButton`（§9.7(a)：既有 token/元件組合，回報假設）。
class BiliEmptyView extends StatelessWidget {
  const BiliEmptyView({
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.detail,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  /// 主標題（繁中）。
  final String message;

  /// 空狀態圖示（各頁可依情境替換，預設收件匣）。
  final IconData icon;

  /// 次要說明（可選）。
  final String? detail;

  /// 可選動作按鈕文案；與 [onAction] 同時提供才顯示。
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final bool showAction = actionLabel != null && onAction != null;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screen),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, color: AppColors.mut, size: 40),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: AppTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (detail != null) ...<Widget>[
              const SizedBox(height: AppSpacing.xs),
              Text(
                detail!,
                style: AppTypography.bodySmall.copyWith(color: AppColors.mut),
                textAlign: TextAlign.center,
              ),
            ],
            if (showAction) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              AppCapsuleButton(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}
