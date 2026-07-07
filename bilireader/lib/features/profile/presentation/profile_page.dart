import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common_widgets/app_capsule_button.dart';
import '../../../core/common_widgets/bili_error_view.dart';
import '../../../core/common_widgets/bili_loading_view.dart';
import '../../../core/common_widgets/status_pill.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/router/auth_controller.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../auth/domain/user_info.dart';
import '../../auth/presentation/current_user_provider.dart';
import '../../system/presentation/system_controllers.dart';

/// 我的分頁（設計稿「個人中心 Profile」）。身分卡 + 簽到狀態 + 5 格會員數值 +
/// 選單。所有數值皆為 UserEntity 真實欄位（§No Mock Data）；顯示文字轉繁（§5.0）。
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthSnapshot auth = ref.watch(authControllerProvider);
    return Scaffold(
      key: const Key('page_profile'),
      backgroundColor: AppColors.bg,
      body: SafeArea(
        bottom: false,
        child: auth.isLoggedIn
            ? const _LoggedInView()
            : const _NotLoggedInView(),
      ),
    );
  }
}

class _NotLoggedInView extends StatelessWidget {
  const _NotLoggedInView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.screen),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.person_outline, color: AppColors.mut, size: 48),
            const SizedBox(height: AppSpacing.md),
            const Text('尚未登入', style: AppTypography.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              '登入後即可使用書架、圈子與作者專區。',
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCapsuleButton(
              label: '前往登入',
              shape: AppButtonShape.capsule,
              onPressed: () => context.pushNamed(AppRoutes.loginName),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoggedInView extends ConsumerWidget {
  const _LoggedInView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<UserInfo?> user = ref.watch(currentUserProvider);
    // F-14：下拉刷新個人資訊；skipLoadingOnReload + skipError 保留已載內容於重抓/失敗，
    // 不閃 loading/錯誤頁（不變量#1）。
    return user.when(
      skipLoadingOnReload: true,
      skipError: true,
      loading: () => const BiliLoadingView(message: '載入中'),
      error: (Object e, StackTrace _) => BiliErrorView(
        message: '無法載入個人資訊',
        onRetry: () => ref.invalidate(currentUserProvider),
      ),
      data: (UserInfo? u) => u == null
          ? BiliErrorView(
              message: '無法載入個人資訊',
              onRetry: () => ref.invalidate(currentUserProvider),
            )
          : RefreshIndicator(
              color: AppColors.acc,
              backgroundColor: AppColors.surf,
              onRefresh: () async {
                ref.invalidate(currentUserProvider);
                await ref.read(currentUserProvider.future);
              },
              child: _ProfileBody(user: u),
            ),
    );
  }
}

/// 設計稿 `.pf`：身分卡 + 簽到 + 5 格統計 + 選單。
class _ProfileBody extends ConsumerWidget {
  const _ProfileBody({required this.user});

  final UserInfo user;

  String _tw(WidgetRef ref, String? text) {
    if (text == null || text.isEmpty) {
      return '';
    }
    try {
      return ref.read(chineseConverterProvider).toTraditionalTw(text);
    } on Object catch (_) {
      return text;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String nickname = _tw(ref, user.nickname ?? user.username);
    final String display = nickname.isEmpty ? '書友' : nickname;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        12,
        AppSpacing.screen,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _ProfileHeader(user: user, displayName: display),
          const SizedBox(height: 16),
          const _SignInCard(),
          const SizedBox(height: 16),
          _StatRow(user: user),
          const SizedBox(height: 18),
          _Menu(user: user),
        ],
      ),
    );
  }
}

/// `.pfh`：頭像 + 暱稱（+ Lv / VIP）+ UID + ⚙ 設定。
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user, required this.displayName});

  final UserInfo user;
  final String displayName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        // `.pfav`：頭像（cov 底 + acc 首字，serif）。
        Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.cov,
            border: Border.all(color: AppColors.line),
          ),
          child: Text(
            displayName.characters.first,
            style: AppTypography.displayMedium.copyWith(
              fontSize: 24,
              color: AppColors.acc,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Flexible(
                    child: Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.displayMedium.copyWith(fontSize: 19),
                    ),
                  ),
                  if (user.level != null && user.level!.isNotEmpty) ...<Widget>[
                    const SizedBox(width: 8),
                    // level 欄位已含「Lv.N …」格式，直接顯示、不再前綴 Lv。
                    StatusPill(
                      label: user.level!,
                      variant: StatusPillVariant.level,
                    ),
                  ],
                  if (user.isVip) ...<Widget>[
                    const SizedBox(width: 8),
                    const StatusPill(
                      label: 'VIP',
                      variant: StatusPillVariant.vip,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 5),
              Text(
                'UID ${user.uid}',
                style: AppTypography.mono.copyWith(
                  fontSize: 11,
                  color: AppColors.mut,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const _SettingsIcon(),
      ],
    );
  }
}

/// `.ico` ⚙ → 系統設定。
class _SettingsIcon extends StatelessWidget {
  const _SettingsIcon();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surf,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => context.pushNamed(AppRoutes.settingsName),
        child: const SizedBox(
          width: 34,
          height: 34,
          child: Icon(Icons.settings_outlined, size: 16, color: AppColors.txt),
        ),
      ),
    );
  }
}

/// `.pfsign`：簽到狀態卡（啟動流程於登入後自動簽到，此處顯示結果）。
class _SignInCard extends ConsumerWidget {
  const _SignInCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<SignInDisplay> status = ref.watch(profileSignInProvider);
    final SignInDisplay s =
        status.value ?? const SignInDisplay(signedToday: false, points: 0);
    final bool signed = s.signedToday;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accBorderSoft),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF3A2C16), Color(0xFF241A10)],
        ),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.access_time, size: 18, color: AppColors.acc),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  signed ? '今日已自動簽到' : '尚未簽到',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 12.5,
                    color: AppColors.acc,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  signed
                      ? (s.points > 0 ? '獲得 ${s.points} 積分 · 明日再來' : '明日再來')
                      : '每日簽到可獲得積分',
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 10,
                    color: AppColors.mut,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          StatusPill(
            label: signed ? '已簽到' : '簽到中',
            variant: StatusPillVariant.signed,
          ),
        ],
      ),
    );
  }
}

/// `.pfstat5`：經驗 / 積分 / 輕嗶哩幣 / 貢獻 / 推薦票（皆 UserEntity 真實欄位）。
class _StatRow extends StatelessWidget {
  const _StatRow({required this.user});

  final UserInfo user;

  static String _comma(int n) {
    final String s = n.abs().toString();
    final StringBuffer out = StringBuffer(n < 0 ? '-' : '');
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) {
        out.write(',');
      }
      out.write(s[i]);
    }
    return out.toString();
  }

  @override
  Widget build(BuildContext context) {
    final List<(String, String)> stats = <(String, String)>[
      (_comma(user.experience ?? 0), '經驗'),
      (_comma(user.score ?? 0), '積分'),
      (_comma(user.egold ?? 0), '輕嗶哩幣'),
      (_comma(user.credit ?? 0), '貢獻'),
      ((user.votes ?? '0').isEmpty ? '0' : user.votes!, '推薦票'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surf,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 14),
      child: Row(
        children: <Widget>[
          for (int i = 0; i < stats.length; i++)
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: i == 0
                      ? null
                      : const Border(left: BorderSide(color: AppColors.line)),
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      stats[i].$1,
                      style: AppTypography.mono.copyWith(
                        fontSize: 15,
                        color: AppColors.txt,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stats[i].$2,
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 8,
                        color: AppColors.mut,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// `.menu`：設計稿 6 列（作者專區依 groupid 閘門）。未建頁者提示建置中。
class _Menu extends StatelessWidget {
  const _Menu({required this.user});

  final UserInfo user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _MenuRow(
          icon: Icons.person_outline,
          label: '個人資料',
          onTap: () => _todo(context, '個人資料'),
        ),
        _MenuRow(
          icon: Icons.notifications_none_outlined,
          label: '消息中心',
          onTap: () => context.pushNamed(AppRoutes.notificationsName),
        ),
        _MenuRow(
          icon: Icons.rate_review_outlined,
          label: '我的書評',
          onTap: () => _todo(context, '我的書評'),
        ),
        _MenuRow(
          icon: Icons.article_outlined,
          label: '我的貼文',
          onTap: () => _todo(context, '我的貼文'),
        ),
        if (user.canAccessAuthorZone)
          _MenuRow(
            icon: Icons.edit_note_outlined,
            label: '作者專區',
            onTap: () => context.pushNamed(AppRoutes.authorZoneName),
          ),
        _MenuRow(
          icon: Icons.help_outline,
          label: '幫助中心',
          onTap: () => _todo(context, '幫助中心'),
        ),
      ],
    );
  }

  void _todo(BuildContext context, String name) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$name（建置中）')));
}

/// `.mrow`：扁平選單列（acc 圖示 + 標題 + chevron，底線分隔）。
class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 2),
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
            const Icon(Icons.chevron_right, size: 18, color: AppColors.mut),
          ],
        ),
      ),
    );
  }
}
