// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_request_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TextRequestEntity _$TextRequestEntityFromJson(Map<String, dynamic> json) =>
    _TextRequestEntity(
      articleId: (json['articleid'] as num?)?.toInt() ?? 0,
      chapterId: (json['chapterid'] as num?)?.toInt() ?? 0,
      chapterName: json['chaptername'] as String?,
      text: json['text'] as String?,
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => ChapterImageDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ChapterImageDto>[],
      isImage: json['isImage'] as bool? ?? false,
      isbody: (json['isbody'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TextRequestEntityToJson(_TextRequestEntity instance) =>
    <String, dynamic>{
      'articleid': instance.articleId,
      'chapterid': instance.chapterId,
      'chaptername': instance.chapterName,
      'text': instance.text,
      'images': instance.images,
      'isImage': instance.isImage,
      'isbody': instance.isbody,
    };

_ChapterImageDto _$ChapterImageDtoFromJson(Map<String, dynamic> json) =>
    _ChapterImageDto(
      path: json['path'] as String?,
      aspectRatio: (json['aspectRatio'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$ChapterImageDtoToJson(_ChapterImageDto instance) =>
    <String, dynamic>{
      'path': instance.path,
      'aspectRatio': instance.aspectRatio,
    };
