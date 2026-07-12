import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/text/relative_time.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../data/bookmark_local_data_source.dart';
import '../../domain/bookmark.dart';
import '../../domain/reader_anchor.dart';

/// 閱讀器「書籤」底部彈窗（使用者提供之設計）：標題「書籤」+「在此處加入書籤」大按鈕
/// + 已存書籤清單（圖示 + 章名 + 錨點片段 + 刪除）。點列跳回該書籤位置（§5.5）。
Future<void> showReaderBookmarkSheet(
  BuildContext context, {
  required BookmarkLocalDataSource dataSource,
  required int ownerUid,
  required int articleId,
  required String articleName,
  required ReaderAnchor Function() currentAnchor,
  required void Function(Bookmark) onJump,
}) => showModalBottomSheet<void>(
  context: context,
  backgroundColor: AppColors.surf,
  barrierColor: AppColors.scrim,
  isScrollControlled: true,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
  ),
  builder: (BuildContext _) => _BookmarkSheet(
    dataSource: dataSource,
    ownerUid: ownerUid,
    articleId: articleId,
    articleName: articleName,
    currentAnchor: currentAnchor,
    onJump: onJump,
  ),
);

class _BookmarkSheet extends StatefulWidget {
  const _BookmarkSheet({
    required this.dataSource,
    required this.ownerUid,
    required this.articleId,
    required this.articleName,
    required this.currentAnchor,
    required this.onJump,
  });

  final BookmarkLocalDataSource dataSource;
  final int ownerUid;
  final int articleId;
  final String articleName;
  final ReaderAnchor Function() currentAnchor;
  final void Function(Bookmark) onJump;

  @override
  State<_BookmarkSheet> createState() => _BookmarkSheetState();
}

class _BookmarkSheetState extends State<_BookmarkSheet> {
  List<Bookmark> _bookmarks = <Bookmark>[];
  bool _loading = true;
  bool _saving = false; // 防連點：加入書籤進行中不重入

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final List<Bookmark> list = await widget.dataSource.getForBook(
        widget.ownerUid,
        widget.articleId,
      );
      if (!mounted) return;
      setState(() {
        _bookmarks = list;
        _loading = false;
      });
    } on Object {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String m) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(m)));

  Future<void> _addHere() async {
    if (_saving) return; // 防連點 → 同位置重複插入
    final ReaderAnchor a = widget.currentAnchor();
    // 去重：同一閱讀位置（章 + block + 章內偏移）已有書籤 → 不重複插入。
    final bool dup = _bookmarks.any((b) =>
        b.anchor.chapterId == a.chapterId &&
        b.anchor.blockIndex == a.blockIndex &&
        b.anchor.sourceTextOffset == a.sourceTextOffset);
    if (dup) {
      _toast('此處已有書籤');
      return;
    }
    setState(() => _saving = true);
    bool ok = true;
    try {
      await widget.dataSource.save(
        Bookmark(
          ownerUid: widget.ownerUid,
          anchor: a,
          articleName: widget.articleName,
        ),
      );
    } on Object {
      ok = false;
    }
    await _load();
    if (!mounted) return;
    setState(() => _saving = false);
    _toast(ok ? '已加入書籤' : '加入書籤失敗');
  }

  Future<void> _delete(Bookmark b) async {
    if (b.id == null) return;
    bool ok = true;
    try {
      await widget.dataSource.delete(b.id!);
    } on Object {
      ok = false;
    }
    await _load();
    if (mounted && !ok) _toast('刪除失敗');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 38,
              height: 4,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: AppColors.mut.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Text(
                '書籤',
                style: GoogleFonts.notoSerifTc(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.txt,
                  letterSpacing: 0.6,
                ),
              ),
            ),
            // 「在此處加入書籤」大按鈕。
            Material(
              color: AppColors.acc,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                onTap: _addHere,
                child: const SizedBox(
                  height: 54,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.bookmark_add_outlined,
                        size: 20,
                        color: AppColors.btxt,
                      ),
                      SizedBox(width: 10),
                      Text(
                        '在此處加入書籤',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.btxt,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _list(),
          ],
        ),
      ),
    );
  }

  Widget _list() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: CircularProgressIndicator(color: AppColors.acc),
      );
    }
    if (_bookmarks.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.page),
        child: Text(
          '尚無書籤，點上方按鈕加入',
          style: TextStyle(color: AppColors.mut, fontSize: 12),
        ),
      );
    }
    return Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: AppSpacing.xxs),
        itemCount: _bookmarks.length,
        itemBuilder: (BuildContext ctx, int i) => _BookmarkRow(
          bookmark: _bookmarks[i],
          onTap: () {
            Navigator.of(context).pop();
            widget.onJump(_bookmarks[i]);
          },
          onDelete: () => _delete(_bookmarks[i]),
        ),
      ),
    );
  }
}

class _BookmarkRow extends StatelessWidget {
  const _BookmarkRow({
    required this.bookmark,
    required this.onTap,
    required this.onDelete,
  });

  final Bookmark bookmark;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final ReaderAnchor a = bookmark.anchor;
    final String quote = a.textQuote.trim();
    final int ts = a.createdAt > 0 ? a.createdAt : a.updatedAt;
    final String time = ts > 0 ? relativeTimeFromSeconds(ts ~/ 1000) : '';
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: <Widget>[
            const Icon(Icons.bookmark, size: 20, color: AppColors.acc),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    a.chapterName.isEmpty ? '未命名章節' : a.chapterName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSerifTc(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.txt,
                    ),
                  ),
                  if (quote.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 3),
                    Text(
                      quote,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.mut,
                      ),
                    ),
                  ],
                  if (time.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 3),
                    Text(
                      time,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 10,
                        color: AppColors.mut,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete_outline,
                size: 20,
                color: AppColors.danger,
              ),
              splashRadius: 22,
              tooltip: '刪除書籤',
            ),
          ],
        ),
      ),
    );
  }
}
