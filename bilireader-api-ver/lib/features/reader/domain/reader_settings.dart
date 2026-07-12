import 'package:flutter/foundation.dart';

/// 翻頁/捲動模式（`reader_scroll_mode`，doc 05 §10）。設計「翻頁方式：捲動 / 翻頁 / 仿真捲頁」。
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

/// 閱讀器「簡繁轉換」顯示模式。**只允許繁體變體**：`t` 繁體、`tw` 台灣正體。
///
/// §5.0（鐵律）：產品輸出只能是繁體，預設台灣繁體 `tw`；`s`（簡體）**不得**作為 UI/閱讀器
/// 顯示模式（設計雖列出「簡體」，但依 §5.0 移除）。故 [fromWire] 對 `s`/未知一律回 [traditionalTw]。
enum ReaderConvertMode {
  traditional('t'),
  traditionalTw('tw');

  const ReaderConvertMode(this.wire);
  final String wire;

  static ReaderConvertMode fromWire(String? s) => switch (s) {
    't' => ReaderConvertMode.traditional,
    _ => ReaderConvertMode.traditionalTw, // 'tw' / 's' / null → tw（§5.0）
  };
}

/// 閱讀器正文字體家族。提供 assets 內三款 CJK 字型：明體（NotoSerifTC，襯線）/
/// 黑體（NotoSansTC，無襯線）/ 圓體（RoundedTC，圓潤黑體，使用者提供之 iPhone 圓體）。
/// SpaceGrotesk 僅拉丁字母、不含 CJK，不列為正文選項。
/// family 值為 pubspec 宣告之字型家族名（與 [AppTypography] 一致；此處以字串內聯保 domain 純淨）。
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

/// 閱讀器「字體·排版 + 行為」設定（存本機 SharedPreferences，doc 05 §8、§12；設計「字體·排版」頁）。
/// 主題/顏色/背景另見 `ReaderTheme`（「主題·顯示」頁）。
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
  static const double kMinFontSize = 16; // §8 seekbar progress≥0 → ≥16
  static const double kMaxFontSize = 40; // 上限 doc 未載明，取 40
  static const int kDefaultLineSpacingDp = 8;
  static const int kDefaultParagraphSpacingDp = 8;
  static const int kMinSpacingDp = 4;
  static const int kMaxSpacingDp = 28;

  // F-33 亮度（螢幕遮罩）：正文上疊黑色遮罩之不透明度。0＝不降亮（最亮）；上限取 0.7
  // （再高則無法閱讀）。以 App 內遮罩實作、不動系統背光（零新依賴、離開閱讀器自然無殘留）。
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

  /// 是否「輕觸畫面中央」切換（收起/展開）上下工具列。**預設 false**（不縮，工具列常駐）——
  /// 使用者要求：沉浸式收合改為可選，避免誤觸收起。true 時恢復點擊中央切換行為（沉浸式）。
  final bool tapCenterTogglesBars;

  /// F-33：螢幕遮罩降亮強度（0＝不降亮 ~ [kMaxDim]）。
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
