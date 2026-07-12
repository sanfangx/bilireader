// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Bookmark _$BookmarkFromJson(Map<String, dynamic> json) => _Bookmark(
  ownerUid: (json['ownerUid'] as num).toInt(),
  anchor: ReaderAnchor.fromJson(json['anchor'] as Map<String, dynamic>),
  articleName: json['articleName'] as String? ?? '',
  poster: json['poster'] as String? ?? '',
  id: (json['id'] as num?)?.toInt(),
);

Map<String, dynamic> _$BookmarkToJson(_Bookmark instance) => <String, dynamic>{
  'ownerUid': instance.ownerUid,
  'anchor': instance.anchor,
  'articleName': instance.articleName,
  'poster': instance.poster,
  'id': instance.id,
};
