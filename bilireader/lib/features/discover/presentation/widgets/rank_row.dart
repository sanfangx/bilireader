import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common_widgets/book_cover.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/novel_summary.dart';

/// 直式榜單列：名次 + 封面 + 書名 / 作者·分類 + 右側數值（設計稿 `.rank`）。
/// 點擊導向書籍詳情。
class RankRow extends StatelessWidget {
  const RankRow({
    required this.rank,
    required this.novel,
    this.trailingValue,
    super.key,
  });

  final int rank;
  final NovelSummary novel;

  /// 右側指標文字（如「128萬 週點擊」）；null 則不顯示。
  final String? trailingValue;

  @override
  Widget build(BuildContext context) {
    // 設計稿 .rnum：Space Grotesk 等寬、寬 20、色 mut（不因名次變金色）。
    final List<String> metaParts = <String>[
      if (novel.author != null && novel.author!.isNotEmpty) novel.author!,
      if (novel.tags.isNotEmpty) novel.tags.first,
    ];
    return InkWell(
      onTap: () => context.pushNamed(
        AppRoutes.novelDetailName,
        pathParameters: <String, String>{'articleId': '${novel.articleId}'},
      ),
      child: Padding(
        // 設計稿 .rank：padding 9px 22px、gap 13。
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 20,
              child: Text(
                '$rank',
                style: AppTypography.mono.copyWith(
                  color: AppColors.mut,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 13),
            BookCover(url: novel.coverUrl, width: 44),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    novel.title.isEmpty ? '未命名' : novel.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    // 設計 `.rmeta b` 用 var(--disp)：榜單書名為 serif。
                    style: AppTypography.bodyLarge.copyWith(
                      fontFamily: AppTypography.fontSerif,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (metaParts.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 2),
                    Text(
                      metaParts.join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.mut,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailingValue != null) ...<Widget>[
              const SizedBox(width: AppSpacing.sm),
              Text(
                trailingValue!,
                style: AppTypography.mono.copyWith(color: AppColors.acc),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
