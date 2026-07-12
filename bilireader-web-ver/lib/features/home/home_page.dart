import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/models/novel_summary.dart';
import '../../core/network/linovelib_api.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/network_cover.dart';
import '../discovery/library_page.dart';
import '../discovery/ranking_page.dart';
import '../discovery/search_page.dart';
import '../discovery/taxonomy.dart';
import '../novel/novel_detail_page.dart';

void _openNovel(BuildContext context, String id) {
  Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => NovelDetailPage(id: id)));
}

/// 書城 Home — 對齊 api-ver DiscoverPage：品牌列 + 搜尋 + 輪播 + 題材 chips +
/// 強力推薦（橫向書卡）+ 點擊榜（直式榜單）。四內容區各自獨立載入，一區失敗不拖累全頁。
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<NovelSummary>> _carousel; // 輪播（推薦月榜 top-5，降級合成）
  late Future<List<NovelSummary>> _strong; // 強力推薦（週推薦榜，橫向書卡）
  late Future<List<NovelSummary>> _hot; // 點擊榜（週點擊，take 8）

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  void _loadAll() {
    _carousel = LinovelibApi.instance.ranking(metric: 'monthvote');
    _strong = LinovelibApi.instance.ranking(metric: 'weekvote');
    _hot = LinovelibApi.instance.ranking(metric: 'weekvisit');
  }

  Future<void> _reload() async {
    setState(_loadAll);
    // 主資料抓完才結束下拉動畫；個別失敗由各區自呈現。
    await Future.wait<void>([
      _carousel.then<void>((_) {}).catchError((_) {}),
      _strong.then<void>((_) {}).catchError((_) {}),
      _hot.then<void>((_) {}).catchError((_) {}),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        color: AppColors.acc,
        backgroundColor: AppColors.surf,
        onRefresh: _reload,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: _Header()),
            const SliverToBoxAdapter(child: _SearchBar()),
            SliverToBoxAdapter(
              child: _CarouselSection(future: _carousel, onRetry: _reload),
            ),
            const SliverToBoxAdapter(child: _Chips()),
            SliverToBoxAdapter(
              child: _StrongRec(future: _strong, onRetry: _reload),
            ),
            SliverToBoxAdapter(
              child: _HotRank(future: _hot, onRetry: _reload),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 6, 22, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('書城', style: AppText.serif(size: 23, color: AppColors.txt)),
              const SizedBox(height: 3),
              Text(
                'BILI · 輕小說',
                style: AppText.mono(
                  size: 10,
                  color: AppColors.mut,
                  letterSpacing: 2.2,
                ),
              ),
            ],
          ),
          Semantics(
            button: true,
            label: '排行榜',
            child: GestureDetector(
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const RankingPage())),
              child: Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: AppColors.surf,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.leaderboard_outlined,
                  size: 17,
                  color: AppColors.txt,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 18),
      child: GestureDetector(
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const SearchPage())),
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: AppColors.surf,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text('⌕', style: AppText.sans(size: 15, color: AppColors.mut)),
              const SizedBox(width: 9),
              Text(
                '搜尋書名、作者、標籤',
                style: AppText.sans(size: 13, color: AppColors.mut),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 輪播區：載入中顯骨架；失敗顯錯誤+重試（不再靜默消失）；有資料 → 多張 hero 輪播。
class _CarouselSection extends StatelessWidget {
  const _CarouselSection({required this.future, required this.onRetry});
  final Future<List<NovelSummary>> future;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NovelSummary>>(
      future: future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(22, 0, 22, 20),
            child: _SkeletonBox(height: 150, radius: 22),
          );
        }
        if (snap.hasError) return _SectionError(onRetry: onRetry);
        final books = (snap.data ?? const <NovelSummary>[]).take(5).toList();
        if (books.isEmpty) return const SizedBox(height: 4);
        return _Carousel(books: books);
      },
    );
  }
}

/// 對齊設計 .caro：16/9 高、圓角 22、底部漸層、describe 白字、頁碼點；自動輪播（reduce-motion 停）。
class _Carousel extends StatefulWidget {
  const _Carousel({required this.books});
  final List<NovelSummary> books;

  @override
  State<_Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<_Carousel> {
  final PageController _pc = PageController();
  int _page = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeAutoplay());
  }

  void _maybeAutoplay() {
    if (!mounted) return;
    final bool reduce = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduce || widget.books.length <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_pc.hasClients) return;
      final int next = (_page + 1) % widget.books.length;
      _pc.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                controller: _pc,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: widget.books.length,
                itemBuilder: (c, i) => _slide(widget.books[i]),
              ),
              // 頁碼點
              Positioned(
                right: 14,
                bottom: 12,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < widget.books.length; i++)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(left: 5),
                        width: i == _page ? 18 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: i == _page ? AppColors.acc : Colors.white54,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _slide(NovelSummary n) {
    return GestureDetector(
      onTap: () => _openNovel(context, n.id),
      child: Stack(
        fit: StackFit.expand,
        children: [
          NetworkCover(url: n.coverUrl, radius: 0),
          // 底部漸層
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xCC000000)],
                stops: [0.45, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 70,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '本月推薦',
                  style: AppText.mono(
                    size: 8.5,
                    color: AppColors.acc,
                    letterSpacing: 1.6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  n.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.serif(
                    size: 16,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 題材 chips：可點 → 文庫 tagid 篩選（對齊 api-ver tags）。取 Taxonomy.genres。
class _Chips extends StatelessWidget {
  const _Chips();
  @override
  Widget build(BuildContext context) {
    // 跳過 genres[0]（'不限'，等於不篩選）→ 首個高亮 chip 是真正的題材。
    final items = Taxonomy.genres.skip(1).take(12).toList();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: SizedBox(
        height: 32,
        // 水平列視口收進 22px 邊界 → 項目 peek 收在內容右緣（1022），與輪播/section 齊，
        // 不再溢出到螢幕邊（1080）造成右緣參差。
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (c, i) {
              final t = items[i];
              final on = i == 0;
              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LibraryPage(
                      initialTagid: t.value is int ? t.value as int : 0,
                      title: t.label,
                    ),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: on ? AppColors.acc : AppColors.surf,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    t.label,
                    style: AppText.sans(
                      size: 12,
                      weight: on ? FontWeight.w700 : FontWeight.w500,
                      color: on ? AppColors.btxt : AppColors.mut,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// 強力推薦：橫向書卡列（週推薦榜）。獨立載入，失敗顯錯誤+重試、空則隱藏。
class _StrongRec extends StatelessWidget {
  const _StrongRec({required this.future, required this.onRetry});
  final Future<List<NovelSummary>> future;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NovelSummary>>(
      future: future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(22, 18, 22, 12),
            child: _SkeletonBox(height: 214, radius: 12),
          );
        }
        if (snap.hasError) return _SectionError(onRetry: onRetry);
        final books = (snap.data ?? const <NovelSummary>[]).take(10).toList();
        if (books.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: '強力推薦',
              onMore: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const RankingPage(
                    initialMetricIdx: 1,
                    initialPeriod: 'week',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 214,
              // 水平列視口收進 22px 邊界 → 卡片 peek 收在內容右緣（1022），與輪播/section 齊，
              // 不再溢出到螢幕邊（1080）造成右緣參差。
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  itemCount: books.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (c, i) => _RecCard(novel: books[i]),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RecCard extends StatelessWidget {
  const _RecCard({required this.novel});
  final NovelSummary novel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openNovel(context, novel.id),
      child: SizedBox(
        width: 104,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NetworkCover(
              url: novel.coverUrl,
              width: 104,
              height: 146,
              radius: 12,
            ),
            const SizedBox(height: 8),
            Text(
              novel.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppText.serif(
                size: 12.5,
                color: AppColors.txt,
                height: 1.3,
              ),
            ),
            if (novel.author != null && novel.author!.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(
                novel.author!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.sans(size: 10, color: AppColors.mut),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 點擊榜：週點擊 take 8 直式榜單。獨立載入。
class _HotRank extends StatelessWidget {
  const _HotRank({required this.future, required this.onRetry});
  final Future<List<NovelSummary>> future;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NovelSummary>>(
      future: future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(22, 18, 22, 8),
            child: _SkeletonBox(height: 240, radius: 12),
          );
        }
        if (snap.hasError) return _SectionError(onRetry: onRetry);
        final books = (snap.data ?? const <NovelSummary>[]).take(8).toList();
        if (books.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: '點擊榜',
              onMore: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const RankingPage(
                    initialMetricIdx: 0,
                    initialPeriod: 'week',
                  ),
                ),
              ),
            ),
            for (int i = 0; i < books.length; i++)
              _RankRow(novel: books[i], rank: i + 1),
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onMore});
  final String title;
  final VoidCallback? onMore;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppText.serif(size: 16, color: AppColors.txt)),
          if (onMore != null)
            GestureDetector(
              onTap: onMore,
              child: Text(
                '更多 ›',
                style: AppText.sans(size: 12, color: AppColors.acc),
              ),
            ),
        ],
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  const _RankRow({required this.novel, required this.rank});
  final NovelSummary novel;
  final int rank;
  @override
  Widget build(BuildContext context) {
    final top3 = rank <= 3;
    return InkWell(
      onTap: () => _openNovel(context, novel.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
        child: Row(
          children: [
            SizedBox(
              width: 26,
              child: Text(
                '$rank',
                style: AppText.mono(
                  size: 15,
                  weight: FontWeight.w700,
                  color: top3 ? AppColors.acc : AppColors.mut,
                ),
              ),
            ),
            const SizedBox(width: 13),
            NetworkCover(
              url: novel.coverUrl,
              width: 42,
              height: 58,
              radius: 10,
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    novel.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.serif(size: 14, color: AppColors.txt),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    novel.author ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.sans(size: 11, color: AppColors.mut),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 區塊骨架占位（微光矩形）。
class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({required this.height, this.radius = 12});
  final double height;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surf,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _SectionError extends StatelessWidget {
  const _SectionError({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
      child: Center(
        child: Column(
          children: [
            Text('載入失敗', style: AppText.sans(size: 12.5, color: AppColors.mut)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.accBorder),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '重試',
                  style: AppText.sans(size: 12, color: AppColors.acc),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
