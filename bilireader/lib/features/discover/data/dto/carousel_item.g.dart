// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carousel_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CarouselItem _$CarouselItemFromJson(Map<String, dynamic> json) =>
    _CarouselItem(
      articleId: (json['articleid'] as num?)?.toInt() ?? 0,
      coverImg: json['coverImg'] as String?,
      describe: json['describe'] as String?,
    );

Map<String, dynamic> _$CarouselItemToJson(_CarouselItem instance) =>
    <String, dynamic>{
      'articleid': instance.articleId,
      'coverImg': instance.coverImg,
      'describe': instance.describe,
    };
