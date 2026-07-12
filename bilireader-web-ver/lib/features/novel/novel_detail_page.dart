import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_config.dart';
import '../../core/models/catalog.dart';
import '../../core/models/novel_detail.dart';
import '../../core/network/linovelib_api.dart';
import '../../core/offline/offline_store.dart';
import '../../core/reading/local_store.dart';
import '../../core/session/auth_controller.dart';
import '../../core/session/shelf_events.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_background.dart';
import '../../widgets/network_cover.dart';
import '../download/download_manager_page.dart';
import '../interaction/rating_sheet.dart';
import '../reader/presentation/reader_page.dart';
import 'catalog_page.dart';
import 'review_list_page.dart';

/// 書籍詳情頁。
class NovelDetailPage extends StatefulWidget {
  const NovelDetailPage({super.key, required this.id, this.fallbackTitle});

  final String id;
  final String? fallbackTitle;

  @override
  State<NovelDetailPage> createState() => _NovelDetailPageState();
}

class _NovelDetailPageState extends State<NovelDetailPage> {
  late Future<NovelDetail> _future;

  /// 已下載書偵測到的線上新章節數（>0 才顯示「內容非最新」橫幅）。
  int _newChapters = 0;

  /// 收藏態本機覆寫（null=以解析到的 [NovelDetail.shelved] 為準）；防連點。
  bool? _shelvedOverride;
  bool _shelfBusy = false;

  /// 使用者本次自評分（1-5，送出成功後）；非 null 時入口星列反映自評。
  int? _myScore;

  @override
  void initState() {
    super.initState();
    _future = LinovelibApi.instance.novelDetail(widget.id);
    _checkForUpdate();
  }

  /// 已下載的書：背景比對線上目錄章數 vs 下載時的章數，偵測到新章節就提示可更新。
  /// 未下載/離線/失敗一律靜默（best-effort，不擋畫面）。
  Future<void> _checkForUpdate() async {
    final m = OfflineStore.instance.manifest(widget.id);
    if (m == null) return;
    try {
      final cat = await LinovelibApi.instance.catalog(widget.id);
      final int diff = cat.chapterCount - m.chapters.length;
      if (diff > 0 && mounted) setState(() => _newChapters = diff);
    } catch (_) {
      // 離線或抓取失敗 → 不提示。
    }
  }

  void _openCatalog(NovelDetail d) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => CatalogPage(novelId: d.id, title: d.title),
    ));
  }

  /// 主 CTA：續讀。**已下載者直接用離線章節清單**（免網路、可離線，卷名與線上一致）；
  /// 未下載才線上抓目錄。選續讀位置（上次章 → 否則第一個可讀章 → 否則 0），進閱讀器；
  /// 目錄載入失敗才退回目錄頁。（對齊 api-ver「開始/繼續閱讀」直接進 reader。）
  Future<void> _startReading(NovelDetail d) async {
    // 已下載 → 走離線清單（含卷名 → 閱讀器目錄分卷；無需網路，斷網也能讀）。
    if (OfflineStore.instance.hasNovel(d.id)) {
      final offline = OfflineStore.instance.chaptersFor(d.id);
      if (offline.isNotEmpty) {
        _pushReader(d, offline);
        return;
      }
    }
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
          child:
              CircularProgressIndicator(strokeWidth: 2, color: AppColors.acc)),
    );
    try {
      final cat = await LinovelibApi.instance.catalog(d.id);
      final flat = cat.flattened(); // 帶卷名 → 閱讀器目錄可分卷
      if (!mounted) return;
      navigator.pop(); // 關閉 loading
      if (flat.isEmpty) {
        _openCatalog(d);
        return;
      }
      _pushReader(d, flat);
    } catch (_) {
      if (!mounted) return;
      navigator.pop();
      messenger.showSnackBar(
          const SnackBar(content: Text('載入失敗，請稍後再試')));
    }
  }

  /// 依上次進度選起始章並進入閱讀器（線上/離線章節清單共用）。
  void _pushReader(NovelDetail d, List<Chapter> flat) {
    final int? saved = LocalStore.instance.progressOf(d.id)?.chapterIndex;
    int start;
    if (saved != null && saved >= 0 && saved < flat.length) {
      start = saved;
    } else {
      final int firstReadable = flat.indexWhere((c) => c.url != null);
      start = firstReadable >= 0 ? firstReadable : 0;
    }
    Navigator.of(context)
        .push(MaterialPageRoute<void>(
          builder: (_) => ReaderPage(
            articleId: int.tryParse(d.id) ?? 0,
            chapters: flat,
            startIndex: start,
            articleName: d.title,
            poster: d.coverUrl ?? '',
          ),
        ))
        // 讀完返回 → 重建，讓底部 CTA 由「開始閱讀」變「繼續閱讀」（progressOf 已更新）。
        .then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: FutureBuilder<NovelDetail>(
            future: _future,
            builder: (context, snap) {
              return Column(
                children: [
                  _topBar(),
                  Expanded(
                    child: snap.connectionState == ConnectionState.waiting
                        ? const Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: AppColors.acc))
                        : snap.hasError || !snap.hasData
                            ? Center(
                                child: Text('載入失敗',
                                    style: AppText.sans(
                                        size: 13, color: AppColors.mut)))
                            : _content(snap.data!),
                  ),
                  if (snap.hasData && _newChapters > 0)
                    _updateBanner(snap.data!),
                  if (snap.hasData) _bottomBar(snap.data!),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 4, 22, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: Text('‹', style: AppText.sans(size: 26, color: AppColors.mut)),
          ),
          Text('書籍詳情',
              style: AppText.serif(size: 14, color: AppColors.txt)),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(
                  text: '${AppConfig.origin}/novel/${widget.id}.html'));
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已複製書籍連結')));
            },
            child: Text('⤴', style: AppText.sans(size: 18, color: AppColors.mut)),
          ),
        ],
      ),
    );
  }

  Widget _content(NovelDetail d) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NetworkCover(url: d.coverUrl, width: 100, height: 142, radius: 16),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d.title,
                        style: AppText.serif(
                            size: 20, color: AppColors.txt, height: 1.22)),
                    const SizedBox(height: 8),
                    Text(d.author ?? '',
                        style: AppText.sans(size: 12, color: AppColors.mut)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: d.tags
                          .take(4)
                          .map((t) => _tag(t))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _stats(d),
        _catalogEntry(d),
        _ratingEntry(d),
        if (d.summary != null && d.summary!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 8),
            child: Text(d.summary!,
                style: AppText.sans(
                    size: 12.5, color: AppColors.rtxt, height: 1.75)),
          ),
        if (d.lastUpdate != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 6, 22, 8),
            child: Text('最後更新 · ${d.lastUpdate}',
                style: AppText.sans(size: 11, color: AppColors.mut)),
          ),
        _comments(d),
        const SizedBox(height: 24),
      ],
    );
  }

  /// 章節目錄入口（開始閱讀已改為續讀，故目錄改由此進）。
  Widget _catalogEntry(NovelDetail d) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
      child: GestureDetector(
        onTap: () => _openCatalog(d),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
              color: AppColors.surf, borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              const Icon(Icons.menu_book_outlined,
                  size: 17, color: AppColors.acc),
              const SizedBox(width: 10),
              Expanded(
                child: Text('章節目錄',
                    style: AppText.sans(size: 12.5, color: AppColors.txt)),
              ),
              Text('›', style: AppText.sans(size: 16, color: AppColors.mut)),
            ],
          ),
        ),
      ),
    );
  }

  /// 評分入口（⑧ 唯一可行互動）。未登入 → 提示登入；已登入 → 開評分表單。
  Widget _ratingEntry(NovelDetail d) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
      child: GestureDetector(
        onTap: () async {
          if (!AuthController.instance.isLoggedIn) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('請先登入才能評分')));
            return;
          }
          final int? r = await showRatingSheet(context,
              novelId: d.id, novelTitle: d.title, initialScore: _myScore);
          if (r != null && mounted) setState(() => _myScore = r);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
              color: AppColors.surf, borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              const Icon(Icons.star_outline_rounded,
                  size: 18, color: AppColors.acc),
              const SizedBox(width: 10),
              Expanded(
                child: Text(_myScore != null ? '已評分（點擊修改）' : '為這本書評分',
                    style: AppText.sans(size: 12.5, color: AppColors.txt)),
              ),
              // 有自評用自評分（1-5）；否則以站方評分 d.score（0-10）換算填色（/2）。
              Builder(builder: (_) {
                final int filled = _myScore ??
                    ((double.tryParse(d.score ?? '') ?? 0) / 2)
                        .round()
                        .clamp(0, 5);
                return Row(
                  children: [
                    for (int i = 1; i <= 5; i++)
                      Icon(Icons.star_rounded,
                          size: 13,
                          color: i <= filled
                              ? AppColors.acc
                              : AppColors.mut.withValues(alpha: 0.4)),
                  ],
                );
              }),
              const SizedBox(width: 6),
              Text('›', style: AppText.sans(size: 16, color: AppColors.mut)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _comments(NovelDetail d) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('書友評論', style: AppText.serif(size: 16, color: AppColors.txt)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) =>
                  ReviewListPage(novelId: d.id, title: d.title),
            )),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                  color: AppColors.surf,
                  borderRadius: BorderRadius.circular(14)),
              child: Row(
                children: [
                  const Icon(Icons.rate_review_outlined,
                      size: 16, color: AppColors.acc),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('查看書友書評',
                        style: AppText.sans(size: 12.5, color: AppColors.txt)),
                  ),
                  Text('›', style: AppText.sans(size: 16, color: AppColors.mut)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(
                  text: '${AppConfig.origin}/novel/${d.id}.html'));
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已複製書籍連結，可於官網參與討論')));
            },
            child: Text('複製書籍連結，前往官網撰寫/回覆書評',
                style: AppText.sans(size: 11, color: AppColors.mut)),
          ),
        ],
      ),
    );
  }

  Widget _tag(String t) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(999)),
        child: Text(t, style: AppText.sans(size: 10, color: AppColors.acc)),
      );

  Widget _stats(NovelDetail d) {
    final items = <List<String>>[
      [d.wordCount?.replaceAll(' ', '') ?? '—', '字數'],
      [d.status ?? '—', '狀態'],
      [d.score ?? '—', '評分'],
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22),
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
          color: AppColors.surf, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0)
              Container(width: 1, height: 28, color: AppColors.line),
            Expanded(
              child: Column(
                children: [
                  Text(items[i][0],
                      style: AppText.mono(
                          size: 15,
                          weight: FontWeight.w700,
                          color: AppColors.txt)),
                  const SizedBox(height: 4),
                  Text(items[i][1],
                      style: AppText.sans(size: 10, color: AppColors.mut)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// 「下載內容非最新」橫幅（僅已下載且偵測到新章節時顯示）。點更新→確認→增量補下新章節。
  Widget _updateBanner(NovelDetail d) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 14, 10),
      color: AppColors.cov,
      child: Row(
        children: [
          const Text('↻ ',
              style: TextStyle(color: AppColors.hotOrange, fontSize: 15)),
          Expanded(
            child: Text('下載內容非最新 · 有 $_newChapters 章新章節',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.sans(size: 12, color: AppColors.txt)),
          ),
          GestureDetector(
            onTap: () => _updateDownload(d),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.accBorder),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text('更新', style: AppText.sans(size: 12, color: AppColors.acc)),
            ),
          ),
        ],
      ),
    );
  }

  /// 更新下載：確認後以最新目錄重新入列——保留已下載章節、只補新章節（增量，非全刪重下）。
  Future<void> _updateDownload(NovelDetail d) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surf,
        title: Text('更新下載',
            style: AppText.serif(size: 15, color: AppColors.txt)),
        content: Text(
            '偵測到 $_newChapters 章新章節。\n更新會保留已下載章節，只補下載新章節。',
            style: AppText.sans(size: 13, color: AppColors.mut, height: 1.6)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text('取消',
                  style: AppText.sans(size: 13, color: AppColors.mut))),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text('更新',
                  style: AppText.sans(size: 13, color: AppColors.acc))),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
          child:
              CircularProgressIndicator(strokeWidth: 2, color: AppColors.acc)),
    );
    try {
      final cat = await LinovelibApi.instance.catalog(d.id);
      final flat = cat.flattened();
      if (!mounted) return;
      navigator.pop(); // 關閉 loading
      OfflineStore.instance.enqueue(d.id, d.title, d.coverUrl, flat);
      setState(() => _newChapters = 0);
      messenger
          .showSnackBar(const SnackBar(content: Text('已開始更新下載（只補新章節）')));
      navigator.push(
          MaterialPageRoute(builder: (_) => const DownloadManagerPage()));
    } catch (_) {
      if (!mounted) return;
      navigator.pop();
      messenger
          .showSnackBar(const SnackBar(content: Text('更新失敗，請稍後再試')));
    }
  }

  Widget _bottomBar(NovelDetail d) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _iconBtn('⤓', () => _download(d)),
            const SizedBox(width: 10),
            Expanded(child: _shelfToggleBtn(d)),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () => _startReading(d),
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                      color: AppColors.acc,
                      borderRadius: BorderRadius.circular(16)),
                  alignment: Alignment.center,
                  child: Text(
                      LocalStore.instance.progressOf(d.id) != null
                          ? '繼續閱讀'
                          : '開始閱讀',
                      style: AppText.sans(
                          size: 13,
                          weight: FontWeight.w700,
                          color: AppColors.btxt)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(String icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
            border: Border.all(color: AppColors.line),
            borderRadius: BorderRadius.circular(16)),
        alignment: Alignment.center,
        child: Text(icon, style: AppText.sans(size: 18, color: AppColors.acc)),
      ),
    );
  }

  Future<void> _download(NovelDetail d) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    if (OfflineStore.instance.hasNovel(d.id)) {
      navigator.push(MaterialPageRoute(
          builder: (_) => const DownloadManagerPage()));
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
          child:
              CircularProgressIndicator(strokeWidth: 2, color: AppColors.acc)),
    );
    try {
      final cat = await LinovelibApi.instance.catalog(d.id);
      final flat = cat.flattened(); // 帶卷名 → 離線閱讀器目錄也能分卷
      if (!mounted) return;
      navigator.pop(); // 關閉 loading
      OfflineStore.instance.enqueue(d.id, d.title, d.coverUrl, flat);
      messenger.showSnackBar(SnackBar(content: Text('已開始下載（共 ${flat.length} 章）')));
      navigator
          .push(MaterialPageRoute(builder: (_) => const DownloadManagerPage()));
    } catch (_) {
      if (!mounted) return;
      navigator.pop();
      messenger
          .showSnackBar(const SnackBar(content: Text('下載啟動失敗，請稍後再試')));
    }
  }

  /// 收藏切換鈕（伺服器狀態）：已收藏 → 點按移除；未收藏 → 點按加入。
  /// 初始態解析自詳情頁收藏鈕（`#a_delbookcase`）；未登入點按提示登入；防連點。
  Widget _shelfToggleBtn(NovelDetail d) {
    final bool shelved = _shelvedOverride ?? d.shelved;
    return GestureDetector(
      onTap: () => _toggleShelf(d),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
            border: Border.all(
                color: shelved ? AppColors.accBorder : AppColors.line),
            borderRadius: BorderRadius.circular(16)),
        alignment: Alignment.center,
        child: _shelfBusy
            ? const SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppColors.acc))
            : Text(shelved ? '★ 已收藏' : '＋ 書架',
                style: AppText.sans(
                    size: 13,
                    color: shelved ? AppColors.acc : AppColors.txt)),
      ),
    );
  }

  Future<void> _toggleShelf(NovelDetail d) async {
    if (_shelfBusy) return;
    final messenger = ScaffoldMessenger.of(context);
    if (!AuthController.instance.isLoggedIn) {
      messenger.showSnackBar(const SnackBar(content: Text('請先登入才能收藏')));
      return;
    }
    final bool shelved = _shelvedOverride ?? d.shelved;
    setState(() => _shelfBusy = true);
    final bool ok = shelved
        ? await LinovelibApi.instance.removeFromShelf(d.id)
        : await LinovelibApi.instance.addToShelf(d.id);
    if (!mounted) return;
    setState(() {
      _shelfBusy = false;
      if (ok) _shelvedOverride = !shelved;
    });
    if (ok) ShelfEvents.instance.bumped(); // 通知書架分頁/我的收藏數即時刷新（跨頁一致）
    messenger.showSnackBar(SnackBar(
        content: Text(ok
            ? (shelved ? '已移除書架' : '已加入書架')
            : '操作失敗（請確認登入）')));
  }

}
