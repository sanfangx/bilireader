import 'package:bilireader/features/reader/presentation/page_curl/simulation_page_curl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(PageCurlController controller, ValueChanged<int> onChanged) {
  return MaterialApp(
    home: Scaffold(
      body: SimulationPageCurl(
        itemCount: 3,
        controller: controller,
        onIndexChanged: onChanged,
        animDuration: const Duration(milliseconds: 50),
        itemBuilder: (BuildContext context, int index) =>
            Center(child: Text('page $index')),
      ),
    ),
  );
}

void main() {
  testWidgets('程式化 next / previous 會更新頁碼並回呼（含捕圖或 fallback）', (
    WidgetTester tester,
  ) async {
    int? changed;
    final PageCurlController controller = PageCurlController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(_harness(controller, (int i) => changed = i));
    expect(controller.index, 0);

    controller.next();
    await tester.pumpAndSettle();
    expect(controller.index, 1);
    expect(changed, 1);

    controller.previous();
    await tester.pumpAndSettle();
    expect(controller.index, 0);
    expect(changed, 0);
  });

  testWidgets('邊界：第 0 頁不能往前、最後一頁不能往後', (WidgetTester tester) async {
    int callCount = 0;
    final PageCurlController controller = PageCurlController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(_harness(controller, (_) => callCount++));

    controller.previous(); // 已在第 0 頁 → 無效
    await tester.pumpAndSettle();
    expect(controller.index, 0);
    expect(callCount, 0);

    controller.jumpTo(2); // 直接到最後一頁
    await tester.pump();
    expect(controller.index, 2);

    controller.next(); // 已在最後一頁 → 無效
    await tester.pumpAndSettle();
    expect(controller.index, 2);
  });

  testWidgets('點擊右側翻下一頁、左側翻上一頁', (WidgetTester tester) async {
    final PageCurlController controller = PageCurlController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(_harness(controller, (_) {}));
    final Size size = tester.getSize(find.byType(SimulationPageCurl));

    // 點右側 → next
    await tester.tapAt(Offset(size.width * 0.8, size.height / 2));
    await tester.pumpAndSettle();
    expect(controller.index, 1);

    // 點左側 → previous
    await tester.tapAt(Offset(size.width * 0.1, size.height / 2));
    await tester.pumpAndSettle();
    expect(controller.index, 0);
  });
}
