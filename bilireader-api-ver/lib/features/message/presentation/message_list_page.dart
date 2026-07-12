import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/common_widgets/bili_error_view.dart';
import '../../../core/common_widgets/bili_loading_view.dart';
import '../../../core/common_widgets/user_avatar.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/text/relative_time.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/text/tw_error.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../domain/message_entities.dart';
import 'message_controllers.dart';

/// 私訊會話列表頁（設計稿「私訊會話 Messages」）。`message/conversations`。
class MessageListPage extends ConsumerWidget {
  const MessageListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Conversation>> convos = ref.watch(
      conversationsProvider,
    );
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('私訊')),
      body: RefreshIndicator(
        color: AppColors.acc,
        backgroundColor: AppColors.surf,
        onRefresh: () async {
          ref.invalidate(conversationsProvider);
          await ref.read(conversationsProvider.future);
        },
        // F-04：WS 新私訊會 invalidate 本 provider 重抓；skipLoadingOnReload 保留已載列表
        // 於重抓期間、skipError 保留已載列表於重抓「失敗」時（否則背景重抓失敗會以錯誤頁
        // 取代整列、掉捲動，違反不變量#1）。首載的 loading / error 仍正常顯示。
        child: convos.when(
          skipLoadingOnReload: true,
          skipError: true,
          loading: () => const BiliLoadingView(message: '載入私訊'),
          error: (Object e, StackTrace _) => BiliErrorView(
            message: twErrorMessage(ref.read(chineseConverterProvider), e),
            onRetry: () => ref.invalidate(conversationsProvider),
          ),
          data: (List<Conversation> list) => list.isEmpty
              ? const _Empty()
              : ListView.builder(
                  // F-23：會話列為等高（avatar 44 主導 + 固定 padding），設 itemExtent 讓
                  // ListView 免逐項量測離屏子項。值由 _ConversationRow 實測鎖定（見測試）。
                  itemExtent: _kConversationRowExtent,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int i) =>
                      _ConversationRow(convo: list[i]),
                ),
        ),
      ),
    );
  }
}

/// F-23：`_ConversationRow` 的固定列高（avatar 44 + 上下 padding 13×2 = 70；
/// 名稱/內文各 1 行、含 1.3× 文字縮放仍短於 avatar，故列高恆定）。widget test 鎖定。
const double _kConversationRowExtent = 70;

/// `.cv`：會話列。
class _ConversationRow extends StatelessWidget {
  const _ConversationRow({required this.convo});

  final Conversation convo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        AppRoutes.chatName,
        pathParameters: <String, String>{'peerId': '${convo.peerId}'},
        queryParameters: <String, String>{'name': convo.peerName},
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screen,
          vertical: 13,
        ),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: <Widget>[
            UserAvatar(url: convo.avatarUrl, size: 44),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          convo.peerName.isEmpty ? '書友' : convo.peerName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 13,
                            color: AppColors.txt,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        relativeTimeFromSeconds(convo.lastPostdate),
                        style: AppTypography.mono.copyWith(
                          fontSize: 9.5,
                          color: AppColors.mut,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    convo.lastContent,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.bodySmall.copyWith(fontSize: 11.5),
                  ),
                ],
              ),
            ),
            if (convo.unreadCount > 0) ...<Widget>[
              const SizedBox(width: 10),
              _UnreadBadge(count: convo.unreadCount),
            ],
          ],
        ),
      ),
    );
  }
}

/// `.cv-badge`：未讀數紅點。
class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 18),
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.badgeRed,
        borderRadius: BorderRadius.all(Radius.circular(9)),
      ),
      child: Text(
        count > 99 ? '99+' : '$count',
        style: AppTypography.mono.copyWith(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        SizedBox(height: 120),
        Icon(Icons.mail_outline, color: AppColors.mut, size: 44),
        SizedBox(height: AppSpacing.md),
        Center(child: Text('還沒有私訊', style: AppTypography.titleMedium)),
      ],
    );
  }
}
