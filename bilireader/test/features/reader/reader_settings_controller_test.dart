import 'package:bilireader/core/di/infra_providers.dart';
import 'package:bilireader/features/reader/domain/reader_settings.dart';
import 'package:bilireader/features/reader/domain/reader_theme.dart';
import 'package:bilireader/features/reader/presentation/reader_settings_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ProviderContainer> makeContainer() async {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // overrides 型別交由推斷（Riverpod 3 的 Override 為內部密封型別）。
  return ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('ReaderSettingsController：mutators 更新 state', () async {
    final ProviderContainer c = await makeContainer();
    addTearDown(c.dispose);
    final ReaderSettingsController ctl = c.read(
      readerSettingsControllerProvider.notifier,
    );

    expect(c.read(readerSettingsControllerProvider).fontSize, 20);
    ctl.setFontSize(28);
    ctl.setConvertMode(ReaderConvertMode.traditional);
    ctl.setScrollMode(ReaderScrollMode.pageCurl);
    ctl.setIllustrationSpoiler(false);

    final ReaderSettings s = c.read(readerSettingsControllerProvider);
    expect(s.fontSize, 28);
    expect(s.convertMode, ReaderConvertMode.traditional);
    expect(s.scrollMode, ReaderScrollMode.pageCurl);
    expect(s.illustrationSpoiler, isFalse);
  });

  test('setFontSize 夾制範圍', () async {
    final ProviderContainer c = await makeContainer();
    addTearDown(c.dispose);
    final ReaderSettingsController ctl = c.read(
      readerSettingsControllerProvider.notifier,
    );
    ctl.setFontSize(999);
    expect(c.read(readerSettingsControllerProvider).fontSize, 40);
    ctl.setFontSize(1);
    expect(c.read(readerSettingsControllerProvider).fontSize, 16);
  });

  test('ReaderThemeController：applyTheme / 自訂上限 5 / 刪除重置 active', () async {
    final ProviderContainer c = await makeContainer();
    addTearDown(c.dispose);
    final ReaderThemeController ctl = c.read(
      readerThemeControllerProvider.notifier,
    );

    // 預設護眼。
    expect(c.read(readerThemeControllerProvider).active.id, 'builtin_eye');

    ctl.applyTheme(kBuiltInReaderThemes[1]); // 夜間
    expect(c.read(readerThemeControllerProvider).active.id, 'builtin_night');

    // 新增 5 個成功、第 6 個失敗。
    for (int i = 0; i < 5; i++) {
      final bool ok = ctl.addCustomTheme(
        ReaderTheme(
          id: 'c$i',
          name: 'n$i',
          builtIn: false,
          textColor: 0xFF000000,
          bgColor: 0xFFFFFFFF,
        ),
      );
      expect(ok, isTrue);
    }
    final bool sixth = ctl.addCustomTheme(
      const ReaderTheme(
        id: 'c5',
        name: 'n5',
        builtIn: false,
        textColor: 0xFF000000,
        bgColor: 0xFFFFFFFF,
      ),
    );
    expect(sixth, isFalse);
    expect(c.read(readerThemeControllerProvider).custom.length, 5);

    // 目前 active 為最後新增的 c4；刪除它 → active 重置為預設護眼。
    expect(c.read(readerThemeControllerProvider).active.id, 'c4');
    ctl.deleteCustomTheme('c4');
    expect(c.read(readerThemeControllerProvider).active.id, 'builtin_eye');
    expect(c.read(readerThemeControllerProvider).custom.length, 4);
  });
}
