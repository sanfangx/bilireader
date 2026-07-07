import 'package:bilireader/core/common_widgets/bili_skeleton.dart';
import 'package:bilireader/core/theme/app_colors.dart';
import 'package:bilireader/core/theme/app_radius.dart';
import 'package:bilireader/core/theme/app_spacing.dart';
import 'package:bilireader/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// F-29：載入骨架。設計稿無 skeleton 稿 → 形狀對齊實際卡片、灰階以 surf token（回報假設）。
/// 靜態、無 shimmer → golden 可測、reduce-motion 安全。
Future<void> _pump(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 720);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildDarkTheme(),
      home: const Scaffold(
        backgroundColor: AppColors.bg,
        body: Padding(
          padding: EdgeInsets.all(AppSpacing.screen),
          child: Column(
            // 拉伸使 banner 佔滿寬度，貼近書城輪播載入時的實際版面（sliver 子項本即滿寬）。
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              BiliSkeletonBox(height: 120, radius: AppRadius.banner),
              SizedBox(height: AppSpacing.xl),
              HorizontalBooksSkeleton(count: 3),
              SizedBox(height: AppSpacing.xl),
              RankListSkeleton(count: 3),
            ],
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('骨架元件 gallery golden', (WidgetTester tester) async {
    await _pump(tester);
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/skeleton_gallery.png'),
    );
  });
}
