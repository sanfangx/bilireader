import 'package:flutter/material.dart';

import '../../core/discovery/offsite_search.dart';
import '../../core/discovery/offsite_search_service.dart';
import '../../core/models/novel_summary.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_background.dart';
import '../../widgets/list_states.dart';
import 'novel_list_view.dart';
import 'web_search_fallback_page.dart';

/// 站外搜尋結果（原生卡片）。
///
/// Path B 主線：dio 直抓 DuckDuckGo（[OffsiteSearchService]）→ 原生清單。
/// Path A fallback：Path B 被擋（[OffsiteSearchBlocked]）→ 自動開 WebView（[WebSearchFallbackPage]）
/// 帶回結果。空態另提供「改用 Google（WebView）」入口（DDG 可能漏，Google 較全）。
class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key, required this.query});
  final String query;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

enum _Phase { loading, ready, empty, error }

class _SearchResultsPageState extends State<SearchResultsPage> {
  _Phase _phase = _Phase.loading;
  List<NovelSummary> _books = const [];

  @override
  void initState() {
    super.initState();
    _run();
  }

  /// Path B（dio+DDG）→ 失敗自動退 Path A（WebView）。
  Future<void> _run() async {
    setState(() => _phase = _Phase.loading);
    try {
      final r = await OffsiteSearchService.instance.search(widget.query);
      if (!mounted) return;
      setState(() {
        _books = r;
        _phase = r.isEmpty ? _Phase.empty : _Phase.ready;
      });
    } on OffsiteSearchBlocked {
      // 被擋 → 退 Path A（可見 WebView，能解 captcha / 用 Google）。
      await _openFallback(auto: true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _phase = _Phase.error);
    }
  }

  /// 開 Path A WebView，帶回結果。`auto`＝由 Path B 失敗自動觸發（回 null 時落到錯誤態，
  /// 而非空態，讓使用者知道是「被擋」而非「查無」）。
  Future<void> _openFallback({required bool auto}) async {
    if (!mounted) return;
    final r = await Navigator.of(context).push<List<NovelSummary>>(
      MaterialPageRoute(
        builder: (_) => WebSearchFallbackPage(query: widget.query),
      ),
    );
    if (!mounted) return;
    if (r != null) {
      setState(() {
        _books = r;
        _phase = r.isEmpty ? _Phase.empty : _Phase.ready;
      });
    } else if (auto) {
      // 自動 fallback 但使用者放棄 → 錯誤態（附重試/再試 WebView）。
      setState(() => _phase = _Phase.error);
    }
    // 手動 fallback 放棄 → 維持原狀態（多半是空態）。
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              _header(),
              Expanded(child: _body()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() => Padding(
    padding: const EdgeInsets.fromLTRB(22, 6, 22, 10),
    child: Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Text('‹', style: AppText.sans(size: 24, color: AppColors.mut)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.query,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.serif(size: 16, color: AppColors.txt),
              ),
              Text(
                '站外搜尋結果',
                style: AppText.mono(
                  size: 9.5,
                  color: AppColors.mut,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _body() {
    switch (_phase) {
      case _Phase.loading:
        return const ListSkeleton();
      case _Phase.error:
        return ListErrorView(message: '站外搜尋暫時受阻', onRetry: _run);
      case _Phase.empty:
        return _EmptyWithFallback(
          query: widget.query,
          onWebSearch: () => _openFallback(auto: false),
        );
      case _Phase.ready:
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: _books.length,
          itemBuilder: (c, i) => NovelCard(novel: _books[i]),
        );
    }
  }
}

/// 空態：查無結果，提供「改用 Google（WebView）」——DDG 可能漏、Google 較全。
class _EmptyWithFallback extends StatelessWidget {
  const _EmptyWithFallback({required this.query, required this.onWebSearch});
  final String query;
  final VoidCallback onWebSearch;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_outlined,
            size: 40,
            color: AppColors.mut.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            '找不到「$query」的相關作品',
            textAlign: TextAlign.center,
            style: AppText.sans(size: 13, color: AppColors.mut),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onWebSearch,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              decoration: BoxDecoration(
                color: AppColors.surf,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.acc.withValues(alpha: 0.5)),
              ),
              child: Text(
                '改用網頁搜尋',
                style: AppText.sans(
                  size: 12,
                  weight: FontWeight.w600,
                  color: AppColors.acc,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
