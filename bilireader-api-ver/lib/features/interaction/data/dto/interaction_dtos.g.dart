// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interaction_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NovelVotesDto _$NovelVotesDtoFromJson(Map<String, dynamic> json) =>
    _NovelVotesDto(
      allVote: (json['allVote'] as num?)?.toInt() ?? 0,
      articleid: (json['articleid'] as num?)?.toInt() ?? 0,
      dayVote: (json['dayVote'] as num?)?.toInt() ?? 0,
      monthVote: (json['monthVote'] as num?)?.toInt() ?? 0,
      todayVoted: json['todayVoted'] as bool? ?? false,
      userVoted: json['userVoted'] as bool? ?? false,
      weekVote: (json['weekVote'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$NovelVotesDtoToJson(_NovelVotesDto instance) =>
    <String, dynamic>{
      'allVote': instance.allVote,
      'articleid': instance.articleid,
      'dayVote': instance.dayVote,
      'monthVote': instance.monthVote,
      'todayVoted': instance.todayVoted,
      'userVoted': instance.userVoted,
      'weekVote': instance.weekVote,
    };

_GiftBalanceDto _$GiftBalanceDtoFromJson(Map<String, dynamic> json) =>
    _GiftBalanceDto(
      egold: (json['egold'] as num?)?.toInt() ?? 0,
      flowerStock: (json['flowerStock'] as num?)?.toInt() ?? 0,
      flowerUnitPrice: (json['flowerUnitPrice'] as num?)?.toInt() ?? 0,
      score: (json['score'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$GiftBalanceDtoToJson(_GiftBalanceDto instance) =>
    <String, dynamic>{
      'egold': instance.egold,
      'flowerStock': instance.flowerStock,
      'flowerUnitPrice': instance.flowerUnitPrice,
      'score': instance.score,
    };

_GiftSendDto _$GiftSendDtoFromJson(Map<String, dynamic> json) => _GiftSendDto(
  flowerStock: (json['flowerStock'] as num?)?.toInt() ?? 0,
  novelAllFlower: (json['novelAllFlower'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$GiftSendDtoToJson(_GiftSendDto instance) =>
    <String, dynamic>{
      'flowerStock': instance.flowerStock,
      'novelAllFlower': instance.novelAllFlower,
    };

_GiftExchangeDto _$GiftExchangeDtoFromJson(Map<String, dynamic> json) =>
    _GiftExchangeDto(
      egold: (json['egold'] as num?)?.toInt() ?? 0,
      flowerStock: (json['flowerStock'] as num?)?.toInt() ?? 0,
      score: (json['score'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$GiftExchangeDtoToJson(_GiftExchangeDto instance) =>
    <String, dynamic>{
      'egold': instance.egold,
      'flowerStock': instance.flowerStock,
      'score': instance.score,
    };

_FlowerStatDto _$FlowerStatDtoFromJson(Map<String, dynamic> json) =>
    _FlowerStatDto(
      allflower: (json['allflower'] as num?)?.toInt() ?? 0,
      dayflower: (json['dayflower'] as num?)?.toInt() ?? 0,
      weekflower: (json['weekflower'] as num?)?.toInt() ?? 0,
      monthflower: (json['monthflower'] as num?)?.toInt() ?? 0,
      lastflower: (json['lastflower'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$FlowerStatDtoToJson(_FlowerStatDto instance) =>
    <String, dynamic>{
      'allflower': instance.allflower,
      'dayflower': instance.dayflower,
      'weekflower': instance.weekflower,
      'monthflower': instance.monthflower,
      'lastflower': instance.lastflower,
    };
