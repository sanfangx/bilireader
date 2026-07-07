// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookReviewItemDto {

 int get topicid; int get articleid; int? get avatar; String? get avatarUrl; String? get poster; String? get posterLevel; String? get title; String? get content; int get likeNum; int get badNum; int get myReaction; int get replies; int get posttime; int get ispoiler; int get isgood; int get istop; int get views;
/// Create a copy of BookReviewItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookReviewItemDtoCopyWith<BookReviewItemDto> get copyWith => _$BookReviewItemDtoCopyWithImpl<BookReviewItemDto>(this as BookReviewItemDto, _$identity);

  /// Serializes this BookReviewItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookReviewItemDto&&(identical(other.topicid, topicid) || other.topicid == topicid)&&(identical(other.articleid, articleid) || other.articleid == articleid)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.poster, poster) || other.poster == poster)&&(identical(other.posterLevel, posterLevel) || other.posterLevel == posterLevel)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.likeNum, likeNum) || other.likeNum == likeNum)&&(identical(other.badNum, badNum) || other.badNum == badNum)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction)&&(identical(other.replies, replies) || other.replies == replies)&&(identical(other.posttime, posttime) || other.posttime == posttime)&&(identical(other.ispoiler, ispoiler) || other.ispoiler == ispoiler)&&(identical(other.isgood, isgood) || other.isgood == isgood)&&(identical(other.istop, istop) || other.istop == istop)&&(identical(other.views, views) || other.views == views));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,topicid,articleid,avatar,avatarUrl,poster,posterLevel,title,content,likeNum,badNum,myReaction,replies,posttime,ispoiler,isgood,istop,views);

@override
String toString() {
  return 'BookReviewItemDto(topicid: $topicid, articleid: $articleid, avatar: $avatar, avatarUrl: $avatarUrl, poster: $poster, posterLevel: $posterLevel, title: $title, content: $content, likeNum: $likeNum, badNum: $badNum, myReaction: $myReaction, replies: $replies, posttime: $posttime, ispoiler: $ispoiler, isgood: $isgood, istop: $istop, views: $views)';
}


}

/// @nodoc
abstract mixin class $BookReviewItemDtoCopyWith<$Res>  {
  factory $BookReviewItemDtoCopyWith(BookReviewItemDto value, $Res Function(BookReviewItemDto) _then) = _$BookReviewItemDtoCopyWithImpl;
@useResult
$Res call({
 int topicid, int articleid, int? avatar, String? avatarUrl, String? poster, String? posterLevel, String? title, String? content, int likeNum, int badNum, int myReaction, int replies, int posttime, int ispoiler, int isgood, int istop, int views
});




}
/// @nodoc
class _$BookReviewItemDtoCopyWithImpl<$Res>
    implements $BookReviewItemDtoCopyWith<$Res> {
  _$BookReviewItemDtoCopyWithImpl(this._self, this._then);

  final BookReviewItemDto _self;
  final $Res Function(BookReviewItemDto) _then;

/// Create a copy of BookReviewItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? topicid = null,Object? articleid = null,Object? avatar = freezed,Object? avatarUrl = freezed,Object? poster = freezed,Object? posterLevel = freezed,Object? title = freezed,Object? content = freezed,Object? likeNum = null,Object? badNum = null,Object? myReaction = null,Object? replies = null,Object? posttime = null,Object? ispoiler = null,Object? isgood = null,Object? istop = null,Object? views = null,}) {
  return _then(_self.copyWith(
topicid: null == topicid ? _self.topicid : topicid // ignore: cast_nullable_to_non_nullable
as int,articleid: null == articleid ? _self.articleid : articleid // ignore: cast_nullable_to_non_nullable
as int,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as int?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,poster: freezed == poster ? _self.poster : poster // ignore: cast_nullable_to_non_nullable
as String?,posterLevel: freezed == posterLevel ? _self.posterLevel : posterLevel // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,likeNum: null == likeNum ? _self.likeNum : likeNum // ignore: cast_nullable_to_non_nullable
as int,badNum: null == badNum ? _self.badNum : badNum // ignore: cast_nullable_to_non_nullable
as int,myReaction: null == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as int,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as int,posttime: null == posttime ? _self.posttime : posttime // ignore: cast_nullable_to_non_nullable
as int,ispoiler: null == ispoiler ? _self.ispoiler : ispoiler // ignore: cast_nullable_to_non_nullable
as int,isgood: null == isgood ? _self.isgood : isgood // ignore: cast_nullable_to_non_nullable
as int,istop: null == istop ? _self.istop : istop // ignore: cast_nullable_to_non_nullable
as int,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BookReviewItemDto].
extension BookReviewItemDtoPatterns on BookReviewItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookReviewItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookReviewItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookReviewItemDto value)  $default,){
final _that = this;
switch (_that) {
case _BookReviewItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookReviewItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _BookReviewItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int topicid,  int articleid,  int? avatar,  String? avatarUrl,  String? poster,  String? posterLevel,  String? title,  String? content,  int likeNum,  int badNum,  int myReaction,  int replies,  int posttime,  int ispoiler,  int isgood,  int istop,  int views)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookReviewItemDto() when $default != null:
return $default(_that.topicid,_that.articleid,_that.avatar,_that.avatarUrl,_that.poster,_that.posterLevel,_that.title,_that.content,_that.likeNum,_that.badNum,_that.myReaction,_that.replies,_that.posttime,_that.ispoiler,_that.isgood,_that.istop,_that.views);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int topicid,  int articleid,  int? avatar,  String? avatarUrl,  String? poster,  String? posterLevel,  String? title,  String? content,  int likeNum,  int badNum,  int myReaction,  int replies,  int posttime,  int ispoiler,  int isgood,  int istop,  int views)  $default,) {final _that = this;
switch (_that) {
case _BookReviewItemDto():
return $default(_that.topicid,_that.articleid,_that.avatar,_that.avatarUrl,_that.poster,_that.posterLevel,_that.title,_that.content,_that.likeNum,_that.badNum,_that.myReaction,_that.replies,_that.posttime,_that.ispoiler,_that.isgood,_that.istop,_that.views);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int topicid,  int articleid,  int? avatar,  String? avatarUrl,  String? poster,  String? posterLevel,  String? title,  String? content,  int likeNum,  int badNum,  int myReaction,  int replies,  int posttime,  int ispoiler,  int isgood,  int istop,  int views)?  $default,) {final _that = this;
switch (_that) {
case _BookReviewItemDto() when $default != null:
return $default(_that.topicid,_that.articleid,_that.avatar,_that.avatarUrl,_that.poster,_that.posterLevel,_that.title,_that.content,_that.likeNum,_that.badNum,_that.myReaction,_that.replies,_that.posttime,_that.ispoiler,_that.isgood,_that.istop,_that.views);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookReviewItemDto implements BookReviewItemDto {
  const _BookReviewItemDto({this.topicid = 0, this.articleid = 0, this.avatar, this.avatarUrl, this.poster, this.posterLevel, this.title, this.content, this.likeNum = 0, this.badNum = 0, this.myReaction = 0, this.replies = 0, this.posttime = 0, this.ispoiler = 0, this.isgood = 0, this.istop = 0, this.views = 0});
  factory _BookReviewItemDto.fromJson(Map<String, dynamic> json) => _$BookReviewItemDtoFromJson(json);

@override@JsonKey() final  int topicid;
@override@JsonKey() final  int articleid;
@override final  int? avatar;
@override final  String? avatarUrl;
@override final  String? poster;
@override final  String? posterLevel;
@override final  String? title;
@override final  String? content;
@override@JsonKey() final  int likeNum;
@override@JsonKey() final  int badNum;
@override@JsonKey() final  int myReaction;
@override@JsonKey() final  int replies;
@override@JsonKey() final  int posttime;
@override@JsonKey() final  int ispoiler;
@override@JsonKey() final  int isgood;
@override@JsonKey() final  int istop;
@override@JsonKey() final  int views;

/// Create a copy of BookReviewItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookReviewItemDtoCopyWith<_BookReviewItemDto> get copyWith => __$BookReviewItemDtoCopyWithImpl<_BookReviewItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookReviewItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookReviewItemDto&&(identical(other.topicid, topicid) || other.topicid == topicid)&&(identical(other.articleid, articleid) || other.articleid == articleid)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.poster, poster) || other.poster == poster)&&(identical(other.posterLevel, posterLevel) || other.posterLevel == posterLevel)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.likeNum, likeNum) || other.likeNum == likeNum)&&(identical(other.badNum, badNum) || other.badNum == badNum)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction)&&(identical(other.replies, replies) || other.replies == replies)&&(identical(other.posttime, posttime) || other.posttime == posttime)&&(identical(other.ispoiler, ispoiler) || other.ispoiler == ispoiler)&&(identical(other.isgood, isgood) || other.isgood == isgood)&&(identical(other.istop, istop) || other.istop == istop)&&(identical(other.views, views) || other.views == views));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,topicid,articleid,avatar,avatarUrl,poster,posterLevel,title,content,likeNum,badNum,myReaction,replies,posttime,ispoiler,isgood,istop,views);

@override
String toString() {
  return 'BookReviewItemDto(topicid: $topicid, articleid: $articleid, avatar: $avatar, avatarUrl: $avatarUrl, poster: $poster, posterLevel: $posterLevel, title: $title, content: $content, likeNum: $likeNum, badNum: $badNum, myReaction: $myReaction, replies: $replies, posttime: $posttime, ispoiler: $ispoiler, isgood: $isgood, istop: $istop, views: $views)';
}


}

/// @nodoc
abstract mixin class _$BookReviewItemDtoCopyWith<$Res> implements $BookReviewItemDtoCopyWith<$Res> {
  factory _$BookReviewItemDtoCopyWith(_BookReviewItemDto value, $Res Function(_BookReviewItemDto) _then) = __$BookReviewItemDtoCopyWithImpl;
@override @useResult
$Res call({
 int topicid, int articleid, int? avatar, String? avatarUrl, String? poster, String? posterLevel, String? title, String? content, int likeNum, int badNum, int myReaction, int replies, int posttime, int ispoiler, int isgood, int istop, int views
});




}
/// @nodoc
class __$BookReviewItemDtoCopyWithImpl<$Res>
    implements _$BookReviewItemDtoCopyWith<$Res> {
  __$BookReviewItemDtoCopyWithImpl(this._self, this._then);

  final _BookReviewItemDto _self;
  final $Res Function(_BookReviewItemDto) _then;

/// Create a copy of BookReviewItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? topicid = null,Object? articleid = null,Object? avatar = freezed,Object? avatarUrl = freezed,Object? poster = freezed,Object? posterLevel = freezed,Object? title = freezed,Object? content = freezed,Object? likeNum = null,Object? badNum = null,Object? myReaction = null,Object? replies = null,Object? posttime = null,Object? ispoiler = null,Object? isgood = null,Object? istop = null,Object? views = null,}) {
  return _then(_BookReviewItemDto(
topicid: null == topicid ? _self.topicid : topicid // ignore: cast_nullable_to_non_nullable
as int,articleid: null == articleid ? _self.articleid : articleid // ignore: cast_nullable_to_non_nullable
as int,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as int?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,poster: freezed == poster ? _self.poster : poster // ignore: cast_nullable_to_non_nullable
as String?,posterLevel: freezed == posterLevel ? _self.posterLevel : posterLevel // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,likeNum: null == likeNum ? _self.likeNum : likeNum // ignore: cast_nullable_to_non_nullable
as int,badNum: null == badNum ? _self.badNum : badNum // ignore: cast_nullable_to_non_nullable
as int,myReaction: null == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as int,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as int,posttime: null == posttime ? _self.posttime : posttime // ignore: cast_nullable_to_non_nullable
as int,ispoiler: null == ispoiler ? _self.ispoiler : ispoiler // ignore: cast_nullable_to_non_nullable
as int,isgood: null == isgood ? _self.isgood : isgood // ignore: cast_nullable_to_non_nullable
as int,istop: null == istop ? _self.istop : istop // ignore: cast_nullable_to_non_nullable
as int,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BookReplyItemDto {

 int get postid; int? get avatar; String? get avatarUrl; String? get poster; String? get posterLevel; String? get posttext; int get likeNum; int get badNum; int get myReaction; int get posttime; String? get replyToPoster; int get topicid;
/// Create a copy of BookReplyItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookReplyItemDtoCopyWith<BookReplyItemDto> get copyWith => _$BookReplyItemDtoCopyWithImpl<BookReplyItemDto>(this as BookReplyItemDto, _$identity);

  /// Serializes this BookReplyItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookReplyItemDto&&(identical(other.postid, postid) || other.postid == postid)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.poster, poster) || other.poster == poster)&&(identical(other.posterLevel, posterLevel) || other.posterLevel == posterLevel)&&(identical(other.posttext, posttext) || other.posttext == posttext)&&(identical(other.likeNum, likeNum) || other.likeNum == likeNum)&&(identical(other.badNum, badNum) || other.badNum == badNum)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction)&&(identical(other.posttime, posttime) || other.posttime == posttime)&&(identical(other.replyToPoster, replyToPoster) || other.replyToPoster == replyToPoster)&&(identical(other.topicid, topicid) || other.topicid == topicid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,postid,avatar,avatarUrl,poster,posterLevel,posttext,likeNum,badNum,myReaction,posttime,replyToPoster,topicid);

@override
String toString() {
  return 'BookReplyItemDto(postid: $postid, avatar: $avatar, avatarUrl: $avatarUrl, poster: $poster, posterLevel: $posterLevel, posttext: $posttext, likeNum: $likeNum, badNum: $badNum, myReaction: $myReaction, posttime: $posttime, replyToPoster: $replyToPoster, topicid: $topicid)';
}


}

/// @nodoc
abstract mixin class $BookReplyItemDtoCopyWith<$Res>  {
  factory $BookReplyItemDtoCopyWith(BookReplyItemDto value, $Res Function(BookReplyItemDto) _then) = _$BookReplyItemDtoCopyWithImpl;
@useResult
$Res call({
 int postid, int? avatar, String? avatarUrl, String? poster, String? posterLevel, String? posttext, int likeNum, int badNum, int myReaction, int posttime, String? replyToPoster, int topicid
});




}
/// @nodoc
class _$BookReplyItemDtoCopyWithImpl<$Res>
    implements $BookReplyItemDtoCopyWith<$Res> {
  _$BookReplyItemDtoCopyWithImpl(this._self, this._then);

  final BookReplyItemDto _self;
  final $Res Function(BookReplyItemDto) _then;

/// Create a copy of BookReplyItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? postid = null,Object? avatar = freezed,Object? avatarUrl = freezed,Object? poster = freezed,Object? posterLevel = freezed,Object? posttext = freezed,Object? likeNum = null,Object? badNum = null,Object? myReaction = null,Object? posttime = null,Object? replyToPoster = freezed,Object? topicid = null,}) {
  return _then(_self.copyWith(
postid: null == postid ? _self.postid : postid // ignore: cast_nullable_to_non_nullable
as int,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as int?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,poster: freezed == poster ? _self.poster : poster // ignore: cast_nullable_to_non_nullable
as String?,posterLevel: freezed == posterLevel ? _self.posterLevel : posterLevel // ignore: cast_nullable_to_non_nullable
as String?,posttext: freezed == posttext ? _self.posttext : posttext // ignore: cast_nullable_to_non_nullable
as String?,likeNum: null == likeNum ? _self.likeNum : likeNum // ignore: cast_nullable_to_non_nullable
as int,badNum: null == badNum ? _self.badNum : badNum // ignore: cast_nullable_to_non_nullable
as int,myReaction: null == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as int,posttime: null == posttime ? _self.posttime : posttime // ignore: cast_nullable_to_non_nullable
as int,replyToPoster: freezed == replyToPoster ? _self.replyToPoster : replyToPoster // ignore: cast_nullable_to_non_nullable
as String?,topicid: null == topicid ? _self.topicid : topicid // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BookReplyItemDto].
extension BookReplyItemDtoPatterns on BookReplyItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookReplyItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookReplyItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookReplyItemDto value)  $default,){
final _that = this;
switch (_that) {
case _BookReplyItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookReplyItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _BookReplyItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int postid,  int? avatar,  String? avatarUrl,  String? poster,  String? posterLevel,  String? posttext,  int likeNum,  int badNum,  int myReaction,  int posttime,  String? replyToPoster,  int topicid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookReplyItemDto() when $default != null:
return $default(_that.postid,_that.avatar,_that.avatarUrl,_that.poster,_that.posterLevel,_that.posttext,_that.likeNum,_that.badNum,_that.myReaction,_that.posttime,_that.replyToPoster,_that.topicid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int postid,  int? avatar,  String? avatarUrl,  String? poster,  String? posterLevel,  String? posttext,  int likeNum,  int badNum,  int myReaction,  int posttime,  String? replyToPoster,  int topicid)  $default,) {final _that = this;
switch (_that) {
case _BookReplyItemDto():
return $default(_that.postid,_that.avatar,_that.avatarUrl,_that.poster,_that.posterLevel,_that.posttext,_that.likeNum,_that.badNum,_that.myReaction,_that.posttime,_that.replyToPoster,_that.topicid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int postid,  int? avatar,  String? avatarUrl,  String? poster,  String? posterLevel,  String? posttext,  int likeNum,  int badNum,  int myReaction,  int posttime,  String? replyToPoster,  int topicid)?  $default,) {final _that = this;
switch (_that) {
case _BookReplyItemDto() when $default != null:
return $default(_that.postid,_that.avatar,_that.avatarUrl,_that.poster,_that.posterLevel,_that.posttext,_that.likeNum,_that.badNum,_that.myReaction,_that.posttime,_that.replyToPoster,_that.topicid);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookReplyItemDto implements BookReplyItemDto {
  const _BookReplyItemDto({this.postid = 0, this.avatar, this.avatarUrl, this.poster, this.posterLevel, this.posttext, this.likeNum = 0, this.badNum = 0, this.myReaction = 0, this.posttime = 0, this.replyToPoster, this.topicid = 0});
  factory _BookReplyItemDto.fromJson(Map<String, dynamic> json) => _$BookReplyItemDtoFromJson(json);

@override@JsonKey() final  int postid;
@override final  int? avatar;
@override final  String? avatarUrl;
@override final  String? poster;
@override final  String? posterLevel;
@override final  String? posttext;
@override@JsonKey() final  int likeNum;
@override@JsonKey() final  int badNum;
@override@JsonKey() final  int myReaction;
@override@JsonKey() final  int posttime;
@override final  String? replyToPoster;
@override@JsonKey() final  int topicid;

/// Create a copy of BookReplyItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookReplyItemDtoCopyWith<_BookReplyItemDto> get copyWith => __$BookReplyItemDtoCopyWithImpl<_BookReplyItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookReplyItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookReplyItemDto&&(identical(other.postid, postid) || other.postid == postid)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.poster, poster) || other.poster == poster)&&(identical(other.posterLevel, posterLevel) || other.posterLevel == posterLevel)&&(identical(other.posttext, posttext) || other.posttext == posttext)&&(identical(other.likeNum, likeNum) || other.likeNum == likeNum)&&(identical(other.badNum, badNum) || other.badNum == badNum)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction)&&(identical(other.posttime, posttime) || other.posttime == posttime)&&(identical(other.replyToPoster, replyToPoster) || other.replyToPoster == replyToPoster)&&(identical(other.topicid, topicid) || other.topicid == topicid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,postid,avatar,avatarUrl,poster,posterLevel,posttext,likeNum,badNum,myReaction,posttime,replyToPoster,topicid);

@override
String toString() {
  return 'BookReplyItemDto(postid: $postid, avatar: $avatar, avatarUrl: $avatarUrl, poster: $poster, posterLevel: $posterLevel, posttext: $posttext, likeNum: $likeNum, badNum: $badNum, myReaction: $myReaction, posttime: $posttime, replyToPoster: $replyToPoster, topicid: $topicid)';
}


}

/// @nodoc
abstract mixin class _$BookReplyItemDtoCopyWith<$Res> implements $BookReplyItemDtoCopyWith<$Res> {
  factory _$BookReplyItemDtoCopyWith(_BookReplyItemDto value, $Res Function(_BookReplyItemDto) _then) = __$BookReplyItemDtoCopyWithImpl;
@override @useResult
$Res call({
 int postid, int? avatar, String? avatarUrl, String? poster, String? posterLevel, String? posttext, int likeNum, int badNum, int myReaction, int posttime, String? replyToPoster, int topicid
});




}
/// @nodoc
class __$BookReplyItemDtoCopyWithImpl<$Res>
    implements _$BookReplyItemDtoCopyWith<$Res> {
  __$BookReplyItemDtoCopyWithImpl(this._self, this._then);

  final _BookReplyItemDto _self;
  final $Res Function(_BookReplyItemDto) _then;

/// Create a copy of BookReplyItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? postid = null,Object? avatar = freezed,Object? avatarUrl = freezed,Object? poster = freezed,Object? posterLevel = freezed,Object? posttext = freezed,Object? likeNum = null,Object? badNum = null,Object? myReaction = null,Object? posttime = null,Object? replyToPoster = freezed,Object? topicid = null,}) {
  return _then(_BookReplyItemDto(
postid: null == postid ? _self.postid : postid // ignore: cast_nullable_to_non_nullable
as int,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as int?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,poster: freezed == poster ? _self.poster : poster // ignore: cast_nullable_to_non_nullable
as String?,posterLevel: freezed == posterLevel ? _self.posterLevel : posterLevel // ignore: cast_nullable_to_non_nullable
as String?,posttext: freezed == posttext ? _self.posttext : posttext // ignore: cast_nullable_to_non_nullable
as String?,likeNum: null == likeNum ? _self.likeNum : likeNum // ignore: cast_nullable_to_non_nullable
as int,badNum: null == badNum ? _self.badNum : badNum // ignore: cast_nullable_to_non_nullable
as int,myReaction: null == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as int,posttime: null == posttime ? _self.posttime : posttime // ignore: cast_nullable_to_non_nullable
as int,replyToPoster: freezed == replyToPoster ? _self.replyToPoster : replyToPoster // ignore: cast_nullable_to_non_nullable
as String?,topicid: null == topicid ? _self.topicid : topicid // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BookReviewListDataDto {

 List<BookReviewItemDto> get list; int get pageNum; int get pageSize; int get pages; int get total;
/// Create a copy of BookReviewListDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookReviewListDataDtoCopyWith<BookReviewListDataDto> get copyWith => _$BookReviewListDataDtoCopyWithImpl<BookReviewListDataDto>(this as BookReviewListDataDto, _$identity);

  /// Serializes this BookReviewListDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookReviewListDataDto&&const DeepCollectionEquality().equals(other.list, list)&&(identical(other.pageNum, pageNum) || other.pageNum == pageNum)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.pages, pages) || other.pages == pages)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list),pageNum,pageSize,pages,total);

@override
String toString() {
  return 'BookReviewListDataDto(list: $list, pageNum: $pageNum, pageSize: $pageSize, pages: $pages, total: $total)';
}


}

/// @nodoc
abstract mixin class $BookReviewListDataDtoCopyWith<$Res>  {
  factory $BookReviewListDataDtoCopyWith(BookReviewListDataDto value, $Res Function(BookReviewListDataDto) _then) = _$BookReviewListDataDtoCopyWithImpl;
@useResult
$Res call({
 List<BookReviewItemDto> list, int pageNum, int pageSize, int pages, int total
});




}
/// @nodoc
class _$BookReviewListDataDtoCopyWithImpl<$Res>
    implements $BookReviewListDataDtoCopyWith<$Res> {
  _$BookReviewListDataDtoCopyWithImpl(this._self, this._then);

  final BookReviewListDataDto _self;
  final $Res Function(BookReviewListDataDto) _then;

/// Create a copy of BookReviewListDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = null,Object? pageNum = null,Object? pageSize = null,Object? pages = null,Object? total = null,}) {
  return _then(_self.copyWith(
list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<BookReviewItemDto>,pageNum: null == pageNum ? _self.pageNum : pageNum // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BookReviewListDataDto].
extension BookReviewListDataDtoPatterns on BookReviewListDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookReviewListDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookReviewListDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookReviewListDataDto value)  $default,){
final _that = this;
switch (_that) {
case _BookReviewListDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookReviewListDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _BookReviewListDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BookReviewItemDto> list,  int pageNum,  int pageSize,  int pages,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookReviewListDataDto() when $default != null:
return $default(_that.list,_that.pageNum,_that.pageSize,_that.pages,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BookReviewItemDto> list,  int pageNum,  int pageSize,  int pages,  int total)  $default,) {final _that = this;
switch (_that) {
case _BookReviewListDataDto():
return $default(_that.list,_that.pageNum,_that.pageSize,_that.pages,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BookReviewItemDto> list,  int pageNum,  int pageSize,  int pages,  int total)?  $default,) {final _that = this;
switch (_that) {
case _BookReviewListDataDto() when $default != null:
return $default(_that.list,_that.pageNum,_that.pageSize,_that.pages,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookReviewListDataDto implements BookReviewListDataDto {
  const _BookReviewListDataDto({final  List<BookReviewItemDto> list = const <BookReviewItemDto>[], this.pageNum = 1, this.pageSize = 20, this.pages = 1, this.total = 0}): _list = list;
  factory _BookReviewListDataDto.fromJson(Map<String, dynamic> json) => _$BookReviewListDataDtoFromJson(json);

 final  List<BookReviewItemDto> _list;
@override@JsonKey() List<BookReviewItemDto> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}

@override@JsonKey() final  int pageNum;
@override@JsonKey() final  int pageSize;
@override@JsonKey() final  int pages;
@override@JsonKey() final  int total;

/// Create a copy of BookReviewListDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookReviewListDataDtoCopyWith<_BookReviewListDataDto> get copyWith => __$BookReviewListDataDtoCopyWithImpl<_BookReviewListDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookReviewListDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookReviewListDataDto&&const DeepCollectionEquality().equals(other._list, _list)&&(identical(other.pageNum, pageNum) || other.pageNum == pageNum)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.pages, pages) || other.pages == pages)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_list),pageNum,pageSize,pages,total);

@override
String toString() {
  return 'BookReviewListDataDto(list: $list, pageNum: $pageNum, pageSize: $pageSize, pages: $pages, total: $total)';
}


}

/// @nodoc
abstract mixin class _$BookReviewListDataDtoCopyWith<$Res> implements $BookReviewListDataDtoCopyWith<$Res> {
  factory _$BookReviewListDataDtoCopyWith(_BookReviewListDataDto value, $Res Function(_BookReviewListDataDto) _then) = __$BookReviewListDataDtoCopyWithImpl;
@override @useResult
$Res call({
 List<BookReviewItemDto> list, int pageNum, int pageSize, int pages, int total
});




}
/// @nodoc
class __$BookReviewListDataDtoCopyWithImpl<$Res>
    implements _$BookReviewListDataDtoCopyWith<$Res> {
  __$BookReviewListDataDtoCopyWithImpl(this._self, this._then);

  final _BookReviewListDataDto _self;
  final $Res Function(_BookReviewListDataDto) _then;

/// Create a copy of BookReviewListDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = null,Object? pageNum = null,Object? pageSize = null,Object? pages = null,Object? total = null,}) {
  return _then(_BookReviewListDataDto(
list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<BookReviewItemDto>,pageNum: null == pageNum ? _self.pageNum : pageNum // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BookReviewRepliesDataDto {

 List<BookReplyItemDto> get list; int get pageNum; int get pageSize; int get pages; int get total;
/// Create a copy of BookReviewRepliesDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookReviewRepliesDataDtoCopyWith<BookReviewRepliesDataDto> get copyWith => _$BookReviewRepliesDataDtoCopyWithImpl<BookReviewRepliesDataDto>(this as BookReviewRepliesDataDto, _$identity);

  /// Serializes this BookReviewRepliesDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookReviewRepliesDataDto&&const DeepCollectionEquality().equals(other.list, list)&&(identical(other.pageNum, pageNum) || other.pageNum == pageNum)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.pages, pages) || other.pages == pages)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list),pageNum,pageSize,pages,total);

@override
String toString() {
  return 'BookReviewRepliesDataDto(list: $list, pageNum: $pageNum, pageSize: $pageSize, pages: $pages, total: $total)';
}


}

/// @nodoc
abstract mixin class $BookReviewRepliesDataDtoCopyWith<$Res>  {
  factory $BookReviewRepliesDataDtoCopyWith(BookReviewRepliesDataDto value, $Res Function(BookReviewRepliesDataDto) _then) = _$BookReviewRepliesDataDtoCopyWithImpl;
@useResult
$Res call({
 List<BookReplyItemDto> list, int pageNum, int pageSize, int pages, int total
});




}
/// @nodoc
class _$BookReviewRepliesDataDtoCopyWithImpl<$Res>
    implements $BookReviewRepliesDataDtoCopyWith<$Res> {
  _$BookReviewRepliesDataDtoCopyWithImpl(this._self, this._then);

  final BookReviewRepliesDataDto _self;
  final $Res Function(BookReviewRepliesDataDto) _then;

/// Create a copy of BookReviewRepliesDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = null,Object? pageNum = null,Object? pageSize = null,Object? pages = null,Object? total = null,}) {
  return _then(_self.copyWith(
list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<BookReplyItemDto>,pageNum: null == pageNum ? _self.pageNum : pageNum // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BookReviewRepliesDataDto].
extension BookReviewRepliesDataDtoPatterns on BookReviewRepliesDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookReviewRepliesDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookReviewRepliesDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookReviewRepliesDataDto value)  $default,){
final _that = this;
switch (_that) {
case _BookReviewRepliesDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookReviewRepliesDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _BookReviewRepliesDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BookReplyItemDto> list,  int pageNum,  int pageSize,  int pages,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookReviewRepliesDataDto() when $default != null:
return $default(_that.list,_that.pageNum,_that.pageSize,_that.pages,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BookReplyItemDto> list,  int pageNum,  int pageSize,  int pages,  int total)  $default,) {final _that = this;
switch (_that) {
case _BookReviewRepliesDataDto():
return $default(_that.list,_that.pageNum,_that.pageSize,_that.pages,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BookReplyItemDto> list,  int pageNum,  int pageSize,  int pages,  int total)?  $default,) {final _that = this;
switch (_that) {
case _BookReviewRepliesDataDto() when $default != null:
return $default(_that.list,_that.pageNum,_that.pageSize,_that.pages,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookReviewRepliesDataDto implements BookReviewRepliesDataDto {
  const _BookReviewRepliesDataDto({final  List<BookReplyItemDto> list = const <BookReplyItemDto>[], this.pageNum = 1, this.pageSize = 20, this.pages = 1, this.total = 0}): _list = list;
  factory _BookReviewRepliesDataDto.fromJson(Map<String, dynamic> json) => _$BookReviewRepliesDataDtoFromJson(json);

 final  List<BookReplyItemDto> _list;
@override@JsonKey() List<BookReplyItemDto> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}

@override@JsonKey() final  int pageNum;
@override@JsonKey() final  int pageSize;
@override@JsonKey() final  int pages;
@override@JsonKey() final  int total;

/// Create a copy of BookReviewRepliesDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookReviewRepliesDataDtoCopyWith<_BookReviewRepliesDataDto> get copyWith => __$BookReviewRepliesDataDtoCopyWithImpl<_BookReviewRepliesDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookReviewRepliesDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookReviewRepliesDataDto&&const DeepCollectionEquality().equals(other._list, _list)&&(identical(other.pageNum, pageNum) || other.pageNum == pageNum)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.pages, pages) || other.pages == pages)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_list),pageNum,pageSize,pages,total);

@override
String toString() {
  return 'BookReviewRepliesDataDto(list: $list, pageNum: $pageNum, pageSize: $pageSize, pages: $pages, total: $total)';
}


}

/// @nodoc
abstract mixin class _$BookReviewRepliesDataDtoCopyWith<$Res> implements $BookReviewRepliesDataDtoCopyWith<$Res> {
  factory _$BookReviewRepliesDataDtoCopyWith(_BookReviewRepliesDataDto value, $Res Function(_BookReviewRepliesDataDto) _then) = __$BookReviewRepliesDataDtoCopyWithImpl;
@override @useResult
$Res call({
 List<BookReplyItemDto> list, int pageNum, int pageSize, int pages, int total
});




}
/// @nodoc
class __$BookReviewRepliesDataDtoCopyWithImpl<$Res>
    implements _$BookReviewRepliesDataDtoCopyWith<$Res> {
  __$BookReviewRepliesDataDtoCopyWithImpl(this._self, this._then);

  final _BookReviewRepliesDataDto _self;
  final $Res Function(_BookReviewRepliesDataDto) _then;

/// Create a copy of BookReviewRepliesDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = null,Object? pageNum = null,Object? pageSize = null,Object? pages = null,Object? total = null,}) {
  return _then(_BookReviewRepliesDataDto(
list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<BookReplyItemDto>,pageNum: null == pageNum ? _self.pageNum : pageNum // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ReviewReactionDto {

 int get likeNum; int get badNum; int get myReaction; int get type;
/// Create a copy of ReviewReactionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewReactionDtoCopyWith<ReviewReactionDto> get copyWith => _$ReviewReactionDtoCopyWithImpl<ReviewReactionDto>(this as ReviewReactionDto, _$identity);

  /// Serializes this ReviewReactionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewReactionDto&&(identical(other.likeNum, likeNum) || other.likeNum == likeNum)&&(identical(other.badNum, badNum) || other.badNum == badNum)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,likeNum,badNum,myReaction,type);

@override
String toString() {
  return 'ReviewReactionDto(likeNum: $likeNum, badNum: $badNum, myReaction: $myReaction, type: $type)';
}


}

/// @nodoc
abstract mixin class $ReviewReactionDtoCopyWith<$Res>  {
  factory $ReviewReactionDtoCopyWith(ReviewReactionDto value, $Res Function(ReviewReactionDto) _then) = _$ReviewReactionDtoCopyWithImpl;
@useResult
$Res call({
 int likeNum, int badNum, int myReaction, int type
});




}
/// @nodoc
class _$ReviewReactionDtoCopyWithImpl<$Res>
    implements $ReviewReactionDtoCopyWith<$Res> {
  _$ReviewReactionDtoCopyWithImpl(this._self, this._then);

  final ReviewReactionDto _self;
  final $Res Function(ReviewReactionDto) _then;

/// Create a copy of ReviewReactionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? likeNum = null,Object? badNum = null,Object? myReaction = null,Object? type = null,}) {
  return _then(_self.copyWith(
likeNum: null == likeNum ? _self.likeNum : likeNum // ignore: cast_nullable_to_non_nullable
as int,badNum: null == badNum ? _self.badNum : badNum // ignore: cast_nullable_to_non_nullable
as int,myReaction: null == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewReactionDto].
extension ReviewReactionDtoPatterns on ReviewReactionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewReactionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewReactionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewReactionDto value)  $default,){
final _that = this;
switch (_that) {
case _ReviewReactionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewReactionDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewReactionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int likeNum,  int badNum,  int myReaction,  int type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewReactionDto() when $default != null:
return $default(_that.likeNum,_that.badNum,_that.myReaction,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int likeNum,  int badNum,  int myReaction,  int type)  $default,) {final _that = this;
switch (_that) {
case _ReviewReactionDto():
return $default(_that.likeNum,_that.badNum,_that.myReaction,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int likeNum,  int badNum,  int myReaction,  int type)?  $default,) {final _that = this;
switch (_that) {
case _ReviewReactionDto() when $default != null:
return $default(_that.likeNum,_that.badNum,_that.myReaction,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewReactionDto implements ReviewReactionDto {
  const _ReviewReactionDto({this.likeNum = 0, this.badNum = 0, this.myReaction = 0, this.type = 0});
  factory _ReviewReactionDto.fromJson(Map<String, dynamic> json) => _$ReviewReactionDtoFromJson(json);

@override@JsonKey() final  int likeNum;
@override@JsonKey() final  int badNum;
@override@JsonKey() final  int myReaction;
@override@JsonKey() final  int type;

/// Create a copy of ReviewReactionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewReactionDtoCopyWith<_ReviewReactionDto> get copyWith => __$ReviewReactionDtoCopyWithImpl<_ReviewReactionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewReactionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewReactionDto&&(identical(other.likeNum, likeNum) || other.likeNum == likeNum)&&(identical(other.badNum, badNum) || other.badNum == badNum)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,likeNum,badNum,myReaction,type);

@override
String toString() {
  return 'ReviewReactionDto(likeNum: $likeNum, badNum: $badNum, myReaction: $myReaction, type: $type)';
}


}

/// @nodoc
abstract mixin class _$ReviewReactionDtoCopyWith<$Res> implements $ReviewReactionDtoCopyWith<$Res> {
  factory _$ReviewReactionDtoCopyWith(_ReviewReactionDto value, $Res Function(_ReviewReactionDto) _then) = __$ReviewReactionDtoCopyWithImpl;
@override @useResult
$Res call({
 int likeNum, int badNum, int myReaction, int type
});




}
/// @nodoc
class __$ReviewReactionDtoCopyWithImpl<$Res>
    implements _$ReviewReactionDtoCopyWith<$Res> {
  __$ReviewReactionDtoCopyWithImpl(this._self, this._then);

  final _ReviewReactionDto _self;
  final $Res Function(_ReviewReactionDto) _then;

/// Create a copy of ReviewReactionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? likeNum = null,Object? badNum = null,Object? myReaction = null,Object? type = null,}) {
  return _then(_ReviewReactionDto(
likeNum: null == likeNum ? _self.likeNum : likeNum // ignore: cast_nullable_to_non_nullable
as int,badNum: null == badNum ? _self.badNum : badNum // ignore: cast_nullable_to_non_nullable
as int,myReaction: null == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
