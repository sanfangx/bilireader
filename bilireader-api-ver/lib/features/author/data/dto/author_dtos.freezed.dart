// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'author_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthorNovelListDataDto {

 List<NovelResponseEntity> get list; int get total;
/// Create a copy of AuthorNovelListDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthorNovelListDataDtoCopyWith<AuthorNovelListDataDto> get copyWith => _$AuthorNovelListDataDtoCopyWithImpl<AuthorNovelListDataDto>(this as AuthorNovelListDataDto, _$identity);

  /// Serializes this AuthorNovelListDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthorNovelListDataDto&&const DeepCollectionEquality().equals(other.list, list)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list),total);

@override
String toString() {
  return 'AuthorNovelListDataDto(list: $list, total: $total)';
}


}

/// @nodoc
abstract mixin class $AuthorNovelListDataDtoCopyWith<$Res>  {
  factory $AuthorNovelListDataDtoCopyWith(AuthorNovelListDataDto value, $Res Function(AuthorNovelListDataDto) _then) = _$AuthorNovelListDataDtoCopyWithImpl;
@useResult
$Res call({
 List<NovelResponseEntity> list, int total
});




}
/// @nodoc
class _$AuthorNovelListDataDtoCopyWithImpl<$Res>
    implements $AuthorNovelListDataDtoCopyWith<$Res> {
  _$AuthorNovelListDataDtoCopyWithImpl(this._self, this._then);

  final AuthorNovelListDataDto _self;
  final $Res Function(AuthorNovelListDataDto) _then;

/// Create a copy of AuthorNovelListDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = null,Object? total = null,}) {
  return _then(_self.copyWith(
list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<NovelResponseEntity>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthorNovelListDataDto].
extension AuthorNovelListDataDtoPatterns on AuthorNovelListDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthorNovelListDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthorNovelListDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthorNovelListDataDto value)  $default,){
final _that = this;
switch (_that) {
case _AuthorNovelListDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthorNovelListDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _AuthorNovelListDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<NovelResponseEntity> list,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthorNovelListDataDto() when $default != null:
return $default(_that.list,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<NovelResponseEntity> list,  int total)  $default,) {final _that = this;
switch (_that) {
case _AuthorNovelListDataDto():
return $default(_that.list,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<NovelResponseEntity> list,  int total)?  $default,) {final _that = this;
switch (_that) {
case _AuthorNovelListDataDto() when $default != null:
return $default(_that.list,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthorNovelListDataDto implements AuthorNovelListDataDto {
  const _AuthorNovelListDataDto({final  List<NovelResponseEntity> list = const <NovelResponseEntity>[], this.total = 0}): _list = list;
  factory _AuthorNovelListDataDto.fromJson(Map<String, dynamic> json) => _$AuthorNovelListDataDtoFromJson(json);

 final  List<NovelResponseEntity> _list;
@override@JsonKey() List<NovelResponseEntity> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}

@override@JsonKey() final  int total;

/// Create a copy of AuthorNovelListDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthorNovelListDataDtoCopyWith<_AuthorNovelListDataDto> get copyWith => __$AuthorNovelListDataDtoCopyWithImpl<_AuthorNovelListDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthorNovelListDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthorNovelListDataDto&&const DeepCollectionEquality().equals(other._list, _list)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_list),total);

@override
String toString() {
  return 'AuthorNovelListDataDto(list: $list, total: $total)';
}


}

/// @nodoc
abstract mixin class _$AuthorNovelListDataDtoCopyWith<$Res> implements $AuthorNovelListDataDtoCopyWith<$Res> {
  factory _$AuthorNovelListDataDtoCopyWith(_AuthorNovelListDataDto value, $Res Function(_AuthorNovelListDataDto) _then) = __$AuthorNovelListDataDtoCopyWithImpl;
@override @useResult
$Res call({
 List<NovelResponseEntity> list, int total
});




}
/// @nodoc
class __$AuthorNovelListDataDtoCopyWithImpl<$Res>
    implements _$AuthorNovelListDataDtoCopyWith<$Res> {
  __$AuthorNovelListDataDtoCopyWithImpl(this._self, this._then);

  final _AuthorNovelListDataDto _self;
  final $Res Function(_AuthorNovelListDataDto) _then;

/// Create a copy of AuthorNovelListDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = null,Object? total = null,}) {
  return _then(_AuthorNovelListDataDto(
list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<NovelResponseEntity>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AuthorChapterRowDto {

 int get chapterid; int get articleid; int get volumeid; String? get chaptername; int get chapterorder; int get chaptertype; int get words;
/// Create a copy of AuthorChapterRowDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthorChapterRowDtoCopyWith<AuthorChapterRowDto> get copyWith => _$AuthorChapterRowDtoCopyWithImpl<AuthorChapterRowDto>(this as AuthorChapterRowDto, _$identity);

  /// Serializes this AuthorChapterRowDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthorChapterRowDto&&(identical(other.chapterid, chapterid) || other.chapterid == chapterid)&&(identical(other.articleid, articleid) || other.articleid == articleid)&&(identical(other.volumeid, volumeid) || other.volumeid == volumeid)&&(identical(other.chaptername, chaptername) || other.chaptername == chaptername)&&(identical(other.chapterorder, chapterorder) || other.chapterorder == chapterorder)&&(identical(other.chaptertype, chaptertype) || other.chaptertype == chaptertype)&&(identical(other.words, words) || other.words == words));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chapterid,articleid,volumeid,chaptername,chapterorder,chaptertype,words);

@override
String toString() {
  return 'AuthorChapterRowDto(chapterid: $chapterid, articleid: $articleid, volumeid: $volumeid, chaptername: $chaptername, chapterorder: $chapterorder, chaptertype: $chaptertype, words: $words)';
}


}

/// @nodoc
abstract mixin class $AuthorChapterRowDtoCopyWith<$Res>  {
  factory $AuthorChapterRowDtoCopyWith(AuthorChapterRowDto value, $Res Function(AuthorChapterRowDto) _then) = _$AuthorChapterRowDtoCopyWithImpl;
@useResult
$Res call({
 int chapterid, int articleid, int volumeid, String? chaptername, int chapterorder, int chaptertype, int words
});




}
/// @nodoc
class _$AuthorChapterRowDtoCopyWithImpl<$Res>
    implements $AuthorChapterRowDtoCopyWith<$Res> {
  _$AuthorChapterRowDtoCopyWithImpl(this._self, this._then);

  final AuthorChapterRowDto _self;
  final $Res Function(AuthorChapterRowDto) _then;

/// Create a copy of AuthorChapterRowDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chapterid = null,Object? articleid = null,Object? volumeid = null,Object? chaptername = freezed,Object? chapterorder = null,Object? chaptertype = null,Object? words = null,}) {
  return _then(_self.copyWith(
chapterid: null == chapterid ? _self.chapterid : chapterid // ignore: cast_nullable_to_non_nullable
as int,articleid: null == articleid ? _self.articleid : articleid // ignore: cast_nullable_to_non_nullable
as int,volumeid: null == volumeid ? _self.volumeid : volumeid // ignore: cast_nullable_to_non_nullable
as int,chaptername: freezed == chaptername ? _self.chaptername : chaptername // ignore: cast_nullable_to_non_nullable
as String?,chapterorder: null == chapterorder ? _self.chapterorder : chapterorder // ignore: cast_nullable_to_non_nullable
as int,chaptertype: null == chaptertype ? _self.chaptertype : chaptertype // ignore: cast_nullable_to_non_nullable
as int,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthorChapterRowDto].
extension AuthorChapterRowDtoPatterns on AuthorChapterRowDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthorChapterRowDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthorChapterRowDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthorChapterRowDto value)  $default,){
final _that = this;
switch (_that) {
case _AuthorChapterRowDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthorChapterRowDto value)?  $default,){
final _that = this;
switch (_that) {
case _AuthorChapterRowDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int chapterid,  int articleid,  int volumeid,  String? chaptername,  int chapterorder,  int chaptertype,  int words)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthorChapterRowDto() when $default != null:
return $default(_that.chapterid,_that.articleid,_that.volumeid,_that.chaptername,_that.chapterorder,_that.chaptertype,_that.words);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int chapterid,  int articleid,  int volumeid,  String? chaptername,  int chapterorder,  int chaptertype,  int words)  $default,) {final _that = this;
switch (_that) {
case _AuthorChapterRowDto():
return $default(_that.chapterid,_that.articleid,_that.volumeid,_that.chaptername,_that.chapterorder,_that.chaptertype,_that.words);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int chapterid,  int articleid,  int volumeid,  String? chaptername,  int chapterorder,  int chaptertype,  int words)?  $default,) {final _that = this;
switch (_that) {
case _AuthorChapterRowDto() when $default != null:
return $default(_that.chapterid,_that.articleid,_that.volumeid,_that.chaptername,_that.chapterorder,_that.chaptertype,_that.words);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthorChapterRowDto implements AuthorChapterRowDto {
  const _AuthorChapterRowDto({this.chapterid = 0, this.articleid = 0, this.volumeid = 0, this.chaptername, this.chapterorder = 0, this.chaptertype = 0, this.words = 0});
  factory _AuthorChapterRowDto.fromJson(Map<String, dynamic> json) => _$AuthorChapterRowDtoFromJson(json);

@override@JsonKey() final  int chapterid;
@override@JsonKey() final  int articleid;
@override@JsonKey() final  int volumeid;
@override final  String? chaptername;
@override@JsonKey() final  int chapterorder;
@override@JsonKey() final  int chaptertype;
@override@JsonKey() final  int words;

/// Create a copy of AuthorChapterRowDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthorChapterRowDtoCopyWith<_AuthorChapterRowDto> get copyWith => __$AuthorChapterRowDtoCopyWithImpl<_AuthorChapterRowDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthorChapterRowDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthorChapterRowDto&&(identical(other.chapterid, chapterid) || other.chapterid == chapterid)&&(identical(other.articleid, articleid) || other.articleid == articleid)&&(identical(other.volumeid, volumeid) || other.volumeid == volumeid)&&(identical(other.chaptername, chaptername) || other.chaptername == chaptername)&&(identical(other.chapterorder, chapterorder) || other.chapterorder == chapterorder)&&(identical(other.chaptertype, chaptertype) || other.chaptertype == chaptertype)&&(identical(other.words, words) || other.words == words));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chapterid,articleid,volumeid,chaptername,chapterorder,chaptertype,words);

@override
String toString() {
  return 'AuthorChapterRowDto(chapterid: $chapterid, articleid: $articleid, volumeid: $volumeid, chaptername: $chaptername, chapterorder: $chapterorder, chaptertype: $chaptertype, words: $words)';
}


}

/// @nodoc
abstract mixin class _$AuthorChapterRowDtoCopyWith<$Res> implements $AuthorChapterRowDtoCopyWith<$Res> {
  factory _$AuthorChapterRowDtoCopyWith(_AuthorChapterRowDto value, $Res Function(_AuthorChapterRowDto) _then) = __$AuthorChapterRowDtoCopyWithImpl;
@override @useResult
$Res call({
 int chapterid, int articleid, int volumeid, String? chaptername, int chapterorder, int chaptertype, int words
});




}
/// @nodoc
class __$AuthorChapterRowDtoCopyWithImpl<$Res>
    implements _$AuthorChapterRowDtoCopyWith<$Res> {
  __$AuthorChapterRowDtoCopyWithImpl(this._self, this._then);

  final _AuthorChapterRowDto _self;
  final $Res Function(_AuthorChapterRowDto) _then;

/// Create a copy of AuthorChapterRowDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chapterid = null,Object? articleid = null,Object? volumeid = null,Object? chaptername = freezed,Object? chapterorder = null,Object? chaptertype = null,Object? words = null,}) {
  return _then(_AuthorChapterRowDto(
chapterid: null == chapterid ? _self.chapterid : chapterid // ignore: cast_nullable_to_non_nullable
as int,articleid: null == articleid ? _self.articleid : articleid // ignore: cast_nullable_to_non_nullable
as int,volumeid: null == volumeid ? _self.volumeid : volumeid // ignore: cast_nullable_to_non_nullable
as int,chaptername: freezed == chaptername ? _self.chaptername : chaptername // ignore: cast_nullable_to_non_nullable
as String?,chapterorder: null == chapterorder ? _self.chapterorder : chapterorder // ignore: cast_nullable_to_non_nullable
as int,chaptertype: null == chaptertype ? _self.chaptertype : chaptertype // ignore: cast_nullable_to_non_nullable
as int,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AuthorVolumeDto {

 int get chapterid; String? get chaptername;
/// Create a copy of AuthorVolumeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthorVolumeDtoCopyWith<AuthorVolumeDto> get copyWith => _$AuthorVolumeDtoCopyWithImpl<AuthorVolumeDto>(this as AuthorVolumeDto, _$identity);

  /// Serializes this AuthorVolumeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthorVolumeDto&&(identical(other.chapterid, chapterid) || other.chapterid == chapterid)&&(identical(other.chaptername, chaptername) || other.chaptername == chaptername));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chapterid,chaptername);

@override
String toString() {
  return 'AuthorVolumeDto(chapterid: $chapterid, chaptername: $chaptername)';
}


}

/// @nodoc
abstract mixin class $AuthorVolumeDtoCopyWith<$Res>  {
  factory $AuthorVolumeDtoCopyWith(AuthorVolumeDto value, $Res Function(AuthorVolumeDto) _then) = _$AuthorVolumeDtoCopyWithImpl;
@useResult
$Res call({
 int chapterid, String? chaptername
});




}
/// @nodoc
class _$AuthorVolumeDtoCopyWithImpl<$Res>
    implements $AuthorVolumeDtoCopyWith<$Res> {
  _$AuthorVolumeDtoCopyWithImpl(this._self, this._then);

  final AuthorVolumeDto _self;
  final $Res Function(AuthorVolumeDto) _then;

/// Create a copy of AuthorVolumeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chapterid = null,Object? chaptername = freezed,}) {
  return _then(_self.copyWith(
chapterid: null == chapterid ? _self.chapterid : chapterid // ignore: cast_nullable_to_non_nullable
as int,chaptername: freezed == chaptername ? _self.chaptername : chaptername // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthorVolumeDto].
extension AuthorVolumeDtoPatterns on AuthorVolumeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthorVolumeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthorVolumeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthorVolumeDto value)  $default,){
final _that = this;
switch (_that) {
case _AuthorVolumeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthorVolumeDto value)?  $default,){
final _that = this;
switch (_that) {
case _AuthorVolumeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int chapterid,  String? chaptername)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthorVolumeDto() when $default != null:
return $default(_that.chapterid,_that.chaptername);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int chapterid,  String? chaptername)  $default,) {final _that = this;
switch (_that) {
case _AuthorVolumeDto():
return $default(_that.chapterid,_that.chaptername);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int chapterid,  String? chaptername)?  $default,) {final _that = this;
switch (_that) {
case _AuthorVolumeDto() when $default != null:
return $default(_that.chapterid,_that.chaptername);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthorVolumeDto implements AuthorVolumeDto {
  const _AuthorVolumeDto({this.chapterid = 0, this.chaptername});
  factory _AuthorVolumeDto.fromJson(Map<String, dynamic> json) => _$AuthorVolumeDtoFromJson(json);

@override@JsonKey() final  int chapterid;
@override final  String? chaptername;

/// Create a copy of AuthorVolumeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthorVolumeDtoCopyWith<_AuthorVolumeDto> get copyWith => __$AuthorVolumeDtoCopyWithImpl<_AuthorVolumeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthorVolumeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthorVolumeDto&&(identical(other.chapterid, chapterid) || other.chapterid == chapterid)&&(identical(other.chaptername, chaptername) || other.chaptername == chaptername));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chapterid,chaptername);

@override
String toString() {
  return 'AuthorVolumeDto(chapterid: $chapterid, chaptername: $chaptername)';
}


}

/// @nodoc
abstract mixin class _$AuthorVolumeDtoCopyWith<$Res> implements $AuthorVolumeDtoCopyWith<$Res> {
  factory _$AuthorVolumeDtoCopyWith(_AuthorVolumeDto value, $Res Function(_AuthorVolumeDto) _then) = __$AuthorVolumeDtoCopyWithImpl;
@override @useResult
$Res call({
 int chapterid, String? chaptername
});




}
/// @nodoc
class __$AuthorVolumeDtoCopyWithImpl<$Res>
    implements _$AuthorVolumeDtoCopyWith<$Res> {
  __$AuthorVolumeDtoCopyWithImpl(this._self, this._then);

  final _AuthorVolumeDto _self;
  final $Res Function(_AuthorVolumeDto) _then;

/// Create a copy of AuthorVolumeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chapterid = null,Object? chaptername = freezed,}) {
  return _then(_AuthorVolumeDto(
chapterid: null == chapterid ? _self.chapterid : chapterid // ignore: cast_nullable_to_non_nullable
as int,chaptername: freezed == chaptername ? _self.chaptername : chaptername // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AuthorChapterTreeDataDto {

 int get articleid; String? get articlename; List<AuthorVolumeDto> get volumes; List<AuthorChapterRowDto> get flat;
/// Create a copy of AuthorChapterTreeDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthorChapterTreeDataDtoCopyWith<AuthorChapterTreeDataDto> get copyWith => _$AuthorChapterTreeDataDtoCopyWithImpl<AuthorChapterTreeDataDto>(this as AuthorChapterTreeDataDto, _$identity);

  /// Serializes this AuthorChapterTreeDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthorChapterTreeDataDto&&(identical(other.articleid, articleid) || other.articleid == articleid)&&(identical(other.articlename, articlename) || other.articlename == articlename)&&const DeepCollectionEquality().equals(other.volumes, volumes)&&const DeepCollectionEquality().equals(other.flat, flat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleid,articlename,const DeepCollectionEquality().hash(volumes),const DeepCollectionEquality().hash(flat));

@override
String toString() {
  return 'AuthorChapterTreeDataDto(articleid: $articleid, articlename: $articlename, volumes: $volumes, flat: $flat)';
}


}

/// @nodoc
abstract mixin class $AuthorChapterTreeDataDtoCopyWith<$Res>  {
  factory $AuthorChapterTreeDataDtoCopyWith(AuthorChapterTreeDataDto value, $Res Function(AuthorChapterTreeDataDto) _then) = _$AuthorChapterTreeDataDtoCopyWithImpl;
@useResult
$Res call({
 int articleid, String? articlename, List<AuthorVolumeDto> volumes, List<AuthorChapterRowDto> flat
});




}
/// @nodoc
class _$AuthorChapterTreeDataDtoCopyWithImpl<$Res>
    implements $AuthorChapterTreeDataDtoCopyWith<$Res> {
  _$AuthorChapterTreeDataDtoCopyWithImpl(this._self, this._then);

  final AuthorChapterTreeDataDto _self;
  final $Res Function(AuthorChapterTreeDataDto) _then;

/// Create a copy of AuthorChapterTreeDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? articleid = null,Object? articlename = freezed,Object? volumes = null,Object? flat = null,}) {
  return _then(_self.copyWith(
articleid: null == articleid ? _self.articleid : articleid // ignore: cast_nullable_to_non_nullable
as int,articlename: freezed == articlename ? _self.articlename : articlename // ignore: cast_nullable_to_non_nullable
as String?,volumes: null == volumes ? _self.volumes : volumes // ignore: cast_nullable_to_non_nullable
as List<AuthorVolumeDto>,flat: null == flat ? _self.flat : flat // ignore: cast_nullable_to_non_nullable
as List<AuthorChapterRowDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthorChapterTreeDataDto].
extension AuthorChapterTreeDataDtoPatterns on AuthorChapterTreeDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthorChapterTreeDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthorChapterTreeDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthorChapterTreeDataDto value)  $default,){
final _that = this;
switch (_that) {
case _AuthorChapterTreeDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthorChapterTreeDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _AuthorChapterTreeDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int articleid,  String? articlename,  List<AuthorVolumeDto> volumes,  List<AuthorChapterRowDto> flat)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthorChapterTreeDataDto() when $default != null:
return $default(_that.articleid,_that.articlename,_that.volumes,_that.flat);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int articleid,  String? articlename,  List<AuthorVolumeDto> volumes,  List<AuthorChapterRowDto> flat)  $default,) {final _that = this;
switch (_that) {
case _AuthorChapterTreeDataDto():
return $default(_that.articleid,_that.articlename,_that.volumes,_that.flat);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int articleid,  String? articlename,  List<AuthorVolumeDto> volumes,  List<AuthorChapterRowDto> flat)?  $default,) {final _that = this;
switch (_that) {
case _AuthorChapterTreeDataDto() when $default != null:
return $default(_that.articleid,_that.articlename,_that.volumes,_that.flat);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthorChapterTreeDataDto implements AuthorChapterTreeDataDto {
  const _AuthorChapterTreeDataDto({this.articleid = 0, this.articlename, final  List<AuthorVolumeDto> volumes = const <AuthorVolumeDto>[], final  List<AuthorChapterRowDto> flat = const <AuthorChapterRowDto>[]}): _volumes = volumes,_flat = flat;
  factory _AuthorChapterTreeDataDto.fromJson(Map<String, dynamic> json) => _$AuthorChapterTreeDataDtoFromJson(json);

@override@JsonKey() final  int articleid;
@override final  String? articlename;
 final  List<AuthorVolumeDto> _volumes;
@override@JsonKey() List<AuthorVolumeDto> get volumes {
  if (_volumes is EqualUnmodifiableListView) return _volumes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_volumes);
}

 final  List<AuthorChapterRowDto> _flat;
@override@JsonKey() List<AuthorChapterRowDto> get flat {
  if (_flat is EqualUnmodifiableListView) return _flat;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_flat);
}


/// Create a copy of AuthorChapterTreeDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthorChapterTreeDataDtoCopyWith<_AuthorChapterTreeDataDto> get copyWith => __$AuthorChapterTreeDataDtoCopyWithImpl<_AuthorChapterTreeDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthorChapterTreeDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthorChapterTreeDataDto&&(identical(other.articleid, articleid) || other.articleid == articleid)&&(identical(other.articlename, articlename) || other.articlename == articlename)&&const DeepCollectionEquality().equals(other._volumes, _volumes)&&const DeepCollectionEquality().equals(other._flat, _flat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleid,articlename,const DeepCollectionEquality().hash(_volumes),const DeepCollectionEquality().hash(_flat));

@override
String toString() {
  return 'AuthorChapterTreeDataDto(articleid: $articleid, articlename: $articlename, volumes: $volumes, flat: $flat)';
}


}

/// @nodoc
abstract mixin class _$AuthorChapterTreeDataDtoCopyWith<$Res> implements $AuthorChapterTreeDataDtoCopyWith<$Res> {
  factory _$AuthorChapterTreeDataDtoCopyWith(_AuthorChapterTreeDataDto value, $Res Function(_AuthorChapterTreeDataDto) _then) = __$AuthorChapterTreeDataDtoCopyWithImpl;
@override @useResult
$Res call({
 int articleid, String? articlename, List<AuthorVolumeDto> volumes, List<AuthorChapterRowDto> flat
});




}
/// @nodoc
class __$AuthorChapterTreeDataDtoCopyWithImpl<$Res>
    implements _$AuthorChapterTreeDataDtoCopyWith<$Res> {
  __$AuthorChapterTreeDataDtoCopyWithImpl(this._self, this._then);

  final _AuthorChapterTreeDataDto _self;
  final $Res Function(_AuthorChapterTreeDataDto) _then;

/// Create a copy of AuthorChapterTreeDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? articleid = null,Object? articlename = freezed,Object? volumes = null,Object? flat = null,}) {
  return _then(_AuthorChapterTreeDataDto(
articleid: null == articleid ? _self.articleid : articleid // ignore: cast_nullable_to_non_nullable
as int,articlename: freezed == articlename ? _self.articlename : articlename // ignore: cast_nullable_to_non_nullable
as String?,volumes: null == volumes ? _self._volumes : volumes // ignore: cast_nullable_to_non_nullable
as List<AuthorVolumeDto>,flat: null == flat ? _self._flat : flat // ignore: cast_nullable_to_non_nullable
as List<AuthorChapterRowDto>,
  ));
}


}


/// @nodoc
mixin _$AuthorChapterTextDataDto {

 int get articleid; int get chapterid; String? get chaptername; int get isbody; String? get text;
/// Create a copy of AuthorChapterTextDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthorChapterTextDataDtoCopyWith<AuthorChapterTextDataDto> get copyWith => _$AuthorChapterTextDataDtoCopyWithImpl<AuthorChapterTextDataDto>(this as AuthorChapterTextDataDto, _$identity);

  /// Serializes this AuthorChapterTextDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthorChapterTextDataDto&&(identical(other.articleid, articleid) || other.articleid == articleid)&&(identical(other.chapterid, chapterid) || other.chapterid == chapterid)&&(identical(other.chaptername, chaptername) || other.chaptername == chaptername)&&(identical(other.isbody, isbody) || other.isbody == isbody)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleid,chapterid,chaptername,isbody,text);

@override
String toString() {
  return 'AuthorChapterTextDataDto(articleid: $articleid, chapterid: $chapterid, chaptername: $chaptername, isbody: $isbody, text: $text)';
}


}

/// @nodoc
abstract mixin class $AuthorChapterTextDataDtoCopyWith<$Res>  {
  factory $AuthorChapterTextDataDtoCopyWith(AuthorChapterTextDataDto value, $Res Function(AuthorChapterTextDataDto) _then) = _$AuthorChapterTextDataDtoCopyWithImpl;
@useResult
$Res call({
 int articleid, int chapterid, String? chaptername, int isbody, String? text
});




}
/// @nodoc
class _$AuthorChapterTextDataDtoCopyWithImpl<$Res>
    implements $AuthorChapterTextDataDtoCopyWith<$Res> {
  _$AuthorChapterTextDataDtoCopyWithImpl(this._self, this._then);

  final AuthorChapterTextDataDto _self;
  final $Res Function(AuthorChapterTextDataDto) _then;

/// Create a copy of AuthorChapterTextDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? articleid = null,Object? chapterid = null,Object? chaptername = freezed,Object? isbody = null,Object? text = freezed,}) {
  return _then(_self.copyWith(
articleid: null == articleid ? _self.articleid : articleid // ignore: cast_nullable_to_non_nullable
as int,chapterid: null == chapterid ? _self.chapterid : chapterid // ignore: cast_nullable_to_non_nullable
as int,chaptername: freezed == chaptername ? _self.chaptername : chaptername // ignore: cast_nullable_to_non_nullable
as String?,isbody: null == isbody ? _self.isbody : isbody // ignore: cast_nullable_to_non_nullable
as int,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthorChapterTextDataDto].
extension AuthorChapterTextDataDtoPatterns on AuthorChapterTextDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthorChapterTextDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthorChapterTextDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthorChapterTextDataDto value)  $default,){
final _that = this;
switch (_that) {
case _AuthorChapterTextDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthorChapterTextDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _AuthorChapterTextDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int articleid,  int chapterid,  String? chaptername,  int isbody,  String? text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthorChapterTextDataDto() when $default != null:
return $default(_that.articleid,_that.chapterid,_that.chaptername,_that.isbody,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int articleid,  int chapterid,  String? chaptername,  int isbody,  String? text)  $default,) {final _that = this;
switch (_that) {
case _AuthorChapterTextDataDto():
return $default(_that.articleid,_that.chapterid,_that.chaptername,_that.isbody,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int articleid,  int chapterid,  String? chaptername,  int isbody,  String? text)?  $default,) {final _that = this;
switch (_that) {
case _AuthorChapterTextDataDto() when $default != null:
return $default(_that.articleid,_that.chapterid,_that.chaptername,_that.isbody,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthorChapterTextDataDto implements AuthorChapterTextDataDto {
  const _AuthorChapterTextDataDto({this.articleid = 0, this.chapterid = 0, this.chaptername, this.isbody = 1, this.text});
  factory _AuthorChapterTextDataDto.fromJson(Map<String, dynamic> json) => _$AuthorChapterTextDataDtoFromJson(json);

@override@JsonKey() final  int articleid;
@override@JsonKey() final  int chapterid;
@override final  String? chaptername;
@override@JsonKey() final  int isbody;
@override final  String? text;

/// Create a copy of AuthorChapterTextDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthorChapterTextDataDtoCopyWith<_AuthorChapterTextDataDto> get copyWith => __$AuthorChapterTextDataDtoCopyWithImpl<_AuthorChapterTextDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthorChapterTextDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthorChapterTextDataDto&&(identical(other.articleid, articleid) || other.articleid == articleid)&&(identical(other.chapterid, chapterid) || other.chapterid == chapterid)&&(identical(other.chaptername, chaptername) || other.chaptername == chaptername)&&(identical(other.isbody, isbody) || other.isbody == isbody)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleid,chapterid,chaptername,isbody,text);

@override
String toString() {
  return 'AuthorChapterTextDataDto(articleid: $articleid, chapterid: $chapterid, chaptername: $chaptername, isbody: $isbody, text: $text)';
}


}

/// @nodoc
abstract mixin class _$AuthorChapterTextDataDtoCopyWith<$Res> implements $AuthorChapterTextDataDtoCopyWith<$Res> {
  factory _$AuthorChapterTextDataDtoCopyWith(_AuthorChapterTextDataDto value, $Res Function(_AuthorChapterTextDataDto) _then) = __$AuthorChapterTextDataDtoCopyWithImpl;
@override @useResult
$Res call({
 int articleid, int chapterid, String? chaptername, int isbody, String? text
});




}
/// @nodoc
class __$AuthorChapterTextDataDtoCopyWithImpl<$Res>
    implements _$AuthorChapterTextDataDtoCopyWith<$Res> {
  __$AuthorChapterTextDataDtoCopyWithImpl(this._self, this._then);

  final _AuthorChapterTextDataDto _self;
  final $Res Function(_AuthorChapterTextDataDto) _then;

/// Create a copy of AuthorChapterTextDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? articleid = null,Object? chapterid = null,Object? chaptername = freezed,Object? isbody = null,Object? text = freezed,}) {
  return _then(_AuthorChapterTextDataDto(
articleid: null == articleid ? _self.articleid : articleid // ignore: cast_nullable_to_non_nullable
as int,chapterid: null == chapterid ? _self.chapterid : chapterid // ignore: cast_nullable_to_non_nullable
as int,chaptername: freezed == chaptername ? _self.chaptername : chaptername // ignore: cast_nullable_to_non_nullable
as String?,isbody: null == isbody ? _self.isbody : isbody // ignore: cast_nullable_to_non_nullable
as int,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AuthorDraftItemDto {

 int get draftid; int get articleid; int get volumeid; String? get chaptername; String? get chaptercontent; int get words; int get lastupdate; int get ispub; int get isbody;
/// Create a copy of AuthorDraftItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthorDraftItemDtoCopyWith<AuthorDraftItemDto> get copyWith => _$AuthorDraftItemDtoCopyWithImpl<AuthorDraftItemDto>(this as AuthorDraftItemDto, _$identity);

  /// Serializes this AuthorDraftItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthorDraftItemDto&&(identical(other.draftid, draftid) || other.draftid == draftid)&&(identical(other.articleid, articleid) || other.articleid == articleid)&&(identical(other.volumeid, volumeid) || other.volumeid == volumeid)&&(identical(other.chaptername, chaptername) || other.chaptername == chaptername)&&(identical(other.chaptercontent, chaptercontent) || other.chaptercontent == chaptercontent)&&(identical(other.words, words) || other.words == words)&&(identical(other.lastupdate, lastupdate) || other.lastupdate == lastupdate)&&(identical(other.ispub, ispub) || other.ispub == ispub)&&(identical(other.isbody, isbody) || other.isbody == isbody));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,draftid,articleid,volumeid,chaptername,chaptercontent,words,lastupdate,ispub,isbody);

@override
String toString() {
  return 'AuthorDraftItemDto(draftid: $draftid, articleid: $articleid, volumeid: $volumeid, chaptername: $chaptername, chaptercontent: $chaptercontent, words: $words, lastupdate: $lastupdate, ispub: $ispub, isbody: $isbody)';
}


}

/// @nodoc
abstract mixin class $AuthorDraftItemDtoCopyWith<$Res>  {
  factory $AuthorDraftItemDtoCopyWith(AuthorDraftItemDto value, $Res Function(AuthorDraftItemDto) _then) = _$AuthorDraftItemDtoCopyWithImpl;
@useResult
$Res call({
 int draftid, int articleid, int volumeid, String? chaptername, String? chaptercontent, int words, int lastupdate, int ispub, int isbody
});




}
/// @nodoc
class _$AuthorDraftItemDtoCopyWithImpl<$Res>
    implements $AuthorDraftItemDtoCopyWith<$Res> {
  _$AuthorDraftItemDtoCopyWithImpl(this._self, this._then);

  final AuthorDraftItemDto _self;
  final $Res Function(AuthorDraftItemDto) _then;

/// Create a copy of AuthorDraftItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? draftid = null,Object? articleid = null,Object? volumeid = null,Object? chaptername = freezed,Object? chaptercontent = freezed,Object? words = null,Object? lastupdate = null,Object? ispub = null,Object? isbody = null,}) {
  return _then(_self.copyWith(
draftid: null == draftid ? _self.draftid : draftid // ignore: cast_nullable_to_non_nullable
as int,articleid: null == articleid ? _self.articleid : articleid // ignore: cast_nullable_to_non_nullable
as int,volumeid: null == volumeid ? _self.volumeid : volumeid // ignore: cast_nullable_to_non_nullable
as int,chaptername: freezed == chaptername ? _self.chaptername : chaptername // ignore: cast_nullable_to_non_nullable
as String?,chaptercontent: freezed == chaptercontent ? _self.chaptercontent : chaptercontent // ignore: cast_nullable_to_non_nullable
as String?,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as int,lastupdate: null == lastupdate ? _self.lastupdate : lastupdate // ignore: cast_nullable_to_non_nullable
as int,ispub: null == ispub ? _self.ispub : ispub // ignore: cast_nullable_to_non_nullable
as int,isbody: null == isbody ? _self.isbody : isbody // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthorDraftItemDto].
extension AuthorDraftItemDtoPatterns on AuthorDraftItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthorDraftItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthorDraftItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthorDraftItemDto value)  $default,){
final _that = this;
switch (_that) {
case _AuthorDraftItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthorDraftItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _AuthorDraftItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int draftid,  int articleid,  int volumeid,  String? chaptername,  String? chaptercontent,  int words,  int lastupdate,  int ispub,  int isbody)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthorDraftItemDto() when $default != null:
return $default(_that.draftid,_that.articleid,_that.volumeid,_that.chaptername,_that.chaptercontent,_that.words,_that.lastupdate,_that.ispub,_that.isbody);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int draftid,  int articleid,  int volumeid,  String? chaptername,  String? chaptercontent,  int words,  int lastupdate,  int ispub,  int isbody)  $default,) {final _that = this;
switch (_that) {
case _AuthorDraftItemDto():
return $default(_that.draftid,_that.articleid,_that.volumeid,_that.chaptername,_that.chaptercontent,_that.words,_that.lastupdate,_that.ispub,_that.isbody);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int draftid,  int articleid,  int volumeid,  String? chaptername,  String? chaptercontent,  int words,  int lastupdate,  int ispub,  int isbody)?  $default,) {final _that = this;
switch (_that) {
case _AuthorDraftItemDto() when $default != null:
return $default(_that.draftid,_that.articleid,_that.volumeid,_that.chaptername,_that.chaptercontent,_that.words,_that.lastupdate,_that.ispub,_that.isbody);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthorDraftItemDto implements AuthorDraftItemDto {
  const _AuthorDraftItemDto({this.draftid = 0, this.articleid = 0, this.volumeid = 0, this.chaptername, this.chaptercontent, this.words = 0, this.lastupdate = 0, this.ispub = 0, this.isbody = 1});
  factory _AuthorDraftItemDto.fromJson(Map<String, dynamic> json) => _$AuthorDraftItemDtoFromJson(json);

@override@JsonKey() final  int draftid;
@override@JsonKey() final  int articleid;
@override@JsonKey() final  int volumeid;
@override final  String? chaptername;
@override final  String? chaptercontent;
@override@JsonKey() final  int words;
@override@JsonKey() final  int lastupdate;
@override@JsonKey() final  int ispub;
@override@JsonKey() final  int isbody;

/// Create a copy of AuthorDraftItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthorDraftItemDtoCopyWith<_AuthorDraftItemDto> get copyWith => __$AuthorDraftItemDtoCopyWithImpl<_AuthorDraftItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthorDraftItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthorDraftItemDto&&(identical(other.draftid, draftid) || other.draftid == draftid)&&(identical(other.articleid, articleid) || other.articleid == articleid)&&(identical(other.volumeid, volumeid) || other.volumeid == volumeid)&&(identical(other.chaptername, chaptername) || other.chaptername == chaptername)&&(identical(other.chaptercontent, chaptercontent) || other.chaptercontent == chaptercontent)&&(identical(other.words, words) || other.words == words)&&(identical(other.lastupdate, lastupdate) || other.lastupdate == lastupdate)&&(identical(other.ispub, ispub) || other.ispub == ispub)&&(identical(other.isbody, isbody) || other.isbody == isbody));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,draftid,articleid,volumeid,chaptername,chaptercontent,words,lastupdate,ispub,isbody);

@override
String toString() {
  return 'AuthorDraftItemDto(draftid: $draftid, articleid: $articleid, volumeid: $volumeid, chaptername: $chaptername, chaptercontent: $chaptercontent, words: $words, lastupdate: $lastupdate, ispub: $ispub, isbody: $isbody)';
}


}

/// @nodoc
abstract mixin class _$AuthorDraftItemDtoCopyWith<$Res> implements $AuthorDraftItemDtoCopyWith<$Res> {
  factory _$AuthorDraftItemDtoCopyWith(_AuthorDraftItemDto value, $Res Function(_AuthorDraftItemDto) _then) = __$AuthorDraftItemDtoCopyWithImpl;
@override @useResult
$Res call({
 int draftid, int articleid, int volumeid, String? chaptername, String? chaptercontent, int words, int lastupdate, int ispub, int isbody
});




}
/// @nodoc
class __$AuthorDraftItemDtoCopyWithImpl<$Res>
    implements _$AuthorDraftItemDtoCopyWith<$Res> {
  __$AuthorDraftItemDtoCopyWithImpl(this._self, this._then);

  final _AuthorDraftItemDto _self;
  final $Res Function(_AuthorDraftItemDto) _then;

/// Create a copy of AuthorDraftItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? draftid = null,Object? articleid = null,Object? volumeid = null,Object? chaptername = freezed,Object? chaptercontent = freezed,Object? words = null,Object? lastupdate = null,Object? ispub = null,Object? isbody = null,}) {
  return _then(_AuthorDraftItemDto(
draftid: null == draftid ? _self.draftid : draftid // ignore: cast_nullable_to_non_nullable
as int,articleid: null == articleid ? _self.articleid : articleid // ignore: cast_nullable_to_non_nullable
as int,volumeid: null == volumeid ? _self.volumeid : volumeid // ignore: cast_nullable_to_non_nullable
as int,chaptername: freezed == chaptername ? _self.chaptername : chaptername // ignore: cast_nullable_to_non_nullable
as String?,chaptercontent: freezed == chaptercontent ? _self.chaptercontent : chaptercontent // ignore: cast_nullable_to_non_nullable
as String?,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as int,lastupdate: null == lastupdate ? _self.lastupdate : lastupdate // ignore: cast_nullable_to_non_nullable
as int,ispub: null == ispub ? _self.ispub : ispub // ignore: cast_nullable_to_non_nullable
as int,isbody: null == isbody ? _self.isbody : isbody // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ChapterAttachUploadDataDto {

 int get attachId; String? get previewUrl; String? get insertHtml; String? get insertToken; String? get fileName; int get size;
/// Create a copy of ChapterAttachUploadDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterAttachUploadDataDtoCopyWith<ChapterAttachUploadDataDto> get copyWith => _$ChapterAttachUploadDataDtoCopyWithImpl<ChapterAttachUploadDataDto>(this as ChapterAttachUploadDataDto, _$identity);

  /// Serializes this ChapterAttachUploadDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterAttachUploadDataDto&&(identical(other.attachId, attachId) || other.attachId == attachId)&&(identical(other.previewUrl, previewUrl) || other.previewUrl == previewUrl)&&(identical(other.insertHtml, insertHtml) || other.insertHtml == insertHtml)&&(identical(other.insertToken, insertToken) || other.insertToken == insertToken)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attachId,previewUrl,insertHtml,insertToken,fileName,size);

@override
String toString() {
  return 'ChapterAttachUploadDataDto(attachId: $attachId, previewUrl: $previewUrl, insertHtml: $insertHtml, insertToken: $insertToken, fileName: $fileName, size: $size)';
}


}

/// @nodoc
abstract mixin class $ChapterAttachUploadDataDtoCopyWith<$Res>  {
  factory $ChapterAttachUploadDataDtoCopyWith(ChapterAttachUploadDataDto value, $Res Function(ChapterAttachUploadDataDto) _then) = _$ChapterAttachUploadDataDtoCopyWithImpl;
@useResult
$Res call({
 int attachId, String? previewUrl, String? insertHtml, String? insertToken, String? fileName, int size
});




}
/// @nodoc
class _$ChapterAttachUploadDataDtoCopyWithImpl<$Res>
    implements $ChapterAttachUploadDataDtoCopyWith<$Res> {
  _$ChapterAttachUploadDataDtoCopyWithImpl(this._self, this._then);

  final ChapterAttachUploadDataDto _self;
  final $Res Function(ChapterAttachUploadDataDto) _then;

/// Create a copy of ChapterAttachUploadDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attachId = null,Object? previewUrl = freezed,Object? insertHtml = freezed,Object? insertToken = freezed,Object? fileName = freezed,Object? size = null,}) {
  return _then(_self.copyWith(
attachId: null == attachId ? _self.attachId : attachId // ignore: cast_nullable_to_non_nullable
as int,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,insertHtml: freezed == insertHtml ? _self.insertHtml : insertHtml // ignore: cast_nullable_to_non_nullable
as String?,insertToken: freezed == insertToken ? _self.insertToken : insertToken // ignore: cast_nullable_to_non_nullable
as String?,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChapterAttachUploadDataDto].
extension ChapterAttachUploadDataDtoPatterns on ChapterAttachUploadDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChapterAttachUploadDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChapterAttachUploadDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChapterAttachUploadDataDto value)  $default,){
final _that = this;
switch (_that) {
case _ChapterAttachUploadDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChapterAttachUploadDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _ChapterAttachUploadDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int attachId,  String? previewUrl,  String? insertHtml,  String? insertToken,  String? fileName,  int size)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChapterAttachUploadDataDto() when $default != null:
return $default(_that.attachId,_that.previewUrl,_that.insertHtml,_that.insertToken,_that.fileName,_that.size);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int attachId,  String? previewUrl,  String? insertHtml,  String? insertToken,  String? fileName,  int size)  $default,) {final _that = this;
switch (_that) {
case _ChapterAttachUploadDataDto():
return $default(_that.attachId,_that.previewUrl,_that.insertHtml,_that.insertToken,_that.fileName,_that.size);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int attachId,  String? previewUrl,  String? insertHtml,  String? insertToken,  String? fileName,  int size)?  $default,) {final _that = this;
switch (_that) {
case _ChapterAttachUploadDataDto() when $default != null:
return $default(_that.attachId,_that.previewUrl,_that.insertHtml,_that.insertToken,_that.fileName,_that.size);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChapterAttachUploadDataDto implements ChapterAttachUploadDataDto {
  const _ChapterAttachUploadDataDto({this.attachId = 0, this.previewUrl, this.insertHtml, this.insertToken, this.fileName, this.size = 0});
  factory _ChapterAttachUploadDataDto.fromJson(Map<String, dynamic> json) => _$ChapterAttachUploadDataDtoFromJson(json);

@override@JsonKey() final  int attachId;
@override final  String? previewUrl;
@override final  String? insertHtml;
@override final  String? insertToken;
@override final  String? fileName;
@override@JsonKey() final  int size;

/// Create a copy of ChapterAttachUploadDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterAttachUploadDataDtoCopyWith<_ChapterAttachUploadDataDto> get copyWith => __$ChapterAttachUploadDataDtoCopyWithImpl<_ChapterAttachUploadDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChapterAttachUploadDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChapterAttachUploadDataDto&&(identical(other.attachId, attachId) || other.attachId == attachId)&&(identical(other.previewUrl, previewUrl) || other.previewUrl == previewUrl)&&(identical(other.insertHtml, insertHtml) || other.insertHtml == insertHtml)&&(identical(other.insertToken, insertToken) || other.insertToken == insertToken)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attachId,previewUrl,insertHtml,insertToken,fileName,size);

@override
String toString() {
  return 'ChapterAttachUploadDataDto(attachId: $attachId, previewUrl: $previewUrl, insertHtml: $insertHtml, insertToken: $insertToken, fileName: $fileName, size: $size)';
}


}

/// @nodoc
abstract mixin class _$ChapterAttachUploadDataDtoCopyWith<$Res> implements $ChapterAttachUploadDataDtoCopyWith<$Res> {
  factory _$ChapterAttachUploadDataDtoCopyWith(_ChapterAttachUploadDataDto value, $Res Function(_ChapterAttachUploadDataDto) _then) = __$ChapterAttachUploadDataDtoCopyWithImpl;
@override @useResult
$Res call({
 int attachId, String? previewUrl, String? insertHtml, String? insertToken, String? fileName, int size
});




}
/// @nodoc
class __$ChapterAttachUploadDataDtoCopyWithImpl<$Res>
    implements _$ChapterAttachUploadDataDtoCopyWith<$Res> {
  __$ChapterAttachUploadDataDtoCopyWithImpl(this._self, this._then);

  final _ChapterAttachUploadDataDto _self;
  final $Res Function(_ChapterAttachUploadDataDto) _then;

/// Create a copy of ChapterAttachUploadDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attachId = null,Object? previewUrl = freezed,Object? insertHtml = freezed,Object? insertToken = freezed,Object? fileName = freezed,Object? size = null,}) {
  return _then(_ChapterAttachUploadDataDto(
attachId: null == attachId ? _self.attachId : attachId // ignore: cast_nullable_to_non_nullable
as int,previewUrl: freezed == previewUrl ? _self.previewUrl : previewUrl // ignore: cast_nullable_to_non_nullable
as String?,insertHtml: freezed == insertHtml ? _self.insertHtml : insertHtml // ignore: cast_nullable_to_non_nullable
as String?,insertToken: freezed == insertToken ? _self.insertToken : insertToken // ignore: cast_nullable_to_non_nullable
as String?,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
