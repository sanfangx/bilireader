import 'package:flutter/foundation.dart';

/// 翻頁/捲動模式（`reader_scroll_mode`）。設計「翻頁方式：捲動 / 翻頁 / 仿真捲頁」。
enum ReaderScrollMode {
  vertical('vertical'),
  horizontal('horizontal'),
  pageCurl('page_curl');

  const ReaderScrollMode(this.wire);
  final String wire;

  static ReaderScrollMode fromWire(String? s) => switch (s) {
    'horizontal' => ReaderScrollMode.horizontal,
    'page_curl' => ReaderScrollMode.pageCurl,
    _ => ReaderScrollMode.vertical,
  };
}

/// 簡繁轉換顯示模式。忠實保留自 api-ver（§5.0 只允許繁體變體：`t` 繁體、`tw` 台灣正體）。
///
/// **web-ver 註記**：tw.linovelib 內容本即繁體，OpenCC **不套用**（builder 的 convert=identity）；
/// 此設定於 web 端為**惰性保留**（不驅動任何轉換），設定面板可略過此項。
enum ReaderConvertMode {
  traditional('t'),
  traditionalTw('tw');

  const ReaderConvertMode(this.wire);
  final String wire;

  static ReaderConvertMode fromWire(String? s) => switch (s) {
    't' => ReaderConvertMode.traditional,
    _ => ReaderConvertMode.traditionalTw, // 'tw' / 's' / null → tw
  };
}

/// 閱讀器正文字體家族。明體（NotoSerifTC，襯線）/ 黑體（NotoSansTC，無襯線）/
/// 圓體（RoundedTC，bundled asset，對齊 api-ver）。
/// web-ver 明體/黑體走 google_fonts 動態載入；圓體無 Google Fonts 對應 → bundle ttf。
enum ReaderFontFamily {
  serif('serif', '明體', 'NotoSerifTC'),
  sans('sans', '黑體', 'NotoSansTC'),
  rounded('rounded', '圓體', 'RoundedTC');

  const ReaderFontFamily(this.wire, this.label, this.family);
  final String wire;
  final String label;
  final String family;

  static ReaderFontFamily fromWire(String? s) => switch (s) {
    'sans' => ReaderFontFamily.sans,
    'rounded' => ReaderFontFamily.rounded,
    _ => ReaderFontFamily.serif, // 'serif' / 未知 → 明體（預設）
  };
}

/// 閱讀器「字體·排版 + 行為」設定（存本機 SharedPreferences）。忠實移植自 api-ver。
/// 主題/顏色/背景另見 [ReaderTheme]（「主題·顯示」頁）。
@immutable
class ReaderSettings {
  const ReaderSettings({
    this.fontFamily = ReaderFontFamily.serif,
    this.fontSize = kDefaultFontSize,
    this.lineSpacingDp = kDefaultLineSpacingDp,
    this.paragraphSpacingDp = kDefaultParagraphSpacingDp,
    this.convertMode = ReaderConvertMode.traditionalTw,
    this.illustrationSpoiler = true,
    this.chapterCommentEnabled = true,
    this.scrollMode = ReaderScrollMode.vertical,
    this.tapCenterTogglesBars = false,
    this.dimLevel = kDefaultDim,
  });

  static const double kDefaultFontSize = 20; // font_size 預設 20sp
  static const double kMinFontSize = 16;
  static const double kMaxFontSize = 40;
  static const int kDefaultLineSpacingDp = 8;
  static const int kDefaultParagraphSpacingDp = 8;
  static const int kMinSpacingDp = 4;
  static const int kMaxSpacingDp = 28;

  // 亮度（螢幕遮罩）：正文上疊黑色遮罩之不透明度。0＝不降亮（最亮）；上限 0.7。
  static const double kDefaultDim = 0;
  static const double kMaxDim = 0.7;

  final ReaderFontFamily fontFamily;
  final double fontSize;
  final int lineSpacingDp;
  final int paragraphSpacingDp;
  final ReaderConvertMode convertMode;
  final bool illustrationSpoiler;
  final bool chapterCommentEnabled;
  final ReaderScrollMode scrollMode;

  /// 是否「輕觸畫面中央」切換上下工具列。**預設 false**（工具列常駐，避免誤觸收起）。
  final bool tapCenterTogglesBars;

  /// 螢幕遮罩降亮強度（0＝不降亮 ~ [kMaxDim]）。
  final double dimLevel;

  ReaderSettings copyWith({
    ReaderFontFamily? fontFamily,
    double? fontSize,
    int? lineSpacingDp,
    int? paragraphSpacingDp,
    ReaderConvertMode? convertMode,
    bool? illustrationSpoiler,
    bool? chapterCommentEnabled,
    ReaderScrollMode? scrollMode,
    bool? tapCenterTogglesBars,
    double? dimLevel,
  }) => ReaderSettings(
    fontFamily: fontFamily ?? this.fontFamily,
    fontSize: (fontSize ?? this.fontSize).clamp(kMinFontSize, kMaxFontSize),
    lineSpacingDp: (lineSpacingDp ?? this.lineSpacingDp).clamp(
      kMinSpacingDp,
      kMaxSpacingDp,
    ),
    paragraphSpacingDp: (paragraphSpacingDp ?? this.paragraphSpacingDp).clamp(
      kMinSpacingDp,
      kMaxSpacingDp,
    ),
    convertMode: convertMode ?? this.convertMode,
    illustrationSpoiler: illustrationSpoiler ?? this.illustrationSpoiler,
    chapterCommentEnabled: chapterCommentEnabled ?? this.chapterCommentEnabled,
    scrollMode: scrollMode ?? this.scrollMode,
    tapCenterTogglesBars: tapCenterTogglesBars ?? this.tapCenterTogglesBars,
    dimLevel: (dimLevel ?? this.dimLevel).clamp(0.0, kMaxDim),
  );

  @override
  bool operator ==(Object other) =>
      other is ReaderSettings &&
      other.fontFamily == fontFamily &&
      other.fontSize == fontSize &&
      other.lineSpacingDp == lineSpacingDp &&
      other.paragraphSpacingDp == paragraphSpacingDp &&
      other.convertMode == convertMode &&
      other.illustrationSpoiler == illustrationSpoiler &&
      other.chapterCommentEnabled == chapterCommentEnabled &&
      other.scrollMode == scrollMode &&
      other.tapCenterTogglesBars == tapCenterTogglesBars &&
      other.dimLevel == dimLevel;

  @override
  int get hashCode => Object.hash(
    fontFamily,
    fontSize,
    lineSpacingDp,
    paragraphSpacingDp,
    convertMode,
    illustrationSpoiler,
    chapterCommentEnabled,
    scrollMode,
    tapCenterTogglesBars,
    dimLevel,
  );
}
