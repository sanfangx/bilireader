import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../network/image_headers.dart';
import '../theme/app_colors.dart';

/// 圓形使用者頭像（圈子 / 書評 / 章評共用）。走與封面相同的 CDN rewrite + headers；
/// 無 URL 或載入失敗時顯示 cov 底圓（對齊設計稿的 `.post-av` / `.ccav` / `.rvd-av`）。
class UserAvatar extends StatelessWidget {
  const UserAvatar({required this.url, this.size = 34, super.key});

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    final String raw = url?.trim() ?? '';
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: raw.isEmpty
            ? const ColoredBox(color: AppColors.cov)
            : CachedNetworkImage(
                imageUrl: ImageHeaders.rewriteCdn(raw),
                httpHeaders: ImageHeaders.headersFor(
                  ImageHeaders.rewriteCdn(raw),
                ),
                fit: BoxFit.cover,
                placeholder: (_, _) => const ColoredBox(color: AppColors.cov),
                errorWidget: (_, _, _) =>
                    const ColoredBox(color: AppColors.cov),
              ),
      ),
    );
  }
}
