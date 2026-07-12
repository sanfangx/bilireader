import 'package:flutter/foundation.dart';

/// 章節正文 domain。[text] 保留原文 HTML；[images] 為插圖清單。忠實移植自 api-ver。
///
/// web-ver 註記：內容不來自 readpai getNovelText，而由 `chapter_extractor`（WebView 擷取）
/// 產生；[text] 為擷取到的可見 innerHTML（含富文本標籤），圖片 URL 已由 extractor 正規化
/// （非 readpai 的 img3→img2 改寫）。OpenCC 不套用（tw.linovelib 本就繁體）。
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

/// 章節插圖（URL + 寬高比）。
@immutable
class ChapterImage {
  const ChapterImage({required this.url, required this.aspectRatio});

  final String url;
  final double aspectRatio;
}
