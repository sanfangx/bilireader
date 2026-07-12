import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

/// 水平篩選膠囊（設計稿 `.chip` / `.chip-on`）。規範 §5.1.1：膠囊為高頻設計語言，
/// 必須抽為共用元件並使用 token，不在各頁手刻 padding / radius / selected 色。
///
/// 設計稿未提供 disabled 樣式，此處以降透明度自訂（規範允許主動補齊缺口）。
class AppChip extends StatelessWidget {
  const AppChip({
    required this.label,
    this.selected = false,
    this.onTap,
    this.enabled = true,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final bool interactive = enabled && onTap != null;
    final Color background = selected ? AppColors.acc : AppColors.surf;
    final Color foreground = selected ? AppColors.btxt : AppColors.mut;

    // F-12：篩選膠囊補 button 角色 + 選中/停用語意（名稱取自可見標籤）。MergeSemantics
    // 把 InkWell 的點擊語意與此節點併為一個焦點（TalkBack 讀「<標籤>，已選取，按鈕」）。
    return MergeSemantics(
      child: Semantics(
        button: interactive,
        selected: selected,
        enabled: enabled,
        child: Opacity(
          opacity: enabled ? 1 : 0.4,
          child: Material(
            color: background,
            borderRadius: AppRadius.pillAll,
            child: InkWell(
              borderRadius: AppRadius.pillAll,
              onTap: interactive ? onTap : null,
              child: SizedBox(
                height: 32,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    widthFactor: 1,
                    child: Text(
                      label,
                      style: AppTypography.bodySmall.copyWith(
                        color: foreground,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
