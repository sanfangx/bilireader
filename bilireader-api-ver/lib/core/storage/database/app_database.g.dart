// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ChapterContentsTable extends ChapterContents
    with TableInfo<$ChapterContentsTable, ChapterContentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChapterContentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _articleIdMeta = const VerificationMeta(
    'articleId',
  );
  @override
  late final GeneratedColumn<int> articleId = GeneratedColumn<int>(
    'article_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<int> chapterId = GeneratedColumn<int>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    articleId,
    chapterId,
    payload,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'novel_chapter_content';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChapterContentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('article_id')) {
      context.handle(
        _articleIdMeta,
        articleId.isAcceptableOrUnknown(data['article_id']!, _articleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_articleIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {articleId, chapterId};
  @override
  ChapterContentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChapterContentRow(
      articleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}article_id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ChapterContentsTable createAlias(String alias) {
    return $ChapterContentsTable(attachedDatabase, alias);
  }
}

class ChapterContentRow extends DataClass
    implements Insertable<ChapterContentRow> {
  final int articleId;
  final int chapterId;

  /// TextRequestEntity 的 JSON。
  final String payload;

  /// 毫秒時間戳；僅供排序，不做過期判斷。
  final int updatedAt;
  const ChapterContentRow({
    required this.articleId,
    required this.chapterId,
    required this.payload,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['article_id'] = Variable<int>(articleId);
    map['chapter_id'] = Variable<int>(chapterId);
    map['payload'] = Variable<String>(payload);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ChapterContentsCompanion toCompanion(bool nullToAbsent) {
    return ChapterContentsCompanion(
      articleId: Value(articleId),
      chapterId: Value(chapterId),
      payload: Value(payload),
      updatedAt: Value(updatedAt),
    );
  }

  factory ChapterContentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChapterContentRow(
      articleId: serializer.fromJson<int>(json['articleId']),
      chapterId: serializer.fromJson<int>(json['chapterId']),
      payload: serializer.fromJson<String>(json['payload']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'articleId': serializer.toJson<int>(articleId),
      'chapterId': serializer.toJson<int>(chapterId),
      'payload': serializer.toJson<String>(payload),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ChapterContentRow copyWith({
    int? articleId,
    int? chapterId,
    String? payload,
    int? updatedAt,
  }) => ChapterContentRow(
    articleId: articleId ?? this.articleId,
    chapterId: chapterId ?? this.chapterId,
    payload: payload ?? this.payload,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ChapterContentRow copyWithCompanion(ChapterContentsCompanion data) {
    return ChapterContentRow(
      articleId: data.articleId.present ? data.articleId.value : this.articleId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      payload: data.payload.present ? data.payload.value : this.payload,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChapterContentRow(')
          ..write('articleId: $articleId, ')
          ..write('chapterId: $chapterId, ')
          ..write('payload: $payload, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(articleId, chapterId, payload, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChapterContentRow &&
          other.articleId == this.articleId &&
          other.chapterId == this.chapterId &&
          other.payload == this.payload &&
          other.updatedAt == this.updatedAt);
}

class ChapterContentsCompanion extends UpdateCompanion<ChapterContentRow> {
  final Value<int> articleId;
  final Value<int> chapterId;
  final Value<String> payload;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ChapterContentsCompanion({
    this.articleId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.payload = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChapterContentsCompanion.insert({
    required int articleId,
    required int chapterId,
    required String payload,
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : articleId = Value(articleId),
       chapterId = Value(chapterId),
       payload = Value(payload),
       updatedAt = Value(updatedAt);
  static Insertable<ChapterContentRow> custom({
    Expression<int>? articleId,
    Expression<int>? chapterId,
    Expression<String>? payload,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (articleId != null) 'article_id': articleId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (payload != null) 'payload': payload,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChapterContentsCompanion copyWith({
    Value<int>? articleId,
    Value<int>? chapterId,
    Value<String>? payload,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ChapterContentsCompanion(
      articleId: articleId ?? this.articleId,
      chapterId: chapterId ?? this.chapterId,
      payload: payload ?? this.payload,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (articleId.present) {
      map['article_id'] = Variable<int>(articleId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<int>(chapterId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChapterContentsCompanion(')
          ..write('articleId: $articleId, ')
          ..write('chapterId: $chapterId, ')
          ..write('payload: $payload, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChapterCatalogsTable extends ChapterCatalogs
    with TableInfo<$ChapterCatalogsTable, ChapterCatalogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChapterCatalogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _articleIdMeta = const VerificationMeta(
    'articleId',
  );
  @override
  late final GeneratedColumn<int> articleId = GeneratedColumn<int>(
    'article_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _articleNameMeta = const VerificationMeta(
    'articleName',
  );
  @override
  late final GeneratedColumn<String> articleName = GeneratedColumn<String>(
    'article_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    articleId,
    articleName,
    payload,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'novel_chapter_catalog';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChapterCatalogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('article_id')) {
      context.handle(
        _articleIdMeta,
        articleId.isAcceptableOrUnknown(data['article_id']!, _articleIdMeta),
      );
    }
    if (data.containsKey('article_name')) {
      context.handle(
        _articleNameMeta,
        articleName.isAcceptableOrUnknown(
          data['article_name']!,
          _articleNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_articleNameMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {articleId};
  @override
  ChapterCatalogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChapterCatalogRow(
      articleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}article_id'],
      )!,
      articleName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}article_name'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ChapterCatalogsTable createAlias(String alias) {
    return $ChapterCatalogsTable(attachedDatabase, alias);
  }
}

class ChapterCatalogRow extends DataClass
    implements Insertable<ChapterCatalogRow> {
  final int articleId;
  final String articleName;

  /// List&lt;ChapterRequestEntity&gt; 的 JSON。
  final String payload;
  final int updatedAt;
  const ChapterCatalogRow({
    required this.articleId,
    required this.articleName,
    required this.payload,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['article_id'] = Variable<int>(articleId);
    map['article_name'] = Variable<String>(articleName);
    map['payload'] = Variable<String>(payload);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ChapterCatalogsCompanion toCompanion(bool nullToAbsent) {
    return ChapterCatalogsCompanion(
      articleId: Value(articleId),
      articleName: Value(articleName),
      payload: Value(payload),
      updatedAt: Value(updatedAt),
    );
  }

  factory ChapterCatalogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChapterCatalogRow(
      articleId: serializer.fromJson<int>(json['articleId']),
      articleName: serializer.fromJson<String>(json['articleName']),
      payload: serializer.fromJson<String>(json['payload']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'articleId': serializer.toJson<int>(articleId),
      'articleName': serializer.toJson<String>(articleName),
      'payload': serializer.toJson<String>(payload),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ChapterCatalogRow copyWith({
    int? articleId,
    String? articleName,
    String? payload,
    int? updatedAt,
  }) => ChapterCatalogRow(
    articleId: articleId ?? this.articleId,
    articleName: articleName ?? this.articleName,
    payload: payload ?? this.payload,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ChapterCatalogRow copyWithCompanion(ChapterCatalogsCompanion data) {
    return ChapterCatalogRow(
      articleId: data.articleId.present ? data.articleId.value : this.articleId,
      articleName: data.articleName.present
          ? data.articleName.value
          : this.articleName,
      payload: data.payload.present ? data.payload.value : this.payload,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChapterCatalogRow(')
          ..write('articleId: $articleId, ')
          ..write('articleName: $articleName, ')
          ..write('payload: $payload, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(articleId, articleName, payload, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChapterCatalogRow &&
          other.articleId == this.articleId &&
          other.articleName == this.articleName &&
          other.payload == this.payload &&
          other.updatedAt == this.updatedAt);
}

class ChapterCatalogsCompanion extends UpdateCompanion<ChapterCatalogRow> {
  final Value<int> articleId;
  final Value<String> articleName;
  final Value<String> payload;
  final Value<int> updatedAt;
  const ChapterCatalogsCompanion({
    this.articleId = const Value.absent(),
    this.articleName = const Value.absent(),
    this.payload = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ChapterCatalogsCompanion.insert({
    this.articleId = const Value.absent(),
    required String articleName,
    required String payload,
    required int updatedAt,
  }) : articleName = Value(articleName),
       payload = Value(payload),
       updatedAt = Value(updatedAt);
  static Insertable<ChapterCatalogRow> custom({
    Expression<int>? articleId,
    Expression<String>? articleName,
    Expression<String>? payload,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (articleId != null) 'article_id': articleId,
      if (articleName != null) 'article_name': articleName,
      if (payload != null) 'payload': payload,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ChapterCatalogsCompanion copyWith({
    Value<int>? articleId,
    Value<String>? articleName,
    Value<String>? payload,
    Value<int>? updatedAt,
  }) {
    return ChapterCatalogsCompanion(
      articleId: articleId ?? this.articleId,
      articleName: articleName ?? this.articleName,
      payload: payload ?? this.payload,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (articleId.present) {
      map['article_id'] = Variable<int>(articleId.value);
    }
    if (articleName.present) {
      map['article_name'] = Variable<String>(articleName.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChapterCatalogsCompanion(')
          ..write('articleId: $articleId, ')
          ..write('articleName: $articleName, ')
          ..write('payload: $payload, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $PrivateMessagesTable extends PrivateMessages
    with TableInfo<$PrivateMessagesTable, PrivateMessageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrivateMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ownerUidMeta = const VerificationMeta(
    'ownerUid',
  );
  @override
  late final GeneratedColumn<int> ownerUid = GeneratedColumn<int>(
    'owner_uid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<int> messageId = GeneratedColumn<int>(
    'message_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _peerIdMeta = const VerificationMeta('peerId');
  @override
  late final GeneratedColumn<int> peerId = GeneratedColumn<int>(
    'peer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromIdMeta = const VerificationMeta('fromId');
  @override
  late final GeneratedColumn<int> fromId = GeneratedColumn<int>(
    'from_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toIdMeta = const VerificationMeta('toId');
  @override
  late final GeneratedColumn<int> toId = GeneratedColumn<int>(
    'to_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fromNameMeta = const VerificationMeta(
    'fromName',
  );
  @override
  late final GeneratedColumn<String> fromName = GeneratedColumn<String>(
    'from_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toNameMeta = const VerificationMeta('toName');
  @override
  late final GeneratedColumn<String> toName = GeneratedColumn<String>(
    'to_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quoteMessageIdMeta = const VerificationMeta(
    'quoteMessageId',
  );
  @override
  late final GeneratedColumn<int> quoteMessageId = GeneratedColumn<int>(
    'quote_message_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _quoteFromIdMeta = const VerificationMeta(
    'quoteFromId',
  );
  @override
  late final GeneratedColumn<int> quoteFromId = GeneratedColumn<int>(
    'quote_from_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _quoteFromNameMeta = const VerificationMeta(
    'quoteFromName',
  );
  @override
  late final GeneratedColumn<String> quoteFromName = GeneratedColumn<String>(
    'quote_from_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _quoteContentMeta = const VerificationMeta(
    'quoteContent',
  );
  @override
  late final GeneratedColumn<String> quoteContent = GeneratedColumn<String>(
    'quote_content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _postDateMeta = const VerificationMeta(
    'postDate',
  );
  @override
  late final GeneratedColumn<int> postDate = GeneratedColumn<int>(
    'post_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    ownerUid,
    messageId,
    peerId,
    fromId,
    toId,
    fromName,
    toName,
    content,
    quoteMessageId,
    quoteFromId,
    quoteFromName,
    quoteContent,
    postDate,
    title,
    isRead,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'private_message';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrivateMessageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('owner_uid')) {
      context.handle(
        _ownerUidMeta,
        ownerUid.isAcceptableOrUnknown(data['owner_uid']!, _ownerUidMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerUidMeta);
    }
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('peer_id')) {
      context.handle(
        _peerIdMeta,
        peerId.isAcceptableOrUnknown(data['peer_id']!, _peerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_peerIdMeta);
    }
    if (data.containsKey('from_id')) {
      context.handle(
        _fromIdMeta,
        fromId.isAcceptableOrUnknown(data['from_id']!, _fromIdMeta),
      );
    }
    if (data.containsKey('to_id')) {
      context.handle(
        _toIdMeta,
        toId.isAcceptableOrUnknown(data['to_id']!, _toIdMeta),
      );
    }
    if (data.containsKey('from_name')) {
      context.handle(
        _fromNameMeta,
        fromName.isAcceptableOrUnknown(data['from_name']!, _fromNameMeta),
      );
    }
    if (data.containsKey('to_name')) {
      context.handle(
        _toNameMeta,
        toName.isAcceptableOrUnknown(data['to_name']!, _toNameMeta),
      );
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('quote_message_id')) {
      context.handle(
        _quoteMessageIdMeta,
        quoteMessageId.isAcceptableOrUnknown(
          data['quote_message_id']!,
          _quoteMessageIdMeta,
        ),
      );
    }
    if (data.containsKey('quote_from_id')) {
      context.handle(
        _quoteFromIdMeta,
        quoteFromId.isAcceptableOrUnknown(
          data['quote_from_id']!,
          _quoteFromIdMeta,
        ),
      );
    }
    if (data.containsKey('quote_from_name')) {
      context.handle(
        _quoteFromNameMeta,
        quoteFromName.isAcceptableOrUnknown(
          data['quote_from_name']!,
          _quoteFromNameMeta,
        ),
      );
    }
    if (data.containsKey('quote_content')) {
      context.handle(
        _quoteContentMeta,
        quoteContent.isAcceptableOrUnknown(
          data['quote_content']!,
          _quoteContentMeta,
        ),
      );
    }
    if (data.containsKey('post_date')) {
      context.handle(
        _postDateMeta,
        postDate.isAcceptableOrUnknown(data['post_date']!, _postDateMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ownerUid, messageId};
  @override
  PrivateMessageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrivateMessageRow(
      ownerUid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_uid'],
      )!,
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}message_id'],
      )!,
      peerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}peer_id'],
      )!,
      fromId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}from_id'],
      ),
      toId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_id'],
      ),
      fromName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_name'],
      ),
      toName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_name'],
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      ),
      quoteMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quote_message_id'],
      )!,
      quoteFromId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quote_from_id'],
      )!,
      quoteFromName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_from_name'],
      )!,
      quoteContent: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_content'],
      )!,
      postDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}post_date'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
    );
  }

  @override
  $PrivateMessagesTable createAlias(String alias) {
    return $PrivateMessagesTable(attachedDatabase, alias);
  }
}

class PrivateMessageRow extends DataClass
    implements Insertable<PrivateMessageRow> {
  final int ownerUid;
  final int messageId;
  final int peerId;
  final int? fromId;
  final int? toId;
  final String? fromName;
  final String? toName;
  final String? content;
  final int quoteMessageId;
  final int quoteFromId;
  final String quoteFromName;
  final String quoteContent;
  final int postDate;
  final String? title;
  final bool isRead;
  const PrivateMessageRow({
    required this.ownerUid,
    required this.messageId,
    required this.peerId,
    this.fromId,
    this.toId,
    this.fromName,
    this.toName,
    this.content,
    required this.quoteMessageId,
    required this.quoteFromId,
    required this.quoteFromName,
    required this.quoteContent,
    required this.postDate,
    this.title,
    required this.isRead,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['owner_uid'] = Variable<int>(ownerUid);
    map['message_id'] = Variable<int>(messageId);
    map['peer_id'] = Variable<int>(peerId);
    if (!nullToAbsent || fromId != null) {
      map['from_id'] = Variable<int>(fromId);
    }
    if (!nullToAbsent || toId != null) {
      map['to_id'] = Variable<int>(toId);
    }
    if (!nullToAbsent || fromName != null) {
      map['from_name'] = Variable<String>(fromName);
    }
    if (!nullToAbsent || toName != null) {
      map['to_name'] = Variable<String>(toName);
    }
    if (!nullToAbsent || content != null) {
      map['content'] = Variable<String>(content);
    }
    map['quote_message_id'] = Variable<int>(quoteMessageId);
    map['quote_from_id'] = Variable<int>(quoteFromId);
    map['quote_from_name'] = Variable<String>(quoteFromName);
    map['quote_content'] = Variable<String>(quoteContent);
    map['post_date'] = Variable<int>(postDate);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['is_read'] = Variable<bool>(isRead);
    return map;
  }

  PrivateMessagesCompanion toCompanion(bool nullToAbsent) {
    return PrivateMessagesCompanion(
      ownerUid: Value(ownerUid),
      messageId: Value(messageId),
      peerId: Value(peerId),
      fromId: fromId == null && nullToAbsent
          ? const Value.absent()
          : Value(fromId),
      toId: toId == null && nullToAbsent ? const Value.absent() : Value(toId),
      fromName: fromName == null && nullToAbsent
          ? const Value.absent()
          : Value(fromName),
      toName: toName == null && nullToAbsent
          ? const Value.absent()
          : Value(toName),
      content: content == null && nullToAbsent
          ? const Value.absent()
          : Value(content),
      quoteMessageId: Value(quoteMessageId),
      quoteFromId: Value(quoteFromId),
      quoteFromName: Value(quoteFromName),
      quoteContent: Value(quoteContent),
      postDate: Value(postDate),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      isRead: Value(isRead),
    );
  }

  factory PrivateMessageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrivateMessageRow(
      ownerUid: serializer.fromJson<int>(json['ownerUid']),
      messageId: serializer.fromJson<int>(json['messageId']),
      peerId: serializer.fromJson<int>(json['peerId']),
      fromId: serializer.fromJson<int?>(json['fromId']),
      toId: serializer.fromJson<int?>(json['toId']),
      fromName: serializer.fromJson<String?>(json['fromName']),
      toName: serializer.fromJson<String?>(json['toName']),
      content: serializer.fromJson<String?>(json['content']),
      quoteMessageId: serializer.fromJson<int>(json['quoteMessageId']),
      quoteFromId: serializer.fromJson<int>(json['quoteFromId']),
      quoteFromName: serializer.fromJson<String>(json['quoteFromName']),
      quoteContent: serializer.fromJson<String>(json['quoteContent']),
      postDate: serializer.fromJson<int>(json['postDate']),
      title: serializer.fromJson<String?>(json['title']),
      isRead: serializer.fromJson<bool>(json['isRead']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ownerUid': serializer.toJson<int>(ownerUid),
      'messageId': serializer.toJson<int>(messageId),
      'peerId': serializer.toJson<int>(peerId),
      'fromId': serializer.toJson<int?>(fromId),
      'toId': serializer.toJson<int?>(toId),
      'fromName': serializer.toJson<String?>(fromName),
      'toName': serializer.toJson<String?>(toName),
      'content': serializer.toJson<String?>(content),
      'quoteMessageId': serializer.toJson<int>(quoteMessageId),
      'quoteFromId': serializer.toJson<int>(quoteFromId),
      'quoteFromName': serializer.toJson<String>(quoteFromName),
      'quoteContent': serializer.toJson<String>(quoteContent),
      'postDate': serializer.toJson<int>(postDate),
      'title': serializer.toJson<String?>(title),
      'isRead': serializer.toJson<bool>(isRead),
    };
  }

  PrivateMessageRow copyWith({
    int? ownerUid,
    int? messageId,
    int? peerId,
    Value<int?> fromId = const Value.absent(),
    Value<int?> toId = const Value.absent(),
    Value<String?> fromName = const Value.absent(),
    Value<String?> toName = const Value.absent(),
    Value<String?> content = const Value.absent(),
    int? quoteMessageId,
    int? quoteFromId,
    String? quoteFromName,
    String? quoteContent,
    int? postDate,
    Value<String?> title = const Value.absent(),
    bool? isRead,
  }) => PrivateMessageRow(
    ownerUid: ownerUid ?? this.ownerUid,
    messageId: messageId ?? this.messageId,
    peerId: peerId ?? this.peerId,
    fromId: fromId.present ? fromId.value : this.fromId,
    toId: toId.present ? toId.value : this.toId,
    fromName: fromName.present ? fromName.value : this.fromName,
    toName: toName.present ? toName.value : this.toName,
    content: content.present ? content.value : this.content,
    quoteMessageId: quoteMessageId ?? this.quoteMessageId,
    quoteFromId: quoteFromId ?? this.quoteFromId,
    quoteFromName: quoteFromName ?? this.quoteFromName,
    quoteContent: quoteContent ?? this.quoteContent,
    postDate: postDate ?? this.postDate,
    title: title.present ? title.value : this.title,
    isRead: isRead ?? this.isRead,
  );
  PrivateMessageRow copyWithCompanion(PrivateMessagesCompanion data) {
    return PrivateMessageRow(
      ownerUid: data.ownerUid.present ? data.ownerUid.value : this.ownerUid,
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      peerId: data.peerId.present ? data.peerId.value : this.peerId,
      fromId: data.fromId.present ? data.fromId.value : this.fromId,
      toId: data.toId.present ? data.toId.value : this.toId,
      fromName: data.fromName.present ? data.fromName.value : this.fromName,
      toName: data.toName.present ? data.toName.value : this.toName,
      content: data.content.present ? data.content.value : this.content,
      quoteMessageId: data.quoteMessageId.present
          ? data.quoteMessageId.value
          : this.quoteMessageId,
      quoteFromId: data.quoteFromId.present
          ? data.quoteFromId.value
          : this.quoteFromId,
      quoteFromName: data.quoteFromName.present
          ? data.quoteFromName.value
          : this.quoteFromName,
      quoteContent: data.quoteContent.present
          ? data.quoteContent.value
          : this.quoteContent,
      postDate: data.postDate.present ? data.postDate.value : this.postDate,
      title: data.title.present ? data.title.value : this.title,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrivateMessageRow(')
          ..write('ownerUid: $ownerUid, ')
          ..write('messageId: $messageId, ')
          ..write('peerId: $peerId, ')
          ..write('fromId: $fromId, ')
          ..write('toId: $toId, ')
          ..write('fromName: $fromName, ')
          ..write('toName: $toName, ')
          ..write('content: $content, ')
          ..write('quoteMessageId: $quoteMessageId, ')
          ..write('quoteFromId: $quoteFromId, ')
          ..write('quoteFromName: $quoteFromName, ')
          ..write('quoteContent: $quoteContent, ')
          ..write('postDate: $postDate, ')
          ..write('title: $title, ')
          ..write('isRead: $isRead')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    ownerUid,
    messageId,
    peerId,
    fromId,
    toId,
    fromName,
    toName,
    content,
    quoteMessageId,
    quoteFromId,
    quoteFromName,
    quoteContent,
    postDate,
    title,
    isRead,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrivateMessageRow &&
          other.ownerUid == this.ownerUid &&
          other.messageId == this.messageId &&
          other.peerId == this.peerId &&
          other.fromId == this.fromId &&
          other.toId == this.toId &&
          other.fromName == this.fromName &&
          other.toName == this.toName &&
          other.content == this.content &&
          other.quoteMessageId == this.quoteMessageId &&
          other.quoteFromId == this.quoteFromId &&
          other.quoteFromName == this.quoteFromName &&
          other.quoteContent == this.quoteContent &&
          other.postDate == this.postDate &&
          other.title == this.title &&
          other.isRead == this.isRead);
}

class PrivateMessagesCompanion extends UpdateCompanion<PrivateMessageRow> {
  final Value<int> ownerUid;
  final Value<int> messageId;
  final Value<int> peerId;
  final Value<int?> fromId;
  final Value<int?> toId;
  final Value<String?> fromName;
  final Value<String?> toName;
  final Value<String?> content;
  final Value<int> quoteMessageId;
  final Value<int> quoteFromId;
  final Value<String> quoteFromName;
  final Value<String> quoteContent;
  final Value<int> postDate;
  final Value<String?> title;
  final Value<bool> isRead;
  final Value<int> rowid;
  const PrivateMessagesCompanion({
    this.ownerUid = const Value.absent(),
    this.messageId = const Value.absent(),
    this.peerId = const Value.absent(),
    this.fromId = const Value.absent(),
    this.toId = const Value.absent(),
    this.fromName = const Value.absent(),
    this.toName = const Value.absent(),
    this.content = const Value.absent(),
    this.quoteMessageId = const Value.absent(),
    this.quoteFromId = const Value.absent(),
    this.quoteFromName = const Value.absent(),
    this.quoteContent = const Value.absent(),
    this.postDate = const Value.absent(),
    this.title = const Value.absent(),
    this.isRead = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrivateMessagesCompanion.insert({
    required int ownerUid,
    required int messageId,
    required int peerId,
    this.fromId = const Value.absent(),
    this.toId = const Value.absent(),
    this.fromName = const Value.absent(),
    this.toName = const Value.absent(),
    this.content = const Value.absent(),
    this.quoteMessageId = const Value.absent(),
    this.quoteFromId = const Value.absent(),
    this.quoteFromName = const Value.absent(),
    this.quoteContent = const Value.absent(),
    this.postDate = const Value.absent(),
    this.title = const Value.absent(),
    this.isRead = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : ownerUid = Value(ownerUid),
       messageId = Value(messageId),
       peerId = Value(peerId);
  static Insertable<PrivateMessageRow> custom({
    Expression<int>? ownerUid,
    Expression<int>? messageId,
    Expression<int>? peerId,
    Expression<int>? fromId,
    Expression<int>? toId,
    Expression<String>? fromName,
    Expression<String>? toName,
    Expression<String>? content,
    Expression<int>? quoteMessageId,
    Expression<int>? quoteFromId,
    Expression<String>? quoteFromName,
    Expression<String>? quoteContent,
    Expression<int>? postDate,
    Expression<String>? title,
    Expression<bool>? isRead,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ownerUid != null) 'owner_uid': ownerUid,
      if (messageId != null) 'message_id': messageId,
      if (peerId != null) 'peer_id': peerId,
      if (fromId != null) 'from_id': fromId,
      if (toId != null) 'to_id': toId,
      if (fromName != null) 'from_name': fromName,
      if (toName != null) 'to_name': toName,
      if (content != null) 'content': content,
      if (quoteMessageId != null) 'quote_message_id': quoteMessageId,
      if (quoteFromId != null) 'quote_from_id': quoteFromId,
      if (quoteFromName != null) 'quote_from_name': quoteFromName,
      if (quoteContent != null) 'quote_content': quoteContent,
      if (postDate != null) 'post_date': postDate,
      if (title != null) 'title': title,
      if (isRead != null) 'is_read': isRead,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrivateMessagesCompanion copyWith({
    Value<int>? ownerUid,
    Value<int>? messageId,
    Value<int>? peerId,
    Value<int?>? fromId,
    Value<int?>? toId,
    Value<String?>? fromName,
    Value<String?>? toName,
    Value<String?>? content,
    Value<int>? quoteMessageId,
    Value<int>? quoteFromId,
    Value<String>? quoteFromName,
    Value<String>? quoteContent,
    Value<int>? postDate,
    Value<String?>? title,
    Value<bool>? isRead,
    Value<int>? rowid,
  }) {
    return PrivateMessagesCompanion(
      ownerUid: ownerUid ?? this.ownerUid,
      messageId: messageId ?? this.messageId,
      peerId: peerId ?? this.peerId,
      fromId: fromId ?? this.fromId,
      toId: toId ?? this.toId,
      fromName: fromName ?? this.fromName,
      toName: toName ?? this.toName,
      content: content ?? this.content,
      quoteMessageId: quoteMessageId ?? this.quoteMessageId,
      quoteFromId: quoteFromId ?? this.quoteFromId,
      quoteFromName: quoteFromName ?? this.quoteFromName,
      quoteContent: quoteContent ?? this.quoteContent,
      postDate: postDate ?? this.postDate,
      title: title ?? this.title,
      isRead: isRead ?? this.isRead,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ownerUid.present) {
      map['owner_uid'] = Variable<int>(ownerUid.value);
    }
    if (messageId.present) {
      map['message_id'] = Variable<int>(messageId.value);
    }
    if (peerId.present) {
      map['peer_id'] = Variable<int>(peerId.value);
    }
    if (fromId.present) {
      map['from_id'] = Variable<int>(fromId.value);
    }
    if (toId.present) {
      map['to_id'] = Variable<int>(toId.value);
    }
    if (fromName.present) {
      map['from_name'] = Variable<String>(fromName.value);
    }
    if (toName.present) {
      map['to_name'] = Variable<String>(toName.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (quoteMessageId.present) {
      map['quote_message_id'] = Variable<int>(quoteMessageId.value);
    }
    if (quoteFromId.present) {
      map['quote_from_id'] = Variable<int>(quoteFromId.value);
    }
    if (quoteFromName.present) {
      map['quote_from_name'] = Variable<String>(quoteFromName.value);
    }
    if (quoteContent.present) {
      map['quote_content'] = Variable<String>(quoteContent.value);
    }
    if (postDate.present) {
      map['post_date'] = Variable<int>(postDate.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrivateMessagesCompanion(')
          ..write('ownerUid: $ownerUid, ')
          ..write('messageId: $messageId, ')
          ..write('peerId: $peerId, ')
          ..write('fromId: $fromId, ')
          ..write('toId: $toId, ')
          ..write('fromName: $fromName, ')
          ..write('toName: $toName, ')
          ..write('content: $content, ')
          ..write('quoteMessageId: $quoteMessageId, ')
          ..write('quoteFromId: $quoteFromId, ')
          ..write('quoteFromName: $quoteFromName, ')
          ..write('quoteContent: $quoteContent, ')
          ..write('postDate: $postDate, ')
          ..write('title: $title, ')
          ..write('isRead: $isRead, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ConversationSyncsTable extends ConversationSyncs
    with TableInfo<$ConversationSyncsTable, ConversationSyncRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConversationSyncsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ownerUidMeta = const VerificationMeta(
    'ownerUid',
  );
  @override
  late final GeneratedColumn<int> ownerUid = GeneratedColumn<int>(
    'owner_uid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _peerIdMeta = const VerificationMeta('peerId');
  @override
  late final GeneratedColumn<int> peerId = GeneratedColumn<int>(
    'peer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<int> lastSyncAt = GeneratedColumn<int>(
    'last_sync_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [ownerUid, peerId, lastSyncAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conversation_sync';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConversationSyncRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('owner_uid')) {
      context.handle(
        _ownerUidMeta,
        ownerUid.isAcceptableOrUnknown(data['owner_uid']!, _ownerUidMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerUidMeta);
    }
    if (data.containsKey('peer_id')) {
      context.handle(
        _peerIdMeta,
        peerId.isAcceptableOrUnknown(data['peer_id']!, _peerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_peerIdMeta);
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSyncAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ownerUid, peerId};
  @override
  ConversationSyncRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConversationSyncRow(
      ownerUid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_uid'],
      )!,
      peerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}peer_id'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_sync_at'],
      )!,
    );
  }

  @override
  $ConversationSyncsTable createAlias(String alias) {
    return $ConversationSyncsTable(attachedDatabase, alias);
  }
}

class ConversationSyncRow extends DataClass
    implements Insertable<ConversationSyncRow> {
  final int ownerUid;
  final int peerId;
  final int lastSyncAt;
  const ConversationSyncRow({
    required this.ownerUid,
    required this.peerId,
    required this.lastSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['owner_uid'] = Variable<int>(ownerUid);
    map['peer_id'] = Variable<int>(peerId);
    map['last_sync_at'] = Variable<int>(lastSyncAt);
    return map;
  }

  ConversationSyncsCompanion toCompanion(bool nullToAbsent) {
    return ConversationSyncsCompanion(
      ownerUid: Value(ownerUid),
      peerId: Value(peerId),
      lastSyncAt: Value(lastSyncAt),
    );
  }

  factory ConversationSyncRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConversationSyncRow(
      ownerUid: serializer.fromJson<int>(json['ownerUid']),
      peerId: serializer.fromJson<int>(json['peerId']),
      lastSyncAt: serializer.fromJson<int>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ownerUid': serializer.toJson<int>(ownerUid),
      'peerId': serializer.toJson<int>(peerId),
      'lastSyncAt': serializer.toJson<int>(lastSyncAt),
    };
  }

  ConversationSyncRow copyWith({int? ownerUid, int? peerId, int? lastSyncAt}) =>
      ConversationSyncRow(
        ownerUid: ownerUid ?? this.ownerUid,
        peerId: peerId ?? this.peerId,
        lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      );
  ConversationSyncRow copyWithCompanion(ConversationSyncsCompanion data) {
    return ConversationSyncRow(
      ownerUid: data.ownerUid.present ? data.ownerUid.value : this.ownerUid,
      peerId: data.peerId.present ? data.peerId.value : this.peerId,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConversationSyncRow(')
          ..write('ownerUid: $ownerUid, ')
          ..write('peerId: $peerId, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(ownerUid, peerId, lastSyncAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConversationSyncRow &&
          other.ownerUid == this.ownerUid &&
          other.peerId == this.peerId &&
          other.lastSyncAt == this.lastSyncAt);
}

class ConversationSyncsCompanion extends UpdateCompanion<ConversationSyncRow> {
  final Value<int> ownerUid;
  final Value<int> peerId;
  final Value<int> lastSyncAt;
  final Value<int> rowid;
  const ConversationSyncsCompanion({
    this.ownerUid = const Value.absent(),
    this.peerId = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ConversationSyncsCompanion.insert({
    required int ownerUid,
    required int peerId,
    required int lastSyncAt,
    this.rowid = const Value.absent(),
  }) : ownerUid = Value(ownerUid),
       peerId = Value(peerId),
       lastSyncAt = Value(lastSyncAt);
  static Insertable<ConversationSyncRow> custom({
    Expression<int>? ownerUid,
    Expression<int>? peerId,
    Expression<int>? lastSyncAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ownerUid != null) 'owner_uid': ownerUid,
      if (peerId != null) 'peer_id': peerId,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ConversationSyncsCompanion copyWith({
    Value<int>? ownerUid,
    Value<int>? peerId,
    Value<int>? lastSyncAt,
    Value<int>? rowid,
  }) {
    return ConversationSyncsCompanion(
      ownerUid: ownerUid ?? this.ownerUid,
      peerId: peerId ?? this.peerId,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ownerUid.present) {
      map['owner_uid'] = Variable<int>(ownerUid.value);
    }
    if (peerId.present) {
      map['peer_id'] = Variable<int>(peerId.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<int>(lastSyncAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConversationSyncsCompanion(')
          ..write('ownerUid: $ownerUid, ')
          ..write('peerId: $peerId, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookmarkRowsTable extends BookmarkRows
    with TableInfo<$BookmarkRowsTable, BookmarkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarkRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _ownerUidMeta = const VerificationMeta(
    'ownerUid',
  );
  @override
  late final GeneratedColumn<int> ownerUid = GeneratedColumn<int>(
    'owner_uid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _articleIdMeta = const VerificationMeta(
    'articleId',
  );
  @override
  late final GeneratedColumn<int> articleId = GeneratedColumn<int>(
    'article_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<int> chapterId = GeneratedColumn<int>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTextOffsetMeta = const VerificationMeta(
    'sourceTextOffset',
  );
  @override
  late final GeneratedColumn<int> sourceTextOffset = GeneratedColumn<int>(
    'source_text_offset',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anchorJsonMeta = const VerificationMeta(
    'anchorJson',
  );
  @override
  late final GeneratedColumn<String> anchorJson = GeneratedColumn<String>(
    'anchor_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textQuoteMeta = const VerificationMeta(
    'textQuote',
  );
  @override
  late final GeneratedColumn<String> textQuote = GeneratedColumn<String>(
    'text_quote',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _chapterNameMeta = const VerificationMeta(
    'chapterName',
  );
  @override
  late final GeneratedColumn<String> chapterName = GeneratedColumn<String>(
    'chapter_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _articleNameMeta = const VerificationMeta(
    'articleName',
  );
  @override
  late final GeneratedColumn<String> articleName = GeneratedColumn<String>(
    'article_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _posterMeta = const VerificationMeta('poster');
  @override
  late final GeneratedColumn<String> poster = GeneratedColumn<String>(
    'poster',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUid,
    articleId,
    chapterId,
    sourceTextOffset,
    anchorJson,
    textQuote,
    chapterName,
    articleName,
    poster,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookmarkRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_uid')) {
      context.handle(
        _ownerUidMeta,
        ownerUid.isAcceptableOrUnknown(data['owner_uid']!, _ownerUidMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerUidMeta);
    }
    if (data.containsKey('article_id')) {
      context.handle(
        _articleIdMeta,
        articleId.isAcceptableOrUnknown(data['article_id']!, _articleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_articleIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('source_text_offset')) {
      context.handle(
        _sourceTextOffsetMeta,
        sourceTextOffset.isAcceptableOrUnknown(
          data['source_text_offset']!,
          _sourceTextOffsetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceTextOffsetMeta);
    }
    if (data.containsKey('anchor_json')) {
      context.handle(
        _anchorJsonMeta,
        anchorJson.isAcceptableOrUnknown(data['anchor_json']!, _anchorJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_anchorJsonMeta);
    }
    if (data.containsKey('text_quote')) {
      context.handle(
        _textQuoteMeta,
        textQuote.isAcceptableOrUnknown(data['text_quote']!, _textQuoteMeta),
      );
    }
    if (data.containsKey('chapter_name')) {
      context.handle(
        _chapterNameMeta,
        chapterName.isAcceptableOrUnknown(
          data['chapter_name']!,
          _chapterNameMeta,
        ),
      );
    }
    if (data.containsKey('article_name')) {
      context.handle(
        _articleNameMeta,
        articleName.isAcceptableOrUnknown(
          data['article_name']!,
          _articleNameMeta,
        ),
      );
    }
    if (data.containsKey('poster')) {
      context.handle(
        _posterMeta,
        poster.isAcceptableOrUnknown(data['poster']!, _posterMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookmarkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookmarkRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerUid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_uid'],
      )!,
      articleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}article_id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter_id'],
      )!,
      sourceTextOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_text_offset'],
      )!,
      anchorJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anchor_json'],
      )!,
      textQuote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_quote'],
      )!,
      chapterName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_name'],
      )!,
      articleName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}article_name'],
      )!,
      poster: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BookmarkRowsTable createAlias(String alias) {
    return $BookmarkRowsTable(attachedDatabase, alias);
  }
}

class BookmarkRow extends DataClass implements Insertable<BookmarkRow> {
  final int id;
  final int ownerUid;
  final int articleId;
  final int chapterId;
  final int sourceTextOffset;
  final String anchorJson;
  final String textQuote;
  final String chapterName;
  final String articleName;
  final String poster;
  final int createdAt;
  final int updatedAt;
  const BookmarkRow({
    required this.id,
    required this.ownerUid,
    required this.articleId,
    required this.chapterId,
    required this.sourceTextOffset,
    required this.anchorJson,
    required this.textQuote,
    required this.chapterName,
    required this.articleName,
    required this.poster,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['owner_uid'] = Variable<int>(ownerUid);
    map['article_id'] = Variable<int>(articleId);
    map['chapter_id'] = Variable<int>(chapterId);
    map['source_text_offset'] = Variable<int>(sourceTextOffset);
    map['anchor_json'] = Variable<String>(anchorJson);
    map['text_quote'] = Variable<String>(textQuote);
    map['chapter_name'] = Variable<String>(chapterName);
    map['article_name'] = Variable<String>(articleName);
    map['poster'] = Variable<String>(poster);
    map['created_at'] = Variable<int>(createdAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  BookmarkRowsCompanion toCompanion(bool nullToAbsent) {
    return BookmarkRowsCompanion(
      id: Value(id),
      ownerUid: Value(ownerUid),
      articleId: Value(articleId),
      chapterId: Value(chapterId),
      sourceTextOffset: Value(sourceTextOffset),
      anchorJson: Value(anchorJson),
      textQuote: Value(textQuote),
      chapterName: Value(chapterName),
      articleName: Value(articleName),
      poster: Value(poster),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BookmarkRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookmarkRow(
      id: serializer.fromJson<int>(json['id']),
      ownerUid: serializer.fromJson<int>(json['ownerUid']),
      articleId: serializer.fromJson<int>(json['articleId']),
      chapterId: serializer.fromJson<int>(json['chapterId']),
      sourceTextOffset: serializer.fromJson<int>(json['sourceTextOffset']),
      anchorJson: serializer.fromJson<String>(json['anchorJson']),
      textQuote: serializer.fromJson<String>(json['textQuote']),
      chapterName: serializer.fromJson<String>(json['chapterName']),
      articleName: serializer.fromJson<String>(json['articleName']),
      poster: serializer.fromJson<String>(json['poster']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerUid': serializer.toJson<int>(ownerUid),
      'articleId': serializer.toJson<int>(articleId),
      'chapterId': serializer.toJson<int>(chapterId),
      'sourceTextOffset': serializer.toJson<int>(sourceTextOffset),
      'anchorJson': serializer.toJson<String>(anchorJson),
      'textQuote': serializer.toJson<String>(textQuote),
      'chapterName': serializer.toJson<String>(chapterName),
      'articleName': serializer.toJson<String>(articleName),
      'poster': serializer.toJson<String>(poster),
      'createdAt': serializer.toJson<int>(createdAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  BookmarkRow copyWith({
    int? id,
    int? ownerUid,
    int? articleId,
    int? chapterId,
    int? sourceTextOffset,
    String? anchorJson,
    String? textQuote,
    String? chapterName,
    String? articleName,
    String? poster,
    int? createdAt,
    int? updatedAt,
  }) => BookmarkRow(
    id: id ?? this.id,
    ownerUid: ownerUid ?? this.ownerUid,
    articleId: articleId ?? this.articleId,
    chapterId: chapterId ?? this.chapterId,
    sourceTextOffset: sourceTextOffset ?? this.sourceTextOffset,
    anchorJson: anchorJson ?? this.anchorJson,
    textQuote: textQuote ?? this.textQuote,
    chapterName: chapterName ?? this.chapterName,
    articleName: articleName ?? this.articleName,
    poster: poster ?? this.poster,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BookmarkRow copyWithCompanion(BookmarkRowsCompanion data) {
    return BookmarkRow(
      id: data.id.present ? data.id.value : this.id,
      ownerUid: data.ownerUid.present ? data.ownerUid.value : this.ownerUid,
      articleId: data.articleId.present ? data.articleId.value : this.articleId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      sourceTextOffset: data.sourceTextOffset.present
          ? data.sourceTextOffset.value
          : this.sourceTextOffset,
      anchorJson: data.anchorJson.present
          ? data.anchorJson.value
          : this.anchorJson,
      textQuote: data.textQuote.present ? data.textQuote.value : this.textQuote,
      chapterName: data.chapterName.present
          ? data.chapterName.value
          : this.chapterName,
      articleName: data.articleName.present
          ? data.articleName.value
          : this.articleName,
      poster: data.poster.present ? data.poster.value : this.poster,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookmarkRow(')
          ..write('id: $id, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('articleId: $articleId, ')
          ..write('chapterId: $chapterId, ')
          ..write('sourceTextOffset: $sourceTextOffset, ')
          ..write('anchorJson: $anchorJson, ')
          ..write('textQuote: $textQuote, ')
          ..write('chapterName: $chapterName, ')
          ..write('articleName: $articleName, ')
          ..write('poster: $poster, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUid,
    articleId,
    chapterId,
    sourceTextOffset,
    anchorJson,
    textQuote,
    chapterName,
    articleName,
    poster,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookmarkRow &&
          other.id == this.id &&
          other.ownerUid == this.ownerUid &&
          other.articleId == this.articleId &&
          other.chapterId == this.chapterId &&
          other.sourceTextOffset == this.sourceTextOffset &&
          other.anchorJson == this.anchorJson &&
          other.textQuote == this.textQuote &&
          other.chapterName == this.chapterName &&
          other.articleName == this.articleName &&
          other.poster == this.poster &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BookmarkRowsCompanion extends UpdateCompanion<BookmarkRow> {
  final Value<int> id;
  final Value<int> ownerUid;
  final Value<int> articleId;
  final Value<int> chapterId;
  final Value<int> sourceTextOffset;
  final Value<String> anchorJson;
  final Value<String> textQuote;
  final Value<String> chapterName;
  final Value<String> articleName;
  final Value<String> poster;
  final Value<int> createdAt;
  final Value<int> updatedAt;
  const BookmarkRowsCompanion({
    this.id = const Value.absent(),
    this.ownerUid = const Value.absent(),
    this.articleId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.sourceTextOffset = const Value.absent(),
    this.anchorJson = const Value.absent(),
    this.textQuote = const Value.absent(),
    this.chapterName = const Value.absent(),
    this.articleName = const Value.absent(),
    this.poster = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BookmarkRowsCompanion.insert({
    this.id = const Value.absent(),
    required int ownerUid,
    required int articleId,
    required int chapterId,
    required int sourceTextOffset,
    required String anchorJson,
    this.textQuote = const Value.absent(),
    this.chapterName = const Value.absent(),
    this.articleName = const Value.absent(),
    this.poster = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : ownerUid = Value(ownerUid),
       articleId = Value(articleId),
       chapterId = Value(chapterId),
       sourceTextOffset = Value(sourceTextOffset),
       anchorJson = Value(anchorJson);
  static Insertable<BookmarkRow> custom({
    Expression<int>? id,
    Expression<int>? ownerUid,
    Expression<int>? articleId,
    Expression<int>? chapterId,
    Expression<int>? sourceTextOffset,
    Expression<String>? anchorJson,
    Expression<String>? textQuote,
    Expression<String>? chapterName,
    Expression<String>? articleName,
    Expression<String>? poster,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUid != null) 'owner_uid': ownerUid,
      if (articleId != null) 'article_id': articleId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (sourceTextOffset != null) 'source_text_offset': sourceTextOffset,
      if (anchorJson != null) 'anchor_json': anchorJson,
      if (textQuote != null) 'text_quote': textQuote,
      if (chapterName != null) 'chapter_name': chapterName,
      if (articleName != null) 'article_name': articleName,
      if (poster != null) 'poster': poster,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BookmarkRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? ownerUid,
    Value<int>? articleId,
    Value<int>? chapterId,
    Value<int>? sourceTextOffset,
    Value<String>? anchorJson,
    Value<String>? textQuote,
    Value<String>? chapterName,
    Value<String>? articleName,
    Value<String>? poster,
    Value<int>? createdAt,
    Value<int>? updatedAt,
  }) {
    return BookmarkRowsCompanion(
      id: id ?? this.id,
      ownerUid: ownerUid ?? this.ownerUid,
      articleId: articleId ?? this.articleId,
      chapterId: chapterId ?? this.chapterId,
      sourceTextOffset: sourceTextOffset ?? this.sourceTextOffset,
      anchorJson: anchorJson ?? this.anchorJson,
      textQuote: textQuote ?? this.textQuote,
      chapterName: chapterName ?? this.chapterName,
      articleName: articleName ?? this.articleName,
      poster: poster ?? this.poster,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerUid.present) {
      map['owner_uid'] = Variable<int>(ownerUid.value);
    }
    if (articleId.present) {
      map['article_id'] = Variable<int>(articleId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<int>(chapterId.value);
    }
    if (sourceTextOffset.present) {
      map['source_text_offset'] = Variable<int>(sourceTextOffset.value);
    }
    if (anchorJson.present) {
      map['anchor_json'] = Variable<String>(anchorJson.value);
    }
    if (textQuote.present) {
      map['text_quote'] = Variable<String>(textQuote.value);
    }
    if (chapterName.present) {
      map['chapter_name'] = Variable<String>(chapterName.value);
    }
    if (articleName.present) {
      map['article_name'] = Variable<String>(articleName.value);
    }
    if (poster.present) {
      map['poster'] = Variable<String>(poster.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarkRowsCompanion(')
          ..write('id: $id, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('articleId: $articleId, ')
          ..write('chapterId: $chapterId, ')
          ..write('sourceTextOffset: $sourceTextOffset, ')
          ..write('anchorJson: $anchorJson, ')
          ..write('textQuote: $textQuote, ')
          ..write('chapterName: $chapterName, ')
          ..write('articleName: $articleName, ')
          ..write('poster: $poster, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ReadingProgressRowsTable extends ReadingProgressRows
    with TableInfo<$ReadingProgressRowsTable, ReadingProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingProgressRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ownerUidMeta = const VerificationMeta(
    'ownerUid',
  );
  @override
  late final GeneratedColumn<int> ownerUid = GeneratedColumn<int>(
    'owner_uid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _articleIdMeta = const VerificationMeta(
    'articleId',
  );
  @override
  late final GeneratedColumn<int> articleId = GeneratedColumn<int>(
    'article_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chapterIdMeta = const VerificationMeta(
    'chapterId',
  );
  @override
  late final GeneratedColumn<int> chapterId = GeneratedColumn<int>(
    'chapter_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTextOffsetMeta = const VerificationMeta(
    'sourceTextOffset',
  );
  @override
  late final GeneratedColumn<int> sourceTextOffset = GeneratedColumn<int>(
    'source_text_offset',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anchorJsonMeta = const VerificationMeta(
    'anchorJson',
  );
  @override
  late final GeneratedColumn<String> anchorJson = GeneratedColumn<String>(
    'anchor_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _textQuoteMeta = const VerificationMeta(
    'textQuote',
  );
  @override
  late final GeneratedColumn<String> textQuote = GeneratedColumn<String>(
    'text_quote',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _chapterNameMeta = const VerificationMeta(
    'chapterName',
  );
  @override
  late final GeneratedColumn<String> chapterName = GeneratedColumn<String>(
    'chapter_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _articleNameMeta = const VerificationMeta(
    'articleName',
  );
  @override
  late final GeneratedColumn<String> articleName = GeneratedColumn<String>(
    'article_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _posterMeta = const VerificationMeta('poster');
  @override
  late final GeneratedColumn<String> poster = GeneratedColumn<String>(
    'poster',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    ownerUid,
    articleId,
    chapterId,
    sourceTextOffset,
    anchorJson,
    textQuote,
    chapterName,
    articleName,
    poster,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('owner_uid')) {
      context.handle(
        _ownerUidMeta,
        ownerUid.isAcceptableOrUnknown(data['owner_uid']!, _ownerUidMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerUidMeta);
    }
    if (data.containsKey('article_id')) {
      context.handle(
        _articleIdMeta,
        articleId.isAcceptableOrUnknown(data['article_id']!, _articleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_articleIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(
        _chapterIdMeta,
        chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('source_text_offset')) {
      context.handle(
        _sourceTextOffsetMeta,
        sourceTextOffset.isAcceptableOrUnknown(
          data['source_text_offset']!,
          _sourceTextOffsetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceTextOffsetMeta);
    }
    if (data.containsKey('anchor_json')) {
      context.handle(
        _anchorJsonMeta,
        anchorJson.isAcceptableOrUnknown(data['anchor_json']!, _anchorJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_anchorJsonMeta);
    }
    if (data.containsKey('text_quote')) {
      context.handle(
        _textQuoteMeta,
        textQuote.isAcceptableOrUnknown(data['text_quote']!, _textQuoteMeta),
      );
    }
    if (data.containsKey('chapter_name')) {
      context.handle(
        _chapterNameMeta,
        chapterName.isAcceptableOrUnknown(
          data['chapter_name']!,
          _chapterNameMeta,
        ),
      );
    }
    if (data.containsKey('article_name')) {
      context.handle(
        _articleNameMeta,
        articleName.isAcceptableOrUnknown(
          data['article_name']!,
          _articleNameMeta,
        ),
      );
    }
    if (data.containsKey('poster')) {
      context.handle(
        _posterMeta,
        poster.isAcceptableOrUnknown(data['poster']!, _posterMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ownerUid, articleId};
  @override
  ReadingProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingProgressRow(
      ownerUid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_uid'],
      )!,
      articleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}article_id'],
      )!,
      chapterId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chapter_id'],
      )!,
      sourceTextOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_text_offset'],
      )!,
      anchorJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anchor_json'],
      )!,
      textQuote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text_quote'],
      )!,
      chapterName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_name'],
      )!,
      articleName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}article_name'],
      )!,
      poster: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReadingProgressRowsTable createAlias(String alias) {
    return $ReadingProgressRowsTable(attachedDatabase, alias);
  }
}

class ReadingProgressRow extends DataClass
    implements Insertable<ReadingProgressRow> {
  final int ownerUid;
  final int articleId;
  final int chapterId;
  final int sourceTextOffset;
  final String anchorJson;
  final String textQuote;
  final String chapterName;
  final String articleName;
  final String poster;
  final int updatedAt;
  const ReadingProgressRow({
    required this.ownerUid,
    required this.articleId,
    required this.chapterId,
    required this.sourceTextOffset,
    required this.anchorJson,
    required this.textQuote,
    required this.chapterName,
    required this.articleName,
    required this.poster,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['owner_uid'] = Variable<int>(ownerUid);
    map['article_id'] = Variable<int>(articleId);
    map['chapter_id'] = Variable<int>(chapterId);
    map['source_text_offset'] = Variable<int>(sourceTextOffset);
    map['anchor_json'] = Variable<String>(anchorJson);
    map['text_quote'] = Variable<String>(textQuote);
    map['chapter_name'] = Variable<String>(chapterName);
    map['article_name'] = Variable<String>(articleName);
    map['poster'] = Variable<String>(poster);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ReadingProgressRowsCompanion toCompanion(bool nullToAbsent) {
    return ReadingProgressRowsCompanion(
      ownerUid: Value(ownerUid),
      articleId: Value(articleId),
      chapterId: Value(chapterId),
      sourceTextOffset: Value(sourceTextOffset),
      anchorJson: Value(anchorJson),
      textQuote: Value(textQuote),
      chapterName: Value(chapterName),
      articleName: Value(articleName),
      poster: Value(poster),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReadingProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingProgressRow(
      ownerUid: serializer.fromJson<int>(json['ownerUid']),
      articleId: serializer.fromJson<int>(json['articleId']),
      chapterId: serializer.fromJson<int>(json['chapterId']),
      sourceTextOffset: serializer.fromJson<int>(json['sourceTextOffset']),
      anchorJson: serializer.fromJson<String>(json['anchorJson']),
      textQuote: serializer.fromJson<String>(json['textQuote']),
      chapterName: serializer.fromJson<String>(json['chapterName']),
      articleName: serializer.fromJson<String>(json['articleName']),
      poster: serializer.fromJson<String>(json['poster']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ownerUid': serializer.toJson<int>(ownerUid),
      'articleId': serializer.toJson<int>(articleId),
      'chapterId': serializer.toJson<int>(chapterId),
      'sourceTextOffset': serializer.toJson<int>(sourceTextOffset),
      'anchorJson': serializer.toJson<String>(anchorJson),
      'textQuote': serializer.toJson<String>(textQuote),
      'chapterName': serializer.toJson<String>(chapterName),
      'articleName': serializer.toJson<String>(articleName),
      'poster': serializer.toJson<String>(poster),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ReadingProgressRow copyWith({
    int? ownerUid,
    int? articleId,
    int? chapterId,
    int? sourceTextOffset,
    String? anchorJson,
    String? textQuote,
    String? chapterName,
    String? articleName,
    String? poster,
    int? updatedAt,
  }) => ReadingProgressRow(
    ownerUid: ownerUid ?? this.ownerUid,
    articleId: articleId ?? this.articleId,
    chapterId: chapterId ?? this.chapterId,
    sourceTextOffset: sourceTextOffset ?? this.sourceTextOffset,
    anchorJson: anchorJson ?? this.anchorJson,
    textQuote: textQuote ?? this.textQuote,
    chapterName: chapterName ?? this.chapterName,
    articleName: articleName ?? this.articleName,
    poster: poster ?? this.poster,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReadingProgressRow copyWithCompanion(ReadingProgressRowsCompanion data) {
    return ReadingProgressRow(
      ownerUid: data.ownerUid.present ? data.ownerUid.value : this.ownerUid,
      articleId: data.articleId.present ? data.articleId.value : this.articleId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      sourceTextOffset: data.sourceTextOffset.present
          ? data.sourceTextOffset.value
          : this.sourceTextOffset,
      anchorJson: data.anchorJson.present
          ? data.anchorJson.value
          : this.anchorJson,
      textQuote: data.textQuote.present ? data.textQuote.value : this.textQuote,
      chapterName: data.chapterName.present
          ? data.chapterName.value
          : this.chapterName,
      articleName: data.articleName.present
          ? data.articleName.value
          : this.articleName,
      poster: data.poster.present ? data.poster.value : this.poster,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressRow(')
          ..write('ownerUid: $ownerUid, ')
          ..write('articleId: $articleId, ')
          ..write('chapterId: $chapterId, ')
          ..write('sourceTextOffset: $sourceTextOffset, ')
          ..write('anchorJson: $anchorJson, ')
          ..write('textQuote: $textQuote, ')
          ..write('chapterName: $chapterName, ')
          ..write('articleName: $articleName, ')
          ..write('poster: $poster, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    ownerUid,
    articleId,
    chapterId,
    sourceTextOffset,
    anchorJson,
    textQuote,
    chapterName,
    articleName,
    poster,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingProgressRow &&
          other.ownerUid == this.ownerUid &&
          other.articleId == this.articleId &&
          other.chapterId == this.chapterId &&
          other.sourceTextOffset == this.sourceTextOffset &&
          other.anchorJson == this.anchorJson &&
          other.textQuote == this.textQuote &&
          other.chapterName == this.chapterName &&
          other.articleName == this.articleName &&
          other.poster == this.poster &&
          other.updatedAt == this.updatedAt);
}

class ReadingProgressRowsCompanion extends UpdateCompanion<ReadingProgressRow> {
  final Value<int> ownerUid;
  final Value<int> articleId;
  final Value<int> chapterId;
  final Value<int> sourceTextOffset;
  final Value<String> anchorJson;
  final Value<String> textQuote;
  final Value<String> chapterName;
  final Value<String> articleName;
  final Value<String> poster;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const ReadingProgressRowsCompanion({
    this.ownerUid = const Value.absent(),
    this.articleId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.sourceTextOffset = const Value.absent(),
    this.anchorJson = const Value.absent(),
    this.textQuote = const Value.absent(),
    this.chapterName = const Value.absent(),
    this.articleName = const Value.absent(),
    this.poster = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadingProgressRowsCompanion.insert({
    required int ownerUid,
    required int articleId,
    required int chapterId,
    required int sourceTextOffset,
    required String anchorJson,
    this.textQuote = const Value.absent(),
    this.chapterName = const Value.absent(),
    this.articleName = const Value.absent(),
    this.poster = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : ownerUid = Value(ownerUid),
       articleId = Value(articleId),
       chapterId = Value(chapterId),
       sourceTextOffset = Value(sourceTextOffset),
       anchorJson = Value(anchorJson);
  static Insertable<ReadingProgressRow> custom({
    Expression<int>? ownerUid,
    Expression<int>? articleId,
    Expression<int>? chapterId,
    Expression<int>? sourceTextOffset,
    Expression<String>? anchorJson,
    Expression<String>? textQuote,
    Expression<String>? chapterName,
    Expression<String>? articleName,
    Expression<String>? poster,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ownerUid != null) 'owner_uid': ownerUid,
      if (articleId != null) 'article_id': articleId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (sourceTextOffset != null) 'source_text_offset': sourceTextOffset,
      if (anchorJson != null) 'anchor_json': anchorJson,
      if (textQuote != null) 'text_quote': textQuote,
      if (chapterName != null) 'chapter_name': chapterName,
      if (articleName != null) 'article_name': articleName,
      if (poster != null) 'poster': poster,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadingProgressRowsCompanion copyWith({
    Value<int>? ownerUid,
    Value<int>? articleId,
    Value<int>? chapterId,
    Value<int>? sourceTextOffset,
    Value<String>? anchorJson,
    Value<String>? textQuote,
    Value<String>? chapterName,
    Value<String>? articleName,
    Value<String>? poster,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return ReadingProgressRowsCompanion(
      ownerUid: ownerUid ?? this.ownerUid,
      articleId: articleId ?? this.articleId,
      chapterId: chapterId ?? this.chapterId,
      sourceTextOffset: sourceTextOffset ?? this.sourceTextOffset,
      anchorJson: anchorJson ?? this.anchorJson,
      textQuote: textQuote ?? this.textQuote,
      chapterName: chapterName ?? this.chapterName,
      articleName: articleName ?? this.articleName,
      poster: poster ?? this.poster,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ownerUid.present) {
      map['owner_uid'] = Variable<int>(ownerUid.value);
    }
    if (articleId.present) {
      map['article_id'] = Variable<int>(articleId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<int>(chapterId.value);
    }
    if (sourceTextOffset.present) {
      map['source_text_offset'] = Variable<int>(sourceTextOffset.value);
    }
    if (anchorJson.present) {
      map['anchor_json'] = Variable<String>(anchorJson.value);
    }
    if (textQuote.present) {
      map['text_quote'] = Variable<String>(textQuote.value);
    }
    if (chapterName.present) {
      map['chapter_name'] = Variable<String>(chapterName.value);
    }
    if (articleName.present) {
      map['article_name'] = Variable<String>(articleName.value);
    }
    if (poster.present) {
      map['poster'] = Variable<String>(poster.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressRowsCompanion(')
          ..write('ownerUid: $ownerUid, ')
          ..write('articleId: $articleId, ')
          ..write('chapterId: $chapterId, ')
          ..write('sourceTextOffset: $sourceTextOffset, ')
          ..write('anchorJson: $anchorJson, ')
          ..write('textQuote: $textQuote, ')
          ..write('chapterName: $chapterName, ')
          ..write('articleName: $articleName, ')
          ..write('poster: $poster, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ChapterContentsTable chapterContents = $ChapterContentsTable(
    this,
  );
  late final $ChapterCatalogsTable chapterCatalogs = $ChapterCatalogsTable(
    this,
  );
  late final $PrivateMessagesTable privateMessages = $PrivateMessagesTable(
    this,
  );
  late final $ConversationSyncsTable conversationSyncs =
      $ConversationSyncsTable(this);
  late final $BookmarkRowsTable bookmarkRows = $BookmarkRowsTable(this);
  late final $ReadingProgressRowsTable readingProgressRows =
      $ReadingProgressRowsTable(this);
  late final Index idxPrivateMessagePeer = Index(
    'idx_private_message_peer',
    'CREATE INDEX idx_private_message_peer ON private_message (owner_uid, peer_id, post_date)',
  );
  late final Index idxBookmarksAnchor = Index(
    'idx_bookmarks_anchor',
    'CREATE INDEX idx_bookmarks_anchor ON bookmarks (owner_uid, article_id, chapter_id, source_text_offset)',
  );
  late final ChapterCacheDao chapterCacheDao = ChapterCacheDao(
    this as AppDatabase,
  );
  late final BookmarkDao bookmarkDao = BookmarkDao(this as AppDatabase);
  late final ReadingProgressDao readingProgressDao = ReadingProgressDao(
    this as AppDatabase,
  );
  late final PrivateMessageDao privateMessageDao = PrivateMessageDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    chapterContents,
    chapterCatalogs,
    privateMessages,
    conversationSyncs,
    bookmarkRows,
    readingProgressRows,
    idxPrivateMessagePeer,
    idxBookmarksAnchor,
  ];
}

typedef $$ChapterContentsTableCreateCompanionBuilder =
    ChapterContentsCompanion Function({
      required int articleId,
      required int chapterId,
      required String payload,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$ChapterContentsTableUpdateCompanionBuilder =
    ChapterContentsCompanion Function({
      Value<int> articleId,
      Value<int> chapterId,
      Value<String> payload,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$ChapterContentsTableFilterComposer
    extends Composer<_$AppDatabase, $ChapterContentsTable> {
  $$ChapterContentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get articleId => $composableBuilder(
    column: $table.articleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChapterContentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChapterContentsTable> {
  $$ChapterContentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get articleId => $composableBuilder(
    column: $table.articleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChapterContentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChapterContentsTable> {
  $$ChapterContentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get articleId =>
      $composableBuilder(column: $table.articleId, builder: (column) => column);

  GeneratedColumn<int> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ChapterContentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChapterContentsTable,
          ChapterContentRow,
          $$ChapterContentsTableFilterComposer,
          $$ChapterContentsTableOrderingComposer,
          $$ChapterContentsTableAnnotationComposer,
          $$ChapterContentsTableCreateCompanionBuilder,
          $$ChapterContentsTableUpdateCompanionBuilder,
          (
            ChapterContentRow,
            BaseReferences<
              _$AppDatabase,
              $ChapterContentsTable,
              ChapterContentRow
            >,
          ),
          ChapterContentRow,
          PrefetchHooks Function()
        > {
  $$ChapterContentsTableTableManager(
    _$AppDatabase db,
    $ChapterContentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChapterContentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChapterContentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChapterContentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> articleId = const Value.absent(),
                Value<int> chapterId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChapterContentsCompanion(
                articleId: articleId,
                chapterId: chapterId,
                payload: payload,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int articleId,
                required int chapterId,
                required String payload,
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ChapterContentsCompanion.insert(
                articleId: articleId,
                chapterId: chapterId,
                payload: payload,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChapterContentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChapterContentsTable,
      ChapterContentRow,
      $$ChapterContentsTableFilterComposer,
      $$ChapterContentsTableOrderingComposer,
      $$ChapterContentsTableAnnotationComposer,
      $$ChapterContentsTableCreateCompanionBuilder,
      $$ChapterContentsTableUpdateCompanionBuilder,
      (
        ChapterContentRow,
        BaseReferences<_$AppDatabase, $ChapterContentsTable, ChapterContentRow>,
      ),
      ChapterContentRow,
      PrefetchHooks Function()
    >;
typedef $$ChapterCatalogsTableCreateCompanionBuilder =
    ChapterCatalogsCompanion Function({
      Value<int> articleId,
      required String articleName,
      required String payload,
      required int updatedAt,
    });
typedef $$ChapterCatalogsTableUpdateCompanionBuilder =
    ChapterCatalogsCompanion Function({
      Value<int> articleId,
      Value<String> articleName,
      Value<String> payload,
      Value<int> updatedAt,
    });

class $$ChapterCatalogsTableFilterComposer
    extends Composer<_$AppDatabase, $ChapterCatalogsTable> {
  $$ChapterCatalogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get articleId => $composableBuilder(
    column: $table.articleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get articleName => $composableBuilder(
    column: $table.articleName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChapterCatalogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChapterCatalogsTable> {
  $$ChapterCatalogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get articleId => $composableBuilder(
    column: $table.articleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get articleName => $composableBuilder(
    column: $table.articleName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChapterCatalogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChapterCatalogsTable> {
  $$ChapterCatalogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get articleId =>
      $composableBuilder(column: $table.articleId, builder: (column) => column);

  GeneratedColumn<String> get articleName => $composableBuilder(
    column: $table.articleName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ChapterCatalogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChapterCatalogsTable,
          ChapterCatalogRow,
          $$ChapterCatalogsTableFilterComposer,
          $$ChapterCatalogsTableOrderingComposer,
          $$ChapterCatalogsTableAnnotationComposer,
          $$ChapterCatalogsTableCreateCompanionBuilder,
          $$ChapterCatalogsTableUpdateCompanionBuilder,
          (
            ChapterCatalogRow,
            BaseReferences<
              _$AppDatabase,
              $ChapterCatalogsTable,
              ChapterCatalogRow
            >,
          ),
          ChapterCatalogRow,
          PrefetchHooks Function()
        > {
  $$ChapterCatalogsTableTableManager(
    _$AppDatabase db,
    $ChapterCatalogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChapterCatalogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChapterCatalogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChapterCatalogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> articleId = const Value.absent(),
                Value<String> articleName = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => ChapterCatalogsCompanion(
                articleId: articleId,
                articleName: articleName,
                payload: payload,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> articleId = const Value.absent(),
                required String articleName,
                required String payload,
                required int updatedAt,
              }) => ChapterCatalogsCompanion.insert(
                articleId: articleId,
                articleName: articleName,
                payload: payload,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChapterCatalogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChapterCatalogsTable,
      ChapterCatalogRow,
      $$ChapterCatalogsTableFilterComposer,
      $$ChapterCatalogsTableOrderingComposer,
      $$ChapterCatalogsTableAnnotationComposer,
      $$ChapterCatalogsTableCreateCompanionBuilder,
      $$ChapterCatalogsTableUpdateCompanionBuilder,
      (
        ChapterCatalogRow,
        BaseReferences<_$AppDatabase, $ChapterCatalogsTable, ChapterCatalogRow>,
      ),
      ChapterCatalogRow,
      PrefetchHooks Function()
    >;
typedef $$PrivateMessagesTableCreateCompanionBuilder =
    PrivateMessagesCompanion Function({
      required int ownerUid,
      required int messageId,
      required int peerId,
      Value<int?> fromId,
      Value<int?> toId,
      Value<String?> fromName,
      Value<String?> toName,
      Value<String?> content,
      Value<int> quoteMessageId,
      Value<int> quoteFromId,
      Value<String> quoteFromName,
      Value<String> quoteContent,
      Value<int> postDate,
      Value<String?> title,
      Value<bool> isRead,
      Value<int> rowid,
    });
typedef $$PrivateMessagesTableUpdateCompanionBuilder =
    PrivateMessagesCompanion Function({
      Value<int> ownerUid,
      Value<int> messageId,
      Value<int> peerId,
      Value<int?> fromId,
      Value<int?> toId,
      Value<String?> fromName,
      Value<String?> toName,
      Value<String?> content,
      Value<int> quoteMessageId,
      Value<int> quoteFromId,
      Value<String> quoteFromName,
      Value<String> quoteContent,
      Value<int> postDate,
      Value<String?> title,
      Value<bool> isRead,
      Value<int> rowid,
    });

class $$PrivateMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $PrivateMessagesTable> {
  $$PrivateMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get peerId => $composableBuilder(
    column: $table.peerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fromId => $composableBuilder(
    column: $table.fromId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get toId => $composableBuilder(
    column: $table.toId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromName => $composableBuilder(
    column: $table.fromName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toName => $composableBuilder(
    column: $table.toName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quoteMessageId => $composableBuilder(
    column: $table.quoteMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quoteFromId => $composableBuilder(
    column: $table.quoteFromId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quoteFromName => $composableBuilder(
    column: $table.quoteFromName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quoteContent => $composableBuilder(
    column: $table.quoteContent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get postDate => $composableBuilder(
    column: $table.postDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PrivateMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $PrivateMessagesTable> {
  $$PrivateMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get peerId => $composableBuilder(
    column: $table.peerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fromId => $composableBuilder(
    column: $table.fromId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get toId => $composableBuilder(
    column: $table.toId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromName => $composableBuilder(
    column: $table.fromName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toName => $composableBuilder(
    column: $table.toName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quoteMessageId => $composableBuilder(
    column: $table.quoteMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quoteFromId => $composableBuilder(
    column: $table.quoteFromId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quoteFromName => $composableBuilder(
    column: $table.quoteFromName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quoteContent => $composableBuilder(
    column: $table.quoteContent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get postDate => $composableBuilder(
    column: $table.postDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrivateMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrivateMessagesTable> {
  $$PrivateMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get ownerUid =>
      $composableBuilder(column: $table.ownerUid, builder: (column) => column);

  GeneratedColumn<int> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<int> get peerId =>
      $composableBuilder(column: $table.peerId, builder: (column) => column);

  GeneratedColumn<int> get fromId =>
      $composableBuilder(column: $table.fromId, builder: (column) => column);

  GeneratedColumn<int> get toId =>
      $composableBuilder(column: $table.toId, builder: (column) => column);

  GeneratedColumn<String> get fromName =>
      $composableBuilder(column: $table.fromName, builder: (column) => column);

  GeneratedColumn<String> get toName =>
      $composableBuilder(column: $table.toName, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get quoteMessageId => $composableBuilder(
    column: $table.quoteMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quoteFromId => $composableBuilder(
    column: $table.quoteFromId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quoteFromName => $composableBuilder(
    column: $table.quoteFromName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quoteContent => $composableBuilder(
    column: $table.quoteContent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get postDate =>
      $composableBuilder(column: $table.postDate, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);
}

class $$PrivateMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrivateMessagesTable,
          PrivateMessageRow,
          $$PrivateMessagesTableFilterComposer,
          $$PrivateMessagesTableOrderingComposer,
          $$PrivateMessagesTableAnnotationComposer,
          $$PrivateMessagesTableCreateCompanionBuilder,
          $$PrivateMessagesTableUpdateCompanionBuilder,
          (
            PrivateMessageRow,
            BaseReferences<
              _$AppDatabase,
              $PrivateMessagesTable,
              PrivateMessageRow
            >,
          ),
          PrivateMessageRow,
          PrefetchHooks Function()
        > {
  $$PrivateMessagesTableTableManager(
    _$AppDatabase db,
    $PrivateMessagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrivateMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrivateMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrivateMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> ownerUid = const Value.absent(),
                Value<int> messageId = const Value.absent(),
                Value<int> peerId = const Value.absent(),
                Value<int?> fromId = const Value.absent(),
                Value<int?> toId = const Value.absent(),
                Value<String?> fromName = const Value.absent(),
                Value<String?> toName = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<int> quoteMessageId = const Value.absent(),
                Value<int> quoteFromId = const Value.absent(),
                Value<String> quoteFromName = const Value.absent(),
                Value<String> quoteContent = const Value.absent(),
                Value<int> postDate = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrivateMessagesCompanion(
                ownerUid: ownerUid,
                messageId: messageId,
                peerId: peerId,
                fromId: fromId,
                toId: toId,
                fromName: fromName,
                toName: toName,
                content: content,
                quoteMessageId: quoteMessageId,
                quoteFromId: quoteFromId,
                quoteFromName: quoteFromName,
                quoteContent: quoteContent,
                postDate: postDate,
                title: title,
                isRead: isRead,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int ownerUid,
                required int messageId,
                required int peerId,
                Value<int?> fromId = const Value.absent(),
                Value<int?> toId = const Value.absent(),
                Value<String?> fromName = const Value.absent(),
                Value<String?> toName = const Value.absent(),
                Value<String?> content = const Value.absent(),
                Value<int> quoteMessageId = const Value.absent(),
                Value<int> quoteFromId = const Value.absent(),
                Value<String> quoteFromName = const Value.absent(),
                Value<String> quoteContent = const Value.absent(),
                Value<int> postDate = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrivateMessagesCompanion.insert(
                ownerUid: ownerUid,
                messageId: messageId,
                peerId: peerId,
                fromId: fromId,
                toId: toId,
                fromName: fromName,
                toName: toName,
                content: content,
                quoteMessageId: quoteMessageId,
                quoteFromId: quoteFromId,
                quoteFromName: quoteFromName,
                quoteContent: quoteContent,
                postDate: postDate,
                title: title,
                isRead: isRead,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PrivateMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrivateMessagesTable,
      PrivateMessageRow,
      $$PrivateMessagesTableFilterComposer,
      $$PrivateMessagesTableOrderingComposer,
      $$PrivateMessagesTableAnnotationComposer,
      $$PrivateMessagesTableCreateCompanionBuilder,
      $$PrivateMessagesTableUpdateCompanionBuilder,
      (
        PrivateMessageRow,
        BaseReferences<_$AppDatabase, $PrivateMessagesTable, PrivateMessageRow>,
      ),
      PrivateMessageRow,
      PrefetchHooks Function()
    >;
typedef $$ConversationSyncsTableCreateCompanionBuilder =
    ConversationSyncsCompanion Function({
      required int ownerUid,
      required int peerId,
      required int lastSyncAt,
      Value<int> rowid,
    });
typedef $$ConversationSyncsTableUpdateCompanionBuilder =
    ConversationSyncsCompanion Function({
      Value<int> ownerUid,
      Value<int> peerId,
      Value<int> lastSyncAt,
      Value<int> rowid,
    });

class $$ConversationSyncsTableFilterComposer
    extends Composer<_$AppDatabase, $ConversationSyncsTable> {
  $$ConversationSyncsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get peerId => $composableBuilder(
    column: $table.peerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConversationSyncsTableOrderingComposer
    extends Composer<_$AppDatabase, $ConversationSyncsTable> {
  $$ConversationSyncsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get peerId => $composableBuilder(
    column: $table.peerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConversationSyncsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConversationSyncsTable> {
  $$ConversationSyncsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get ownerUid =>
      $composableBuilder(column: $table.ownerUid, builder: (column) => column);

  GeneratedColumn<int> get peerId =>
      $composableBuilder(column: $table.peerId, builder: (column) => column);

  GeneratedColumn<int> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );
}

class $$ConversationSyncsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConversationSyncsTable,
          ConversationSyncRow,
          $$ConversationSyncsTableFilterComposer,
          $$ConversationSyncsTableOrderingComposer,
          $$ConversationSyncsTableAnnotationComposer,
          $$ConversationSyncsTableCreateCompanionBuilder,
          $$ConversationSyncsTableUpdateCompanionBuilder,
          (
            ConversationSyncRow,
            BaseReferences<
              _$AppDatabase,
              $ConversationSyncsTable,
              ConversationSyncRow
            >,
          ),
          ConversationSyncRow,
          PrefetchHooks Function()
        > {
  $$ConversationSyncsTableTableManager(
    _$AppDatabase db,
    $ConversationSyncsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConversationSyncsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConversationSyncsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConversationSyncsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> ownerUid = const Value.absent(),
                Value<int> peerId = const Value.absent(),
                Value<int> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ConversationSyncsCompanion(
                ownerUid: ownerUid,
                peerId: peerId,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int ownerUid,
                required int peerId,
                required int lastSyncAt,
                Value<int> rowid = const Value.absent(),
              }) => ConversationSyncsCompanion.insert(
                ownerUid: ownerUid,
                peerId: peerId,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConversationSyncsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConversationSyncsTable,
      ConversationSyncRow,
      $$ConversationSyncsTableFilterComposer,
      $$ConversationSyncsTableOrderingComposer,
      $$ConversationSyncsTableAnnotationComposer,
      $$ConversationSyncsTableCreateCompanionBuilder,
      $$ConversationSyncsTableUpdateCompanionBuilder,
      (
        ConversationSyncRow,
        BaseReferences<
          _$AppDatabase,
          $ConversationSyncsTable,
          ConversationSyncRow
        >,
      ),
      ConversationSyncRow,
      PrefetchHooks Function()
    >;
typedef $$BookmarkRowsTableCreateCompanionBuilder =
    BookmarkRowsCompanion Function({
      Value<int> id,
      required int ownerUid,
      required int articleId,
      required int chapterId,
      required int sourceTextOffset,
      required String anchorJson,
      Value<String> textQuote,
      Value<String> chapterName,
      Value<String> articleName,
      Value<String> poster,
      Value<int> createdAt,
      Value<int> updatedAt,
    });
typedef $$BookmarkRowsTableUpdateCompanionBuilder =
    BookmarkRowsCompanion Function({
      Value<int> id,
      Value<int> ownerUid,
      Value<int> articleId,
      Value<int> chapterId,
      Value<int> sourceTextOffset,
      Value<String> anchorJson,
      Value<String> textQuote,
      Value<String> chapterName,
      Value<String> articleName,
      Value<String> poster,
      Value<int> createdAt,
      Value<int> updatedAt,
    });

class $$BookmarkRowsTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarkRowsTable> {
  $$BookmarkRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get articleId => $composableBuilder(
    column: $table.articleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sourceTextOffset => $composableBuilder(
    column: $table.sourceTextOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get anchorJson => $composableBuilder(
    column: $table.anchorJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textQuote => $composableBuilder(
    column: $table.textQuote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapterName => $composableBuilder(
    column: $table.chapterName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get articleName => $composableBuilder(
    column: $table.articleName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poster => $composableBuilder(
    column: $table.poster,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BookmarkRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarkRowsTable> {
  $$BookmarkRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get articleId => $composableBuilder(
    column: $table.articleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sourceTextOffset => $composableBuilder(
    column: $table.sourceTextOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get anchorJson => $composableBuilder(
    column: $table.anchorJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textQuote => $composableBuilder(
    column: $table.textQuote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapterName => $composableBuilder(
    column: $table.chapterName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get articleName => $composableBuilder(
    column: $table.articleName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poster => $composableBuilder(
    column: $table.poster,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BookmarkRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarkRowsTable> {
  $$BookmarkRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get ownerUid =>
      $composableBuilder(column: $table.ownerUid, builder: (column) => column);

  GeneratedColumn<int> get articleId =>
      $composableBuilder(column: $table.articleId, builder: (column) => column);

  GeneratedColumn<int> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<int> get sourceTextOffset => $composableBuilder(
    column: $table.sourceTextOffset,
    builder: (column) => column,
  );

  GeneratedColumn<String> get anchorJson => $composableBuilder(
    column: $table.anchorJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get textQuote =>
      $composableBuilder(column: $table.textQuote, builder: (column) => column);

  GeneratedColumn<String> get chapterName => $composableBuilder(
    column: $table.chapterName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get articleName => $composableBuilder(
    column: $table.articleName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get poster =>
      $composableBuilder(column: $table.poster, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BookmarkRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookmarkRowsTable,
          BookmarkRow,
          $$BookmarkRowsTableFilterComposer,
          $$BookmarkRowsTableOrderingComposer,
          $$BookmarkRowsTableAnnotationComposer,
          $$BookmarkRowsTableCreateCompanionBuilder,
          $$BookmarkRowsTableUpdateCompanionBuilder,
          (
            BookmarkRow,
            BaseReferences<_$AppDatabase, $BookmarkRowsTable, BookmarkRow>,
          ),
          BookmarkRow,
          PrefetchHooks Function()
        > {
  $$BookmarkRowsTableTableManager(_$AppDatabase db, $BookmarkRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarkRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarkRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarkRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ownerUid = const Value.absent(),
                Value<int> articleId = const Value.absent(),
                Value<int> chapterId = const Value.absent(),
                Value<int> sourceTextOffset = const Value.absent(),
                Value<String> anchorJson = const Value.absent(),
                Value<String> textQuote = const Value.absent(),
                Value<String> chapterName = const Value.absent(),
                Value<String> articleName = const Value.absent(),
                Value<String> poster = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => BookmarkRowsCompanion(
                id: id,
                ownerUid: ownerUid,
                articleId: articleId,
                chapterId: chapterId,
                sourceTextOffset: sourceTextOffset,
                anchorJson: anchorJson,
                textQuote: textQuote,
                chapterName: chapterName,
                articleName: articleName,
                poster: poster,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ownerUid,
                required int articleId,
                required int chapterId,
                required int sourceTextOffset,
                required String anchorJson,
                Value<String> textQuote = const Value.absent(),
                Value<String> chapterName = const Value.absent(),
                Value<String> articleName = const Value.absent(),
                Value<String> poster = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => BookmarkRowsCompanion.insert(
                id: id,
                ownerUid: ownerUid,
                articleId: articleId,
                chapterId: chapterId,
                sourceTextOffset: sourceTextOffset,
                anchorJson: anchorJson,
                textQuote: textQuote,
                chapterName: chapterName,
                articleName: articleName,
                poster: poster,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BookmarkRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookmarkRowsTable,
      BookmarkRow,
      $$BookmarkRowsTableFilterComposer,
      $$BookmarkRowsTableOrderingComposer,
      $$BookmarkRowsTableAnnotationComposer,
      $$BookmarkRowsTableCreateCompanionBuilder,
      $$BookmarkRowsTableUpdateCompanionBuilder,
      (
        BookmarkRow,
        BaseReferences<_$AppDatabase, $BookmarkRowsTable, BookmarkRow>,
      ),
      BookmarkRow,
      PrefetchHooks Function()
    >;
typedef $$ReadingProgressRowsTableCreateCompanionBuilder =
    ReadingProgressRowsCompanion Function({
      required int ownerUid,
      required int articleId,
      required int chapterId,
      required int sourceTextOffset,
      required String anchorJson,
      Value<String> textQuote,
      Value<String> chapterName,
      Value<String> articleName,
      Value<String> poster,
      Value<int> updatedAt,
      Value<int> rowid,
    });
typedef $$ReadingProgressRowsTableUpdateCompanionBuilder =
    ReadingProgressRowsCompanion Function({
      Value<int> ownerUid,
      Value<int> articleId,
      Value<int> chapterId,
      Value<int> sourceTextOffset,
      Value<String> anchorJson,
      Value<String> textQuote,
      Value<String> chapterName,
      Value<String> articleName,
      Value<String> poster,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$ReadingProgressRowsTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingProgressRowsTable> {
  $$ReadingProgressRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get articleId => $composableBuilder(
    column: $table.articleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sourceTextOffset => $composableBuilder(
    column: $table.sourceTextOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get anchorJson => $composableBuilder(
    column: $table.anchorJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get textQuote => $composableBuilder(
    column: $table.textQuote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapterName => $composableBuilder(
    column: $table.chapterName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get articleName => $composableBuilder(
    column: $table.articleName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poster => $composableBuilder(
    column: $table.poster,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReadingProgressRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingProgressRowsTable> {
  $$ReadingProgressRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get articleId => $composableBuilder(
    column: $table.articleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chapterId => $composableBuilder(
    column: $table.chapterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sourceTextOffset => $composableBuilder(
    column: $table.sourceTextOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get anchorJson => $composableBuilder(
    column: $table.anchorJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get textQuote => $composableBuilder(
    column: $table.textQuote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapterName => $composableBuilder(
    column: $table.chapterName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get articleName => $composableBuilder(
    column: $table.articleName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poster => $composableBuilder(
    column: $table.poster,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReadingProgressRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingProgressRowsTable> {
  $$ReadingProgressRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get ownerUid =>
      $composableBuilder(column: $table.ownerUid, builder: (column) => column);

  GeneratedColumn<int> get articleId =>
      $composableBuilder(column: $table.articleId, builder: (column) => column);

  GeneratedColumn<int> get chapterId =>
      $composableBuilder(column: $table.chapterId, builder: (column) => column);

  GeneratedColumn<int> get sourceTextOffset => $composableBuilder(
    column: $table.sourceTextOffset,
    builder: (column) => column,
  );

  GeneratedColumn<String> get anchorJson => $composableBuilder(
    column: $table.anchorJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get textQuote =>
      $composableBuilder(column: $table.textQuote, builder: (column) => column);

  GeneratedColumn<String> get chapterName => $composableBuilder(
    column: $table.chapterName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get articleName => $composableBuilder(
    column: $table.articleName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get poster =>
      $composableBuilder(column: $table.poster, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ReadingProgressRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingProgressRowsTable,
          ReadingProgressRow,
          $$ReadingProgressRowsTableFilterComposer,
          $$ReadingProgressRowsTableOrderingComposer,
          $$ReadingProgressRowsTableAnnotationComposer,
          $$ReadingProgressRowsTableCreateCompanionBuilder,
          $$ReadingProgressRowsTableUpdateCompanionBuilder,
          (
            ReadingProgressRow,
            BaseReferences<
              _$AppDatabase,
              $ReadingProgressRowsTable,
              ReadingProgressRow
            >,
          ),
          ReadingProgressRow,
          PrefetchHooks Function()
        > {
  $$ReadingProgressRowsTableTableManager(
    _$AppDatabase db,
    $ReadingProgressRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingProgressRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingProgressRowsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ReadingProgressRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> ownerUid = const Value.absent(),
                Value<int> articleId = const Value.absent(),
                Value<int> chapterId = const Value.absent(),
                Value<int> sourceTextOffset = const Value.absent(),
                Value<String> anchorJson = const Value.absent(),
                Value<String> textQuote = const Value.absent(),
                Value<String> chapterName = const Value.absent(),
                Value<String> articleName = const Value.absent(),
                Value<String> poster = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadingProgressRowsCompanion(
                ownerUid: ownerUid,
                articleId: articleId,
                chapterId: chapterId,
                sourceTextOffset: sourceTextOffset,
                anchorJson: anchorJson,
                textQuote: textQuote,
                chapterName: chapterName,
                articleName: articleName,
                poster: poster,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int ownerUid,
                required int articleId,
                required int chapterId,
                required int sourceTextOffset,
                required String anchorJson,
                Value<String> textQuote = const Value.absent(),
                Value<String> chapterName = const Value.absent(),
                Value<String> articleName = const Value.absent(),
                Value<String> poster = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadingProgressRowsCompanion.insert(
                ownerUid: ownerUid,
                articleId: articleId,
                chapterId: chapterId,
                sourceTextOffset: sourceTextOffset,
                anchorJson: anchorJson,
                textQuote: textQuote,
                chapterName: chapterName,
                articleName: articleName,
                poster: poster,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReadingProgressRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingProgressRowsTable,
      ReadingProgressRow,
      $$ReadingProgressRowsTableFilterComposer,
      $$ReadingProgressRowsTableOrderingComposer,
      $$ReadingProgressRowsTableAnnotationComposer,
      $$ReadingProgressRowsTableCreateCompanionBuilder,
      $$ReadingProgressRowsTableUpdateCompanionBuilder,
      (
        ReadingProgressRow,
        BaseReferences<
          _$AppDatabase,
          $ReadingProgressRowsTable,
          ReadingProgressRow
        >,
      ),
      ReadingProgressRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ChapterContentsTableTableManager get chapterContents =>
      $$ChapterContentsTableTableManager(_db, _db.chapterContents);
  $$ChapterCatalogsTableTableManager get chapterCatalogs =>
      $$ChapterCatalogsTableTableManager(_db, _db.chapterCatalogs);
  $$PrivateMessagesTableTableManager get privateMessages =>
      $$PrivateMessagesTableTableManager(_db, _db.privateMessages);
  $$ConversationSyncsTableTableManager get conversationSyncs =>
      $$ConversationSyncsTableTableManager(_db, _db.conversationSyncs);
  $$BookmarkRowsTableTableManager get bookmarkRows =>
      $$BookmarkRowsTableTableManager(_db, _db.bookmarkRows);
  $$ReadingProgressRowsTableTableManager get readingProgressRows =>
      $$ReadingProgressRowsTableTableManager(_db, _db.readingProgressRows);
}

mixin _$ChapterCacheDaoMixin on DatabaseAccessor<AppDatabase> {
  $ChapterContentsTable get chapterContents => attachedDatabase.chapterContents;
  $ChapterCatalogsTable get chapterCatalogs => attachedDatabase.chapterCatalogs;
  ChapterCacheDaoManager get managers => ChapterCacheDaoManager(this);
}

class ChapterCacheDaoManager {
  final _$ChapterCacheDaoMixin _db;
  ChapterCacheDaoManager(this._db);
  $$ChapterContentsTableTableManager get chapterContents =>
      $$ChapterContentsTableTableManager(
        _db.attachedDatabase,
        _db.chapterContents,
      );
  $$ChapterCatalogsTableTableManager get chapterCatalogs =>
      $$ChapterCatalogsTableTableManager(
        _db.attachedDatabase,
        _db.chapterCatalogs,
      );
}

mixin _$BookmarkDaoMixin on DatabaseAccessor<AppDatabase> {
  $BookmarkRowsTable get bookmarkRows => attachedDatabase.bookmarkRows;
  BookmarkDaoManager get managers => BookmarkDaoManager(this);
}

class BookmarkDaoManager {
  final _$BookmarkDaoMixin _db;
  BookmarkDaoManager(this._db);
  $$BookmarkRowsTableTableManager get bookmarkRows =>
      $$BookmarkRowsTableTableManager(_db.attachedDatabase, _db.bookmarkRows);
}

mixin _$ReadingProgressDaoMixin on DatabaseAccessor<AppDatabase> {
  $ReadingProgressRowsTable get readingProgressRows =>
      attachedDatabase.readingProgressRows;
  ReadingProgressDaoManager get managers => ReadingProgressDaoManager(this);
}

class ReadingProgressDaoManager {
  final _$ReadingProgressDaoMixin _db;
  ReadingProgressDaoManager(this._db);
  $$ReadingProgressRowsTableTableManager get readingProgressRows =>
      $$ReadingProgressRowsTableTableManager(
        _db.attachedDatabase,
        _db.readingProgressRows,
      );
}

mixin _$PrivateMessageDaoMixin on DatabaseAccessor<AppDatabase> {
  $PrivateMessagesTable get privateMessages => attachedDatabase.privateMessages;
  $ConversationSyncsTable get conversationSyncs =>
      attachedDatabase.conversationSyncs;
  PrivateMessageDaoManager get managers => PrivateMessageDaoManager(this);
}

class PrivateMessageDaoManager {
  final _$PrivateMessageDaoMixin _db;
  PrivateMessageDaoManager(this._db);
  $$PrivateMessagesTableTableManager get privateMessages =>
      $$PrivateMessagesTableTableManager(
        _db.attachedDatabase,
        _db.privateMessages,
      );
  $$ConversationSyncsTableTableManager get conversationSyncs =>
      $$ConversationSyncsTableTableManager(
        _db.attachedDatabase,
        _db.conversationSyncs,
      );
}
