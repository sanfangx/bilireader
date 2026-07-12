import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/media/image_pick_service.dart';
import '../../../core/network/api_result.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/text/tw_error.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../domain/author_entities.dart';
import 'author_controllers.dart';

/// 章節編輯器（設計稿「章節編輯器 Editor」）。存草稿 `author/draft/save`、插圖
/// `author/chapter/attach/upload`（Multipart🔒，回 insertToken/insertHtml）、發佈
/// `author/chapter/publishDirect`（新）或更新 `author/chapter/update`（既有）。
///
/// 皆為狀態變更端點（§7.0），僅使用者主動觸發——不做背景自動存草稿（避免未經使用者
/// 操作的寫入）。作者稿件保留原文、不轉繁（見 repo 說明）。
class ChapterEditorPage extends ConsumerStatefulWidget {
  const ChapterEditorPage({
    required this.articleId,
    this.chapterId,
    this.volumeId = 0,
    this.initialName,
    super.key,
  });

  final int articleId;

  /// 既有章節 id（編輯模式）；null 為新章節。
  final int? chapterId;

  /// 目標卷 id（新章節必需）。
  final int volumeId;
  final String? initialName;

  @override
  ConsumerState<ChapterEditorPage> createState() => _ChapterEditorPageState();
}

class _ChapterEditorPageState extends ConsumerState<ChapterEditorPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _content = TextEditingController();
  final ImagePickService _picker = ImagePickService();

  bool get _isExisting => (widget.chapterId ?? 0) > 0;
  bool _loading = false;
  bool _busy = false;
  int? _draftId;
  String _status = '';

  @override
  void initState() {
    super.initState();
    _name.text = widget.initialName ?? '';
    _content.addListener(_onChanged);
    if (_isExisting) {
      _loadExisting();
    }
  }

  @override
  void dispose() {
    _content.removeListener(_onChanged);
    _name.dispose();
    _content.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (_status.isNotEmpty) {
      setState(() => _status = '');
    }
  }

  Future<void> _loadExisting() async {
    setState(() => _loading = true);
    final ApiResult<AuthorChapterText> result = await ref
        .read(authorActionsProvider.notifier)
        .loadChapterText(
          articleId: widget.articleId,
          chapterId: widget.chapterId!,
        );
    if (!mounted) {
      return;
    }
    switch (result) {
      case ApiSuccess<AuthorChapterText>(:final data):
        _name.text = data.chapterName;
        _content.text = data.text;
        setState(() => _loading = false);
      case ApiFailure<AuthorChapterText>(:final error):
        setState(() => _loading = false);
        _toast(twErrorMessage(ref.read(chineseConverterProvider), error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('章節編輯器'),
        actions: <Widget>[
          TextButton(
            onPressed: _busy ? null : _saveDraft,
            child: Text(
              '存草稿',
              style: AppTypography.bodySmall.copyWith(
                fontSize: 12,
                color: AppColors.mut,
              ),
            ),
          ),
          TextButton(
            onPressed: _busy ? null : _publish,
            child: Text(
              _isExisting ? '更新' : '發佈',
              style: AppTypography.bodySmall.copyWith(
                fontSize: 12,
                color: AppColors.acc,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.acc))
          : Column(
              children: <Widget>[
                // .ed-vol：卷 / 存檔狀態帶。
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    6,
                    AppSpacing.screen,
                    8,
                  ),
                  child: Text.rich(
                    TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                          text: _isExisting ? '編輯章節 › ' : '新章節 › ',
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 11,
                            color: AppColors.mut,
                          ),
                        ),
                        TextSpan(
                          text: _status.isEmpty ? '尚未儲存' : _status,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 11,
                            color: _status.isEmpty
                                ? AppColors.mut
                                : AppColors.acc,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // .ed-title：章名（可編輯）。
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screen,
                  ),
                  child: TextField(
                    controller: _name,
                    style: AppTypography.titleMedium.copyWith(
                      fontFamily: AppTypography.fontSerif,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      border: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.line),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.line),
                      ),
                      contentPadding: const EdgeInsets.only(bottom: 10),
                      hintText: '章節標題',
                      hintStyle: AppTypography.titleMedium.copyWith(
                        fontFamily: AppTypography.fontSerif,
                        fontSize: 17,
                        color: AppColors.mut,
                      ),
                    ),
                  ),
                ),
                // .ed-area：正文（閱讀字體）。
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screen,
                      vertical: 12,
                    ),
                    child: TextField(
                      controller: _content,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: AppTypography.bodyMedium.copyWith(
                        fontFamily: AppTypography.fontSerif,
                        fontSize: 13.5,
                        height: 1.9,
                        color: AppColors.rtxt,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '在此輸入章節正文…',
                        hintStyle: AppTypography.bodyMedium.copyWith(
                          fontSize: 13.5,
                          color: AppColors.mut,
                        ),
                      ),
                    ),
                  ),
                ),
                _EditorBar(
                  wordCount: _content.text.characters.length,
                  onImage: _busy ? null : _insertIllustration,
                  onBold: _wrapBold,
                ),
              ],
            ),
    );
  }

  /// 🖼：選圖 → attach/upload（Multipart🔒）→ 於游標插入伺服器回傳的 insertHtml。
  Future<void> _insertIllustration() async {
    final XFile? file = await _picker.pickSingle();
    if (file == null || !mounted) {
      return;
    }
    setState(() => _busy = true);
    final ApiResult<ChapterAttachResult> result = await ref
        .read(authorActionsProvider.notifier)
        .uploadIllustration(
          articleId: widget.articleId,
          chapterId: widget.chapterId,
          draftId: _draftId,
          file: file,
        );
    if (!mounted) {
      return;
    }
    setState(() => _busy = false);
    switch (result) {
      case ApiSuccess<ChapterAttachResult>(:final data):
        final String snippet = (data.insertHtml ?? '').isNotEmpty
            ? data.insertHtml!
            : (data.previewUrl ?? '');
        _insertAtCursor(snippet);
        _toast('插圖已上傳');
      case ApiFailure<ChapterAttachResult>(:final error):
        _toast(twErrorMessage(ref.read(chineseConverterProvider), error));
    }
  }

  /// Ｂ：以 `<b></b>` 包住選取文字（正文為 HTML，閱讀器據以渲染）。
  void _wrapBold() {
    final TextSelection sel = _content.selection;
    if (!sel.isValid || sel.isCollapsed) {
      _insertAtCursor('<b></b>');
      return;
    }
    final String text = _content.text;
    final String selected = sel.textInside(text);
    final String next = text.replaceRange(
      sel.start,
      sel.end,
      '<b>$selected</b>',
    );
    _content.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: sel.end + 7),
    );
  }

  void _insertAtCursor(String snippet) {
    if (snippet.isEmpty) {
      return;
    }
    final TextSelection sel = _content.selection;
    final int at = sel.isValid ? sel.start : _content.text.length;
    final String text = _content.text;
    final String next = text.replaceRange(
      at,
      sel.isValid ? sel.end : at,
      snippet,
    );
    _content.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: at + snippet.length),
    );
  }

  Future<void> _saveDraft() async {
    final String name = _name.text.trim();
    final String content = _content.text;
    if (name.isEmpty) {
      _toast('請先輸入章節標題');
      return;
    }
    setState(() => _busy = true);
    final ApiResult<AuthorDraft> result = await ref
        .read(authorActionsProvider.notifier)
        .saveDraft(
          draftId: _draftId,
          articleId: widget.articleId,
          volumeId: widget.volumeId,
          chapterName: name,
          chapterContent: content,
        );
    if (!mounted) {
      return;
    }
    switch (result) {
      case ApiSuccess<AuthorDraft>(:final data):
        setState(() {
          _busy = false;
          _draftId = data.draftId;
          _status = '草稿已存';
        });
      case ApiFailure<AuthorDraft>(:final error):
        setState(() => _busy = false);
        _toast(twErrorMessage(ref.read(chineseConverterProvider), error));
    }
  }

  Future<void> _publish() async {
    final String name = _name.text.trim();
    final String content = _content.text.trim();
    if (name.isEmpty || content.isEmpty) {
      _toast('章名與正文不可為空');
      return;
    }
    setState(() => _busy = true);
    final AuthorActions actions = ref.read(authorActionsProvider.notifier);
    final ApiResult<Object?> result = _isExisting
        ? await actions.updateChapter(
            articleId: widget.articleId,
            chapterId: widget.chapterId!,
            chapterName: name,
            content: content,
          )
        : await actions.publishDirect(
            articleId: widget.articleId,
            volumeId: widget.volumeId,
            chapterName: name,
            content: content,
          );
    if (!mounted) {
      return;
    }
    switch (result) {
      case ApiSuccess<Object?>():
        // 重新整理章節樹（回上一頁時反映）。
        ref.invalidate(authorChapterTreeProvider(widget.articleId));
        _toast(_isExisting ? '已更新' : '已發佈');
        await Navigator.of(context).maybePop();
      case ApiFailure<Object?>(:final error):
        setState(() => _busy = false);
        _toast(twErrorMessage(ref.read(chineseConverterProvider), error));
    }
  }

  void _toast(String msg) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));
}

/// `.ed-bar`：底部工具列（插圖 / 粗體 + 字數）。
class _EditorBar extends StatelessWidget {
  const _EditorBar({
    required this.wordCount,
    required this.onImage,
    required this.onBold,
  });

  final int wordCount;
  final VoidCallback? onImage;
  final VoidCallback onBold;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          12,
          AppSpacing.screen,
          14,
        ),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: onImage,
              tooltip: '插入插圖',
              icon: const Icon(
                Icons.image_outlined,
                color: AppColors.mut,
                size: 20,
              ),
            ),
            IconButton(
              onPressed: onBold,
              tooltip: '粗體',
              icon: const Icon(
                Icons.format_bold,
                color: AppColors.mut,
                size: 20,
              ),
            ),
            const Spacer(),
            Text(
              '$wordCount 字',
              style: AppTypography.mono.copyWith(
                fontSize: 10,
                color: AppColors.mut,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
