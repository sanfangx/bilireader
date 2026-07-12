import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/catalog.dart';
import '../../core/reading/local_store.dart';
import '../../core/storage/database/database_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_background.dart';
import '../reader/presentation/reader_page.dart';
import 'catalog_providers.dart';

/// 章節目錄頁。目錄走 drift cache-first（`novelCatalogProvider`）；下拉強制重整。
class CatalogPage extends ConsumerStatefulWidget {
  const CatalogPage({super.key, required this.novelId, required this.title});

  final String novelId;
  final String title;

  @override
  ConsumerState<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends ConsumerState<CatalogPage> {
  bool _asc = true;

  Future<void> _refresh() async {
    final int aid = int.tryParse(widget.novelId) ?? 0;
    if (aid > 0) {
      await ref.read(chapterCacheDaoProvider).deleteCatalog(aid);
    }
    ref.invalidate(novelCatalogProvider(widget.novelId));
  }

  void _openChapter(List<Chapter> flat, int index) {
    // 不預先信任 VIP 標記（站方可能拿來騙爬蟲）→ 一律進閱讀器嘗試取得內文；
    // 壞連結（url==null）會由閱讀器沿閱讀鏈解析真實 URL。
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ReaderPage(
        articleId: int.tryParse(widget.novelId) ?? 0,
        chapters: flat,
        startIndex: index,
        articleName: widget.title,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<Catalog> catalog =
        ref.watch(novelCatalogProvider(widget.novelId));
    final Catalog? data = catalog.asData?.value;
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              _topBar(),
              _head(data),
              _bar(),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.acc,
                  backgroundColor: AppColors.surf,
                  onRefresh: _refresh,
                  // 監聽本機進度：從閱讀器讀到後面章節返回時，「閱讀中」標記即時跳到正確章
                  // （修正舊版需下拉/切排序才更新的 stale）。
                  child: ListenableBuilder(
                    listenable: LocalStore.instance,
                    builder: (context, _) => catalog.when(
                      skipLoadingOnRefresh: true,
                      loading: () => const Center(
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: AppColors.acc)),
                      // 補 physics：短內容也能 overscroll → 下拉重試（唯一重試手段）才觸發得了。
                      error: (Object e, StackTrace _) => ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 120),
                          Center(
                            child: Text('載入失敗\n下拉可重試',
                                textAlign: TextAlign.center,
                                style: AppText.sans(
                                    size: 13, color: AppColors.mut, height: 1.7)),
                          ),
                        ],
                      ),
                      data: _list,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar() => Padding(
        padding: const EdgeInsets.fromLTRB(22, 4, 22, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).maybePop(),
              child:
                  Text('‹', style: AppText.sans(size: 26, color: AppColors.mut)),
            ),
            Text('目錄', style: AppText.serif(size: 14, color: AppColors.txt)),
            const SizedBox(width: 20),
          ],
        ),
      );

  Widget _head(Catalog? c) => Padding(
        padding: const EdgeInsets.fromLTRB(22, 2, 22, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.serif(size: 18, color: AppColors.txt)),
            const SizedBox(height: 5),
            Text(
              c == null
                  ? '載入中…'
                  : '共 ${c.chapterCount} 章 · ${c.volumes.length} 卷',
              style: AppText.sans(size: 11, color: AppColors.mut),
            ),
          ],
        ),
      );

  Widget _bar() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.line))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('全部章節',
                style: AppText.sans(size: 12, color: AppColors.mut)),
            GestureDetector(
              onTap: () => setState(() => _asc = !_asc),
              child: Row(
                children: [
                  Text('⇅ ', style: AppText.sans(size: 13, color: AppColors.acc)),
                  Text(_asc ? '正序' : '倒序',
                      style: AppText.sans(
                          size: 12,
                          weight: FontWeight.w600,
                          color: AppColors.acc)),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _list(Catalog cat) {
    // 全書閱讀順序的扁平章節清單(供閱讀器自動推進 + 內建目錄分卷);依顯示排序渲染。
    // flattened() 每章為帶卷名的新實例，故攤平索引改以各卷起始位置累加計算（不可 indexOf）。
    final flat = cat.flattened();
    final readingIdx = LocalStore.instance.progressOf(widget.novelId)?.chapterIndex;
    final bases = <int>[]; // 各卷在閱讀順序攤平清單中的起始索引（正序累加）
    int acc = 0;
    for (final v in cat.volumes) {
      bases.add(acc);
      acc += v.chapters.length;
    }
    final order = List<int>.generate(
        cat.volumes.length, (i) => _asc ? i : cat.volumes.length - 1 - i);
    final rows = <Widget>[];
    for (final vi in order) {
      final v = cat.volumes[vi];
      if (v.name.isNotEmpty) rows.add(_volHeader(v.name));
      final n = v.chapters.length;
      for (int j = 0; j < n; j++) {
        final local = _asc ? j : n - 1 - j; // 卷內位置（正序）
        final flatIdx = bases[vi] + local; // 閱讀順序攤平索引
        final ch = v.chapters[local];
        rows.add(_chapterRow(ch, local + 1, flatIdx == readingIdx,
            () => _openChapter(flat, flatIdx)));
      }
    }
    return ListView(
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      children: rows,
    );
  }

  Widget _volHeader(String name) => Container(
        width: double.infinity,
        color: AppColors.surf,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
        child: Text(name,
            style: AppText.mono(
                size: 10, color: AppColors.mut, letterSpacing: 1.4)),
      );

  Widget _chapterRow(Chapter c, int num, bool reading, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.line))),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
        child: Row(
          children: [
            SizedBox(
              width: 26,
              child: Text(num.toString().padLeft(2, '0'),
                  style: AppText.mono(size: 11, color: AppColors.mut)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(c.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.sans(
                      size: 13,
                      color: reading ? AppColors.acc : AppColors.txt)),
            ),
            // VIP 膠囊（對齊 api-ver ④）：純資訊標示，仍一律進閱讀器嘗試取內文（不預先擋）。
            if (c.vip)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Icon(Icons.lock_outline,
                    size: 13, color: AppColors.mut.withValues(alpha: 0.7)),
              ),
            if (reading)
              Container(
                margin: const EdgeInsets.only(left: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: AppColors.acc.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999)),
                child: Text('閱讀中',
                    style: AppText.sans(size: 10, color: AppColors.acc)),
              ),
          ],
        ),
      ),
    );
  }
}
