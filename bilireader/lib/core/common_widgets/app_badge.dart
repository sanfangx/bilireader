import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

/// 徽章視覺變體。對照設計稿：
/// - [filled]：金色實心（`.lvb` 等級）。
/// - [outline]：金色外框（`.vip`）。
/// - [danger]：紅色計數 / 狀態（`.cv-badge`）。
enum AppBadgeVariant { filled, outline, danger }

/// 小型徽章（規範 §5.1.1）。以 [variant] 與 [pill] 參數化，涵蓋設計稿
/// 多種視覺變體（實心／外框、小圓角／膠囊），避免各頁重刻。
class AppBadge extends StatelessWidget {
  const AppBadge({
    required this.label,
    this.variant = AppBadgeVariant.filled,
    this.pill = false,
    this.semanticLabel,
    super.key,
  });

  final String label;
  final AppBadgeVariant variant;

  /// true 為膠囊（標籤 pill）；false 為小圓角（level / hot 徽章）。
  final bool pill;

  /// F-12：無障礙名——數字類徽章（如未讀 `3`）用它播報有意義文字（如「3 則未讀」）；
  /// null 則以可見文字為名。
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final (
      Color background,
      Color foreground,
      Border? border,
    ) = switch (variant) {
      AppBadgeVariant.filled => (AppColors.acc, AppColors.btxt, null),
      AppBadgeVariant.outline => (
        Colors.transparent,
        AppColors.acc,
        Border.all(color: AppColors.accBorder),
      ),
      AppBadgeVariant.danger => (AppColors.badgeRed, Colors.white, null),
    };

    final Widget text = Text(
      label,
      style: AppTypography.eyebrow.copyWith(
        color: foreground,
        letterSpacing: 0.3,
      ),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        border: border,
        borderRadius: pill ? AppRadius.pillAll : AppRadius.badgeAll,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        child: semanticLabel == null
            ? text
            : Semantics(
                label: semanticLabel,
                excludeSemantics: true,
                child: text,
              ),
      ),
    );
  }
}
