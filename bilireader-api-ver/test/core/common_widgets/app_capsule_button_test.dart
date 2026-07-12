import 'package:bilireader/core/common_widgets/app_capsule_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_harness.dart';

void main() {
  group('AppCapsuleButton', () {
    testWidgets('啟用時觸發 onPressed', (WidgetTester tester) async {
      int presses = 0;
      await tester.pumpWidget(
        harness(AppCapsuleButton(label: '登入', onPressed: () => presses++)),
      );

      expect(find.text('登入'), findsOneWidget);
      await tester.tap(find.byType(AppCapsuleButton));
      expect(presses, 1);
    });

    testWidgets('onPressed 為 null 時為 disabled 且不崩潰', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(harness(const AppCapsuleButton(label: '登入')));

      await tester.tap(find.byType(AppCapsuleButton));
      expect(find.text('登入'), findsOneWidget);
    });

    testWidgets('可顯示前置 icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        harness(
          AppCapsuleButton(label: '重試', icon: Icons.refresh, onPressed: () {}),
        ),
      );

      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });
  });
}
