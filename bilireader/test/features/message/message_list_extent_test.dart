import 'package:bilireader/core/text/chinese_converter.dart';
import 'package:bilireader/core/text/text_providers.dart';
import 'package:bilireader/features/message/domain/message_entities.dart';
import 'package:bilireader/features/message/presentation/message_controllers.dart';
import 'package:bilireader/features/message/presentation/message_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // F-23：會話列設了 itemExtent（等高列，免逐項量測）。若 itemExtent 小於實際列高，
  // 內容會溢位（可捕捉的 overflow error）→ 此測試同時鎖定「itemExtent 已設 + 值不小於列高」。
  testWidgets('F-23：會話列 itemExtent 已設且不裁切內容', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          conversationsProvider.overrideWith(
            (Ref ref) async => <Conversation>[
              const Conversation(
                peerId: 1,
                peerName: '書友A',
                lastContent: '你好，最近在看什麼小說？',
                unreadCount: 3,
              ),
              const Conversation(peerId: 2, peerName: '書友B', lastContent: '在嗎'),
            ],
          ),
          chineseConverterProvider.overrideWithValue(
            ChineseConverter(loader: (String k) async => ''),
          ),
        ],
        child: const MaterialApp(home: MessageListPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('書友A'), findsOneWidget);
    expect(find.text('書友B'), findsOneWidget);
    // itemExtent 已設（非 null）→ 免逐項量測。
    final ListView list = tester.widget<ListView>(find.byType(ListView));
    expect(list.itemExtent, isNotNull);
    expect(list.itemExtent, greaterThanOrEqualTo(44)); // 至少容納 avatar
    // 無 overflow：itemExtent 不小於實際列高（否則 RenderFlex overflow 會被 takeException 捕捉）。
    expect(tester.takeException(), isNull);
  });
}
