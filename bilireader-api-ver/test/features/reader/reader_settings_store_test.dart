import 'package:bilireader/features/reader/data/reader_settings_store.dart';
import 'package:bilireader/features/reader/domain/reader_settings.dart';
import 'package:bilireader/features/reader/domain/reader_theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ReaderSettingsStore> storeWith(Map<String, Object> seed) async {
  SharedPreferences.setMockInitialValues(seed);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return ReaderSettingsStore(prefs);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('loadSettings 預設值', () {
    test('無存值 → 預設', () async {
      final ReaderSettingsStore s = await storeWith(<String, Object>{});
      final ReaderSettings r = s.loadSettings();
      expect(r.fontFamily, ReaderFontFamily.serif); // 預設明體
      expect(r.fontSize, 20);
      expect(r.lineSpacingDp, 8);
      expect(r.paragraphSpacingDp, 8);
      expect(r.convertMode, ReaderConvertMode.traditionalTw);
      expect(r.illustrationSpoiler, isTrue);
      expect(r.chapterCommentEnabled, isTrue);
      expect(r.scrollMode, ReaderScrollMode.vertical);
      expect(r.tapCenterTogglesBars, isFalse); // 預設不縮
    });

    test('點擊中央切換工具列 round-trip：開 save → load', () async {
      final ReaderSettingsStore s = await storeWith(<String, Object>{});
      await s.saveSettings(const ReaderSettings(tapCenterTogglesBars: true));
      expect(s.loadSettings().tapCenterTogglesBars, isTrue);
    });

    test('字體家族 round-trip：黑體 save → load', () async {
      final ReaderSettingsStore s = await storeWith(<String, Object>{});
      await s.saveSettings(
        const ReaderSettings(fontFamily: ReaderFontFamily.sans),
      );
      expect(s.loadSettings().fontFamily, ReaderFontFamily.sans);
    });

    test('字體家族 round-trip：圓體 save → load（RoundedTC）', () async {
      final ReaderSettingsStore s = await storeWith(<String, Object>{});
      await s.saveSettings(
        const ReaderSettings(fontFamily: ReaderFontFamily.rounded),
      );
      final ReaderFontFamily f = s.loadSettings().fontFamily;
      expect(f, ReaderFontFamily.rounded);
      expect(f.family, 'RoundedTC');
    });
  });

  group('§5.0：chinese_convert_mode 只認 t/tw，s→tw', () {
    test("'s' → tw（不得簡體顯示）", () async {
      final ReaderSettingsStore s = await storeWith(<String, Object>{
        'chinese_convert_mode': 's',
      });
      expect(s.loadSettings().convertMode, ReaderConvertMode.traditionalTw);
    });
    test("'t' → traditional；'tw' → traditionalTw", () async {
      expect(
        (await storeWith(<String, Object>{
          'chinese_convert_mode': 't',
        })).loadSettings().convertMode,
        ReaderConvertMode.traditional,
      );
      expect(
        (await storeWith(<String, Object>{
          'chinese_convert_mode': 'tw',
        })).loadSettings().convertMode,
        ReaderConvertMode.traditionalTw,
      );
    });
    test('saveSettings 只寫 t/tw 字串', () async {
      final ReaderSettingsStore s = await storeWith(<String, Object>{});
      await s.saveSettings(
        const ReaderSettings(convertMode: ReaderConvertMode.traditional),
      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('chinese_convert_mode'), 't');
    });
  });

  group('範圍夾制', () {
    test('超範圍值被夾到合法區間', () async {
      final ReaderSettingsStore s = await storeWith(<String, Object>{
        'font_size': 999.0,
        'reader_line_spacing_extra_dp': 99,
        'reader_paragraph_spacing_dp': 1,
      });
      final ReaderSettings r = s.loadSettings();
      expect(r.fontSize, 40); // kMaxFontSize
      expect(r.lineSpacingDp, 28); // kMaxSpacingDp
      expect(r.paragraphSpacingDp, 4); // kMinSpacingDp
    });
  });

  group('scrollMode wire', () {
    test('page_curl / horizontal / 未知', () async {
      expect(
        (await storeWith(<String, Object>{
          'reader_scroll_mode': 'page_curl',
        })).loadSettings().scrollMode,
        ReaderScrollMode.pageCurl,
      );
      expect(
        (await storeWith(<String, Object>{
          'reader_scroll_mode': 'horizontal',
        })).loadSettings().scrollMode,
        ReaderScrollMode.horizontal,
      );
      expect(
        (await storeWith(<String, Object>{
          'reader_scroll_mode': 'zzz',
        })).loadSettings().scrollMode,
        ReaderScrollMode.vertical,
      );
    });
  });

  group('settings round-trip', () {
    test('save → load 相等', () async {
      final ReaderSettingsStore s = await storeWith(<String, Object>{});
      const ReaderSettings custom = ReaderSettings(
        fontSize: 24,
        lineSpacingDp: 12,
        paragraphSpacingDp: 16,
        convertMode: ReaderConvertMode.traditional,
        illustrationSpoiler: false,
        chapterCommentEnabled: false,
        scrollMode: ReaderScrollMode.pageCurl,
      );
      await s.saveSettings(custom);
      expect(s.loadSettings(), custom);
    });
  });

  group('F-33 亮度遮罩 dimLevel', () {
    test('預設 0（不降亮）', () async {
      final ReaderSettingsStore s = await storeWith(<String, Object>{});
      expect(s.loadSettings().dimLevel, 0);
    });

    test('round-trip：save → load', () async {
      final ReaderSettingsStore s = await storeWith(<String, Object>{});
      await s.saveSettings(const ReaderSettings(dimLevel: 0.4));
      expect(s.loadSettings().dimLevel, 0.4);
    });

    test('超上限 / 負值被夾到 [0, kMaxDim]', () async {
      expect(
        (await storeWith(<String, Object>{
          'reader_dim_level': 0.99,
        })).loadSettings().dimLevel,
        ReaderSettings.kMaxDim,
      );
      expect(
        (await storeWith(<String, Object>{
          'reader_dim_level': -0.5,
        })).loadSettings().dimLevel,
        0,
      );
    });
  });

  group('主題', () {
    test('loadThemeState：active id 解析；未知 → 預設護眼', () async {
      final ReaderThemeState night = (await storeWith(<String, Object>{
        'reader_active_theme_id': 'builtin_night',
      })).loadThemeState();
      expect(night.active.id, 'builtin_night');
      expect(night.active.bgColor, 0xFF121212);

      final ReaderThemeState def = (await storeWith(<String, Object>{
        'reader_active_theme_id': 'nope',
      })).loadThemeState();
      expect(def.active.id, 'builtin_eye'); // 預設護眼
    });

    test('自訂主題 JSON round-trip + builtIn 強制 false', () async {
      final ReaderSettingsStore s = await storeWith(<String, Object>{});
      const ReaderTheme t = ReaderTheme(
        id: 'c1',
        name: '午夜',
        builtIn: true, // 應被強制 false
        textColor: 0xFFC6C9E0,
        bgColor: 0xFF161A2E,
      );
      await s.saveCustomThemes(<ReaderTheme>[t]);
      final List<ReaderTheme> loaded = s.loadCustomThemes();
      expect(loaded.length, 1);
      expect(loaded.single.id, 'c1');
      expect(loaded.single.name, '午夜');
      expect(loaded.single.builtIn, isFalse);
      expect(loaded.single.bgColor, 0xFF161A2E);
    });

    test('自訂主題超過 5 → 截斷', () async {
      final ReaderSettingsStore s = await storeWith(<String, Object>{});
      final List<ReaderTheme> many = List<ReaderTheme>.generate(
        8,
        (int i) => ReaderTheme(
          id: 'c$i',
          name: 'n$i',
          builtIn: false,
          textColor: 0xFF000000,
          bgColor: 0xFFFFFFFF,
        ),
      );
      await s.saveCustomThemes(many);
      expect(s.loadCustomThemes().length, kMaxCustomReaderThemes);
    });

    test(
      'saveActiveTheme 鏡射 §9.3 鍵（font_color / background_color hex）',
      () async {
        final ReaderSettingsStore s = await storeWith(<String, Object>{});
        await s.saveActiveTheme(kBuiltInReaderThemes[1]); // 夜間
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        expect(prefs.getString('reader_active_theme_id'), 'builtin_night');
        expect(prefs.getInt('font_color'), 0xFFCCC6BC);
        expect(prefs.getString('background_color'), '#121212');
      },
    );
  });
}
