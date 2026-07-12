import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';

/// 膠囊型搜尋入口（設計稿 `.hsearch`）。點擊導向搜尋頁；本身不接受輸入。
class SearchEntryBar extends StatelessWidget {
  const SearchEntryBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.pushNamed(AppRoutes.searchName),
      child: Container(
        key: const Key('discover_search_entry'),
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: AppColors.surf,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Row(
          children: <Widget>[
            const Icon(Icons.search, color: AppColors.mut, size: 18),
            const SizedBox(width: 9),
            Text(
              '搜尋書名、作者、標籤',
              style: AppTypography.bodySmall.copyWith(color: AppColors.mut),
            ),
          ],
        ),
      ),
    );
  }
}
