import 'package:flutter/foundation.dart';

/// 首頁輪播項 domain entity（規範 §4.3）。[describe] 已於 data 層轉繁（§5.0）。
@immutable
class CarouselSlide {
  const CarouselSlide({required this.articleId, this.coverUrl, this.describe});

  final int articleId;
  final String? coverUrl;
  final String? describe;
}
