import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// 畫面底色 + 頂部金色光暈。
/// 對齊設計稿 .scr：
///   background-color: var(--bg);
///   background-image: radial-gradient(120% 60% at 50% -8%, rgba(202,161,92,.08), transparent 60%);
class AppBackground extends StatelessWidget {
  const AppBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        gradient: RadialGradient(
          center: Alignment(0, -1.15), // 頂部中央偏上（CSS 的 at 50% -8%）
          radius: 1.1,
          colors: [
            Color(0x14CAA15C), // acc @ ~8%
            Color(0x00CAA15C), // 透明
          ],
          stops: [0.0, 0.6],
        ),
      ),
      child: child,
    );
  }
}
