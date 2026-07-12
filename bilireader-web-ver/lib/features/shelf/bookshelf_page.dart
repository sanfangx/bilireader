import 'package:flutter/material.dart';

import '../../core/models/catalog.dart';
import '../../core/models/novel_summary.dart';
import '../../core/models/shelf_class.dart';
import '../../core/network/linovelib_api.dart';
import '../../core/offline/offline_store.dart';
import '../../core/reading/local_store.dart';
import '../../core/session/auth_controller.dart';
import '../../core/session/shelf_events.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/network_cover.dart';
import '../auth/webview_login_page.dart';
import '../novel/novel_detail_page.dart';
import '../reader/presentation/reader_page.dart';

/// 書架 — 伺服器收藏（`/bookcase.php`）。對齊 api-ver：真實伺服器操作（加入/移除/分組），
/// 採網站原生 6 個固定分組（[ShelfClass]）；繼續閱讀卡維持本機（伺服器只到章級）。
/// 未登入 → 登入引導（帳號動作需登入 cookie）。
class BookshelfPage extends StatefulWidget {
  const BookshelfPage({super.key});

  @override
  State<BookshelfPage> createState() => _BookshelfPageState();
}

class _BookshelfPageState extends State<BookshelfPage> {
  ShelfClass _group = ShelfClass.reading;
  ShelfSort _sort = ShelfSort.lastUpdate;

  /// 各「分組×排序」的伺服器清單**快取**（key=classid_sort）。切分組直接讀快取 → 即時顯示、
  /// 不重打網路、不閃骨架。只有：首次進入該分組 / 下拉重整（⋯）/ 書架異動（ShelfEvents，
  /// 影響多組故整批失效）時才抓。app 內的加/移/分組都會發 ShelfEvents → 快取正確。
  final Map<String, List<NovelSummary>> _cache = {};
  final Set<String> _inflight = {}; // 同 key 進行中，避免重複抓
  bool _error = false; // 目前分組的載入是否失敗

  String _keyOf(ShelfClass g, ShelfSort s) => '${g.classid}_${s.wire}';
  String get _key => _keyOf(_group, _sort);
  List<NovelSummary>? get _books => _cache[_key];

  @override
  void initState() {
    super.initState();
    AuthController.instance.addListener(_onAuthChanged);
    ShelfEvents.instance.addListener(_onShelfChanged);
    _load();
  }

  @override
  void dispose() {
    AuthController.instance.removeListener(_onAuthChanged);
    ShelfEvents.instance.removeListener(_onShelfChanged);
    super.dispose();
  }

  /// 本頁自身正在做樂觀 mutation → 忽略自己發的 ShelfEvents（不重刷），只讓別頁（我的）反應。
  bool _selfMutating = false;

  /// 詳情頁/他處加移書架 → 全部快取失效（一次加/移可能改多組成員）+ 重抓目前組。
  void _onShelfChanged() {
    if (_selfMutating) return; // 自己剛樂觀更新過，不用重抓
    if (!mounted || !AuthController.instance.isLoggedIn) return;
    _cache.clear();
    _load();
  }

  /// 通知別頁（我的收藏數）刷新，但不觸發本頁重刷（bumped 是同步 notify，旗標包住即可）。
  void _notifyOthersOnly() {
    _selfMutating = true;
    ShelfEvents.instance.bumped();
    _selfMutating = false;
  }

  /// 登入完成 → 自動抓（gate 期間沒抓過）。
  void _onAuthChanged() {
    if (AuthController.instance.isLoggedIn && _books == null) _load();
  }

  /// 抓目前分組並寫入快取（覆蓋更新，不清舊內容 → 重整不閃）。
  Future<void> _load() async {
    if (!AuthController.instance.isLoggedIn) return;
    final ShelfClass g = _group;
    final ShelfSort s = _sort;
    final String key = _keyOf(g, s);
    if (_inflight.contains(key)) return;
    _inflight.add(key);
    if (mounted) setState(() => _error = false);
    try {
      final list = await LinovelibApi.instance.bookcase(
        classid: g.classid,
        sortorder: s.wire,
      );
      _cache[key] = list; // 一律寫快取（即使使用者已切走，切回時即時顯示）
      if (mounted) setState(() {});
    } catch (_) {
      if (mounted && _key == key) setState(() => _error = true);
    } finally {
      _inflight.remove(key);
    }
  }

  /// 開書籍詳情。收藏狀態變更由詳情頁 ShelfEvents.bumped() → _onShelfChanged 統一刷新，
  /// 閱讀進度由 LocalStore 反應式更新，故此處不必額外重抓。
  Future<void> _openDetail(String novelId) => Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => NovelDetailPage(id: novelId)));

  void _selectGroup(ShelfClass g) {
    if (g == _group) return;
    setState(() {
      _group = g;
      _error = false;
    });
    if (_cache[_key] == null) _load(); // 未快取才抓；已快取立即顯示（不重刷）
  }

  void _toggleSort() {
    setState(() {
      _sort = _sort == ShelfSort.lastUpdate
          ? ShelfSort.joinDate
          : ShelfSort.lastUpdate;
      _error = false;
    });
    if (_cache[_key] == null) _load();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListenableBuilder(
        listenable: AuthController.instance,
        builder: (context, _) {
          if (!AuthController.instance.isLoggedIn) return _loginGate();
          return Column(
            children: [
              _header(),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.acc,
                  backgroundColor: AppColors.surf,
                  onRefresh: _load, // 下拉重整：重抓目前分組並更新其快取
                  child: ListenableBuilder(
                    listenable: LocalStore.instance,
                    builder: (context, _) {
                      final books = _books;
                      if (books == null) {
                        // 無快取：載入中顯骨架、失敗顯錯誤（仍可下拉重試）。
                        return _error
                            ? _content(const <NovelSummary>[], loadError: true)
                            : const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.acc,
                                ),
                              );
                      }
                      return _content(books, loadError: _error);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _header() => Padding(
    padding: const EdgeInsets.fromLTRB(22, 8, 22, 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('書架', style: AppText.serif(size: 23, color: AppColors.txt)),
            const SizedBox(height: 3),
            Text(
              'BOOKSHELF · 收藏',
              style: AppText.mono(
                size: 10,
                color: AppColors.mut,
                letterSpacing: 2.2,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () async {
            await _load();
            if (mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('已重新整理')));
            }
          },
          child: Text('⋯', style: AppText.sans(size: 20, color: AppColors.mut)),
        ),
      ],
    ),
  );

  Widget _content(List<NovelSummary> books, {bool loadError = false}) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _continueCard(books)),
        SliverToBoxAdapter(child: _groupsHeader()),
        SliverToBoxAdapter(child: _tabs()),
        if (books.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Center(
                child: Text(
                  loadError
                      ? '收藏載入失敗\n（可能逾期或網路問題，下拉可重試）'
                      : '「${_group.label}」還沒有書\n長按書封可移動分組',
                  textAlign: TextAlign.center,
                  style: AppText.sans(
                    size: 13,
                    color: AppColors.mut,
                    height: 1.7,
                  ),
                ),
              ),
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 4, 22, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 18,
                crossAxisSpacing: 12,
                childAspectRatio: 0.50,
              ),
              delegate: SliverChildBuilderDelegate(
                (c, i) => _cell(books[i]),
                childCount: books.length,
              ),
            ),
          ),
      ],
    );
  }

  // 繼續閱讀（本機進度；伺服器只到章級，章內 % 是本機獨有）。
  Widget _continueCard(List<NovelSummary> books) {
    final p = LocalStore.instance.latest;
    if (p == null) return const SizedBox(height: 6);
    final matches = books.where((b) => b.id == p.novelId).toList();
    // 先用目前分組清單的封面（最新）；不在此分組 → 退回進度存的封面，
    // 切分組時縮圖才不會消失。
    final cover = matches.isNotEmpty ? matches.first.coverUrl : p.cover;
    final pct = (p.percent * 100).round();
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 2, 22, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('最近閱讀', style: AppText.sans(size: 11.5, color: AppColors.mut)),
          const SizedBox(height: 9),
          GestureDetector(
            onTap: () => _openDetail(p.novelId),
            child: Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: AppColors.surf,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  NetworkCover(url: cover, width: 54, height: 76, radius: 11),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '繼續閱讀',
                          style: AppText.mono(
                            size: 9,
                            color: AppColors.acc,
                            letterSpacing: 1.6,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          p.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.serif(size: 15, color: AppColors.txt),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '第 ${p.chapterIndex + 1} 章 · ${p.chapterTitle} · 本機進度 $pct%',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.sans(size: 11, color: AppColors.mut),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _resume(p, cover: cover),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: AppColors.acc,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '▶',
                        style: TextStyle(fontSize: 13, color: AppColors.btxt),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _groupsHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(22, 14, 22, 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('收藏分組', style: AppText.serif(size: 16, color: AppColors.txt)),
        GestureDetector(
          onTap: _toggleSort,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.line),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: [
                Text('⇅ ', style: AppText.sans(size: 12, color: AppColors.acc)),
                Text(
                  _sort.label,
                  style: AppText.sans(size: 11, color: AppColors.mut),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _tabs() {
    // 視口內縮 22 → 列尾 tab（經典作品）收在內容右緣，不溢到螢幕邊。
    // 用外層 Padding 收縮 viewport，而非 SingleChildScrollView 自身 padding
    // （後者是隨捲動的內容內距，捲到 0 時列尾仍溢出）。
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            for (final g in ShelfClass.values)
              GestureDetector(
                onTap: () => _selectGroup(g),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        g.label,
                        style: AppText.sans(
                          size: 13,
                          weight: _group == g
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: _group == g ? AppColors.txt : AppColors.mut,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 22,
                        height: 2,
                        color: _group == g ? AppColors.acc : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _cell(NovelSummary n) {
    final p = LocalStore.instance.progressOf(n.id);
    return GestureDetector(
      onTap: () => _openDetail(n.id),
      onLongPress: () => _manageSheet(n),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: NetworkCover(url: n.coverUrl, radius: 12),
          ),
          const SizedBox(height: 7),
          if (p != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Container(
                height: 2,
                color: AppColors.cov,
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: p.percent.clamp(0.02, 1.0),
                  child: Container(color: AppColors.acc),
                ),
              ),
            ),
            const SizedBox(height: 5),
          ],
          Text(
            n.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.sans(
              size: 11,
              weight: FontWeight.w600,
              color: AppColors.txt,
            ),
          ),
          if (p != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                p.finished ? '讀畢' : '${(p.percent * 100).round()}%',
                style: AppText.mono(size: 9.5, color: AppColors.mut),
              ),
            ),
        ],
      ),
    );
  }

  /// 長按書封：移動分組（真實伺服器 act=move）或移除書架（addbookcase.php?did=）。
  void _manageSheet(NovelSummary n) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surf,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14),
            Text('移動分組', style: AppText.serif(size: 15, color: AppColors.txt)),
            const SizedBox(height: 4),
            Text(
              n.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.sans(size: 11, color: AppColors.mut),
            ),
            const SizedBox(height: 8),
            for (final g in ShelfClass.values)
              ListTile(
                dense: true,
                title: Text(
                  g.label,
                  style: AppText.sans(size: 14, color: AppColors.txt),
                ),
                trailing: g == _group
                    ? Text(
                        '目前',
                        style: AppText.mono(size: 10, color: AppColors.mut),
                      )
                    : null,
                onTap: g == _group
                    ? null
                    : () {
                        Navigator.pop(context);
                        _moveToGroup(n, g);
                      },
              ),
            const Divider(height: 1, color: AppColors.line),
            ListTile(
              dense: true,
              title: Text(
                '移除書架',
                style: AppText.sans(size: 14, color: AppColors.danger),
              ),
              onTap: () {
                Navigator.pop(context);
                _removeFromShelf(n);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  /// 移動/移除成功後**樂觀移出目前清單**（不立即重抓）：實測 mutation 後立即重抓
  /// 常拿到快取的舊頁把書「復活」；伺服器已確認成功，直接更新畫面最誠實。
  void _optimisticRemove(NovelSummary n) {
    setState(() {
      // 目前分組樂觀移除該書；其他分組因移動可能變動 → 失效，下次進該組重抓。
      final String cur = _key;
      _cache[cur] = List<NovelSummary>.of(_cache[cur] ?? const <NovelSummary>[])
        ..removeWhere((b) => b.id == n.id);
      _cache.removeWhere((k, v) => k != cur);
    });
  }

  Future<void> _moveToGroup(NovelSummary n, ShelfClass g) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await LinovelibApi.instance.assignShelfGroup(n.id, g.classid);
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(content: Text(ok ? '已移至「${g.label}」' : '移動失敗（請確認登入）')),
    );
    if (ok) _optimisticRemove(n); // 離開目前分組
  }

  Future<void> _removeFromShelf(NovelSummary n) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await LinovelibApi.instance.removeFromShelf(n.id);
    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(content: Text(ok ? '已移除書架' : '移除失敗（請確認登入）')),
    );
    if (ok) {
      _optimisticRemove(n);
      _notifyOthersOnly(); // 收藏總數 -1 → 更新「我的」，不重刷本頁
    }
  }

  Widget _loginGate() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('書架', style: AppText.serif(size: 22, color: AppColors.txt)),
            const SizedBox(height: 10),
            Text(
              '登入以同步你的雲端收藏\n（加入/移除/分組都會與網站同步）',
              textAlign: TextAlign.center,
              style: AppText.sans(size: 13, color: AppColors.mut, height: 1.7),
            ),
            const SizedBox(height: 22),
            GestureDetector(
              onTap: () => Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (_) => const WebViewLoginPage()),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 34,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: AppColors.acc,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '登入',
                  style: AppText.sans(
                    size: 14,
                    weight: FontWeight.w700,
                    color: AppColors.btxt,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ▶ 續讀：抓目錄 → 開閱讀器至上次章節（章內位置由閱讀器依 drift ReaderAnchor 還原）。
  /// 已完整下載的書離線也能續讀（目錄改用離線清單，不需網路）。
  Future<void> _resume(ReadProgress p, {String? cover}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.acc),
      ),
    );
    try {
      List<Chapter> flat;
      try {
        final cat = await LinovelibApi.instance.catalog(p.novelId);
        flat = cat.flattened(); // 帶卷名 → 閱讀器目錄可分卷
      } catch (_) {
        // 線上目錄抓不到（斷網等）→ 退回離線清單（有下載才有）。
        flat = OfflineStore.instance.chaptersFor(p.novelId);
        if (flat.isEmpty) rethrow;
      }
      if (!mounted) return;
      Navigator.of(context).pop(); // 關閉 loading
      final idx = p.chapterIndex.clamp(0, flat.length - 1);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ReaderPage(
            articleId: int.tryParse(p.novelId) ?? 0,
            chapters: flat,
            startIndex: idx,
            articleName: p.title,
            poster: cover ?? '',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('載入失敗，請稍後再試')));
    }
  }
}
