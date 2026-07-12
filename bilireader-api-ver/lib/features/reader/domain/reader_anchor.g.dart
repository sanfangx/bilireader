// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reader_anchor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReaderAnchor _$ReaderAnchorFromJson(Map<String, dynamic> json) =>
    _ReaderAnchor(
      articleId: (json['articleId'] as num).toInt(),
      chapterId: (json['chapterId'] as num).toInt(),
      chapterName: json['chapterName'] as String,
      sourceTextOffset: (json['sourceTextOffset'] as num).toInt(),
      visibleTextOffset: (json['visibleTextOffset'] as num?)?.toInt() ?? 0,
      blockIndex: (json['blockIndex'] as num?)?.toInt() ?? 0,
      blockType: json['blockType'] as String? ?? 'text',
      imageIndex: (json['imageIndex'] as num?)?.toInt(),
      imageUrl: json['imageUrl'] as String?,
      textQuote: json['textQuote'] as String? ?? '',
      progressInChapter: (json['progressInChapter'] as num?)?.toDouble() ?? 0.0,
      createdAt: (json['createdAt'] as num?)?.toInt() ?? 0,
      updatedAt: (json['updatedAt'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ReaderAnchorToJson(_ReaderAnchor instance) =>
    <String, dynamic>{
      'articleId': instance.articleId,
      'chapterId': instance.chapterId,
      'chapterName': instance.chapterName,
      'sourceTextOffset': instance.sourceTextOffset,
      'visibleTextOffset': instance.visibleTextOffset,
      'blockIndex': instance.blockIndex,
      'blockType': instance.blockType,
      'imageIndex': instance.imageIndex,
      'imageUrl': instance.imageUrl,
      'textQuote': instance.textQuote,
      'progressInChapter': instance.progressInChapter,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
