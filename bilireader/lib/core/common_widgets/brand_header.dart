import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// 分頁品牌標頭（設計稿 `.htop` / `.brand`）：大標題（serif 23/700）+ 單位副標
/// （mono 大寫、字距）+ 可選右側 `.ico` 圓鈕。書城 / 圈子 主分頁共用，確保四分頁
/// 標題樣式一致（規範 §5.1）。
class BrandHeader extends StatelessWidget {
  const BrandHeader({
    required this.title,
    required this.subtitle,
    this.trailing,
    super.key,
  });

  final String title;

  /// 單位副標（如 `BILI · 輕小說`、`QUANZI · 書友圈`）。
  final String subtitle;

  /// 右側 `.ico` 圓鈕（如發文 ✎）；null 則不顯示。
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        6,
        AppSpacing.screen,
        14,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: AppTypography.displayMedium.copyWith(
                    fontSize: 23,
                    letterSpacing: 0.9,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: AppTypography.eyebrow.copyWith(letterSpacing: 2.2),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// `.ico`：34 圓形圖示鈕（surf 底）。[onTap] 為 null 時為純裝飾（無點擊回饋）。
///
/// [semanticLabel]（F-12，**必填**）：icon-only 鈕的無障礙名稱——可點時同時作為長按
/// Tooltip 與 TalkBack 播報名；純裝飾時僅作語意名。[onTap] 觸發前發
/// [HapticFeedback.selectionClick]（F-20）。
class BrandIconButton extends StatelessWidget {
  const BrandIconButton({
    required this.icon,
    required this.semanticLabel,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // 視覺：34 圓形 surf 底 + 16 icon（設計稿 `.ico`）。
    final Widget circle = DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surf,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: 34,
        height: 34,
        child: Icon(icon, size: 16, color: AppColors.txt),
      ),
    );
    if (onTap == null) {
      // 純裝飾：維持 34（非可點，不受 §5.3 命中區下限約束）；僅給語意名。
      return Semantics(label: semanticLabel, child: circle);
    }
    final VoidCallback tap = onTap!;
    // 可點：Tooltip 提供長按提示；Semantics(label) 才是無障礙**名稱**（Tooltip 只給 hint）。
    // MergeSemantics 併入點擊語意 → TalkBack 讀「<名>，按鈕」且保留雙擊觸發。
    // F-13：視覺維持 34 圓，外層 44×44 透明命中區（§5.3 觸控目標下限）。
    return MergeSemantics(
      child: Tooltip(
        message: semanticLabel,
        child: Semantics(
          button: true,
          label: semanticLabel,
          child: SizedBox.square(
            dimension: 44,
            child: Material(
              type: MaterialType.transparency,
              shape: const CircleBorder(),
              child: InkResponse(
                radius: 22,
                onTap: () {
                  HapticFeedback.selectionClick();
                  tap();
                },
                child: Center(child: circle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
