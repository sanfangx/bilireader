import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/reader_settings.dart';
import '../domain/reader_theme.dart';

/// 閱讀器設定的本機持久化（SharedPreferences「settings」；doc 05 §12 鍵名對齊，便於日後遷移）。
/// 純資料存取（無 Riverpod）以利測試。
///
/// §5.0：`chinese_convert_mode` 只寫 `t`/`tw`（[ReaderConvertMode.wire]），**永不寫 `s`**。
class ReaderSettingsStore {
  const ReaderSettingsStore(this._prefs);

  final SharedPreferences _prefs;

  // 字體·排版 + 行為（§8、§12）
  static const String kFontFamily = 'reader_font_family'; // serif/sans（本機新增設定）
  static const String kFontSize = 'font_size';
  static const String kLineSpacingDp = 'reader_line_spacing_extra_dp';
  static const String kParagraphSpacingDp = 'reader_paragraph_spacing_dp';
  static const String kConvertMode = 'chinese_convert_mode';
  static const String kIllustrationSpoiler = 'illustration_spoiler';
  static const String kChapterCommentEnabled = 'chapter_comment_enabled';
  static const String kScrollMode = 'reader_scroll_mode';
  // 輕觸中央收合工具列（本機新增設定；預設 false＝不縮）
  static const String kTapCenterTogglesBars = 'reader_tap_center_toggles_bars';
  // 螢幕遮罩降亮強度（本機新增設定；F-33，預設 0＝不降亮）
  static const String kReaderDim = 'reader_dim_level';
  // 主題·顯示（§9.3、§12）
  static const String kActiveThemeId = 'reader_active_theme_id';
  static const String kCustomThemes = 'reader_custom_themes';
  static const String kFontColor = 'font_color';
  static const String kBackgroundType = 'background_type';
  static const String kBackgroundColor = 'background_color';
  static const String kBackgroundImagePath = 'background_image_path';
  static const String kBackgroundImageMaskAlpha = 'background_image_mask_alpha';
  static const String kReaderCustomized = 'reader_customized';

  // ---- 字體·排版 + 行為 ----

  ReaderSettings loadSettings() => ReaderSettings(
    fontFamily: ReaderFontFamily.fromWire(_prefs.getString(kFontFamily)),
    fontSize: (_prefs.getDouble(kFontSize) ?? ReaderSettings.kDefaultFontSize)
        .clamp(ReaderSettings.kMinFontSize, ReaderSettings.kMaxFontSize),
    lineSpacingDp:
        (_prefs.getInt(kLineSpacingDp) ?? ReaderSettings.kDefaultLineSpacingDp)
            .clamp(ReaderSettings.kMinSpacingDp, ReaderSettings.kMaxSpacingDp),
    paragraphSpacingDp:
        (_prefs.getInt(kParagraphSpacingDp) ??
                ReaderSettings.kDefaultParagraphSpacingDp)
            .clamp(ReaderSettings.kMinSpacingDp, ReaderSettings.kMaxSpacingDp),
    convertMode: ReaderConvertMode.fromWire(_prefs.getString(kConvertMode)),
    illustrationSpoiler: _prefs.getBool(kIllustrationSpoiler) ?? true,
    chapterCommentEnabled: _prefs.getBool(kChapterCommentEnabled) ?? true,
    scrollMode: ReaderScrollMode.fromWire(_prefs.getString(kScrollMode)),
    tapCenterTogglesBars: _prefs.getBool(kTapCenterTogglesBars) ?? false,
    dimLevel: (_prefs.getDouble(kReaderDim) ?? ReaderSettings.kDefaultDim)
        .clamp(0.0, ReaderSettings.kMaxDim),
  );

  Future<void> saveSettings(ReaderSettings s) async {
    await _prefs.setString(kFontFamily, s.fontFamily.wire);
    await _prefs.setDouble(kFontSize, s.fontSize);
    await _prefs.setInt(kLineSpacingDp, s.lineSpacingDp);
    await _prefs.setInt(kParagraphSpacingDp, s.paragraphSpacingDp);
    await _prefs.setString(kConvertMode, s.convertMode.wire); // 只 t/tw
    await _prefs.setBool(kIllustrationSpoiler, s.illustrationSpoiler);
    await _prefs.setBool(kChapterCommentEnabled, s.chapterCommentEnabled);
    await _prefs.setString(kScrollMode, s.scrollMode.wire);
    await _prefs.setBool(kTapCenterTogglesBars, s.tapCenterTogglesBars);
    await _prefs.setDouble(kReaderDim, s.dimLevel);
  }

  // ---- 主題·顯示 ----

  List<ReaderTheme> loadCustomThemes() {
    final String? raw = _prefs.getString(kCustomThemes);
    if (raw == null || raw.isEmpty) return const <ReaderTheme>[];
    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! List) return const <ReaderTheme>[];
      return decoded
          .whereType<Map<String, Object?>>()
          .map(ReaderTheme.fromJson)
          .take(kMaxCustomReaderThemes)
          .toList();
    } on Object {
      return const <ReaderTheme>[];
    }
  }

  ReaderThemeState loadThemeState() {
    final List<ReaderTheme> custom = loadCustomThemes();
    final String? activeId = _prefs.getString(kActiveThemeId);
    final ReaderTheme active = <ReaderTheme>[...kBuiltInReaderThemes, ...custom]
        .firstWhere(
          (ReaderTheme t) => t.id == activeId,
          orElse: () => kDefaultReaderTheme,
        );
    return ReaderThemeState(active: active, custom: custom);
  }

  Future<void> saveCustomThemes(List<ReaderTheme> themes) async {
    await _prefs.setString(
      kCustomThemes,
      jsonEncode(themes.map((ReaderTheme t) => t.toJson()).toList()),
    );
  }

  /// 保存目前套用主題：id 為 source of truth；同時鏡射色值到 §9.3 鍵（write-only，供 §12 對齊）。
  Future<void> saveActiveTheme(ReaderTheme t) async {
    await _prefs.setString(kActiveThemeId, t.id);
    await _prefs.setInt(kFontColor, t.textColor);
    await _prefs.setString(kBackgroundType, t.bgType.wire);
    await _prefs.setString(kBackgroundColor, _toHex(t.bgColor));
    await _prefs.setInt(kBackgroundImageMaskAlpha, t.imageMaskAlpha);
    if (t.bgImagePath != null) {
      await _prefs.setString(kBackgroundImagePath, t.bgImagePath!);
    } else {
      await _prefs.remove(kBackgroundImagePath);
    }
    if (!t.builtIn) await _prefs.setBool(kReaderCustomized, true);
  }

  static String _toHex(int argb) =>
      '#${(argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
}
