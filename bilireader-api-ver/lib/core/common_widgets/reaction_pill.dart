import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// 按讚/倒讚膠囊（設計稿 `.rvd-rb`）。規範 §5.1.1：書評 / 章評 / 圈子共用的 reaction
/// pill，抽為共用元件並使用 token（h34、pill、surf 底；選中 cov 底 + acc 字 + acc 描邊）。
///
/// [semanticLabel]（F-12）：無障礙動作名（如「讚」「倒讚」）；提供時 TalkBack 播報
/// 「<名> <計數>，已選取/未選取，按鈕」，null 則以可見計數為名。tap 發
/// [HapticFeedback.selectionClick]（F-20，僅 [onTap] 非 null）。
class ReactionPill extends StatelessWidget {
  const ReactionPill({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
    this.semanticLabel,
    super.key,
  });

  final IconData icon;

  /// 顯示文字（通常為計數；0 可傳空字串只顯示圖示）。
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final Color fg = selected ? AppColors.acc : AppColors.mut;
    final VoidCallback? tap = onTap;
    final Material pill = Material(
      color: selected ? AppColors.cov : AppColors.surf,
      shape: StadiumBorder(
        side: selected
            ? const BorderSide(color: AppColors.acc)
            : BorderSide.none,
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: tap == null
            ? null
            : () {
                HapticFeedback.selectionClick();
                tap();
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SizedBox(
            height: 34,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(icon, size: 15, color: fg),
                if (label.isNotEmpty) ...<Widget>[
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: AppTypography.bodySmall.copyWith(
                      fontSize: 12,
                      color: fg,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
    // F-12：語意名（如「讚」）+ 選中態 + button 角色。MergeSemantics 把 InkWell 的
    // 點擊語意與計數文字併入同一節點——TalkBack 讀「<名> <計數>，已選取，按鈕」且
    // 保留雙擊觸發（不可用 excludeSemantics，會連點擊動作一起丟掉）。
    return MergeSemantics(
      child: Semantics(
        button: onTap != null,
        selected: selected,
        label: semanticLabel,
        child: pill,
      ),
    );
  }
}
