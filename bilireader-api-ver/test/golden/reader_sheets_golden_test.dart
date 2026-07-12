import 'package:bilireader/core/di/infra_providers.dart';
import 'package:bilireader/core/theme/app_theme.dart';
import 'package:bilireader/features/reader/presentation/panels/reader_settings_sheets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// F-18 純重構回歸網：在 magic number → token 重構**前**鎖定閱讀器設定彈窗現狀。
/// 重構後 golden 原樣通過＝「視覺零變化」證明（§9.3）。
Future<void> _pumpSheet(
  WidgetTester tester,
  ProviderContainer container,
  Size size,
  void Function(BuildContext) open,
) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildDarkTheme(),
        home: Scaffold(
          body: Builder(
            builder: (BuildContext ctx) => Center(
              child: ElevatedButton(
                onPressed: () => open(ctx),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
  });

  tearDown(() => container.dispose());

  testWidgets('字體·排版 sheet golden 390x844', (WidgetTester tester) async {
    await _pumpSheet(
      tester,
      container,
      const Size(390, 844),
      showReaderFontSheet,
    );
    await expectLater(
      find.byType(BottomSheet),
      matchesGoldenFile('goldens/reader_font_sheet_390x844.png'),
    );
  });

  testWidgets('字體·排版 sheet golden 360x640', (WidgetTester tester) async {
    await _pumpSheet(
      tester,
      container,
      const Size(360, 640),
      showReaderFontSheet,
    );
    await expectLater(
      find.byType(BottomSheet),
      matchesGoldenFile('goldens/reader_font_sheet_360x640.png'),
    );
  });

  testWidgets('主題·顯示 sheet golden 390x844', (WidgetTester tester) async {
    await _pumpSheet(
      tester,
      container,
      const Size(390, 844),
      showReaderThemeSheet,
    );
    await expectLater(
      find.byType(BottomSheet),
      matchesGoldenFile('goldens/reader_theme_sheet_390x844.png'),
    );
  });

  testWidgets('主題·顯示 sheet golden 360x640', (WidgetTester tester) async {
    await _pumpSheet(
      tester,
      container,
      const Size(360, 640),
      showReaderThemeSheet,
    );
    await expectLater(
      find.byType(BottomSheet),
      matchesGoldenFile('goldens/reader_theme_sheet_360x640.png'),
    );
  });
}
