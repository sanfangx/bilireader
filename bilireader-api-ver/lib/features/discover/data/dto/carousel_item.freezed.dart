// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'carousel_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CarouselItem {

@JsonKey(name: 'articleid') int get articleId;@JsonKey(name: 'coverImg') String? get coverImg; String? get describe;
/// Create a copy of CarouselItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CarouselItemCopyWith<CarouselItem> get copyWith => _$CarouselItemCopyWithImpl<CarouselItem>(this as CarouselItem, _$identity);

  /// Serializes this CarouselItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CarouselItem&&(identical(other.articleId, articleId) || other.articleId == articleId)&&(identical(other.coverImg, coverImg) || other.coverImg == coverImg)&&(identical(other.describe, describe) || other.describe == describe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleId,coverImg,describe);

@override
String toString() {
  return 'CarouselItem(articleId: $articleId, coverImg: $coverImg, describe: $describe)';
}


}

/// @nodoc
abstract mixin class $CarouselItemCopyWith<$Res>  {
  factory $CarouselItemCopyWith(CarouselItem value, $Res Function(CarouselItem) _then) = _$CarouselItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'articleid') int articleId,@JsonKey(name: 'coverImg') String? coverImg, String? describe
});




}
/// @nodoc
class _$CarouselItemCopyWithImpl<$Res>
    implements $CarouselItemCopyWith<$Res> {
  _$CarouselItemCopyWithImpl(this._self, this._then);

  final CarouselItem _self;
  final $Res Function(CarouselItem) _then;

/// Create a copy of CarouselItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? articleId = null,Object? coverImg = freezed,Object? describe = freezed,}) {
  return _then(_self.copyWith(
articleId: null == articleId ? _self.articleId : articleId // ignore: cast_nullable_to_non_nullable
as int,coverImg: freezed == coverImg ? _self.coverImg : coverImg // ignore: cast_nullable_to_non_nullable
as String?,describe: freezed == describe ? _self.describe : describe // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CarouselItem].
extension CarouselItemPatterns on CarouselItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CarouselItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CarouselItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CarouselItem value)  $default,){
final _that = this;
switch (_that) {
case _CarouselItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CarouselItem value)?  $default,){
final _that = this;
switch (_that) {
case _CarouselItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'articleid')  int articleId, @JsonKey(name: 'coverImg')  String? coverImg,  String? describe)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CarouselItem() when $default != null:
return $default(_that.articleId,_that.coverImg,_that.describe);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'articleid')  int articleId, @JsonKey(name: 'coverImg')  String? coverImg,  String? describe)  $default,) {final _that = this;
switch (_that) {
case _CarouselItem():
return $default(_that.articleId,_that.coverImg,_that.describe);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'articleid')  int articleId, @JsonKey(name: 'coverImg')  String? coverImg,  String? describe)?  $default,) {final _that = this;
switch (_that) {
case _CarouselItem() when $default != null:
return $default(_that.articleId,_that.coverImg,_that.describe);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CarouselItem implements CarouselItem {
  const _CarouselItem({@JsonKey(name: 'articleid') this.articleId = 0, @JsonKey(name: 'coverImg') this.coverImg, this.describe});
  factory _CarouselItem.fromJson(Map<String, dynamic> json) => _$CarouselItemFromJson(json);

@override@JsonKey(name: 'articleid') final  int articleId;
@override@JsonKey(name: 'coverImg') final  String? coverImg;
@override final  String? describe;

/// Create a copy of CarouselItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CarouselItemCopyWith<_CarouselItem> get copyWith => __$CarouselItemCopyWithImpl<_CarouselItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CarouselItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CarouselItem&&(identical(other.articleId, articleId) || other.articleId == articleId)&&(identical(other.coverImg, coverImg) || other.coverImg == coverImg)&&(identical(other.describe, describe) || other.describe == describe));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleId,coverImg,describe);

@override
String toString() {
  return 'CarouselItem(articleId: $articleId, coverImg: $coverImg, describe: $describe)';
}


}

/// @nodoc
abstract mixin class _$CarouselItemCopyWith<$Res> implements $CarouselItemCopyWith<$Res> {
  factory _$CarouselItemCopyWith(_CarouselItem value, $Res Function(_CarouselItem) _then) = __$CarouselItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'articleid') int articleId,@JsonKey(name: 'coverImg') String? coverImg, String? describe
});




}
/// @nodoc
class __$CarouselItemCopyWithImpl<$Res>
    implements _$CarouselItemCopyWith<$Res> {
  __$CarouselItemCopyWithImpl(this._self, this._then);

  final _CarouselItem _self;
  final $Res Function(_CarouselItem) _then;

/// Create a copy of CarouselItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? articleId = null,Object? coverImg = freezed,Object? describe = freezed,}) {
  return _then(_CarouselItem(
articleId: null == articleId ? _self.articleId : articleId // ignore: cast_nullable_to_non_nullable
as int,coverImg: freezed == coverImg ? _self.coverImg : coverImg // ignore: cast_nullable_to_non_nullable
as String?,describe: freezed == describe ? _self.describe : describe // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
