import 'inline/reader_inline_node.dart';
import 'inline/reader_inline_parser.dart';

/// 章節內容區塊：文字段落（保留富文本 HTML）或插圖。
///
/// 文字段內部改存**原始 HTML**（ruby/黑幕/傍点/顏色/sup/small 標籤保留），
/// 懶解析成 [inlines] 行內 AST 供富文本渲染；[plainText] 為去標籤後的可見文字，
/// 所有章內字元位移（書籤/進度）一律以 [plainText] 為準。
class ContentBlock {
  ContentBlock.text(String html)
      : _html = html,
        image = null;
  ContentBlock.image(this.image) : _html = null;

  final String? _html;
  final String? image;

  bool get isImage => image != null;

  /// 原始 HTML（文字段；圖片段為 null）。
  String? get html => _html;

  List<InlineNode>? _inlinesCache;

  /// 懶解析的行內 AST（僅文字段；圖片段回空）。
  List<InlineNode> get inlines {
    final String? h = _html;
    if (h == null) return const <InlineNode>[];
    return _inlinesCache ??= const ReaderInlineParser().parse(h);
  }

  /// 可見純文字（ruby→base、heimu→內容、`<br>`→`\n`）。圖片段為空字串。
  /// 章內 charOffset / 分頁量測一律以此為準。
  String get plainText => _html == null ? '' : visibleText(inlines);

  /// 過渡相容 getter：文字段回可見純文字、圖片段回 null。
  /// （舊呼叫點的 `.text`；富文本渲染改用 [inlines]，位移數學用 [plainText]。）
  String? get text => _html == null ? null : plainText;
}

/// 一整章（含分頁串接後）的內容。
class ChapterContent {
  const ChapterContent({required this.title, required this.blocks});
  final String? title;
  final List<ContentBlock> blocks;
}
