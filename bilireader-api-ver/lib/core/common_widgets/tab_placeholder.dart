import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// 分頁「建置中」狀態視圖（Phase 1 骨架）。僅呈現分頁語意與說明文字，
/// 不含任何假資料（規範 No Mock Data）。實際資料頁完成後移除。
class TabPlaceholder extends StatelessWidget {
  const TabPlaceholder({
    required this.icon,
    required this.title,
    this.note,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screen),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, color: AppColors.mut, size: 48),
            const SizedBox(height: AppSpacing.md),
            Text(title, style: AppTypography.titleMedium),
            if (note != null) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              Text(
                note!,
                style: AppTypography.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
