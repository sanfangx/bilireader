import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

/// 主要動作按鈕的外型。設計稿膠囊型（pill CTA / FAB，radius 999）與
/// 圓角主按鈕（radius 14）並存，以此區分。
enum AppButtonShape { rounded, capsule }

/// 主要動作按鈕（規範 §5.1.1）。金色底、深色字。以 [shape] 切換圓角／膠囊，
/// [onPressed] 為 null 時視為 disabled（自訂降透明度）。
class AppCapsuleButton extends StatelessWidget {
  const AppCapsuleButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.shape = AppButtonShape.rounded,
    this.expanded = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonShape shape;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;
    final BorderRadius radius = shape == AppButtonShape.capsule
        ? AppRadius.pillAll
        : AppRadius.buttonAll;

    final Widget content = Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (icon != null) ...<Widget>[
          Icon(icon, size: 18, color: AppColors.btxt),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: AppTypography.labelLarge.copyWith(color: AppColors.btxt),
        ),
      ],
    );

    return Opacity(
      opacity: enabled ? 1 : 0.4,
      child: Material(
        color: AppColors.acc,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          // F-20：主要動作按鈕 tap 給輕觸覺回饋（僅 enabled）。
          onTap: enabled
              ? () {
                  HapticFeedback.selectionClick();
                  onPressed!();
                }
              : null,
          child: ConstrainedBox(
            // 觸控目標不小於 44x44（規範 §5.3）。
            constraints: const BoxConstraints(minHeight: 44, minWidth: 44),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
