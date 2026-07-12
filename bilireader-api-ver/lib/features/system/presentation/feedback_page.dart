import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_result.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/text/tw_error.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../domain/feedback_options.dart';
import 'system_controllers.dart';

/// 意見回饋頁（設計稿「意見回饋 Feedback」）。分類（reportSort）+ 細項（reportType）
/// + 標題 + 內容 → `feedback/submit`。狀態變更端點（§7.0），僅使用者主動送出。
class FeedbackPage extends ConsumerStatefulWidget {
  const FeedbackPage({super.key});

  @override
  ConsumerState<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends ConsumerState<FeedbackPage> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _content = TextEditingController();
  FeedbackSort _sort = FeedbackSort.suggestion;
  late FeedbackType _type = _sort.types.first;
  bool _submitting = false;

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  void _selectSort(FeedbackSort sort) {
    if (sort == _sort) {
      return;
    }
    setState(() {
      _sort = sort;
      _type = sort.types.first; // 切分類時細項重設為首項
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('問題反饋')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screen,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const _SectionLabel('分類'),
                  _Pills<FeedbackSort>(
                    options: FeedbackSort.values,
                    selected: _sort,
                    labelOf: (FeedbackSort s) => s.label,
                    onTap: _selectSort,
                  ),
                  const _SectionLabel('細項'),
                  _Pills<FeedbackType>(
                    options: _sort.types,
                    selected: _type,
                    labelOf: (FeedbackType t) => t.label,
                    onTap: (FeedbackType t) => setState(() => _type = t),
                  ),
                  const _SectionLabel('標題'),
                  _Field(controller: _title, hint: '簡述你的問題…', maxLines: 1),
                  const _SectionLabel('內容'),
                  _Field(
                    controller: _content,
                    hint: '詳細描述你遇到的狀況或建議…',
                    maxLines: 5,
                    minHeight: 86,
                  ),
                ],
              ),
            ),
          ),
          _SubmitButton(submitting: _submitting, onTap: _submit),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final String title = _title.text.trim();
    final String content = _content.text.trim();
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    if (title.isEmpty) {
      messenger.showSnackBar(const SnackBar(content: Text('請輸入標題')));
      return;
    }
    if (content.isEmpty) {
      messenger.showSnackBar(const SnackBar(content: Text('請輸入內容')));
      return;
    }
    setState(() => _submitting = true);
    final ApiResult<int> result = await ref
        .read(feedbackActionsProvider.notifier)
        .submit(sort: _sort, type: _type, title: title, content: content);
    if (!mounted) {
      return;
    }
    final NavigatorState navigator = Navigator.of(context);
    switch (result) {
      case ApiSuccess<int>():
        messenger.showSnackBar(const SnackBar(content: Text('反饋已提交')));
        await navigator.maybePop();
      case ApiFailure<int>(:final error):
        setState(() => _submitting = false);
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

/// `.fb h5`：區段標籤。
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 14, 0, 9),
      child: Text(
        text,
        style: AppTypography.bodySmall.copyWith(
          fontSize: 11,
          color: AppColors.mut,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// `.fb-opts`：可換行的選項膠囊組。
class _Pills<T> extends StatelessWidget {
  const _Pills({
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onTap,
  });

  final List<T> options;
  final T selected;
  final String Function(T) labelOf;
  final void Function(T) onTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        for (final T o in options)
          _Pill(label: labelOf(o), on: o == selected, onTap: () => onTap(o)),
      ],
    );
  }
}

/// `.fb-o`（`.on` 為選中）。
class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.on, required this.onTap});

  final String label;
  final bool on;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      // Wrap 內以 padding 撐出膠囊高度並自然 hug 內容（勿用固定 height + alignment，
      // 否則於 Wrap 的無界寬度下會撐滿整列）。
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: on ? AppColors.cov : AppColors.surf,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: on ? AppColors.acc : Colors.transparent),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            fontSize: 12,
            color: on ? AppColors.acc : AppColors.mut,
            fontWeight: on ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

/// `.fb-in` / `.fb-ta`：輸入框（surf 底、圓角）。
class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    required this.maxLines,
    this.minHeight,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: minHeight == null
          ? null
          : BoxConstraints(minHeight: minHeight!),
      decoration: BoxDecoration(
        color: AppColors.surf,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: AppTypography.bodyMedium.copyWith(
          fontSize: 13,
          color: AppColors.txt,
          height: 1.6,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 9),
          hintText: hint,
          hintStyle: AppTypography.bodyMedium.copyWith(
            fontSize: 13,
            color: AppColors.mut,
          ),
        ),
      ),
    );
  }
}

/// `.fb-sub`：提交按鈕。
class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.submitting, required this.onTap});

  final bool submitting;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          18,
          AppSpacing.screen,
          12,
        ),
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.acc,
              foregroundColor: AppColors.btxt,
              disabledBackgroundColor: AppColors.cov,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: submitting ? null : onTap,
            child: submitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.btxt,
                    ),
                  )
                : Text(
                    '提交反饋',
                    style: AppTypography.bodyMedium.copyWith(
                      fontSize: 14,
                      color: AppColors.btxt,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
