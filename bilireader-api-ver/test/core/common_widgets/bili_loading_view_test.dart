import 'package:bilireader/core/common_widgets/bili_loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_harness.dart';

void main() {
  group('BiliLoadingView', () {
    testWidgets('顯示載入指示與訊息', (WidgetTester tester) async {
      await tester.pumpWidget(harness(const BiliLoadingView(message: '載入中')));
      // 不呼叫 pumpAndSettle：CircularProgressIndicator 為持續動畫。
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('載入中'), findsOneWidget);
    });

    testWidgets('無訊息時只顯示指示器', (WidgetTester tester) async {
      await tester.pumpWidget(harness(const BiliLoadingView()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });
  });
}
