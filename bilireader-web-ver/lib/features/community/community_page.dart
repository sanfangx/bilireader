import 'package:flutter/material.dart';

import '../../core/models/topic.dart';
import '../../core/network/linovelib_api.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_background.dart';
import '../../widgets/network_cover.dart';
import '../../widgets/simple_web_view_page.dart';

/// 圈子（社群貼文）唯讀列表（爬取 `/alltopics`）。分頁滾動載入；點選開站方貼文詳情。
/// 對齊 api-ver 第三分頁「圈子」；web-ver 暫以獨立頁進入（底部分頁保留「分類」為主要發現面）。
class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<Topic> _topics = [];
  final ScrollController _scroll = ScrollController();
  int _page = 1;
  bool _loading = false;
  bool _end = false;
  bool _error = false;

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
    // 納入 _error：失敗後不再每個 scroll frame 狂重打（要靠 footer 明確重試）。
    if (_loading || _end || _error) return;
    setState(() {
      _loading = true;
      _error = false;
    });
    try {
      final list = await LinovelibApi.instance.topics(page: _page);
      if (!mounted) return;
      setState(() {
        if (list.isEmpty) {
          _end = true;
        } else {
          _topics.addAll(list);
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
      _topics.clear();
      _page = 1;
      _end = false;
      _error = false;
    });
    await _load();
  }

  void _open(Topic t) {
    if (t.detailUrl.isEmpty) return;
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => SimpleWebViewPage(url: t.detailUrl, title: '圈子'),
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
            Text('圈子', style: AppText.serif(size: 14, color: AppColors.txt)),
            const SizedBox(width: 20),
          ],
        ),
      );

  Widget _body() {
    if (_topics.isEmpty) {
      if (_loading) {
        return const Center(
            child: CircularProgressIndicator(
                strokeWidth: 2, color: AppColors.acc));
      }
      if (_error) {
        return Center(
          child: GestureDetector(
            onTap: () {
              setState(() => _error = false); // 先解除守衛才能重試
              _load();
            },
            child: Text('載入失敗，點此重試',
                style: AppText.sans(size: 13, color: AppColors.mut)),
          ),
        );
      }
      return Center(
          child: Text('目前還沒有貼文',
              style: AppText.sans(size: 13, color: AppColors.mut)));
    }
    return RefreshIndicator(
      color: AppColors.acc,
      backgroundColor: AppColors.surf,
      onRefresh: _refresh,
      child: ListView.builder(
        controller: _scroll,
        padding: EdgeInsets.zero,
        itemCount: _topics.length + 1,
        itemBuilder: (context, i) {
          if (i == _topics.length) return _footer();
          return _item(_topics[i]);
        },
      ),
    );
  }

  Widget _footer() {
    if (_end) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text('— 沒有更多貼文 —',
              style: AppText.sans(size: 11, color: AppColors.mut)),
        ),
      );
    }
    // 分頁失敗（有舊資料）：顯示可點重試，而非永遠轉圈的假載入。
    if (_error && !_loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Center(
          child: GestureDetector(
            onTap: () {
              setState(() => _error = false);
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

  Widget _item(Topic t) => InkWell(
        onTap: () => _open(t),
        child: Container(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.line))),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NetworkCover(url: t.avatarUrl, width: 38, height: 38, radius: 19),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (t.title.isNotEmpty)
                      Text(t.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.sans(
                              size: 14,
                              weight: FontWeight.w600,
                              color: AppColors.txt)),
                    if (t.meta.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(t.meta,
                          style: AppText.mono(size: 10, color: AppColors.mut)),
                    ],
                    if (t.preview.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(t.preview,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.sans(
                              size: 12.5,
                              color: AppColors.rtxt,
                              height: 1.5)),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.thumb_up_alt_outlined,
                            size: 12, color: AppColors.mut),
                        const SizedBox(width: 4),
                        Text('${t.likes}',
                            style:
                                AppText.mono(size: 10, color: AppColors.mut)),
                        const SizedBox(width: 16),
                        const Icon(Icons.chat_bubble_outline,
                            size: 12, color: AppColors.mut),
                        const SizedBox(width: 4),
                        Text('${t.replies}',
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
