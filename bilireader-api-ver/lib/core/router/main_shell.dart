import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/message/presentation/unread_center.dart';
import '../../features/system/domain/system_entities.dart';
import '../../features/system/presentation/startup_dialogs.dart';
import '../../features/system/presentation/system_controllers.dart';
import '../common_widgets/app_badge.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../ws/ws_providers.dart';

/// 底部四分頁外框（規範 §2.2）。以 [StatefulNavigationShell] 保留各分頁狀態，
/// 對應原生非滑動 ViewPager2。分頁順序與文案：書城／書架／圈子／我的（繁中）。
///
/// 首次掛載時（每次啟動一次）跑 Feature ⑧ 啟動流程：版本檢查（501 強更覆蓋層）→
/// 啟動公告（去重彈窗）→ 每日自動簽到（登入且今日未簽）。
class MainShell extends ConsumerStatefulWidget {
  const MainShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  static const List<_TabSpec> _tabs = <_TabSpec>[
    _TabSpec(
      keyValue: 'tab_store',
      label: '書城',
      icon: Icons.storefront_outlined,
      activeIcon: Icons.storefront,
    ),
    _TabSpec(
      keyValue: 'tab_shelf',
      label: '書架',
      icon: Icons.collections_bookmark_outlined,
      activeIcon: Icons.collections_bookmark,
    ),
    _TabSpec(
      keyValue: 'tab_quanzi',
      label: '圈子',
      icon: Icons.forum_outlined,
      activeIcon: Icons.forum,
    ),
    // 我的分頁未讀紅點（F-02）：badge 由 [unreadCenterProvider] 驅動，見 build()。
    _TabSpec(
      keyValue: 'tab_user',
      label: '我的',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
    ),
  ];

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell>
    with WidgetsBindingObserver {
  bool _startupRan = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _runStartupOnce());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// F-10：App 恢復前景時，兩條 socket「重置退避 + 立即重連」（睡眠斷線後退避可能正在
  /// 16–30s 等待，這幾秒收不到即時更新），並重同步全域未讀。`resetBackoffAndReconnect()`
  /// 已冪等（`_open()` 先拆舊 channel/sub，phase6 ②），重連不孤兒化 subscription。
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(noticeSocketProvider).resetBackoffAndReconnect();
        ref.read(chatSocketProvider).resetBackoffAndReconnect();
        ref.invalidate(unreadCenterProvider);
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // F-21：閱讀進度的 pause/background flush 由 ReaderPage 自身的 WidgetsBindingObserver
        // 處理（reader 為 root-navigator 全屏 route、非 shell 子樹，shell observer 無把手）。
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  /// 每次 App 啟動只跑一次（MainShell 於路由解析後首度掛載）。
  Future<void> _runStartupOnce() async {
    if (_startupRan || !mounted) {
      return;
    }
    _startupRan = true;
    final SystemStartup startup = ref.read(systemStartupProvider.notifier);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    // 1) 版本檢查：需更新則由 VersionCheckInterceptor 於 501 觸發強更覆蓋層，此處不再往下。
    final VersionCheck version = await startup.versionCheck();
    if (!mounted || version.needUpdate) {
      return;
    }
    // 2) 啟動公告（以 dismissKey + 內容簽章去重）。
    final StartupAnnouncement? ann = await startup.announcementIfNew();
    if (!mounted) {
      return;
    }
    if (ann != null) {
      await showStartupAnnouncementDialog(context, ref, ann);
      if (!mounted) {
        return;
      }
    }
    // 3) 每日自動簽到（登入且今日未簽；§7.0 一次/日）。
    final SignInResult? signIn = await startup.autoSignInIfNeeded();
    if (!mounted || signIn == null) {
      return;
    }
    messenger.showSnackBar(
      SnackBar(
        content: Text('簽到成功 · +${signIn.points} 積分（共 ${signIn.totalScore}）'),
      ),
    );
  }

  void _onTap(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    // F-02：「我的」分頁未讀紅點 = 私訊 + 通知合併未讀（未登入強制 0）。
    final int userUnread = ref.watch(
      unreadCenterProvider.select((UnreadState s) => s.total),
    );
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: _BottomBar(
        tabs: MainShell._tabs,
        currentIndex: widget.navigationShell.currentIndex,
        onTap: _onTap,
        userUnread: userUnread,
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.userUnread = 0,
  });

  final List<_TabSpec> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;

  /// 「我的」分頁未讀計數（F-02）；0 時不顯示紅點。
  final int userUnread;

  @override
  Widget build(BuildContext context) {
    final double bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SizedBox(
          height: 58,
          child: Row(
            children: <Widget>[
              for (int i = 0; i < tabs.length; i++)
                Expanded(
                  child: _TabItem(
                    key: ValueKey<String>(tabs[i].keyValue),
                    spec: tabs[i],
                    selected: i == currentIndex,
                    onTap: () => onTap(i),
                    badgeCount: tabs[i].keyValue == 'tab_user' ? userUnread : 0,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.spec,
    required this.selected,
    required this.onTap,
    this.badgeCount = 0,
    super.key,
  });

  final _TabSpec spec;
  final bool selected;
  final VoidCallback onTap;

  /// 未讀計數（F-02）；>0 時於圖示右上疊紅色 [AppBadge]。
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final Color color = selected ? AppColors.acc : AppColors.mut;
    final Widget icon = Icon(
      selected ? spec.activeIcon : spec.icon,
      color: color,
      size: 24,
    );
    return InkResponse(
      onTap: onTap,
      radius: 44,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (badgeCount > 0)
            Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                icon,
                Positioned(
                  top: -6,
                  right: -10,
                  child: AppBadge(
                    label: badgeCount > 99 ? '99+' : '$badgeCount',
                    variant: AppBadgeVariant.danger,
                    pill: true,
                    // F-12：徽章對 TalkBack 播報有意義文字，而非裸數字。
                    semanticLabel: badgeCount > 99
                        ? '99 則以上未讀'
                        : '$badgeCount 則未讀',
                  ),
                ),
              ],
            )
          else
            icon,
          const SizedBox(height: 4),
          Text(
            spec.label,
            style: AppTypography.bodySmall.copyWith(
              color: color,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

@immutable
class _TabSpec {
  const _TabSpec({
    required this.keyValue,
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String keyValue;
  final String label;
  final IconData icon;
  final IconData activeIcon;
}
