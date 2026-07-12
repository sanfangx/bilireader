import 'package:flutter/material.dart';

import '../core/app_config.dart';
import '../core/session/auth_controller.dart';
import '../theme/app_colors.dart';

/// 封面圖。linovelib 圖片需帶 Referer（+ UA / Cookie），故用帶 header 的 Image.network。
class NetworkCover extends StatelessWidget {
  const NetworkCover({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.radius = 10,
  });

  final String? url;
  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final br = BorderRadius.circular(radius);
    final placeholder = _CoverSkeleton(width: width, height: height, radius: br);
    if (url == null || url!.isEmpty) return placeholder;

    final cookie = AuthController.instance.session?.cookieHeader ?? 'night=0';
    return ClipRRect(
      borderRadius: br,
      child: Image.network(
        url!,
        width: width,
        height: height,
        fit: BoxFit.cover,
        headers: {
          'Referer': AppConfig.origin,
          'User-Agent': AppConfig.userAgent,
          'Cookie': cookie,
        },
        gaplessPlayback: true,
        errorBuilder: (_, _, _) => placeholder,
        loadingBuilder: (c, child, progress) =>
            progress == null ? child : placeholder,
      ),
    );
  }
}

class _CoverSkeleton extends StatelessWidget {
  const _CoverSkeleton({this.width, this.height, required this.radius});
  final double? width;
  final double? height;
  final BorderRadius radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.cov, Color(0xFF231B12)],
        ),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.menu_book_outlined,
          size: 18, color: AppColors.mut.withValues(alpha: 0.4)),
    );
  }
}
