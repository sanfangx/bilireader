import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter_comment_dtos.freezed.dart';
part 'chapter_comment_dtos.g.dart';

/// 章節評論 DTO。**欄位以反編譯 `ChapterCommentItem`（`com.linovelib.bilinovel.NovelRead`
/// Gson @SerializedName）為準**——與 `BookReplyItem` 並非同一模型（資料模型.md §144 僅列
/// 「常見欄位」含 posttext/content 兩式，不可據以推斷；前一版誤對齊 BookReplyItem 之
/// `poster/posttext/posterLevel/posttime` → 姓名/內容/等級/時間全空白，avatar/讚踩/熱門
/// 因欄位同名而僅剩這些能顯示）。章評用 `cmt` 前綴：`cmtid/cmtcontent/cmtname/cmtLevel`；
/// 時間為 **`addtime`（字串，可為 epoch 秒/毫秒或日期）**；另有 `id`（long 主鍵，**按讚/刪除
/// 的 commentId 用此，非 cmtid**，對齊原 App `getId()`）、`parentid`（long 樓層）、`userid`、
/// `catid`、`ischeck`。共用欄位 `avatar/avatarUrl/likeNum/badNum/myReaction/ishot/ispoiler`。
///
/// **寬鬆型別（重要）**：原生 App 用 Gson，對 `String`/數字欄位雙向寬鬆轉型；Dart
/// `json_serializable` 為嚴格轉型（`as int` 遇字串、`as String?` 遇數字即拋 → 整筆 list
/// 解析失敗、面板顯示「載入失敗」）。**實測真實回應**（ADB logcat 型別診斷）：`catid`、`cmtid`
/// 以「**字串**」回傳（如 "12"），其餘數值欄位為 int，`addtime` 為字串。故所有純量欄位一律經
/// [_looseStr]/[_looseInt]/[_looseIntN] 寬鬆轉換，忠實對齊來源 API 的 Gson 契約（不假設型別）。
@freezed
abstract class ChapterCommentItemDto with _$ChapterCommentItemDto {
  const factory ChapterCommentItemDto({
    @JsonKey(fromJson: _looseInt)
    @Default(0)
    int id, // 主鍵（like/delete 的 commentId）
    @JsonKey(fromJson: _looseInt) @Default(0) int catid,
    @JsonKey(fromJson: _looseInt) @Default(0) int cmtid, // 章評序號（非 like 用）
    @JsonKey(fromJson: _looseInt) @Default(0) int userid,
    @JsonKey(fromJson: _looseStr) String? cmtname, // 暱稱
    @JsonKey(fromJson: _looseStr) String? cmtcontent, // 內容
    @JsonKey(fromJson: _looseStr) String? addtime, // 時間（epoch 秒/毫秒或日期，可為數字）
    @JsonKey(fromJson: _looseInt) @Default(0) int likeNum,
    @JsonKey(fromJson: _looseInt) @Default(0) int badNum,
    @JsonKey(fromJson: _looseInt) @Default(0) int myReaction,
    @JsonKey(fromJson: _looseInt) @Default(0) int ischeck,
    @JsonKey(fromJson: _looseInt) @Default(0) int ishot,
    @JsonKey(fromJson: _looseInt) @Default(0) int ispoiler,
    @JsonKey(fromJson: _looseInt) @Default(0) int parentid,
    @JsonKey(fromJson: _looseIntN) int? avatar,
    @JsonKey(fromJson: _looseStr) String? avatarUrl,
    @JsonKey(fromJson: _looseStr) String? cmtLevel,
  }) = _ChapterCommentItemDto;

  factory ChapterCommentItemDto.fromJson(Map<String, dynamic> json) =>
      _$ChapterCommentItemDtoFromJson(json);
}

/// 任意純量 → String?（Gson 對 String 欄位的寬鬆行為；數字/布林亦轉字串）。null/空 → null。
String? _looseStr(Object? v) {
  if (v == null) return null;
  final String s = v is String ? v : '$v';
  return s.isEmpty ? null : s;
}

/// 任意純量 → int（數字截尾；字串試解析；否則 0）。
int _looseInt(Object? v) =>
    v is num ? v.toInt() : (v is String ? int.tryParse(v.trim()) ?? 0 : 0);

/// 任意純量 → int?（同 [_looseInt]，但保留 null）。
int? _looseIntN(Object? v) => v == null ? null : _looseInt(v);

/// 章評分頁（`ChapterCommentListData = PageData<ChapterCommentItem>`）。
@freezed
abstract class ChapterCommentListDataDto with _$ChapterCommentListDataDto {
  const factory ChapterCommentListDataDto({
    @Default(<ChapterCommentItemDto>[]) List<ChapterCommentItemDto> list,
    @Default(1) int pageNum,
    @Default(20) int pageSize,
    @Default(1) int pages,
    @Default(0) int total,
  }) = _ChapterCommentListDataDto;

  factory ChapterCommentListDataDto.fromJson(Map<String, dynamic> json) =>
      _$ChapterCommentListDataDtoFromJson(json);
}

/// 章評反應結果 DTO（`chapter_comment/like`，{likeNum,badNum,myReaction}）。
@freezed
abstract class ChapterCommentReactionDto with _$ChapterCommentReactionDto {
  const factory ChapterCommentReactionDto({
    @Default(0) int likeNum,
    @Default(0) int badNum,
    @Default(0) int myReaction,
  }) = _ChapterCommentReactionDto;

  factory ChapterCommentReactionDto.fromJson(Map<String, dynamic> json) =>
      _$ChapterCommentReactionDtoFromJson(json);
}
