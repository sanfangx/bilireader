import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../network/image_headers.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

/// 統一封面圖元件（規範 §5.1、§5.3、§7.6）。
///
/// - 以 [ImageHeaders] 改寫 img3→img2 並帶 Referer/UA 反盜鏈 header。
/// - 固定尺寸約束 + 圓角，避免載入時 layout shift。
/// - placeholder / error 皆為本地繪製 fallback（不使用 HTTP 佔位圖，規範 §5.1）。
class BookCover extends StatelessWidget {
  const BookCover({
    required this.url,
    this.width,
    this.height,
    this.aspectRatio = 3 / 4,
    this.radius = AppRadius.sm,
    super.key,
  });

  /// 原始封面 URL（可為 null/空 → 直接顯示 fallback）。
  final String? url;
  final double? width;
  final double? height;

  /// 未指定 [height] 時以 [width] × 此比例推算（書封預設 3:4）。
  final double aspectRatio;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final String raw = url?.trim() ?? '';
    final BorderRadius br = BorderRadius.circular(radius);
    return ClipRRect(
      borderRadius: br,
      child: SizedBox(
        width: width,
        height: height ?? (width == null ? null : width! / aspectRatio),
        child: raw.isEmpty
            ? const _CoverFallback()
            : _networkCover(ImageHeaders.rewriteCdn(raw)),
      ),
    );
  }

  Widget _networkCover(String finalUrl) => CachedNetworkImage(
    imageUrl: finalUrl,
    httpHeaders: ImageHeaders.headersFor(finalUrl),
    fit: BoxFit.cover,
    placeholder: (BuildContext context, String url) => const _CoverFallback(),
    errorWidget: (BuildContext context, String url, Object error) =>
        const _CoverFallback(),
  );
}

/// 封面 fallback：暗色底 + 書本圖示（本地繪製，無需二進位 asset）。
class _CoverFallback extends StatelessWidget {
  const _CoverFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.cov,
      child: Center(
        child: Icon(Icons.menu_book_outlined, color: AppColors.mut, size: 28),
      ),
    );
  }
}
