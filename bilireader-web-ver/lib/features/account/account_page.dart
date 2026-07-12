import 'package:flutter/material.dart';

import '../../core/models/novel_summary.dart';
import '../../core/network/linovelib_api.dart';
import '../../core/offline/offline_store.dart';
import '../../core/reading/local_store.dart';
import '../../core/session/auth_controller.dart';
import '../../core/session/shelf_events.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/network_cover.dart';
import '../community/community_page.dart';
import '../download/download_manager_page.dart';

/// 我的 — 個人中心。對齊設計稿 Profile：頭像 + 統計 + 功能選單。
/// 身分（頭像/ID/暱稱/等級）登入後由 `/user.php` 解析（見 applyProfile）；
/// 抓不到暱稱時退回「書友」。統計為本機（收藏/閱讀中/已下載）。
class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late Future<List<NovelSummary>> _bookcase;

  @override
  void initState() {
    super.initState();
    _bookcase = LinovelibApi.instance.bookcase();
    // 加/移書架 → 重抓收藏數（常駐分頁，靠事件刷新）；登入態變（guest→login）也重抓。
    ShelfEvents.instance.addListener(_reloadBookcase);
    AuthController.instance.addListener(_reloadBookcase);
    // 已登入但尚無使用者資訊 → 背景補抓 /user.php
    // （讓在此修復前就已登入的使用者，不必重登也能取回真實暱稱/頭像）。
    final s = AuthController.instance.session;
    if (s != null && s.profile == null) {
      LinovelibApi.instance
          .userProfile()
          .then(AuthController.instance.applyProfile)
          .catchError((_) {});
    }
  }

  @override
  void dispose() {
    ShelfEvents.instance.removeListener(_reloadBookcase);
    AuthController.instance.removeListener(_reloadBookcase);
    super.dispose();
  }

  void _reloadBookcase() {
    if (mounted) setState(() => _bookcase = LinovelibApi.instance.bookcase());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
        children: [
          // 頭像 + 名稱（身分來自 /user.php，隨 applyProfile 即時更新）
          ListenableBuilder(
            listenable: AuthController.instance,
            builder: (context, _) {
              final session = AuthController.instance.session;
              final name = session?.displayName ?? '書友';
              final avatar = session?.avatarUrl;
              final level = session?.levelLabel;
              final uid = session?.userId;
              final subtitle = <String>[
                if (uid != null && uid.isNotEmpty) 'ID $uid',
                if (level != null && level.isNotEmpty) level,
              ].join(' · ');
              return Row(
                children: [
                  (avatar != null && avatar.isNotEmpty)
                      ? NetworkCover(
                          url: avatar, width: 60, height: 60, radius: 30)
                      : Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.cov,
                            border: Border.all(color: AppColors.line),
                          ),
                          alignment: Alignment.center,
                          child: Text(name.characters.first,
                              style: AppText.serif(
                                  size: 22, color: AppColors.acc)),
                        ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: AppText.serif(
                                size: 19, color: AppColors.txt)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Icons.verified_outlined,
                                size: 13, color: Color(0xFF3FBF86)),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                subtitle.isNotEmpty
                                    ? subtitle
                                    : '嗶哩輕小說 · 憑證保存於本機',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.sans(
                                    size: 11, color: AppColors.mut),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 22),

          // 統計列
          FutureBuilder<List<NovelSummary>>(
            future: _bookcase,
            builder: (context, snap) {
              final fav = snap.hasData ? '${snap.data!.length}' : '—';
              return ListenableBuilder(
                listenable: Listenable.merge(
                    [LocalStore.instance, OfflineStore.instance]),
                builder: (context, _) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surf,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      _stat(fav, '收藏書籍'),
                      _divider(),
                      _stat('${LocalStore.instance.readingCount}', '閱讀中'),
                      _divider(),
                      _stat('${OfflineStore.instance.downloadedCount}', '已下載'),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 22),

          // 功能選單
          _menu('✦', '閱讀偏好', () => _toast('閱讀時點底部「字體」即可調整')),
          _menu(
              '◍',
              '圈子討論',
              () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const CommunityPage()))),
          _menu(
              '⤓',
              '下載管理',
              () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => const DownloadManagerPage()))),
          _menu('◔', '消息通知', () => _toast('消息中心開發中')),
          _menu('⚙', '設定', _openSettings),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) => Expanded(
        child: Column(
          children: [
            Text(value, style: AppText.serif(size: 22, color: AppColors.txt)),
            const SizedBox(height: 4),
            Text(label, style: AppText.sans(size: 10.5, color: AppColors.mut)),
          ],
        ),
      );

  Widget _divider() => Container(width: 1, height: 28, color: AppColors.line);

  Widget _menu(String icon, String label, VoidCallback onTap) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.line)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              SizedBox(
                  width: 24,
                  child: Text(icon,
                      textAlign: TextAlign.center,
                      style: AppText.sans(size: 15, color: AppColors.acc))),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(label,
                      style: AppText.sans(size: 13.5, color: AppColors.txt))),
              Text('›', style: AppText.sans(size: 16, color: AppColors.mut)),
            ],
          ),
        ),
      );

  void _toast(String m) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));

  void _openSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surf,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                  child: Text('設定',
                      style: AppText.serif(size: 15, color: AppColors.txt))),
              const SizedBox(height: 16),
              Text('嗶哩輕小說客戶端 · 非官方',
                  style: AppText.sans(size: 11.5, color: AppColors.mut)),
              const SizedBox(height: 4),
              Text('閱讀偏好（字體/主題/亮度）於閱讀頁內調整',
                  style: AppText.sans(size: 11.5, color: AppColors.mut)),
              const SizedBox(height: 18),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  AuthController.instance.logout();
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: AppColors.line),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('登出',
                    style: AppText.sans(size: 13.5, color: AppColors.txt)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
