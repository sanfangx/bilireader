import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../core/network/image_headers.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/reader_block.dart';
import '../../domain/reader_inline_parser.dart';
import '../../domain/reader_text_utils.dart';
import 'reader_span_builder.dart';
import 'reader_style.dart';

/// 單一 [ReaderBlock] → widget（doc 05 §11.4；design「閱讀器 .prose」）。
/// 顏色/字級來自 [ReaderStyle]（主題 + 設定）。段落含黑幕點擊揭露；圖片點擊大圖預覽。
class ReaderBlockView extends StatelessWidget {
  const ReaderBlockView({
    required this.block,
    required this.style,
    this.onChapterComment,
    super.key,
  });

  final ReaderBlock block;
  final ReaderStyle style;
  final VoidCallback? onChapterComment;

  @override
  Widget build(BuildContext context) {
    switch (block) {
      case ChapterTitleBlock():
        // 沉浸式重設計「移除中央大標題」——章名只在頂列 .rdch 顯示。此 block 不渲染。
        return const SizedBox.shrink();
      case final ParagraphBlock b:
        return _ParagraphView(block: b, style: style);
      case final ImageBlock b:
        return _ImageView(block: b, style: style);
      case ChapterCommentBlock():
        return _ChapterCommentEntry(style: style, onTap: onChapterComment);
      case AdBlock():
        return const SizedBox(height: 60);
      case ReaderEndBlock():
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 28),
          child: Center(
            child: Text(
              '· 本章結束 ·',
              style: TextStyle(
                fontFamily: AppTypography.fontSerif,
                fontSize: 13,
                color: style.textColor.withValues(alpha: 0.5),
                letterSpacing: 2,
              ),
            ),
          ),
        );
    }
  }
}

/// 文字段落（含黑幕點擊揭露）。continuation 段：不縮排 + 40% 透明（design `.prose p.cont`）。
class _ParagraphView extends StatefulWidget {
  const _ParagraphView({required this.block, required this.style});

  final ParagraphBlock block;
  final ReaderStyle style;

  @override
  State<_ParagraphView> createState() => _ParagraphViewState();
}

class _ParagraphViewState extends State<_ParagraphView>
    with AutomaticKeepAliveClientMixin {
  static const ReaderInlineParser _parser = ReaderInlineParser();
  static const ReaderSpanBuilder _builder = ReaderSpanBuilder();
  final Set<int> _revealed = <int>{};

  // 已揭露黑幕的段落保活，避免捲離/重分頁後 reveal 遺失。
  @override
  bool get wantKeepAlive => _revealed.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin 要求
    final ParagraphBlock b = widget.block;
    final String display = readerDisplayText(
      b.html,
      b.continuation,
      b.centered,
    );
    final InlineSpan span = _builder.build(
      _parser.parse(display),
      widget.style,
      revealedHeimu: _revealed,
      onHeimuTap: (int i) {
        setState(() => _revealed.add(i));
        updateKeepAlive();
      },
    );
    Widget text = Text.rich(
      span,
      strutStyle: widget.style.strut,
      textAlign: b.centered ? TextAlign.center : TextAlign.start,
    );
    if (b.continuation) {
      // F-25：續段是**正文**，0.4 透明（design `.prose p.cont`）對比不足未過 WCAG AA。
      // 提到 0.65 保留「續段較淡」意圖但達正文可讀門檻（蓄意偏離設計，golden 已核可）。
      text = Opacity(opacity: 0.65, child: text);
    }
    return Padding(
      padding: EdgeInsets.only(top: widget.style.paragraphTopPad),
      child: text,
    );
  }
}

/// 插圖：填滿內容寬，點擊開大圖預覽（photo_view）。帶 Referer header（§11.2，否則 403）。
class _ImageView extends StatelessWidget {
  const _ImageView({required this.block, required this.style});

  final ImageBlock block;
  final ReaderStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: GestureDetector(
        onTap: () => _openPreview(context),
        child: AspectRatio(
          aspectRatio: block.aspectRatio > 0 ? block.aspectRatio : 3 / 4,
          child: CachedNetworkImage(
            imageUrl: block.url,
            httpHeaders: ImageHeaders.headersFor(block.url),
            fit: BoxFit.fitWidth,
            placeholder: (BuildContext c, String u) =>
                ColoredBox(color: style.textColor.withValues(alpha: 0.06)),
            errorWidget: (BuildContext c, String u, Object e) => ColoredBox(
              color: style.textColor.withValues(alpha: 0.06),
              child: Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  color: style.textColor.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openPreview(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push<void>(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, _, _) => _ImagePreview(url: block.url),
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.of(context).maybePop(),
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(
            url,
            headers: ImageHeaders.headersFor(url),
          ),
          backgroundDecoration: const BoxDecoration(color: Colors.black),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 3,
        ),
      ),
    );
  }
}

/// 章末「章節評論」入口（點擊開章評面板，⑨f 接線）。
class _ChapterCommentEntry extends StatelessWidget {
  const _ChapterCommentEntry({required this.style, this.onTap});

  final ReaderStyle style;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color line = style.textColor.withValues(alpha: 0.18);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: line),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.chat_bubble_outline,
                size: 18,
                color: style.textColor.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 10),
              Text(
                '查看本章評論',
                style: TextStyle(
                  fontFamily: AppTypography.fontSerif,
                  fontSize: 14,
                  color: style.textColor.withValues(alpha: 0.85),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: style.textColor.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
