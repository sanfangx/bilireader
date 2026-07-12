import 'chapter_text.dart';
import 'reader_block.dart';
import 'reader_text_utils.dart';

/// `<img …src="…"…>` 擷取 regex。group(1)=src。
final RegExp _imgRe = RegExp('''<img\\s+[^>]*src=["']([^"']*)["'][^>]*>''');

/// 把 [ChapterText] 轉成 [ReaderBlock] 串。忠實移植自 api-ver `buildContent`。
///
/// 管線順序：先轉換整段（[convert]）→ 依換行切段（行內標籤感知）→ 擷取 `<img>`。
/// web-ver 註記：[convert] 傳 identity（tw.linovelib 本就繁體，不套 OpenCC）；
/// [chapterCommentEnabled] 恆 false（web 無章末章評）；ChapterText.text 由
/// `chapter_extractor` 擷取結果合成（見 Step 3 內容橋接）。
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

    // 整章皆圖（isImage）：把 images[] 全部塞入，不受防劇透限制。
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

    // 章末章評入口（web 端恆關）。
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
