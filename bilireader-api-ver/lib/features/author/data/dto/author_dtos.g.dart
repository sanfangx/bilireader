// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthorNovelListDataDto _$AuthorNovelListDataDtoFromJson(
  Map<String, dynamic> json,
) => _AuthorNovelListDataDto(
  list:
      (json['list'] as List<dynamic>?)
          ?.map((e) => NovelResponseEntity.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <NovelResponseEntity>[],
  total: (json['total'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AuthorNovelListDataDtoToJson(
  _AuthorNovelListDataDto instance,
) => <String, dynamic>{'list': instance.list, 'total': instance.total};

_AuthorChapterRowDto _$AuthorChapterRowDtoFromJson(Map<String, dynamic> json) =>
    _AuthorChapterRowDto(
      chapterid: (json['chapterid'] as num?)?.toInt() ?? 0,
      articleid: (json['articleid'] as num?)?.toInt() ?? 0,
      volumeid: (json['volumeid'] as num?)?.toInt() ?? 0,
      chaptername: json['chaptername'] as String?,
      chapterorder: (json['chapterorder'] as num?)?.toInt() ?? 0,
      chaptertype: (json['chaptertype'] as num?)?.toInt() ?? 0,
      words: (json['words'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AuthorChapterRowDtoToJson(
  _AuthorChapterRowDto instance,
) => <String, dynamic>{
  'chapterid': instance.chapterid,
  'articleid': instance.articleid,
  'volumeid': instance.volumeid,
  'chaptername': instance.chaptername,
  'chapterorder': instance.chapterorder,
  'chaptertype': instance.chaptertype,
  'words': instance.words,
};

_AuthorVolumeDto _$AuthorVolumeDtoFromJson(Map<String, dynamic> json) =>
    _AuthorVolumeDto(
      chapterid: (json['chapterid'] as num?)?.toInt() ?? 0,
      chaptername: json['chaptername'] as String?,
    );

Map<String, dynamic> _$AuthorVolumeDtoToJson(_AuthorVolumeDto instance) =>
    <String, dynamic>{
      'chapterid': instance.chapterid,
      'chaptername': instance.chaptername,
    };

_AuthorChapterTreeDataDto _$AuthorChapterTreeDataDtoFromJson(
  Map<String, dynamic> json,
) => _AuthorChapterTreeDataDto(
  articleid: (json['articleid'] as num?)?.toInt() ?? 0,
  articlename: json['articlename'] as String?,
  volumes:
      (json['volumes'] as List<dynamic>?)
          ?.map((e) => AuthorVolumeDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AuthorVolumeDto>[],
  flat:
      (json['flat'] as List<dynamic>?)
          ?.map((e) => AuthorChapterRowDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AuthorChapterRowDto>[],
);

Map<String, dynamic> _$AuthorChapterTreeDataDtoToJson(
  _AuthorChapterTreeDataDto instance,
) => <String, dynamic>{
  'articleid': instance.articleid,
  'articlename': instance.articlename,
  'volumes': instance.volumes,
  'flat': instance.flat,
};

_AuthorChapterTextDataDto _$AuthorChapterTextDataDtoFromJson(
  Map<String, dynamic> json,
) => _AuthorChapterTextDataDto(
  articleid: (json['articleid'] as num?)?.toInt() ?? 0,
  chapterid: (json['chapterid'] as num?)?.toInt() ?? 0,
  chaptername: json['chaptername'] as String?,
  isbody: (json['isbody'] as num?)?.toInt() ?? 1,
  text: json['text'] as String?,
);

Map<String, dynamic> _$AuthorChapterTextDataDtoToJson(
  _AuthorChapterTextDataDto instance,
) => <String, dynamic>{
  'articleid': instance.articleid,
  'chapterid': instance.chapterid,
  'chaptername': instance.chaptername,
  'isbody': instance.isbody,
  'text': instance.text,
};

_AuthorDraftItemDto _$AuthorDraftItemDtoFromJson(Map<String, dynamic> json) =>
    _AuthorDraftItemDto(
      draftid: (json['draftid'] as num?)?.toInt() ?? 0,
      articleid: (json['articleid'] as num?)?.toInt() ?? 0,
      volumeid: (json['volumeid'] as num?)?.toInt() ?? 0,
      chaptername: json['chaptername'] as String?,
      chaptercontent: json['chaptercontent'] as String?,
      words: (json['words'] as num?)?.toInt() ?? 0,
      lastupdate: (json['lastupdate'] as num?)?.toInt() ?? 0,
      ispub: (json['ispub'] as num?)?.toInt() ?? 0,
      isbody: (json['isbody'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$AuthorDraftItemDtoToJson(_AuthorDraftItemDto instance) =>
    <String, dynamic>{
      'draftid': instance.draftid,
      'articleid': instance.articleid,
      'volumeid': instance.volumeid,
      'chaptername': instance.chaptername,
      'chaptercontent': instance.chaptercontent,
      'words': instance.words,
      'lastupdate': instance.lastupdate,
      'ispub': instance.ispub,
      'isbody': instance.isbody,
    };

_ChapterAttachUploadDataDto _$ChapterAttachUploadDataDtoFromJson(
  Map<String, dynamic> json,
) => _ChapterAttachUploadDataDto(
  attachId: (json['attachId'] as num?)?.toInt() ?? 0,
  previewUrl: json['previewUrl'] as String?,
  insertHtml: json['insertHtml'] as String?,
  insertToken: json['insertToken'] as String?,
  fileName: json['fileName'] as String?,
  size: (json['size'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ChapterAttachUploadDataDtoToJson(
  _ChapterAttachUploadDataDto instance,
) => <String, dynamic>{
  'attachId': instance.attachId,
  'previewUrl': instance.previewUrl,
  'insertHtml': instance.insertHtml,
  'insertToken': instance.insertToken,
  'fileName': instance.fileName,
  'size': instance.size,
};
