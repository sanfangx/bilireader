import 'package:freezed_annotation/freezed_annotation.dart';

part 'reader_anchor.freezed.dart';
part 'reader_anchor.g.dart';

/// 跨模式穩定的閱讀位置錨點（規範 §5.5）。不得只用 scroll pixel / page index，
/// 這些值會因字級、行距、螢幕尺寸、橫豎屏、圖片高度、模式切換、繁體轉換與
/// 重分頁而失效；本錨點以文字偏移與 textQuote 做跨模式定位。純 Dart（§4.2）。
@freezed
abstract class ReaderAnchor with _$ReaderAnchor {
  const factory ReaderAnchor({
    required int articleId,
    required int chapterId,
    required String chapterName,

    /// 在「OpenCC 轉繁後、切段/解析前」章節 source 中的字元偏移；
    /// 用於垂直與分頁模式互相定位。
    required int sourceTextOffset,

    /// 去除 HTML tag、ruby 注音等不可見內容後的可見文字偏移，輔助對映。
    @Default(0) int visibleTextOffset,

    /// 目前所在 ReaderBlock 序號與型別；用於快速定位，不作唯一依據。
    @Default(0) int blockIndex,
    @Default('text') String blockType,

    /// 錨點落在圖片 block 時的圖片序號與 normalized URL。
    int? imageIndex,
    String? imageUrl,

    /// 錨點附近 20-40 個繁體可見字，供章節更新造成 offset 漂移時近似搜尋修復。
    @Default('') String textQuote,

    /// 章內百分比 0.0-1.0；作顯示與 fallback，不作精準定位唯一依據。
    @Default(0.0) double progressInChapter,

    /// 建立 / 更新的毫秒時間戳。
    @Default(0) int createdAt,
    @Default(0) int updatedAt,
  }) = _ReaderAnchor;

  factory ReaderAnchor.fromJson(Map<String, dynamic> json) =>
      _$ReaderAnchorFromJson(json);
}
