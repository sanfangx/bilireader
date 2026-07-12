import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// 金色主要按鈕。對齊設計稿 .lg-btn / .btn：
/// height 52, radius 16, 金底深字, w700。
class GoldButton extends StatelessWidget {
  const GoldButton({
    super.key,
    required this.label,
    required this.onTap,
    this.loading = false,
    this.height = 52,
    this.fontSize = 15,
  });

  final String label;

  /// 可空 → 傳 null（或 loading=true）即停用，才能表達「進行中」防連點（M7/M8）。
  final VoidCallback? onTap;
  final bool loading;
  final double height;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final bool disabled = onTap == null || loading;
    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: Material(
        color: AppColors.acc,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: height,
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.btxt),
                    )
                  : Text(
                      label,
                      style: AppText.sans(
                        size: fontSize,
                        weight: FontWeight.w700,
                        color: AppColors.btxt,
                        letterSpacing: 0.6,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
