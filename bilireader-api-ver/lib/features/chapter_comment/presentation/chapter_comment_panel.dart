import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_result.dart';
import '../../../core/router/auth_controller.dart';
import '../../../core/social/reaction.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../data/chapter_comment_providers.dart';
import '../domain/chapter_comment_entities.dart';

/// 開啟閱讀器內「章節評論」面板（設計 `章節評論 Comments`）。
Future<void> openChapterCommentPanel(
  BuildContext context, {
  required int articleId,
  required int chapterId,
  required String chapterName,
}) => Navigator.of(context).push(
  MaterialPageRoute<void>(
    builder: (BuildContext _) => ChapterCommentPanel(
      articleId: articleId,
      chapterId: chapterId,
      chapterName: chapterName,
    ),
  ),
);

/// 章節評論面板：`chapter_comment/list·add·like`（§8.2）。反應 讚1/倒讚2/取消0（互斥、
/// 樂觀更新）；劇透 [ChapterComment.isSpoiler] 先遮罩點擊揭露；等級/熱門旗標。
/// 設計 `.subtop/.cchead/.ccrow/.ccav/.ccbd/.cctop/.ccft/.ccinput`。
///
/// 註：設計含 ⌕ 搜尋與 💬 回覆數；⑤c 端點無此兩者（無搜尋端點、entity 無回覆數），故不呈現。
class ChapterCommentPanel extends ConsumerStatefulWidget {
  const ChapterCommentPanel({
    required this.articleId,
    required this.chapterId,
    required this.chapterName,
    super.key,
  });

  final int articleId;
  final int chapterId;
  final String chapterName;

  @override
  ConsumerState<ChapterCommentPanel> createState() =>
      _ChapterCommentPanelState();
}

class _ChapterCommentPanelState extends ConsumerState<ChapterCommentPanel> {
  final List<ChapterComment> _comments = <ChapterComment>[];
  final Set<int> _revealed = <int>{}; // 已揭露劇透的 commentId
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();

  int _page = 1;
  int _pages = 1;
  int _total = 0;
  bool _loading = true;
  bool _loadingMore = false;
  bool _sending = false;
  bool _composerSpoiler = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    _load();
  }

  @override
  void dispose() {
    _scroll.dispose();
    _input.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 240) {
      _loadMore();
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final ApiResult<ChapterCommentPage> res = await ref
        .read(chapterCommentRepositoryProvider)
        .list(
          articleId: widget.articleId,
          chapterId: widget.chapterId,
          page: 1,
        );
    if (!mounted) return;
    switch (res) {
      case ApiSuccess<ChapterCommentPage>(:final ChapterCommentPage data):
        setState(() {
          _comments
            ..clear()
            ..addAll(data.comments);
          _page = data.pageNum;
          _pages = data.pages;
          _total = data.total;
          _loading = false;
        });
      case ApiFailure<ChapterCommentPage>(:final error):
        setState(() {
          _error = error;
          _loading = false;
        });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || _loading || _page >= _pages) return;
    setState(() => _loadingMore = true);
    final ApiResult<ChapterCommentPage> res = await ref
        .read(chapterCommentRepositoryProvider)
        .list(
          articleId: widget.articleId,
          chapterId: widget.chapterId,
          page: _page + 1,
        );
    if (!mounted) return;
    if (res case ApiSuccess<ChapterCommentPage>(
      :final ChapterCommentPage data,
    )) {
      setState(() {
        _comments.addAll(data.comments);
        _page = data.pageNum;
        _pages = data.pages;
        _total = data.total;
      });
    }
    if (mounted) setState(() => _loadingMore = false);
  }

  bool _requireLogin() {
    if (ref.read(authControllerProvider).isLoggedIn) return true;
    _toast('請先登入');
    return false;
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }

  Future<void> _react(int index, Reaction target) async {
    if (!_requireLogin()) return;
    final ChapterComment before = _comments[index];
    final int type = target.toggledRequestValue(before.myReaction);
    // 樂觀更新：先本地套用。
    setState(() => _comments[index] = _applyReaction(before, type));
    final ApiResult<ReactionCounts> res = await ref
        .read(chapterCommentRepositoryProvider)
        .like(commentId: before.commentId, type: type);
    if (!mounted) return;
    switch (res) {
      case ApiSuccess<ReactionCounts>(:final ReactionCounts data):
        // 以伺服器計數校正。
        final int i = _indexOf(before.commentId);
        if (i >= 0) {
          setState(() {
            _comments[i] = _copyReaction(
              _comments[i],
              like: data.likeNum,
              bad: data.badNum,
              my: data.myReaction,
            );
          });
        }
      case ApiFailure<ReactionCounts>():
        // 還原。
        final int i = _indexOf(before.commentId);
        if (i >= 0) setState(() => _comments[i] = before);
        _toast('操作失敗，請稍後再試');
    }
  }

  int _indexOf(int commentId) =>
      _comments.indexWhere((ChapterComment c) => c.commentId == commentId);

  /// 本地套用反應（互斥；type 1讚/2倒讚/0取消）。
  ChapterComment _applyReaction(ChapterComment c, int type) {
    int like = c.likeNum;
    int bad = c.badNum;
    // 先移除舊反應計數。
    if (c.myReaction == Reaction.like) like -= 1;
    if (c.myReaction == Reaction.bad) bad -= 1;
    final Reaction next = Reaction.fromValue(type);
    if (next == Reaction.like) like += 1;
    if (next == Reaction.bad) bad += 1;
    return _copyReaction(
      c,
      like: like < 0 ? 0 : like,
      bad: bad < 0 ? 0 : bad,
      my: next,
    );
  }

  ChapterComment _copyReaction(
    ChapterComment c, {
    required int like,
    required int bad,
    required Reaction my,
  }) => ChapterComment(
    commentId: c.commentId,
    content: c.content,
    commenterName: c.commenterName,
    commenterLevel: c.commenterLevel,
    avatarUrl: c.avatarUrl,
    likeNum: like,
    badNum: bad,
    myReaction: my,
    addtime: c.addtime,
    isSpoiler: c.isSpoiler,
    isHot: c.isHot,
    parentId: c.parentId,
  );

  Future<void> _send() async {
    if (_sending) return;
    final String text = _input.text.trim();
    if (text.isEmpty) return;
    if (!_requireLogin()) return;
    setState(() => _sending = true);
    final ApiResult<int> res = await ref
        .read(chapterCommentRepositoryProvider)
        .add(
          articleId: widget.articleId,
          chapterId: widget.chapterId,
          content: text,
          isSpoiler: _composerSpoiler,
        );
    if (!mounted) return;
    setState(() => _sending = false);
    if (res is ApiSuccess<int>) {
      _input.clear();
      setState(() => _composerSpoiler = false);
      _toast('已送出');
      await _load(); // 重新載入第一頁以顯示新評論。
    } else {
      _toast('送出失敗，請稍後再試');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _subtop(),
            _cchead(),
            Expanded(child: _list()),
            _ccinput(),
          ],
        ),
      ),
    );
  }

  Widget _subtop() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 4, 22, 10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Text(
              '‹',
              style: TextStyle(fontSize: 19, color: AppColors.mut),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                widget.chapterName.isEmpty
                    ? '章評'
                    : '${widget.chapterName} · 章評',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: AppTypography.fontSerif,
                  fontSize: 14,
                  color: AppColors.txt,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 19),
        ],
      ),
    );
  }

  Widget _cchead() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 2, 22, 8),
      child: Row(
        children: <Widget>[
          const Text(
            '章節評論',
            style: TextStyle(
              fontFamily: AppTypography.fontSerif,
              fontSize: 16,
              color: AppColors.txt,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            '共 $_total 則',
            style: const TextStyle(fontSize: 11, color: AppColors.mut),
          ),
        ],
      ),
    );
  }

  Widget _list() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.acc),
      );
    }
    if (_error != null) {
      return _ErrorRetry(onRetry: _load);
    }
    if (_comments.isEmpty) {
      return const Center(
        child: Text(
          '還沒有評論，來搶第一個吧',
          style: TextStyle(color: AppColors.mut, fontSize: 12),
        ),
      );
    }
    return ListView.builder(
      controller: _scroll,
      itemCount: _comments.length + (_page < _pages ? 1 : 0),
      itemBuilder: (BuildContext ctx, int i) {
        if (i >= _comments.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.mut,
                ),
              ),
            ),
          );
        }
        return _CommentRow(
          comment: _comments[i],
          revealed: _revealed.contains(_comments[i].commentId),
          onRevealSpoiler: () =>
              setState(() => _revealed.add(_comments[i].commentId)),
          onLike: () => _react(i, Reaction.like),
          onBad: () => _react(i, Reaction.bad),
        );
      },
    );
  }

  Widget _ccinput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surf,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                alignment: Alignment.center,
                child: TextField(
                  controller: _input,
                  style: const TextStyle(color: AppColors.txt, fontSize: 12),
                  cursorColor: AppColors.acc,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _send(),
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: '寫下你的看法…',
                    hintStyle: TextStyle(color: AppColors.mut, fontSize: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => setState(() => _composerSpoiler = !_composerSpoiler),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 13,
                    color: _composerSpoiler ? AppColors.acc : AppColors.mut,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '劇透',
                    style: TextStyle(
                      fontSize: 10,
                      color: _composerSpoiler ? AppColors.acc : AppColors.mut,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _sending ? null : _send,
              child: Text(
                '送出',
                style: TextStyle(
                  color: _sending ? AppColors.mut : AppColors.acc,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `.ccrow`：單則評論。
class _CommentRow extends StatelessWidget {
  const _CommentRow({
    required this.comment,
    required this.revealed,
    required this.onRevealSpoiler,
    required this.onLike,
    required this.onBad,
  });

  final ChapterComment comment;
  final bool revealed;
  final VoidCallback onRevealSpoiler;
  final VoidCallback onLike;
  final VoidCallback onBad;

  @override
  Widget build(BuildContext context) {
    final bool masked = comment.isSpoiler && !revealed;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Avatar(url: comment.avatarUrl),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _top(),
                const SizedBox(height: 6),
                if (masked)
                  GestureDetector(
                    onTap: onRevealSpoiler,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2B2B2B),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '⚠ 劇透內容 · 點擊顯示',
                        style: TextStyle(
                          color: Color(0xFF8A8278),
                          fontSize: 11,
                        ),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      comment.content,
                      style: const TextStyle(
                        fontSize: 12,
                        height: 1.62,
                        color: AppColors.rtxt,
                      ),
                    ),
                  ),
                _footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _top() {
    return Row(
      children: <Widget>[
        Flexible(
          child: Text(
            comment.commenterName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.txt,
            ),
          ),
        ),
        if ((comment.commenterLevel ?? '').isNotEmpty) ...<Widget>[
          const SizedBox(width: 7),
          _Tag(
            text: comment.commenterLevel!,
            color: AppColors.acc,
            borderColor: const Color(0x66CAA15C),
          ),
        ],
        if (comment.isHot) ...<Widget>[
          const SizedBox(width: 7),
          const _Tag(
            text: '熱門',
            color: Color(0xFFE0894A),
            borderColor: Color(0x66E0894A),
          ),
        ],
      ],
    );
  }

  Widget _footer() {
    return Row(
      children: <Widget>[
        _Reaction(
          glyph: '▲',
          count: comment.likeNum,
          on: comment.myReaction == Reaction.like,
          onTap: onLike,
        ),
        const SizedBox(width: 16),
        _Reaction(
          glyph: '▽',
          count: comment.badNum,
          on: comment.myReaction == Reaction.bad,
          onTap: onBad,
        ),
        const Spacer(),
        Text(
          comment.addtime ?? '',
          style: const TextStyle(
            fontFamily: AppTypography.fontMono,
            fontSize: 9.5,
            color: AppColors.mut,
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final String u = url ?? '';
    return ClipOval(
      child: SizedBox(
        width: 32,
        height: 32,
        child: u.isEmpty
            ? const ColoredBox(color: AppColors.cov)
            : CachedNetworkImage(
                imageUrl: u,
                fit: BoxFit.cover,
                placeholder: (_, _) => const ColoredBox(color: AppColors.cov),
                errorWidget: (_, _, _) =>
                    const ColoredBox(color: AppColors.cov),
              ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.text,
    required this.color,
    required this.borderColor,
  });

  final String text;
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: AppTypography.fontMono,
          fontSize: 8,
          color: color,
        ),
      ),
    );
  }
}

/// `.ccft .r`：內嵌反應（等寬字，選中 acc）。
class _Reaction extends StatelessWidget {
  const _Reaction({
    required this.glyph,
    required this.count,
    required this.on,
    required this.onTap,
  });

  final String glyph;
  final int count;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color c = on ? AppColors.acc : AppColors.mut;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Text(
        count > 0 ? '$glyph $count' : glyph,
        style: TextStyle(
          fontFamily: AppTypography.fontMono,
          fontSize: 11,
          color: c,
        ),
      ),
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  const _ErrorRetry({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            '載入失敗',
            style: TextStyle(color: AppColors.mut, fontSize: 12),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onRetry,
            child: const Text('重試', style: TextStyle(color: AppColors.acc)),
          ),
        ],
      ),
    );
  }
}
