import 'package:flutter/foundation.dart';

/// 背景類型（`background_type`）。
enum ReaderBgType {
  color('color'),
  image('image');

  const ReaderBgType(this.wire);
  final String wire;

  static ReaderBgType fromWire(String? s) =>
      s == 'image' ? ReaderBgType.image : ReaderBgType.color;
}

/// 閱讀主題（doc 05 §9；設計「主題·顯示」頁）。**主題只負責顏色/背景，不覆寫字級/行距**
/// （字級行距走 [ReaderSettings]）。顏色以 ARGB int 保存（渲染層轉 `Color`）。
@immutable
class ReaderTheme {
  const ReaderTheme({
    required this.id,
    required this.name,
    required this.builtIn,
    required this.textColor,
    required this.bgColor,
    this.bgType = ReaderBgType.color,
    this.bgImagePath,
    this.imageMaskAlpha = 0,
  });

  factory ReaderTheme.fromJson(Map<String, Object?> j) => ReaderTheme(
    id: (j['id'] as String?) ?? '',
    name: (j['name'] as String?) ?? '',
    builtIn: false, // 自訂主題永為 false
    textColor: (j['textColor'] as num?)?.toInt() ?? 0xFFECE3D4,
    bgColor: (j['bgColor'] as num?)?.toInt() ?? 0xFF15110D,
    bgType: ReaderBgType.fromWire(j['bgType'] as String?),
    bgImagePath: j['bgImagePath'] as String?,
    imageMaskAlpha: (j['imageMaskAlpha'] as num?)?.toInt() ?? 0,
  );

  final String id;
  final String name;
  final bool builtIn;
  final int textColor; // font_color（ARGB）
  final int bgColor; // background_color（ARGB）
  final ReaderBgType bgType;
  final String? bgImagePath; // background_image_path
  final int imageMaskAlpha; // background_image_mask_alpha 0–255

  ReaderTheme copyWith({
    String? id,
    String? name,
    bool? builtIn,
    int? textColor,
    int? bgColor,
    ReaderBgType? bgType,
    String? bgImagePath,
    int? imageMaskAlpha,
  }) => ReaderTheme(
    id: id ?? this.id,
    name: name ?? this.name,
    builtIn: builtIn ?? this.builtIn,
    textColor: textColor ?? this.textColor,
    bgColor: bgColor ?? this.bgColor,
    bgType: bgType ?? this.bgType,
    bgImagePath: bgImagePath ?? this.bgImagePath,
    imageMaskAlpha: imageMaskAlpha ?? this.imageMaskAlpha,
  );

  /// 供 `reader_custom_themes` 本機 JSON 持久化（自有格式；顏色存 int）。
  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'name': name,
    'textColor': textColor,
    'bgColor': bgColor,
    'bgType': bgType.wire,
    'bgImagePath': bgImagePath,
    'imageMaskAlpha': imageMaskAlpha,
  };

  @override
  bool operator ==(Object other) =>
      other is ReaderTheme &&
      other.id == id &&
      other.name == name &&
      other.builtIn == builtIn &&
      other.textColor == textColor &&
      other.bgColor == bgColor &&
      other.bgType == bgType &&
      other.bgImagePath == bgImagePath &&
      other.imageMaskAlpha == imageMaskAlpha;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    builtIn,
    textColor,
    bgColor,
    bgType,
    bgImagePath,
    imageMaskAlpha,
  );
}

/// 內建主題（doc 05 §9.2，真實色值）。順序＝設計「護眼/夜間/紙書/清爽」。
const List<ReaderTheme> kBuiltInReaderThemes = <ReaderTheme>[
  ReaderTheme(
    id: 'builtin_eye',
    name: '護眼',
    builtIn: true,
    textColor: 0xFF2F2A22,
    bgColor: 0xFFF5F5DC,
  ),
  ReaderTheme(
    id: 'builtin_night',
    name: '夜間',
    builtIn: true,
    textColor: 0xFFCCC6BC,
    bgColor: 0xFF121212,
  ),
  ReaderTheme(
    id: 'builtin_paper',
    name: '紙書',
    builtIn: true,
    textColor: 0xFF4B3826,
    bgColor: 0xFFF4ECD8,
  ),
  ReaderTheme(
    id: 'builtin_clear',
    name: '清爽',
    builtIn: true,
    textColor: 0xFF263238,
    bgColor: 0xFFEAF4F8,
  ),
];

/// 自訂主題上限（`MAX_CUSTOM_THEMES`）。
const int kMaxCustomReaderThemes = 5;

/// 預設主題（護眼）。
final ReaderTheme kDefaultReaderTheme = kBuiltInReaderThemes.first;

/// 主題狀態：目前套用的主題 + 使用者自訂清單（≤5）。
@immutable
class ReaderThemeState {
  const ReaderThemeState({
    required this.active,
    this.custom = const <ReaderTheme>[],
  });

  final ReaderTheme active;
  final List<ReaderTheme> custom;

  /// 內建 + 自訂（供選單/依 id 查找）。
  List<ReaderTheme> get all => <ReaderTheme>[
    ...kBuiltInReaderThemes,
    ...custom,
  ];

  bool get canAddCustom => custom.length < kMaxCustomReaderThemes;

  ReaderThemeState copyWith({ReaderTheme? active, List<ReaderTheme>? custom}) =>
      ReaderThemeState(
        active: active ?? this.active,
        custom: custom ?? this.custom,
      );

  @override
  bool operator ==(Object other) =>
      other is ReaderThemeState &&
      other.active == active &&
      listEquals(other.custom, custom);

  @override
  int get hashCode => Object.hash(active, Object.hashAll(custom));
}
