import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// 啟動品牌 splash（F-26）：OpenCC 字典於背景載入期間顯示，避免字典同步 parse 阻塞首幀。
/// 設計稿無 splash 稿 → 採既有品牌色 + 品牌字樣（§9.7(a) 既有 token 組合，回報假設）。
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'BiliReader',
              style: AppTypography.displayMedium.copyWith(
                fontSize: 34,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'BILI · 輕小說',
              style: AppTypography.eyebrow.copyWith(
                letterSpacing: 2.6,
                color: AppColors.mut,
              ),
            ),
            const SizedBox(height: 30),
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.acc,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
