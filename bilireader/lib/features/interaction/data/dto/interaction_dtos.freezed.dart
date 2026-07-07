// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'interaction_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NovelVotesDto {

 int get allVote; int get articleid; int get dayVote; int get monthVote; bool get todayVoted; bool get userVoted; int get weekVote;
/// Create a copy of NovelVotesDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NovelVotesDtoCopyWith<NovelVotesDto> get copyWith => _$NovelVotesDtoCopyWithImpl<NovelVotesDto>(this as NovelVotesDto, _$identity);

  /// Serializes this NovelVotesDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NovelVotesDto&&(identical(other.allVote, allVote) || other.allVote == allVote)&&(identical(other.articleid, articleid) || other.articleid == articleid)&&(identical(other.dayVote, dayVote) || other.dayVote == dayVote)&&(identical(other.monthVote, monthVote) || other.monthVote == monthVote)&&(identical(other.todayVoted, todayVoted) || other.todayVoted == todayVoted)&&(identical(other.userVoted, userVoted) || other.userVoted == userVoted)&&(identical(other.weekVote, weekVote) || other.weekVote == weekVote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,allVote,articleid,dayVote,monthVote,todayVoted,userVoted,weekVote);

@override
String toString() {
  return 'NovelVotesDto(allVote: $allVote, articleid: $articleid, dayVote: $dayVote, monthVote: $monthVote, todayVoted: $todayVoted, userVoted: $userVoted, weekVote: $weekVote)';
}


}

/// @nodoc
abstract mixin class $NovelVotesDtoCopyWith<$Res>  {
  factory $NovelVotesDtoCopyWith(NovelVotesDto value, $Res Function(NovelVotesDto) _then) = _$NovelVotesDtoCopyWithImpl;
@useResult
$Res call({
 int allVote, int articleid, int dayVote, int monthVote, bool todayVoted, bool userVoted, int weekVote
});




}
/// @nodoc
class _$NovelVotesDtoCopyWithImpl<$Res>
    implements $NovelVotesDtoCopyWith<$Res> {
  _$NovelVotesDtoCopyWithImpl(this._self, this._then);

  final NovelVotesDto _self;
  final $Res Function(NovelVotesDto) _then;

/// Create a copy of NovelVotesDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allVote = null,Object? articleid = null,Object? dayVote = null,Object? monthVote = null,Object? todayVoted = null,Object? userVoted = null,Object? weekVote = null,}) {
  return _then(_self.copyWith(
allVote: null == allVote ? _self.allVote : allVote // ignore: cast_nullable_to_non_nullable
as int,articleid: null == articleid ? _self.articleid : articleid // ignore: cast_nullable_to_non_nullable
as int,dayVote: null == dayVote ? _self.dayVote : dayVote // ignore: cast_nullable_to_non_nullable
as int,monthVote: null == monthVote ? _self.monthVote : monthVote // ignore: cast_nullable_to_non_nullable
as int,todayVoted: null == todayVoted ? _self.todayVoted : todayVoted // ignore: cast_nullable_to_non_nullable
as bool,userVoted: null == userVoted ? _self.userVoted : userVoted // ignore: cast_nullable_to_non_nullable
as bool,weekVote: null == weekVote ? _self.weekVote : weekVote // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NovelVotesDto].
extension NovelVotesDtoPatterns on NovelVotesDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NovelVotesDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NovelVotesDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NovelVotesDto value)  $default,){
final _that = this;
switch (_that) {
case _NovelVotesDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NovelVotesDto value)?  $default,){
final _that = this;
switch (_that) {
case _NovelVotesDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int allVote,  int articleid,  int dayVote,  int monthVote,  bool todayVoted,  bool userVoted,  int weekVote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NovelVotesDto() when $default != null:
return $default(_that.allVote,_that.articleid,_that.dayVote,_that.monthVote,_that.todayVoted,_that.userVoted,_that.weekVote);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int allVote,  int articleid,  int dayVote,  int monthVote,  bool todayVoted,  bool userVoted,  int weekVote)  $default,) {final _that = this;
switch (_that) {
case _NovelVotesDto():
return $default(_that.allVote,_that.articleid,_that.dayVote,_that.monthVote,_that.todayVoted,_that.userVoted,_that.weekVote);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int allVote,  int articleid,  int dayVote,  int monthVote,  bool todayVoted,  bool userVoted,  int weekVote)?  $default,) {final _that = this;
switch (_that) {
case _NovelVotesDto() when $default != null:
return $default(_that.allVote,_that.articleid,_that.dayVote,_that.monthVote,_that.todayVoted,_that.userVoted,_that.weekVote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NovelVotesDto implements NovelVotesDto {
  const _NovelVotesDto({this.allVote = 0, this.articleid = 0, this.dayVote = 0, this.monthVote = 0, this.todayVoted = false, this.userVoted = false, this.weekVote = 0});
  factory _NovelVotesDto.fromJson(Map<String, dynamic> json) => _$NovelVotesDtoFromJson(json);

@override@JsonKey() final  int allVote;
@override@JsonKey() final  int articleid;
@override@JsonKey() final  int dayVote;
@override@JsonKey() final  int monthVote;
@override@JsonKey() final  bool todayVoted;
@override@JsonKey() final  bool userVoted;
@override@JsonKey() final  int weekVote;

/// Create a copy of NovelVotesDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NovelVotesDtoCopyWith<_NovelVotesDto> get copyWith => __$NovelVotesDtoCopyWithImpl<_NovelVotesDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NovelVotesDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NovelVotesDto&&(identical(other.allVote, allVote) || other.allVote == allVote)&&(identical(other.articleid, articleid) || other.articleid == articleid)&&(identical(other.dayVote, dayVote) || other.dayVote == dayVote)&&(identical(other.monthVote, monthVote) || other.monthVote == monthVote)&&(identical(other.todayVoted, todayVoted) || other.todayVoted == todayVoted)&&(identical(other.userVoted, userVoted) || other.userVoted == userVoted)&&(identical(other.weekVote, weekVote) || other.weekVote == weekVote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,allVote,articleid,dayVote,monthVote,todayVoted,userVoted,weekVote);

@override
String toString() {
  return 'NovelVotesDto(allVote: $allVote, articleid: $articleid, dayVote: $dayVote, monthVote: $monthVote, todayVoted: $todayVoted, userVoted: $userVoted, weekVote: $weekVote)';
}


}

/// @nodoc
abstract mixin class _$NovelVotesDtoCopyWith<$Res> implements $NovelVotesDtoCopyWith<$Res> {
  factory _$NovelVotesDtoCopyWith(_NovelVotesDto value, $Res Function(_NovelVotesDto) _then) = __$NovelVotesDtoCopyWithImpl;
@override @useResult
$Res call({
 int allVote, int articleid, int dayVote, int monthVote, bool todayVoted, bool userVoted, int weekVote
});




}
/// @nodoc
class __$NovelVotesDtoCopyWithImpl<$Res>
    implements _$NovelVotesDtoCopyWith<$Res> {
  __$NovelVotesDtoCopyWithImpl(this._self, this._then);

  final _NovelVotesDto _self;
  final $Res Function(_NovelVotesDto) _then;

/// Create a copy of NovelVotesDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allVote = null,Object? articleid = null,Object? dayVote = null,Object? monthVote = null,Object? todayVoted = null,Object? userVoted = null,Object? weekVote = null,}) {
  return _then(_NovelVotesDto(
allVote: null == allVote ? _self.allVote : allVote // ignore: cast_nullable_to_non_nullable
as int,articleid: null == articleid ? _self.articleid : articleid // ignore: cast_nullable_to_non_nullable
as int,dayVote: null == dayVote ? _self.dayVote : dayVote // ignore: cast_nullable_to_non_nullable
as int,monthVote: null == monthVote ? _self.monthVote : monthVote // ignore: cast_nullable_to_non_nullable
as int,todayVoted: null == todayVoted ? _self.todayVoted : todayVoted // ignore: cast_nullable_to_non_nullable
as bool,userVoted: null == userVoted ? _self.userVoted : userVoted // ignore: cast_nullable_to_non_nullable
as bool,weekVote: null == weekVote ? _self.weekVote : weekVote // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$GiftBalanceDto {

 int get egold; int get flowerStock; int get flowerUnitPrice; int get score;
/// Create a copy of GiftBalanceDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GiftBalanceDtoCopyWith<GiftBalanceDto> get copyWith => _$GiftBalanceDtoCopyWithImpl<GiftBalanceDto>(this as GiftBalanceDto, _$identity);

  /// Serializes this GiftBalanceDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GiftBalanceDto&&(identical(other.egold, egold) || other.egold == egold)&&(identical(other.flowerStock, flowerStock) || other.flowerStock == flowerStock)&&(identical(other.flowerUnitPrice, flowerUnitPrice) || other.flowerUnitPrice == flowerUnitPrice)&&(identical(other.score, score) || other.score == score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,egold,flowerStock,flowerUnitPrice,score);

@override
String toString() {
  return 'GiftBalanceDto(egold: $egold, flowerStock: $flowerStock, flowerUnitPrice: $flowerUnitPrice, score: $score)';
}


}

/// @nodoc
abstract mixin class $GiftBalanceDtoCopyWith<$Res>  {
  factory $GiftBalanceDtoCopyWith(GiftBalanceDto value, $Res Function(GiftBalanceDto) _then) = _$GiftBalanceDtoCopyWithImpl;
@useResult
$Res call({
 int egold, int flowerStock, int flowerUnitPrice, int score
});




}
/// @nodoc
class _$GiftBalanceDtoCopyWithImpl<$Res>
    implements $GiftBalanceDtoCopyWith<$Res> {
  _$GiftBalanceDtoCopyWithImpl(this._self, this._then);

  final GiftBalanceDto _self;
  final $Res Function(GiftBalanceDto) _then;

/// Create a copy of GiftBalanceDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? egold = null,Object? flowerStock = null,Object? flowerUnitPrice = null,Object? score = null,}) {
  return _then(_self.copyWith(
egold: null == egold ? _self.egold : egold // ignore: cast_nullable_to_non_nullable
as int,flowerStock: null == flowerStock ? _self.flowerStock : flowerStock // ignore: cast_nullable_to_non_nullable
as int,flowerUnitPrice: null == flowerUnitPrice ? _self.flowerUnitPrice : flowerUnitPrice // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GiftBalanceDto].
extension GiftBalanceDtoPatterns on GiftBalanceDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GiftBalanceDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GiftBalanceDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GiftBalanceDto value)  $default,){
final _that = this;
switch (_that) {
case _GiftBalanceDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GiftBalanceDto value)?  $default,){
final _that = this;
switch (_that) {
case _GiftBalanceDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int egold,  int flowerStock,  int flowerUnitPrice,  int score)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GiftBalanceDto() when $default != null:
return $default(_that.egold,_that.flowerStock,_that.flowerUnitPrice,_that.score);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int egold,  int flowerStock,  int flowerUnitPrice,  int score)  $default,) {final _that = this;
switch (_that) {
case _GiftBalanceDto():
return $default(_that.egold,_that.flowerStock,_that.flowerUnitPrice,_that.score);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int egold,  int flowerStock,  int flowerUnitPrice,  int score)?  $default,) {final _that = this;
switch (_that) {
case _GiftBalanceDto() when $default != null:
return $default(_that.egold,_that.flowerStock,_that.flowerUnitPrice,_that.score);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GiftBalanceDto implements GiftBalanceDto {
  const _GiftBalanceDto({this.egold = 0, this.flowerStock = 0, this.flowerUnitPrice = 0, this.score = 0});
  factory _GiftBalanceDto.fromJson(Map<String, dynamic> json) => _$GiftBalanceDtoFromJson(json);

@override@JsonKey() final  int egold;
@override@JsonKey() final  int flowerStock;
@override@JsonKey() final  int flowerUnitPrice;
@override@JsonKey() final  int score;

/// Create a copy of GiftBalanceDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GiftBalanceDtoCopyWith<_GiftBalanceDto> get copyWith => __$GiftBalanceDtoCopyWithImpl<_GiftBalanceDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GiftBalanceDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GiftBalanceDto&&(identical(other.egold, egold) || other.egold == egold)&&(identical(other.flowerStock, flowerStock) || other.flowerStock == flowerStock)&&(identical(other.flowerUnitPrice, flowerUnitPrice) || other.flowerUnitPrice == flowerUnitPrice)&&(identical(other.score, score) || other.score == score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,egold,flowerStock,flowerUnitPrice,score);

@override
String toString() {
  return 'GiftBalanceDto(egold: $egold, flowerStock: $flowerStock, flowerUnitPrice: $flowerUnitPrice, score: $score)';
}


}

/// @nodoc
abstract mixin class _$GiftBalanceDtoCopyWith<$Res> implements $GiftBalanceDtoCopyWith<$Res> {
  factory _$GiftBalanceDtoCopyWith(_GiftBalanceDto value, $Res Function(_GiftBalanceDto) _then) = __$GiftBalanceDtoCopyWithImpl;
@override @useResult
$Res call({
 int egold, int flowerStock, int flowerUnitPrice, int score
});




}
/// @nodoc
class __$GiftBalanceDtoCopyWithImpl<$Res>
    implements _$GiftBalanceDtoCopyWith<$Res> {
  __$GiftBalanceDtoCopyWithImpl(this._self, this._then);

  final _GiftBalanceDto _self;
  final $Res Function(_GiftBalanceDto) _then;

/// Create a copy of GiftBalanceDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? egold = null,Object? flowerStock = null,Object? flowerUnitPrice = null,Object? score = null,}) {
  return _then(_GiftBalanceDto(
egold: null == egold ? _self.egold : egold // ignore: cast_nullable_to_non_nullable
as int,flowerStock: null == flowerStock ? _self.flowerStock : flowerStock // ignore: cast_nullable_to_non_nullable
as int,flowerUnitPrice: null == flowerUnitPrice ? _self.flowerUnitPrice : flowerUnitPrice // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$GiftSendDto {

 int get flowerStock; int get novelAllFlower;
/// Create a copy of GiftSendDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GiftSendDtoCopyWith<GiftSendDto> get copyWith => _$GiftSendDtoCopyWithImpl<GiftSendDto>(this as GiftSendDto, _$identity);

  /// Serializes this GiftSendDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GiftSendDto&&(identical(other.flowerStock, flowerStock) || other.flowerStock == flowerStock)&&(identical(other.novelAllFlower, novelAllFlower) || other.novelAllFlower == novelAllFlower));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,flowerStock,novelAllFlower);

@override
String toString() {
  return 'GiftSendDto(flowerStock: $flowerStock, novelAllFlower: $novelAllFlower)';
}


}

/// @nodoc
abstract mixin class $GiftSendDtoCopyWith<$Res>  {
  factory $GiftSendDtoCopyWith(GiftSendDto value, $Res Function(GiftSendDto) _then) = _$GiftSendDtoCopyWithImpl;
@useResult
$Res call({
 int flowerStock, int novelAllFlower
});




}
/// @nodoc
class _$GiftSendDtoCopyWithImpl<$Res>
    implements $GiftSendDtoCopyWith<$Res> {
  _$GiftSendDtoCopyWithImpl(this._self, this._then);

  final GiftSendDto _self;
  final $Res Function(GiftSendDto) _then;

/// Create a copy of GiftSendDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? flowerStock = null,Object? novelAllFlower = null,}) {
  return _then(_self.copyWith(
flowerStock: null == flowerStock ? _self.flowerStock : flowerStock // ignore: cast_nullable_to_non_nullable
as int,novelAllFlower: null == novelAllFlower ? _self.novelAllFlower : novelAllFlower // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GiftSendDto].
extension GiftSendDtoPatterns on GiftSendDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GiftSendDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GiftSendDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GiftSendDto value)  $default,){
final _that = this;
switch (_that) {
case _GiftSendDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GiftSendDto value)?  $default,){
final _that = this;
switch (_that) {
case _GiftSendDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int flowerStock,  int novelAllFlower)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GiftSendDto() when $default != null:
return $default(_that.flowerStock,_that.novelAllFlower);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int flowerStock,  int novelAllFlower)  $default,) {final _that = this;
switch (_that) {
case _GiftSendDto():
return $default(_that.flowerStock,_that.novelAllFlower);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int flowerStock,  int novelAllFlower)?  $default,) {final _that = this;
switch (_that) {
case _GiftSendDto() when $default != null:
return $default(_that.flowerStock,_that.novelAllFlower);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GiftSendDto implements GiftSendDto {
  const _GiftSendDto({this.flowerStock = 0, this.novelAllFlower = 0});
  factory _GiftSendDto.fromJson(Map<String, dynamic> json) => _$GiftSendDtoFromJson(json);

@override@JsonKey() final  int flowerStock;
@override@JsonKey() final  int novelAllFlower;

/// Create a copy of GiftSendDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GiftSendDtoCopyWith<_GiftSendDto> get copyWith => __$GiftSendDtoCopyWithImpl<_GiftSendDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GiftSendDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GiftSendDto&&(identical(other.flowerStock, flowerStock) || other.flowerStock == flowerStock)&&(identical(other.novelAllFlower, novelAllFlower) || other.novelAllFlower == novelAllFlower));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,flowerStock,novelAllFlower);

@override
String toString() {
  return 'GiftSendDto(flowerStock: $flowerStock, novelAllFlower: $novelAllFlower)';
}


}

/// @nodoc
abstract mixin class _$GiftSendDtoCopyWith<$Res> implements $GiftSendDtoCopyWith<$Res> {
  factory _$GiftSendDtoCopyWith(_GiftSendDto value, $Res Function(_GiftSendDto) _then) = __$GiftSendDtoCopyWithImpl;
@override @useResult
$Res call({
 int flowerStock, int novelAllFlower
});




}
/// @nodoc
class __$GiftSendDtoCopyWithImpl<$Res>
    implements _$GiftSendDtoCopyWith<$Res> {
  __$GiftSendDtoCopyWithImpl(this._self, this._then);

  final _GiftSendDto _self;
  final $Res Function(_GiftSendDto) _then;

/// Create a copy of GiftSendDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? flowerStock = null,Object? novelAllFlower = null,}) {
  return _then(_GiftSendDto(
flowerStock: null == flowerStock ? _self.flowerStock : flowerStock // ignore: cast_nullable_to_non_nullable
as int,novelAllFlower: null == novelAllFlower ? _self.novelAllFlower : novelAllFlower // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$GiftExchangeDto {

 int get egold; int get flowerStock; int get score;
/// Create a copy of GiftExchangeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GiftExchangeDtoCopyWith<GiftExchangeDto> get copyWith => _$GiftExchangeDtoCopyWithImpl<GiftExchangeDto>(this as GiftExchangeDto, _$identity);

  /// Serializes this GiftExchangeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GiftExchangeDto&&(identical(other.egold, egold) || other.egold == egold)&&(identical(other.flowerStock, flowerStock) || other.flowerStock == flowerStock)&&(identical(other.score, score) || other.score == score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,egold,flowerStock,score);

@override
String toString() {
  return 'GiftExchangeDto(egold: $egold, flowerStock: $flowerStock, score: $score)';
}


}

/// @nodoc
abstract mixin class $GiftExchangeDtoCopyWith<$Res>  {
  factory $GiftExchangeDtoCopyWith(GiftExchangeDto value, $Res Function(GiftExchangeDto) _then) = _$GiftExchangeDtoCopyWithImpl;
@useResult
$Res call({
 int egold, int flowerStock, int score
});




}
/// @nodoc
class _$GiftExchangeDtoCopyWithImpl<$Res>
    implements $GiftExchangeDtoCopyWith<$Res> {
  _$GiftExchangeDtoCopyWithImpl(this._self, this._then);

  final GiftExchangeDto _self;
  final $Res Function(GiftExchangeDto) _then;

/// Create a copy of GiftExchangeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? egold = null,Object? flowerStock = null,Object? score = null,}) {
  return _then(_self.copyWith(
egold: null == egold ? _self.egold : egold // ignore: cast_nullable_to_non_nullable
as int,flowerStock: null == flowerStock ? _self.flowerStock : flowerStock // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GiftExchangeDto].
extension GiftExchangeDtoPatterns on GiftExchangeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GiftExchangeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GiftExchangeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GiftExchangeDto value)  $default,){
final _that = this;
switch (_that) {
case _GiftExchangeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GiftExchangeDto value)?  $default,){
final _that = this;
switch (_that) {
case _GiftExchangeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int egold,  int flowerStock,  int score)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GiftExchangeDto() when $default != null:
return $default(_that.egold,_that.flowerStock,_that.score);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int egold,  int flowerStock,  int score)  $default,) {final _that = this;
switch (_that) {
case _GiftExchangeDto():
return $default(_that.egold,_that.flowerStock,_that.score);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int egold,  int flowerStock,  int score)?  $default,) {final _that = this;
switch (_that) {
case _GiftExchangeDto() when $default != null:
return $default(_that.egold,_that.flowerStock,_that.score);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GiftExchangeDto implements GiftExchangeDto {
  const _GiftExchangeDto({this.egold = 0, this.flowerStock = 0, this.score = 0});
  factory _GiftExchangeDto.fromJson(Map<String, dynamic> json) => _$GiftExchangeDtoFromJson(json);

@override@JsonKey() final  int egold;
@override@JsonKey() final  int flowerStock;
@override@JsonKey() final  int score;

/// Create a copy of GiftExchangeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GiftExchangeDtoCopyWith<_GiftExchangeDto> get copyWith => __$GiftExchangeDtoCopyWithImpl<_GiftExchangeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GiftExchangeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GiftExchangeDto&&(identical(other.egold, egold) || other.egold == egold)&&(identical(other.flowerStock, flowerStock) || other.flowerStock == flowerStock)&&(identical(other.score, score) || other.score == score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,egold,flowerStock,score);

@override
String toString() {
  return 'GiftExchangeDto(egold: $egold, flowerStock: $flowerStock, score: $score)';
}


}

/// @nodoc
abstract mixin class _$GiftExchangeDtoCopyWith<$Res> implements $GiftExchangeDtoCopyWith<$Res> {
  factory _$GiftExchangeDtoCopyWith(_GiftExchangeDto value, $Res Function(_GiftExchangeDto) _then) = __$GiftExchangeDtoCopyWithImpl;
@override @useResult
$Res call({
 int egold, int flowerStock, int score
});




}
/// @nodoc
class __$GiftExchangeDtoCopyWithImpl<$Res>
    implements _$GiftExchangeDtoCopyWith<$Res> {
  __$GiftExchangeDtoCopyWithImpl(this._self, this._then);

  final _GiftExchangeDto _self;
  final $Res Function(_GiftExchangeDto) _then;

/// Create a copy of GiftExchangeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? egold = null,Object? flowerStock = null,Object? score = null,}) {
  return _then(_GiftExchangeDto(
egold: null == egold ? _self.egold : egold // ignore: cast_nullable_to_non_nullable
as int,flowerStock: null == flowerStock ? _self.flowerStock : flowerStock // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$FlowerStatDto {

 int get allflower; int get dayflower; int get weekflower; int get monthflower; int get lastflower;
/// Create a copy of FlowerStatDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlowerStatDtoCopyWith<FlowerStatDto> get copyWith => _$FlowerStatDtoCopyWithImpl<FlowerStatDto>(this as FlowerStatDto, _$identity);

  /// Serializes this FlowerStatDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlowerStatDto&&(identical(other.allflower, allflower) || other.allflower == allflower)&&(identical(other.dayflower, dayflower) || other.dayflower == dayflower)&&(identical(other.weekflower, weekflower) || other.weekflower == weekflower)&&(identical(other.monthflower, monthflower) || other.monthflower == monthflower)&&(identical(other.lastflower, lastflower) || other.lastflower == lastflower));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,allflower,dayflower,weekflower,monthflower,lastflower);

@override
String toString() {
  return 'FlowerStatDto(allflower: $allflower, dayflower: $dayflower, weekflower: $weekflower, monthflower: $monthflower, lastflower: $lastflower)';
}


}

/// @nodoc
abstract mixin class $FlowerStatDtoCopyWith<$Res>  {
  factory $FlowerStatDtoCopyWith(FlowerStatDto value, $Res Function(FlowerStatDto) _then) = _$FlowerStatDtoCopyWithImpl;
@useResult
$Res call({
 int allflower, int dayflower, int weekflower, int monthflower, int lastflower
});




}
/// @nodoc
class _$FlowerStatDtoCopyWithImpl<$Res>
    implements $FlowerStatDtoCopyWith<$Res> {
  _$FlowerStatDtoCopyWithImpl(this._self, this._then);

  final FlowerStatDto _self;
  final $Res Function(FlowerStatDto) _then;

/// Create a copy of FlowerStatDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allflower = null,Object? dayflower = null,Object? weekflower = null,Object? monthflower = null,Object? lastflower = null,}) {
  return _then(_self.copyWith(
allflower: null == allflower ? _self.allflower : allflower // ignore: cast_nullable_to_non_nullable
as int,dayflower: null == dayflower ? _self.dayflower : dayflower // ignore: cast_nullable_to_non_nullable
as int,weekflower: null == weekflower ? _self.weekflower : weekflower // ignore: cast_nullable_to_non_nullable
as int,monthflower: null == monthflower ? _self.monthflower : monthflower // ignore: cast_nullable_to_non_nullable
as int,lastflower: null == lastflower ? _self.lastflower : lastflower // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FlowerStatDto].
extension FlowerStatDtoPatterns on FlowerStatDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlowerStatDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlowerStatDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlowerStatDto value)  $default,){
final _that = this;
switch (_that) {
case _FlowerStatDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlowerStatDto value)?  $default,){
final _that = this;
switch (_that) {
case _FlowerStatDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int allflower,  int dayflower,  int weekflower,  int monthflower,  int lastflower)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FlowerStatDto() when $default != null:
return $default(_that.allflower,_that.dayflower,_that.weekflower,_that.monthflower,_that.lastflower);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int allflower,  int dayflower,  int weekflower,  int monthflower,  int lastflower)  $default,) {final _that = this;
switch (_that) {
case _FlowerStatDto():
return $default(_that.allflower,_that.dayflower,_that.weekflower,_that.monthflower,_that.lastflower);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int allflower,  int dayflower,  int weekflower,  int monthflower,  int lastflower)?  $default,) {final _that = this;
switch (_that) {
case _FlowerStatDto() when $default != null:
return $default(_that.allflower,_that.dayflower,_that.weekflower,_that.monthflower,_that.lastflower);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FlowerStatDto implements FlowerStatDto {
  const _FlowerStatDto({this.allflower = 0, this.dayflower = 0, this.weekflower = 0, this.monthflower = 0, this.lastflower = 0});
  factory _FlowerStatDto.fromJson(Map<String, dynamic> json) => _$FlowerStatDtoFromJson(json);

@override@JsonKey() final  int allflower;
@override@JsonKey() final  int dayflower;
@override@JsonKey() final  int weekflower;
@override@JsonKey() final  int monthflower;
@override@JsonKey() final  int lastflower;

/// Create a copy of FlowerStatDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlowerStatDtoCopyWith<_FlowerStatDto> get copyWith => __$FlowerStatDtoCopyWithImpl<_FlowerStatDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FlowerStatDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlowerStatDto&&(identical(other.allflower, allflower) || other.allflower == allflower)&&(identical(other.dayflower, dayflower) || other.dayflower == dayflower)&&(identical(other.weekflower, weekflower) || other.weekflower == weekflower)&&(identical(other.monthflower, monthflower) || other.monthflower == monthflower)&&(identical(other.lastflower, lastflower) || other.lastflower == lastflower));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,allflower,dayflower,weekflower,monthflower,lastflower);

@override
String toString() {
  return 'FlowerStatDto(allflower: $allflower, dayflower: $dayflower, weekflower: $weekflower, monthflower: $monthflower, lastflower: $lastflower)';
}


}

/// @nodoc
abstract mixin class _$FlowerStatDtoCopyWith<$Res> implements $FlowerStatDtoCopyWith<$Res> {
  factory _$FlowerStatDtoCopyWith(_FlowerStatDto value, $Res Function(_FlowerStatDto) _then) = __$FlowerStatDtoCopyWithImpl;
@override @useResult
$Res call({
 int allflower, int dayflower, int weekflower, int monthflower, int lastflower
});




}
/// @nodoc
class __$FlowerStatDtoCopyWithImpl<$Res>
    implements _$FlowerStatDtoCopyWith<$Res> {
  __$FlowerStatDtoCopyWithImpl(this._self, this._then);

  final _FlowerStatDto _self;
  final $Res Function(_FlowerStatDto) _then;

/// Create a copy of FlowerStatDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allflower = null,Object? dayflower = null,Object? weekflower = null,Object? monthflower = null,Object? lastflower = null,}) {
  return _then(_FlowerStatDto(
allflower: null == allflower ? _self.allflower : allflower // ignore: cast_nullable_to_non_nullable
as int,dayflower: null == dayflower ? _self.dayflower : dayflower // ignore: cast_nullable_to_non_nullable
as int,weekflower: null == weekflower ? _self.weekflower : weekflower // ignore: cast_nullable_to_non_nullable
as int,monthflower: null == monthflower ? _self.monthflower : monthflower // ignore: cast_nullable_to_non_nullable
as int,lastflower: null == lastflower ? _self.lastflower : lastflower // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
