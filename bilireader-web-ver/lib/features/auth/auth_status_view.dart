import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/gold_button.dart';

/// 狀態畫面（對齊設計稿 .state）：大圓圖示 + 標題 + 說明 +（可選）按鈕 +（可選）footer。
class AuthStatusView extends StatelessWidget {
  const AuthStatusView({
    super.key,
    required this.glyph,
    required this.tone,
    required this.title,
    required this.description,
    this.primaryLabel,
    this.onPrimary,
    this.footer,
    this.onFooter,
  });

  final String glyph;
  final AuthTone tone;
  final String title;
  final String description;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final String? footer;
  final VoidCallback? onFooter;

  static const _ok = Color(0xFF3FBF86);

  /// ③ 登入成功
  factory AuthStatusView.success({required String name, Key? key}) {
    return AuthStatusView(
      key: key,
      glyph: '✓',
      tone: AuthTone.ok,
      title: '登入成功',
      description: '已取得官網通行證，\n歡迎回來，$name。',
      footer: '正在返回 App…',
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = tone == AuthTone.ok ? _ok : AppColors.acc;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 84,
            height: 84,
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.14),
              border: Border.all(color: color.withValues(alpha: 0.42)),
            ),
            alignment: Alignment.center,
            child: Text(glyph,
                style: AppText.sans(size: 36, color: color, weight: FontWeight.w400)),
          ),
          Text(title, style: AppText.serif(size: 22, color: AppColors.txt)),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppText.sans(size: 12.5, color: AppColors.mut, height: 1.8),
          ),
          if (primaryLabel != null) ...[
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: GoldButton(
                label: primaryLabel!,
                onTap: onPrimary ?? () {},
                height: 50,
                fontSize: 14,
              ),
            ),
          ],
          if (footer != null) ...[
            const SizedBox(height: 22),
            GestureDetector(
              onTap: onFooter,
              child: Text(footer!,
                  style: AppText.mono(size: 11, color: AppColors.mut)),
            ),
          ],
        ],
      ),
    );
  }
}

enum AuthTone { ok, warn }
