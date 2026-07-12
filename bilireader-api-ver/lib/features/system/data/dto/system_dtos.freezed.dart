// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SignInResponseDto {

 int get points; int get totalScore;
/// Create a copy of SignInResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignInResponseDtoCopyWith<SignInResponseDto> get copyWith => _$SignInResponseDtoCopyWithImpl<SignInResponseDto>(this as SignInResponseDto, _$identity);

  /// Serializes this SignInResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignInResponseDto&&(identical(other.points, points) || other.points == points)&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,points,totalScore);

@override
String toString() {
  return 'SignInResponseDto(points: $points, totalScore: $totalScore)';
}


}

/// @nodoc
abstract mixin class $SignInResponseDtoCopyWith<$Res>  {
  factory $SignInResponseDtoCopyWith(SignInResponseDto value, $Res Function(SignInResponseDto) _then) = _$SignInResponseDtoCopyWithImpl;
@useResult
$Res call({
 int points, int totalScore
});




}
/// @nodoc
class _$SignInResponseDtoCopyWithImpl<$Res>
    implements $SignInResponseDtoCopyWith<$Res> {
  _$SignInResponseDtoCopyWithImpl(this._self, this._then);

  final SignInResponseDto _self;
  final $Res Function(SignInResponseDto) _then;

/// Create a copy of SignInResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? points = null,Object? totalScore = null,}) {
  return _then(_self.copyWith(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SignInResponseDto].
extension SignInResponseDtoPatterns on SignInResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignInResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignInResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignInResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _SignInResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignInResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _SignInResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int points,  int totalScore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SignInResponseDto() when $default != null:
return $default(_that.points,_that.totalScore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int points,  int totalScore)  $default,) {final _that = this;
switch (_that) {
case _SignInResponseDto():
return $default(_that.points,_that.totalScore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int points,  int totalScore)?  $default,) {final _that = this;
switch (_that) {
case _SignInResponseDto() when $default != null:
return $default(_that.points,_that.totalScore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SignInResponseDto implements SignInResponseDto {
  const _SignInResponseDto({this.points = 3, this.totalScore = 0});
  factory _SignInResponseDto.fromJson(Map<String, dynamic> json) => _$SignInResponseDtoFromJson(json);

@override@JsonKey() final  int points;
@override@JsonKey() final  int totalScore;

/// Create a copy of SignInResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignInResponseDtoCopyWith<_SignInResponseDto> get copyWith => __$SignInResponseDtoCopyWithImpl<_SignInResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SignInResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignInResponseDto&&(identical(other.points, points) || other.points == points)&&(identical(other.totalScore, totalScore) || other.totalScore == totalScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,points,totalScore);

@override
String toString() {
  return 'SignInResponseDto(points: $points, totalScore: $totalScore)';
}


}

/// @nodoc
abstract mixin class _$SignInResponseDtoCopyWith<$Res> implements $SignInResponseDtoCopyWith<$Res> {
  factory _$SignInResponseDtoCopyWith(_SignInResponseDto value, $Res Function(_SignInResponseDto) _then) = __$SignInResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 int points, int totalScore
});




}
/// @nodoc
class __$SignInResponseDtoCopyWithImpl<$Res>
    implements _$SignInResponseDtoCopyWith<$Res> {
  __$SignInResponseDtoCopyWithImpl(this._self, this._then);

  final _SignInResponseDto _self;
  final $Res Function(_SignInResponseDto) _then;

/// Create a copy of SignInResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? points = null,Object? totalScore = null,}) {
  return _then(_SignInResponseDto(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,totalScore: null == totalScore ? _self.totalScore : totalScore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$VersionLogItemDto {

 String? get versionName; String? get updateContent; bool get current;
/// Create a copy of VersionLogItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VersionLogItemDtoCopyWith<VersionLogItemDto> get copyWith => _$VersionLogItemDtoCopyWithImpl<VersionLogItemDto>(this as VersionLogItemDto, _$identity);

  /// Serializes this VersionLogItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VersionLogItemDto&&(identical(other.versionName, versionName) || other.versionName == versionName)&&(identical(other.updateContent, updateContent) || other.updateContent == updateContent)&&(identical(other.current, current) || other.current == current));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,versionName,updateContent,current);

@override
String toString() {
  return 'VersionLogItemDto(versionName: $versionName, updateContent: $updateContent, current: $current)';
}


}

/// @nodoc
abstract mixin class $VersionLogItemDtoCopyWith<$Res>  {
  factory $VersionLogItemDtoCopyWith(VersionLogItemDto value, $Res Function(VersionLogItemDto) _then) = _$VersionLogItemDtoCopyWithImpl;
@useResult
$Res call({
 String? versionName, String? updateContent, bool current
});




}
/// @nodoc
class _$VersionLogItemDtoCopyWithImpl<$Res>
    implements $VersionLogItemDtoCopyWith<$Res> {
  _$VersionLogItemDtoCopyWithImpl(this._self, this._then);

  final VersionLogItemDto _self;
  final $Res Function(VersionLogItemDto) _then;

/// Create a copy of VersionLogItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? versionName = freezed,Object? updateContent = freezed,Object? current = null,}) {
  return _then(_self.copyWith(
versionName: freezed == versionName ? _self.versionName : versionName // ignore: cast_nullable_to_non_nullable
as String?,updateContent: freezed == updateContent ? _self.updateContent : updateContent // ignore: cast_nullable_to_non_nullable
as String?,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [VersionLogItemDto].
extension VersionLogItemDtoPatterns on VersionLogItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VersionLogItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VersionLogItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VersionLogItemDto value)  $default,){
final _that = this;
switch (_that) {
case _VersionLogItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VersionLogItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _VersionLogItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? versionName,  String? updateContent,  bool current)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VersionLogItemDto() when $default != null:
return $default(_that.versionName,_that.updateContent,_that.current);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? versionName,  String? updateContent,  bool current)  $default,) {final _that = this;
switch (_that) {
case _VersionLogItemDto():
return $default(_that.versionName,_that.updateContent,_that.current);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? versionName,  String? updateContent,  bool current)?  $default,) {final _that = this;
switch (_that) {
case _VersionLogItemDto() when $default != null:
return $default(_that.versionName,_that.updateContent,_that.current);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VersionLogItemDto implements VersionLogItemDto {
  const _VersionLogItemDto({this.versionName, this.updateContent, this.current = false});
  factory _VersionLogItemDto.fromJson(Map<String, dynamic> json) => _$VersionLogItemDtoFromJson(json);

@override final  String? versionName;
@override final  String? updateContent;
@override@JsonKey() final  bool current;

/// Create a copy of VersionLogItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VersionLogItemDtoCopyWith<_VersionLogItemDto> get copyWith => __$VersionLogItemDtoCopyWithImpl<_VersionLogItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VersionLogItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VersionLogItemDto&&(identical(other.versionName, versionName) || other.versionName == versionName)&&(identical(other.updateContent, updateContent) || other.updateContent == updateContent)&&(identical(other.current, current) || other.current == current));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,versionName,updateContent,current);

@override
String toString() {
  return 'VersionLogItemDto(versionName: $versionName, updateContent: $updateContent, current: $current)';
}


}

/// @nodoc
abstract mixin class _$VersionLogItemDtoCopyWith<$Res> implements $VersionLogItemDtoCopyWith<$Res> {
  factory _$VersionLogItemDtoCopyWith(_VersionLogItemDto value, $Res Function(_VersionLogItemDto) _then) = __$VersionLogItemDtoCopyWithImpl;
@override @useResult
$Res call({
 String? versionName, String? updateContent, bool current
});




}
/// @nodoc
class __$VersionLogItemDtoCopyWithImpl<$Res>
    implements _$VersionLogItemDtoCopyWith<$Res> {
  __$VersionLogItemDtoCopyWithImpl(this._self, this._then);

  final _VersionLogItemDto _self;
  final $Res Function(_VersionLogItemDto) _then;

/// Create a copy of VersionLogItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? versionName = freezed,Object? updateContent = freezed,Object? current = null,}) {
  return _then(_VersionLogItemDto(
versionName: freezed == versionName ? _self.versionName : versionName // ignore: cast_nullable_to_non_nullable
as String?,updateContent: freezed == updateContent ? _self.updateContent : updateContent // ignore: cast_nullable_to_non_nullable
as String?,current: null == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AppStartupAnnouncementDto {

 int? get bid; String? get title; String? get content; String? get actionText; String? get actionUrl; String? get dismissKey; String? get description; String? get latestVersionName; int? get latestVersionCode; String? get latestUpdateContent;
/// Create a copy of AppStartupAnnouncementDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppStartupAnnouncementDtoCopyWith<AppStartupAnnouncementDto> get copyWith => _$AppStartupAnnouncementDtoCopyWithImpl<AppStartupAnnouncementDto>(this as AppStartupAnnouncementDto, _$identity);

  /// Serializes this AppStartupAnnouncementDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppStartupAnnouncementDto&&(identical(other.bid, bid) || other.bid == bid)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.actionText, actionText) || other.actionText == actionText)&&(identical(other.actionUrl, actionUrl) || other.actionUrl == actionUrl)&&(identical(other.dismissKey, dismissKey) || other.dismissKey == dismissKey)&&(identical(other.description, description) || other.description == description)&&(identical(other.latestVersionName, latestVersionName) || other.latestVersionName == latestVersionName)&&(identical(other.latestVersionCode, latestVersionCode) || other.latestVersionCode == latestVersionCode)&&(identical(other.latestUpdateContent, latestUpdateContent) || other.latestUpdateContent == latestUpdateContent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bid,title,content,actionText,actionUrl,dismissKey,description,latestVersionName,latestVersionCode,latestUpdateContent);

@override
String toString() {
  return 'AppStartupAnnouncementDto(bid: $bid, title: $title, content: $content, actionText: $actionText, actionUrl: $actionUrl, dismissKey: $dismissKey, description: $description, latestVersionName: $latestVersionName, latestVersionCode: $latestVersionCode, latestUpdateContent: $latestUpdateContent)';
}


}

/// @nodoc
abstract mixin class $AppStartupAnnouncementDtoCopyWith<$Res>  {
  factory $AppStartupAnnouncementDtoCopyWith(AppStartupAnnouncementDto value, $Res Function(AppStartupAnnouncementDto) _then) = _$AppStartupAnnouncementDtoCopyWithImpl;
@useResult
$Res call({
 int? bid, String? title, String? content, String? actionText, String? actionUrl, String? dismissKey, String? description, String? latestVersionName, int? latestVersionCode, String? latestUpdateContent
});




}
/// @nodoc
class _$AppStartupAnnouncementDtoCopyWithImpl<$Res>
    implements $AppStartupAnnouncementDtoCopyWith<$Res> {
  _$AppStartupAnnouncementDtoCopyWithImpl(this._self, this._then);

  final AppStartupAnnouncementDto _self;
  final $Res Function(AppStartupAnnouncementDto) _then;

/// Create a copy of AppStartupAnnouncementDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bid = freezed,Object? title = freezed,Object? content = freezed,Object? actionText = freezed,Object? actionUrl = freezed,Object? dismissKey = freezed,Object? description = freezed,Object? latestVersionName = freezed,Object? latestVersionCode = freezed,Object? latestUpdateContent = freezed,}) {
  return _then(_self.copyWith(
bid: freezed == bid ? _self.bid : bid // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,actionText: freezed == actionText ? _self.actionText : actionText // ignore: cast_nullable_to_non_nullable
as String?,actionUrl: freezed == actionUrl ? _self.actionUrl : actionUrl // ignore: cast_nullable_to_non_nullable
as String?,dismissKey: freezed == dismissKey ? _self.dismissKey : dismissKey // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,latestVersionName: freezed == latestVersionName ? _self.latestVersionName : latestVersionName // ignore: cast_nullable_to_non_nullable
as String?,latestVersionCode: freezed == latestVersionCode ? _self.latestVersionCode : latestVersionCode // ignore: cast_nullable_to_non_nullable
as int?,latestUpdateContent: freezed == latestUpdateContent ? _self.latestUpdateContent : latestUpdateContent // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppStartupAnnouncementDto].
extension AppStartupAnnouncementDtoPatterns on AppStartupAnnouncementDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppStartupAnnouncementDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppStartupAnnouncementDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppStartupAnnouncementDto value)  $default,){
final _that = this;
switch (_that) {
case _AppStartupAnnouncementDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppStartupAnnouncementDto value)?  $default,){
final _that = this;
switch (_that) {
case _AppStartupAnnouncementDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? bid,  String? title,  String? content,  String? actionText,  String? actionUrl,  String? dismissKey,  String? description,  String? latestVersionName,  int? latestVersionCode,  String? latestUpdateContent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppStartupAnnouncementDto() when $default != null:
return $default(_that.bid,_that.title,_that.content,_that.actionText,_that.actionUrl,_that.dismissKey,_that.description,_that.latestVersionName,_that.latestVersionCode,_that.latestUpdateContent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? bid,  String? title,  String? content,  String? actionText,  String? actionUrl,  String? dismissKey,  String? description,  String? latestVersionName,  int? latestVersionCode,  String? latestUpdateContent)  $default,) {final _that = this;
switch (_that) {
case _AppStartupAnnouncementDto():
return $default(_that.bid,_that.title,_that.content,_that.actionText,_that.actionUrl,_that.dismissKey,_that.description,_that.latestVersionName,_that.latestVersionCode,_that.latestUpdateContent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? bid,  String? title,  String? content,  String? actionText,  String? actionUrl,  String? dismissKey,  String? description,  String? latestVersionName,  int? latestVersionCode,  String? latestUpdateContent)?  $default,) {final _that = this;
switch (_that) {
case _AppStartupAnnouncementDto() when $default != null:
return $default(_that.bid,_that.title,_that.content,_that.actionText,_that.actionUrl,_that.dismissKey,_that.description,_that.latestVersionName,_that.latestVersionCode,_that.latestUpdateContent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppStartupAnnouncementDto implements AppStartupAnnouncementDto {
  const _AppStartupAnnouncementDto({this.bid, this.title, this.content, this.actionText, this.actionUrl, this.dismissKey, this.description, this.latestVersionName, this.latestVersionCode, this.latestUpdateContent});
  factory _AppStartupAnnouncementDto.fromJson(Map<String, dynamic> json) => _$AppStartupAnnouncementDtoFromJson(json);

@override final  int? bid;
@override final  String? title;
@override final  String? content;
@override final  String? actionText;
@override final  String? actionUrl;
@override final  String? dismissKey;
@override final  String? description;
@override final  String? latestVersionName;
@override final  int? latestVersionCode;
@override final  String? latestUpdateContent;

/// Create a copy of AppStartupAnnouncementDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppStartupAnnouncementDtoCopyWith<_AppStartupAnnouncementDto> get copyWith => __$AppStartupAnnouncementDtoCopyWithImpl<_AppStartupAnnouncementDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppStartupAnnouncementDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppStartupAnnouncementDto&&(identical(other.bid, bid) || other.bid == bid)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.actionText, actionText) || other.actionText == actionText)&&(identical(other.actionUrl, actionUrl) || other.actionUrl == actionUrl)&&(identical(other.dismissKey, dismissKey) || other.dismissKey == dismissKey)&&(identical(other.description, description) || other.description == description)&&(identical(other.latestVersionName, latestVersionName) || other.latestVersionName == latestVersionName)&&(identical(other.latestVersionCode, latestVersionCode) || other.latestVersionCode == latestVersionCode)&&(identical(other.latestUpdateContent, latestUpdateContent) || other.latestUpdateContent == latestUpdateContent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bid,title,content,actionText,actionUrl,dismissKey,description,latestVersionName,latestVersionCode,latestUpdateContent);

@override
String toString() {
  return 'AppStartupAnnouncementDto(bid: $bid, title: $title, content: $content, actionText: $actionText, actionUrl: $actionUrl, dismissKey: $dismissKey, description: $description, latestVersionName: $latestVersionName, latestVersionCode: $latestVersionCode, latestUpdateContent: $latestUpdateContent)';
}


}

/// @nodoc
abstract mixin class _$AppStartupAnnouncementDtoCopyWith<$Res> implements $AppStartupAnnouncementDtoCopyWith<$Res> {
  factory _$AppStartupAnnouncementDtoCopyWith(_AppStartupAnnouncementDto value, $Res Function(_AppStartupAnnouncementDto) _then) = __$AppStartupAnnouncementDtoCopyWithImpl;
@override @useResult
$Res call({
 int? bid, String? title, String? content, String? actionText, String? actionUrl, String? dismissKey, String? description, String? latestVersionName, int? latestVersionCode, String? latestUpdateContent
});




}
/// @nodoc
class __$AppStartupAnnouncementDtoCopyWithImpl<$Res>
    implements _$AppStartupAnnouncementDtoCopyWith<$Res> {
  __$AppStartupAnnouncementDtoCopyWithImpl(this._self, this._then);

  final _AppStartupAnnouncementDto _self;
  final $Res Function(_AppStartupAnnouncementDto) _then;

/// Create a copy of AppStartupAnnouncementDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bid = freezed,Object? title = freezed,Object? content = freezed,Object? actionText = freezed,Object? actionUrl = freezed,Object? dismissKey = freezed,Object? description = freezed,Object? latestVersionName = freezed,Object? latestVersionCode = freezed,Object? latestUpdateContent = freezed,}) {
  return _then(_AppStartupAnnouncementDto(
bid: freezed == bid ? _self.bid : bid // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,actionText: freezed == actionText ? _self.actionText : actionText // ignore: cast_nullable_to_non_nullable
as String?,actionUrl: freezed == actionUrl ? _self.actionUrl : actionUrl // ignore: cast_nullable_to_non_nullable
as String?,dismissKey: freezed == dismissKey ? _self.dismissKey : dismissKey // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,latestVersionName: freezed == latestVersionName ? _self.latestVersionName : latestVersionName // ignore: cast_nullable_to_non_nullable
as String?,latestVersionCode: freezed == latestVersionCode ? _self.latestVersionCode : latestVersionCode // ignore: cast_nullable_to_non_nullable
as int?,latestUpdateContent: freezed == latestUpdateContent ? _self.latestUpdateContent : latestUpdateContent // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$FeedbackSubmitResponseDto {

 int get reportId;
/// Create a copy of FeedbackSubmitResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedbackSubmitResponseDtoCopyWith<FeedbackSubmitResponseDto> get copyWith => _$FeedbackSubmitResponseDtoCopyWithImpl<FeedbackSubmitResponseDto>(this as FeedbackSubmitResponseDto, _$identity);

  /// Serializes this FeedbackSubmitResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedbackSubmitResponseDto&&(identical(other.reportId, reportId) || other.reportId == reportId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportId);

@override
String toString() {
  return 'FeedbackSubmitResponseDto(reportId: $reportId)';
}


}

/// @nodoc
abstract mixin class $FeedbackSubmitResponseDtoCopyWith<$Res>  {
  factory $FeedbackSubmitResponseDtoCopyWith(FeedbackSubmitResponseDto value, $Res Function(FeedbackSubmitResponseDto) _then) = _$FeedbackSubmitResponseDtoCopyWithImpl;
@useResult
$Res call({
 int reportId
});




}
/// @nodoc
class _$FeedbackSubmitResponseDtoCopyWithImpl<$Res>
    implements $FeedbackSubmitResponseDtoCopyWith<$Res> {
  _$FeedbackSubmitResponseDtoCopyWithImpl(this._self, this._then);

  final FeedbackSubmitResponseDto _self;
  final $Res Function(FeedbackSubmitResponseDto) _then;

/// Create a copy of FeedbackSubmitResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reportId = null,}) {
  return _then(_self.copyWith(
reportId: null == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedbackSubmitResponseDto].
extension FeedbackSubmitResponseDtoPatterns on FeedbackSubmitResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedbackSubmitResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedbackSubmitResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedbackSubmitResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _FeedbackSubmitResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedbackSubmitResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _FeedbackSubmitResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int reportId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedbackSubmitResponseDto() when $default != null:
return $default(_that.reportId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int reportId)  $default,) {final _that = this;
switch (_that) {
case _FeedbackSubmitResponseDto():
return $default(_that.reportId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int reportId)?  $default,) {final _that = this;
switch (_that) {
case _FeedbackSubmitResponseDto() when $default != null:
return $default(_that.reportId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedbackSubmitResponseDto implements FeedbackSubmitResponseDto {
  const _FeedbackSubmitResponseDto({this.reportId = 0});
  factory _FeedbackSubmitResponseDto.fromJson(Map<String, dynamic> json) => _$FeedbackSubmitResponseDtoFromJson(json);

@override@JsonKey() final  int reportId;

/// Create a copy of FeedbackSubmitResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedbackSubmitResponseDtoCopyWith<_FeedbackSubmitResponseDto> get copyWith => __$FeedbackSubmitResponseDtoCopyWithImpl<_FeedbackSubmitResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedbackSubmitResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedbackSubmitResponseDto&&(identical(other.reportId, reportId) || other.reportId == reportId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reportId);

@override
String toString() {
  return 'FeedbackSubmitResponseDto(reportId: $reportId)';
}


}

/// @nodoc
abstract mixin class _$FeedbackSubmitResponseDtoCopyWith<$Res> implements $FeedbackSubmitResponseDtoCopyWith<$Res> {
  factory _$FeedbackSubmitResponseDtoCopyWith(_FeedbackSubmitResponseDto value, $Res Function(_FeedbackSubmitResponseDto) _then) = __$FeedbackSubmitResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 int reportId
});




}
/// @nodoc
class __$FeedbackSubmitResponseDtoCopyWithImpl<$Res>
    implements _$FeedbackSubmitResponseDtoCopyWith<$Res> {
  __$FeedbackSubmitResponseDtoCopyWithImpl(this._self, this._then);

  final _FeedbackSubmitResponseDto _self;
  final $Res Function(_FeedbackSubmitResponseDto) _then;

/// Create a copy of FeedbackSubmitResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reportId = null,}) {
  return _then(_FeedbackSubmitResponseDto(
reportId: null == reportId ? _self.reportId : reportId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
