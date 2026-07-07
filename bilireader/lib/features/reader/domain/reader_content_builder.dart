import 'chapter_text.dart';
import 'reader_block.dart';
import 'reader_text_utils.dart';

/// `<img …src="…"…>` 擷取 regex（`NovelReadActivity.java:1540`，§4.1，務必照抄）。group(1)=src。
final RegExp _imgRe = RegExp('''<img\\s+[^>]*src=["']([^"']*)["'][^>]*>''');

/// 把 [ChapterText] 轉成 [ReaderBlock] 串（`buildContent`，§4）。
///
/// 管線順序（不可更動）：**先 OpenCC 轉換整段 → 再依換行切段（行內標籤感知）→ 再擷取
/// `<img>`**。轉換函式由外部注入（[convert]，來自 `ChineseConverter`，依 `chinese_convert_mode`）。
/// [illustrationSpoiler] 開啟且 `isbody>0` 時，正文插圖只顯示前 `isbody` 張（防劇透，§4.4）。
class ReaderContentBuilder {
  const ReaderContentBuilder();

  List<ReaderBlock> build(
    ChapterText chapter, {
    required String Function(String) convert,
    required bool illustrationSpoiler,
    required bool chapterCommentEnabled,
  }) {
    final int aid = chapter.articleId;
    final int cid = chapter.chapterId;
    final List<ReaderBlock> out = <ReaderBlock>[];

    // 沉浸式重設計「移除中央大標題」——章名只在頂列顯示，正文不再插入 ChapterTitleBlock
    // （對原生 buildContent 的**設計取捨**：章名由 readerChapterContent 另行提供給頂列）。

    // images[] → Map（key 為改寫後 URL；normalize 對已改寫者為 no-op）。
    final Map<String, ChapterImage> byUrl = <String, ChapterImage>{
      for (final ChapterImage img in chapter.images)
        normalizeImageUrl(img.url): img,
    };

    // 先轉換整段，再切段。
    final String converted = convert(chapter.text);
    final List<String> lines = splitTextByNewLine(converted);

    final Set<String> seen = <String>{};
    int imgCount = 0;
    int offset = 0;
    for (final String line in lines) {
      final int lineOffset = offset;
      offset += line.length + 1; // 補回被吃掉的 '\n'

      final List<RegExpMatch> matches = _imgRe.allMatches(line).toList();
      if (matches.isEmpty) {
        out.add(
          ParagraphBlock(
            articleId: aid,
            chapterId: cid,
            html: line,
            centered: isReaderCenterLine(line),
            sourceOffset: lineOffset,
          ),
        );
      } else {
        for (final RegExpMatch m in matches) {
          final String url = normalizeImageUrl(m.group(1) ?? '');
          if (url.isEmpty || !seen.add(url)) continue;
          // 防劇透門檻（整章皆圖不受限，於下方另行處理）。
          if (illustrationSpoiler &&
              chapter.isbody > 0 &&
              imgCount >= chapter.isbody) {
            continue;
          }
          imgCount++;
          out.add(
            ImageBlock(
              articleId: aid,
              chapterId: cid,
              url: url,
              aspectRatio: byUrl[url]?.aspectRatio ?? 0.0,
              sourceOffset: lineOffset,
            ),
          );
        }
      }
    }

    // 整章皆圖（isImage）：把 images[] 全部塞入，不受防劇透限制（§4.4）。
    if (chapter.isImage) {
      for (final ChapterImage img in chapter.images) {
        final String url = normalizeImageUrl(img.url);
        if (url.isEmpty || !seen.add(url)) continue;
        out.add(
          ImageBlock(
            articleId: aid,
            chapterId: cid,
            url: url,
            aspectRatio: img.aspectRatio,
            sourceOffset: offset,
          ),
        );
      }
    }

    // 章末章評入口。
    if (chapterCommentEnabled) {
      out.add(
        ChapterCommentBlock(
          articleId: aid,
          chapterId: cid,
          sourceOffset: offset,
        ),
      );
    }
    return out;
  }
}
