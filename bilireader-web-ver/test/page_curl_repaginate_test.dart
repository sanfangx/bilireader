import 'package:bilireader_app/features/reader/presentation/page_curl/simulation_page_curl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// 迴歸測試：捲曲翻頁模式下「重新分頁使頁數變少」不得索引越界。
///
/// 坑：`SimulationPageCurl._index` 只在 initState 初始化、之後只由翻頁流程更新。
/// 使用者讀到章節後段時放大字級／旋轉螢幕 → 上層 `ReaderPagedView` 重新分頁 →
/// `itemCount` 變小，但 build 仍無條件以舊 `_index` 呼叫 `itemBuilder`
/// （`_boundary(_curKey, _index)`）→ `_pages[_index]` 直接 RangeError 紅屏。
///
/// 上層雖然也會 `_curlController.jumpTo(initial)` 定位並夾住，但那排在
/// `addPostFrameCallback` 裡，比崩潰的那一幀 build 晚一幀——來不及。
/// 故夾制必須發生在 `didUpdateWidget`。
void main() {
  Widget host({required int itemCount, PageCurlController? controller}) {
    return MaterialApp(
      home: SimulationPageCurl(
        itemCount: itemCount,
        controller: controller,
        // 刻意模擬 ReaderPagedView 的 `page(i) => _PageContent(blocks: _pages[i])`：
        // 越界索引在這裡就會拋，正是線上崩潰的形狀。
        itemBuilder: (BuildContext ctx, int i) {
          if (i < 0 || i >= itemCount) {
            throw RangeError.index(i, List<int>.filled(itemCount, 0));
          }
          return Text('page $i');
        },
      ),
    );
  }

  testWidgets('重新分頁使頁數變少：_index 被夾住，不越界崩潰', (WidgetTester tester) async {
    final PageCurlController controller = PageCurlController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(host(itemCount: 32, controller: controller));

    // 讀到章節後段（第 30 頁／共 32 頁）。
    controller.jumpTo(30);
    await tester.pump();
    expect(controller.index, 30);

    // 放大字級 → 重新分頁 → 總頁數縮到 24。
    await tester.pumpWidget(host(itemCount: 24, controller: controller));
    await tester.pump();

    expect(
      tester.takeException(),
      isNull,
      reason: '頁數變少時 _index 未夾住 → itemBuilder 索引越界',
    );
    expect(controller.index, 23, reason: '應被夾到新的最後一頁');
  });

  testWidgets('頁數變多時不動 _index（只夾上界，不干擾閱讀位置）', (WidgetTester tester) async {
    final PageCurlController controller = PageCurlController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(host(itemCount: 10, controller: controller));
    controller.jumpTo(4);
    await tester.pump();

    // 縮小字級 → 頁數變多。目前頁仍然有效，不應被移動。
    await tester.pumpWidget(host(itemCount: 40, controller: controller));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(controller.index, 4);
  });

  testWidgets('itemCount 降到 1：夾到 0 而非 -1', (WidgetTester tester) async {
    final PageCurlController controller = PageCurlController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(host(itemCount: 8, controller: controller));
    controller.jumpTo(7);
    await tester.pump();

    await tester.pumpWidget(host(itemCount: 1, controller: controller));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(controller.index, 0);
  });
}
