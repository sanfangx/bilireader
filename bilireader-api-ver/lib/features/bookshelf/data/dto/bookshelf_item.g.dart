// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookshelf_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookshelfItem _$BookshelfItemFromJson(Map<String, dynamic> json) =>
    _BookshelfItem(
      caseid: (json['caseid'] as num?)?.toInt() ?? 0,
      articleid: (json['articleid'] as num?)?.toInt() ?? 0,
      articlename: json['articlename'] as String?,
      author: json['author'] as String?,
      poster: json['poster'] as String?,
      classid: (json['classid'] as num?)?.toInt() ?? 0,
      chapterid: (json['chapterid'] as num?)?.toInt() ?? 0,
      chaptername: json['chaptername'] as String?,
      chapterorder: (json['chapterorder'] as num?)?.toInt() ?? 0,
      pageid: (json['pageid'] as num?)?.toInt() ?? 0,
      progress: (json['progress'] as num?)?.toInt() ?? 0,
      joindate: (json['joindate'] as num?)?.toInt() ?? 0,
      lastupdate: (json['lastupdate'] as num?)?.toInt() ?? 0,
      lastvisit: (json['lastvisit'] as num?)?.toInt() ?? 0,
      lastchapter: json['lastchapter'] as String?,
      lastchapterid: (json['lastchapterid'] as num?)?.toInt() ?? 0,
      words: (json['words'] as num?)?.toInt() ?? 0,
      allvote: (json['allvote'] as num?)?.toInt() ?? 0,
      goodnum: (json['goodnum'] as num?)?.toInt() ?? 0,
      intro: json['intro'] as String?,
    );

Map<String, dynamic> _$BookshelfItemToJson(_BookshelfItem instance) =>
    <String, dynamic>{
      'caseid': instance.caseid,
      'articleid': instance.articleid,
      'articlename': instance.articlename,
      'author': instance.author,
      'poster': instance.poster,
      'classid': instance.classid,
      'chapterid': instance.chapterid,
      'chaptername': instance.chaptername,
      'chapterorder': instance.chapterorder,
      'pageid': instance.pageid,
      'progress': instance.progress,
      'joindate': instance.joindate,
      'lastupdate': instance.lastupdate,
      'lastvisit': instance.lastvisit,
      'lastchapter': instance.lastchapter,
      'lastchapterid': instance.lastchapterid,
      'words': instance.words,
      'allvote': instance.allvote,
      'goodnum': instance.goodnum,
      'intro': instance.intro,
    };
