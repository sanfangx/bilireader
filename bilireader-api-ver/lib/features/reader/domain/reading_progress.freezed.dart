// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReadingProgress {

 int get ownerUid; ReaderAnchor get anchor; String get articleName; String get poster; int get updatedAt;
/// Create a copy of ReadingProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReadingProgressCopyWith<ReadingProgress> get copyWith => _$ReadingProgressCopyWithImpl<ReadingProgress>(this as ReadingProgress, _$identity);

  /// Serializes this ReadingProgress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReadingProgress&&(identical(other.ownerUid, ownerUid) || other.ownerUid == ownerUid)&&(identical(other.anchor, anchor) || other.anchor == anchor)&&(identical(other.articleName, articleName) || other.articleName == articleName)&&(identical(other.poster, poster) || other.poster == poster)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ownerUid,anchor,articleName,poster,updatedAt);

@override
String toString() {
  return 'ReadingProgress(ownerUid: $ownerUid, anchor: $anchor, articleName: $articleName, poster: $poster, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ReadingProgressCopyWith<$Res>  {
  factory $ReadingProgressCopyWith(ReadingProgress value, $Res Function(ReadingProgress) _then) = _$ReadingProgressCopyWithImpl;
@useResult
$Res call({
 int ownerUid, ReaderAnchor anchor, String articleName, String poster, int updatedAt
});


$ReaderAnchorCopyWith<$Res> get anchor;

}
/// @nodoc
class _$ReadingProgressCopyWithImpl<$Res>
    implements $ReadingProgressCopyWith<$Res> {
  _$ReadingProgressCopyWithImpl(this._self, this._then);

  final ReadingProgress _self;
  final $Res Function(ReadingProgress) _then;

/// Create a copy of ReadingProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ownerUid = null,Object? anchor = null,Object? articleName = null,Object? poster = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
ownerUid: null == ownerUid ? _self.ownerUid : ownerUid // ignore: cast_nullable_to_non_nullable
as int,anchor: null == anchor ? _self.anchor : anchor // ignore: cast_nullable_to_non_nullable
as ReaderAnchor,articleName: null == articleName ? _self.articleName : articleName // ignore: cast_nullable_to_non_nullable
as String,poster: null == poster ? _self.poster : poster // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ReadingProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReaderAnchorCopyWith<$Res> get anchor {
  
  return $ReaderAnchorCopyWith<$Res>(_self.anchor, (value) {
    return _then(_self.copyWith(anchor: value));
  });
}
}


/// Adds pattern-matching-related methods to [ReadingProgress].
extension ReadingProgressPatterns on ReadingProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReadingProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReadingProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReadingProgress value)  $default,){
final _that = this;
switch (_that) {
case _ReadingProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReadingProgress value)?  $default,){
final _that = this;
switch (_that) {
case _ReadingProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int ownerUid,  ReaderAnchor anchor,  String articleName,  String poster,  int updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReadingProgress() when $default != null:
return $default(_that.ownerUid,_that.anchor,_that.articleName,_that.poster,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int ownerUid,  ReaderAnchor anchor,  String articleName,  String poster,  int updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ReadingProgress():
return $default(_that.ownerUid,_that.anchor,_that.articleName,_that.poster,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int ownerUid,  ReaderAnchor anchor,  String articleName,  String poster,  int updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ReadingProgress() when $default != null:
return $default(_that.ownerUid,_that.anchor,_that.articleName,_that.poster,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReadingProgress implements ReadingProgress {
  const _ReadingProgress({required this.ownerUid, required this.anchor, this.articleName = '', this.poster = '', this.updatedAt = 0});
  factory _ReadingProgress.fromJson(Map<String, dynamic> json) => _$ReadingProgressFromJson(json);

@override final  int ownerUid;
@override final  ReaderAnchor anchor;
@override@JsonKey() final  String articleName;
@override@JsonKey() final  String poster;
@override@JsonKey() final  int updatedAt;

/// Create a copy of ReadingProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadingProgressCopyWith<_ReadingProgress> get copyWith => __$ReadingProgressCopyWithImpl<_ReadingProgress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReadingProgressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadingProgress&&(identical(other.ownerUid, ownerUid) || other.ownerUid == ownerUid)&&(identical(other.anchor, anchor) || other.anchor == anchor)&&(identical(other.articleName, articleName) || other.articleName == articleName)&&(identical(other.poster, poster) || other.poster == poster)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ownerUid,anchor,articleName,poster,updatedAt);

@override
String toString() {
  return 'ReadingProgress(ownerUid: $ownerUid, anchor: $anchor, articleName: $articleName, poster: $poster, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReadingProgressCopyWith<$Res> implements $ReadingProgressCopyWith<$Res> {
  factory _$ReadingProgressCopyWith(_ReadingProgress value, $Res Function(_ReadingProgress) _then) = __$ReadingProgressCopyWithImpl;
@override @useResult
$Res call({
 int ownerUid, ReaderAnchor anchor, String articleName, String poster, int updatedAt
});


@override $ReaderAnchorCopyWith<$Res> get anchor;

}
/// @nodoc
class __$ReadingProgressCopyWithImpl<$Res>
    implements _$ReadingProgressCopyWith<$Res> {
  __$ReadingProgressCopyWithImpl(this._self, this._then);

  final _ReadingProgress _self;
  final $Res Function(_ReadingProgress) _then;

/// Create a copy of ReadingProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ownerUid = null,Object? anchor = null,Object? articleName = null,Object? poster = null,Object? updatedAt = null,}) {
  return _then(_ReadingProgress(
ownerUid: null == ownerUid ? _self.ownerUid : ownerUid // ignore: cast_nullable_to_non_nullable
as int,anchor: null == anchor ? _self.anchor : anchor // ignore: cast_nullable_to_non_nullable
as ReaderAnchor,articleName: null == articleName ? _self.articleName : articleName // ignore: cast_nullable_to_non_nullable
as String,poster: null == poster ? _self.poster : poster // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ReadingProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReaderAnchorCopyWith<$Res> get anchor {
  
  return $ReaderAnchorCopyWith<$Res>(_self.anchor, (value) {
    return _then(_self.copyWith(anchor: value));
  });
}
}

// dart format on
