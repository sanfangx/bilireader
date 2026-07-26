import '../inline/reader_inline_node.dart';
import '../inline/reader_inline_parser.dart';
import 'reader_block.dart';
import 'reader_layout_metrics.dart';
import 'reader_split_support.dart';
import 'reader_text_utils.dart';

/// 高度量測抽象。分頁器只依賴此介面（純演算法可測）；具體以 `TextPainter` 實作（展示層，
/// 與渲染共用同一 span 產生器以確保「量測＝渲染」§7.3）。
abstract class BlockMeasurer {
  /// 段落文字（已 [readerDisplayText] 處理）在 [m].availableWidth 下的高度（含行距）。
  double measureParagraph(String displayHtml, ReaderLayoutMetrics m);

  /// 章名（24sp 粗體、寬 availableWidth−10、行距 0）高度。
  double measureTitle(String title, ReaderLayoutMetrics m);

  /// `findFittingTextOffset`：可容納於 [maxHeight] 的最大「可見字 offset」。
  int findFittingVisibleOffset(
    String displayHtml,
    ReaderLayoutMetrics m,
    double maxHeight,
  );
}

/// 分頁器（`ContentPaginator`，§7），忠實移植自 api-ver。**僅用於水平翻頁 / 仿真翻頁**；
/// 垂直連續滾動不分頁。貪婪裝箱；特殊 block（廣告/末尾/章評/圖片）獨佔一頁；章名開新頁；
/// 長段以 splitTextByLines 切分（補行內標籤平衡 + 更新 sourceOffset）。
class ReaderPaginator {
  const ReaderPaginator(this.measurer);

  final BlockMeasurer measurer;
  static const ReaderInlineParser _parser = ReaderInlineParser();

  List<List<ReaderBlock>> paginate(
    List<ReaderBlock> blocks,
    ReaderLayoutMetrics m,
  ) => paginateIndexed(blocks, m).pages;

  /// 分頁，並一併回傳 **每頁首個 block 對應的「原始 [blocks] 索引」**。
  ///
  /// 為什麼需要這個：長段會被 [_splitTextEntity] / [_splitTextByLines] 切成多個
  /// `ParagraphBlock`，所以「分頁後的 block 數」比原始多，兩者的索引空間**不一致**。
  /// 展示層若用「逐頁累加分頁後 block 數」當前綴和（舊作法），算出來的 blockIndex 會隨
  /// 切分次數單調偏移，而那個數字正是跨模式（垂直↔翻頁）共用的書籤/進度錨點
  /// ——偏移的結果是「翻頁模式存的位置，回到捲動模式還原時越跑越後面」。
  /// 故索引必須在分頁當下就記錄，而不是事後從結果推算。
  ///
  /// 同一個 block 跨多頁時，這幾頁的起始索引會是**同一個值**（重複），這是正確的：
  /// 它們的頁首確實都落在同一個原始 block 內。
  ({List<List<ReaderBlock>> pages, List<int> pageStartOriginIndex})
  paginateIndexed(List<ReaderBlock> blocks, ReaderLayoutMetrics m) {
    if (blocks.isEmpty) {
      return (pages: <List<ReaderBlock>>[], pageStartOriginIndex: <int>[]);
    }
    final _Packer pk = _Packer(m.availableHeight < 1 ? 1 : m.availableHeight);

    for (int i = 0; i < blocks.length; i++) {
      final ReaderBlock b = blocks[i];
      switch (b) {
        case AdBlock():
        case ReaderEndBlock():
        case ChapterCommentBlock():
        case ImageBlock():
          pk.ownPage(b, i);
        case ChapterTitleBlock():
          pk.flush();
          pk.add(b, _estimate(b, m, includeBottom: true), i);
        case final ParagraphBlock p:
          final double est = _estimate(p, m, includeBottom: true);
          if (pk.remaining >= est) {
            pk.add(p, est, i);
          } else if (pk.cur.isEmpty) {
            final List<ParagraphBlock> parts = _splitTextEntity(p, pk.avail, m);
            if (parts.isEmpty) {
              pk.add(p, est, i);
            } else {
              _addParts(pk, parts, m, i);
            }
          } else {
            final (ParagraphBlock? first, ParagraphBlock? second) =
                _splitTextByLines(p, pk.remaining, m);
            if (first != null) {
              pk.add(first, _estimate(first, m, includeBottom: false), i);
            }
            pk.flush();
            if (second != null) {
              final double est2 = _estimate(second, m, includeBottom: true);
              if (est2 > pk.avail) {
                _addParts(pk, _splitTextEntity(second, pk.avail, m), m, i);
              } else {
                pk.add(second, est2, i);
              }
            }
          }
      }
    }
    pk.flush();
    return (pages: pk.pages, pageStartOriginIndex: pk.pageOrigins);
  }

  /// `paginate$addTextPartsToPages`：逐 part 裝箱，溢出先封頁；每個 part（除最後）自成一頁。
  /// [origin] 為這些 part 共同來源的原始 block 索引（切片不產生新的原始 block）。
  void _addParts(
    _Packer pk,
    List<ParagraphBlock> parts,
    ReaderLayoutMetrics m,
    int origin,
  ) {
    for (int i = 0; i < parts.length; i++) {
      final ParagraphBlock part = parts[i];
      final double est = _estimate(
        part,
        m,
        includeBottom: i == parts.length - 1,
      );
      if (pk.cur.isNotEmpty && pk.h + est > pk.avail) pk.flush();
      pk.add(part, est, origin);
      if (i < parts.length - 1) pk.flush();
    }
  }

  double _estimate(
    ReaderBlock b,
    ReaderLayoutMetrics m, {
    required bool includeBottom,
  }) {
    switch (b) {
      case AdBlock():
      case ReaderEndBlock():
        return ReaderLayoutMetrics.adEndHeight;
      case ChapterCommentBlock():
        return ReaderLayoutMetrics.commentHeight;
      case ChapterTitleBlock(:final title):
        return measurer.measureTitle(title, m) + ReaderLayoutMetrics.titleExtra;
      case ImageBlock(:final aspectRatio):
        final double body = aspectRatio > 0
            ? m.availableWidth / aspectRatio
            : ReaderLayoutMetrics.imageDefaultHeight;
        return body + ReaderLayoutMetrics.imageExtra;
      case final ParagraphBlock p:
        final String display = readerDisplayText(
          p.html,
          p.continuation,
          p.centered,
        );
        return measurer.measureParagraph(display, m) +
            m.textTopPadding +
            (includeBottom ? m.textBottomPadding : 0);
    }
  }

  /// `splitTextEntity`：把超長段反覆 splitTextByLines 成多段（各 ≤ 一頁高）。
  List<ParagraphBlock> _splitTextEntity(
    ParagraphBlock entity,
    double availableHeight,
    ReaderLayoutMetrics m,
  ) {
    final List<ParagraphBlock> out = <ParagraphBlock>[];
    ParagraphBlock cur = entity;
    while (cur.html.isNotEmpty) {
      final (ParagraphBlock? first, ParagraphBlock? second) = _splitTextByLines(
        cur,
        availableHeight,
        m,
      );
      if (first != null) {
        out.add(first);
        if (second == null || second.html == cur.html) break;
        cur = second;
      } else {
        if (out.isEmpty) out.add(cur);
        break; // full-page 下 first==null 為退化情形，避免無窮迴圈。
      }
    }
    return out;
  }

  /// `splitTextByLines`（§7.4）：在 [remainingHeight] 內把段切成 (前半, 後半)。
  (ParagraphBlock?, ParagraphBlock?) _splitTextByLines(
    ParagraphBlock entity,
    double remainingHeight,
    ReaderLayoutMetrics m,
  ) {
    final String text = entity.html;
    if (text.isEmpty) return (null, entity);
    final String str = readerDisplayText(
      text,
      entity.continuation,
      entity.centered,
    );
    final int i5 = (entity.continuation || entity.centered) ? 0 : 2;
    final double avail1 = remainingHeight - m.textTopPadding;
    if (avail1 <= 0) return (null, entity);

    final String visible = visibleText(_parser.parse(str));
    final int fit = measurer.findFittingVisibleOffset(str, m, avail1);
    if (fit == 0) return (null, entity);
    if (fit >= visible.length) return (entity, null);

    final int mapOffset = mapReaderVisibleOffsetToOriginalText(str, fit);
    if (mapOffset <= i5) return (null, entity);

    final (String close, String open) = readerInlineTagBalanceForSplit(
      str,
      mapOffset,
    );
    final String str4 = str.substring(i5, mapOffset) + close;
    final String str5 = open + str.substring(mapOffset);
    final String first = str4.trim();
    final String second = str5.trim();
    final int length = str4.length - str4.trimLeft().length;
    final int length2 =
        (mapOffset - i5) + (str5.length - str5.trimLeft().length);
    final int i6 = length2 >= 0 ? length2 : 0;

    return (
      first.isEmpty
          ? null
          : entity.copyWith(
              html: first,
              sourceOffset: entity.sourceOffset + length,
            ),
      second.isEmpty
          ? null
          : entity.copyWith(
              html: second,
              continuation: true,
              sourceOffset: entity.sourceOffset + i6,
            ),
    );
  }
}

/// 分頁裝箱可變狀態。
class _Packer {
  _Packer(this.avail);

  final double avail;
  final List<List<ReaderBlock>> pages = <List<ReaderBlock>>[];

  /// 與 [pages] 等長：每頁首個 block 的**原始** blocks 索引（見 `paginateIndexed`）。
  final List<int> pageOrigins = <int>[];

  List<ReaderBlock> cur = <ReaderBlock>[];

  /// 目前這一頁首個 block 的原始索引（`cur` 為空時為 null）。
  int? curOrigin;
  double h = 0;

  double get remaining => avail - h;

  void flush() {
    if (cur.isNotEmpty) {
      pages.add(cur);
      pageOrigins.add(curOrigin ?? 0);
      cur = <ReaderBlock>[];
      curOrigin = null;
      h = 0;
    }
  }

  void add(ReaderBlock b, double est, int origin) {
    curOrigin ??= origin; // 只有頁首那一個決定本頁的原始索引
    cur.add(b);
    h += est;
  }

  void ownPage(ReaderBlock b, int origin) {
    flush();
    curOrigin = origin;
    cur.add(b);
    flush();
  }
}
