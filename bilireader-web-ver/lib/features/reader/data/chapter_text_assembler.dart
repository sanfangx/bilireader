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
///
/// ⚠️ 這只擋得住「空」，擋不住「被截斷」——見 [containsTruncationMarker]。
bool hasRenderableContent(ChapterContent content) => content.blocks.any(
  (ContentBlock b) => b.isImage || (b.html?.trim().isNotEmpty ?? false),
);

/// 站方「信任分級截斷」的標記字串（2026-07-25 實測確認）。
///
/// tw.linovelib / m.bilinovel / www.bilinovel 對**不受信任的用戶端**只送出約 1/3 段落，
/// 在正文中途硬切後接上這些字串；受信任的用戶端則收到完整內容、完全不含這些字串。
/// 分野在**用戶端指紋**（TLS/JA3 等），與 cookie 無關——實測 `credentials:'omit'` 的
/// 瀏覽器請求（不送任何 cookie，含 cf_clearance）照樣拿到完整內容。
///
/// 繁簡並列：`tw.` 送繁體、`m./www.` 送簡體。
const List<String> kTruncationMarkers = <String>[
  '內容加載失敗',
  '内容加载失败',
  '暫不支持電腦端閱讀',
  '暂不支持电脑端阅读',
];

/// 正文是否含站方截斷標記。
///
/// **為什麼需要這道獨立的檢查**：截斷版是合法 HTML、帶著數十段真實內文，會直接通過
/// [hasRenderableContent]（「非空即有效」），於是被當成正常章節寫進 drift 快取與離線檔
/// **永久固化**——使用者之後每次開都是殘缺的，且沒有任何錯誤徵兆。故「非空」不等於
/// 「有效」，必須另外驗證正向的完整性訊號。
///
/// 這道檢查**必須排在段落順序閘門之前**：順序閘門比對的是「DOM 順序 vs 伺服器順序」，
/// 截斷版兩邊同樣截斷、順序照樣會被還原，驗不出內容少了 2/3。
bool containsTruncationMarker(String text) =>
    kTruncationMarkers.any(text.contains);

/// 判定終端截斷時往回檢視的文字段數。
///
/// 不能只看「最後一段」：實測的截斷尾巴是
/// `<p>要……（內容加載失敗！…）<br><br><center>【…暫不支持電腦端…】</center>`，
/// 而 `<center>` 是區塊級元素會讓 HTML 解析器提前關閉 `<p>`，兩個標記因此可能落在
/// 相鄰的不同 block。
const int kTailBlocksToInspect = 3;

/// [ChapterContent] 是否為**終端截斷**（正文中途被切斷、尾端接上站方標記）。
///
/// ⚠️ **鐵律：標記是證據，不是判決**（見 convention「Never pre-block chapters based on
/// HTML markers」）。站方慣於用誤導性標記勸退爬蟲——過去是目錄裡的假 VIP 鎖與壞掉的
/// `javascript:cid()` 連結，同一套手法完全可能把「內容加載失敗」字樣當誘餌塞進**完整**
/// 內容裡。若見字即擋，好章節會被整個封鎖，使用者毫無繞道——這正是當初被明令禁止的
/// 失敗模式。
///
/// 故只認**終端截斷**：標記出現在最後 [kTailBlocksToInspect] 個文字段之內，才視為
/// 「內容在此被切斷」。標記出現在中段 → 判定為誘餌/正常內文，**照常放行**。
///
/// 且即使判定為截斷，也只用來**拒絕寫入快取**與**提示使用者**，
/// 絕不剝奪閱讀——已擷取到的部分仍可由使用者明確選擇閱讀（見
/// `ChapterContentTruncatedException.partial`）。
bool looksTruncated(ChapterContent content) {
  final List<String> texts = content.blocks
      .where((ContentBlock b) => !b.isImage)
      .map((ContentBlock b) => b.html ?? '')
      .where((String h) => h.trim().isNotEmpty)
      .toList();
  if (texts.isEmpty) return false;
  final Iterable<String> tail = texts.skip(
    texts.length > kTailBlocksToInspect ? texts.length - kTailBlocksToInspect : 0,
  );
  return tail.any(containsTruncationMarker);
}

/// 已**合成**的整章文字（`ChapterText.text`）是否為終端截斷。
///
/// ⚠️ 必須與 [looksTruncated] 保持**同一套「只認終端」語意與同一種粒度**。若讀取端比
/// 寫入端嚴格（例如掃描整份內容），中段帶標記的章節就會「寫入時放行、讀取時判壞」→
/// 每次開啟都刪快取重抓，永遠命不中且毫無徵兆。
///
/// 實作對齊：合成時各 block 以 `\n` 串接（見 [ChapterTextAssembler.assemble]），故這裡
/// 反向以 `\n` 切回段落再取尾端 [kTailBlocksToInspect] 段。**不可**改用「尾端 N 個字元」
/// —— 短章節會使字元窗涵蓋全文，等同退回「掃描整份內容」而重新引入上述迴圈。
///
/// 若 block 內部本身含換行，切出的段數會多於 block 數，尾端窗因而涵蓋**較少**內容
/// → 偏寬鬆。這是刻意選的方向：漏抓只是留下一筆壞快取（使用者可用「重新擷取」／
/// 「清除章節快取」處理），誤抓卻會變成永久重抓迴圈。
///
/// **已知落差**：偵測上線前寫入的多分頁舊快取，其截斷標記可能停在整章中段（當時的
/// 擷取器不會在截斷頁停止翻頁），此規則抓不到 —— 同樣交由上述兩個自救入口處理。
bool assembledTailLooksTruncated(String text) {
  final List<String> parts = text
      .split('\n')
      .where((String s) => s.trim().isNotEmpty)
      .toList();
  if (parts.isEmpty) return false;
  return parts
      .skip(
        parts.length > kTailBlocksToInspect
            ? parts.length - kTailBlocksToInspect
            : 0,
      )
      .any(containsTruncationMarker);
}
