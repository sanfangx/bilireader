// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter_comment_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChapterCommentItemDto {

@JsonKey(fromJson: _looseInt) int get id;@JsonKey(fromJson: _looseInt) int get catid;@JsonKey(fromJson: _looseInt) int get cmtid;@JsonKey(fromJson: _looseInt) int get userid;@JsonKey(fromJson: _looseStr) String? get cmtname;@JsonKey(fromJson: _looseStr) String? get cmtcontent;@JsonKey(fromJson: _looseStr) String? get addtime;@JsonKey(fromJson: _looseInt) int get likeNum;@JsonKey(fromJson: _looseInt) int get badNum;@JsonKey(fromJson: _looseInt) int get myReaction;@JsonKey(fromJson: _looseInt) int get ischeck;@JsonKey(fromJson: _looseInt) int get ishot;@JsonKey(fromJson: _looseInt) int get ispoiler;@JsonKey(fromJson: _looseInt) int get parentid;@JsonKey(fromJson: _looseIntN) int? get avatar;@JsonKey(fromJson: _looseStr) String? get avatarUrl;@JsonKey(fromJson: _looseStr) String? get cmtLevel;
/// Create a copy of ChapterCommentItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterCommentItemDtoCopyWith<ChapterCommentItemDto> get copyWith => _$ChapterCommentItemDtoCopyWithImpl<ChapterCommentItemDto>(this as ChapterCommentItemDto, _$identity);

  /// Serializes this ChapterCommentItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterCommentItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.catid, catid) || other.catid == catid)&&(identical(other.cmtid, cmtid) || other.cmtid == cmtid)&&(identical(other.userid, userid) || other.userid == userid)&&(identical(other.cmtname, cmtname) || other.cmtname == cmtname)&&(identical(other.cmtcontent, cmtcontent) || other.cmtcontent == cmtcontent)&&(identical(other.addtime, addtime) || other.addtime == addtime)&&(identical(other.likeNum, likeNum) || other.likeNum == likeNum)&&(identical(other.badNum, badNum) || other.badNum == badNum)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction)&&(identical(other.ischeck, ischeck) || other.ischeck == ischeck)&&(identical(other.ishot, ishot) || other.ishot == ishot)&&(identical(other.ispoiler, ispoiler) || other.ispoiler == ispoiler)&&(identical(other.parentid, parentid) || other.parentid == parentid)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.cmtLevel, cmtLevel) || other.cmtLevel == cmtLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,catid,cmtid,userid,cmtname,cmtcontent,addtime,likeNum,badNum,myReaction,ischeck,ishot,ispoiler,parentid,avatar,avatarUrl,cmtLevel);

@override
String toString() {
  return 'ChapterCommentItemDto(id: $id, catid: $catid, cmtid: $cmtid, userid: $userid, cmtname: $cmtname, cmtcontent: $cmtcontent, addtime: $addtime, likeNum: $likeNum, badNum: $badNum, myReaction: $myReaction, ischeck: $ischeck, ishot: $ishot, ispoiler: $ispoiler, parentid: $parentid, avatar: $avatar, avatarUrl: $avatarUrl, cmtLevel: $cmtLevel)';
}


}

/// @nodoc
abstract mixin class $ChapterCommentItemDtoCopyWith<$Res>  {
  factory $ChapterCommentItemDtoCopyWith(ChapterCommentItemDto value, $Res Function(ChapterCommentItemDto) _then) = _$ChapterCommentItemDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _looseInt) int id,@JsonKey(fromJson: _looseInt) int catid,@JsonKey(fromJson: _looseInt) int cmtid,@JsonKey(fromJson: _looseInt) int userid,@JsonKey(fromJson: _looseStr) String? cmtname,@JsonKey(fromJson: _looseStr) String? cmtcontent,@JsonKey(fromJson: _looseStr) String? addtime,@JsonKey(fromJson: _looseInt) int likeNum,@JsonKey(fromJson: _looseInt) int badNum,@JsonKey(fromJson: _looseInt) int myReaction,@JsonKey(fromJson: _looseInt) int ischeck,@JsonKey(fromJson: _looseInt) int ishot,@JsonKey(fromJson: _looseInt) int ispoiler,@JsonKey(fromJson: _looseInt) int parentid,@JsonKey(fromJson: _looseIntN) int? avatar,@JsonKey(fromJson: _looseStr) String? avatarUrl,@JsonKey(fromJson: _looseStr) String? cmtLevel
});




}
/// @nodoc
class _$ChapterCommentItemDtoCopyWithImpl<$Res>
    implements $ChapterCommentItemDtoCopyWith<$Res> {
  _$ChapterCommentItemDtoCopyWithImpl(this._self, this._then);

  final ChapterCommentItemDto _self;
  final $Res Function(ChapterCommentItemDto) _then;

/// Create a copy of ChapterCommentItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? catid = null,Object? cmtid = null,Object? userid = null,Object? cmtname = freezed,Object? cmtcontent = freezed,Object? addtime = freezed,Object? likeNum = null,Object? badNum = null,Object? myReaction = null,Object? ischeck = null,Object? ishot = null,Object? ispoiler = null,Object? parentid = null,Object? avatar = freezed,Object? avatarUrl = freezed,Object? cmtLevel = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,catid: null == catid ? _self.catid : catid // ignore: cast_nullable_to_non_nullable
as int,cmtid: null == cmtid ? _self.cmtid : cmtid // ignore: cast_nullable_to_non_nullable
as int,userid: null == userid ? _self.userid : userid // ignore: cast_nullable_to_non_nullable
as int,cmtname: freezed == cmtname ? _self.cmtname : cmtname // ignore: cast_nullable_to_non_nullable
as String?,cmtcontent: freezed == cmtcontent ? _self.cmtcontent : cmtcontent // ignore: cast_nullable_to_non_nullable
as String?,addtime: freezed == addtime ? _self.addtime : addtime // ignore: cast_nullable_to_non_nullable
as String?,likeNum: null == likeNum ? _self.likeNum : likeNum // ignore: cast_nullable_to_non_nullable
as int,badNum: null == badNum ? _self.badNum : badNum // ignore: cast_nullable_to_non_nullable
as int,myReaction: null == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as int,ischeck: null == ischeck ? _self.ischeck : ischeck // ignore: cast_nullable_to_non_nullable
as int,ishot: null == ishot ? _self.ishot : ishot // ignore: cast_nullable_to_non_nullable
as int,ispoiler: null == ispoiler ? _self.ispoiler : ispoiler // ignore: cast_nullable_to_non_nullable
as int,parentid: null == parentid ? _self.parentid : parentid // ignore: cast_nullable_to_non_nullable
as int,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as int?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,cmtLevel: freezed == cmtLevel ? _self.cmtLevel : cmtLevel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChapterCommentItemDto].
extension ChapterCommentItemDtoPatterns on ChapterCommentItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChapterCommentItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChapterCommentItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChapterCommentItemDto value)  $default,){
final _that = this;
switch (_that) {
case _ChapterCommentItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChapterCommentItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _ChapterCommentItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _looseInt)  int id, @JsonKey(fromJson: _looseInt)  int catid, @JsonKey(fromJson: _looseInt)  int cmtid, @JsonKey(fromJson: _looseInt)  int userid, @JsonKey(fromJson: _looseStr)  String? cmtname, @JsonKey(fromJson: _looseStr)  String? cmtcontent, @JsonKey(fromJson: _looseStr)  String? addtime, @JsonKey(fromJson: _looseInt)  int likeNum, @JsonKey(fromJson: _looseInt)  int badNum, @JsonKey(fromJson: _looseInt)  int myReaction, @JsonKey(fromJson: _looseInt)  int ischeck, @JsonKey(fromJson: _looseInt)  int ishot, @JsonKey(fromJson: _looseInt)  int ispoiler, @JsonKey(fromJson: _looseInt)  int parentid, @JsonKey(fromJson: _looseIntN)  int? avatar, @JsonKey(fromJson: _looseStr)  String? avatarUrl, @JsonKey(fromJson: _looseStr)  String? cmtLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChapterCommentItemDto() when $default != null:
return $default(_that.id,_that.catid,_that.cmtid,_that.userid,_that.cmtname,_that.cmtcontent,_that.addtime,_that.likeNum,_that.badNum,_that.myReaction,_that.ischeck,_that.ishot,_that.ispoiler,_that.parentid,_that.avatar,_that.avatarUrl,_that.cmtLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _looseInt)  int id, @JsonKey(fromJson: _looseInt)  int catid, @JsonKey(fromJson: _looseInt)  int cmtid, @JsonKey(fromJson: _looseInt)  int userid, @JsonKey(fromJson: _looseStr)  String? cmtname, @JsonKey(fromJson: _looseStr)  String? cmtcontent, @JsonKey(fromJson: _looseStr)  String? addtime, @JsonKey(fromJson: _looseInt)  int likeNum, @JsonKey(fromJson: _looseInt)  int badNum, @JsonKey(fromJson: _looseInt)  int myReaction, @JsonKey(fromJson: _looseInt)  int ischeck, @JsonKey(fromJson: _looseInt)  int ishot, @JsonKey(fromJson: _looseInt)  int ispoiler, @JsonKey(fromJson: _looseInt)  int parentid, @JsonKey(fromJson: _looseIntN)  int? avatar, @JsonKey(fromJson: _looseStr)  String? avatarUrl, @JsonKey(fromJson: _looseStr)  String? cmtLevel)  $default,) {final _that = this;
switch (_that) {
case _ChapterCommentItemDto():
return $default(_that.id,_that.catid,_that.cmtid,_that.userid,_that.cmtname,_that.cmtcontent,_that.addtime,_that.likeNum,_that.badNum,_that.myReaction,_that.ischeck,_that.ishot,_that.ispoiler,_that.parentid,_that.avatar,_that.avatarUrl,_that.cmtLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _looseInt)  int id, @JsonKey(fromJson: _looseInt)  int catid, @JsonKey(fromJson: _looseInt)  int cmtid, @JsonKey(fromJson: _looseInt)  int userid, @JsonKey(fromJson: _looseStr)  String? cmtname, @JsonKey(fromJson: _looseStr)  String? cmtcontent, @JsonKey(fromJson: _looseStr)  String? addtime, @JsonKey(fromJson: _looseInt)  int likeNum, @JsonKey(fromJson: _looseInt)  int badNum, @JsonKey(fromJson: _looseInt)  int myReaction, @JsonKey(fromJson: _looseInt)  int ischeck, @JsonKey(fromJson: _looseInt)  int ishot, @JsonKey(fromJson: _looseInt)  int ispoiler, @JsonKey(fromJson: _looseInt)  int parentid, @JsonKey(fromJson: _looseIntN)  int? avatar, @JsonKey(fromJson: _looseStr)  String? avatarUrl, @JsonKey(fromJson: _looseStr)  String? cmtLevel)?  $default,) {final _that = this;
switch (_that) {
case _ChapterCommentItemDto() when $default != null:
return $default(_that.id,_that.catid,_that.cmtid,_that.userid,_that.cmtname,_that.cmtcontent,_that.addtime,_that.likeNum,_that.badNum,_that.myReaction,_that.ischeck,_that.ishot,_that.ispoiler,_that.parentid,_that.avatar,_that.avatarUrl,_that.cmtLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChapterCommentItemDto implements ChapterCommentItemDto {
  const _ChapterCommentItemDto({@JsonKey(fromJson: _looseInt) this.id = 0, @JsonKey(fromJson: _looseInt) this.catid = 0, @JsonKey(fromJson: _looseInt) this.cmtid = 0, @JsonKey(fromJson: _looseInt) this.userid = 0, @JsonKey(fromJson: _looseStr) this.cmtname, @JsonKey(fromJson: _looseStr) this.cmtcontent, @JsonKey(fromJson: _looseStr) this.addtime, @JsonKey(fromJson: _looseInt) this.likeNum = 0, @JsonKey(fromJson: _looseInt) this.badNum = 0, @JsonKey(fromJson: _looseInt) this.myReaction = 0, @JsonKey(fromJson: _looseInt) this.ischeck = 0, @JsonKey(fromJson: _looseInt) this.ishot = 0, @JsonKey(fromJson: _looseInt) this.ispoiler = 0, @JsonKey(fromJson: _looseInt) this.parentid = 0, @JsonKey(fromJson: _looseIntN) this.avatar, @JsonKey(fromJson: _looseStr) this.avatarUrl, @JsonKey(fromJson: _looseStr) this.cmtLevel});
  factory _ChapterCommentItemDto.fromJson(Map<String, dynamic> json) => _$ChapterCommentItemDtoFromJson(json);

@override@JsonKey(fromJson: _looseInt) final  int id;
@override@JsonKey(fromJson: _looseInt) final  int catid;
@override@JsonKey(fromJson: _looseInt) final  int cmtid;
@override@JsonKey(fromJson: _looseInt) final  int userid;
@override@JsonKey(fromJson: _looseStr) final  String? cmtname;
@override@JsonKey(fromJson: _looseStr) final  String? cmtcontent;
@override@JsonKey(fromJson: _looseStr) final  String? addtime;
@override@JsonKey(fromJson: _looseInt) final  int likeNum;
@override@JsonKey(fromJson: _looseInt) final  int badNum;
@override@JsonKey(fromJson: _looseInt) final  int myReaction;
@override@JsonKey(fromJson: _looseInt) final  int ischeck;
@override@JsonKey(fromJson: _looseInt) final  int ishot;
@override@JsonKey(fromJson: _looseInt) final  int ispoiler;
@override@JsonKey(fromJson: _looseInt) final  int parentid;
@override@JsonKey(fromJson: _looseIntN) final  int? avatar;
@override@JsonKey(fromJson: _looseStr) final  String? avatarUrl;
@override@JsonKey(fromJson: _looseStr) final  String? cmtLevel;

/// Create a copy of ChapterCommentItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterCommentItemDtoCopyWith<_ChapterCommentItemDto> get copyWith => __$ChapterCommentItemDtoCopyWithImpl<_ChapterCommentItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChapterCommentItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChapterCommentItemDto&&(identical(other.id, id) || other.id == id)&&(identical(other.catid, catid) || other.catid == catid)&&(identical(other.cmtid, cmtid) || other.cmtid == cmtid)&&(identical(other.userid, userid) || other.userid == userid)&&(identical(other.cmtname, cmtname) || other.cmtname == cmtname)&&(identical(other.cmtcontent, cmtcontent) || other.cmtcontent == cmtcontent)&&(identical(other.addtime, addtime) || other.addtime == addtime)&&(identical(other.likeNum, likeNum) || other.likeNum == likeNum)&&(identical(other.badNum, badNum) || other.badNum == badNum)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction)&&(identical(other.ischeck, ischeck) || other.ischeck == ischeck)&&(identical(other.ishot, ishot) || other.ishot == ishot)&&(identical(other.ispoiler, ispoiler) || other.ispoiler == ispoiler)&&(identical(other.parentid, parentid) || other.parentid == parentid)&&(identical(other.avatar, avatar) || other.avatar == avatar)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.cmtLevel, cmtLevel) || other.cmtLevel == cmtLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,catid,cmtid,userid,cmtname,cmtcontent,addtime,likeNum,badNum,myReaction,ischeck,ishot,ispoiler,parentid,avatar,avatarUrl,cmtLevel);

@override
String toString() {
  return 'ChapterCommentItemDto(id: $id, catid: $catid, cmtid: $cmtid, userid: $userid, cmtname: $cmtname, cmtcontent: $cmtcontent, addtime: $addtime, likeNum: $likeNum, badNum: $badNum, myReaction: $myReaction, ischeck: $ischeck, ishot: $ishot, ispoiler: $ispoiler, parentid: $parentid, avatar: $avatar, avatarUrl: $avatarUrl, cmtLevel: $cmtLevel)';
}


}

/// @nodoc
abstract mixin class _$ChapterCommentItemDtoCopyWith<$Res> implements $ChapterCommentItemDtoCopyWith<$Res> {
  factory _$ChapterCommentItemDtoCopyWith(_ChapterCommentItemDto value, $Res Function(_ChapterCommentItemDto) _then) = __$ChapterCommentItemDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _looseInt) int id,@JsonKey(fromJson: _looseInt) int catid,@JsonKey(fromJson: _looseInt) int cmtid,@JsonKey(fromJson: _looseInt) int userid,@JsonKey(fromJson: _looseStr) String? cmtname,@JsonKey(fromJson: _looseStr) String? cmtcontent,@JsonKey(fromJson: _looseStr) String? addtime,@JsonKey(fromJson: _looseInt) int likeNum,@JsonKey(fromJson: _looseInt) int badNum,@JsonKey(fromJson: _looseInt) int myReaction,@JsonKey(fromJson: _looseInt) int ischeck,@JsonKey(fromJson: _looseInt) int ishot,@JsonKey(fromJson: _looseInt) int ispoiler,@JsonKey(fromJson: _looseInt) int parentid,@JsonKey(fromJson: _looseIntN) int? avatar,@JsonKey(fromJson: _looseStr) String? avatarUrl,@JsonKey(fromJson: _looseStr) String? cmtLevel
});




}
/// @nodoc
class __$ChapterCommentItemDtoCopyWithImpl<$Res>
    implements _$ChapterCommentItemDtoCopyWith<$Res> {
  __$ChapterCommentItemDtoCopyWithImpl(this._self, this._then);

  final _ChapterCommentItemDto _self;
  final $Res Function(_ChapterCommentItemDto) _then;

/// Create a copy of ChapterCommentItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? catid = null,Object? cmtid = null,Object? userid = null,Object? cmtname = freezed,Object? cmtcontent = freezed,Object? addtime = freezed,Object? likeNum = null,Object? badNum = null,Object? myReaction = null,Object? ischeck = null,Object? ishot = null,Object? ispoiler = null,Object? parentid = null,Object? avatar = freezed,Object? avatarUrl = freezed,Object? cmtLevel = freezed,}) {
  return _then(_ChapterCommentItemDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,catid: null == catid ? _self.catid : catid // ignore: cast_nullable_to_non_nullable
as int,cmtid: null == cmtid ? _self.cmtid : cmtid // ignore: cast_nullable_to_non_nullable
as int,userid: null == userid ? _self.userid : userid // ignore: cast_nullable_to_non_nullable
as int,cmtname: freezed == cmtname ? _self.cmtname : cmtname // ignore: cast_nullable_to_non_nullable
as String?,cmtcontent: freezed == cmtcontent ? _self.cmtcontent : cmtcontent // ignore: cast_nullable_to_non_nullable
as String?,addtime: freezed == addtime ? _self.addtime : addtime // ignore: cast_nullable_to_non_nullable
as String?,likeNum: null == likeNum ? _self.likeNum : likeNum // ignore: cast_nullable_to_non_nullable
as int,badNum: null == badNum ? _self.badNum : badNum // ignore: cast_nullable_to_non_nullable
as int,myReaction: null == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as int,ischeck: null == ischeck ? _self.ischeck : ischeck // ignore: cast_nullable_to_non_nullable
as int,ishot: null == ishot ? _self.ishot : ishot // ignore: cast_nullable_to_non_nullable
as int,ispoiler: null == ispoiler ? _self.ispoiler : ispoiler // ignore: cast_nullable_to_non_nullable
as int,parentid: null == parentid ? _self.parentid : parentid // ignore: cast_nullable_to_non_nullable
as int,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as int?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,cmtLevel: freezed == cmtLevel ? _self.cmtLevel : cmtLevel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ChapterCommentListDataDto {

 List<ChapterCommentItemDto> get list; int get pageNum; int get pageSize; int get pages; int get total;
/// Create a copy of ChapterCommentListDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterCommentListDataDtoCopyWith<ChapterCommentListDataDto> get copyWith => _$ChapterCommentListDataDtoCopyWithImpl<ChapterCommentListDataDto>(this as ChapterCommentListDataDto, _$identity);

  /// Serializes this ChapterCommentListDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterCommentListDataDto&&const DeepCollectionEquality().equals(other.list, list)&&(identical(other.pageNum, pageNum) || other.pageNum == pageNum)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.pages, pages) || other.pages == pages)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list),pageNum,pageSize,pages,total);

@override
String toString() {
  return 'ChapterCommentListDataDto(list: $list, pageNum: $pageNum, pageSize: $pageSize, pages: $pages, total: $total)';
}


}

/// @nodoc
abstract mixin class $ChapterCommentListDataDtoCopyWith<$Res>  {
  factory $ChapterCommentListDataDtoCopyWith(ChapterCommentListDataDto value, $Res Function(ChapterCommentListDataDto) _then) = _$ChapterCommentListDataDtoCopyWithImpl;
@useResult
$Res call({
 List<ChapterCommentItemDto> list, int pageNum, int pageSize, int pages, int total
});




}
/// @nodoc
class _$ChapterCommentListDataDtoCopyWithImpl<$Res>
    implements $ChapterCommentListDataDtoCopyWith<$Res> {
  _$ChapterCommentListDataDtoCopyWithImpl(this._self, this._then);

  final ChapterCommentListDataDto _self;
  final $Res Function(ChapterCommentListDataDto) _then;

/// Create a copy of ChapterCommentListDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = null,Object? pageNum = null,Object? pageSize = null,Object? pages = null,Object? total = null,}) {
  return _then(_self.copyWith(
list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<ChapterCommentItemDto>,pageNum: null == pageNum ? _self.pageNum : pageNum // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChapterCommentListDataDto].
extension ChapterCommentListDataDtoPatterns on ChapterCommentListDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChapterCommentListDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChapterCommentListDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChapterCommentListDataDto value)  $default,){
final _that = this;
switch (_that) {
case _ChapterCommentListDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChapterCommentListDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _ChapterCommentListDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChapterCommentItemDto> list,  int pageNum,  int pageSize,  int pages,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChapterCommentListDataDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChapterCommentItemDto> list,  int pageNum,  int pageSize,  int pages,  int total)  $default,) {final _that = this;
switch (_that) {
case _ChapterCommentListDataDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChapterCommentItemDto> list,  int pageNum,  int pageSize,  int pages,  int total)?  $default,) {final _that = this;
switch (_that) {
case _ChapterCommentListDataDto() when $default != null:
return $default(_that.list,_that.pageNum,_that.pageSize,_that.pages,_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChapterCommentListDataDto implements ChapterCommentListDataDto {
  const _ChapterCommentListDataDto({final  List<ChapterCommentItemDto> list = const <ChapterCommentItemDto>[], this.pageNum = 1, this.pageSize = 20, this.pages = 1, this.total = 0}): _list = list;
  factory _ChapterCommentListDataDto.fromJson(Map<String, dynamic> json) => _$ChapterCommentListDataDtoFromJson(json);

 final  List<ChapterCommentItemDto> _list;
@override@JsonKey() List<ChapterCommentItemDto> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}

@override@JsonKey() final  int pageNum;
@override@JsonKey() final  int pageSize;
@override@JsonKey() final  int pages;
@override@JsonKey() final  int total;

/// Create a copy of ChapterCommentListDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterCommentListDataDtoCopyWith<_ChapterCommentListDataDto> get copyWith => __$ChapterCommentListDataDtoCopyWithImpl<_ChapterCommentListDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChapterCommentListDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChapterCommentListDataDto&&const DeepCollectionEquality().equals(other._list, _list)&&(identical(other.pageNum, pageNum) || other.pageNum == pageNum)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.pages, pages) || other.pages == pages)&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_list),pageNum,pageSize,pages,total);

@override
String toString() {
  return 'ChapterCommentListDataDto(list: $list, pageNum: $pageNum, pageSize: $pageSize, pages: $pages, total: $total)';
}


}

/// @nodoc
abstract mixin class _$ChapterCommentListDataDtoCopyWith<$Res> implements $ChapterCommentListDataDtoCopyWith<$Res> {
  factory _$ChapterCommentListDataDtoCopyWith(_ChapterCommentListDataDto value, $Res Function(_ChapterCommentListDataDto) _then) = __$ChapterCommentListDataDtoCopyWithImpl;
@override @useResult
$Res call({
 List<ChapterCommentItemDto> list, int pageNum, int pageSize, int pages, int total
});




}
/// @nodoc
class __$ChapterCommentListDataDtoCopyWithImpl<$Res>
    implements _$ChapterCommentListDataDtoCopyWith<$Res> {
  __$ChapterCommentListDataDtoCopyWithImpl(this._self, this._then);

  final _ChapterCommentListDataDto _self;
  final $Res Function(_ChapterCommentListDataDto) _then;

/// Create a copy of ChapterCommentListDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = null,Object? pageNum = null,Object? pageSize = null,Object? pages = null,Object? total = null,}) {
  return _then(_ChapterCommentListDataDto(
list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<ChapterCommentItemDto>,pageNum: null == pageNum ? _self.pageNum : pageNum // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,pages: null == pages ? _self.pages : pages // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ChapterCommentReactionDto {

 int get likeNum; int get badNum; int get myReaction;
/// Create a copy of ChapterCommentReactionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterCommentReactionDtoCopyWith<ChapterCommentReactionDto> get copyWith => _$ChapterCommentReactionDtoCopyWithImpl<ChapterCommentReactionDto>(this as ChapterCommentReactionDto, _$identity);

  /// Serializes this ChapterCommentReactionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterCommentReactionDto&&(identical(other.likeNum, likeNum) || other.likeNum == likeNum)&&(identical(other.badNum, badNum) || other.badNum == badNum)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,likeNum,badNum,myReaction);

@override
String toString() {
  return 'ChapterCommentReactionDto(likeNum: $likeNum, badNum: $badNum, myReaction: $myReaction)';
}


}

/// @nodoc
abstract mixin class $ChapterCommentReactionDtoCopyWith<$Res>  {
  factory $ChapterCommentReactionDtoCopyWith(ChapterCommentReactionDto value, $Res Function(ChapterCommentReactionDto) _then) = _$ChapterCommentReactionDtoCopyWithImpl;
@useResult
$Res call({
 int likeNum, int badNum, int myReaction
});




}
/// @nodoc
class _$ChapterCommentReactionDtoCopyWithImpl<$Res>
    implements $ChapterCommentReactionDtoCopyWith<$Res> {
  _$ChapterCommentReactionDtoCopyWithImpl(this._self, this._then);

  final ChapterCommentReactionDto _self;
  final $Res Function(ChapterCommentReactionDto) _then;

/// Create a copy of ChapterCommentReactionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? likeNum = null,Object? badNum = null,Object? myReaction = null,}) {
  return _then(_self.copyWith(
likeNum: null == likeNum ? _self.likeNum : likeNum // ignore: cast_nullable_to_non_nullable
as int,badNum: null == badNum ? _self.badNum : badNum // ignore: cast_nullable_to_non_nullable
as int,myReaction: null == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChapterCommentReactionDto].
extension ChapterCommentReactionDtoPatterns on ChapterCommentReactionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChapterCommentReactionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChapterCommentReactionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChapterCommentReactionDto value)  $default,){
final _that = this;
switch (_that) {
case _ChapterCommentReactionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChapterCommentReactionDto value)?  $default,){
final _that = this;
switch (_that) {
case _ChapterCommentReactionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int likeNum,  int badNum,  int myReaction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChapterCommentReactionDto() when $default != null:
return $default(_that.likeNum,_that.badNum,_that.myReaction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int likeNum,  int badNum,  int myReaction)  $default,) {final _that = this;
switch (_that) {
case _ChapterCommentReactionDto():
return $default(_that.likeNum,_that.badNum,_that.myReaction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int likeNum,  int badNum,  int myReaction)?  $default,) {final _that = this;
switch (_that) {
case _ChapterCommentReactionDto() when $default != null:
return $default(_that.likeNum,_that.badNum,_that.myReaction);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChapterCommentReactionDto implements ChapterCommentReactionDto {
  const _ChapterCommentReactionDto({this.likeNum = 0, this.badNum = 0, this.myReaction = 0});
  factory _ChapterCommentReactionDto.fromJson(Map<String, dynamic> json) => _$ChapterCommentReactionDtoFromJson(json);

@override@JsonKey() final  int likeNum;
@override@JsonKey() final  int badNum;
@override@JsonKey() final  int myReaction;

/// Create a copy of ChapterCommentReactionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterCommentReactionDtoCopyWith<_ChapterCommentReactionDto> get copyWith => __$ChapterCommentReactionDtoCopyWithImpl<_ChapterCommentReactionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChapterCommentReactionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChapterCommentReactionDto&&(identical(other.likeNum, likeNum) || other.likeNum == likeNum)&&(identical(other.badNum, badNum) || other.badNum == badNum)&&(identical(other.myReaction, myReaction) || other.myReaction == myReaction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,likeNum,badNum,myReaction);

@override
String toString() {
  return 'ChapterCommentReactionDto(likeNum: $likeNum, badNum: $badNum, myReaction: $myReaction)';
}


}

/// @nodoc
abstract mixin class _$ChapterCommentReactionDtoCopyWith<$Res> implements $ChapterCommentReactionDtoCopyWith<$Res> {
  factory _$ChapterCommentReactionDtoCopyWith(_ChapterCommentReactionDto value, $Res Function(_ChapterCommentReactionDto) _then) = __$ChapterCommentReactionDtoCopyWithImpl;
@override @useResult
$Res call({
 int likeNum, int badNum, int myReaction
});




}
/// @nodoc
class __$ChapterCommentReactionDtoCopyWithImpl<$Res>
    implements _$ChapterCommentReactionDtoCopyWith<$Res> {
  __$ChapterCommentReactionDtoCopyWithImpl(this._self, this._then);

  final _ChapterCommentReactionDto _self;
  final $Res Function(_ChapterCommentReactionDto) _then;

/// Create a copy of ChapterCommentReactionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? likeNum = null,Object? badNum = null,Object? myReaction = null,}) {
  return _then(_ChapterCommentReactionDto(
likeNum: null == likeNum ? _self.likeNum : likeNum // ignore: cast_nullable_to_non_nullable
as int,badNum: null == badNum ? _self.badNum : badNum // ignore: cast_nullable_to_non_nullable
as int,myReaction: null == myReaction ? _self.myReaction : myReaction // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
