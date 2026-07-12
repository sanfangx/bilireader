import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/network/image_headers.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/carousel_slide.dart';

/// 首頁輪播 Banner（設計稿 `.caro`）：全寬 hero 圖卡 + 底部漸層 + 描述 + 頁碼點。
/// 使用原生 `PageView`（不引入額外套件，規範 §2）。
class CarouselBanner extends StatefulWidget {
  const CarouselBanner({required this.slides, super.key});

  final List<CarouselSlide> slides;

  @override
  State<CarouselBanner> createState() => _CarouselBannerState();
}

class _CarouselBannerState extends State<CarouselBanner> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<CarouselSlide> slides = widget.slides;
    return AspectRatio(
      // 設計稿 .caro：width(scr-44) : height 150 ≈ 16:9。
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.banner),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            PageView.builder(
              controller: _controller,
              itemCount: slides.length,
              onPageChanged: (int i) => setState(() => _index = i),
              itemBuilder: (BuildContext context, int i) =>
                  _Slide(slide: slides[i]),
            ),
            // 設計稿 .cdots：右下角。
            Positioned(
              right: 14,
              bottom: 14,
              child: _Dots(count: slides.length, index: _index),
            ),
          ],
        ),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({required this.slide});

  final CarouselSlide slide;

  @override
  Widget build(BuildContext context) {
    final String url = ImageHeaders.rewriteCdn(slide.coverUrl?.trim() ?? '');
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.pushNamed(
        AppRoutes.novelDetailName,
        pathParameters: <String, String>{'articleId': '${slide.articleId}'},
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          if (url.isEmpty)
            const ColoredBox(color: AppColors.cov)
          else
            CachedNetworkImage(
              imageUrl: url,
              httpHeaders: ImageHeaders.headersFor(url),
              fit: BoxFit.cover,
              placeholder: (_, _) => const ColoredBox(color: AppColors.cov),
              errorWidget: (_, _, _) => const ColoredBox(color: AppColors.cov),
            ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.transparent, Color(0xCC000000)],
                stops: <double>[0.45, 1],
              ),
            ),
          ),
          if ((slide.describe ?? '').isNotEmpty)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Text(
                slide.describe!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleMedium.copyWith(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(count, (int i) {
        final bool active = i == index;
        return AnimatedContainer(
          // F-22：reduce-motion 開啟時折為 Duration.zero（頁碼點不做縮放補間）。
          duration: AppMotion.durationOf(context, AppMotion.fast),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: active ? AppColors.acc : Colors.white54,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
