import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widgets/bili_error_view.dart';
import '../../../core/common_widgets/bili_loading_view.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/text/tw_error.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../domain/system_entities.dart';
import 'system_controllers.dart';

/// 更新日誌頁（`version/changelog`）。設計稿未單獨定義本頁，沿用既有清單基元（§5.1）。
class ChangelogPage extends ConsumerWidget {
  const ChangelogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<VersionLog>> logs = ref.watch(changelogProvider);
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('更新日誌')),
      body: logs.when(
        loading: () => const BiliLoadingView(message: '載入更新日誌'),
        error: (Object e, StackTrace _) => BiliErrorView(
          message: twErrorMessage(ref.read(chineseConverterProvider), e),
          onRetry: () => ref.invalidate(changelogProvider),
        ),
        data: (List<VersionLog> list) => list.isEmpty
            ? const Center(
                child: Text('目前沒有更新日誌', style: AppTypography.titleMedium),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                itemCount: list.length,
                itemBuilder: (BuildContext context, int i) =>
                    _LogRow(log: list[i]),
              ),
      ),
    );
  }
}

class _LogRow extends StatelessWidget {
  const _LogRow({required this.log});

  final VersionLog log;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screen,
        vertical: 14,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                log.versionName.isEmpty ? '—' : log.versionName,
                style: AppTypography.mono.copyWith(
                  fontSize: 13,
                  color: AppColors.txt,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (log.isCurrent) ...<Widget>[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: AppColors.accBorder),
                  ),
                  child: Text(
                    '目前版本',
                    style: AppTypography.mono.copyWith(
                      fontSize: 9,
                      color: AppColors.acc,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (log.updateContent.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              log.updateContent,
              style: AppTypography.bodyMedium.copyWith(
                fontSize: 12.5,
                height: 1.75,
                color: AppColors.mut,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
