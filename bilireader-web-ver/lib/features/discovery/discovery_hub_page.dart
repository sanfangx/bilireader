import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import 'library_page.dart';
import 'ranking_page.dart';
import 'tags_page.dart';
import 'taxonomy.dart';

/// 分類 tab 落地頁 — 文庫 / 排行榜 / 標籤 / 完本 入口 + 熱門題材。
class DiscoveryHubPage extends StatelessWidget {
  const DiscoveryHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(22, 8, 22, 22),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('分類', style: AppText.serif(size: 23, color: AppColors.txt)),
                  const SizedBox(height: 3),
                  Text('EXPLORE · 探索',
                      style: AppText.mono(
                          size: 10, color: AppColors.mut, letterSpacing: 2.2)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          _entry(context, '庫', '文庫', '依來源 · 題材 · 排序篩選全站作品',
              () => const LibraryPage()),
          const SizedBox(height: 13),
          _entry(context, '榜', '排行榜', '點擊 · 推薦 · 鮮花 · 收藏 · 新書',
              () => const RankingPage()),
          const SizedBox(height: 13),
          _entry(context, '籤', '標籤', '依題材標籤探索',
              () => const TagsPage()),
          const SizedBox(height: 13),
          _entry(context, '完', '完本書庫', '已完結作品一次看到飽',
              () => const RankingPage(initialFull: true)),
          const SizedBox(height: 26),
          Text('熱門題材', style: AppText.sans(size: 12, color: AppColors.mut)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: Taxonomy.genres
                .where((t) => t.value != 0)
                .take(6)
                .map((t) => GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => LibraryPage(
                            initialTagid: t.value as int, title: t.label),
                      )),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                            color: AppColors.surf,
                            borderRadius: BorderRadius.circular(999)),
                        child: Text(t.label,
                            style:
                                AppText.sans(size: 12, color: AppColors.txt)),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _entry(BuildContext context, String glyph, String title, String sub,
      Widget Function() page) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => page())),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppColors.surf, borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                  color: AppColors.cov,
                  borderRadius: BorderRadius.circular(13)),
              alignment: Alignment.center,
              child: Text(glyph,
                  style: AppText.serif(size: 20, color: AppColors.acc)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppText.serif(size: 16, color: AppColors.txt)),
                  const SizedBox(height: 3),
                  Text(sub,
                      style: AppText.sans(size: 11, color: AppColors.mut)),
                ],
              ),
            ),
            Text('›', style: AppText.sans(size: 18, color: AppColors.mut)),
          ],
        ),
      ),
    );
  }
}
