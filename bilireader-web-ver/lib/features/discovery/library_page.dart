import 'package:flutter/material.dart';

import '../../core/discovery/paged_list_controller.dart';
import '../../core/models/novel_summary.dart';
import '../../core/network/linovelib_api.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_background.dart';
import 'novel_list_view.dart';
import 'taxonomy.dart';

/// 文庫 — 排序 + 來源 + 題材 篩選。
class LibraryPage extends StatefulWidget {
  const LibraryPage({
    super.key,
    this.initialTagid = 0,
    this.initialRgroupid = 0,
    this.title = '文庫',
  });

  final int initialTagid;
  final int initialRgroupid;
  final String title;

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  String _order = 'monthvisit';
  late int _rgroupid = widget.initialRgroupid;
  late int _tagid = widget.initialTagid;

  late final PagedListController<NovelSummary> _controller =
      PagedListController<NovelSummary>(
        fetcher: (page, token) => LinovelibApi.instance.library(
          order: _order,
          rgroupid: _rgroupid,
          tagid: _tagid,
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

  /// 篩選變更 → 重載第一頁（控制器取消在途請求，避免舊頁覆蓋新篩選）。
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
              _FilterRow(
                label: '排序',
                options: Taxonomy.orders,
                selected: _order,
                onPick: (v) {
                  _order = v as String;
                  _reload();
                },
              ),
              _FilterRow(
                label: '來源',
                options: Taxonomy.sources,
                selected: _rgroupid,
                onPick: (v) {
                  if (v as int == _rgroupid) return; // 同值守衛
                  _rgroupid = v;
                  _reload();
                },
              ),
              _FilterRow(
                label: '題材',
                options: Taxonomy.genres,
                selected: _tagid,
                onPick: (v) {
                  if (v as int == _tagid) return; // 同值守衛
                  _tagid = v;
                  _reload();
                },
              ),
              const SizedBox(height: 6),
              Expanded(child: PagedNovelListView(controller: _controller)),
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
        Text(
          widget.title,
          style: AppText.serif(size: 14, color: AppColors.txt),
        ),
        const SizedBox(width: 20),
      ],
    ),
  );
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.label,
    required this.options,
    required this.selected,
    required this.onPick,
  });

  final String label;
  final List<Taxon> options;
  final Object selected;
  final ValueChanged<Object> onPick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 6, 10, 0),
            child: Text(
              label,
              style: AppText.sans(size: 11, color: AppColors.mut),
            ),
          ),
          Expanded(
            // 視口右緣內縮 22 → 列尾 chip 收在內容右緣，不溢到螢幕邊
            // （外層 Padding 收縮 viewport，而非 ListView 自身 padding）。
            child: Padding(
              padding: const EdgeInsets.only(right: 22),
              child: SizedBox(
                height: 28,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 7),
                  itemBuilder: (c, i) {
                    final t = options[i];
                    final on = t.value == selected;
                    return GestureDetector(
                      onTap: () => onPick(t.value),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: on ? AppColors.cov : AppColors.surf,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: on
                                ? AppColors.acc.withValues(alpha: 0.5)
                                : Colors.transparent,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          t.label,
                          style: AppText.sans(
                            size: 11,
                            weight: on ? FontWeight.w600 : FontWeight.w400,
                            color: on ? AppColors.acc : AppColors.mut,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
