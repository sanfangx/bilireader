import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// 清單首屏骨架（取代單一 spinner，對齊 api-ver F-24）。數列微光矩形。
class ListSkeleton extends StatelessWidget {
  const ListSkeleton({super.key, this.rows = 7});
  final int rows;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 6),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rows,
      itemBuilder: (_, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _box(54, 76),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(double.infinity, 13, maxW: 160),
                  const SizedBox(height: 8),
                  _box(double.infinity, 10, maxW: 90),
                  const SizedBox(height: 10),
                  _box(double.infinity, 9),
                  const SizedBox(height: 5),
                  _box(double.infinity, 9, maxW: 200),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _box(double w, double h, {double? maxW}) => Container(
        width: w,
        height: h,
        constraints: maxW != null ? BoxConstraints(maxWidth: maxW) : null,
        decoration: BoxDecoration(
          color: AppColors.surf,
          borderRadius: BorderRadius.circular(6),
        ),
      );
}

/// 統一空態（圖示 + 文案）。
class ListEmptyView extends StatelessWidget {
  const ListEmptyView({
    super.key,
    this.icon = Icons.inbox_outlined,
    this.message = '沒有符合的作品',
  });
  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: AppColors.mut.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          Text(message, style: AppText.sans(size: 13, color: AppColors.mut)),
        ],
      ),
    );
  }
}

/// 統一錯誤態（可重試）。
class ListErrorView extends StatelessWidget {
  const ListErrorView({
    super.key,
    this.message = '載入失敗',
    required this.onRetry,
  });
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_outlined,
              size: 38, color: AppColors.mut.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          Text(message, style: AppText.sans(size: 13, color: AppColors.mut)),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onRetry,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              decoration: BoxDecoration(
                color: AppColors.surf,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.acc.withValues(alpha: 0.5)),
              ),
              child: Text('重試',
                  style: AppText.sans(
                      size: 12, weight: FontWeight.w600, color: AppColors.acc)),
            ),
          ),
        ],
      ),
    );
  }
}

/// 清單尾端三態：載入中 / 失敗可重試 / 已無更多（對齊 F-30）。
class ListFooter extends StatelessWidget {
  const ListFooter({
    super.key,
    required this.loadingMore,
    required this.error,
    required this.hasMore,
    required this.isEmpty,
    required this.onRetry,
  });

  final bool loadingMore;
  final bool error;
  final bool hasMore;
  final bool isEmpty; // 清單本身為空時不顯示「已無更多」。
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (loadingMore) {
      child = const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.acc),
      );
    } else if (error) {
      child = GestureDetector(
        onTap: onRetry,
        child: Text('載入更多失敗，點此重試',
            style: AppText.sans(size: 12, color: AppColors.acc)),
      );
    } else if (!hasMore && !isEmpty) {
      child = Text('已無更多',
          style: AppText.mono(
              size: 10, color: AppColors.mut, letterSpacing: 1.5));
    } else {
      child = const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Center(child: child),
    );
  }
}
