import 'package:bilireader/core/common_widgets/app_badge.dart';
import 'package:bilireader/core/common_widgets/app_capsule_button.dart';
import 'package:bilireader/core/common_widgets/app_chip.dart';
import 'package:bilireader/core/common_widgets/app_segmented_control.dart';
import 'package:bilireader/core/common_widgets/bili_error_view.dart';
import 'package:bilireader/core/common_widgets/brand_header.dart';
import 'package:bilireader/core/common_widgets/reaction_pill.dart';
import 'package:bilireader/core/theme/app_colors.dart';
import 'package:bilireader/core/theme/app_spacing.dart';
import 'package:bilireader/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('共用元件 gallery golden', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildDarkTheme(),
        home: const Scaffold(body: _Gallery()),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(_Gallery),
      matchesGoldenFile('goldens/components_gallery.png'),
    );
  });
}

/// 靜態元件展示（不含動畫，避免 golden 無法 settle）。涵蓋膠囊元件的
/// selected / unselected / disabled 狀態（規範 §11 Phase 1 步驟 9）。
class _Gallery extends StatelessWidget {
  const _Gallery();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.bg,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                AppChip(label: '全部', selected: true),
                AppChip(label: '輕小說'),
                AppChip(label: '已完結', enabled: false),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                AppBadge(label: 'Lv3'),
                AppBadge(label: 'VIP', variant: AppBadgeVariant.outline),
                AppBadge(label: '3', variant: AppBadgeVariant.danger),
                AppBadge(
                  label: '校正',
                  pill: true,
                  variant: AppBadgeVariant.outline,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppSegmentedControl(
              segments: const <String>['日', '週', '月'],
              selectedIndex: 1,
              onChanged: (_) {},
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AppCapsuleButton(label: '主要', onPressed: () {}),
                const SizedBox(width: 8),
                AppCapsuleButton(
                  label: '膠囊',
                  shape: AppButtonShape.capsule,
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                const AppCapsuleButton(label: '停用'),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // 批 4 鎖現狀：BrandHeader + BrandIconButton（可點 / 純裝飾）+ ReactionPill
            // （選中 / 未選 / 空 label）——F-12 語意 / F-13 命中區 / F-20 觸覺動改前先鎖。
            BrandHeader(
              title: '書城',
              subtitle: 'BILI · 輕小說',
              trailing: BrandIconButton(
                icon: Icons.menu,
                semanticLabel: '選單',
                onTap: () {},
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                BrandIconButton(
                  icon: Icons.edit_outlined,
                  semanticLabel: '發表',
                  onTap: () {},
                ),
                const SizedBox(width: 8),
                const BrandIconButton(icon: Icons.search, semanticLabel: '搜尋'),
                const SizedBox(width: 12),
                ReactionPill(
                  icon: Icons.thumb_up_alt_outlined,
                  label: '12',
                  selected: true,
                  onTap: () {},
                ),
                const SizedBox(width: 8),
                ReactionPill(
                  icon: Icons.thumb_down_alt_outlined,
                  label: '3',
                  onTap: () {},
                ),
                const SizedBox(width: 8),
                ReactionPill(
                  icon: Icons.thumb_up_alt_outlined,
                  label: '',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            const SizedBox(height: 160, child: BiliErrorView(message: '載入失敗')),
          ],
        ),
      ),
    );
  }
}
