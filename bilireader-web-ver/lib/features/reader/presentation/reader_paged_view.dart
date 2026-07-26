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
    this.onFirstBlockIndex,
    this.initialFraction = 0,
    this.restoreBlockIndex,
    this.restoreSeq = 0,
    super.key,
  });

  final List<ReaderBlock> blocks;
  final ReaderStyle style;
  final ReaderSettings settings;
  final bool pageCurl;
  final ValueChanged<double> onFraction;

  /// 頁變動時回報「當前頁首個 block 的全域序號」，作為跨模式（垂直/翻頁）共用的書籤/進度錨點。
  final ValueChanged<int>? onFirstBlockIndex;
  final double initialFraction;

  /// 還原/跳轉目標 block 全域序號；每次 [restoreSeq] 遞增即跳到該 block 所在頁。以 block 序號
  /// （版面無關）定位，達成與垂直捲動模式的書籤互通。
  final int? restoreBlockIndex;
  final int restoreSeq;

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
  List<int> _pageStart = <int>[]; // _pageStart[i] = 第 i 頁首個 block 的全域序號（前綴和）
  PageController? _pageController;
  final PageCurlController _curlController = PageCurlController();
  bool _appliedInitial = false;
  late double _liveFraction = widget.initialFraction; // 目前頁比例（重分頁時保位）
  late int _appliedRestoreSeq = widget.restoreSeq; // 已套用的還原序號（避免重覆/模式切換誤跳）

  @override
  void dispose() {
    _pageController?.dispose();
    _curlController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ReaderPagedView old) {
    super.didUpdateWidget(old);
    // 書籤/跳轉：restoreSeq 遞增 → 跳到目標 block 所在頁（版面無關定位；同章 pages 已存在）。
    if (widget.restoreSeq != old.restoreSeq && widget.restoreBlockIndex != null) {
      _appliedRestoreSeq = widget.restoreSeq;
      final int page = _pageOfBlock(widget.restoreBlockIndex!);
      _liveFraction = _pages.length <= 1 ? 0 : page / (_pages.length - 1);
      _seekToPage(page);
    }
  }

  /// 全域 block 序號 → 所在頁序（[_pageStart] 非遞減）。
  ///
  /// 一個 block 被切成多頁時，那幾頁的起始索引是**同一個值**，此時要回傳**第一頁**
  /// （＝該 block 的開頭）。取「最後一個 ≤ blockIndex」會跳到該 block 的最後一頁，
  /// 還原書籤/進度時會直接略過整段開頭。
  int _pageOfBlock(int blockIndex) {
    if (_pageStart.isEmpty) return 0;
    int page = 0;
    for (int i = 0; i < _pageStart.length; i++) {
      if (_pageStart[i] > blockIndex) break;
      // 只在起始索引「變大」時前進 → 落在重複區段的第一頁。
      if (i == 0 || _pageStart[i] != _pageStart[i - 1]) page = i;
    }
    return page.clamp(0, _pages.length - 1);
  }

  void _seekToPage(int page) {
    if (_pages.length <= 1) return;
    final int target = page.clamp(0, _pages.length - 1);
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
    final ({List<List<ReaderBlock>> pages, List<int> pageStartOriginIndex})
    result = _paginator.paginateIndexed(widget.blocks, m);
    _pages = result.pages;
    // 每頁首個 block 的**原始** blocks 索引（跨模式錨點 blockIndex ↔ 頁序 的換算依據）。
    //
    // 必須向分頁器要，不能用「逐頁累加分頁後 block 數」自己算：長段會被切成多個
    // ParagraphBlock，分頁後的索引空間比原始的大，累加出來的值會隨切分次數單調偏移，
    // 而這個數字正是寫進 ReaderAnchor.blockIndex 的錨點。
    _pageStart = result.pageStartOriginIndex;
    if (_pages.isEmpty) {
      _pages = <List<ReaderBlock>>[widget.blocks];
      _pageStart = <int>[0];
    }
    // 有未套用的還原目標（書籤/進度）→ 跳到該 block 所在頁；否則以「目前頁比例」保住當前閱讀
    // 位置（字級/尺寸變更重分頁時）。
    final int initial;
    if (widget.restoreBlockIndex != null &&
        widget.restoreSeq != _appliedRestoreSeq) {
      _appliedRestoreSeq = widget.restoreSeq;
      initial = _pageOfBlock(widget.restoreBlockIndex!);
      _liveFraction = _pages.length <= 1 ? 0 : initial / (_pages.length - 1);
    } else {
      initial = (_liveFraction * (_pages.length - 1)).round().clamp(
        0,
        _pages.length - 1,
      );
    }
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
    // 先回報 blockIndex（讓上層在 onFraction 觸發存檔前已取到最新頁首 block），再回報頁比例。
    if (index >= 0 && index < _pageStart.length) {
      widget.onFirstBlockIndex?.call(_pageStart[index]);
    }
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
