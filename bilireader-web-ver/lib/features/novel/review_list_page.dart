import 'package:flutter/material.dart';

import '../../core/models/book_review.dart';
import '../../core/network/linovelib_api.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_background.dart';
import '../../widgets/network_cover.dart';
import '../../widgets/simple_web_view_page.dart';

/// 書評列表（唯讀爬取 `/reviews_{aid}_{page}.html`）。分頁滾動載入；點選開站方書評詳情。
class ReviewListPage extends StatefulWidget {
  const ReviewListPage({super.key, required this.novelId, required this.title});

  final String novelId;
  final String title;

  @override
  State<ReviewListPage> createState() => _ReviewListPageState();
}

class _ReviewListPageState extends State<ReviewListPage> {
  final List<BookReview> _reviews = [];
  final Set<String> _seen = {}; // 跨頁去重鍵（防站方對超範圍頁碼回吐最後一頁 → 無限重複）
  final ScrollController _scroll = ScrollController();
  int _page = 1;
  bool _loading = false;
  bool _end = false;
  bool _error = false;

  static String _key(BookReview r) => '${r.author}|${r.timeText}|${r.preview}';

  @override
  void initState() {
    super.initState();
    _load();
    _scroll.addListener(() {
      if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 320) {
        _load();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    // 納入 _error：失敗後不再每個 scroll frame 狂重打同一失敗請求（要靠 footer 明確重試）。
    if (_loading || _end || _error) return;
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final list =
          await LinovelibApi.instance.reviews(widget.novelId, page: _page);
      if (!mounted) return;
      // 去重：只收未見過的；本頁 0 新項（空頁或站方回吐重複最後一頁）→ 到底。
      final fresh = list.where((r) => _seen.add(_key(r))).toList();
      setState(() {
        if (fresh.isEmpty) {
          _end = true;
        } else {
          _reviews.addAll(fresh);
          _page++;
        }
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _reviews.clear();
      _seen.clear();
      _page = 1;
      _end = false;
      _error = false;
    });
    await _load();
  }

  void _open(BookReview r) {
    if (r.detailUrl.isEmpty) return;
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => SimpleWebViewPage(url: r.detailUrl, title: '書評'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              _topBar(),
              Expanded(child: _body()),
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
              child: Text('‹',
                  style: AppText.sans(size: 26, color: AppColors.mut)),
            ),
            Text('書評', style: AppText.serif(size: 14, color: AppColors.txt)),
            const SizedBox(width: 20),
          ],
        ),
      );

  Widget _body() {
    if (_reviews.isEmpty) {
      if (_loading) {
        return const Center(
            child: CircularProgressIndicator(
                strokeWidth: 2, color: AppColors.acc));
      }
      if (_error) {
        return _centered('載入失敗，點此重試', onTap: () {
          setState(() => _error = false); // 先解除守衛才能重試
          _load();
        });
      }
      return _centered('目前還沒有書評');
    }
    return RefreshIndicator(
      color: AppColors.acc,
      backgroundColor: AppColors.surf,
      onRefresh: _refresh,
      child: ListView.builder(
        controller: _scroll,
        padding: EdgeInsets.zero,
        itemCount: _reviews.length + 1,
        itemBuilder: (context, i) {
          if (i == _reviews.length) return _footer();
          return _item(_reviews[i]);
        },
      ),
    );
  }

  Widget _centered(String msg, {VoidCallback? onTap}) => Center(
        child: GestureDetector(
          onTap: onTap,
          child: Text(msg, style: AppText.sans(size: 13, color: AppColors.mut)),
        ),
      );

  Widget _footer() {
    if (_end) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text('— 沒有更多書評 —',
              style: AppText.sans(size: 11, color: AppColors.mut)),
        ),
      );
    }
    // 載入更多失敗（有舊資料）：顯示可點重試，而非永遠轉圈的假載入。
    if (_error && !_loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Center(
          child: GestureDetector(
            onTap: () {
              setState(() => _error = false); // 先解除守衛才能重試
              _load();
            },
            child: Text('載入失敗，點此重試',
                style: AppText.sans(size: 12, color: AppColors.acc)),
          ),
        ),
      );
    }
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 18),
      child: Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child:
              CircularProgressIndicator(strokeWidth: 2, color: AppColors.acc),
        ),
      ),
    );
  }

  Widget _item(BookReview r) => InkWell(
        onTap: () => _open(r),
        child: Container(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.line))),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NetworkCover(url: r.avatarUrl, width: 38, height: 38, radius: 19),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(r.author,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.sans(
                                  size: 13,
                                  weight: FontWeight.w600,
                                  color: AppColors.txt)),
                        ),
                        Text(r.timeText,
                            style:
                                AppText.mono(size: 10, color: AppColors.mut)),
                      ],
                    ),
                    if (r.preview.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(r.preview,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.sans(
                              size: 13, color: AppColors.rtxt, height: 1.5)),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.thumb_up_alt_outlined,
                            size: 12, color: AppColors.mut),
                        const SizedBox(width: 4),
                        Text('${r.likes}',
                            style:
                                AppText.mono(size: 10, color: AppColors.mut)),
                        const SizedBox(width: 16),
                        const Icon(Icons.chat_bubble_outline,
                            size: 12, color: AppColors.mut),
                        const SizedBox(width: 4),
                        Text('${r.replies}',
                            style:
                                AppText.mono(size: 10, color: AppColors.mut)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
