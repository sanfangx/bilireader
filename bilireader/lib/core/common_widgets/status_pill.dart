import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// 狀態膠囊視覺變體（設計稿 `.lvb` / `.vip` / `.sb`，規範 §5.1.1）。
enum StatusPillVariant {
  /// `.lvb`：等級。實心 acc 底、btxt、mono、圓角 5。
  level,

  /// `.vip`：VIP。acc 外框、acc 字、透明底、圓角 5。
  vip,

  /// `.sb`：簽到狀態。cov 底、mut 字、大圓角膠囊。
  signed,
}

/// 只負責視覺的狀態膠囊（等級 / VIP / 簽到 …）。無業務語意；文字由呼叫端傳入。
class StatusPill extends StatelessWidget {
  const StatusPill({required this.label, required this.variant, super.key});

  final String label;
  final StatusPillVariant variant;

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case StatusPillVariant.level:
        return _pill(
          bg: AppColors.acc,
          borderColor: null,
          radius: 5,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          style: AppTypography.mono.copyWith(
            fontSize: 9,
            color: AppColors.btxt,
            fontWeight: FontWeight.w700,
          ),
        );
      case StatusPillVariant.vip:
        return _pill(
          bg: Colors.transparent,
          borderColor: AppColors.acc,
          radius: 5,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          style: AppTypography.bodySmall.copyWith(
            fontSize: 9,
            color: AppColors.acc,
            fontWeight: FontWeight.w600,
          ),
        );
      case StatusPillVariant.signed:
        return _pill(
          bg: AppColors.cov,
          borderColor: null,
          radius: 999,
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
          style: AppTypography.bodySmall.copyWith(
            fontSize: 11,
            color: AppColors.mut,
            fontWeight: FontWeight.w700,
          ),
        );
    }
  }

  Widget _pill({
    required Color bg,
    required Color? borderColor,
    required double radius,
    required EdgeInsets padding,
    required TextStyle style,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
        border: borderColor == null ? null : Border.all(color: borderColor),
      ),
      child: Text(label, style: style),
    );
  }
}
