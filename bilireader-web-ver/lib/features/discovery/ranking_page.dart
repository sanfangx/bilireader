import 'package:flutter/material.dart';

import '../../core/discovery/paged_list_controller.dart';
import '../../core/models/novel_summary.dart';
import '../../core/network/linovelib_api.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_background.dart';
import 'novel_list_view.dart';
import 'taxonomy.dart';

/// 排行榜 — 維度 + 週/月 + 全部/限完本。
class RankingPage extends StatefulWidget {
  const RankingPage({
    super.key,
    this.initialMetricIdx = 0,
    this.initialPeriod = 'month',
    this.initialFull = false,
  });

  /// 初始榜單維度（對齊 Taxonomy.rankMetrics：0 點擊 / 1 推薦 / 2 鮮花 / 3 收藏 / 4 新書）。
  final int initialMetricIdx;

  /// 初始週期（'week' / 'month'）。
  final String initialPeriod;

  /// 初始是否僅限完本（走 /topfull）——供「完本書庫」入口直接進完本榜。
  final bool initialFull;

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  late int _metricIdx = widget.initialMetricIdx.clamp(
    0,
    Taxonomy.rankMetrics.length - 1,
  );
  late String _period = widget.initialPeriod;
  late bool _full = widget.initialFull;

  late final PagedListController<NovelSummary> _controller =
      PagedListController<NovelSummary>(
        fetcher: (page, token) => LinovelibApi.instance.ranking(
          metric: _metric,
          full: _full,
          page: page,
          cancelToken: token,
        ),
        idOf: (n) => n.id,
      );

  @override
  void initState() {
    super.initState();
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _metric {
    final m = Taxonomy.rankMetrics[_metricIdx].value as String;
    if (m == 'goodnum' || m == 'newhot') return m;
    return '$_period$m';
  }

  /// 篩選（維度/週期/完本）變更 → 重載第一頁（控制器會取消在途請求）。
  void _reload() {
    setState(() {}); // 刷新膠囊選中態。
    _controller.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              _topBar(),
              _metricTabs(),
              _toggles(),
              const SizedBox(height: 4),
              Expanded(
                child: PagedNovelListView(
                  controller: _controller,
                  showRank: true,
                  emptyMessage: '這個榜單暫無資料',
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
          child: Text('‹', style: AppText.sans(size: 26, color: AppColors.mut)),
        ),
        Text('排行榜', style: AppText.serif(size: 14, color: AppColors.txt)),
        const SizedBox(width: 20),
      ],
    ),
  );

  Widget _metricTabs() => SizedBox(
    height: 32,
    // 視口內縮 22 → 列尾 tab 收在內容右緣，不溢到螢幕邊（外層 Padding 收縮 viewport）。
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: Taxonomy.rankMetrics.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (c, i) {
          final on = i == _metricIdx;
          return GestureDetector(
            onTap: () {
              if (i == _metricIdx) return; // 同值守衛：不清空已載清單重打
              _metricIdx = i;
              _reload();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: on ? AppColors.cov : AppColors.surf,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: on ? AppColors.acc : Colors.transparent,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                Taxonomy.rankMetrics[i].label,
                style: AppText.sans(
                  size: 11.5,
                  weight: on ? FontWeight.w600 : FontWeight.w400,
                  color: on ? AppColors.acc : AppColors.mut,
                ),
              ),
            ),
          );
        },
      ),
    ),
  );

  Widget _toggles() {
    final metric = Taxonomy.rankMetrics[_metricIdx].value as String;
    final periodic = metric != 'goodnum' && metric != 'newhot';
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (periodic)
            _seg(['週榜', '月榜'], _period == 'week' ? 0 : 1, (i) {
              final p = i == 0 ? 'week' : 'month';
              if (p == _period) return; // 同值守衛
              _period = p;
              _reload();
            })
          else
            const SizedBox.shrink(),
          _seg(['全部', '限完本'], _full ? 1 : 0, (i) {
            final f = i == 1;
            if (f == _full) return; // 同值守衛
            _full = f;
            _reload();
          }),
        ],
      ),
    );
  }

  Widget _seg(List<String> labels, int active, ValueChanged<int> onTap) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surf,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < labels.length; i++)
            GestureDetector(
              onTap: () => onTap(i),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: i == active ? AppColors.acc : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  labels[i],
                  style: AppText.sans(
                    size: 10.5,
                    weight: i == active ? FontWeight.w700 : FontWeight.w400,
                    color: i == active ? AppColors.btxt : AppColors.mut,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
