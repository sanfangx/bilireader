import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// F-29：灰階骨架佔位方塊（載入中取代置中轉圈）。**靜態**（無 shimmer）→ 確定性、golden
/// 可測、reduce-motion 安全。設計稿無 skeleton 樣式 → 形狀對齊實際卡片、灰階以 surf token
/// （§9.7(a) 既有 token 組合，回報假設）。
class BiliSkeletonBox extends StatelessWidget {
  const BiliSkeletonBox({
    this.width,
    this.height,
    this.radius = AppRadius.badge,
    super.key,
  });

  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: AppColors.surf,
      borderRadius: BorderRadius.circular(radius),
    ),
    child: SizedBox(width: width, height: height),
  );
}

/// 直式書卡骨架（封面 + 書名 + 作者行），對齊 `NovelCard` 形狀。
/// 預設 `width:88`、`coverHeight:124`（＝`NovelCard` 預設寬 88 + `_coverAspect 88/124`），
/// 封面圓角 `AppRadius.md`（＝`BookCover` 圓角）、書名→作者間距 2（同 NovelCard），
/// 避免載入→資料的版面跳動。
class NovelCardSkeleton extends StatelessWidget {
  const NovelCardSkeleton({this.width = 88, this.coverHeight = 124, super.key});

  final double width;
  final double coverHeight;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        BiliSkeletonBox(
          width: width,
          height: coverHeight,
          radius: AppRadius.md,
        ),
        const SizedBox(height: AppSpacing.sm),
        BiliSkeletonBox(width: width * 0.85, height: 11),
        const SizedBox(height: 2),
        BiliSkeletonBox(width: width * 0.5, height: 9),
      ],
    ),
  );
}

/// 橫向書卡列骨架（書城「強力推薦」，高 178）。
class HorizontalBooksSkeleton extends StatelessWidget {
  const HorizontalBooksSkeleton({this.count = 4, super.key});

  final int count;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '載入中',
    container: true,
    child: SizedBox(
      height: 178,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (_, _) => const NovelCardSkeleton(),
      ),
    ),
  );
}

/// 榜單 / 點擊榜列骨架（名次 + 封面 + 兩行文字）。
class RankListSkeleton extends StatelessWidget {
  const RankListSkeleton({this.count = 5, super.key});

  final int count;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '載入中',
    container: true,
    child: Column(
      children: <Widget>[
        for (int i = 0; i < count; i++)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: <Widget>[
                BiliSkeletonBox(
                  width: 20,
                  height: 20,
                  radius: AppRadius.badgeSm,
                ),
                SizedBox(width: AppSpacing.md),
                BiliSkeletonBox(width: 44, height: 60, radius: AppRadius.sm),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      BiliSkeletonBox(width: 150, height: 12),
                      SizedBox(height: AppSpacing.sm),
                      BiliSkeletonBox(width: 90, height: 9),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}
