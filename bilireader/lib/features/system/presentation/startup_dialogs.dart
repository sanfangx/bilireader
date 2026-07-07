import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/infra_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../domain/system_entities.dart';
import 'system_controllers.dart';

/// 顯示啟動公告 modal（設計稿「③ 啟動公告 Announcement」`.dlg`）。任何方式關閉都標記已看
/// （同一份不再彈，內容更新才再彈）。有 actionUrl 才顯示行動按鈕。
Future<void> showStartupAnnouncementDialog(
  BuildContext context,
  WidgetRef ref,
  StartupAnnouncement ann,
) async {
  await showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.5), // .scrim
    builder: (BuildContext ctx) => _AnnouncementDialog(ann: ann),
  );
  // 關閉後標記已看（下次啟動不再彈；內容變更會有新簽章而重彈）。
  await ref.read(systemStartupProvider.notifier).markAnnouncementSeen(ann);
}

class _AnnouncementDialog extends ConsumerWidget {
  const _AnnouncementDialog({required this.ann});

  final StartupAnnouncement ann;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String title = (ann.title ?? '').trim().isEmpty
        ? '站內公告'
        : ann.title!.trim();
    final String body = (ann.content ?? '').trim();
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: _DlgCard(
        kicker: '站內公告',
        title: title,
        body: body,
        actionText: ann.hasAction ? (ann.actionText ?? '查看詳情') : null,
        onAction: ann.hasAction
            ? () async {
                await ref
                    .read(systemStartupProvider.notifier)
                    .openUrl(ann.actionUrl!);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              }
            : null,
        secondaryText: '我知道了',
        onSecondary: () => Navigator.of(context).pop(),
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }
}

/// 強制更新覆蓋層（規範 §7.0：version/check 回 501）。以 [child] 疊一層阻斷式對話框；
/// 觀察 [forceUpdateControllerProvider]，一旦為 true 即無法操作 App，必須更新。
class ForceUpdateOverlay extends ConsumerWidget {
  const ForceUpdateOverlay({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool blocked = ref.watch(forceUpdateControllerProvider);
    return Stack(
      children: <Widget>[
        // 強更時吸收底層所有輸入，確保 App 真正被阻斷（不僅視覺遮蓋）。
        AbsorbPointer(absorbing: blocked, child: child),
        if (blocked) const _ForceUpdateScrim(),
      ],
    );
  }
}

class _ForceUpdateScrim extends ConsumerWidget {
  const _ForceUpdateScrim();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      // opaque 手勢層：吞掉 scrim 空白處的點擊，避免穿透到底層。
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: ColoredBox(
          color: Colors.black.withValues(alpha: 0.72),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _DlgCard(
                icon: Icons.system_update,
                kicker: '版本更新',
                title: '請更新至最新版本',
                body: '你的版本已過舊，需更新後才能繼續使用。點擊前往下載最新版本。',
                actionText: '前往更新',
                onAction: () async {
                  final VersionCheck v = await ref
                      .read(systemStartupProvider.notifier)
                      .versionCheck();
                  final String? url = v.appUrl;
                  if (url != null) {
                    await ref.read(systemStartupProvider.notifier).openUrl(url);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// `.dlg` 卡片（公告 / 強更共用）：可選 `.dico` 圖示、`.dkick`、標題、內文、
/// 主行動 `.dbtn`、次行動 `.dsec`、右上關閉 `.dclose`。
class _DlgCard extends StatelessWidget {
  const _DlgCard({
    required this.kicker,
    required this.title,
    required this.body,
    this.icon,
    this.actionText,
    this.onAction,
    this.secondaryText,
    this.onSecondary,
    this.onClose,
  });

  final String kicker;
  final String title;
  final String body;
  final IconData? icon;
  final String? actionText;
  final Future<void> Function()? onAction;
  final String? secondaryText;
  final VoidCallback? onSecondary;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surf,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.line),
      ),
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
      child: Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (icon != null)
                Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accFill,
                    border: Border.all(color: AppColors.accBorder),
                  ),
                  child: Icon(icon, color: AppColors.acc, size: 26),
                ),
              Center(
                child: Text(
                  kicker,
                  style: AppTypography.mono.copyWith(
                    fontSize: 9,
                    letterSpacing: 1.4,
                    color: AppColors.acc,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: AppTypography.titleLarge.copyWith(
                    fontFamily: AppTypography.fontSerif,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (body.isNotEmpty)
                Text(
                  body,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 12,
                    height: 1.75,
                    color: AppColors.mut,
                  ),
                ),
              const SizedBox(height: 20),
              if (actionText != null)
                _DlgPrimary(label: actionText!, onTap: onAction),
              if (secondaryText != null)
                _DlgSecondary(label: secondaryText!, onTap: onSecondary),
            ],
          ),
          if (onClose != null)
            Positioned(
              top: -6,
              right: -6,
              child: GestureDetector(
                onTap: onClose,
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.close, size: 16, color: AppColors.mut),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// `.dbtn`：主行動按鈕。
class _DlgPrimary extends StatelessWidget {
  const _DlgPrimary({required this.label, required this.onTap});

  final String label;
  final Future<void> Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.acc,
          foregroundColor: AppColors.btxt,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onTap == null ? null : () => onTap!(),
        child: Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 14,
            color: AppColors.btxt,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

/// `.dsec`：次要行動（關閉）。
class _DlgSecondary extends StatelessWidget {
  const _DlgSecondary({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        height: 44,
        child: TextButton(
          onPressed: onTap,
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              fontSize: 13,
              color: AppColors.mut,
            ),
          ),
        ),
      ),
    );
  }
}
