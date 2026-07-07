import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// 分頁列表尾端的三態（§5.2 / UX F-24、F-15、F-30）。
enum BiliListFooterState { loading, error, end }

/// 分頁列表尾端狀態列（規範 §5.2）。統一「載入更多中 / 載入失敗+重試 / 已無更多」
/// 三態，取代各頁手刻的 `CircularProgressIndicator` 與靜默停止（F-15/F-24/F-30）。
///
/// 設計稿無此元件 → 視覺預設＝組合既有 [Divider]/token 與 `BiliLoadingView` 樣式
/// （§9.7(a)：既有 token 組合，回報假設）。
class BiliListFooter extends StatelessWidget {
  const BiliListFooter({required this.state, this.onRetry, super.key});

  final BiliListFooterState state;

  /// 錯誤態的重試回呼（僅 [BiliListFooterState.error] 使用）。
  final VoidCallback? onRetry;

  /// 由分頁旗標推導尾端狀態；三者皆不成立（還有更多、未在載入、無錯誤）回 null，
  /// 表示列表尾端**不顯示** footer（捲動觸發 loadMore）。
  static BiliListFooterState? stateOf({
    required bool loadingMore,
    required bool loadMoreError,
    required bool hasMore,
  }) {
    if (loadingMore) {
      return BiliListFooterState.loading;
    }
    if (loadMoreError) {
      return BiliListFooterState.error;
    }
    if (!hasMore) {
      return BiliListFooterState.end;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Center(child: _content(context)),
    );
  }

  Widget _content(BuildContext context) {
    switch (state) {
      case BiliListFooterState.loading:
        return const SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.acc,
          ),
        );
      case BiliListFooterState.error:
        return InkWell(
          onTap: onRetry,
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.refresh, size: 16, color: AppColors.acc),
                const SizedBox(width: 6),
                Text(
                  '載入失敗，點擊重試',
                  style: AppTypography.bodySmall.copyWith(color: AppColors.acc),
                ),
              ],
            ),
          ),
        );
      case BiliListFooterState.end:
        return Text(
          '已無更多',
          style: AppTypography.bodySmall.copyWith(color: AppColors.mut),
        );
    }
  }
}
