import '../../../core/text/chinese_converter.dart';
import '../domain/carousel_slide.dart';
import '../domain/novel_catalog.dart';
import '../domain/novel_summary.dart';
import 'dto/carousel_item.dart';
import 'dto/chapter_data.dart';
import 'dto/novel_response_entity.dart';

/// DTO → domain entity 映射，並集中處理 OpenCC 顯示轉繁（規範 §5.0）。
///
/// 只轉「使用者可見文字」欄位（書名、作者、簡介、標籤、輪播描述、卷/章名）；
/// 封面 URL 保持原始（顯示時由 `BookCover` 做 img3→img2 改寫），
/// 數值/id 一律不轉。
class NovelMapper {
  const NovelMapper(this._converter);

  final ChineseConverter _converter;

  NovelSummary toSummary(NovelResponseEntity e) => NovelSummary(
    articleId: e.articleId,
    title: _tw(e.articleName),
    author: _twNullable(e.author),
    translator: _twNullable(e.translator),
    illustrator: _twNullable(e.illustrator),
    coverUrl: e.cover,
    intro: _twNullable(e.intro),
    keywords: _twNullable(e.keywords),
    tags: e.tagList.map(_tw).toList(),
    lastVolume: _twNullable(e.lastVolume),
    isFinished: e.isFinished,
    rating: e.ratingAvg,
    ratingCount: e.rateNum,
    wordCount: e.words,
    totalVisits: e.allVisit,
    totalFlowers: e.allFlower,
    hot: e.hot,
  );

  List<NovelSummary> toSummaries(List<NovelResponseEntity> list) =>
      list.map(toSummary).toList();

  CarouselSlide toCarouselSlide(CarouselItem e) => CarouselSlide(
    articleId: e.articleId,
    coverUrl: e.coverImg,
    describe: _twNullable(e.describe),
  );

  /// 熱門搜尋 / 標籤等純字串清單轉繁。
  List<String> toTwList(List<String> raw) => raw.map(_tw).toList();

  /// `ChapterData`（遞迴樹）→ [NovelCatalog]（卷→章兩層）。
  /// 卷 = 有子章節的節點；VIP 以 `chaptertype` 判定（非 0 視為特殊/VIP）。
  NovelCatalog toCatalog(ChapterData data) {
    final List<CatalogVolume> volumes = <CatalogVolume>[];
    for (final ChapterRequestEntity node in data.chapters) {
      if (node.isVolume) {
        volumes.add(_toVolume(node));
      } else {
        // 無卷結構時，把散章歸入一個匿名卷，避免遺失。
        if (volumes.isEmpty || volumes.last.title != null) {
          volumes.add(const CatalogVolume(volumeId: 0));
        }
        final CatalogVolume last = volumes.removeLast();
        volumes.add(
          CatalogVolume(
            volumeId: last.volumeId,
            title: last.title,
            coverUrl: last.coverUrl,
            chapters: <CatalogChapter>[...last.chapters, _toChapter(node)],
          ),
        );
      }
    }
    return NovelCatalog(
      articleId: data.articleid,
      articleName: _twNullable(data.articlename),
      volumes: volumes,
    );
  }

  CatalogVolume _toVolume(ChapterRequestEntity vol) => CatalogVolume(
    volumeId: vol.chapterid,
    title: _twNullable(vol.chaptername),
    coverUrl: vol.cover,
    chapters: (vol.chapterList ?? const <ChapterRequestEntity>[])
        .map(_toChapter)
        .toList(),
  );

  CatalogChapter _toChapter(ChapterRequestEntity ch) => CatalogChapter(
    chapterId: ch.chapterid,
    title: _twNullable(ch.chaptername),
    wordCount: ch.words,
    isVip: ch.chaptertype != 0,
  );

  String _tw(String? text) =>
      (text == null || text.isEmpty) ? '' : _converter.toTraditionalTw(text);

  String? _twNullable(String? text) =>
      (text == null || text.isEmpty) ? text : _converter.toTraditionalTw(text);
}
