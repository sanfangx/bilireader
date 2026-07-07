// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChapterData _$ChapterDataFromJson(Map<String, dynamic> json) => _ChapterData(
  articleid: (json['articleid'] as num?)?.toInt() ?? 0,
  articlename: json['articlename'] as String?,
  chapters:
      (json['chapters'] as List<dynamic>?)
          ?.map((e) => ChapterRequestEntity.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ChapterRequestEntity>[],
);

Map<String, dynamic> _$ChapterDataToJson(_ChapterData instance) =>
    <String, dynamic>{
      'articleid': instance.articleid,
      'articlename': instance.articlename,
      'chapters': instance.chapters,
    };

_ChapterRequestEntity _$ChapterRequestEntityFromJson(
  Map<String, dynamic> json,
) => _ChapterRequestEntity(
  articleid: (json['articleid'] as num?)?.toInt() ?? 0,
  chapterid: (json['chapterid'] as num?)?.toInt() ?? 0,
  chaptername: json['chaptername'] as String?,
  chaptertype: (json['chaptertype'] as num?)?.toInt() ?? 0,
  words: (json['words'] as num?)?.toInt() ?? 0,
  cover: json['cover'] as String?,
  chapterList: (json['chapterList'] as List<dynamic>?)
      ?.map((e) => ChapterRequestEntity.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ChapterRequestEntityToJson(
  _ChapterRequestEntity instance,
) => <String, dynamic>{
  'articleid': instance.articleid,
  'chapterid': instance.chapterid,
  'chaptername': instance.chaptername,
  'chaptertype': instance.chaptertype,
  'words': instance.words,
  'cover': instance.cover,
  'chapterList': instance.chapterList,
};
