import 'package:freezed_annotation/freezed_annotation.dart';

part 'carousel_item.freezed.dart';
part 'carousel_item.g.dart';

/// 首頁輪播 Banner DTO（doc 10 §3.3 `CarouselItem`）。
/// wire：`articleid`（駝峰對映）、`coverImg`、`describe`。
@freezed
abstract class CarouselItem with _$CarouselItem {
  const factory CarouselItem({
    @JsonKey(name: 'articleid') @Default(0) int articleId,
    @JsonKey(name: 'coverImg') String? coverImg,
    String? describe,
  }) = _CarouselItem;

  factory CarouselItem.fromJson(Map<String, dynamic> json) =>
      _$CarouselItemFromJson(json);
}
