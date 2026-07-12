import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../core/app_config.dart';
import '../../../../core/session/auth_controller.dart';
import '../../domain/reader_block.dart';
import '../../domain/reader_text_utils.dart';
import '../../inline/reader_inline_parser.dart';
import 'reader_span_builder.dart';
import 'reader_style.dart';

/// 單一 [ReaderBlock] → widget。忠實移植自 api-ver `ReaderBlockView`。
/// 顏色/字級來自 [ReaderStyle]（主題 + 設定）。段落含黑幕點擊揭露；圖片點擊大圖預覽。
///
/// **web 適配**：
/// - 圖片載入改帶 tw.linovelib 反盜鏈 header（Referer/UA/Cookie，見 [_imageHeaders]），
///   不走 readpai CDN / `ImageHeaders`；web-ver 無 `cached_network_image`，插圖用
///   [Image.network]、大圖預覽用 [NetworkImage]。
/// - 大圖預覽用 photo_view（套件已在 pubspec）。
/// - 章末章評（[ChapterCommentBlock]）web 端不產生（誠實退化），渲染層略過。
class ReaderBlockView extends StatelessWidget {
  const ReaderBlockView({required this.block, required this.style, super.key});

  final ReaderBlock block;
  final ReaderStyle style;

  @override
  Widget build(BuildContext context) {
    switch (block) {
      case ChapterTitleBlock():
        // 沉浸式重設計「移除中央大標題」——章名只在頂列顯示。此 block 不渲染。
        return const SizedBox.shrink();
      case final ParagraphBlock b:
        return _ParagraphView(block: b, style: style);
      case final ImageBlock b:
        return _ImageView(block: b, style: style);
      case ChapterCommentBlock():
        // web 適配：tw.linovelib 無章末章評，內容層不產生此 block；渲染層退化為略過。
        return const SizedBox.shrink();
      case AdBlock():
        // web 端不產生章間廣告；保留空白佔位維持 sealed switch 窮盡。
        return const SizedBox(height: 60);
      case ReaderEndBlock():
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 28),
          child: Center(
            child: Text(
              '· 本章結束 ·',
              // web 適配：api-ver 用 AppTypography.fontSerif；web-ver 改 GoogleFonts.notoSerifTc。
              style: GoogleFonts.notoSerifTc(
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

/// 文字段落（含黑幕點擊揭露）。continuation 段：不縮排 + 半透明（design `.prose p.cont`）。
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
      // 續段是**正文**，0.4 透明對比不足未過 WCAG AA；提到 0.65 保留「續段較淡」意圖
      // 但達正文可讀門檻（蓄意偏離設計，api-ver golden 已核可）。
      text = Opacity(opacity: 0.65, child: text);
    }
    return Padding(
      padding: EdgeInsets.only(top: widget.style.paragraphTopPad),
      child: text,
    );
  }
}

/// 插圖：填滿內容寬，點擊開大圖預覽（photo_view）。
/// web 適配：帶 tw.linovelib 反盜鏈 header（否則 403），改用 [Image.network]（無 cached_network_image）。
class _ImageView extends StatelessWidget {
  const _ImageView({required this.block, required this.style});

  final ImageBlock block;
  final ReaderStyle style;

  /// 離線下載的插圖為本機絕對路徑（非 http）→ 走 Image.file。
  bool get _isLocal => !block.url.startsWith('http');

  @override
  Widget build(BuildContext context) {
    Widget errorBox(BuildContext c, Object e, StackTrace? s) => ColoredBox(
      color: style.textColor.withValues(alpha: 0.06),
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: style.textColor.withValues(alpha: 0.3),
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: GestureDetector(
        onTap: () => _openPreview(context),
        child: AspectRatio(
          aspectRatio: block.aspectRatio > 0 ? block.aspectRatio : 3 / 4,
          child: _isLocal
              ? Image.file(
                  File(block.url),
                  fit: BoxFit.fitWidth,
                  errorBuilder: errorBox,
                )
              : Image.network(
                  block.url,
                  headers: _imageHeaders(),
                  fit: BoxFit.fitWidth,
                  // 載入中佔位（對齊 api-ver placeholder：文字色淡底）。
                  loadingBuilder:
                      (BuildContext c, Widget child,
                          ImageChunkEvent? progress) =>
                          progress == null
                          ? child
                          : ColoredBox(
                              color: style.textColor.withValues(alpha: 0.06),
                            ),
                  // 載入失敗佔位（對齊 api-ver errorWidget：文字色淡底 + 破圖 icon）。
                  errorBuilder: errorBox,
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

/// 全螢幕插圖預覽（雙指縮放）。web 適配：網路圖用 [NetworkImage] 帶 tw.linovelib header；
/// 離線下載的本機圖用 [FileImage]。
class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final ImageProvider provider = url.startsWith('http')
        ? NetworkImage(url, headers: _imageHeaders())
        : FileImage(File(url));
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.of(context).maybePop(),
        child: PhotoView(
          imageProvider: provider,
          backgroundDecoration: const BoxDecoration(color: Colors.black),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 3,
        ),
      ),
    );
  }
}

/// tw.linovelib 圖片反盜鏈 header（web 適配：取代 api-ver `ImageHeaders.headersFor(url)`）。
/// Referer 用裸 origin、UA 與 dio/WebView 同源（cf_clearance 綁 UA）、Cookie 帶登入 session。
/// 與 reader_page.dart 舊碼 `_imgHeaders` 同一組表達式。
Map<String, String> _imageHeaders() => <String, String>{
  'Referer': AppConfig.origin,
  'User-Agent': AppConfig.userAgent,
  'Cookie': AuthController.instance.session?.cookieHeader ?? 'night=0',
};
