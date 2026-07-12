import 'package:bilireader/core/common_widgets/bili_error_view.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_harness.dart';

void main() {
  group('BiliErrorView', () {
    testWidgets('顯示訊息並在點擊重試時觸發 onRetry', (WidgetTester tester) async {
      int retries = 0;
      await tester.pumpWidget(
        harness(BiliErrorView(message: '網路連線失敗', onRetry: () => retries++)),
      );

      expect(find.text('網路連線失敗'), findsOneWidget);
      expect(find.text('重試'), findsOneWidget);
      await tester.tap(find.text('重試'));
      expect(retries, 1);
    });

    testWidgets('無 onRetry 時不顯示重試並使用預設訊息', (WidgetTester tester) async {
      await tester.pumpWidget(harness(const BiliErrorView()));

      expect(find.text('重試'), findsNothing);
      expect(find.text('發生錯誤，請稍後再試'), findsOneWidget);
    });
  });
}
