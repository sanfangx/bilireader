// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'text_request_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TextRequestEntity {

@JsonKey(name: 'articleid') int get articleId;@JsonKey(name: 'chapterid') int get chapterId;@JsonKey(name: 'chaptername') String? get chapterName; String? get text; List<ChapterImageDto> get images; bool get isImage; int get isbody;
/// Create a copy of TextRequestEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextRequestEntityCopyWith<TextRequestEntity> get copyWith => _$TextRequestEntityCopyWithImpl<TextRequestEntity>(this as TextRequestEntity, _$identity);

  /// Serializes this TextRequestEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextRequestEntity&&(identical(other.articleId, articleId) || other.articleId == articleId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.chapterName, chapterName) || other.chapterName == chapterName)&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.images, images)&&(identical(other.isImage, isImage) || other.isImage == isImage)&&(identical(other.isbody, isbody) || other.isbody == isbody));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleId,chapterId,chapterName,text,const DeepCollectionEquality().hash(images),isImage,isbody);

@override
String toString() {
  return 'TextRequestEntity(articleId: $articleId, chapterId: $chapterId, chapterName: $chapterName, text: $text, images: $images, isImage: $isImage, isbody: $isbody)';
}


}

/// @nodoc
abstract mixin class $TextRequestEntityCopyWith<$Res>  {
  factory $TextRequestEntityCopyWith(TextRequestEntity value, $Res Function(TextRequestEntity) _then) = _$TextRequestEntityCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'articleid') int articleId,@JsonKey(name: 'chapterid') int chapterId,@JsonKey(name: 'chaptername') String? chapterName, String? text, List<ChapterImageDto> images, bool isImage, int isbody
});




}
/// @nodoc
class _$TextRequestEntityCopyWithImpl<$Res>
    implements $TextRequestEntityCopyWith<$Res> {
  _$TextRequestEntityCopyWithImpl(this._self, this._then);

  final TextRequestEntity _self;
  final $Res Function(TextRequestEntity) _then;

/// Create a copy of TextRequestEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? articleId = null,Object? chapterId = null,Object? chapterName = freezed,Object? text = freezed,Object? images = null,Object? isImage = null,Object? isbody = null,}) {
  return _then(_self.copyWith(
articleId: null == articleId ? _self.articleId : articleId // ignore: cast_nullable_to_non_nullable
as int,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as int,chapterName: freezed == chapterName ? _self.chapterName : chapterName // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<ChapterImageDto>,isImage: null == isImage ? _self.isImage : isImage // ignore: cast_nullable_to_non_nullable
as bool,isbody: null == isbody ? _self.isbody : isbody // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TextRequestEntity].
extension TextRequestEntityPatterns on TextRequestEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TextRequestEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TextRequestEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TextRequestEntity value)  $default,){
final _that = this;
switch (_that) {
case _TextRequestEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TextRequestEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TextRequestEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'articleid')  int articleId, @JsonKey(name: 'chapterid')  int chapterId, @JsonKey(name: 'chaptername')  String? chapterName,  String? text,  List<ChapterImageDto> images,  bool isImage,  int isbody)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TextRequestEntity() when $default != null:
return $default(_that.articleId,_that.chapterId,_that.chapterName,_that.text,_that.images,_that.isImage,_that.isbody);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'articleid')  int articleId, @JsonKey(name: 'chapterid')  int chapterId, @JsonKey(name: 'chaptername')  String? chapterName,  String? text,  List<ChapterImageDto> images,  bool isImage,  int isbody)  $default,) {final _that = this;
switch (_that) {
case _TextRequestEntity():
return $default(_that.articleId,_that.chapterId,_that.chapterName,_that.text,_that.images,_that.isImage,_that.isbody);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'articleid')  int articleId, @JsonKey(name: 'chapterid')  int chapterId, @JsonKey(name: 'chaptername')  String? chapterName,  String? text,  List<ChapterImageDto> images,  bool isImage,  int isbody)?  $default,) {final _that = this;
switch (_that) {
case _TextRequestEntity() when $default != null:
return $default(_that.articleId,_that.chapterId,_that.chapterName,_that.text,_that.images,_that.isImage,_that.isbody);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TextRequestEntity implements TextRequestEntity {
  const _TextRequestEntity({@JsonKey(name: 'articleid') this.articleId = 0, @JsonKey(name: 'chapterid') this.chapterId = 0, @JsonKey(name: 'chaptername') this.chapterName, this.text, final  List<ChapterImageDto> images = const <ChapterImageDto>[], this.isImage = false, this.isbody = 0}): _images = images;
  factory _TextRequestEntity.fromJson(Map<String, dynamic> json) => _$TextRequestEntityFromJson(json);

@override@JsonKey(name: 'articleid') final  int articleId;
@override@JsonKey(name: 'chapterid') final  int chapterId;
@override@JsonKey(name: 'chaptername') final  String? chapterName;
@override final  String? text;
 final  List<ChapterImageDto> _images;
@override@JsonKey() List<ChapterImageDto> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}

@override@JsonKey() final  bool isImage;
@override@JsonKey() final  int isbody;

/// Create a copy of TextRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TextRequestEntityCopyWith<_TextRequestEntity> get copyWith => __$TextRequestEntityCopyWithImpl<_TextRequestEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TextRequestEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TextRequestEntity&&(identical(other.articleId, articleId) || other.articleId == articleId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.chapterName, chapterName) || other.chapterName == chapterName)&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other._images, _images)&&(identical(other.isImage, isImage) || other.isImage == isImage)&&(identical(other.isbody, isbody) || other.isbody == isbody));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleId,chapterId,chapterName,text,const DeepCollectionEquality().hash(_images),isImage,isbody);

@override
String toString() {
  return 'TextRequestEntity(articleId: $articleId, chapterId: $chapterId, chapterName: $chapterName, text: $text, images: $images, isImage: $isImage, isbody: $isbody)';
}


}

/// @nodoc
abstract mixin class _$TextRequestEntityCopyWith<$Res> implements $TextRequestEntityCopyWith<$Res> {
  factory _$TextRequestEntityCopyWith(_TextRequestEntity value, $Res Function(_TextRequestEntity) _then) = __$TextRequestEntityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'articleid') int articleId,@JsonKey(name: 'chapterid') int chapterId,@JsonKey(name: 'chaptername') String? chapterName, String? text, List<ChapterImageDto> images, bool isImage, int isbody
});




}
/// @nodoc
class __$TextRequestEntityCopyWithImpl<$Res>
    implements _$TextRequestEntityCopyWith<$Res> {
  __$TextRequestEntityCopyWithImpl(this._self, this._then);

  final _TextRequestEntity _self;
  final $Res Function(_TextRequestEntity) _then;

/// Create a copy of TextRequestEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? articleId = null,Object? chapterId = null,Object? chapterName = freezed,Object? text = freezed,Object? images = null,Object? isImage = null,Object? isbody = null,}) {
  return _then(_TextRequestEntity(
articleId: null == articleId ? _self.articleId : articleId // ignore: cast_nullable_to_non_nullable
as int,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as int,chapterName: freezed == chapterName ? _self.chapterName : chapterName // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<ChapterImageDto>,isImage: null == isImage ? _self.isImage : isImage // ignore: cast_nullable_to_non_nullable
as bool,isbody: null == isbody ? _self.isbody : isbody // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ChapterImageDto {

 String? get path;@JsonKey(name: 'aspectRatio') double get aspectRatio;
/// Create a copy of ChapterImageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterImageDtoCopyWith<ChapterImageDto> get copyWith => _$ChapterImageDtoCopyWithImpl<ChapterImageDto>(this as ChapterImageDto, _$identity);

  /// Serializes this ChapterImageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterImageDto&&(identical(other.path, path) || other.path == path)&&(identical(other.aspectRatio, aspectRatio) || other.aspectRatio == aspectRatio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,aspectRatio);

@override
String toString() {
  return 'ChapterImageDto(path: $path, aspectRatio: $aspectRatio)';
}


}

/// @nodoc
abstract mixin class $ChapterImageDtoCopyWith<$Res>  {
  factory $ChapterImageDtoCopyWith(ChapterImageDto value, $Res Function(ChapterImageDto) _then) = _$ChapterImageDtoCopyWithImpl;
@useResult
$Res call({
 String? path,@JsonKey(name: 'aspectRatio') double aspectRatio
});




}
/// @nodoc
class _$ChapterImageDtoCopyWithImpl<$Res>
    implements $ChapterImageDtoCopyWith<$Res> {
  _$ChapterImageDtoCopyWithImpl(this._self, this._then);

  final ChapterImageDto _self;
  final $Res Function(ChapterImageDto) _then;

/// Create a copy of ChapterImageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = freezed,Object? aspectRatio = null,}) {
  return _then(_self.copyWith(
path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,aspectRatio: null == aspectRatio ? _self.aspectRatio : aspectRatio // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ChapterImageDto].
extension ChapterImageDtoPatterns on ChapterImageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChapterImageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChapterImageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChapterImageDto value)  $default,){
final _that = this;
switch (_that) {
case _ChapterImageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChapterImageDto value)?  $default,){
final _that = this;
switch (_that) {
case _ChapterImageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? path, @JsonKey(name: 'aspectRatio')  double aspectRatio)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChapterImageDto() when $default != null:
return $default(_that.path,_that.aspectRatio);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? path, @JsonKey(name: 'aspectRatio')  double aspectRatio)  $default,) {final _that = this;
switch (_that) {
case _ChapterImageDto():
return $default(_that.path,_that.aspectRatio);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? path, @JsonKey(name: 'aspectRatio')  double aspectRatio)?  $default,) {final _that = this;
switch (_that) {
case _ChapterImageDto() when $default != null:
return $default(_that.path,_that.aspectRatio);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChapterImageDto implements ChapterImageDto {
  const _ChapterImageDto({this.path, @JsonKey(name: 'aspectRatio') this.aspectRatio = 0.0});
  factory _ChapterImageDto.fromJson(Map<String, dynamic> json) => _$ChapterImageDtoFromJson(json);

@override final  String? path;
@override@JsonKey(name: 'aspectRatio') final  double aspectRatio;

/// Create a copy of ChapterImageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterImageDtoCopyWith<_ChapterImageDto> get copyWith => __$ChapterImageDtoCopyWithImpl<_ChapterImageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChapterImageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChapterImageDto&&(identical(other.path, path) || other.path == path)&&(identical(other.aspectRatio, aspectRatio) || other.aspectRatio == aspectRatio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,aspectRatio);

@override
String toString() {
  return 'ChapterImageDto(path: $path, aspectRatio: $aspectRatio)';
}


}

/// @nodoc
abstract mixin class _$ChapterImageDtoCopyWith<$Res> implements $ChapterImageDtoCopyWith<$Res> {
  factory _$ChapterImageDtoCopyWith(_ChapterImageDto value, $Res Function(_ChapterImageDto) _then) = __$ChapterImageDtoCopyWithImpl;
@override @useResult
$Res call({
 String? path,@JsonKey(name: 'aspectRatio') double aspectRatio
});




}
/// @nodoc
class __$ChapterImageDtoCopyWithImpl<$Res>
    implements _$ChapterImageDtoCopyWith<$Res> {
  __$ChapterImageDtoCopyWithImpl(this._self, this._then);

  final _ChapterImageDto _self;
  final $Res Function(_ChapterImageDto) _then;

/// Create a copy of ChapterImageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = freezed,Object? aspectRatio = null,}) {
  return _then(_ChapterImageDto(
path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,aspectRatio: null == aspectRatio ? _self.aspectRatio : aspectRatio // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
