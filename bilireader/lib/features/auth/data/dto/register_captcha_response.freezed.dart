// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_captcha_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegisterCaptchaResponse {

 String get captchaId; String get img; int get expiresIn;
/// Create a copy of RegisterCaptchaResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterCaptchaResponseCopyWith<RegisterCaptchaResponse> get copyWith => _$RegisterCaptchaResponseCopyWithImpl<RegisterCaptchaResponse>(this as RegisterCaptchaResponse, _$identity);

  /// Serializes this RegisterCaptchaResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterCaptchaResponse&&(identical(other.captchaId, captchaId) || other.captchaId == captchaId)&&(identical(other.img, img) || other.img == img)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,captchaId,img,expiresIn);

@override
String toString() {
  return 'RegisterCaptchaResponse(captchaId: $captchaId, img: $img, expiresIn: $expiresIn)';
}


}

/// @nodoc
abstract mixin class $RegisterCaptchaResponseCopyWith<$Res>  {
  factory $RegisterCaptchaResponseCopyWith(RegisterCaptchaResponse value, $Res Function(RegisterCaptchaResponse) _then) = _$RegisterCaptchaResponseCopyWithImpl;
@useResult
$Res call({
 String captchaId, String img, int expiresIn
});




}
/// @nodoc
class _$RegisterCaptchaResponseCopyWithImpl<$Res>
    implements $RegisterCaptchaResponseCopyWith<$Res> {
  _$RegisterCaptchaResponseCopyWithImpl(this._self, this._then);

  final RegisterCaptchaResponse _self;
  final $Res Function(RegisterCaptchaResponse) _then;

/// Create a copy of RegisterCaptchaResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? captchaId = null,Object? img = null,Object? expiresIn = null,}) {
  return _then(_self.copyWith(
captchaId: null == captchaId ? _self.captchaId : captchaId // ignore: cast_nullable_to_non_nullable
as String,img: null == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisterCaptchaResponse].
extension RegisterCaptchaResponsePatterns on RegisterCaptchaResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterCaptchaResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterCaptchaResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterCaptchaResponse value)  $default,){
final _that = this;
switch (_that) {
case _RegisterCaptchaResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterCaptchaResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterCaptchaResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String captchaId,  String img,  int expiresIn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterCaptchaResponse() when $default != null:
return $default(_that.captchaId,_that.img,_that.expiresIn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String captchaId,  String img,  int expiresIn)  $default,) {final _that = this;
switch (_that) {
case _RegisterCaptchaResponse():
return $default(_that.captchaId,_that.img,_that.expiresIn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String captchaId,  String img,  int expiresIn)?  $default,) {final _that = this;
switch (_that) {
case _RegisterCaptchaResponse() when $default != null:
return $default(_that.captchaId,_that.img,_that.expiresIn);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegisterCaptchaResponse implements RegisterCaptchaResponse {
  const _RegisterCaptchaResponse({this.captchaId = '', this.img = '', this.expiresIn = 0});
  factory _RegisterCaptchaResponse.fromJson(Map<String, dynamic> json) => _$RegisterCaptchaResponseFromJson(json);

@override@JsonKey() final  String captchaId;
@override@JsonKey() final  String img;
@override@JsonKey() final  int expiresIn;

/// Create a copy of RegisterCaptchaResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterCaptchaResponseCopyWith<_RegisterCaptchaResponse> get copyWith => __$RegisterCaptchaResponseCopyWithImpl<_RegisterCaptchaResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisterCaptchaResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterCaptchaResponse&&(identical(other.captchaId, captchaId) || other.captchaId == captchaId)&&(identical(other.img, img) || other.img == img)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,captchaId,img,expiresIn);

@override
String toString() {
  return 'RegisterCaptchaResponse(captchaId: $captchaId, img: $img, expiresIn: $expiresIn)';
}


}

/// @nodoc
abstract mixin class _$RegisterCaptchaResponseCopyWith<$Res> implements $RegisterCaptchaResponseCopyWith<$Res> {
  factory _$RegisterCaptchaResponseCopyWith(_RegisterCaptchaResponse value, $Res Function(_RegisterCaptchaResponse) _then) = __$RegisterCaptchaResponseCopyWithImpl;
@override @useResult
$Res call({
 String captchaId, String img, int expiresIn
});




}
/// @nodoc
class __$RegisterCaptchaResponseCopyWithImpl<$Res>
    implements _$RegisterCaptchaResponseCopyWith<$Res> {
  __$RegisterCaptchaResponseCopyWithImpl(this._self, this._then);

  final _RegisterCaptchaResponse _self;
  final $Res Function(_RegisterCaptchaResponse) _then;

/// Create a copy of RegisterCaptchaResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? captchaId = null,Object? img = null,Object? expiresIn = null,}) {
  return _then(_RegisterCaptchaResponse(
captchaId: null == captchaId ? _self.captchaId : captchaId // ignore: cast_nullable_to_non_nullable
as String,img: null == img ? _self.img : img // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
