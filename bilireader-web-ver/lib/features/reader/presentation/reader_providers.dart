import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/models/catalog.dart';
import '../data/chapter_text_providers.dart';
import '../domain/chapter_text.dart';
import '../domain/reader_block.dart';
import '../domain/reader_content_builder.dart';

part 'reader_providers.g.dart';

/// 一章渲染所需內容：章名 + 區塊串。忠實對應 api-ver `ReaderChapterContent`。
@immutable
class ReaderChapterContent {
  const ReaderChapterContent({required this.chapterName, required this.blocks});

  final String chapterName;
  final List<ReaderBlock> blocks;
}

/// 指涉一個章節。web 適配：內容擷取需 [url]（api-ver 只用 articleId+chapterId 打 readpai API）；
/// 快取/進度/書籤鍵仍用 (articleId, chapterId)。[chapterName] 為目錄章名（擷取不到 title 時的備援）。
@immutable
class ChapterRef {
  const ChapterRef({
    required this.articleId,
    required this.chapterId,
    required this.url,
    this.chapterName = '',
  });

  final int articleId;
  final int chapterId;
  final String url;
  final String chapterName;

  @override
  bool operator ==(Object other) =>
      other is ChapterRef &&
      other.articleId == articleId &&
      other.chapterId == chapterId &&
      other.url == url &&
      other.chapterName == chapterName;

  @override
  int get hashCode => Object.hash(articleId, chapterId, url, chapterName);
}

/// 載入並建構某章內容：ChapterText（drift 快取優先，未命中 WebView 擷取）→ blocks。
///
/// web 適配（忠實對應 api-ver `readerChapterContent`，除下列）：
/// - `convert`＝identity（tw.linovelib 本繁體，不套 OpenCC）。
/// - `illustrationSpoiler`/`chapterCommentEnabled`＝false：兩者對 web 皆**惰性**（擷取合成的
///   ChapterText.isbody 恆 0 → 防劇透門檻不觸發；web 無章末章評）。故 blocks **只依章節本身**，
///   字級/行距/主題/防劇透設定變更都不會重建 blocks（自然滿足 api-ver 的「避免捲動歸零」優化）。
@riverpod
Future<ReaderChapterContent> readerChapterContent(
  Ref ref,
  ChapterRef chapter,
) async {
  final ChapterText text = await ref
      .watch(chapterTextRepositoryProvider)
      .getChapterText(
        articleId: chapter.articleId,
        chapterId: chapter.chapterId,
        url: chapter.url,
        chapterName: chapter.chapterName,
      );
  final List<ReaderBlock> blocks = const ReaderContentBuilder().build(
    text,
    convert: _identity,
    illustrationSpoiler: false,
    chapterCommentEnabled: false,
  );
  return ReaderChapterContent(chapterName: text.chapterName, blocks: blocks);
}

String _identity(String s) => s;

/// 目前章在攤平章節清單中的導覽資訊（上一章/下一章）。忠實對應 api-ver `ChapterNav`。
@immutable
class ChapterNav {
  const ChapterNav({
    required this.index,
    required this.count,
    this.prev,
    this.next,
  });

  final int index; // 0-based；-1 表未知
  final int count;
  final Chapter? prev;
  final Chapter? next;

  bool get hasPrev => prev != null;
  bool get hasNext => next != null;
}

/// 由「攤平章節清單 + 目前索引」計算導覽資訊。web 適配：直接吃 reader 已持有的 `List<Chapter>`
/// （api-ver 是由 NovelCatalog 攤平 + 依 chapterId 查）。跳過 url==null 的壞連結由呼叫端處理。
ChapterNav chapterNavAt(List<Chapter> chapters, int index) {
  final int count = chapters.length;
  if (index < 0 || index >= count) {
    return ChapterNav(index: -1, count: count);
  }
  return ChapterNav(
    index: index,
    count: count,
    prev: index > 0 ? chapters[index - 1] : null,
    next: index < count - 1 ? chapters[index + 1] : null,
  );
}
