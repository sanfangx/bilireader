import 'package:flutter/material.dart';

import '../features/account/account_page.dart';
import '../features/discovery/discovery_hub_page.dart';
import '../features/home/home_page.dart';
import '../features/shelf/bookshelf_page.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/app_background.dart';

/// 登入後主框架：底部導覽（書城 / 書架 / 分類 / 我的）。
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _tabs = ['書城', '書架', '分類', '我的'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: IndexedStack(
          index: _index,
          children: const [
            HomePage(),
            BookshelfPage(),
            DiscoveryHubPage(),
            AccountPage(),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNav(
        index: _index,
        labels: _tabs,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.index,
    required this.labels,
    required this.onTap,
  });

  final int index;
  final List<String> labels;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 6, 0, 18),
          child: SizedBox(
            height: 50,
            child: Row(
              children: [
                for (int i = 0; i < labels.length; i++)
                  Expanded(
                    child: _NavItem(
                      label: labels[i],
                      active: i == index,
                      onTap: () => onTap(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.acc : AppColors.mut;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Center(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: active
                  ? [BoxShadow(color: AppColors.acc, blurRadius: 9)]
                  : null,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: AppText.sans(size: 10, color: color)),
        ],
        ),
      ),
    );
  }
}
