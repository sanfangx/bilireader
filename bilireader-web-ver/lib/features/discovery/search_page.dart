import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_background.dart';
import 'library_page.dart';
import 'search_results_page.dart';
import 'taxonomy.dart';

/// 搜尋 / 分類瀏覽。
/// linovelib 無原生書籍搜尋 API → 關鍵字走站外搜尋;主體為依來源 / 題材瀏覽。
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() {
    final q = _ctrl.text.trim();
    if (q.isEmpty) {
      // 空字串不再靜默無反應：提示需輸入關鍵字。
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('請輸入搜尋關鍵字')));
      return;
    }
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => SearchResultsPage(query: q)));
  }

  void _openLibrary({int rgroupid = 0, int tagid = 0, String title = '文庫'}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LibraryPage(
          initialTagid: tagid,
          initialRgroupid: rgroupid,
          title: title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 6, 22, 14),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Text(
                        '‹',
                        style: AppText.sans(size: 24, color: AppColors.mut),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 42,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: AppColors.surf,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '⌕',
                              style: AppText.sans(
                                size: 15,
                                color: AppColors.mut,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _ctrl,
                                style: AppText.sans(
                                  size: 13,
                                  color: AppColors.txt,
                                ),
                                cursorColor: AppColors.acc,
                                textInputAction: TextInputAction.search,
                                onSubmitted: (_) => _submit(),
                                onChanged: (_) => setState(() {}), // 更新清空鈕顯示
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  hintText: '搜尋書名、作者（站外）',
                                  hintStyle: AppText.sans(
                                    size: 13,
                                    color: AppColors.mut,
                                  ),
                                ),
                              ),
                            ),
                            // 清空鈕（有輸入才顯示）。
                            if (_ctrl.text.isNotEmpty)
                              GestureDetector(
                                onTap: () => setState(() => _ctrl.clear()),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: AppColors.mut,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _submit,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          '搜尋',
                          style: AppText.sans(size: 13, color: AppColors.acc),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _section('依來源瀏覽'),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 8),
                crossAxisCount: 2,
                mainAxisSpacing: 11,
                crossAxisSpacing: 11,
                childAspectRatio: 2.6,
                children: Taxonomy.sources.map((s) => _sourceCard(s)).toList(),
              ),
              const SizedBox(height: 16),
              _section('熱門題材 · tagid'),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
                child: Wrap(
                  spacing: 9,
                  runSpacing: 9,
                  children: Taxonomy.allTags
                      .take(10)
                      .map(
                        (t) => GestureDetector(
                          onTap: () => _openLibrary(
                            tagid: t.value as int,
                            title: t.label,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surf,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              t.label,
                              style: AppText.sans(
                                size: 12,
                                color: AppColors.txt,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _section(String t) => Padding(
    padding: const EdgeInsets.fromLTRB(22, 6, 22, 12),
    child: Text(t, style: AppText.sans(size: 12, color: AppColors.mut)),
  );

  Widget _sourceCard(Taxon s) {
    final label = s.label == '不限' ? '全部文庫' : s.label;
    return GestureDetector(
      onTap: () => _openLibrary(
        rgroupid: s.value as int,
        title: s.label == '不限' ? '文庫' : s.label,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surf,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.cov,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                _badge(label),
                style: AppText.serif(size: 13, color: AppColors.acc),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.serif(size: 14, color: AppColors.txt),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '瀏覽此來源',
                    style: AppText.sans(size: 9.5, color: AppColors.mut),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _badge(String label) {
    if (label.contains('全部')) return '全';
    if (label.contains('日')) return '日';
    if (label.contains('華')) return '華';
    if (label.contains('Web')) return 'W';
    if (label.contains('改') || label.contains('漫畫')) return '改';
    if (label.contains('韓')) return '韓';
    return label.substring(0, 1);
  }
}
