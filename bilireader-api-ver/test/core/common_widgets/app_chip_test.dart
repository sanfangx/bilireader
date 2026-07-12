import 'package:bilireader/core/common_widgets/app_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_harness.dart';

void main() {
  group('AppChip', () {
    testWidgets('顯示文字並在啟用時觸發 onTap', (WidgetTester tester) async {
      int taps = 0;
      await tester.pumpWidget(
        harness(AppChip(label: '全部', onTap: () => taps++)),
      );

      expect(find.text('全部'), findsOneWidget);
      await tester.tap(find.byType(AppChip));
      expect(taps, 1);
    });

    testWidgets('disabled 時不觸發 onTap', (WidgetTester tester) async {
      int taps = 0;
      await tester.pumpWidget(
        harness(AppChip(label: '輕小說', enabled: false, onTap: () => taps++)),
      );

      await tester.tap(find.byType(AppChip));
      expect(taps, 0);
    });

    testWidgets('selected 使用粗體字重', (WidgetTester tester) async {
      await tester.pumpWidget(
        harness(const AppChip(label: '完結', selected: true)),
      );

      final Text text = tester.widget<Text>(find.text('完結'));
      expect(text.style?.fontWeight, FontWeight.w700);
    });

    testWidgets('未選中使用一般字重', (WidgetTester tester) async {
      await tester.pumpWidget(harness(const AppChip(label: '連載中')));

      final Text text = tester.widget<Text>(find.text('連載中'));
      expect(text.style?.fontWeight, FontWeight.w500);
    });
  });
}
