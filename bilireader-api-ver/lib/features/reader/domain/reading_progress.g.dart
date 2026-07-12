// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReadingProgress _$ReadingProgressFromJson(Map<String, dynamic> json) =>
    _ReadingProgress(
      ownerUid: (json['ownerUid'] as num).toInt(),
      anchor: ReaderAnchor.fromJson(json['anchor'] as Map<String, dynamic>),
      articleName: json['articleName'] as String? ?? '',
      poster: json['poster'] as String? ?? '',
      updatedAt: (json['updatedAt'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ReadingProgressToJson(_ReadingProgress instance) =>
    <String, dynamic>{
      'ownerUid': instance.ownerUid,
      'anchor': instance.anchor,
      'articleName': instance.articleName,
      'poster': instance.poster,
      'updatedAt': instance.updatedAt,
    };
