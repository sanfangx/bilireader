import 'package:bilireader/core/di/infra_providers.dart';
import 'package:bilireader/features/reader/domain/reader_settings.dart';
import 'package:bilireader/features/reader/presentation/panels/reader_settings_sheets.dart';
import 'package:bilireader/features/reader/presentation/reader_settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> pumpWithButton(
    WidgetTester tester,
    void Function(BuildContext) open,
  ) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
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

  group('字體·排版 sheet', () {
    testWidgets('§5.0：簡繁轉換只列 繁體/台灣正體，不得有「簡體」', (WidgetTester tester) async {
      await pumpWithButton(tester, showReaderFontSheet);
      expect(find.text('字體 · 排版'), findsOneWidget);
      expect(find.text('字體'), findsOneWidget); // 字體家族列
      expect(find.text('明體'), findsOneWidget);
      expect(find.text('黑體'), findsOneWidget);
      expect(find.text('圓體'), findsOneWidget);
      expect(find.text('字號'), findsOneWidget);
      expect(find.text('行距'), findsOneWidget);
      expect(find.text('段距'), findsOneWidget);
      expect(find.text('繁體'), findsOneWidget);
      expect(find.text('台灣正體'), findsOneWidget);
      // 鐵律：§5.0 line 265 不得提供簡體顯示選項（設計第三欄「簡體」移除）。
      expect(find.text('簡體'), findsNothing);
    });

    testWidgets('點「黑體」→ fontFamily 變 sans（NotoSansTC）', (
      WidgetTester tester,
    ) async {
      await pumpWithButton(tester, showReaderFontSheet);
      await tester.tap(find.text('黑體'));
      await tester.pump();
      final ReaderFontFamily f = container
          .read(readerSettingsControllerProvider)
          .fontFamily;
      expect(f, ReaderFontFamily.sans);
      expect(f.family, 'NotoSansTC');
    });

    testWidgets('點「繁體」→ convertMode 變 traditional', (
      WidgetTester tester,
    ) async {
      await pumpWithButton(tester, showReaderFontSheet);
      // 加了字體列後 sheet 變高、簡繁列可能在可捲區下方，先捲入視野。
      await tester.ensureVisible(find.text('繁體'));
      await tester.tap(find.text('繁體'));
      await tester.pump();
      expect(
        container.read(readerSettingsControllerProvider).convertMode,
        ReaderConvertMode.traditional,
      );
    });
  });

  group('主題·顯示 sheet', () {
    testWidgets('4 內建主題 + 翻頁三模式 + 三開關', (WidgetTester tester) async {
      await pumpWithButton(tester, showReaderThemeSheet);
      expect(find.text('主題 · 顯示'), findsOneWidget);
      for (final String name in <String>['護眼', '夜間', '紙書', '清爽']) {
        expect(find.text(name), findsOneWidget);
      }
      for (final String m in <String>['捲動', '翻頁', '仿真捲頁']) {
        expect(find.text(m), findsOneWidget);
      }
      expect(find.text('防劇透插圖'), findsOneWidget);
      expect(find.text('章末章評入口'), findsOneWidget);
      expect(find.text('點擊隱藏工具列'), findsOneWidget); // 使用者要求：可選沉浸式收合
    });

    testWidgets('點「點擊隱藏工具列」開關 → tapCenterTogglesBars 由 false 變 true', (
      WidgetTester tester,
    ) async {
      await pumpWithButton(tester, showReaderThemeSheet);
      expect(
        container.read(readerSettingsControllerProvider).tapCenterTogglesBars,
        isFalse, // 預設不縮
      );
      // 該列為 sheet 末列，可能在可捲區下方，先捲入視野。
      await tester.ensureVisible(find.text('點擊隱藏工具列'));
      final Finder row = find
          .ancestor(of: find.text('點擊隱藏工具列'), matching: find.byType(Row))
          .first;
      await tester.tap(
        find.descendant(of: row, matching: find.byType(GestureDetector)).last,
      );
      await tester.pump();
      expect(
        container.read(readerSettingsControllerProvider).tapCenterTogglesBars,
        isTrue,
      );
    });

    testWidgets('點「翻頁」→ scrollMode 變 horizontal', (WidgetTester tester) async {
      await pumpWithButton(tester, showReaderThemeSheet);
      // 亮度滑桿（F-33）加入後，翻頁列位置下移，先捲入視野再點（比照隱藏工具列測試）。
      await tester.ensureVisible(find.text('翻頁'));
      await tester.tap(find.text('翻頁'));
      await tester.pump();
      expect(
        container.read(readerSettingsControllerProvider).scrollMode,
        ReaderScrollMode.horizontal,
      );
    });

    testWidgets('點「紙書」→ 主題套用', (WidgetTester tester) async {
      await pumpWithButton(tester, showReaderThemeSheet);
      await tester.tap(find.text('紙書'));
      await tester.pump();
      expect(container.read(readerThemeControllerProvider).active.name, '紙書');
    });
  });
}
