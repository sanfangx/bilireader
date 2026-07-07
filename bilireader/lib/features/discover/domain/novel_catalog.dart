import 'package:flutter/foundation.dart';

/// 章節目錄 domain entity（規範 §4.3，對照 doc 10 §4）。卷/章名已於 data 層轉繁（§5.0）。
///
/// 後端 `ChapterRequestEntity` 為遞迴樹（卷含子章節）；domain 拆為明確的
/// [CatalogVolume] → [CatalogChapter] 兩層，presentation 直接消費。
@immutable
class NovelCatalog {
  const NovelCatalog({
    required this.articleId,
    this.articleName,
    this.volumes = const <CatalogVolume>[],
  });

  final int articleId;
  final String? articleName;
  final List<CatalogVolume> volumes;

  /// 全書章節總數（不含卷節點）。
  int get chapterCount =>
      volumes.fold(0, (int sum, CatalogVolume v) => sum + v.chapters.length);
}

/// 目錄中的一卷。
@immutable
class CatalogVolume {
  const CatalogVolume({
    required this.volumeId,
    this.title,
    this.coverUrl,
    this.chapters = const <CatalogChapter>[],
  });

  /// 卷節點的 `chapterid`（卷層級時可能為卷 ID）。
  final int volumeId;
  final String? title;
  final String? coverUrl;
  final List<CatalogChapter> chapters;
}

/// 目錄中的一章。
@immutable
class CatalogChapter {
  const CatalogChapter({
    required this.chapterId,
    this.title,
    this.wordCount = 0,
    this.isVip = false,
  });

  final int chapterId;
  final String? title;
  final int wordCount;

  /// VIP 章節（`chaptertype` 語意；以 data 層判定）。
  final bool isVip;
}
