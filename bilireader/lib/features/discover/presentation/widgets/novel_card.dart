import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/common_widgets/book_cover.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/novel_summary.dart';

/// 直式書卡（封面在上、書名 /（可選）作者在下），用於首頁橫向捲動與詳情「也在看」。
/// 點擊導向書籍詳情（規範 §6.2：用 go_router，不用 Navigator.push）。
///
/// 設計稿兩種變體：`.hbook`（首頁，寬 88、封面 88×124、書名 11.5、作者 10）與
/// `.reco`（也在看，寬 70、封面 70×98、書名 10、無作者）。書名皆為單行省略。
class NovelCard extends StatelessWidget {
  const NovelCard({
    required this.novel,
    this.width = 88,
    this.titleSize = 11.5,
    this.showAuthor = true,
    super.key,
  });

  final NovelSummary novel;
  final double width;
  final double titleSize;
  final bool showAuthor;

  /// 設計稿封面比例：`.hbcov` 88×124、`.reco .rc` 70×98（約 0.71，5:7）。
  static const double _coverAspect = 88 / 124;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.pushNamed(
        AppRoutes.novelDetailName,
        pathParameters: <String, String>{'articleId': '${novel.articleId}'},
      ),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            BookCover(
              url: novel.coverUrl,
              width: width,
              aspectRatio: _coverAspect,
              radius: AppRadius.md,
            ),
            const SizedBox(height: 8),
            Text(
              novel.title.isEmpty ? '未命名' : novel.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              // 書名為內容標題 → serif（統一各處書名字體）。
              style: AppTypography.bodySmall.copyWith(
                fontFamily: AppTypography.fontSerif,
                fontSize: titleSize,
                fontWeight: FontWeight.w600,
                color: AppColors.txt,
              ),
            ),
            if (showAuthor &&
                novel.author != null &&
                novel.author!.isNotEmpty) ...<Widget>[
              const SizedBox(height: 2),
              Text(
                novel.author!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 10,
                  color: AppColors.mut,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
