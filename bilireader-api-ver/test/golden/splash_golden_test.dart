import 'package:bilireader/core/theme/app_theme.dart';
import 'package:bilireader/features/system/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpAt(WidgetTester tester, Size size, String golden) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildDarkTheme(),
      home: const SplashScreen(),
    ),
  );
  await tester.pump();
  await expectLater(find.byType(SplashScreen), matchesGoldenFile(golden));
}

void main() {
  // F-26：品牌 splash（字典載入期間）。設計稿無 splash 稿 → 品牌色 + 品牌字（回報假設）。
  testWidgets('SplashScreen golden 360x640', (WidgetTester tester) async {
    await _pumpAt(tester, const Size(360, 640), 'goldens/splash_360x640.png');
  });

  testWidgets('SplashScreen golden 390x844', (WidgetTester tester) async {
    await _pumpAt(tester, const Size(390, 844), 'goldens/splash_390x844.png');
  });
}
