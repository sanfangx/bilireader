import 'package:bilireader/core/router/main_shell.dart';
import 'package:bilireader/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/app_harness.dart';

void main() {
  Future<void> pumpShellAtSize(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      wrapAppForTest(BiliReaderApp(dictReady: Future<void>.value())),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('MainShell golden 360x640', (WidgetTester tester) async {
    await pumpShellAtSize(tester, const Size(360, 640));
    await expectLater(
      find.byType(MainShell),
      matchesGoldenFile('goldens/shell_360x640.png'),
    );
  });

  testWidgets('MainShell golden 390x844', (WidgetTester tester) async {
    await pumpShellAtSize(tester, const Size(390, 844));
    await expectLater(
      find.byType(MainShell),
      matchesGoldenFile('goldens/shell_390x844.png'),
    );
  });
}
