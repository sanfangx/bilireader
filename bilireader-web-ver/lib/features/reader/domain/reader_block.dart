import 'package:flutter/foundation.dart';

/// 閱讀器內容區塊（sealed union）。純資料模型，供分頁與渲染消費。忠實移植自 api-ver。
///
/// [sourceOffset] = 該段在整章可見文字中的字元偏移，用於書籤/進度定位。
/// web-ver 註記：內容來自 WebView 逐 `<p>` innerHTML，sourceOffset 以「章內可見文字累加」計；
/// `ChapterCommentBlock`（章末章評）與 `AdBlock`（章間廣告）為 readpai 專屬，**web 端不產生**
/// （型別保留以維持 switch 窮盡；渲染層對 ChapterCommentBlock 退化為書評連結或略過）。
@immutable
sealed class ReaderBlock {
  const ReaderBlock({
    required this.articleId,
    required this.chapterId,
    required this.sourceOffset,
  });

  final int articleId;
  final int chapterId;
  final int sourceOffset;
}

/// 章名標題（每章開頭一筆，大字粗體）。
class ChapterTitleBlock extends ReaderBlock {
  const ChapterTitleBlock({
    required super.articleId,
    required super.chapterId,
    required this.title,
    super.sourceOffset = 0,
  });

  final String title;

  @override
  bool operator ==(Object other) =>
      other is ChapterTitleBlock &&
      other.articleId == articleId &&
      other.chapterId == chapterId &&
      other.title == title;

  @override
  int get hashCode => Object.hash(articleId, chapterId, title);

  @override
  String toString() => 'ChapterTitleBlock($title)';
}

/// 文字段落。[html] 保留行內 HTML（`<ruby>`/`<heimu>`/`<span>`…），渲染層以
/// `ReaderInlineParser` 解析。[centered] 由置中判定；[continuation] 表被分頁切出的後半段。
class ParagraphBlock extends ReaderBlock {
  const ParagraphBlock({
    required super.articleId,
    required super.chapterId,
    required this.html,
    required super.sourceOffset,
    this.centered = false,
    this.continuation = false,
  });

  final String html;
  final bool centered;
  final bool continuation;

  ParagraphBlock copyWith({
    String? html,
    bool? centered,
    bool? continuation,
    int? sourceOffset,
  }) => ParagraphBlock(
    articleId: articleId,
    chapterId: chapterId,
    html: html ?? this.html,
    sourceOffset: sourceOffset ?? this.sourceOffset,
    centered: centered ?? this.centered,
    continuation: continuation ?? this.continuation,
  );

  @override
  bool operator ==(Object other) =>
      other is ParagraphBlock &&
      other.articleId == articleId &&
      other.chapterId == chapterId &&
      other.html == html &&
      other.centered == centered &&
      other.continuation == continuation &&
      other.sourceOffset == sourceOffset;

  @override
  int get hashCode => Object.hash(
    articleId,
    chapterId,
    html,
    centered,
    continuation,
    sourceOffset,
  );

  @override
  String toString() =>
      'ParagraphBlock(html: $html, centered: $centered, cont: $continuation, off: $sourceOffset)';
}

/// 插圖（獨佔一頁）。[aspectRatio]<=0 時渲染用預設比例。
class ImageBlock extends ReaderBlock {
  const ImageBlock({
    required super.articleId,
    required super.chapterId,
    required this.url,
    required this.aspectRatio,
    required super.sourceOffset,
  });

  final String url;
  final double aspectRatio;

  @override
  bool operator ==(Object other) =>
      other is ImageBlock &&
      other.articleId == articleId &&
      other.chapterId == chapterId &&
      other.url == url &&
      other.aspectRatio == aspectRatio;

  @override
  int get hashCode => Object.hash(articleId, chapterId, url, aspectRatio);

  @override
  String toString() => 'ImageBlock($url, ar: $aspectRatio)';
}

/// 章末「章評」入口頁（readpai 專屬；web 端不產生）。
class ChapterCommentBlock extends ReaderBlock {
  const ChapterCommentBlock({
    required super.articleId,
    required super.chapterId,
    super.sourceOffset = 0,
  });

  @override
  bool operator ==(Object other) =>
      other is ChapterCommentBlock &&
      other.articleId == articleId &&
      other.chapterId == chapterId;

  @override
  int get hashCode => Object.hash(articleId, chapterId, 'comment');

  @override
  String toString() => 'ChapterCommentBlock()';
}

/// 閱讀間廣告頁（readpai 專屬；web 端不產生）。
class AdBlock extends ReaderBlock {
  const AdBlock({
    required super.articleId,
    required super.chapterId,
    super.sourceOffset = 0,
  });

  @override
  bool operator ==(Object other) =>
      other is AdBlock &&
      other.articleId == articleId &&
      other.chapterId == chapterId;

  @override
  int get hashCode => Object.hash(articleId, chapterId, 'ad');

  @override
  String toString() => 'AdBlock()';
}

/// 章/全書邊界末尾頁（獨佔一頁）。
class ReaderEndBlock extends ReaderBlock {
  const ReaderEndBlock({
    required super.articleId,
    required super.chapterId,
    super.sourceOffset = 0,
  });

  @override
  bool operator ==(Object other) =>
      other is ReaderEndBlock &&
      other.articleId == articleId &&
      other.chapterId == chapterId;

  @override
  int get hashCode => Object.hash(articleId, chapterId, 'end');

  @override
  String toString() => 'ReaderEndBlock()';
}
