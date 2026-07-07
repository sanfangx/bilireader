import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common_widgets/app_badge.dart';
import '../../../../core/common_widgets/book_cover.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/novel_summary.dart';

/// 搜尋 / 標籤 / 榜單結果的橫向清單項：封面 + 書名 + 作者·狀態 + 標籤 + 簡介。
/// 點擊導向書籍詳情。
class NovelListTile extends StatelessWidget {
  const NovelListTile({required this.novel, super.key});

  final NovelSummary novel;

  @override
  Widget build(BuildContext context) {
    final String statusText = novel.isFinished ? '完結' : '連載中';
    final String meta = <String>[
      if (novel.author != null && novel.author!.isNotEmpty) novel.author!,
      statusText,
    ].join(' · ');
    return InkWell(
      onTap: () => context.pushNamed(
        AppRoutes.novelDetailName,
        pathParameters: <String, String>{'articleId': '${novel.articleId}'},
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 設計稿 .lbcov：52×74，radius 10。
            BookCover(url: novel.coverUrl, width: 52, height: 74),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    novel.title.isEmpty ? '未命名' : novel.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    meta,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.mut,
                    ),
                  ),
                  if (novel.tags.isNotEmpty) ...<Widget>[
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: <Widget>[
                        for (final String t in novel.tags.take(3))
                          AppBadge(label: t, variant: AppBadgeVariant.outline),
                      ],
                    ),
                  ],
                  if ((novel.intro ?? '').isNotEmpty) ...<Widget>[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      novel.intro!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.mut,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
