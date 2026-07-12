import 'dart:async';

import 'package:bilireader/features/system/presentation/splash_screen.dart';
import 'package:bilireader/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/app_harness.dart';

void main() {
  testWidgets('App 啟動並顯示書城分頁（smoke test）', (WidgetTester tester) async {
    // F-26：dictReady 傳已完成 Future → splash gate 立即進入路由 App。
    await tester.pumpWidget(
      wrapAppForTest(BiliReaderApp(dictReady: Future<void>.value())),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('page_discover')), findsOneWidget);
    // 書城字樣同時出現在品牌標頭（BrandHeader）與底部分頁標籤。
    expect(find.text('書城'), findsWidgets);
  });

  testWidgets('F-26：字典未就緒時顯示 splash，就緒後進入書城', (WidgetTester tester) async {
    final Completer<void> gate = Completer<void>();
    await tester.pumpWidget(
      wrapAppForTest(BiliReaderApp(dictReady: gate.future)),
    );
    await tester.pump();
    // 字典載入中 → splash（品牌字 + 尚無書城分頁）。
    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byKey(const Key('page_discover')), findsNothing);
    // 字典就緒 → 進入路由 App、顯示書城。
    gate.complete();
    await tester.pumpAndSettle();
    expect(find.byType(SplashScreen), findsNothing);
    expect(find.byKey(const Key('page_discover')), findsOneWidget);
  });
}
