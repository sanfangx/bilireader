import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widgets/app_bottom_sheet.dart';
import '../../../core/media/image_pick_service.dart';
import '../../../core/network/api_result.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/text/tw_error.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../domain/circle_entities.dart';
import 'circle_controllers.dart';

/// 發表貼文頁（設計稿「發表貼文 Publish」）：標題 + 內文 + 版塊選擇 + 圖片附件。
/// `circle/publish` 為 Multipart🔒（BNUP2 簽章）；圖片經 image_picker 選取，以
/// `images` part 上傳（最多 9 張）。狀態變更端點（§7.0），僅使用者觸發。
class CirclePublishPage extends ConsumerStatefulWidget {
  const CirclePublishPage({super.key});

  @override
  ConsumerState<CirclePublishPage> createState() => _CirclePublishPageState();
}

class _CirclePublishPageState extends ConsumerState<CirclePublishPage> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _content = TextEditingController();
  final ImagePickService _picker = ImagePickService();
  final List<XFile> _images = <XFile>[];
  static const int _maxImages = 9;
  CircleSection? _section;
  bool _publishing = false;

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<CircleSection>> sections = ref.watch(
      circleSectionsProvider,
    );
    _section ??= sections.value?.isNotEmpty ?? false
        ? sections.value!.first
        : null;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('發表貼文'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // .pub-sec
                  InkWell(
                    onTap: () => _pickSection(sections.value),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: AppColors.line),
                        ),
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                            '發佈到 · ',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            _section?.sectionName ?? '選擇版塊',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 12,
                              color: AppColors.txt,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.chevron_right,
                            size: 18,
                            color: AppColors.mut,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // .pub-title
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.line)),
                    ),
                    child: TextField(
                      controller: _title,
                      style: AppTypography.titleMedium.copyWith(
                        fontFamily: AppTypography.fontSerif,
                        fontSize: 17,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        hintText: '輸入標題',
                        hintStyle: AppTypography.titleMedium.copyWith(
                          fontFamily: AppTypography.fontSerif,
                          fontSize: 17,
                          color: AppColors.mut,
                        ),
                      ),
                    ),
                  ),
                  // .pub-area
                  Expanded(
                    child: TextField(
                      controller: _content,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: AppTypography.bodyMedium.copyWith(
                        fontSize: 13,
                        height: 1.75,
                        color: AppColors.txt,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(top: 14),
                        hintText: '分享你的想法、書評或同人創作…',
                        hintStyle: AppTypography.bodyMedium.copyWith(
                          fontSize: 13,
                          color: AppColors.mut,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_images.isNotEmpty)
            _ImageStrip(images: _images, onRemove: _remove),
          _PublishBar(
            publishing: _publishing,
            imageCount: _images.length,
            onImage: _pickImages,
            onPublish: _publish,
          ),
        ],
      ),
    );
  }

  Future<void> _pickSection(List<CircleSection>? sections) async {
    if (sections == null || sections.isEmpty) {
      return;
    }
    final CircleSection? picked = await showAppBottomSheet<CircleSection>(
      context: context,
      title: '發佈到版塊',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final CircleSection s in sections)
            InkWell(
              onTap: () => Navigator.of(context).pop(s),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 13,
                  horizontal: 4,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        s.sectionName,
                        style: AppTypography.bodyLarge.copyWith(
                          color: s.sectionId == _section?.sectionId
                              ? AppColors.acc
                              : AppColors.txt,
                        ),
                      ),
                    ),
                    if (s.sectionId == _section?.sectionId)
                      const Icon(Icons.check, size: 18, color: AppColors.acc),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
    if (picked != null) {
      setState(() => _section = picked);
    }
  }

  Future<void> _pickImages() async {
    final List<XFile> picked = await _picker.pickMultiple(
      limit: _maxImages - _images.length,
    );
    if (picked.isEmpty || !mounted) {
      return;
    }
    setState(() {
      for (final XFile f in picked) {
        if (_images.length < _maxImages) {
          _images.add(f);
        }
      }
    });
  }

  void _remove(int index) => setState(() => _images.removeAt(index));

  Future<void> _publish() async {
    final String title = _title.text.trim();
    final String content = _content.text.trim();
    final CircleSection? section = _section;
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    if (section == null) {
      messenger.showSnackBar(const SnackBar(content: Text('請先選擇版塊')));
      return;
    }
    if (title.isEmpty || content.isEmpty) {
      messenger.showSnackBar(const SnackBar(content: Text('標題與內文不可為空')));
      return;
    }
    setState(() => _publishing = true);
    final ApiResult<int> result = await ref
        .read(circleActionsProvider.notifier)
        .publish(
          sectionId: section.sectionId,
          title: title,
          content: content,
          images: List<XFile>.of(_images),
        );
    if (!mounted) {
      return;
    }
    final NavigatorState navigator = Navigator.of(context);
    switch (result) {
      case ApiSuccess<int>():
        ref.invalidate(circleFeedControllerProvider);
        messenger.showSnackBar(const SnackBar(content: Text('已發佈')));
        await navigator.maybePop();
      case ApiFailure<int>(:final error):
        setState(() => _publishing = false);
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              twErrorMessage(ref.read(chineseConverterProvider), error),
            ),
          ),
        );
    }
  }
}

/// 已選圖片縮圖列（發表/回覆共用）。點縮圖右上角 × 可移除。
class _ImageStrip extends StatelessWidget {
  const _ImageStrip({required this.images, required this.onRemove});

  final List<XFile> images;
  final void Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 78,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: 8,
        ),
        itemCount: images.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (BuildContext context, int i) => Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(images[i].path),
                width: 62,
                height: 62,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => onRemove(i),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 13, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `.pub-bar`：工具列（圖片等）+ 發佈按鈕。
class _PublishBar extends StatelessWidget {
  const _PublishBar({
    required this.publishing,
    required this.imageCount,
    required this.onImage,
    required this.onPublish,
  });

  final bool publishing;
  final int imageCount;
  final VoidCallback onImage;
  final VoidCallback onPublish;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          12,
          AppSpacing.screen,
          12,
        ),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: onImage,
              icon: const Icon(
                Icons.image_outlined,
                color: AppColors.mut,
                size: 20,
              ),
            ),
            if (imageCount > 0)
              Text(
                '$imageCount',
                style: AppTypography.mono.copyWith(
                  fontSize: 11,
                  color: AppColors.acc,
                ),
              ),
            const Spacer(),
            SizedBox(
              height: 38,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.acc,
                  foregroundColor: AppColors.btxt,
                  disabledBackgroundColor: AppColors.cov,
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  shape: const StadiumBorder(),
                ),
                onPressed: publishing ? null : onPublish,
                child: publishing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.btxt,
                        ),
                      )
                    : Text(
                        '發佈',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 13,
                          color: AppColors.btxt,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
