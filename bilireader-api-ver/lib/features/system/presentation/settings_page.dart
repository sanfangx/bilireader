import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/router/auth_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../auth/data/auth_providers.dart';
import '../../auth/presentation/current_user_provider.dart';

/// 系統設定頁（設計稿「系統設定 Settings」）。此階段實作可用項目：問題反饋、版本
/// （→更新日誌）、私訊、登出。閱讀 / 快取 / 通知等設定屬後續階段，暫不放入以免呈現
/// 無作用的控制項（§No Mock Data）。
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        children: <Widget>[
          const _SectionLabel('通用'),
          _SettingsRow(
            icon: Icons.mail_outline,
            label: '私訊',
            onTap: () => context.pushNamed(AppRoutes.messagesName),
          ),
          _SettingsRow(
            icon: Icons.feedback_outlined,
            label: '問題反饋',
            onTap: () => context.pushNamed(AppRoutes.feedbackName),
          ),
          _SettingsRow(
            icon: Icons.info_outline,
            label: '版本',
            value: 'v${ApiConstants.appVersionName}',
            onTap: () => context.pushNamed(AppRoutes.changelogName),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              22,
              AppSpacing.screen,
              26,
            ),
            child: _LogoutButton(onTap: () => _logout(ref, context)),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(WidgetRef ref, BuildContext context) async {
    // logout() 清 token/session + owner-scoped 本機快取（私訊/書籤/進度，見 infra_providers）。
    await ref.read(authRepositoryProvider).logout();
    // 認證態 → 未登入：currentUser / currentOwnerUid 等觀察 authController 的 provider 自動刷新。
    await ref.read(authControllerProvider.notifier).refresh();
    ref.invalidate(currentUserProvider); // 保險：強制個資卡重取
    if (context.mounted) {
      // 導回「我的」根並重設堆疊（移除設定頁）——登出即時反映，不停在原頁（使用者回報 UX）。
      context.goNamed(AppRoutes.userName);
    }
  }
}

/// `.seclbl`：區段標籤（mono 大寫）。
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        14,
        AppSpacing.screen,
        8,
      ),
      child: Text(
        text,
        style: AppTypography.mono.copyWith(
          fontSize: 9.5,
          letterSpacing: 1,
          color: AppColors.mut,
        ),
      ),
    );
  }
}

/// `.mrow`：設定列（acc 圖示 + 標題 + 可選 mval + chevron）。
class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.value,
  });

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: 14,
        ),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 22,
              child: Icon(icon, size: 18, color: AppColors.acc),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMedium.copyWith(fontSize: 13.5),
              ),
            ),
            if (value != null)
              Text(
                value!,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 12,
                  color: AppColors.mut,
                ),
              ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.mut),
          ],
        ),
      ),
    );
  }
}

/// `.logout`：登出（紅框膠囊）。
class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: const Key('settings_logout'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.logoutRed.withValues(alpha: 0.38),
          ),
        ),
        child: Text(
          '登出',
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 14,
            color: AppColors.logoutRed,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
