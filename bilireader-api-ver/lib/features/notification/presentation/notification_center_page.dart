import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widgets/bili_empty_view.dart';
import '../../../core/common_widgets/bili_error_view.dart';
import '../../../core/common_widgets/bili_list_footer.dart';
import '../../../core/common_widgets/bili_loading_view.dart';
import '../../../core/network/api_result.dart';
import '../../../core/text/relative_time.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/text/tw_error.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../domain/notification_entities.dart';
import 'notification_controllers.dart';

/// 消息中心（設計稿「消息中心 Notices」）。分類 chips + 通知列表 + 全部已讀。
/// 即時新通知由 notice WebSocket 推送刷新（doc 08）。
class NotificationCenterPage extends ConsumerStatefulWidget {
  const NotificationCenterPage({super.key});

  @override
  ConsumerState<NotificationCenterPage> createState() =>
      _NotificationCenterPageState();
}

class _NotificationCenterPageState
    extends ConsumerState<NotificationCenterPage> {
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final NotificationTab tab = ref.read(notificationTabStateProvider);
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 320) {
      ref.read(notificationListControllerProvider(tab).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final NotificationTab tab = ref.watch(notificationTabStateProvider);
    final AsyncValue<NotificationListState> list = ref.watch(
      notificationListControllerProvider(tab),
    );
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('消息中心'),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              final ApiResult<void> r = await ref
                  .read(notificationListControllerProvider(tab).notifier)
                  .markAllRead();
              if (!context.mounted) {
                return;
              }
              // F-08：成功與失敗都要有明確回饋（不變量#3），避免點了「全部已讀」
              // 卻毫無反應。失敗以轉繁錯誤訊息提示。
              final String message = switch (r) {
                ApiSuccess<void>() => '已全部標為已讀',
                ApiFailure<void>(:final error) => twErrorMessage(
                  ref.read(chineseConverterProvider),
                  error,
                ),
              };
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            },
            child: const Text('全部已讀', style: TextStyle(color: AppColors.acc)),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          _Tabs(tab: tab),
          // F-06：停留頁面時收到新通知 → 提示條，點擊才刷新（不打斷當前瀏覽/捲動）。
          if (list.value?.hasNew ?? false)
            _NewNoticeBanner(
              onTap: () {
                // 非閃刷新（不 invalidate → 不重建 build/不重訂 socket）；refresh 重抓第一頁
                // 並清 hasNew，列表保持可見（不變量#1）。
                ref
                    .read(notificationListControllerProvider(tab).notifier)
                    .refresh();
                if (_scroll.hasClients) {
                  _scroll.jumpTo(0);
                }
              },
            ),
          Expanded(
            child: _List(tab: tab, list: list, scroll: _scroll),
          ),
        ],
      ),
    );
  }
}

/// F-06：「有新通知，點擊刷新」提示條（§9.7 預設：既有 token 組合，無新視覺語言）。
class _NewNoticeBanner extends StatelessWidget {
  const _NewNoticeBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        0,
        AppSpacing.screen,
        8,
      ),
      child: Material(
        color: AppColors.acc,
        borderRadius: AppRadius.pillAll,
        child: InkWell(
          borderRadius: AppRadius.pillAll,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.arrow_upward, size: 15, color: AppColors.btxt),
                const SizedBox(width: 6),
                Text(
                  '有新通知，點擊刷新',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.btxt,
                    fontWeight: FontWeight.w700,
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

class _Tabs extends ConsumerWidget {
  const _Tabs({required this.tab});

  final NotificationTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 32 + 12,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          0,
          AppSpacing.screen,
          12,
        ),
        children: <Widget>[
          for (final NotificationTab t in NotificationTab.values) ...<Widget>[
            if (t != NotificationTab.values.first) const SizedBox(width: 8),
            _Chip(
              label: t.label,
              selected: t == tab,
              onTap: () =>
                  ref.read(notificationTabStateProvider.notifier).select(t),
            ),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.acc : AppColors.surf,
      borderRadius: AppRadius.pillAll,
      child: InkWell(
        borderRadius: AppRadius.pillAll,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            widthFactor: 1,
            child: Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: selected ? AppColors.btxt : AppColors.mut,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _List extends ConsumerWidget {
  const _List({required this.tab, required this.list, required this.scroll});

  final NotificationTab tab;
  final AsyncValue<NotificationListState> list;
  final ScrollController scroll;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return list.when(
      // F-06/F-14：「有新通知」提示條與下拉刷新走非閃 refresh()（保留列表、不進 AsyncLoading）；
      // skipLoadingOnReload/skipError 保護的是 error 態 onRetry 的 ref.invalidate 重抓路徑
      // （重抓期間/失敗時保留已載列表，不閃 loading/錯誤頁、不掉捲動；不變量#1）。
      skipLoadingOnReload: true,
      skipError: true,
      loading: () => const BiliLoadingView(message: '載入通知'),
      error: (Object e, StackTrace _) => BiliErrorView(
        message: twErrorMessage(ref.read(chineseConverterProvider), e),
        onRetry: () => ref.invalidate(notificationListControllerProvider(tab)),
      ),
      data: (NotificationListState s) {
        // F-14：下拉刷新（保留列表，不閃 loading）。
        Future<void> onRefresh() => ref
            .read(notificationListControllerProvider(tab).notifier)
            .refresh();
        if (s.items.isEmpty) {
          return RefreshIndicator(
            color: AppColors.acc,
            backgroundColor: AppColors.surf,
            onRefresh: onRefresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const <Widget>[
                SizedBox(height: 120),
                BiliEmptyView(
                  message: '沒有新消息',
                  icon: Icons.notifications_none_outlined,
                ),
              ],
            ),
          );
        }
        // F-24/F-15/F-30：尾端三態。
        final BiliListFooterState? footer = BiliListFooter.stateOf(
          loadingMore: s.loadingMore,
          loadMoreError: s.loadMoreError,
          hasMore: s.hasMore,
        );
        return RefreshIndicator(
          color: AppColors.acc,
          backgroundColor: AppColors.surf,
          onRefresh: onRefresh,
          child: ListView.builder(
            controller: scroll,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: s.items.length + (footer == null ? 0 : 1),
            itemBuilder: (BuildContext context, int i) {
              if (i >= s.items.length) {
                return BiliListFooter(
                  state: footer!,
                  onRetry: () => ref
                      .read(notificationListControllerProvider(tab).notifier)
                      .retryLoadMore(),
                );
              }
              return _NoticeRow(tab: tab, item: s.items[i]);
            },
          ),
        );
      },
    );
  }
}

/// `.nt`（`.un` 未讀底色）。點按單則標已讀。
class _NoticeRow extends ConsumerWidget {
  const _NoticeRow({required this.tab, required this.item});

  final NotificationTab tab;
  final AppNotification item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      // F-06：就地標為已讀（樂觀），不 invalidate 整列（否則閃 loading、掉捲動；不變量#1）。
      onTap: item.isRead
          ? null
          : () => ref
                .read(notificationListControllerProvider(tab).notifier)
                .markReadLocal(item.notifyId),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: 13,
        ),
        decoration: BoxDecoration(
          color: item.isRead ? null : AppColors.surf,
          border: const Border(top: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // .nt-ic
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.cov,
                shape: BoxShape.circle,
              ),
              child: Text(
                _glyph(item.kind),
                style: const TextStyle(fontSize: 15, color: AppColors.acc),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          item.headline,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 12.5,
                            color: AppColors.txt,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        relativeTimeFromSeconds(item.addTime),
                        style: AppTypography.mono.copyWith(
                          fontSize: 9.5,
                          color: AppColors.mut,
                        ),
                      ),
                    ],
                  ),
                  if (item.body.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.cov,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border(
                          left: BorderSide(color: AppColors.line, width: 2),
                        ),
                      ),
                      child: Text(
                        item.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(fontSize: 10.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _glyph(NotificationKind kind) => switch (kind) {
    NotificationKind.like => '▲',
    NotificationKind.reply => '💬',
    NotificationKind.flower => '❀',
    NotificationKind.system => '◈',
    NotificationKind.other => '🔔',
  };
}
