import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// 尚未實作之 route 的統一佔位頁（Phase 1）。只顯示 route 標題與參數，
/// 不含任何假資料（規範 No Mock Data）。各 feature 頁完成後移除對應佔位。
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    required this.title,
    this.params = const <String, String>{},
    this.showBack = true,
    super.key,
  });

  final String title;
  final Map<String, String> params;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final bool canPop = showBack && context.canPop();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: canPop
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: context.pop,
              )
            : null,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.construction_outlined,
                color: AppColors.mut,
                size: 40,
              ),
              const SizedBox(height: AppSpacing.md),
              Text('$title（建置中）', style: AppTypography.titleMedium),
              if (params.isNotEmpty) ...<Widget>[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  params.entries
                      .map(
                        (MapEntry<String, String> e) => '${e.key}: ${e.value}',
                      )
                      .join('  ·  '),
                  style: AppTypography.mono,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
