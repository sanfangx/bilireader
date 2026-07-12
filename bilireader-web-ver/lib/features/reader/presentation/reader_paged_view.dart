import 'package:flutter/material.dart';

import '../domain/reader_block.dart';
import '../domain/reader_layout_metrics.dart';
import '../domain/reader_paginator.dart';
import '../domain/reader_settings.dart';
import 'page_curl/simulation_page_curl.dart';
import 'render/reader_block_measurer.dart';
import 'render/reader_block_view.dart';
import 'render/reader_style.dart';

/// 水平翻頁 / 仿真捲頁的分頁內容。忠實移植自 api-ver（web 適配：移除章評回呼——web 無章評）。
/// 以 [ReaderPaginator] + [TextPainterBlockMeasurer] 把 blocks 分成頁，`horizontal`→`PageView`、
/// `page_curl`→`SimulationPageCurl`。頁進度以「頁序 / 總頁數」回報 [onFraction]；[initialFraction]
/// 供還原。分頁結果以 key 記憶化。
class ReaderPagedView extends StatefulWidget {
  const ReaderPagedView({
    required this.blocks,
    required this.style,
    required this.settings,
    required this.pageCurl,
    required this.onFraction,
    this.initialFraction = 0,
    super.key,
  });

  final List<ReaderBlock> blocks;
  final ReaderStyle style;
  final ReaderSettings settings;
  final bool pageCurl;
  final ValueChanged<double> onFraction;
  final double initialFraction;

  @override
  State<ReaderPagedView> createState() => _ReaderPagedViewState();
}

class _ReaderPagedViewState extends State<ReaderPagedView> {
  static const ReaderPaginator _paginator = ReaderPaginator(
    TextPainterBlockMeasurer(),
  );
  static const double _hPad = 26; // .rd padding 0 26px
  static const double _vPad = 8;
  static const double _safety = 28; // ruby/傍点 額外高度 + 呼吸邊界

  Object? _key;
  List<List<ReaderBlock>> _pages = <List<ReaderBlock>>[];
  PageController? _pageController;
  final PageCurlController _curlController = PageCurlController();
  bool _appliedInitial = false;
  late double _liveFraction = widget.initialFraction; // 目前頁比例（重分頁時保位）

  @override
  void dispose() {
    _pageController?.dispose();
    _curlController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ReaderPagedView old) {
    super.didUpdateWidget(old);
    // 還原進度於章載入後（async）才到達；initialFraction 改變 → 同步跳至目標頁。
    if (widget.initialFraction != old.initialFraction) {
      _liveFraction = widget.initialFraction;
      _seekToFraction(_liveFraction);
    }
  }

  void _seekToFraction(double frac) {
    if (_pages.length <= 1) return;
    final int target = (frac * (_pages.length - 1)).round().clamp(
      0,
      _pages.length - 1,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.pageCurl) {
        _curlController.jumpTo(target);
      } else if (_pageController?.hasClients ?? false) {
        _pageController!.jumpToPage(target);
      }
    });
  }

  void _paginate(double width, double height) {
    final Object key = Object.hashAll(<Object>[
      identityHashCode(widget.blocks),
      widget.pageCurl,
      widget.settings.fontFamily,
      widget.settings.fontSize,
      widget.settings.lineSpacingDp,
      widget.settings.paragraphSpacingDp,
      width.round(),
      height.round(),
    ]);
    if (key == _key) return;
    _key = key;
    final ReaderLayoutMetrics m = ReaderLayoutMetrics(
      fontFamily: widget.settings.fontFamily.family,
      fontSizePx: widget.settings.fontSize,
      lineExtraPx: widget.settings.lineSpacingDp.toDouble(),
      paragraphDp: widget.settings.paragraphSpacingDp,
      availableWidth: width - _hPad * 2,
      availableHeight: height - _vPad * 2 - _safety,
    );
    _pages = _paginator.paginate(widget.blocks, m);
    if (_pages.isEmpty) _pages = <List<ReaderBlock>>[widget.blocks];
    // 以「目前頁比例」定位，重分頁（字級/尺寸變更）時保住當前閱讀位置。
    final int initial = (_liveFraction * (_pages.length - 1)).round().clamp(
      0,
      _pages.length - 1,
    );
    _pageController?.dispose();
    _pageController = PageController(initialPage: initial);
    _appliedInitial = false;
    if (widget.pageCurl) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_appliedInitial) {
          _appliedInitial = true;
          _curlController.jumpTo(initial);
        }
      });
    }
  }

  void _onPage(int index) {
    final int count = _pages.length;
    _liveFraction = count <= 1 ? 0 : index / (count - 1);
    widget.onFraction(_liveFraction);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) {
        _paginate(c.maxWidth, c.maxHeight);
        Widget page(int i) => _PageContent(blocks: _pages[i], style: widget.style);
        if (widget.pageCurl) {
          return SimulationPageCurl(
            controller: _curlController,
            itemCount: _pages.length,
            backgroundColor: widget.style.bgColor,
            onIndexChanged: _onPage,
            tapToTurn: false, // tap 交給上層切換控制列；拖曳仍翻頁
            itemBuilder: (BuildContext ctx, int i) => page(i),
          );
        }
        return PageView.builder(
          controller: _pageController,
          onPageChanged: _onPage,
          itemCount: _pages.length,
          itemBuilder: (BuildContext ctx, int i) => page(i),
        );
      },
    );
  }
}

/// 單頁內容（不可捲動；分頁已保證塞得下，溢出以裁切避免 RenderFlex 例外）。
class _PageContent extends StatelessWidget {
  const _PageContent({required this.blocks, required this.style});

  final List<ReaderBlock> blocks;
  final ReaderStyle style;

  @override
  Widget build(BuildContext context) {
    // SafeArea 由 ReaderPage 依控制列可見性統一處理。
    return ClipRect(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for (final ReaderBlock b in blocks)
              ReaderBlockView(
                key: ValueKey<String>('${b.chapterId}:${b.sourceOffset}'),
                block: b,
                style: style,
              ),
          ],
        ),
      ),
    );
  }
}
