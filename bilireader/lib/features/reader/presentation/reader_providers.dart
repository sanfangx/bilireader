import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/api_result.dart';
import '../../../core/text/chinese_converter.dart';
import '../../../core/text/text_providers.dart';
import '../../discover/domain/novel_catalog.dart';
import '../data/chapter_text_providers.dart';
import '../domain/chapter_text.dart';
import '../domain/reader_block.dart';
import '../domain/reader_content_builder.dart';
import '../domain/reader_settings.dart';
import 'reader_settings_providers.dart';

part 'reader_providers.g.dart';

/// 一章渲染所需內容：章名（已轉繁）+ 區塊串。
@immutable
class ReaderChapterContent {
  const ReaderChapterContent({required this.chapterName, required this.blocks});

  final String chapterName;
  final List<ReaderBlock> blocks;
}

/// 只影響 blocks 的設定子集：轉繁模式 / 防劇透 / 章末章評入口。**不含**字級/行距/段距/
/// 翻頁方式——故變更那些設定不會令 [readerChapterContent] 重建 blocks（避免字級滑桿每次
/// 重轉繁 + 內容 provider 進 loading 態導致 ListView 重建、捲動歸零）。
@riverpod
({ReaderConvertMode mode, bool spoiler, bool comment}) readerBlockSettings(
  Ref ref,
) {
  final ReaderSettings s = ref.watch(readerSettingsControllerProvider);
  return (
    mode: s.convertMode,
    spoiler: s.illustrationSpoiler,
    comment: s.chapterCommentEnabled,
  );
}

/// 載入並建構某章內容（doc 05 §0/§4）：ChapterText（快取優先）→ OpenCC（依 `convertMode`）→ blocks。
///
/// 只在 `convertMode`/`illustration_spoiler`/`chapter_comment_enabled` 變更時重建（字級/行距不影響 blocks）。
@riverpod
Future<ReaderChapterContent> readerChapterContent(
  Ref ref,
  int articleId,
  int chapterId,
) async {
  final ({ReaderConvertMode mode, bool spoiler, bool comment}) bs = ref.watch(
    readerBlockSettingsProvider,
  );
  final ReaderConvertMode mode = bs.mode;
  final bool spoiler = bs.spoiler;
  final bool comment = bs.comment;
  final ChineseConverter converter = ref.watch(chineseConverterProvider);
  await converter.ensureLoaded();
  String convert(String x) => mode == ReaderConvertMode.traditionalTw
      ? converter.toTraditionalTw(x)
      : converter.toTraditional(x);

  final ApiResult<ChapterText> res = await ref
      .watch(chapterTextRepositoryProvider)
      .getChapterText(articleId: articleId, chapterId: chapterId);
  final ChapterText chapter = res.dataOrThrow();

  final List<ReaderBlock> blocks = const ReaderContentBuilder().build(
    chapter,
    convert: convert,
    illustrationSpoiler: spoiler,
    chapterCommentEnabled: comment,
  );
  return ReaderChapterContent(
    chapterName: convert(chapter.chapterName),
    blocks: blocks,
  );
}

/// 目錄攤平為跨卷的有序章節清單（供上一章/下一章導覽）。
List<CatalogChapter> flattenCatalogChapters(NovelCatalog catalog) =>
    <CatalogChapter>[
      for (final CatalogVolume v in catalog.volumes) ...v.chapters,
    ];

/// 目前章在攤平清單中的導覽資訊。
@immutable
class ChapterNav {
  const ChapterNav({
    required this.index,
    required this.count,
    this.prevChapterId,
    this.nextChapterId,
  });

  final int index; // 0-based；-1 表未知
  final int count;
  final int? prevChapterId;
  final int? nextChapterId;
}

/// 由目錄計算某章的導覽資訊。
ChapterNav chapterNavOf(NovelCatalog catalog, int chapterId) {
  final List<CatalogChapter> all = flattenCatalogChapters(catalog);
  final int idx = all.indexWhere(
    (CatalogChapter c) => c.chapterId == chapterId,
  );
  return ChapterNav(
    index: idx,
    count: all.length,
    prevChapterId: idx > 0 ? all[idx - 1].chapterId : null,
    nextChapterId: idx >= 0 && idx < all.length - 1
        ? all[idx + 1].chapterId
        : null,
  );
}
