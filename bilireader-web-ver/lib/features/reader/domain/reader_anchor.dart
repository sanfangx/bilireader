import 'package:freezed_annotation/freezed_annotation.dart';

part 'reader_anchor.freezed.dart';
part 'reader_anchor.g.dart';

/// 跨模式穩定的閱讀位置錨點。不得只用 scroll pixel / page index（會因字級、行距、
/// 螢幕尺寸、圖片高度、模式切換、重分頁而失效）；以文字偏移與 textQuote 做跨模式定位。
///
/// 忠實移植自 api-ver。web-ver 註記：sourceTextOffset 因內容來自 WebView 逐 `<p>`
/// innerHTML、無整章連續 source，退化為「章內可見文字偏移」（≈ visibleTextOffset）。
@freezed
abstract class ReaderAnchor with _$ReaderAnchor {
  const factory ReaderAnchor({
    required int articleId,
    required int chapterId,
    required String chapterName,

    /// 章內字元偏移（供垂直與分頁模式互相定位）。
    required int sourceTextOffset,

    /// 去除 HTML tag / ruby 注音等不可見內容後的可見文字偏移。
    @Default(0) int visibleTextOffset,

    /// 目前所在 block 序號與型別。
    @Default(0) int blockIndex,
    @Default('text') String blockType,

    /// 錨點落在圖片 block 時的圖片序號與 URL。
    int? imageIndex,
    String? imageUrl,

    /// 錨點附近可見字，供章節更新造成 offset 漂移時近似搜尋修復。
    @Default('') String textQuote,

    /// 章內百分比 0.0-1.0（顯示 / fallback）。
    @Default(0.0) double progressInChapter,

    @Default(0) int createdAt,
    @Default(0) int updatedAt,
  }) = _ReaderAnchor;

  factory ReaderAnchor.fromJson(Map<String, dynamic> json) =>
      _$ReaderAnchorFromJson(json);
}
