import '../content_block.dart';
import '../domain/chapter_text.dart';

/// Step 3 內容橋接「方案 (a)」：把 WebView 擷取的 [ChapterContent]（`ContentBlock` 串）
/// 合成 api-ver 內容管線期望的 [ChapterText]（`text` = 整章 HTML），供
/// `ReaderContentBuilder` 再切塊 —— 重用 api-ver 的切行/圖片/去重/置中邏輯。
///
/// 合成規則（**保留 DOM 順序**）：文字段輸出其富文本 innerHTML；圖片段輸出
/// `<img src="URL">`；段間以 `\n` 分隔（對齊 `splitTextByNewLine`）。圖片另收進 `images[]`
/// （web 端無寬高比 → 0，由渲染層實測）。tw.linovelib 本繁體 → 不套 OpenCC；無章末章評。
///
/// 註：extractor 的 `ser()` 已把 `<img>` 從文字段剔除、獨立成圖片段，故文字段 html 不含
/// `<img>`；合成後 `text` 中唯一的 `<img>` 即本組譯器輸出者，`ReaderContentBuilder` 可正確擷取。
class ChapterTextAssembler {
  const ChapterTextAssembler();

  ChapterText assemble({
    required int articleId,
    required int chapterId,
    required String chapterName,
    required ChapterContent content,
  }) {
    final List<String> parts = <String>[];
    final List<ChapterImage> images = <ChapterImage>[];
    for (final ContentBlock b in content.blocks) {
      if (b.isImage) {
        final String url = b.image ?? '';
        if (url.isEmpty) continue;
        parts.add('<img src="$url">');
        images.add(ChapterImage(url: url, aspectRatio: 0));
      } else {
        final String html = b.html ?? '';
        if (html.isEmpty) continue;
        parts.add(html);
      }
    }
    final String? title = content.title?.trim();
    return ChapterText(
      articleId: articleId,
      chapterId: chapterId,
      chapterName: (title != null && title.isNotEmpty) ? title : chapterName,
      text: parts.join('\n'),
      images: images,
    );
  }
}

/// 章節是否有可渲染內容。false 多為 **VIP 鎖章 / 空章**：不應寫入快取、也不應當成正常空章
/// 直接顯示（應由展示層提示登入/購買或重試）。
bool hasRenderableContent(ChapterContent content) => content.blocks.any(
  (ContentBlock b) => b.isImage || (b.html?.trim().isNotEmpty ?? false),
);
