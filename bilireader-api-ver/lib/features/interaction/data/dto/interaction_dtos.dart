import 'package:freezed_annotation/freezed_annotation.dart';

part 'interaction_dtos.freezed.dart';
part 'interaction_dtos.g.dart';

/// 投票統計 DTO（`vote/getNovelVotes`，doc 10 §12.1，wire = 駝峰）。
@freezed
abstract class NovelVotesDto with _$NovelVotesDto {
  const factory NovelVotesDto({
    @Default(0) int allVote,
    @Default(0) int articleid,
    @Default(0) int dayVote,
    @Default(0) int monthVote,
    @Default(false) bool todayVoted,
    @Default(false) bool userVoted,
    @Default(0) int weekVote,
  }) = _NovelVotesDto;

  factory NovelVotesDto.fromJson(Map<String, dynamic> json) =>
      _$NovelVotesDtoFromJson(json);
}

/// 禮物餘額 DTO（`gift/balance`，doc 10 §12.3）。
@freezed
abstract class GiftBalanceDto with _$GiftBalanceDto {
  const factory GiftBalanceDto({
    @Default(0) int egold,
    @Default(0) int flowerStock,
    @Default(0) int flowerUnitPrice,
    @Default(0) int score,
  }) = _GiftBalanceDto;

  factory GiftBalanceDto.fromJson(Map<String, dynamic> json) =>
      _$GiftBalanceDtoFromJson(json);
}

/// 送花結果 DTO（`gift/send`）。
@freezed
abstract class GiftSendDto with _$GiftSendDto {
  const factory GiftSendDto({
    @Default(0) int flowerStock,
    @Default(0) int novelAllFlower,
  }) = _GiftSendDto;

  factory GiftSendDto.fromJson(Map<String, dynamic> json) =>
      _$GiftSendDtoFromJson(json);
}

/// 兌換結果 DTO（`gift/exchange`；無 flowerUnitPrice）。
@freezed
abstract class GiftExchangeDto with _$GiftExchangeDto {
  const factory GiftExchangeDto({
    @Default(0) int egold,
    @Default(0) int flowerStock,
    @Default(0) int score,
  }) = _GiftExchangeDto;

  factory GiftExchangeDto.fromJson(Map<String, dynamic> json) =>
      _$GiftExchangeDtoFromJson(json);
}

/// 送花統計 DTO（`gift/novel_stat`，wire = 全小寫）。
@freezed
abstract class FlowerStatDto with _$FlowerStatDto {
  const factory FlowerStatDto({
    @Default(0) int allflower,
    @Default(0) int dayflower,
    @Default(0) int weekflower,
    @Default(0) int monthflower,
    @Default(0) int lastflower,
  }) = _FlowerStatDto;

  factory FlowerStatDto.fromJson(Map<String, dynamic> json) =>
      _$FlowerStatDtoFromJson(json);
}
