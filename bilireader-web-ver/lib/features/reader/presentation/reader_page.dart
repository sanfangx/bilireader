import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/models/catalog.dart';
import '../../../core/network/linovelib_api.dart';
import '../../../core/reading/local_store.dart' show LocalStore, ReadProgress;
import '../../../core/storage/database/database_providers.dart';
import '../../../theme/app_colors.dart';
import '../data/bookmark_local_data_source.dart';
import '../domain/bookmark.dart';
import '../domain/reader_anchor.dart';
import '../domain/reader_block.dart';
import '../domain/reader_settings.dart';
import '../domain/reader_theme.dart';
import '../domain/reading_progress.dart';
import '../domain/reading_progress_repository.dart';
import '../inline/reader_inline_node.dart';
import '../inline/reader_inline_parser.dart';
import '../reading_progress_providers.dart';
import 'panels/reader_bookmark_sheet.dart';
import 'panels/reader_settings_sheets.dart';
import 'reader_paged_view.dart';
import 'reader_providers.dart';
import 'reader_settings_providers.dart';
import 'render/reader_block_view.dart';
import 'render/reader_style.dart';

/// 沉浸式閱讀器主頁。忠實移植自 api-ver（垂直捲動 / 水平翻頁 / 仿真捲頁三模式、點擊中央切換
/// 控制列、上/下章、本機進度與書籤保存/還原）。
///
/// **web 適配**：
/// - 導覽改 **index-based**：收攤平 `List<Chapter>` + startIndex（catalog_page 已有），不抓
///   novelCatalog；`_index` 為目前位置，chapterId/url 由 `chapters[_index]` 推出。
/// - 內容走 `readerChapterContent(ChapterRef{articleId,chapterId,url,chapterName})`（WebView 擷取）。
/// - 章末章評（readpai 專屬）**移除**；目錄改為 reader 內章節清單彈窗。
/// - go_router → Navigator；owner uid 由 [readerOwnerUid]（AuthController，訪客 0＝不持久化）。
class ReaderPage extends ConsumerStatefulWidget {
  const ReaderPage({
    required this.articleId,
    required this.chapters,
    required this.startIndex,
    this.articleName = '',
    this.poster = '',
    super.key,
  });

  final int articleId;
  final List<Chapter> chapters;
  final int startIndex;
  final String articleName;

  /// 封面 URL（供本機進度存檔 → 書架「繼續閱讀」縮圖）。空時掛載期由既有進度回填。
  final String poster;

  @override
  ConsumerState<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends ConsumerState<ReaderPage>
    with WidgetsBindingObserver {
  static const ReaderInlineParser _parser = ReaderInlineParser();

  late int _index = widget.startIndex.clamp(0, widget.chapters.length - 1);
  bool _barsVisible = true;
  final ScrollController _scroll = ScrollController();

  // 捲動進度保存防抖（滾動停止後 500ms 寫入，合併過密寫入）。切章/翻頁/書籤跳轉/dispose/
  // App 進背景一律立即 flush（_saveProgressNow）。
  Timer? _saveDebounce;
  final GlobalKey _listKey = GlobalKey();
  final Map<int, GlobalKey> _blockKeys = <int, GlobalKey>{};
  int _blockCount = 0;
  List<ReaderBlock> _blocks = const <ReaderBlock>[];

  final int _ownerUid = readerOwnerUid(); // 訪客/未登入 = 0（不持久化）
  late String _poster = widget.poster;
  int _restoredChapterId = -1;
  String _chapterName = '';
  late final String _articleName = widget.articleName;
  String _quote = '';

  // 掛載期擷取 repository（keepAlive 單例），供 dispose() 存進度用（dispose 內禁碰 ref）。
  late final ReadingProgressRepository _progressRepo;

  // null-url 章（站方目錄給 javascript:cid(N) 假連結）沿閱讀鏈解析後的真實 URL 快取。
  // 值為空字串＝解析失敗（避免無限重試）。
  final Map<int, String> _resolvedUrls = <int, String>{};
  bool _resolving = false;

  static final RegExp _cidRe = RegExp(r'/(\d+)(?:_\d+)?\.html');

  /// 目前章可用的 URL（原始或已解析）；仍需解析時回 null。
  String? get _effectiveUrl {
    final String? u = widget.chapters[_index].url;
    if (u != null && u.isNotEmpty) return u;
    final String? r = _resolvedUrls[_index];
    return (r != null && r.isNotEmpty) ? r : null;
  }

  int get _chapterId {
    final int? direct = int.tryParse(widget.chapters[_index].id ?? '');
    if (direct != null) return direct;
    // null-url 章：從解析後 URL 取章 cid。
    final String? u = _effectiveUrl;
    if (u == null) return 0;
    return int.tryParse(_cidRe.firstMatch(u)?.group(1) ?? '') ?? 0;
  }

  ChapterRef get _chapterRef => ChapterRef(
    articleId: widget.articleId,
    chapterId: _chapterId,
    url: _effectiveUrl ?? '',
    chapterName: widget.chapters[_index].title,
  );

  /// 目前章是否仍待解析真實 URL（站方假連結）。
  bool get _needsUrlResolve {
    final String? u = widget.chapters[_index].url;
    return (u == null || u.isEmpty) && !_resolvedUrls.containsKey(_index);
  }

  /// 沿閱讀鏈解析 null-url 章的真實 URL；完成後 setState 觸發重建。空字串＝失敗。
  Future<void> _resolveUrlIfNeeded(int index) async {
    if (_resolving || _resolvedUrls.containsKey(index)) return;
    final String? u = widget.chapters[index].url;
    if (u != null && u.isNotEmpty) return;
    _resolving = true;
    final String? resolved =
        await LinovelibApi.instance.resolveBrokenChapterUrl(
      widget.chapters,
      index,
    );
    if (!mounted) return;
    setState(() {
      _resolvedUrls[index] = resolved ?? '';
      _resolving = false;
    });
  }

  bool get _canPersist => _ownerUid > 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _progressRepo = ref.read(readingProgressRepositoryProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || !_canPersist) return;
      // 入口未帶封面時，回填既有進度封面（避免以空封面覆蓋）。
      if (_poster.isEmpty) {
        final ReadingProgress? existing =
            await _progressRepo.get(_ownerUid, widget.articleId);
        if (!mounted) return;
        if (_poster.isEmpty && (existing?.poster.isNotEmpty ?? false)) {
          _poster = existing!.poster;
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _saveDebounce?.cancel();
    _saveProgressNow(); // 卸載前 flush 最後一筆。
    _scroll.dispose();
    super.dispose();
  }

  /// App 進背景（paused/hidden/detached）時 flush 進度。inactive 屬轉場態不 flush。
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      _saveProgressNow();
    }
  }

  void _scheduleSave() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 500), _saveProgressNow);
  }

  void _toggleBars() => setState(() => _barsVisible = !_barsVisible);

  double _fraction = 0; // 章內進度 0–1（垂直=捲動比例；分頁=頁序比例）
  double _restoreFraction = 0;

  double _scrollFraction() =>
      _scroll.hasClients && _scroll.position.maxScrollExtent > 0
      ? (_scroll.offset / _scroll.position.maxScrollExtent).clamp(0.0, 1.0)
      : 0.0;

  /// 切到攤平清單的第 [i] 章（上/下章）。
  void _goToIndex(int i) {
    if (i < 0 || i >= widget.chapters.length) return;
    _saveProgressNow();
    _blockKeys.clear();
    setState(() {
      _index = i;
      _fraction = 0;
      _restoreFraction = 0;
      _restoredChapterId = -1;
    });
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  /// 目前位置的跨模式錨點：章 + 目前可見首個 block 序號 + 章內比例 + 附近繁體片段。
  ReaderAnchor _currentAnchor() {
    final int now = DateTime.now().millisecondsSinceEpoch;
    return ReaderAnchor(
      articleId: widget.articleId,
      chapterId: _chapterId,
      chapterName: _chapterName,
      sourceTextOffset: 0,
      blockIndex: _firstVisibleBlockIndex() ?? 0,
      progressInChapter: _fraction,
      textQuote: _visibleQuote(),
      createdAt: now,
      updatedAt: now,
    );
  }

  String _visibleQuote() {
    final int? idx = _firstVisibleBlockIndex();
    if (idx != null && idx >= 0) {
      for (int i = idx; i < _blocks.length && i < idx + 4; i++) {
        final String q = _blockQuoteText(_blocks[i]);
        if (q.isNotEmpty) return q;
      }
    }
    return _quote;
  }

  /// 垂直模式：目前 viewport 頂端的 ReaderBlock 序號（量測 block key）。
  int? _firstVisibleBlockIndex() {
    final RenderObject? listRo = _listKey.currentContext?.findRenderObject();
    if (listRo is! RenderBox || !listRo.attached) return null;
    final double viewTop = listRo.localToGlobal(Offset.zero).dy;
    int? straddle;
    double straddleTop = double.negativeInfinity;
    int? firstBuilt;
    double firstTop = double.infinity;
    _blockKeys.forEach((int i, GlobalKey k) {
      final RenderObject? ro = k.currentContext?.findRenderObject();
      if (ro is! RenderBox || !ro.attached) return;
      final double t = ro.localToGlobal(Offset.zero).dy;
      if (t < firstTop) {
        firstTop = t;
        firstBuilt = i;
      }
      if (t <= viewTop + 8 && t > straddleTop) {
        straddleTop = t;
        straddle = i;
      }
    });
    return straddle ?? firstBuilt;
  }

  void _scrollToBlock(int index, {double fallbackFrac = 0}) {
    if (_scroll.hasClients &&
        _scroll.position.maxScrollExtent > 0 &&
        _blockCount > 0) {
      final double est = (index / _blockCount).clamp(0.0, 1.0);
      _scroll.jumpTo(est * _scroll.position.maxScrollExtent);
    }
    _ensureBlockVisible(index, 0, fallbackFrac);
  }

  void _ensureBlockVisible(int index, int tries, double fallbackFrac) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      final BuildContext? ctx = _blockKeys[index]?.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(ctx);
      } else if (tries < 8) {
        _ensureBlockVisible(index, tries + 1, fallbackFrac);
      } else if (fallbackFrac > 0 && _scroll.position.maxScrollExtent > 0) {
        _scroll.jumpTo(fallbackFrac * _scroll.position.maxScrollExtent);
      }
    });
  }

  void _saveProgressNow() {
    _saveDebounce?.cancel();
    if (_chapterName.isEmpty) return;
    // 相容層：同步寫舊 `LocalStore`（書架「繼續閱讀」目前讀此，章級位置）。與 drift 富錨點並存，
    // 直到書架遷到 `continueReading`(drift) provider 為止。訪客也寫（LocalStore 非 owner-scoped）。
    LocalStore.instance.saveProgress(
      ReadProgress(
        novelId: widget.articleId.toString(),
        title: _articleName,
        chapterIndex: _index,
        totalChapters: widget.chapters.length,
        chapterTitle: _chapterName,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
        cover: _poster.isEmpty ? null : _poster, // 書架續讀卡縮圖（不依賴分組清單）
      ),
    );
    // drift：富錨點（章內精準位置 + 書架未來遷移用）。僅登入者（owner-scoped）。
    if (!_canPersist) return;
    final ReaderAnchor anchor = _currentAnchor();
    _progressRepo.save(
      ReadingProgress(
        ownerUid: _ownerUid,
        anchor: anchor,
        articleName: _articleName,
        poster: _poster,
        updatedAt: anchor.updatedAt,
      ),
    );
  }

  // ---- 書籤（本機）：頂列旗標開啟書籤面板（加入 / 刪除 / 點選跳回）----

  double? _pendingRestoreFraction;
  int? _pendingRestoreBlockIndex;

  BookmarkLocalDataSource get _bookmarks =>
      BookmarkLocalDataSource(ref.read(bookmarkDaoProvider));

  Future<void> _openBookmarks() async {
    if (!_canPersist) {
      _toast('請先登入');
      return;
    }
    await showReaderBookmarkSheet(
      context,
      dataSource: _bookmarks,
      ownerUid: _ownerUid,
      articleId: widget.articleId,
      articleName: _articleName,
      currentAnchor: _currentAnchor,
      onJump: _jumpToBookmark,
    );
  }

  /// 跳到書籤位置：同章→依 blockIndex/比例還原；異章→切到該章後由 _onChapterLoaded 還原。
  void _jumpToBookmark(Bookmark b) {
    final int cid = b.anchor.chapterId;
    final int blockIdx = b.anchor.blockIndex;
    final double frac = b.anchor.progressInChapter;
    if (cid == _chapterId) {
      setState(() => _fraction = _restoreFraction = frac);
      _restoreVerticalPosition(blockIdx, frac);
      return;
    }
    // 異章：在攤平清單找到該 chapterId 的位置。
    final int target = widget.chapters.indexWhere(
      (Chapter c) => (int.tryParse(c.id ?? '') ?? -1) == cid,
    );
    if (target < 0) return;
    _pendingRestoreBlockIndex = blockIdx > 0 ? blockIdx : null;
    _pendingRestoreFraction = frac;
    setState(() {
      _index = target;
      _fraction = frac;
      _restoreFraction = frac;
      _restoredChapterId = -1;
    });
    _blockKeys.clear();
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  void _restoreVerticalPosition(int blockIndex, double frac) {
    final bool vertical =
        ref.read(readerSettingsControllerProvider).scrollMode ==
        ReaderScrollMode.vertical;
    if (!vertical) return;
    if (blockIndex > 0) {
      _scrollToBlock(blockIndex, fallbackFrac: frac);
    } else if (frac > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scroll.hasClients && _scroll.position.maxScrollExtent > 0) {
          _scroll.jumpTo(frac * _scroll.position.maxScrollExtent);
        }
      });
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }

  /// 章內容載入後：擷取章名/片段、還原捲動位置（若同章有進度）、記錄目前章。
  Future<void> _onChapterLoaded(ReaderChapterContent content) async {
    _chapterName = content.chapterName;
    _blocks = content.blocks;
    _quote = _firstQuote(content.blocks);
    _blockCount = content.blocks.length;
    if (_restoredChapterId == _chapterId) return;
    _restoredChapterId = _chapterId;

    if (_canPersist) {
      final ReadingProgress? saved =
          await _progressRepo.get(_ownerUid, widget.articleId);
      if (!mounted) return;
      final bool sameChapter = saved?.anchor.chapterId == _chapterId;
      final int blockIdx = _pendingRestoreBlockIndex ??
          (sameChapter ? (saved?.anchor.blockIndex ?? 0) : 0);
      final double frac = _pendingRestoreFraction ??
          (sameChapter ? (saved?.anchor.progressInChapter ?? 0) : 0);
      _pendingRestoreBlockIndex = null;
      _pendingRestoreFraction = null;
      if (mounted) setState(() => _fraction = _restoreFraction = frac);
      _restoreVerticalPosition(blockIdx, frac);
    }
    _saveProgressNow();
  }

  String _firstQuote(List<ReaderBlock> blocks) {
    for (final ReaderBlock b in blocks) {
      final String q = _blockQuoteText(b);
      if (q.isNotEmpty) return q;
    }
    return '';
  }

  String _blockQuoteText(ReaderBlock b) {
    if (b is ParagraphBlock) {
      final String v = visibleText(_parser.parse(b.html)).trim();
      if (v.isNotEmpty) return v.length > 34 ? v.substring(0, 34) : v;
    }
    return '';
  }

  /// reader 內章節清單彈窗（取代 api-ver 的目錄路由）。點選跳章。
  void _openCatalog() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surf,
      barrierColor: AppColors.scrim,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (BuildContext _) => _ChapterListSheet(
        chapters: widget.chapters,
        currentIndex: _index,
        onSelect: (int i) {
          Navigator.of(context).maybePop();
          if (i != _index) _goToIndex(i);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ReaderSettings settings = ref.watch(readerSettingsControllerProvider);
    final ReaderTheme theme = ref.watch(readerThemeControllerProvider).active;
    final ReaderStyle style = ReaderStyle.from(settings, theme);

    // null-url 章（站方 javascript:cid 假連結）：先沿閱讀鏈解析真實 URL，解析中顯示 loading。
    if (_needsUrlResolve) {
      _resolveUrlIfNeeded(_index); // async；完成後 setState 重建（不在 build 內 setState）
      // 解析中也保留返回鍵——假連結章解析可能失敗/久候，使用者永遠能逃離（不卡死路）。
      return Scaffold(
        backgroundColor: style.bgColor,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Center(child: CircularProgressIndicator(color: style.textColor)),
              Positioned(
                left: 4,
                top: 4,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: style.textColor),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final ChapterRef chapterRef = _chapterRef;
    final AsyncValue<ReaderChapterContent> content = ref.watch(
      readerChapterContentProvider(chapterRef),
    );
    final ChapterNav nav = chapterNavAt(widget.chapters, _index);

    ref.listen<AsyncValue<ReaderChapterContent>>(
      readerChapterContentProvider(chapterRef),
      (
        AsyncValue<ReaderChapterContent>? prev,
        AsyncValue<ReaderChapterContent> next,
      ) {
        next.whenData(_onChapterLoaded);
      },
    );

    return Scaffold(
      backgroundColor: style.bgColor,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: content.when(
              skipLoadingOnReload: true,
              loading: () => Center(
                child: CircularProgressIndicator(color: style.textColor),
              ),
              error: (Object e, StackTrace _) => _ErrorView(
                style: style,
                onRetry: () =>
                    ref.invalidate(readerChapterContentProvider(chapterRef)),
                onPrev: nav.hasPrev ? () => _goToIndex(_index - 1) : null,
                onNext: nav.hasNext ? () => _goToIndex(_index + 1) : null,
                onCatalog: _openCatalog,
              ),
              data: (ReaderChapterContent c) =>
                  _buildReader(c, nav, style, settings),
            ),
          ),
          if (settings.dimLevel > 0)
            Positioned.fill(
              child: IgnorePointer(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: settings.dimLevel),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReader(
    ReaderChapterContent content,
    ChapterNav nav,
    ReaderStyle style,
    ReaderSettings settings,
  ) {
    final Widget inner = switch (settings.scrollMode) {
      ReaderScrollMode.vertical => NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification n) {
          if (n is ScrollEndNotification) {
            setState(() => _fraction = _scrollFraction());
            _scheduleSave();
          }
          return false;
        },
        child: ListView.builder(
          key: _listKey,
          controller: _scroll,
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 8),
          itemCount: content.blocks.length,
          itemBuilder: (BuildContext ctx, int i) {
            final ReaderBlock b = content.blocks[i];
            return ReaderBlockView(
              key: _blockKeys.putIfAbsent(i, () => GlobalKey()),
              block: b,
              style: style,
            );
          },
        ),
      ),
      ReaderScrollMode.horizontal ||
      ReaderScrollMode.pageCurl => ReaderPagedView(
        key: ValueKey<String>('$_chapterId-${settings.scrollMode.wire}'),
        blocks: content.blocks,
        style: style,
        settings: settings,
        pageCurl: settings.scrollMode == ReaderScrollMode.pageCurl,
        initialFraction: _restoreFraction,
        onFraction: (double f) {
          setState(() => _fraction = f);
          _saveProgressNow();
        },
      ),
    };

    final Widget contentArea = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: settings.tapCenterTogglesBars ? _toggleBars : null,
      child: SafeArea(top: !_barsVisible, bottom: !_barsVisible, child: inner),
    );

    return Column(
      children: <Widget>[
        if (_barsVisible)
          _ReaderTopBar(
            style: style,
            chapterName: content.chapterName,
            onBack: () => Navigator.of(context).maybePop(),
            onBookmark: _openBookmarks,
            onCatalog: _openCatalog,
          ),
        Expanded(
          key: const ValueKey<String>('reader-content'),
          child: contentArea,
        ),
        if (_barsVisible)
          _ReaderFootBar(
            style: style,
            nav: nav,
            progress: _fraction,
            onFont: () => showReaderFontSheet(context),
            onTheme: () => showReaderThemeSheet(context),
            onCatalog: _openCatalog,
            onPrev: nav.hasPrev ? () => _goToIndex(_index - 1) : null,
            onNext: nav.hasNext ? () => _goToIndex(_index + 1) : null,
          ),
      ],
    );
  }
}

/// 頂列：返回 + 章名 + 書籤/目錄（web 移除章評鈕）。
class _ReaderTopBar extends StatelessWidget {
  const _ReaderTopBar({
    required this.style,
    required this.chapterName,
    required this.onBack,
    required this.onBookmark,
    required this.onCatalog,
  });

  final ReaderStyle style;
  final String chapterName;
  final VoidCallback onBack;
  final VoidCallback onBookmark;
  final VoidCallback onCatalog;

  @override
  Widget build(BuildContext context) {
    final Color fg = style.textColor.withValues(alpha: 0.65);
    return Material(
      color: style.bgColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 1, 6, 1),
          child: Row(
            children: <Widget>[
              _icon(Icons.arrow_back_ios_new, onBack, fg, '返回'),
              Expanded(
                child: Text(
                  chapterName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: style.textColor.withValues(alpha: 0.85),
                  ),
                ),
              ),
              _icon(Icons.bookmark_border, onBookmark, fg, '書籤'),
              _icon(Icons.menu, onCatalog, fg, '目錄'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _icon(
    IconData i,
    VoidCallback onTap,
    Color c,
    String semanticLabel, {
    double size = 19,
  }) => MergeSemantics(
    child: Semantics(
      button: true,
      label: semanticLabel,
      child: InkResponse(
        onTap: onTap,
        radius: 22,
        child: SizedBox.square(
          dimension: 44,
          child: Center(child: Icon(i, size: size, color: c)),
        ),
      ),
    ),
  );
}

/// 底列：進度條 + 「第 N 章 / 共 M 章」「本機 X%」 + 5 工具。
class _ReaderFootBar extends StatelessWidget {
  const _ReaderFootBar({
    required this.style,
    required this.nav,
    required this.progress,
    required this.onFont,
    required this.onTheme,
    required this.onCatalog,
    required this.onPrev,
    required this.onNext,
  });

  final ReaderStyle style;
  final ChapterNav nav;
  final double progress;
  final VoidCallback onFont;
  final VoidCallback onTheme;
  final VoidCallback onCatalog;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    const Color acc = AppColors.acc;
    final Color mut = style.textColor.withValues(alpha: 0.55);
    return Material(
      color: style.bgColor,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 3,
                  backgroundColor: style.textColor.withValues(alpha: 0.12),
                  valueColor: const AlwaysStoppedAnimation<Color>(acc),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    nav.index >= 0
                        ? '第 ${nav.index + 1} 章 / 共 ${nav.count} 章'
                        : '',
                    style: GoogleFonts.spaceGrotesk(fontSize: 10.5, color: mut),
                  ),
                  Text(
                    '本機 ${(progress * 100).round()}%',
                    style: GoogleFonts.spaceGrotesk(fontSize: 10.5, color: mut),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _RTool(glyph: 'Aa', label: '字體', onTap: onFont, style: style),
                  _RTool(glyph: '☾', label: '主題', onTap: onTheme, style: style),
                  _RTool(glyph: '≡', label: '目錄', onTap: onCatalog, style: style),
                  _RTool(glyph: '⇤', label: '上一章', onTap: onPrev, style: style),
                  _RTool(glyph: '⇥', label: '下一章', onTap: onNext, style: style),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RTool extends StatelessWidget {
  const _RTool({
    required this.glyph,
    required this.label,
    required this.onTap,
    required this.style,
  });

  final String glyph;
  final String label;
  final VoidCallback? onTap;
  final ReaderStyle style;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onTap != null;
    final Color c = style.textColor.withValues(alpha: enabled ? 0.75 : 0.25);
    return MergeSemantics(
      child: Semantics(
        button: enabled,
        label: label,
        child: InkResponse(
          onTap: onTap,
          radius: 30,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ExcludeSemantics(
                  child: Text(
                    glyph,
                    style: TextStyle(fontSize: 15, color: c, height: 1.0),
                  ),
                ),
                const SizedBox(height: 3),
                ExcludeSemantics(
                  child: Text(label, style: TextStyle(fontSize: 9.5, color: c)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// reader 內章節清單彈窗（web 適配：取代 api-ver 的目錄路由）。
/// 開啟時自動捲到目前章節（620 章大書尤其有感）；兩種列固定高度，故初始位移可精確估算。
class _ChapterListSheet extends StatefulWidget {
  const _ChapterListSheet({
    required this.chapters,
    required this.currentIndex,
    required this.onSelect,
  });

  final List<Chapter> chapters;
  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  State<_ChapterListSheet> createState() => _ChapterListSheetState();
}

class _ChapterListSheetState extends State<_ChapterListSheet> {
  static const double _chapterH = 52; // 章節列固定高度
  static const double _headerH = 34; // 卷標題列固定高度

  late final List<_TocRow> _rows = _buildRows();
  late final ScrollController _controller =
      ScrollController(initialScrollOffset: _initialOffset());

  /// 攤平章節清單 → 顯示列：卷名變動處插入標題列，章節流水號於每卷重置。
  /// 無 [Chapter.volumeName]（如離線清單）時不插標題，流水號連續＝全書序號。
  List<_TocRow> _buildRows() {
    final List<_TocRow> rows = <_TocRow>[];
    String? lastVol;
    int localNum = 0;
    for (int i = 0; i < widget.chapters.length; i++) {
      final String? vn = widget.chapters[i].volumeName;
      if (vn != null && vn.isNotEmpty && vn != lastVol) {
        rows.add(_TocRow.header(vn));
        lastVol = vn;
        localNum = 0;
      }
      localNum++;
      rows.add(_TocRow.chapter(i, localNum));
    }
    return rows;
  }

  /// 目前章節列之上所有列的固定高度總和，減 2 章高讓目前章不貼頂。
  /// 列高固定 → 估算精確，不會累積誤差把目前章捲出畫面。超出範圍時 ListView 於佈局夾制。
  double _initialOffset() {
    final int cur = _rows.indexWhere(
        (r) => !r.isHeader && r.chapterIndex == widget.currentIndex);
    if (cur <= 0) return 0;
    double off = 0;
    for (int r = 0; r < cur; r++) {
      off += _rows[r].isHeader ? _headerH : _chapterH;
    }
    off -= _chapterH * 2;
    return off < 0 ? 0 : off;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: <Widget>[
                  Text(
                    '目錄',
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.txt,
                      letterSpacing: 0.6,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '共 ${widget.chapters.length} 章',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 11,
                      color: AppColors.mut,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.line),
            Flexible(
              child: ListView.builder(
                controller: _controller,
                itemCount: _rows.length,
                itemBuilder: (BuildContext ctx, int r) {
                  final _TocRow row = _rows[r];
                  if (row.isHeader) return _volumeHeader(row.name!);

                  final int i = row.chapterIndex;
                  final bool current = i == widget.currentIndex;
                  return SizedBox(
                    height: _chapterH,
                    child: ListTile(
                      dense: true,
                      onTap: () => widget.onSelect(i),
                      leading: Text(
                        // 依卷內流水號（對齊獨立目錄頁），無卷資訊時退化為全書序號。
                        row.localNum.toString().padLeft(2, '0'),
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          color: current ? AppColors.acc : AppColors.mut,
                        ),
                      ),
                      title: Text(
                        widget.chapters[i].title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: current ? AppColors.acc : AppColors.txt,
                          fontWeight:
                              current ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      trailing: widget.chapters[i].vip
                          ? const Icon(Icons.lock_outline,
                              size: 14, color: AppColors.mut)
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 卷分隔標題（對齊獨立目錄頁 `catalog_page` 的 `_volHeader`；以 [AppColors.cov]
  /// 略亮於 sheet 的 [AppColors.surf] 底做出分組帶）。固定高度 [_headerH] 供位移估算。
  Widget _volumeHeader(String name) => Container(
        width: double.infinity,
        height: _headerH,
        alignment: Alignment.centerLeft,
        color: AppColors.cov,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 10,
            color: AppColors.mut,
            letterSpacing: 1.4,
          ),
        ),
      );
}

/// 閱讀器目錄 sheet 的顯示列：卷標題或章節。
class _TocRow {
  const _TocRow.header(this.name)
      : chapterIndex = -1,
        localNum = 0;
  const _TocRow.chapter(this.chapterIndex, this.localNum) : name = null;

  final String? name;
  final int chapterIndex; // -1 代表卷標題列
  final int localNum; // 卷內流水號（1-based）

  bool get isHeader => chapterIndex < 0;
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.style,
    required this.onRetry,
    this.onPrev,
    this.onNext,
    this.onCatalog,
  });

  final ReaderStyle style;
  final VoidCallback onRetry;
  // 逃生路徑：解析不了的假連結章「重試」無效時，仍能返回/上下章/開目錄離開（不卡死路）。
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final VoidCallback? onCatalog;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 4,
            top: 4,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: style.textColor),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('章節載入失敗',
                    style: TextStyle(color: style.textColor, fontSize: 15)),
                const SizedBox(height: 12),
                OutlinedButton(onPressed: onRetry, child: const Text('重試')),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (onPrev != null)
                      TextButton(
                          onPressed: onPrev,
                          child: Text('上一章',
                              style: TextStyle(color: style.textColor))),
                    if (onCatalog != null)
                      TextButton(
                          onPressed: onCatalog,
                          child: Text('目錄',
                              style: TextStyle(color: style.textColor))),
                    if (onNext != null)
                      TextButton(
                          onPressed: onNext,
                          child: Text('下一章',
                              style: TextStyle(color: style.textColor))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
