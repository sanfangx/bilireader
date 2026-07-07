import 'package:freezed_annotation/freezed_annotation.dart';

part 'novel_response_entity.freezed.dart';
part 'novel_response_entity.g.dart';

/// 小說主物件 DTO（規範 §4.3，doc 10 §3.1 `NovelResponseEntity`）。
///
/// 榜單 / 搜尋 / 首頁清單 / 詳情**共用同一物件**（反編譯確認）。後端 key 全小寫，
/// Dart 端以駝峰 + `@JsonKey` 對映；數值欄位不可空（預設 0），字串欄位可空。
/// 平均評分後端只給 `ratesum`/`ratenum`，需自算；`fullflag` 0/1 完結；
/// `keywords` 常以逗號分隔標籤。
@freezed
abstract class NovelResponseEntity with _$NovelResponseEntity {
  const NovelResponseEntity._();

  const factory NovelResponseEntity({
    @JsonKey(name: 'articleid') @Default(0) int articleId,
    @JsonKey(name: 'articlename') String? articleName,
    String? author,
    @JsonKey(name: 'authorid') @Default(0) int authorId,
    String? translator,
    @JsonKey(name: 'translatorid') @Default(0) int translatorId,
    String? illustrator,
    String? cover,
    String? intro,
    String? keywords,
    // 實測 API（規範 §3 以實際行為為準）：`lastupdate` 為秒級時間戳（int），
    // 但 `lastupdates` 為格式化日期字串（例 '2026-06-21'）——兩者型別不同，勿混用。
    @JsonKey(name: 'lastupdate') int? lastUpdate,
    @JsonKey(name: 'lastupdates') String? lastUpdates,
    @JsonKey(name: 'lastvolume') String? lastVolume,
    @JsonKey(name: 'fullflag') @Default(0) int fullFlag,
    @Default(0) int anime,
    @Default(0) int original,
    @JsonKey(name: 'isvip') @Default(0) int isVip,
    @JsonKey(name: 'issign') @Default(0) int isSign,
    @JsonKey(name: 'rgroup') @Default(0) int rGroup,
    @Default(0) int progress,
    @Default(0) int words,
    @Default(0) int hot,
    @JsonKey(name: 'goodnum') @Default(0) int goodNum,
    @JsonKey(name: 'ratenum') @Default(0) int rateNum,
    @JsonKey(name: 'ratesum') @Default(0) int rateSum,
    @JsonKey(name: 'allvisit') @Default(0) int allVisit,
    @JsonKey(name: 'weekvisit') @Default(0) int weekVisit,
    @JsonKey(name: 'allflower') @Default(0) int allFlower,
    @JsonKey(name: 'allvote') @Default(0) int allVote,
    @JsonKey(name: 'dayvote') @Default(0) int dayVote,
    @JsonKey(name: 'weekvote') @Default(0) int weekVote,
    @JsonKey(name: 'monthvote') @Default(0) int monthVote,
  }) = _NovelResponseEntity;

  factory NovelResponseEntity.fromJson(Map<String, dynamic> json) =>
      _$NovelResponseEntityFromJson(json);

  /// 評分平均（後端只給 sum 與 num）。
  double get ratingAvg => rateNum == 0 ? 0 : rateSum / rateNum;

  bool get isFinished => fullFlag == 1;

  /// 標籤：`keywords` 以中英逗號拆分、去空白。
  List<String> get tagList => (keywords ?? '')
      .split(RegExp('[,，]'))
      .map((String e) => e.trim())
      .where((String e) => e.isNotEmpty)
      .toList();
}
