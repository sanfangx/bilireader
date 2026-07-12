// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChapterData {

 int get articleid; String? get articlename; List<ChapterRequestEntity> get chapters;
/// Create a copy of ChapterData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterDataCopyWith<ChapterData> get copyWith => _$ChapterDataCopyWithImpl<ChapterData>(this as ChapterData, _$identity);

  /// Serializes this ChapterData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterData&&(identical(other.articleid, articleid) || other.articleid == articleid)&&(identical(other.articlename, articlename) || other.articlename == articlename)&&const DeepCollectionEquality().equals(other.chapters, chapters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleid,articlename,const DeepCollectionEquality().hash(chapters));

@override
String toString() {
  return 'ChapterData(articleid: $articleid, articlename: $articlename, chapters: $chapters)';
}


}

/// @nodoc
abstract mixin class $ChapterDataCopyWith<$Res>  {
  factory $ChapterDataCopyWith(ChapterData value, $Res Function(ChapterData) _then) = _$ChapterDataCopyWithImpl;
@useResult
$Res call({
 int articleid, String? articlename, List<ChapterRequestEntity> chapters
});




}
/// @nodoc
class _$ChapterDataCopyWithImpl<$Res>
    implements $ChapterDataCopyWith<$Res> {
  _$ChapterDataCopyWithImpl(this._self, this._then);

  final ChapterData _self;
  final $Res Function(ChapterData) _then;

/// Create a copy of ChapterData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? articleid = null,Object? articlename = freezed,Object? chapters = null,}) {
  return _then(_self.copyWith(
articleid: null == articleid ? _self.articleid : articleid // ignore: cast_nullable_to_non_nullable
as int,articlename: freezed == articlename ? _self.articlename : articlename // ignore: cast_nullable_to_non_nullable
as String?,chapters: null == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<ChapterRequestEntity>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChapterData].
extension ChapterDataPatterns on ChapterData {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChapterData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChapterData() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChapterData value)  $default,){
final _that = this;
switch (_that) {
case _ChapterData():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChapterData value)?  $default,){
final _that = this;
switch (_that) {
case _ChapterData() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int articleid,  String? articlename,  List<ChapterRequestEntity> chapters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChapterData() when $default != null:
return $default(_that.articleid,_that.articlename,_that.chapters);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int articleid,  String? articlename,  List<ChapterRequestEntity> chapters)  $default,) {final _that = this;
switch (_that) {
case _ChapterData():
return $default(_that.articleid,_that.articlename,_that.chapters);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int articleid,  String? articlename,  List<ChapterRequestEntity> chapters)?  $default,) {final _that = this;
switch (_that) {
case _ChapterData() when $default != null:
return $default(_that.articleid,_that.articlename,_that.chapters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChapterData implements ChapterData {
  const _ChapterData({this.articleid = 0, this.articlename, final  List<ChapterRequestEntity> chapters = const <ChapterRequestEntity>[]}): _chapters = chapters;
  factory _ChapterData.fromJson(Map<String, dynamic> json) => _$ChapterDataFromJson(json);

@override@JsonKey() final  int articleid;
@override final  String? articlename;
 final  List<ChapterRequestEntity> _chapters;
@override@JsonKey() List<ChapterRequestEntity> get chapters {
  if (_chapters is EqualUnmodifiableListView) return _chapters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chapters);
}


/// Create a copy of ChapterData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterDataCopyWith<_ChapterData> get copyWith => __$ChapterDataCopyWithImpl<_ChapterData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChapterDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChapterData&&(identical(other.articleid, articleid) || other.articleid == articleid)&&(identical(other.articlename, articlename) || other.articlename == articlename)&&const DeepCollectionEquality().equals(other._chapters, _chapters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleid,articlename,const DeepCollectionEquality().hash(_chapters));

@override
String toString() {
  return 'ChapterData(articleid: $articleid, articlename: $articlename, chapters: $chapters)';
}


}

/// @nodoc
abstract mixin class _$ChapterDataCopyWith<$Res> implements $ChapterDataCopyWith<$Res> {
  factory _$ChapterDataCopyWith(_ChapterData value, $Res Function(_ChapterData) _then) = __$ChapterDataCopyWithImpl;
@override @useResult
$Res call({
 int articleid, String? articlename, List<ChapterRequestEntity> chapters
});




}
/// @nodoc
class __$ChapterDataCopyWithImpl<$Res>
    implements _$ChapterDataCopyWith<$Res> {
  __$ChapterDataCopyWithImpl(this._self, this._then);

  final _ChapterData _self;
  final $Res Function(_ChapterData) _then;

/// Create a copy of ChapterData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? articleid = null,Object? articlename = freezed,Object? chapters = null,}) {
  return _then(_ChapterData(
articleid: null == articleid ? _self.articleid : articleid // ignore: cast_nullable_to_non_nullable
as int,articlename: freezed == articlename ? _self.articlename : articlename // ignore: cast_nullable_to_non_nullable
as String?,chapters: null == chapters ? _self._chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<ChapterRequestEntity>,
  ));
}


}


/// @nodoc
mixin _$ChapterRequestEntity {

 int get articleid; int get chapterid; String? get chaptername; int get chaptertype; int get words; String? get cover; List<ChapterRequestEntity>? get chapterList;
/// Create a copy of ChapterRequestEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterRequestEntityCopyWith<ChapterRequestEntity> get copyWith => _$ChapterRequestEntityCopyWithImpl<ChapterRequestEntity>(this as ChapterRequestEntity, _$identity);

  /// Serializes this ChapterRequestEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterRequestEntity&&(identical(other.articleid, articleid) || other.articleid == articleid)&&(identical(other.chapterid, chapterid) || other.chapterid == chapterid)&&(identical(other.chaptername, chaptername) || other.chaptername == chaptername)&&(identical(other.chaptertype, chaptertype) || other.chaptertype == chaptertype)&&(identical(other.words, words) || other.words == words)&&(identical(other.cover, cover) || other.cover == cover)&&const DeepCollectionEquality().equals(other.chapterList, chapterList));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleid,chapterid,chaptername,chaptertype,words,cover,const DeepCollectionEquality().hash(chapterList));

@override
String toString() {
  return 'ChapterRequestEntity(articleid: $articleid, chapterid: $chapterid, chaptername: $chaptername, chaptertype: $chaptertype, words: $words, cover: $cover, chapterList: $chapterList)';
}


}

/// @nodoc
abstract mixin class $ChapterRequestEntityCopyWith<$Res>  {
  factory $ChapterRequestEntityCopyWith(ChapterRequestEntity value, $Res Function(ChapterRequestEntity) _then) = _$ChapterRequestEntityCopyWithImpl;
@useResult
$Res call({
 int articleid, int chapterid, String? chaptername, int chaptertype, int words, String? cover, List<ChapterRequestEntity>? chapterList
});




}
/// @nodoc
class _$ChapterRequestEntityCopyWithImpl<$Res>
    implements $ChapterRequestEntityCopyWith<$Res> {
  _$ChapterRequestEntityCopyWithImpl(this._self, this._then);

  final ChapterRequestEntity _self;
  final $Res Function(ChapterRequestEntity) _then;

/// Create a copy of ChapterRequestEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? articleid = null,Object? chapterid = null,Object? chaptername = freezed,Object? chaptertype = null,Object? words = null,Object? cover = freezed,Object? chapterList = freezed,}) {
  return _then(_self.copyWith(
articleid: null == articleid ? _self.articleid : articleid // ignore: cast_nullable_to_non_nullable
as int,chapterid: null == chapterid ? _self.chapterid : chapterid // ignore: cast_nullable_to_non_nullable
as int,chaptername: freezed == chaptername ? _self.chaptername : chaptername // ignore: cast_nullable_to_non_nullable
as String?,chaptertype: null == chaptertype ? _self.chaptertype : chaptertype // ignore: cast_nullable_to_non_nullable
as int,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as int,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String?,chapterList: freezed == chapterList ? _self.chapterList : chapterList // ignore: cast_nullable_to_non_nullable
as List<ChapterRequestEntity>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChapterRequestEntity].
extension ChapterRequestEntityPatterns on ChapterRequestEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChapterRequestEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChapterRequestEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChapterRequestEntity value)  $default,){
final _that = this;
switch (_that) {
case _ChapterRequestEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChapterRequestEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ChapterRequestEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int articleid,  int chapterid,  String? chaptername,  int chaptertype,  int words,  String? cover,  List<ChapterRequestEntity>? chapterList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChapterRequestEntity() when $default != null:
return $default(_that.articleid,_that.chapterid,_that.chaptername,_that.chaptertype,_that.words,_that.cover,_that.chapterList);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int articleid,  int chapterid,  String? chaptername,  int chaptertype,  int words,  String? cover,  List<ChapterRequestEntity>? chapterList)  $default,) {final _that = this;
switch (_that) {
case _ChapterRequestEntity():
return $default(_that.articleid,_that.chapterid,_that.chaptername,_that.chaptertype,_that.words,_that.cover,_that.chapterList);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int articleid,  int chapterid,  String? chaptername,  int chaptertype,  int words,  String? cover,  List<ChapterRequestEntity>? chapterList)?  $default,) {final _that = this;
switch (_that) {
case _ChapterRequestEntity() when $default != null:
return $default(_that.articleid,_that.chapterid,_that.chaptername,_that.chaptertype,_that.words,_that.cover,_that.chapterList);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChapterRequestEntity extends ChapterRequestEntity {
  const _ChapterRequestEntity({this.articleid = 0, this.chapterid = 0, this.chaptername, this.chaptertype = 0, this.words = 0, this.cover, final  List<ChapterRequestEntity>? chapterList}): _chapterList = chapterList,super._();
  factory _ChapterRequestEntity.fromJson(Map<String, dynamic> json) => _$ChapterRequestEntityFromJson(json);

@override@JsonKey() final  int articleid;
@override@JsonKey() final  int chapterid;
@override final  String? chaptername;
@override@JsonKey() final  int chaptertype;
@override@JsonKey() final  int words;
@override final  String? cover;
 final  List<ChapterRequestEntity>? _chapterList;
@override List<ChapterRequestEntity>? get chapterList {
  final value = _chapterList;
  if (value == null) return null;
  if (_chapterList is EqualUnmodifiableListView) return _chapterList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ChapterRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterRequestEntityCopyWith<_ChapterRequestEntity> get copyWith => __$ChapterRequestEntityCopyWithImpl<_ChapterRequestEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChapterRequestEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChapterRequestEntity&&(identical(other.articleid, articleid) || other.articleid == articleid)&&(identical(other.chapterid, chapterid) || other.chapterid == chapterid)&&(identical(other.chaptername, chaptername) || other.chaptername == chaptername)&&(identical(other.chaptertype, chaptertype) || other.chaptertype == chaptertype)&&(identical(other.words, words) || other.words == words)&&(identical(other.cover, cover) || other.cover == cover)&&const DeepCollectionEquality().equals(other._chapterList, _chapterList));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleid,chapterid,chaptername,chaptertype,words,cover,const DeepCollectionEquality().hash(_chapterList));

@override
String toString() {
  return 'ChapterRequestEntity(articleid: $articleid, chapterid: $chapterid, chaptername: $chaptername, chaptertype: $chaptertype, words: $words, cover: $cover, chapterList: $chapterList)';
}


}

/// @nodoc
abstract mixin class _$ChapterRequestEntityCopyWith<$Res> implements $ChapterRequestEntityCopyWith<$Res> {
  factory _$ChapterRequestEntityCopyWith(_ChapterRequestEntity value, $Res Function(_ChapterRequestEntity) _then) = __$ChapterRequestEntityCopyWithImpl;
@override @useResult
$Res call({
 int articleid, int chapterid, String? chaptername, int chaptertype, int words, String? cover, List<ChapterRequestEntity>? chapterList
});




}
/// @nodoc
class __$ChapterRequestEntityCopyWithImpl<$Res>
    implements _$ChapterRequestEntityCopyWith<$Res> {
  __$ChapterRequestEntityCopyWithImpl(this._self, this._then);

  final _ChapterRequestEntity _self;
  final $Res Function(_ChapterRequestEntity) _then;

/// Create a copy of ChapterRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? articleid = null,Object? chapterid = null,Object? chaptername = freezed,Object? chaptertype = null,Object? words = null,Object? cover = freezed,Object? chapterList = freezed,}) {
  return _then(_ChapterRequestEntity(
articleid: null == articleid ? _self.articleid : articleid // ignore: cast_nullable_to_non_nullable
as int,chapterid: null == chapterid ? _self.chapterid : chapterid // ignore: cast_nullable_to_non_nullable
as int,chaptername: freezed == chaptername ? _self.chaptername : chaptername // ignore: cast_nullable_to_non_nullable
as String?,chaptertype: null == chaptertype ? _self.chaptertype : chaptertype // ignore: cast_nullable_to_non_nullable
as int,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as int,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String?,chapterList: freezed == chapterList ? _self._chapterList : chapterList // ignore: cast_nullable_to_non_nullable
as List<ChapterRequestEntity>?,
  ));
}


}

// dart format on
