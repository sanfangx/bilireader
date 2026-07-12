import 'package:bilireader/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/app_harness.dart';

void main() {
  testWidgets('底部四分頁切換並保留分頁狀態', (WidgetTester tester) async {
    await tester.pumpWidget(
      wrapAppForTest(BiliReaderApp(dictReady: Future<void>.value())),
    );
    await tester.pumpAndSettle();

    // 初始顯示書城；其餘分頁尚未建立（indexedStack lazy）。
    expect(find.byKey(const Key('page_discover')), findsOneWidget);
    expect(find.byKey(const Key('page_bookshelf')), findsNothing);

    // 切到書架；書城因 indexedStack 保留而仍在樹上（狀態保留）。
    await tester.tap(find.byKey(const Key('tab_shelf')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('page_bookshelf')), findsOneWidget);
    // 書城已切到背景（offstage）但仍在樹上，需 skipOffstage: false 才找得到，
    // 藉此驗證 indexedStack 保留了分頁狀態。
    expect(
      find.byKey(const Key('page_discover'), skipOffstage: false),
      findsOneWidget,
    );

    // 切到我的，顯示未登入引導。
    await tester.tap(find.byKey(const Key('tab_user')));
    await tester.pumpAndSettle();
    expect(find.text('尚未登入'), findsOneWidget);
    expect(find.text('前往登入'), findsOneWidget);
  });

  testWidgets('點擊前往登入導向登入佔位頁', (WidgetTester tester) async {
    await tester.pumpWidget(
      wrapAppForTest(BiliReaderApp(dictReady: Future<void>.value())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('tab_user')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('前往登入'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('login_submit')), findsOneWidget);
    expect(find.text('帳號或信箱'), findsOneWidget);
  });
}
