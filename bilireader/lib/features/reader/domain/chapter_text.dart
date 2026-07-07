import 'package:flutter/foundation.dart';

/// 章節正文 domain（`getNovelText`）。[text] 保留伺服器原文 HTML（未轉繁）——OpenCC 於
/// 顯示層依 `chinese_convert_mode` 設定套用（§5.0、§5.4：轉換先於分頁），使快取與轉換模式解耦。
/// [images] 的 URL 已做 img3→img2/attachment 改寫（穩定轉換，非模式相關）。
@immutable
class ChapterText {
  const ChapterText({
    required this.articleId,
    required this.chapterId,
    required this.chapterName,
    required this.text,
    this.images = const <ChapterImage>[],
    this.isImage = false,
    this.isbody = 0,
  });

  final int articleId;
  final int chapterId;
  final String chapterName;
  final String text;
  final List<ChapterImage> images;
  final bool isImage;
  final int isbody;
}

/// 章節插圖（URL 已改寫 + 寬高比）。
@immutable
class ChapterImage {
  const ChapterImage({required this.url, required this.aspectRatio});

  final String url;
  final double aspectRatio;
}
