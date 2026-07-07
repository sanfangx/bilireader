import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common_widgets/bili_error_view.dart';
import '../../../core/common_widgets/bili_loading_view.dart';
import '../../../core/text/text_providers.dart';
import '../../../core/text/tw_error.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../domain/message_entities.dart';
import 'message_controllers.dart';

/// 私訊對話頁（設計稿「私訊對話 Chat」）。氣泡 in/out + 底部輸入列。
/// 訊息來自 owner-scoped 本地快取串流（REST 歷史 + WS 即時），送訊走 WebSocket。
class ChatPage extends ConsumerWidget {
  const ChatPage({required this.peerId, required this.peerName, super.key});

  final int peerId;
  final String peerName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ChatMessage>> messages = ref.watch(
      chatMessagesProvider(peerId),
    );
    final int myUid = ref.watch(currentUidProvider).value ?? 0;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: Text(peerName.isEmpty ? '私訊' : peerName)),
      body: Column(
        children: <Widget>[
          Expanded(
            child: messages.when(
              loading: () => const BiliLoadingView(message: '載入對話'),
              error: (Object e, StackTrace _) => BiliErrorView(
                message: twErrorMessage(ref.read(chineseConverterProvider), e),
                onRetry: () => ref.invalidate(chatMessagesProvider(peerId)),
              ),
              data: (List<ChatMessage> list) => list.isEmpty
                  ? const Center(
                      child: Text('開始你們的對話', style: AppTypography.bodySmall),
                    )
                  : _Bubbles(messages: list, myUid: myUid),
            ),
          ),
          _ChatInput(peerId: peerId),
        ],
      ),
    );
  }
}

/// `.chat`：氣泡串（reverse:true 錨在底部；newest 在下）。
class _Bubbles extends StatelessWidget {
  const _Bubbles({required this.messages, required this.myUid});

  final List<ChatMessage> messages;
  final int myUid;

  @override
  Widget build(BuildContext context) {
    final int n = messages.length;
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      itemCount: n,
      itemBuilder: (BuildContext context, int i) {
        final ChatMessage m = messages[n - 1 - i];
        return _Bubble(message: m, mine: m.fromId == myUid);
      },
    );
  }
}

/// `.bub.in` / `.bub.out`。
class _Bubble extends StatelessWidget {
  const _Bubble({required this.message, required this.mine});

  final ChatMessage message;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 11),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.74,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        decoration: BoxDecoration(
          color: mine ? AppColors.acc : AppColors.surf,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(mine ? 16 : 5),
            bottomRight: Radius.circular(mine ? 5 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if ((message.quoteContent ?? '').isNotEmpty)
              _Quote(message: message, mine: mine),
            Text(
              message.content,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 12.5,
                height: 1.55,
                color: mine ? AppColors.btxt : AppColors.rtxt,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 引用回覆片段。
class _Quote extends StatelessWidget {
  const _Quote({required this.message, required this.mine});

  final ChatMessage message;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    final Color fg = mine ? AppColors.btxt : AppColors.mut;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        // mine（金底）用半透明黑；in（surf 底）用 cov。皆為固定色（不用 withValues）。
        color: mine ? const Color(0x22000000) : AppColors.cov,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        '${message.quoteFromName ?? ''}：${message.quoteContent}',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.bodySmall.copyWith(fontSize: 10.5, color: fg),
      ),
    );
  }
}

/// `.chat-in`：輸入列。
class _ChatInput extends ConsumerStatefulWidget {
  const _ChatInput({required this.peerId});

  final int peerId;

  @override
  ConsumerState<_ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends ConsumerState<_ChatInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final String text = _controller.text.trim();
    if (text.isEmpty) {
      return;
    }
    ref
        .read(messageActionsProvider.notifier)
        .send(toUserId: widget.peerId, content: text);
    _controller.clear();
    // 送出後由 WS 回音（chat_message/chat_ack）寫入快取，串流即時顯示。
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
        decoration: const BoxDecoration(
          color: AppColors.bg,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: AppColors.surf,
                  borderRadius: AppRadius.pillAll,
                ),
                alignment: Alignment.centerLeft,
                child: TextField(
                  controller: _controller,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.txt),
                  onSubmitted: (_) => _send(),
                  decoration: const InputDecoration.collapsed(
                    hintText: '訊息…',
                    hintStyle: AppTypography.bodySmall,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Material(
              color: AppColors.acc,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _send,
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.arrow_upward_rounded,
                    size: 18,
                    color: AppColors.btxt,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
