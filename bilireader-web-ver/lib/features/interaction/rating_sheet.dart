import 'package:flutter/material.dart';

import '../../core/network/linovelib_api.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';

/// 書籍評分底部表單（1~5 星）。web 端 ⑧ 互動域唯一完全可行的動作：
/// POST /modules/article/rating.php。呼叫端須先確認已登入。
/// **回傳送出成功的分數（1~5）**，供呼叫端反映使用者自評；取消/失敗回 null。
Future<int?> showRatingSheet(
  BuildContext context, {
  required String novelId,
  required String novelTitle,
  int? initialScore,
}) {
  return showModalBottomSheet<int>(
    context: context,
    backgroundColor: AppColors.surf,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) => _RatingSheet(
      novelId: novelId,
      novelTitle: novelTitle,
      initialScore: initialScore,
    ),
  );
}

class _RatingSheet extends StatefulWidget {
  const _RatingSheet({
    required this.novelId,
    required this.novelTitle,
    this.initialScore,
  });

  final String novelId;
  final String novelTitle;
  final int? initialScore;

  @override
  State<_RatingSheet> createState() => _RatingSheetState();
}

class _RatingSheetState extends State<_RatingSheet> {
  late int _score = widget.initialScore ?? 0;
  bool _submitting = false;

  static const List<String> _labels = <String>[
    '', '不推薦', '普通', '還不錯', '推薦', '神作',
  ];

  Future<void> _submit() async {
    if (_score < 1 || _submitting) return;
    setState(() => _submitting = true);
    bool ok = false;
    try {
      ok = await LinovelibApi.instance.submitRating(widget.novelId, _score);
    } catch (_) {
      ok = false;
    }
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    if (ok) {
      Navigator.of(context).pop(_score); // 回傳分數供入口星反映
      messenger.showSnackBar(
          SnackBar(content: Text('已送出評分 · $_score 星')));
    } else {
      // 失敗不關表：保留已選星數讓使用者直接重送（不必重開重選）。
      setState(() => _submitting = false);
      messenger.showSnackBar(
          const SnackBar(content: Text('評分失敗，請稍後再試')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 22,
        right: 22,
        top: 18,
        bottom: 18 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('為本書評分',
              style: AppText.serif(size: 17, color: AppColors.txt)),
          const SizedBox(height: 4),
          Text(widget.novelTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppText.sans(size: 12, color: AppColors.mut)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 1; i <= 5; i++)
                GestureDetector(
                  onTap: () => setState(() => _score = i),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      i <= _score ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 40,
                      color: i <= _score ? AppColors.acc : AppColors.mut,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              _score >= 1 ? _labels[_score] : '點選星數',
              style: AppText.sans(size: 12.5, color: AppColors.acc),
            ),
          ),
          const SizedBox(height: 22),
          GestureDetector(
            onTap: _score >= 1 && !_submitting ? _submit : null,
            child: Opacity(
              opacity: _score >= 1 && !_submitting ? 1 : 0.4,
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.acc,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.btxt),
                      )
                    : Text('送出評分',
                        style: AppText.sans(
                            size: 14,
                            weight: FontWeight.w700,
                            color: AppColors.btxt)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
