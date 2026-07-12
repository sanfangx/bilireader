import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/storage/database/database_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../chapter_comment/presentation/chapter_comment_panel.dart';
import '../../discover/domain/novel_catalog.dart';
import '../../discover/presentation/novel_detail_providers.dart';
import '../data/bookmark_local_data_source.dart';
import '../domain/bookmark.dart';
import '../domain/reader_anchor.dart';
import '../domain/reader_block.dart';
import '../domain/reader_inline_node.dart';
import '../domain/reader_inline_parser.dart';
import '../domain/reader_settings.dart';
import '../domain/reader_theme.dart';
import '../domain/reading_progress.dart';
import '../domain/reading_progress_repository.dart';
import '../reading_progress_providers.dart';
import 'panels/reader_bookmark_sheet.dart';
import 'panels/reader_settings_sheets.dart';
import 'reader_paged_view.dart';
import 'reader_providers.dart';
import 'reader_settings_providers.dart';
import 'render/reader_block_view.dart';
import 'render/reader_style.dart';

/// 沉浸式閱讀器主頁（design「閱讀器 .rd/.rdtop/.prose/.rdfoot」；doc 05 §10/§11）。
/// 目前：垂直連續滾動模式（`vertical`）。點擊中央切換頂/底控制列；上/下章切換；本機進度
/// （章 + 捲動比例）保存/還原（§5.5/§6.2）。水平/仿真翻頁 = ⑨e3；字體/主題/目錄面板 = ⑨f。
class ReaderPage extends ConsumerStatefulWidget {
  const ReaderPage({
    required this.articleId,
    required this.initialChapterId,
    this.poster = '',
    super.key,
  });

  final int articleId;
  final int initialChapterId;

  /// 封面 URL（供本機閱讀進度存檔 → 書架「繼續閱讀」卡片縮圖）。入口（詳情/書架 ▶）帶入；
  /// 空時於掛載期由既有進度回填，避免無封面入口覆蓋既有封面。
  final String poster;

  @override
  ConsumerState<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends ConsumerState<ReaderPage>
    with WidgetsBindingObserver {
  static const ReaderInlineParser _parser = ReaderInlineParser();

  late int _chapterId = widget.initialChapterId;
  bool _barsVisible = true;
  final ScrollController _scroll = ScrollController();

  // F-21：捲動進度保存防抖（§5.5「滾動停止後 300-800ms 寫入，合併過密寫入」）。
  // 慣性滾動連續觸發 ScrollEndNotification → 只排一個 500ms Timer，最後一筆才寫。
  // 切章 / 翻頁 / 書籤跳轉 / dispose / App 進背景 一律立即 flush（_saveProgressNow）。
  Timer? _saveDebounce;
  final GlobalKey _listKey = GlobalKey(); // 垂直 ListView，量測 viewport 頂
  final Map<int, GlobalKey> _blockKeys =
      <int, GlobalKey>{}; // 每 block 一 key（量測/定位）
  int _blockCount = 0;
  List<ReaderBlock> _blocks = const <ReaderBlock>[]; // 目前章 blocks（取位置片段用）

  int? _ownerUid;
  late String _poster = widget.poster; // 進度封面（入口帶入；空則掛載期由既有進度回填）
  int _restoredChapterId = -1; // 已還原捲動位置的章
  String _chapterName = '';
  String _articleName = '';
  String _quote = '';

  // 於掛載期擷取 repository（keepAlive 單例），供 dispose() 存進度時使用——
  // dispose() 內禁止碰 ref（BuildContext 已失效），故不可在存檔當下才 ref.read。
  late final ReadingProgressRepository _progressRepo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // F-21：監聽 App 生命週期以 flush 進度。
    _progressRepo = ref.read(readingProgressRepositoryProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final int? uid = await ref.read(currentOwnerUidProvider.future);
      if (!mounted || uid == null) {
        _ownerUid = uid;
        return;
      }
      // 入口未帶封面時，回填既有進度封面（避免以空封面覆蓋）。於設 _ownerUid（＝開放存檔）前完成。
      if (_poster.isEmpty) {
        final ReadingProgress? existing = await _progressRepo.get(
          uid,
          widget.articleId,
        );
        if (!mounted) return;
        if (_poster.isEmpty && (existing?.poster.isNotEmpty ?? false)) {
          _poster = existing!.poster;
        }
      }
      _ownerUid = uid;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _saveDebounce?.cancel();
    _saveProgressNow(); // 卸載前 flush 未寫入的最後一筆（§5.5）。
    _scroll.dispose();
    super.dispose();
  }

  /// F-21：App 進背景（paused / hidden / detached）時 flush 未寫入的進度（§5.5 明列
  /// App pause/background 為保存來源）。inactive 屬轉場態、不在此 flush（避免每開 sheet 誤寫）。
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.detached) {
      _saveProgressNow();
    }
  }

  /// 排一個 500ms 防抖存檔（捲動熱路徑用）。同視窗內重複呼叫只留最後一筆。
  void _scheduleSave() {
    _saveDebounce?.cancel();
    _saveDebounce = Timer(const Duration(milliseconds: 500), _saveProgressNow);
  }

  void _toggleBars() => setState(() => _barsVisible = !_barsVisible);

  double _fraction = 0; // 章內進度 0–1（垂直=捲動比例；分頁=頁序比例）
  double _restoreFraction = 0; // 開章時同章已存進度，供還原

  double _scrollFraction() =>
      _scroll.hasClients && _scroll.position.maxScrollExtent > 0
      ? (_scroll.offset / _scroll.position.maxScrollExtent).clamp(0.0, 1.0)
      : 0.0;

  void _goChapter(int? id) {
    if (id == null) return;
    _saveProgressNow();
    _blockKeys.clear();
    setState(() {
      _chapterId = id;
      _fraction = 0;
      _restoreFraction = 0;
    });
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  /// 目前位置的跨模式錨點（§5.5）：章 + **目前可見首個 block 序號**（精準定位主依據）
  /// + 章內比例（顯示/fallback）+ 附近繁體片段。
  ReaderAnchor _currentAnchor() {
    final int now = DateTime.now().millisecondsSinceEpoch;
    return ReaderAnchor(
      articleId: widget.articleId,
      chapterId: _chapterId,
      chapterName: _chapterName,
      sourceTextOffset: 0,
      blockIndex: _firstVisibleBlockIndex() ?? 0,
      progressInChapter: _fraction,
      // 錨點附近文字：取目前可見位置的段落（令同章不同位置的書籤可區分），空則退回章首片段。
      textQuote: _visibleQuote(),
      createdAt: now,
      updatedAt: now,
    );
  }

  /// 目前可見位置起算的第一段可見文字（供書籤/進度片段顯示）。
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

  /// 垂直模式：目前 viewport 頂端的 ReaderBlock 序號（量測已建置的 block key）。
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
      // 頂端已在或剛越過 viewport 頂（含 8px padding）者，取最接近頂端。
      if (t <= viewTop + 8 && t > straddleTop) {
        straddleTop = t;
        straddle = i;
      }
    });
    return straddle ?? firstBuilt;
  }

  /// 捲到指定 block 頂端：先以序號比例粗跳（令目標進入建置範圍），再 ensureVisible 精定位。
  /// [fallbackFrac]（F-27c）：精準定位重試耗盡時退回的章內比例（progressInChapter）。
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
        // F-27c：block 精準定位重試耗盡 → 退回章內比例，不靜默停在粗估位置。
        _scroll.jumpTo(fallbackFrac * _scroll.position.maxScrollExtent);
      }
    });
  }

  void _saveProgressNow() {
    _saveDebounce?.cancel(); // 立即寫入 → 取消任何待觸發的防抖，避免舊值稍後覆蓋。
    final int? uid = _ownerUid;
    if (uid == null || _chapterName.isEmpty) return;
    final ReaderAnchor anchor = _currentAnchor();
    _progressRepo.save(
      ReadingProgress(
        ownerUid: uid,
        anchor: anchor,
        articleName: _articleName,
        poster: _poster,
        updatedAt: anchor.updatedAt,
      ),
    );
  }

  // ---- 書籤（本機，§5.5）：頂列旗標開啟書籤面板（加入 / 刪除 / 點選跳回）----

  double? _pendingRestoreFraction; // 書籤跳章時待還原的章內比例
  int? _pendingRestoreBlockIndex; // 書籤跳章時待還原的 block 序號（精準）

  BookmarkLocalDataSource get _bookmarks =>
      BookmarkLocalDataSource(ref.read(bookmarkDaoProvider));

  Future<void> _openBookmarks() async {
    final int? uid = _ownerUid;
    if (uid == null) {
      _toast('請先登入');
      return;
    }
    await showReaderBookmarkSheet(
      context,
      dataSource: _bookmarks,
      ownerUid: uid,
      articleId: widget.articleId,
      articleName: _articleName,
      currentAnchor: _currentAnchor,
      onJump: _jumpToBookmark,
    );
  }

  /// 跳到書籤位置（§5.5）：同章→依 blockIndex（精準）或比例還原；異章→切章後由
  /// _onChapterLoaded 依 pending block/比例還原。
  void _jumpToBookmark(Bookmark b) {
    final int cid = b.anchor.chapterId;
    final int blockIdx = b.anchor.blockIndex;
    final double frac = b.anchor.progressInChapter;
    if (cid == _chapterId) {
      setState(() => _fraction = _restoreFraction = frac);
      _restoreVerticalPosition(blockIdx, frac);
    } else {
      _pendingRestoreBlockIndex = blockIdx > 0 ? blockIdx : null;
      _pendingRestoreFraction = frac;
      setState(() {
        _chapterId = cid;
        _fraction = frac;
        _restoreFraction = frac;
        _restoredChapterId = -1; // 令 _onChapterLoaded 重新還原（用 pending）
      });
      _blockKeys.clear();
      if (_scroll.hasClients) _scroll.jumpTo(0);
    }
  }

  /// 垂直模式還原位置：blockIndex>0 用 block 精準定位，否則退回章內比例。分頁模式由
  /// ReaderPagedView.initialFraction 變更觸發 didUpdateWidget seek（比例）。
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

    final int? uid =
        _ownerUid ?? await ref.read(currentOwnerUidProvider.future);
    if (!mounted) return;
    _ownerUid = uid;
    if (uid != null) {
      final ReadingProgress? saved = await ref
          .read(readingProgressRepositoryProvider)
          .get(uid, widget.articleId);
      if (!mounted) return;
      final bool sameChapter = saved?.anchor.chapterId == _chapterId;
      // 還原目標：書籤跳章 pending 優先；否則本機進度（同章才還原）。blockIndex 為精準主
      // 依據、progressInChapter 為 fallback（§5.5 line 34）。
      final int blockIdx =
          _pendingRestoreBlockIndex ??
          (sameChapter ? (saved?.anchor.blockIndex ?? 0) : 0);
      final double frac =
          _pendingRestoreFraction ??
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

  /// 段落 block 的前 34 個繁體可見字（非段落回空）。
  String _blockQuoteText(ReaderBlock b) {
    if (b is ParagraphBlock) {
      final String v = visibleText(_parser.parse(b.html)).trim();
      if (v.isNotEmpty) return v.length > 34 ? v.substring(0, 34) : v;
    }
    return '';
  }

  void _openCatalog() => context.pushNamed(
    AppRoutes.catalogName,
    pathParameters: <String, String>{'articleId': '${widget.articleId}'},
    queryParameters: <String, String>{'chapterId': '$_chapterId'},
  );

  void _openChapterComments() => openChapterCommentPanel(
    context,
    articleId: widget.articleId,
    chapterId: _chapterId,
    chapterName: _chapterName,
  );

  @override
  Widget build(BuildContext context) {
    final ReaderSettings settings = ref.watch(readerSettingsControllerProvider);
    final ReaderTheme theme = ref.watch(readerThemeControllerProvider).active;
    final ReaderStyle style = ReaderStyle.from(settings, theme);

    final AsyncValue<ReaderChapterContent> content = ref.watch(
      readerChapterContentProvider(widget.articleId, _chapterId),
    );
    final AsyncValue<NovelCatalog> catalogAsync = ref.watch(
      novelCatalogProvider(widget.articleId),
    );

    final ChapterNav nav = catalogAsync.maybeWhen(
      data: (NovelCatalog c) => chapterNavOf(c, _chapterId),
      orElse: () => const ChapterNav(index: -1, count: 0),
    );

    ref.listen<AsyncValue<ReaderChapterContent>>(
      readerChapterContentProvider(widget.articleId, _chapterId),
      (
        AsyncValue<ReaderChapterContent>? prev,
        AsyncValue<ReaderChapterContent> next,
      ) {
        next.whenData(_onChapterLoaded);
      },
    );
    // 書名（供進度／書架「繼續閱讀」顯示）。目錄已於上方 watch（供上下章導覽），直接取
    // 「當前值」——若改用無當前值派送的 ref.listen，目錄已快取（AsyncData）時 listener
    // 永不觸發 → _articleName 空 → 書架顯示「未命名作品」。故必於首次存檔前設妥此值。
    catalogAsync.whenData((NovelCatalog c) {
      final String name = c.articleName ?? '';
      if (name == _articleName) return;
      _articleName = name;
      // 目錄較晚解析、章節進度已存時，於 frame 後補存一次（避免 build 內產生副作用），
      // 令書架「繼續閱讀」即時顯示正確書名。
      if (name.isNotEmpty && _chapterName.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _saveProgressNow();
        });
      }
    });

    return Scaffold(
      backgroundColor: style.bgColor,
      // F-33：整頁疊螢幕遮罩降亮（IgnorePointer 讓點擊照常穿透至內容/工具列；不動系統背光、
      // 離開閱讀器即無殘留）。dimLevel=0 時完全不插入遮罩層 → 對現狀零影響。
      body: Stack(
        children: <Widget>[
          // skipLoadingOnReload：轉繁模式等設定變更令內容 provider 重跑時，維持顯示前一份
          // 內容（不閃 loading），避免 ListView 被換掉導致捲動歸零。首次載入/切章仍顯示 loading。
          Positioned.fill(
            child: content.when(
              skipLoadingOnReload: true,
              loading: () => Center(
                child: CircularProgressIndicator(color: style.textColor),
              ),
              error: (Object e, StackTrace _) => _ErrorView(
                style: style,
                onRetry: () => ref.invalidate(
                  readerChapterContentProvider(widget.articleId, _chapterId),
                ),
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
    // 內容區（依模式）。點擊切換控制列（垂直/水平：tap；仿真：tapToTurn=false 讓 tap 交給此處）。
    final Widget inner = switch (settings.scrollMode) {
      ReaderScrollMode.vertical => NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification n) {
          if (n is ScrollEndNotification) {
            setState(() => _fraction = _scrollFraction());
            _scheduleSave(); // F-21：捲動熱路徑防抖，合併過密寫入。
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
            // 每 block 一 GlobalKey：兼作 keep-alive 身分 + 書籤/進度 block 精準定位量測。
            return ReaderBlockView(
              key: _blockKeys.putIfAbsent(i, () => GlobalKey()),
              block: b,
              style: style,
              onChapterComment: _openChapterComments,
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
        onChapterComment: _openChapterComments,
      ),
    };

    // 點擊中央切換工具列：僅在使用者開啟該設定時生效（預設關閉＝工具列常駐、不因誤觸收起）。
    // 關閉時 onTap 為 null，GestureDetector 不攔截點擊，內文（章評入口等）之點擊照常運作。
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
            onBack: () => context.pop(),
            onBookmark: _openBookmarks,
            onComment: _openChapterComments,
            onCatalog: _openCatalog,
          ),
        // 穩定 key：切換控制列時頂列於 Column 首位增刪，會令內容 Expanded 索引位移。
        // 無 key 時 Flutter 依「位置＋型別」對位失敗 → 重建整棵內容子樹 → 垂直 ListView 的
        // ScrollPosition 重置歸 0、分頁 ReaderPagedView state 重置 → 跳回章首。keyed 對位
        // 令內容元素跨增刪保留，捲動/頁碼位置得以維持（垂直與翻頁兩模式皆適用）。
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
            onPrev: nav.prevChapterId == null
                ? null
                : () => _goChapter(nav.prevChapterId),
            onNext: nav.nextChapterId == null
                ? null
                : () => _goChapter(nav.nextChapterId),
          ),
      ],
    );
  }
}

/// 頂列（design `.rdtop`）：返回 + 章名 + 書籤/章評/目錄。
class _ReaderTopBar extends StatelessWidget {
  const _ReaderTopBar({
    required this.style,
    required this.chapterName,
    required this.onBack,
    required this.onBookmark,
    required this.onComment,
    required this.onCatalog,
  });

  final ReaderStyle style;
  final String chapterName;
  final VoidCallback onBack;
  final VoidCallback onBookmark;
  final VoidCallback onComment;
  final VoidCallback onCatalog;

  @override
  Widget build(BuildContext context) {
    final Color fg = style.textColor.withValues(alpha: 0.65);
    return Material(
      color: style.bgColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          // 44×44 命中盒自帶內距 → 縮小外距，避免頂列過高（F-13）。
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
              // 44×44 命中盒已自帶間距，移除原 8/15/15 顯式 gap 避免右側過度分散（F-13）。
              _icon(Icons.bookmark_border, onBookmark, fg, '書籤'),
              _icon(Icons.chat_bubble_outline, onComment, fg, '章節評論'),
              _icon(Icons.menu, onCatalog, fg, '目錄'),
            ],
          ),
        ),
      ),
    );
  }

  // F-13：圖示視覺維持 [size]（預設 19），但外層 44×44 命中區（§5.3 觸控目標下限）。
  // F-12：icon-only 導覽鈕加 [semanticLabel]（TalkBack 讀「<名>，按鈕」，避免無名鈕）。
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
          child: Center(
            child: Icon(i, size: size, color: c),
          ),
        ),
      ),
    ),
  );
}

/// 底列（design `.rdfoot`）：進度條 + 「第 N 章 / 共 M 章」「本機 X%」 + 5 工具。
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
              // progbar
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
                    style: TextStyle(
                      fontFamily: AppTypography.fontMono,
                      fontSize: 10.5,
                      color: mut,
                    ),
                  ),
                  Text(
                    '本機 ${(progress * 100).round()}%',
                    style: TextStyle(
                      fontFamily: AppTypography.fontMono,
                      fontSize: 10.5,
                      color: mut,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _RTool(glyph: 'Aa', label: '字體', onTap: onFont, style: style),
                  _RTool(glyph: '☾', label: '主題', onTap: onTheme, style: style),
                  _RTool(
                    glyph: '≡',
                    label: '目錄',
                    onTap: onCatalog,
                    style: style,
                  ),
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
    // F-12：以 [label]（字體/主題/目錄/上一章/下一章）為無障礙名，排除 glyph 符號字元
    // 被讀成符號名；F-13：44×44 命中盒（InkResponse.radius 僅墨波、不約束命中矩形）。
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

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.style, required this.onRetry});

  final ReaderStyle style;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '章節載入失敗',
              style: TextStyle(color: style.textColor, fontSize: 15),
            ),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: const Text('重試')),
          ],
        ),
      ),
    );
  }
}
