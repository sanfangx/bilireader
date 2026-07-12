// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'circle_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CircleFeedItemDto {

 int get id; int? get topicId; String? get title; String? get content; String? get author; int? get authorId; String? get authorLevel; int? get avatar; String? get avatarUrl; int? get sectionId; String? get sectionName; String? get category; String? get tag; int get likeNum; int get badNum; int get myReaction; int get replies; int get views; int get postTime; int get score; int? get articleId; String? get articleName; String? get attachmentUrl; List<String>? get attachmentUrls; int? get islock; String? get type;
/// Create a copy of CircleFeedItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircleFeedItemDtoCopyWith<CircleFeedItemDto> get copyWith => _$CircleFeedItemDtoCopyWithImpl<CircleFeedItemDto>(this as CircleFeedItemDto, _$identity);

  /// Serializes this CircleFeedItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircleFeedItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.author, author) || other.author == author)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorLevel, authorLevel) || other.authorLevel == authorLevel)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.sectionName, sectionName) || other.sectionName == sectionName)&&(identical(other.category, category) || other.category == category)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.likeNum, likeNum) || other.likeNum == likeNum)&&(identical(other.badNum, badNum) || other.badNum == badNum)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction)&&(identical(other.replies, replies) || other.replies == replies)&&(identical(other.views, views) || other.views == views)&&(identical(other.postTime, postTime) || other.postTime == postTime)&&(identical(other.score, score) || other.score == score)&&(identical(other.articleId, articleId) || other.articleId == articleId)&&(identical(other.articleName, articleName) || other.articleName == articleName)&&(identical(other.attachmentUrl, attachmentUrl) || other.attachmentUrl == attachmentUrl)&&const DeepCollectionEquality().equals(other.attachmentUrls, attachmentUrls)&&(identical(other.islock, islock) || other.islock == islock)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,topicId,title,content,author,authorId,authorLevel,avatar,avatarUrl,sectionId,sectionName,category,tag,likeNum,badNum,myReaction,replies,views,postTime,score,articleId,articleName,attachmentUrl,const DeepCollectionEquality().hash(attachmentUrls),islock,type]);

@override
String toString() {
  return 'CircleFeedItemDto(id: $id, topicId: $topicId, title: $title, content: $content, author: $author, authorId: $authorId, authorLevel: $authorLevel, avatar: $avatar, avatarUrl: $avatarUrl, sectionId: $sectionId, sectionName: $sectionName, category: $category, tag: $tag, likeNum: $likeNum, badNum: $badNum, myReaction: $myReaction, replies: $replies, views: $views, postTime: $postTime, score: $score, articleId: $articleId, articleName: $articleName, attachmentUrl: $attachmentUrl, attachmentUrls: $attachmentUrls, islock: $islock, type: $type)';
}


}

/// @nodoc
abstract mixin class $CircleFeedItemDtoCopyWith<$Res>  {
  factory $CircleFeedItemDtoCopyWith(CircleFeedItemDto value, $Res Function(CircleFeedItemDto) _then) = _$CircleFeedItemDtoCopyWithImpl;
@useResult
$Res call({
 int id, int? topicId, String? title, String? content, String? author, int? authorId, String? authorLevel, int? avatar, String? avatarUrl, int? sectionId, String? sectionName, String? category, String? tag, int likeNum, int badNum, int myReaction, int replies, int views, int postTime, int score, int? articleId, String? articleName, String? attachmentUrl, List<String>? attachmentUrls, int? islock, String? type
});




}
/// @nodoc
class _$CircleFeedItemDtoCopyWithImpl<$Res>
    implements $CircleFeedItemDtoCopyWith<$Res> {
  _$CircleFeedItemDtoCopyWithImpl(this._self, this._then);

  final CircleFeedItemDto _self;
  final $Res Function(CircleFeedItemDto) _then;

/// Create a copy of CircleFeedItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? topicId = freezed,Object? title = freezed,Object? content = freezed,Object? author = freezed,Object? authorId = freezed,Object? authorLevel = freezed,Object? avatar = freezed,Object? avatarUrl = freezed,Object? sectionId = freezed,Object? sectionName = freezed,Object? category = freezed,Object? tag = freezed,Object? likeNum = null,Object? badNum = null,Object? myReaction = null,Object? replies = null,Object? views = null,Object? postTime = null,Object? score = null,Object? articleId = freezed,Object? articleName = freezed,Object? attachmentUrl = freezed,Object? attachmentUrls = freezed,Object? islock = freezed,Object? type = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,topicId: freezed == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as int?,authorLevel: freezed == authorLevel ? _self.authorLevel : authorLevel // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as int?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,sectionId: freezed == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as int?,sectionName: freezed == sectionName ? _self.sectionName : sectionName // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String?,likeNum: null == likeNum ? _self.likeNum : likeNum // ignore: cast_nullable_to_non_nullable
as int,badNum: null == badNum ? _self.badNum : badNum // ignore: cast_nullable_to_non_nullable
as int,myReaction: null == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as int,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as int,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,postTime: null == postTime ? _self.postTime : postTime // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,articleId: freezed == articleId ? _self.articleId : articleId // ignore: cast_nullable_to_non_nullable
as int?,articleName: freezed == articleName ? _self.articleName : articleName // ignore: cast_nullable_to_non_nullable
as String?,attachmentUrl: freezed == attachmentUrl ? _self.attachmentUrl : attachmentUrl // ignore: cast_nullable_to_non_nullable
as String?,attachmentUrls: freezed == attachmentUrls ? _self.attachmentUrls : attachmentUrls // ignore: cast_nullable_to_non_nullable
as List<String>?,islock: freezed == islock ? _self.islock : islock // ignore: cast_nullable_to_non_nullable
as int?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CircleFeedItemDto].
extension CircleFeedItemDtoPatterns on CircleFeedItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CircleFeedItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CircleFeedItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CircleFeedItemDto value)  $default,){
final _that = this;
switch (_that) {
case _CircleFeedItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CircleFeedItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _CircleFeedItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int? topicId,  String? title,  String? content,  String? author,  int? authorId,  String? authorLevel,  int? avatar,  String? avatarUrl,  int? sectionId,  String? sectionName,  String? category,  String? tag,  int likeNum,  int badNum,  int myReaction,  int replies,  int views,  int postTime,  int score,  int? articleId,  String? articleName,  String? attachmentUrl,  List<String>? attachmentUrls,  int? islock,  String? type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CircleFeedItemDto() when $default != null:
return $default(_that.id,_that.topicId,_that.title,_that.content,_that.author,_that.authorId,_that.authorLevel,_that.avatar,_that.avatarUrl,_that.sectionId,_that.sectionName,_that.category,_that.tag,_that.likeNum,_that.badNum,_that.myReaction,_that.replies,_that.views,_that.postTime,_that.score,_that.articleId,_that.articleName,_that.attachmentUrl,_that.attachmentUrls,_that.islock,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int? topicId,  String? title,  String? content,  String? author,  int? authorId,  String? authorLevel,  int? avatar,  String? avatarUrl,  int? sectionId,  String? sectionName,  String? category,  String? tag,  int likeNum,  int badNum,  int myReaction,  int replies,  int views,  int postTime,  int score,  int? articleId,  String? articleName,  String? attachmentUrl,  List<String>? attachmentUrls,  int? islock,  String? type)  $default,) {final _that = this;
switch (_that) {
case _CircleFeedItemDto():
return $default(_that.id,_that.topicId,_that.title,_that.content,_that.author,_that.authorId,_that.authorLevel,_that.avatar,_that.avatarUrl,_that.sectionId,_that.sectionName,_that.category,_that.tag,_that.likeNum,_that.badNum,_that.myReaction,_that.replies,_that.views,_that.postTime,_that.score,_that.articleId,_that.articleName,_that.attachmentUrl,_that.attachmentUrls,_that.islock,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int? topicId,  String? title,  String? content,  String? author,  int? authorId,  String? authorLevel,  int? avatar,  String? avatarUrl,  int? sectionId,  String? sectionName,  String? category,  String? tag,  int likeNum,  int badNum,  int myReaction,  int replies,  int views,  int postTime,  int score,  int? articleId,  String? articleName,  String? attachmentUrl,  List<String>? attachmentUrls,  int? islock,  String? type)?  $default,) {final _that = this;
switch (_that) {
case _CircleFeedItemDto() when $default != null:
return $default(_that.id,_that.topicId,_that.title,_that.content,_that.author,_that.authorId,_that.authorLevel,_that.avatar,_that.avatarUrl,_that.sectionId,_that.sectionName,_that.category,_that.tag,_that.likeNum,_that.badNum,_that.myReaction,_that.replies,_that.views,_that.postTime,_that.score,_that.articleId,_that.articleName,_that.attachmentUrl,_that.attachmentUrls,_that.islock,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CircleFeedItemDto implements CircleFeedItemDto {
  const _CircleFeedItemDto({this.id = 0, this.topicId, this.title, this.content, this.author, this.authorId, this.authorLevel, this.avatar, this.avatarUrl, this.sectionId, this.sectionName, this.category, this.tag, this.likeNum = 0, this.badNum = 0, this.myReaction = 0, this.replies = 0, this.views = 0, this.postTime = 0, this.score = 0, this.articleId, this.articleName, this.attachmentUrl, final  List<String>? attachmentUrls, this.islock, this.type}): _attachmentUrls = attachmentUrls;
  factory _CircleFeedItemDto.fromJson(Map<String, dynamic> json) => _$CircleFeedItemDtoFromJson(json);

@override@JsonKey() final  int id;
@override final  int? topicId;
@override final  String? title;
@override final  String? content;
@override final  String? author;
@override final  int? authorId;
@override final  String? authorLevel;
@override final  int? avatar;
@override final  String? avatarUrl;
@override final  int? sectionId;
@override final  String? sectionName;
@override final  String? category;
@override final  String? tag;
@override@JsonKey() final  int likeNum;
@override@JsonKey() final  int badNum;
@override@JsonKey() final  int myReaction;
@override@JsonKey() final  int replies;
@override@JsonKey() final  int views;
@override@JsonKey() final  int postTime;
@override@JsonKey() final  int score;
@override final  int? articleId;
@override final  String? articleName;
@override final  String? attachmentUrl;
 final  List<String>? _attachmentUrls;
@override List<String>? get attachmentUrls {
  final value = _attachmentUrls;
  if (value == null) return null;
  if (_attachmentUrls is EqualUnmodifiableListView) return _attachmentUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? islock;
@override final  String? type;

/// Create a copy of CircleFeedItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CircleFeedItemDtoCopyWith<_CircleFeedItemDto> get copyWith => __$CircleFeedItemDtoCopyWithImpl<_CircleFeedItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CircleFeedItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CircleFeedItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.author, author) || other.author == author)&&(identical(other.authorId, authorId) || other.authorId == authorId)&&(identical(other.authorLevel, authorLevel) || other.authorLevel == authorLevel)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.sectionName, sectionName) || other.sectionName == sectionName)&&(identical(other.category, category) || other.category == category)&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.likeNum, likeNum) || other.likeNum == likeNum)&&(identical(other.badNum, badNum) || other.badNum == badNum)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction)&&(identical(other.replies, replies) || other.replies == replies)&&(identical(other.views, views) || other.views == views)&&(identical(other.postTime, postTime) || other.postTime == postTime)&&(identical(other.score, score) || other.score == score)&&(identical(other.articleId, articleId) || other.articleId == articleId)&&(identical(other.articleName, articleName) || other.articleName == articleName)&&(identical(other.attachmentUrl, attachmentUrl) || other.attachmentUrl == attachmentUrl)&&const DeepCollectionEquality().equals(other._attachmentUrls, _attachmentUrls)&&(identical(other.islock, islock) || other.islock == islock)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,topicId,title,content,author,authorId,authorLevel,avatar,avatarUrl,sectionId,sectionName,category,tag,likeNum,badNum,myReaction,replies,views,postTime,score,articleId,articleName,attachmentUrl,const DeepCollectionEquality().hash(_attachmentUrls),islock,type]);

@override
String toString() {
  return 'CircleFeedItemDto(id: $id, topicId: $topicId, title: $title, content: $content, author: $author, authorId: $authorId, authorLevel: $authorLevel, avatar: $avatar, avatarUrl: $avatarUrl, sectionId: $sectionId, sectionName: $sectionName, category: $category, tag: $tag, likeNum: $likeNum, badNum: $badNum, myReaction: $myReaction, replies: $replies, views: $views, postTime: $postTime, score: $score, articleId: $articleId, articleName: $articleName, attachmentUrl: $attachmentUrl, attachmentUrls: $attachmentUrls, islock: $islock, type: $type)';
}


}

/// @nodoc
abstract mixin class _$CircleFeedItemDtoCopyWith<$Res> implements $CircleFeedItemDtoCopyWith<$Res> {
  factory _$CircleFeedItemDtoCopyWith(_CircleFeedItemDto value, $Res Function(_CircleFeedItemDto) _then) = __$CircleFeedItemDtoCopyWithImpl;
@override @useResult
$Res call({
 int id, int? topicId, String? title, String? content, String? author, int? authorId, String? authorLevel, int? avatar, String? avatarUrl, int? sectionId, String? sectionName, String? category, String? tag, int likeNum, int badNum, int myReaction, int replies, int views, int postTime, int score, int? articleId, String? articleName, String? attachmentUrl, List<String>? attachmentUrls, int? islock, String? type
});




}
/// @nodoc
class __$CircleFeedItemDtoCopyWithImpl<$Res>
    implements _$CircleFeedItemDtoCopyWith<$Res> {
  __$CircleFeedItemDtoCopyWithImpl(this._self, this._then);

  final _CircleFeedItemDto _self;
  final $Res Function(_CircleFeedItemDto) _then;

/// Create a copy of CircleFeedItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? topicId = freezed,Object? title = freezed,Object? content = freezed,Object? author = freezed,Object? authorId = freezed,Object? authorLevel = freezed,Object? avatar = freezed,Object? avatarUrl = freezed,Object? sectionId = freezed,Object? sectionName = freezed,Object? category = freezed,Object? tag = freezed,Object? likeNum = null,Object? badNum = null,Object? myReaction = null,Object? replies = null,Object? views = null,Object? postTime = null,Object? score = null,Object? articleId = freezed,Object? articleName = freezed,Object? attachmentUrl = freezed,Object? attachmentUrls = freezed,Object? islock = freezed,Object? type = freezed,}) {
  return _then(_CircleFeedItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,topicId: freezed == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,authorId: freezed == authorId ? _self.authorId : authorId // ignore: cast_nullable_to_non_nullable
as int?,authorLevel: freezed == authorLevel ? _self.authorLevel : authorLevel // ignore: cast_nullable_to_non_nullable
as String?,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as int?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,sectionId: freezed == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as int?,sectionName: freezed == sectionName ? _self.sectionName : sectionName // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,tag: freezed == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String?,likeNum: null == likeNum ? _self.likeNum : likeNum // ignore: cast_nullable_to_non_nullable
as int,badNum: null == badNum ? _self.badNum : badNum // ignore: cast_nullable_to_non_nullable
as int,myReaction: null == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as int,replies: null == replies ? _self.replies : replies // ignore: cast_nullable_to_non_nullable
as int,views: null == views ? _self.views : views // ignore: cast_nullable_to_non_nullable
as int,postTime: null == postTime ? _self.postTime : postTime // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,articleId: freezed == articleId ? _self.articleId : articleId // ignore: cast_nullable_to_non_nullable
as int?,articleName: freezed == articleName ? _self.articleName : articleName // ignore: cast_nullable_to_non_nullable
as String?,attachmentUrl: freezed == attachmentUrl ? _self.attachmentUrl : attachmentUrl // ignore: cast_nullable_to_non_nullable
as String?,attachmentUrls: freezed == attachmentUrls ? _self._attachmentUrls : attachmentUrls // ignore: cast_nullable_to_non_nullable
as List<String>?,islock: freezed == islock ? _self.islock : islock // ignore: cast_nullable_to_non_nullable
as int?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CircleFeedDataDto {

 String? get category; List<CircleFeedItemDto> get list; int get pageNum; int get pageSize; int get pages; int? get sectionId; int get total;
/// Create a copy of CircleFeedDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircleFeedDataDtoCopyWith<CircleFeedDataDto> get copyWith => _$CircleFeedDataDtoCopyWithImpl<CircleFeedDataDto>(this as CircleFeedDataDto, _$identity);

  /// Serializes this CircleFeedDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircleFeedDataDto&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.list, list)&&(identical(other.pageNum, pageNum) || other.pageNum == pageNum)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.pages, pages) || other.pages == pages)&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,const DeepCollectionEquality().hash(list),pageNum,pageSize,pages,sectionId,total);

@override
String toString() {
  return 'CircleFeedDataDto(category: $category, list: $list, pageNum: $pageNum, pageSize: $pageSize, pages: $pages, sectionId: $sectionId, total: $total)';
}


}

/// @nodoc
abstract mixin class $CircleFeedDataDtoCopyWith<$Res>  {
  factory $CircleFeedDataDtoCopyWith(CircleFeedDataDto value, $Res Function(CircleFeedDataDto) _then) = _$CircleFeedDataDtoCopyWithImpl;
@useResult
$Res call({
 String? category, List<CircleFeedItemDto> list, int pageNum, int pageSize, int pages, int? sectionId, int total
});




}
/// @nodoc
class _$CircleFeedDataDtoCopyWithImpl<$Res>
    implements $CircleFeedDataDtoCopyWith<$Res> {
  _$CircleFeedDataDtoCopyWithImpl(this._self, this._then);

  final CircleFeedDataDto _self;
  final $Res Function(CircleFeedDataDto) _then;

/// Create a copy of CircleFeedDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = freezed,Object? list = null,Object? pageNum = null,Object? pageSize = null,Object? pages = null,Object? sectionId = freezed,Object? total = null,}) {
  return _then(_self.copyWith(
category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<CircleFeedItemDto>,pageNum: null == pageNum ? _self.pageNum : pageNum // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,sectionId: freezed == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as int?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CircleFeedDataDto].
extension CircleFeedDataDtoPatterns on CircleFeedDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CircleFeedDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CircleFeedDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CircleFeedDataDto value)  $default,){
final _that = this;
switch (_that) {
case _CircleFeedDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CircleFeedDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _CircleFeedDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? category,  List<CircleFeedItemDto> list,  int pageNum,  int pageSize,  int pages,  int? sectionId,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CircleFeedDataDto() when $default != null:
return $default(_that.category,_that.list,_that.pageNum,_that.pageSize,_that.pages,_that.sectionId,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? category,  List<CircleFeedItemDto> list,  int pageNum,  int pageSize,  int pages,  int? sectionId,  int total)  $default,) {final _that = this;
switch (_that) {
case _CircleFeedDataDto():
return $default(_that.category,_that.list,_that.pageNum,_that.pageSize,_that.pages,_that.sectionId,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? category,  List<CircleFeedItemDto> list,  int pageNum,  int pageSize,  int pages,  int? sectionId,  int total)?  $default,) {final _that = this;
switch (_that) {
case _CircleFeedDataDto() when $default != null:
return $default(_that.category,_that.list,_that.pageNum,_that.pageSize,_that.pages,_that.sectionId,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CircleFeedDataDto implements CircleFeedDataDto {
  const _CircleFeedDataDto({this.category, final  List<CircleFeedItemDto> list = const <CircleFeedItemDto>[], this.pageNum = 1, this.pageSize = 20, this.pages = 1, this.sectionId, this.total = 0}): _list = list;
  factory _CircleFeedDataDto.fromJson(Map<String, dynamic> json) => _$CircleFeedDataDtoFromJson(json);

@override final  String? category;
 final  List<CircleFeedItemDto> _list;
@override@JsonKey() List<CircleFeedItemDto> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}

@override@JsonKey() final  int pageNum;
@override@JsonKey() final  int pageSize;
@override@JsonKey() final  int pages;
@override final  int? sectionId;
@override@JsonKey() final  int total;

/// Create a copy of CircleFeedDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CircleFeedDataDtoCopyWith<_CircleFeedDataDto> get copyWith => __$CircleFeedDataDtoCopyWithImpl<_CircleFeedDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CircleFeedDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CircleFeedDataDto&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._list, _list)&&(identical(other.pageNum, pageNum) || other.pageNum == pageNum)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.pages, pages) || other.pages == pages)&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,category,const DeepCollectionEquality().hash(_list),pageNum,pageSize,pages,sectionId,total);

@override
String toString() {
  return 'CircleFeedDataDto(category: $category, list: $list, pageNum: $pageNum, pageSize: $pageSize, pages: $pages, sectionId: $sectionId, total: $total)';
}


}

/// @nodoc
abstract mixin class _$CircleFeedDataDtoCopyWith<$Res> implements $CircleFeedDataDtoCopyWith<$Res> {
  factory _$CircleFeedDataDtoCopyWith(_CircleFeedDataDto value, $Res Function(_CircleFeedDataDto) _then) = __$CircleFeedDataDtoCopyWithImpl;
@override @useResult
$Res call({
 String? category, List<CircleFeedItemDto> list, int pageNum, int pageSize, int pages, int? sectionId, int total
});




}
/// @nodoc
class __$CircleFeedDataDtoCopyWithImpl<$Res>
    implements _$CircleFeedDataDtoCopyWith<$Res> {
  __$CircleFeedDataDtoCopyWithImpl(this._self, this._then);

  final _CircleFeedDataDto _self;
  final $Res Function(_CircleFeedDataDto) _then;

/// Create a copy of CircleFeedDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = freezed,Object? list = null,Object? pageNum = null,Object? pageSize = null,Object? pages = null,Object? sectionId = freezed,Object? total = null,}) {
  return _then(_CircleFeedDataDto(
category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<CircleFeedItemDto>,pageNum: null == pageNum ? _self.pageNum : pageNum // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,sectionId: freezed == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as int?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CircleSectionDto {

 int get sectionId; String get sectionName; String get categoryName; int get postCount; int get topicCount;
/// Create a copy of CircleSectionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircleSectionDtoCopyWith<CircleSectionDto> get copyWith => _$CircleSectionDtoCopyWithImpl<CircleSectionDto>(this as CircleSectionDto, _$identity);

  /// Serializes this CircleSectionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircleSectionDto&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.sectionName, sectionName) || other.sectionName == sectionName)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.postCount, postCount) || other.postCount == postCount)&&(identical(other.topicCount, topicCount) || other.topicCount == topicCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sectionId,sectionName,categoryName,postCount,topicCount);

@override
String toString() {
  return 'CircleSectionDto(sectionId: $sectionId, sectionName: $sectionName, categoryName: $categoryName, postCount: $postCount, topicCount: $topicCount)';
}


}

/// @nodoc
abstract mixin class $CircleSectionDtoCopyWith<$Res>  {
  factory $CircleSectionDtoCopyWith(CircleSectionDto value, $Res Function(CircleSectionDto) _then) = _$CircleSectionDtoCopyWithImpl;
@useResult
$Res call({
 int sectionId, String sectionName, String categoryName, int postCount, int topicCount
});




}
/// @nodoc
class _$CircleSectionDtoCopyWithImpl<$Res>
    implements $CircleSectionDtoCopyWith<$Res> {
  _$CircleSectionDtoCopyWithImpl(this._self, this._then);

  final CircleSectionDto _self;
  final $Res Function(CircleSectionDto) _then;

/// Create a copy of CircleSectionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sectionId = null,Object? sectionName = null,Object? categoryName = null,Object? postCount = null,Object? topicCount = null,}) {
  return _then(_self.copyWith(
sectionId: null == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as int,sectionName: null == sectionName ? _self.sectionName : sectionName // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,postCount: null == postCount ? _self.postCount : postCount // ignore: cast_nullable_to_non_nullable
as int,topicCount: null == topicCount ? _self.topicCount : topicCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CircleSectionDto].
extension CircleSectionDtoPatterns on CircleSectionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CircleSectionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CircleSectionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CircleSectionDto value)  $default,){
final _that = this;
switch (_that) {
case _CircleSectionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CircleSectionDto value)?  $default,){
final _that = this;
switch (_that) {
case _CircleSectionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int sectionId,  String sectionName,  String categoryName,  int postCount,  int topicCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CircleSectionDto() when $default != null:
return $default(_that.sectionId,_that.sectionName,_that.categoryName,_that.postCount,_that.topicCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int sectionId,  String sectionName,  String categoryName,  int postCount,  int topicCount)  $default,) {final _that = this;
switch (_that) {
case _CircleSectionDto():
return $default(_that.sectionId,_that.sectionName,_that.categoryName,_that.postCount,_that.topicCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int sectionId,  String sectionName,  String categoryName,  int postCount,  int topicCount)?  $default,) {final _that = this;
switch (_that) {
case _CircleSectionDto() when $default != null:
return $default(_that.sectionId,_that.sectionName,_that.categoryName,_that.postCount,_that.topicCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CircleSectionDto implements CircleSectionDto {
  const _CircleSectionDto({this.sectionId = 0, this.sectionName = '', this.categoryName = '', this.postCount = 0, this.topicCount = 0});
  factory _CircleSectionDto.fromJson(Map<String, dynamic> json) => _$CircleSectionDtoFromJson(json);

@override@JsonKey() final  int sectionId;
@override@JsonKey() final  String sectionName;
@override@JsonKey() final  String categoryName;
@override@JsonKey() final  int postCount;
@override@JsonKey() final  int topicCount;

/// Create a copy of CircleSectionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CircleSectionDtoCopyWith<_CircleSectionDto> get copyWith => __$CircleSectionDtoCopyWithImpl<_CircleSectionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CircleSectionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CircleSectionDto&&(identical(other.sectionId, sectionId) || other.sectionId == sectionId)&&(identical(other.sectionName, sectionName) || other.sectionName == sectionName)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.postCount, postCount) || other.postCount == postCount)&&(identical(other.topicCount, topicCount) || other.topicCount == topicCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sectionId,sectionName,categoryName,postCount,topicCount);

@override
String toString() {
  return 'CircleSectionDto(sectionId: $sectionId, sectionName: $sectionName, categoryName: $categoryName, postCount: $postCount, topicCount: $topicCount)';
}


}

/// @nodoc
abstract mixin class _$CircleSectionDtoCopyWith<$Res> implements $CircleSectionDtoCopyWith<$Res> {
  factory _$CircleSectionDtoCopyWith(_CircleSectionDto value, $Res Function(_CircleSectionDto) _then) = __$CircleSectionDtoCopyWithImpl;
@override @useResult
$Res call({
 int sectionId, String sectionName, String categoryName, int postCount, int topicCount
});




}
/// @nodoc
class __$CircleSectionDtoCopyWithImpl<$Res>
    implements _$CircleSectionDtoCopyWith<$Res> {
  __$CircleSectionDtoCopyWithImpl(this._self, this._then);

  final _CircleSectionDto _self;
  final $Res Function(_CircleSectionDto) _then;

/// Create a copy of CircleSectionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sectionId = null,Object? sectionName = null,Object? categoryName = null,Object? postCount = null,Object? topicCount = null,}) {
  return _then(_CircleSectionDto(
sectionId: null == sectionId ? _self.sectionId : sectionId // ignore: cast_nullable_to_non_nullable
as int,sectionName: null == sectionName ? _self.sectionName : sectionName // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,postCount: null == postCount ? _self.postCount : postCount // ignore: cast_nullable_to_non_nullable
as int,topicCount: null == topicCount ? _self.topicCount : topicCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CircleReplyDto {

 int get postid; int get topicid; String? get posttext; String? get poster; String? get posterLevel; int get posterid; int? get avatar; String? get avatarUrl; int get likeNum; int get badNum; int get myReaction; int get posttime; int get replypid; int get replyppid; int get depth; String? get replyToPoster; String? get subject; String? get topicTitle; String? get attachmentUrl; List<String>? get attachmentUrls;
/// Create a copy of CircleReplyDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircleReplyDtoCopyWith<CircleReplyDto> get copyWith => _$CircleReplyDtoCopyWithImpl<CircleReplyDto>(this as CircleReplyDto, _$identity);

  /// Serializes this CircleReplyDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircleReplyDto&&(identical(other.postid, postid) || other.postid == postid)&&(identical(other.topicid, topicid) || other.topicid == topicid)&&(identical(other.posttext, posttext) || other.posttext == posttext)&&(identical(other.poster, poster) || other.poster == poster)&&(identical(other.posterLevel, posterLevel) || other.posterLevel == posterLevel)&&(identical(other.posterid, posterid) || other.posterid == posterid)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.likeNum, likeNum) || other.likeNum == likeNum)&&(identical(other.badNum, badNum) || other.badNum == badNum)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction)&&(identical(other.posttime, posttime) || other.posttime == posttime)&&(identical(other.replypid, replypid) || other.replypid == replypid)&&(identical(other.replyppid, replyppid) || other.replyppid == replyppid)&&(identical(other.depth, depth) || other.depth == depth)&&(identical(other.replyToPoster, replyToPoster) || other.replyToPoster == replyToPoster)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.topicTitle, topicTitle) || other.topicTitle == topicTitle)&&(identical(other.attachmentUrl, attachmentUrl) || other.attachmentUrl == attachmentUrl)&&const DeepCollectionEquality().equals(other.attachmentUrls, attachmentUrls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,postid,topicid,posttext,poster,posterLevel,posterid,avatar,avatarUrl,likeNum,badNum,myReaction,posttime,replypid,replyppid,depth,replyToPoster,subject,topicTitle,attachmentUrl,const DeepCollectionEquality().hash(attachmentUrls)]);

@override
String toString() {
  return 'CircleReplyDto(postid: $postid, topicid: $topicid, posttext: $posttext, poster: $poster, posterLevel: $posterLevel, posterid: $posterid, avatar: $avatar, avatarUrl: $avatarUrl, likeNum: $likeNum, badNum: $badNum, myReaction: $myReaction, posttime: $posttime, replypid: $replypid, replyppid: $replyppid, depth: $depth, replyToPoster: $replyToPoster, subject: $subject, topicTitle: $topicTitle, attachmentUrl: $attachmentUrl, attachmentUrls: $attachmentUrls)';
}


}

/// @nodoc
abstract mixin class $CircleReplyDtoCopyWith<$Res>  {
  factory $CircleReplyDtoCopyWith(CircleReplyDto value, $Res Function(CircleReplyDto) _then) = _$CircleReplyDtoCopyWithImpl;
@useResult
$Res call({
 int postid, int topicid, String? posttext, String? poster, String? posterLevel, int posterid, int? avatar, String? avatarUrl, int likeNum, int badNum, int myReaction, int posttime, int replypid, int replyppid, int depth, String? replyToPoster, String? subject, String? topicTitle, String? attachmentUrl, List<String>? attachmentUrls
});




}
/// @nodoc
class _$CircleReplyDtoCopyWithImpl<$Res>
    implements $CircleReplyDtoCopyWith<$Res> {
  _$CircleReplyDtoCopyWithImpl(this._self, this._then);

  final CircleReplyDto _self;
  final $Res Function(CircleReplyDto) _then;

/// Create a copy of CircleReplyDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? postid = null,Object? topicid = null,Object? posttext = freezed,Object? poster = freezed,Object? posterLevel = freezed,Object? posterid = null,Object? avatar = freezed,Object? avatarUrl = freezed,Object? likeNum = null,Object? badNum = null,Object? myReaction = null,Object? posttime = null,Object? replypid = null,Object? replyppid = null,Object? depth = null,Object? replyToPoster = freezed,Object? subject = freezed,Object? topicTitle = freezed,Object? attachmentUrl = freezed,Object? attachmentUrls = freezed,}) {
  return _then(_self.copyWith(
postid: null == postid ? _self.postid : postid // ignore: cast_nullable_to_non_nullable
as int,topicid: null == topicid ? _self.topicid : topicid // ignore: cast_nullable_to_non_nullable
as int,posttext: freezed == posttext ? _self.posttext : posttext // ignore: cast_nullable_to_non_nullable
as String?,poster: freezed == poster ? _self.poster : poster // ignore: cast_nullable_to_non_nullable
as String?,posterLevel: freezed == posterLevel ? _self.posterLevel : posterLevel // ignore: cast_nullable_to_non_nullable
as String?,posterid: null == posterid ? _self.posterid : posterid // ignore: cast_nullable_to_non_nullable
as int,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as int?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,likeNum: null == likeNum ? _self.likeNum : likeNum // ignore: cast_nullable_to_non_nullable
as int,badNum: null == badNum ? _self.badNum : badNum // ignore: cast_nullable_to_non_nullable
as int,myReaction: null == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as int,posttime: null == posttime ? _self.posttime : posttime // ignore: cast_nullable_to_non_nullable
as int,replypid: null == replypid ? _self.replypid : replypid // ignore: cast_nullable_to_non_nullable
as int,replyppid: null == replyppid ? _self.replyppid : replyppid // ignore: cast_nullable_to_non_nullable
as int,depth: null == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as int,replyToPoster: freezed == replyToPoster ? _self.replyToPoster : replyToPoster // ignore: cast_nullable_to_non_nullable
as String?,subject: freezed == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String?,topicTitle: freezed == topicTitle ? _self.topicTitle : topicTitle // ignore: cast_nullable_to_non_nullable
as String?,attachmentUrl: freezed == attachmentUrl ? _self.attachmentUrl : attachmentUrl // ignore: cast_nullable_to_non_nullable
as String?,attachmentUrls: freezed == attachmentUrls ? _self.attachmentUrls : attachmentUrls // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CircleReplyDto].
extension CircleReplyDtoPatterns on CircleReplyDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CircleReplyDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CircleReplyDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CircleReplyDto value)  $default,){
final _that = this;
switch (_that) {
case _CircleReplyDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CircleReplyDto value)?  $default,){
final _that = this;
switch (_that) {
case _CircleReplyDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int postid,  int topicid,  String? posttext,  String? poster,  String? posterLevel,  int posterid,  int? avatar,  String? avatarUrl,  int likeNum,  int badNum,  int myReaction,  int posttime,  int replypid,  int replyppid,  int depth,  String? replyToPoster,  String? subject,  String? topicTitle,  String? attachmentUrl,  List<String>? attachmentUrls)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CircleReplyDto() when $default != null:
return $default(_that.postid,_that.topicid,_that.posttext,_that.poster,_that.posterLevel,_that.posterid,_that.avatar,_that.avatarUrl,_that.likeNum,_that.badNum,_that.myReaction,_that.posttime,_that.replypid,_that.replyppid,_that.depth,_that.replyToPoster,_that.subject,_that.topicTitle,_that.attachmentUrl,_that.attachmentUrls);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int postid,  int topicid,  String? posttext,  String? poster,  String? posterLevel,  int posterid,  int? avatar,  String? avatarUrl,  int likeNum,  int badNum,  int myReaction,  int posttime,  int replypid,  int replyppid,  int depth,  String? replyToPoster,  String? subject,  String? topicTitle,  String? attachmentUrl,  List<String>? attachmentUrls)  $default,) {final _that = this;
switch (_that) {
case _CircleReplyDto():
return $default(_that.postid,_that.topicid,_that.posttext,_that.poster,_that.posterLevel,_that.posterid,_that.avatar,_that.avatarUrl,_that.likeNum,_that.badNum,_that.myReaction,_that.posttime,_that.replypid,_that.replyppid,_that.depth,_that.replyToPoster,_that.subject,_that.topicTitle,_that.attachmentUrl,_that.attachmentUrls);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int postid,  int topicid,  String? posttext,  String? poster,  String? posterLevel,  int posterid,  int? avatar,  String? avatarUrl,  int likeNum,  int badNum,  int myReaction,  int posttime,  int replypid,  int replyppid,  int depth,  String? replyToPoster,  String? subject,  String? topicTitle,  String? attachmentUrl,  List<String>? attachmentUrls)?  $default,) {final _that = this;
switch (_that) {
case _CircleReplyDto() when $default != null:
return $default(_that.postid,_that.topicid,_that.posttext,_that.poster,_that.posterLevel,_that.posterid,_that.avatar,_that.avatarUrl,_that.likeNum,_that.badNum,_that.myReaction,_that.posttime,_that.replypid,_that.replyppid,_that.depth,_that.replyToPoster,_that.subject,_that.topicTitle,_that.attachmentUrl,_that.attachmentUrls);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CircleReplyDto implements CircleReplyDto {
  const _CircleReplyDto({this.postid = 0, this.topicid = 0, this.posttext, this.poster, this.posterLevel, this.posterid = 0, this.avatar, this.avatarUrl, this.likeNum = 0, this.badNum = 0, this.myReaction = 0, this.posttime = 0, this.replypid = 0, this.replyppid = 0, this.depth = 0, this.replyToPoster, this.subject, this.topicTitle, this.attachmentUrl, final  List<String>? attachmentUrls}): _attachmentUrls = attachmentUrls;
  factory _CircleReplyDto.fromJson(Map<String, dynamic> json) => _$CircleReplyDtoFromJson(json);

@override@JsonKey() final  int postid;
@override@JsonKey() final  int topicid;
@override final  String? posttext;
@override final  String? poster;
@override final  String? posterLevel;
@override@JsonKey() final  int posterid;
@override final  int? avatar;
@override final  String? avatarUrl;
@override@JsonKey() final  int likeNum;
@override@JsonKey() final  int badNum;
@override@JsonKey() final  int myReaction;
@override@JsonKey() final  int posttime;
@override@JsonKey() final  int replypid;
@override@JsonKey() final  int replyppid;
@override@JsonKey() final  int depth;
@override final  String? replyToPoster;
@override final  String? subject;
@override final  String? topicTitle;
@override final  String? attachmentUrl;
 final  List<String>? _attachmentUrls;
@override List<String>? get attachmentUrls {
  final value = _attachmentUrls;
  if (value == null) return null;
  if (_attachmentUrls is EqualUnmodifiableListView) return _attachmentUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of CircleReplyDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CircleReplyDtoCopyWith<_CircleReplyDto> get copyWith => __$CircleReplyDtoCopyWithImpl<_CircleReplyDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CircleReplyDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CircleReplyDto&&(identical(other.postid, postid) || other.postid == postid)&&(identical(other.topicid, topicid) || other.topicid == topicid)&&(identical(other.posttext, posttext) || other.posttext == posttext)&&(identical(other.poster, poster) || other.poster == poster)&&(identical(other.posterLevel, posterLevel) || other.posterLevel == posterLevel)&&(identical(other.posterid, posterid) || other.posterid == posterid)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.likeNum, likeNum) || other.likeNum == likeNum)&&(identical(other.badNum, badNum) || other.badNum == badNum)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction)&&(identical(other.posttime, posttime) || other.posttime == posttime)&&(identical(other.replypid, replypid) || other.replypid == replypid)&&(identical(other.replyppid, replyppid) || other.replyppid == replyppid)&&(identical(other.depth, depth) || other.depth == depth)&&(identical(other.replyToPoster, replyToPoster) || other.replyToPoster == replyToPoster)&&(identical(other.subject, subject) || other.subject == subject)&&(identical(other.topicTitle, topicTitle) || other.topicTitle == topicTitle)&&(identical(other.attachmentUrl, attachmentUrl) || other.attachmentUrl == attachmentUrl)&&const DeepCollectionEquality().equals(other._attachmentUrls, _attachmentUrls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,postid,topicid,posttext,poster,posterLevel,posterid,avatar,avatarUrl,likeNum,badNum,myReaction,posttime,replypid,replyppid,depth,replyToPoster,subject,topicTitle,attachmentUrl,const DeepCollectionEquality().hash(_attachmentUrls)]);

@override
String toString() {
  return 'CircleReplyDto(postid: $postid, topicid: $topicid, posttext: $posttext, poster: $poster, posterLevel: $posterLevel, posterid: $posterid, avatar: $avatar, avatarUrl: $avatarUrl, likeNum: $likeNum, badNum: $badNum, myReaction: $myReaction, posttime: $posttime, replypid: $replypid, replyppid: $replyppid, depth: $depth, replyToPoster: $replyToPoster, subject: $subject, topicTitle: $topicTitle, attachmentUrl: $attachmentUrl, attachmentUrls: $attachmentUrls)';
}


}

/// @nodoc
abstract mixin class _$CircleReplyDtoCopyWith<$Res> implements $CircleReplyDtoCopyWith<$Res> {
  factory _$CircleReplyDtoCopyWith(_CircleReplyDto value, $Res Function(_CircleReplyDto) _then) = __$CircleReplyDtoCopyWithImpl;
@override @useResult
$Res call({
 int postid, int topicid, String? posttext, String? poster, String? posterLevel, int posterid, int? avatar, String? avatarUrl, int likeNum, int badNum, int myReaction, int posttime, int replypid, int replyppid, int depth, String? replyToPoster, String? subject, String? topicTitle, String? attachmentUrl, List<String>? attachmentUrls
});




}
/// @nodoc
class __$CircleReplyDtoCopyWithImpl<$Res>
    implements _$CircleReplyDtoCopyWith<$Res> {
  __$CircleReplyDtoCopyWithImpl(this._self, this._then);

  final _CircleReplyDto _self;
  final $Res Function(_CircleReplyDto) _then;

/// Create a copy of CircleReplyDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? postid = null,Object? topicid = null,Object? posttext = freezed,Object? poster = freezed,Object? posterLevel = freezed,Object? posterid = null,Object? avatar = freezed,Object? avatarUrl = freezed,Object? likeNum = null,Object? badNum = null,Object? myReaction = null,Object? posttime = null,Object? replypid = null,Object? replyppid = null,Object? depth = null,Object? replyToPoster = freezed,Object? subject = freezed,Object? topicTitle = freezed,Object? attachmentUrl = freezed,Object? attachmentUrls = freezed,}) {
  return _then(_CircleReplyDto(
postid: null == postid ? _self.postid : postid // ignore: cast_nullable_to_non_nullable
as int,topicid: null == topicid ? _self.topicid : topicid // ignore: cast_nullable_to_non_nullable
as int,posttext: freezed == posttext ? _self.posttext : posttext // ignore: cast_nullable_to_non_nullable
as String?,poster: freezed == poster ? _self.poster : poster // ignore: cast_nullable_to_non_nullable
as String?,posterLevel: freezed == posterLevel ? _self.posterLevel : posterLevel // ignore: cast_nullable_to_non_nullable
as String?,posterid: null == posterid ? _self.posterid : posterid // ignore: cast_nullable_to_non_nullable
as int,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as int?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,likeNum: null == likeNum ? _self.likeNum : likeNum // ignore: cast_nullable_to_non_nullable
as int,badNum: null == badNum ? _self.badNum : badNum // ignore: cast_nullable_to_non_nullable
as int,myReaction: null == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as int,posttime: null == posttime ? _self.posttime : posttime // ignore: cast_nullable_to_non_nullable
as int,replypid: null == replypid ? _self.replypid : replypid // ignore: cast_nullable_to_non_nullable
as int,replyppid: null == replyppid ? _self.replyppid : replyppid // ignore: cast_nullable_to_non_nullable
as int,depth: null == depth ? _self.depth : depth // ignore: cast_nullable_to_non_nullable
as int,replyToPoster: freezed == replyToPoster ? _self.replyToPoster : replyToPoster // ignore: cast_nullable_to_non_nullable
as String?,subject: freezed == subject ? _self.subject : subject // ignore: cast_nullable_to_non_nullable
as String?,topicTitle: freezed == topicTitle ? _self.topicTitle : topicTitle // ignore: cast_nullable_to_non_nullable
as String?,attachmentUrl: freezed == attachmentUrl ? _self.attachmentUrl : attachmentUrl // ignore: cast_nullable_to_non_nullable
as String?,attachmentUrls: freezed == attachmentUrls ? _self._attachmentUrls : attachmentUrls // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$CircleRepliesDataDto {

 List<CircleReplyDto> get list; int get pageNum; int get pageSize; int get pages; int get total;
/// Create a copy of CircleRepliesDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircleRepliesDataDtoCopyWith<CircleRepliesDataDto> get copyWith => _$CircleRepliesDataDtoCopyWithImpl<CircleRepliesDataDto>(this as CircleRepliesDataDto, _$identity);

  /// Serializes this CircleRepliesDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircleRepliesDataDto&&const DeepCollectionEquality().equals(other.list, list)&&(identical(other.pageNum, pageNum) || other.pageNum == pageNum)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.pages, pages) || other.pages == pages)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list),pageNum,pageSize,pages,total);

@override
String toString() {
  return 'CircleRepliesDataDto(list: $list, pageNum: $pageNum, pageSize: $pageSize, pages: $pages, total: $total)';
}


}

/// @nodoc
abstract mixin class $CircleRepliesDataDtoCopyWith<$Res>  {
  factory $CircleRepliesDataDtoCopyWith(CircleRepliesDataDto value, $Res Function(CircleRepliesDataDto) _then) = _$CircleRepliesDataDtoCopyWithImpl;
@useResult
$Res call({
 List<CircleReplyDto> list, int pageNum, int pageSize, int pages, int total
});




}
/// @nodoc
class _$CircleRepliesDataDtoCopyWithImpl<$Res>
    implements $CircleRepliesDataDtoCopyWith<$Res> {
  _$CircleRepliesDataDtoCopyWithImpl(this._self, this._then);

  final CircleRepliesDataDto _self;
  final $Res Function(CircleRepliesDataDto) _then;

/// Create a copy of CircleRepliesDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = null,Object? pageNum = null,Object? pageSize = null,Object? pages = null,Object? total = null,}) {
  return _then(_self.copyWith(
list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<CircleReplyDto>,pageNum: null == pageNum ? _self.pageNum : pageNum // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CircleRepliesDataDto].
extension CircleRepliesDataDtoPatterns on CircleRepliesDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CircleRepliesDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CircleRepliesDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CircleRepliesDataDto value)  $default,){
final _that = this;
switch (_that) {
case _CircleRepliesDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CircleRepliesDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _CircleRepliesDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<CircleReplyDto> list,  int pageNum,  int pageSize,  int pages,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CircleRepliesDataDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<CircleReplyDto> list,  int pageNum,  int pageSize,  int pages,  int total)  $default,) {final _that = this;
switch (_that) {
case _CircleRepliesDataDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<CircleReplyDto> list,  int pageNum,  int pageSize,  int pages,  int total)?  $default,) {final _that = this;
switch (_that) {
case _CircleRepliesDataDto() when $default != null:
return $default(_that.list,_that.pageNum,_that.pageSize,_that.pages,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CircleRepliesDataDto implements CircleRepliesDataDto {
  const _CircleRepliesDataDto({final  List<CircleReplyDto> list = const <CircleReplyDto>[], this.pageNum = 1, this.pageSize = 20, this.pages = 1, this.total = 0}): _list = list;
  factory _CircleRepliesDataDto.fromJson(Map<String, dynamic> json) => _$CircleRepliesDataDtoFromJson(json);

 final  List<CircleReplyDto> _list;
@override@JsonKey() List<CircleReplyDto> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}

@override@JsonKey() final  int pageNum;
@override@JsonKey() final  int pageSize;
@override@JsonKey() final  int pages;
@override@JsonKey() final  int total;

/// Create a copy of CircleRepliesDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CircleRepliesDataDtoCopyWith<_CircleRepliesDataDto> get copyWith => __$CircleRepliesDataDtoCopyWithImpl<_CircleRepliesDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CircleRepliesDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CircleRepliesDataDto&&const DeepCollectionEquality().equals(other._list, _list)&&(identical(other.pageNum, pageNum) || other.pageNum == pageNum)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.pages, pages) || other.pages == pages)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_list),pageNum,pageSize,pages,total);

@override
String toString() {
  return 'CircleRepliesDataDto(list: $list, pageNum: $pageNum, pageSize: $pageSize, pages: $pages, total: $total)';
}


}

/// @nodoc
abstract mixin class _$CircleRepliesDataDtoCopyWith<$Res> implements $CircleRepliesDataDtoCopyWith<$Res> {
  factory _$CircleRepliesDataDtoCopyWith(_CircleRepliesDataDto value, $Res Function(_CircleRepliesDataDto) _then) = __$CircleRepliesDataDtoCopyWithImpl;
@override @useResult
$Res call({
 List<CircleReplyDto> list, int pageNum, int pageSize, int pages, int total
});




}
/// @nodoc
class __$CircleRepliesDataDtoCopyWithImpl<$Res>
    implements _$CircleRepliesDataDtoCopyWith<$Res> {
  __$CircleRepliesDataDtoCopyWithImpl(this._self, this._then);

  final _CircleRepliesDataDto _self;
  final $Res Function(_CircleRepliesDataDto) _then;

/// Create a copy of CircleRepliesDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = null,Object? pageNum = null,Object? pageSize = null,Object? pages = null,Object? total = null,}) {
  return _then(_CircleRepliesDataDto(
list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<CircleReplyDto>,pageNum: null == pageNum ? _self.pageNum : pageNum // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CircleReactionDto {

 int get likeNum; int get badNum; int get myReaction; int get type;
/// Create a copy of CircleReactionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CircleReactionDtoCopyWith<CircleReactionDto> get copyWith => _$CircleReactionDtoCopyWithImpl<CircleReactionDto>(this as CircleReactionDto, _$identity);

  /// Serializes this CircleReactionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircleReactionDto&&(identical(other.likeNum, likeNum) || other.likeNum == likeNum)&&(identical(other.badNum, badNum) || other.badNum == badNum)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,likeNum,badNum,myReaction,type);

@override
String toString() {
  return 'CircleReactionDto(likeNum: $likeNum, badNum: $badNum, myReaction: $myReaction, type: $type)';
}


}

/// @nodoc
abstract mixin class $CircleReactionDtoCopyWith<$Res>  {
  factory $CircleReactionDtoCopyWith(CircleReactionDto value, $Res Function(CircleReactionDto) _then) = _$CircleReactionDtoCopyWithImpl;
@useResult
$Res call({
 int likeNum, int badNum, int myReaction, int type
});




}
/// @nodoc
class _$CircleReactionDtoCopyWithImpl<$Res>
    implements $CircleReactionDtoCopyWith<$Res> {
  _$CircleReactionDtoCopyWithImpl(this._self, this._then);

  final CircleReactionDto _self;
  final $Res Function(CircleReactionDto) _then;

/// Create a copy of CircleReactionDto
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


/// Adds pattern-matching-related methods to [CircleReactionDto].
extension CircleReactionDtoPatterns on CircleReactionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CircleReactionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CircleReactionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CircleReactionDto value)  $default,){
final _that = this;
switch (_that) {
case _CircleReactionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CircleReactionDto value)?  $default,){
final _that = this;
switch (_that) {
case _CircleReactionDto() when $default != null:
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
case _CircleReactionDto() when $default != null:
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
case _CircleReactionDto():
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
case _CircleReactionDto() when $default != null:
return $default(_that.likeNum,_that.badNum,_that.myReaction,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CircleReactionDto implements CircleReactionDto {
  const _CircleReactionDto({this.likeNum = 0, this.badNum = 0, this.myReaction = 0, this.type = 0});
  factory _CircleReactionDto.fromJson(Map<String, dynamic> json) => _$CircleReactionDtoFromJson(json);

@override@JsonKey() final  int likeNum;
@override@JsonKey() final  int badNum;
@override@JsonKey() final  int myReaction;
@override@JsonKey() final  int type;

/// Create a copy of CircleReactionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CircleReactionDtoCopyWith<_CircleReactionDto> get copyWith => __$CircleReactionDtoCopyWithImpl<_CircleReactionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CircleReactionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CircleReactionDto&&(identical(other.likeNum, likeNum) || other.likeNum == likeNum)&&(identical(other.badNum, badNum) || other.badNum == badNum)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,likeNum,badNum,myReaction,type);

@override
String toString() {
  return 'CircleReactionDto(likeNum: $likeNum, badNum: $badNum, myReaction: $myReaction, type: $type)';
}


}

/// @nodoc
abstract mixin class _$CircleReactionDtoCopyWith<$Res> implements $CircleReactionDtoCopyWith<$Res> {
  factory _$CircleReactionDtoCopyWith(_CircleReactionDto value, $Res Function(_CircleReactionDto) _then) = __$CircleReactionDtoCopyWithImpl;
@override @useResult
$Res call({
 int likeNum, int badNum, int myReaction, int type
});




}
/// @nodoc
class __$CircleReactionDtoCopyWithImpl<$Res>
    implements _$CircleReactionDtoCopyWith<$Res> {
  __$CircleReactionDtoCopyWithImpl(this._self, this._then);

  final _CircleReactionDto _self;
  final $Res Function(_CircleReactionDto) _then;

/// Create a copy of CircleReactionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? likeNum = null,Object? badNum = null,Object? myReaction = null,Object? type = null,}) {
  return _then(_CircleReactionDto(
likeNum: null == likeNum ? _self.likeNum : likeNum // ignore: cast_nullable_to_non_nullable
as int,badNum: null == badNum ? _self.badNum : badNum // ignore: cast_nullable_to_non_nullable
as int,myReaction: null == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
