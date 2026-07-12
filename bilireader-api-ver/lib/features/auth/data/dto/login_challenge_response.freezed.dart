// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_challenge_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoginChallengeResponse {

 String get challenge; String get challengeId; int get expiresIn; int get timestamp;
/// Create a copy of LoginChallengeResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginChallengeResponseCopyWith<LoginChallengeResponse> get copyWith => _$LoginChallengeResponseCopyWithImpl<LoginChallengeResponse>(this as LoginChallengeResponse, _$identity);

  /// Serializes this LoginChallengeResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginChallengeResponse&&(identical(other.challenge, challenge) || other.challenge == challenge)&&(identical(other.challengeId, challengeId) || other.challengeId == challengeId)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,challenge,challengeId,expiresIn,timestamp);

@override
String toString() {
  return 'LoginChallengeResponse(challenge: $challenge, challengeId: $challengeId, expiresIn: $expiresIn, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $LoginChallengeResponseCopyWith<$Res>  {
  factory $LoginChallengeResponseCopyWith(LoginChallengeResponse value, $Res Function(LoginChallengeResponse) _then) = _$LoginChallengeResponseCopyWithImpl;
@useResult
$Res call({
 String challenge, String challengeId, int expiresIn, int timestamp
});




}
/// @nodoc
class _$LoginChallengeResponseCopyWithImpl<$Res>
    implements $LoginChallengeResponseCopyWith<$Res> {
  _$LoginChallengeResponseCopyWithImpl(this._self, this._then);

  final LoginChallengeResponse _self;
  final $Res Function(LoginChallengeResponse) _then;

/// Create a copy of LoginChallengeResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? challenge = null,Object? challengeId = null,Object? expiresIn = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
challenge: null == challenge ? _self.challenge : challenge // ignore: cast_nullable_to_non_nullable
as String,challengeId: null == challengeId ? _self.challengeId : challengeId // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginChallengeResponse].
extension LoginChallengeResponsePatterns on LoginChallengeResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginChallengeResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginChallengeResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginChallengeResponse value)  $default,){
final _that = this;
switch (_that) {
case _LoginChallengeResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginChallengeResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LoginChallengeResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String challenge,  String challengeId,  int expiresIn,  int timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginChallengeResponse() when $default != null:
return $default(_that.challenge,_that.challengeId,_that.expiresIn,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String challenge,  String challengeId,  int expiresIn,  int timestamp)  $default,) {final _that = this;
switch (_that) {
case _LoginChallengeResponse():
return $default(_that.challenge,_that.challengeId,_that.expiresIn,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String challenge,  String challengeId,  int expiresIn,  int timestamp)?  $default,) {final _that = this;
switch (_that) {
case _LoginChallengeResponse() when $default != null:
return $default(_that.challenge,_that.challengeId,_that.expiresIn,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoginChallengeResponse implements LoginChallengeResponse {
  const _LoginChallengeResponse({this.challenge = '', this.challengeId = '', this.expiresIn = 0, this.timestamp = 0});
  factory _LoginChallengeResponse.fromJson(Map<String, dynamic> json) => _$LoginChallengeResponseFromJson(json);

@override@JsonKey() final  String challenge;
@override@JsonKey() final  String challengeId;
@override@JsonKey() final  int expiresIn;
@override@JsonKey() final  int timestamp;

/// Create a copy of LoginChallengeResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginChallengeResponseCopyWith<_LoginChallengeResponse> get copyWith => __$LoginChallengeResponseCopyWithImpl<_LoginChallengeResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoginChallengeResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginChallengeResponse&&(identical(other.challenge, challenge) || other.challenge == challenge)&&(identical(other.challengeId, challengeId) || other.challengeId == challengeId)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,challenge,challengeId,expiresIn,timestamp);

@override
String toString() {
  return 'LoginChallengeResponse(challenge: $challenge, challengeId: $challengeId, expiresIn: $expiresIn, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$LoginChallengeResponseCopyWith<$Res> implements $LoginChallengeResponseCopyWith<$Res> {
  factory _$LoginChallengeResponseCopyWith(_LoginChallengeResponse value, $Res Function(_LoginChallengeResponse) _then) = __$LoginChallengeResponseCopyWithImpl;
@override @useResult
$Res call({
 String challenge, String challengeId, int expiresIn, int timestamp
});




}
/// @nodoc
class __$LoginChallengeResponseCopyWithImpl<$Res>
    implements _$LoginChallengeResponseCopyWith<$Res> {
  __$LoginChallengeResponseCopyWithImpl(this._self, this._then);

  final _LoginChallengeResponse _self;
  final $Res Function(_LoginChallengeResponse) _then;

/// Create a copy of LoginChallengeResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? challenge = null,Object? challengeId = null,Object? expiresIn = null,Object? timestamp = null,}) {
  return _then(_LoginChallengeResponse(
challenge: null == challenge ? _self.challenge : challenge // ignore: cast_nullable_to_non_nullable
as String,challengeId: null == challengeId ? _self.challengeId : challengeId // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
