// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppNotificationDto {

 int get notifyid; String? get ntype; String? get nstype; int get fuid; String? get funame; int get isread; int get addtime; int get eid; String? get ename; String? get ncontent; String? get modname; String? get etype; int get upptime;
/// Create a copy of AppNotificationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppNotificationDtoCopyWith<AppNotificationDto> get copyWith => _$AppNotificationDtoCopyWithImpl<AppNotificationDto>(this as AppNotificationDto, _$identity);

  /// Serializes this AppNotificationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppNotificationDto&&(identical(other.notifyid, notifyid) || other.notifyid == notifyid)&&(identical(other.ntype, ntype) || other.ntype == ntype)&&(identical(other.nstype, nstype) || other.nstype == nstype)&&(identical(other.fuid, fuid) || other.fuid == fuid)&&(identical(other.funame, funame) || other.funame == funame)&&(identical(other.isread, isread) || other.isread == isread)&&(identical(other.addtime, addtime) || other.addtime == addtime)&&(identical(other.eid, eid) || other.eid == eid)&&(identical(other.ename, ename) || other.ename == ename)&&(identical(other.ncontent, ncontent) || other.ncontent == ncontent)&&(identical(other.modname, modname) || other.modname == modname)&&(identical(other.etype, etype) || other.etype == etype)&&(identical(other.upptime, upptime) || other.upptime == upptime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notifyid,ntype,nstype,fuid,funame,isread,addtime,eid,ename,ncontent,modname,etype,upptime);

@override
String toString() {
  return 'AppNotificationDto(notifyid: $notifyid, ntype: $ntype, nstype: $nstype, fuid: $fuid, funame: $funame, isread: $isread, addtime: $addtime, eid: $eid, ename: $ename, ncontent: $ncontent, modname: $modname, etype: $etype, upptime: $upptime)';
}


}

/// @nodoc
abstract mixin class $AppNotificationDtoCopyWith<$Res>  {
  factory $AppNotificationDtoCopyWith(AppNotificationDto value, $Res Function(AppNotificationDto) _then) = _$AppNotificationDtoCopyWithImpl;
@useResult
$Res call({
 int notifyid, String? ntype, String? nstype, int fuid, String? funame, int isread, int addtime, int eid, String? ename, String? ncontent, String? modname, String? etype, int upptime
});




}
/// @nodoc
class _$AppNotificationDtoCopyWithImpl<$Res>
    implements $AppNotificationDtoCopyWith<$Res> {
  _$AppNotificationDtoCopyWithImpl(this._self, this._then);

  final AppNotificationDto _self;
  final $Res Function(AppNotificationDto) _then;

/// Create a copy of AppNotificationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notifyid = null,Object? ntype = freezed,Object? nstype = freezed,Object? fuid = null,Object? funame = freezed,Object? isread = null,Object? addtime = null,Object? eid = null,Object? ename = freezed,Object? ncontent = freezed,Object? modname = freezed,Object? etype = freezed,Object? upptime = null,}) {
  return _then(_self.copyWith(
notifyid: null == notifyid ? _self.notifyid : notifyid // ignore: cast_nullable_to_non_nullable
as int,ntype: freezed == ntype ? _self.ntype : ntype // ignore: cast_nullable_to_non_nullable
as String?,nstype: freezed == nstype ? _self.nstype : nstype // ignore: cast_nullable_to_non_nullable
as String?,fuid: null == fuid ? _self.fuid : fuid // ignore: cast_nullable_to_non_nullable
as int,funame: freezed == funame ? _self.funame : funame // ignore: cast_nullable_to_non_nullable
as String?,isread: null == isread ? _self.isread : isread // ignore: cast_nullable_to_non_nullable
as int,addtime: null == addtime ? _self.addtime : addtime // ignore: cast_nullable_to_non_nullable
as int,eid: null == eid ? _self.eid : eid // ignore: cast_nullable_to_non_nullable
as int,ename: freezed == ename ? _self.ename : ename // ignore: cast_nullable_to_non_nullable
as String?,ncontent: freezed == ncontent ? _self.ncontent : ncontent // ignore: cast_nullable_to_non_nullable
as String?,modname: freezed == modname ? _self.modname : modname // ignore: cast_nullable_to_non_nullable
as String?,etype: freezed == etype ? _self.etype : etype // ignore: cast_nullable_to_non_nullable
as String?,upptime: null == upptime ? _self.upptime : upptime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AppNotificationDto].
extension AppNotificationDtoPatterns on AppNotificationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppNotificationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppNotificationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppNotificationDto value)  $default,){
final _that = this;
switch (_that) {
case _AppNotificationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppNotificationDto value)?  $default,){
final _that = this;
switch (_that) {
case _AppNotificationDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int notifyid,  String? ntype,  String? nstype,  int fuid,  String? funame,  int isread,  int addtime,  int eid,  String? ename,  String? ncontent,  String? modname,  String? etype,  int upptime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppNotificationDto() when $default != null:
return $default(_that.notifyid,_that.ntype,_that.nstype,_that.fuid,_that.funame,_that.isread,_that.addtime,_that.eid,_that.ename,_that.ncontent,_that.modname,_that.etype,_that.upptime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int notifyid,  String? ntype,  String? nstype,  int fuid,  String? funame,  int isread,  int addtime,  int eid,  String? ename,  String? ncontent,  String? modname,  String? etype,  int upptime)  $default,) {final _that = this;
switch (_that) {
case _AppNotificationDto():
return $default(_that.notifyid,_that.ntype,_that.nstype,_that.fuid,_that.funame,_that.isread,_that.addtime,_that.eid,_that.ename,_that.ncontent,_that.modname,_that.etype,_that.upptime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int notifyid,  String? ntype,  String? nstype,  int fuid,  String? funame,  int isread,  int addtime,  int eid,  String? ename,  String? ncontent,  String? modname,  String? etype,  int upptime)?  $default,) {final _that = this;
switch (_that) {
case _AppNotificationDto() when $default != null:
return $default(_that.notifyid,_that.ntype,_that.nstype,_that.fuid,_that.funame,_that.isread,_that.addtime,_that.eid,_that.ename,_that.ncontent,_that.modname,_that.etype,_that.upptime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppNotificationDto implements AppNotificationDto {
  const _AppNotificationDto({this.notifyid = 0, this.ntype, this.nstype, this.fuid = 0, this.funame, this.isread = 0, this.addtime = 0, this.eid = 0, this.ename, this.ncontent, this.modname, this.etype, this.upptime = 0});
  factory _AppNotificationDto.fromJson(Map<String, dynamic> json) => _$AppNotificationDtoFromJson(json);

@override@JsonKey() final  int notifyid;
@override final  String? ntype;
@override final  String? nstype;
@override@JsonKey() final  int fuid;
@override final  String? funame;
@override@JsonKey() final  int isread;
@override@JsonKey() final  int addtime;
@override@JsonKey() final  int eid;
@override final  String? ename;
@override final  String? ncontent;
@override final  String? modname;
@override final  String? etype;
@override@JsonKey() final  int upptime;

/// Create a copy of AppNotificationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppNotificationDtoCopyWith<_AppNotificationDto> get copyWith => __$AppNotificationDtoCopyWithImpl<_AppNotificationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppNotificationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppNotificationDto&&(identical(other.notifyid, notifyid) || other.notifyid == notifyid)&&(identical(other.ntype, ntype) || other.ntype == ntype)&&(identical(other.nstype, nstype) || other.nstype == nstype)&&(identical(other.fuid, fuid) || other.fuid == fuid)&&(identical(other.funame, funame) || other.funame == funame)&&(identical(other.isread, isread) || other.isread == isread)&&(identical(other.addtime, addtime) || other.addtime == addtime)&&(identical(other.eid, eid) || other.eid == eid)&&(identical(other.ename, ename) || other.ename == ename)&&(identical(other.ncontent, ncontent) || other.ncontent == ncontent)&&(identical(other.modname, modname) || other.modname == modname)&&(identical(other.etype, etype) || other.etype == etype)&&(identical(other.upptime, upptime) || other.upptime == upptime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,notifyid,ntype,nstype,fuid,funame,isread,addtime,eid,ename,ncontent,modname,etype,upptime);

@override
String toString() {
  return 'AppNotificationDto(notifyid: $notifyid, ntype: $ntype, nstype: $nstype, fuid: $fuid, funame: $funame, isread: $isread, addtime: $addtime, eid: $eid, ename: $ename, ncontent: $ncontent, modname: $modname, etype: $etype, upptime: $upptime)';
}


}

/// @nodoc
abstract mixin class _$AppNotificationDtoCopyWith<$Res> implements $AppNotificationDtoCopyWith<$Res> {
  factory _$AppNotificationDtoCopyWith(_AppNotificationDto value, $Res Function(_AppNotificationDto) _then) = __$AppNotificationDtoCopyWithImpl;
@override @useResult
$Res call({
 int notifyid, String? ntype, String? nstype, int fuid, String? funame, int isread, int addtime, int eid, String? ename, String? ncontent, String? modname, String? etype, int upptime
});




}
/// @nodoc
class __$AppNotificationDtoCopyWithImpl<$Res>
    implements _$AppNotificationDtoCopyWith<$Res> {
  __$AppNotificationDtoCopyWithImpl(this._self, this._then);

  final _AppNotificationDto _self;
  final $Res Function(_AppNotificationDto) _then;

/// Create a copy of AppNotificationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notifyid = null,Object? ntype = freezed,Object? nstype = freezed,Object? fuid = null,Object? funame = freezed,Object? isread = null,Object? addtime = null,Object? eid = null,Object? ename = freezed,Object? ncontent = freezed,Object? modname = freezed,Object? etype = freezed,Object? upptime = null,}) {
  return _then(_AppNotificationDto(
notifyid: null == notifyid ? _self.notifyid : notifyid // ignore: cast_nullable_to_non_nullable
as int,ntype: freezed == ntype ? _self.ntype : ntype // ignore: cast_nullable_to_non_nullable
as String?,nstype: freezed == nstype ? _self.nstype : nstype // ignore: cast_nullable_to_non_nullable
as String?,fuid: null == fuid ? _self.fuid : fuid // ignore: cast_nullable_to_non_nullable
as int,funame: freezed == funame ? _self.funame : funame // ignore: cast_nullable_to_non_nullable
as String?,isread: null == isread ? _self.isread : isread // ignore: cast_nullable_to_non_nullable
as int,addtime: null == addtime ? _self.addtime : addtime // ignore: cast_nullable_to_non_nullable
as int,eid: null == eid ? _self.eid : eid // ignore: cast_nullable_to_non_nullable
as int,ename: freezed == ename ? _self.ename : ename // ignore: cast_nullable_to_non_nullable
as String?,ncontent: freezed == ncontent ? _self.ncontent : ncontent // ignore: cast_nullable_to_non_nullable
as String?,modname: freezed == modname ? _self.modname : modname // ignore: cast_nullable_to_non_nullable
as String?,etype: freezed == etype ? _self.etype : etype // ignore: cast_nullable_to_non_nullable
as String?,upptime: null == upptime ? _self.upptime : upptime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AppNotificationContentDto {

 String? get action; int? get articleId; String? get body; int? get fromUserId; String? get fromUserName; int? get postId; int? get replyPid; String? get subtype; String? get title; int? get topicId;
/// Create a copy of AppNotificationContentDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppNotificationContentDtoCopyWith<AppNotificationContentDto> get copyWith => _$AppNotificationContentDtoCopyWithImpl<AppNotificationContentDto>(this as AppNotificationContentDto, _$identity);

  /// Serializes this AppNotificationContentDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppNotificationContentDto&&(identical(other.action, action) || other.action == action)&&(identical(other.articleId, articleId) || other.articleId == articleId)&&(identical(other.body, body) || other.body == body)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.fromUserName, fromUserName) || other.fromUserName == fromUserName)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.replyPid, replyPid) || other.replyPid == replyPid)&&(identical(other.subtype, subtype) || other.subtype == subtype)&&(identical(other.title, title) || other.title == title)&&(identical(other.topicId, topicId) || other.topicId == topicId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,action,articleId,body,fromUserId,fromUserName,postId,replyPid,subtype,title,topicId);

@override
String toString() {
  return 'AppNotificationContentDto(action: $action, articleId: $articleId, body: $body, fromUserId: $fromUserId, fromUserName: $fromUserName, postId: $postId, replyPid: $replyPid, subtype: $subtype, title: $title, topicId: $topicId)';
}


}

/// @nodoc
abstract mixin class $AppNotificationContentDtoCopyWith<$Res>  {
  factory $AppNotificationContentDtoCopyWith(AppNotificationContentDto value, $Res Function(AppNotificationContentDto) _then) = _$AppNotificationContentDtoCopyWithImpl;
@useResult
$Res call({
 String? action, int? articleId, String? body, int? fromUserId, String? fromUserName, int? postId, int? replyPid, String? subtype, String? title, int? topicId
});




}
/// @nodoc
class _$AppNotificationContentDtoCopyWithImpl<$Res>
    implements $AppNotificationContentDtoCopyWith<$Res> {
  _$AppNotificationContentDtoCopyWithImpl(this._self, this._then);

  final AppNotificationContentDto _self;
  final $Res Function(AppNotificationContentDto) _then;

/// Create a copy of AppNotificationContentDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = freezed,Object? articleId = freezed,Object? body = freezed,Object? fromUserId = freezed,Object? fromUserName = freezed,Object? postId = freezed,Object? replyPid = freezed,Object? subtype = freezed,Object? title = freezed,Object? topicId = freezed,}) {
  return _then(_self.copyWith(
action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,articleId: freezed == articleId ? _self.articleId : articleId // ignore: cast_nullable_to_non_nullable
as int?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,fromUserId: freezed == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as int?,fromUserName: freezed == fromUserName ? _self.fromUserName : fromUserName // ignore: cast_nullable_to_non_nullable
as String?,postId: freezed == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as int?,replyPid: freezed == replyPid ? _self.replyPid : replyPid // ignore: cast_nullable_to_non_nullable
as int?,subtype: freezed == subtype ? _self.subtype : subtype // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,topicId: freezed == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppNotificationContentDto].
extension AppNotificationContentDtoPatterns on AppNotificationContentDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppNotificationContentDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppNotificationContentDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppNotificationContentDto value)  $default,){
final _that = this;
switch (_that) {
case _AppNotificationContentDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppNotificationContentDto value)?  $default,){
final _that = this;
switch (_that) {
case _AppNotificationContentDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? action,  int? articleId,  String? body,  int? fromUserId,  String? fromUserName,  int? postId,  int? replyPid,  String? subtype,  String? title,  int? topicId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppNotificationContentDto() when $default != null:
return $default(_that.action,_that.articleId,_that.body,_that.fromUserId,_that.fromUserName,_that.postId,_that.replyPid,_that.subtype,_that.title,_that.topicId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? action,  int? articleId,  String? body,  int? fromUserId,  String? fromUserName,  int? postId,  int? replyPid,  String? subtype,  String? title,  int? topicId)  $default,) {final _that = this;
switch (_that) {
case _AppNotificationContentDto():
return $default(_that.action,_that.articleId,_that.body,_that.fromUserId,_that.fromUserName,_that.postId,_that.replyPid,_that.subtype,_that.title,_that.topicId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? action,  int? articleId,  String? body,  int? fromUserId,  String? fromUserName,  int? postId,  int? replyPid,  String? subtype,  String? title,  int? topicId)?  $default,) {final _that = this;
switch (_that) {
case _AppNotificationContentDto() when $default != null:
return $default(_that.action,_that.articleId,_that.body,_that.fromUserId,_that.fromUserName,_that.postId,_that.replyPid,_that.subtype,_that.title,_that.topicId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppNotificationContentDto implements AppNotificationContentDto {
  const _AppNotificationContentDto({this.action, this.articleId, this.body, this.fromUserId, this.fromUserName, this.postId, this.replyPid, this.subtype, this.title, this.topicId});
  factory _AppNotificationContentDto.fromJson(Map<String, dynamic> json) => _$AppNotificationContentDtoFromJson(json);

@override final  String? action;
@override final  int? articleId;
@override final  String? body;
@override final  int? fromUserId;
@override final  String? fromUserName;
@override final  int? postId;
@override final  int? replyPid;
@override final  String? subtype;
@override final  String? title;
@override final  int? topicId;

/// Create a copy of AppNotificationContentDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppNotificationContentDtoCopyWith<_AppNotificationContentDto> get copyWith => __$AppNotificationContentDtoCopyWithImpl<_AppNotificationContentDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppNotificationContentDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppNotificationContentDto&&(identical(other.action, action) || other.action == action)&&(identical(other.articleId, articleId) || other.articleId == articleId)&&(identical(other.body, body) || other.body == body)&&(identical(other.fromUserId, fromUserId) || other.fromUserId == fromUserId)&&(identical(other.fromUserName, fromUserName) || other.fromUserName == fromUserName)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.replyPid, replyPid) || other.replyPid == replyPid)&&(identical(other.subtype, subtype) || other.subtype == subtype)&&(identical(other.title, title) || other.title == title)&&(identical(other.topicId, topicId) || other.topicId == topicId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,action,articleId,body,fromUserId,fromUserName,postId,replyPid,subtype,title,topicId);

@override
String toString() {
  return 'AppNotificationContentDto(action: $action, articleId: $articleId, body: $body, fromUserId: $fromUserId, fromUserName: $fromUserName, postId: $postId, replyPid: $replyPid, subtype: $subtype, title: $title, topicId: $topicId)';
}


}

/// @nodoc
abstract mixin class _$AppNotificationContentDtoCopyWith<$Res> implements $AppNotificationContentDtoCopyWith<$Res> {
  factory _$AppNotificationContentDtoCopyWith(_AppNotificationContentDto value, $Res Function(_AppNotificationContentDto) _then) = __$AppNotificationContentDtoCopyWithImpl;
@override @useResult
$Res call({
 String? action, int? articleId, String? body, int? fromUserId, String? fromUserName, int? postId, int? replyPid, String? subtype, String? title, int? topicId
});




}
/// @nodoc
class __$AppNotificationContentDtoCopyWithImpl<$Res>
    implements _$AppNotificationContentDtoCopyWith<$Res> {
  __$AppNotificationContentDtoCopyWithImpl(this._self, this._then);

  final _AppNotificationContentDto _self;
  final $Res Function(_AppNotificationContentDto) _then;

/// Create a copy of AppNotificationContentDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = freezed,Object? articleId = freezed,Object? body = freezed,Object? fromUserId = freezed,Object? fromUserName = freezed,Object? postId = freezed,Object? replyPid = freezed,Object? subtype = freezed,Object? title = freezed,Object? topicId = freezed,}) {
  return _then(_AppNotificationContentDto(
action: freezed == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String?,articleId: freezed == articleId ? _self.articleId : articleId // ignore: cast_nullable_to_non_nullable
as int?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,fromUserId: freezed == fromUserId ? _self.fromUserId : fromUserId // ignore: cast_nullable_to_non_nullable
as int?,fromUserName: freezed == fromUserName ? _self.fromUserName : fromUserName // ignore: cast_nullable_to_non_nullable
as String?,postId: freezed == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as int?,replyPid: freezed == replyPid ? _self.replyPid : replyPid // ignore: cast_nullable_to_non_nullable
as int?,subtype: freezed == subtype ? _self.subtype : subtype // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,topicId: freezed == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$NotificationListDataDto {

 List<AppNotificationDto> get list; int get pageNum; int get pageSize; int get unread;
/// Create a copy of NotificationListDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationListDataDtoCopyWith<NotificationListDataDto> get copyWith => _$NotificationListDataDtoCopyWithImpl<NotificationListDataDto>(this as NotificationListDataDto, _$identity);

  /// Serializes this NotificationListDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationListDataDto&&const DeepCollectionEquality().equals(other.list, list)&&(identical(other.pageNum, pageNum) || other.pageNum == pageNum)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.unread, unread) || other.unread == unread));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list),pageNum,pageSize,unread);

@override
String toString() {
  return 'NotificationListDataDto(list: $list, pageNum: $pageNum, pageSize: $pageSize, unread: $unread)';
}


}

/// @nodoc
abstract mixin class $NotificationListDataDtoCopyWith<$Res>  {
  factory $NotificationListDataDtoCopyWith(NotificationListDataDto value, $Res Function(NotificationListDataDto) _then) = _$NotificationListDataDtoCopyWithImpl;
@useResult
$Res call({
 List<AppNotificationDto> list, int pageNum, int pageSize, int unread
});




}
/// @nodoc
class _$NotificationListDataDtoCopyWithImpl<$Res>
    implements $NotificationListDataDtoCopyWith<$Res> {
  _$NotificationListDataDtoCopyWithImpl(this._self, this._then);

  final NotificationListDataDto _self;
  final $Res Function(NotificationListDataDto) _then;

/// Create a copy of NotificationListDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = null,Object? pageNum = null,Object? pageSize = null,Object? unread = null,}) {
  return _then(_self.copyWith(
list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<AppNotificationDto>,pageNum: null == pageNum ? _self.pageNum : pageNum // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,unread: null == unread ? _self.unread : unread // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationListDataDto].
extension NotificationListDataDtoPatterns on NotificationListDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationListDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationListDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationListDataDto value)  $default,){
final _that = this;
switch (_that) {
case _NotificationListDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationListDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationListDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AppNotificationDto> list,  int pageNum,  int pageSize,  int unread)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationListDataDto() when $default != null:
return $default(_that.list,_that.pageNum,_that.pageSize,_that.unread);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AppNotificationDto> list,  int pageNum,  int pageSize,  int unread)  $default,) {final _that = this;
switch (_that) {
case _NotificationListDataDto():
return $default(_that.list,_that.pageNum,_that.pageSize,_that.unread);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AppNotificationDto> list,  int pageNum,  int pageSize,  int unread)?  $default,) {final _that = this;
switch (_that) {
case _NotificationListDataDto() when $default != null:
return $default(_that.list,_that.pageNum,_that.pageSize,_that.unread);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationListDataDto implements NotificationListDataDto {
  const _NotificationListDataDto({final  List<AppNotificationDto> list = const <AppNotificationDto>[], this.pageNum = 1, this.pageSize = 20, this.unread = 0}): _list = list;
  factory _NotificationListDataDto.fromJson(Map<String, dynamic> json) => _$NotificationListDataDtoFromJson(json);

 final  List<AppNotificationDto> _list;
@override@JsonKey() List<AppNotificationDto> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}

@override@JsonKey() final  int pageNum;
@override@JsonKey() final  int pageSize;
@override@JsonKey() final  int unread;

/// Create a copy of NotificationListDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationListDataDtoCopyWith<_NotificationListDataDto> get copyWith => __$NotificationListDataDtoCopyWithImpl<_NotificationListDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationListDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationListDataDto&&const DeepCollectionEquality().equals(other._list, _list)&&(identical(other.pageNum, pageNum) || other.pageNum == pageNum)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.unread, unread) || other.unread == unread));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_list),pageNum,pageSize,unread);

@override
String toString() {
  return 'NotificationListDataDto(list: $list, pageNum: $pageNum, pageSize: $pageSize, unread: $unread)';
}


}

/// @nodoc
abstract mixin class _$NotificationListDataDtoCopyWith<$Res> implements $NotificationListDataDtoCopyWith<$Res> {
  factory _$NotificationListDataDtoCopyWith(_NotificationListDataDto value, $Res Function(_NotificationListDataDto) _then) = __$NotificationListDataDtoCopyWithImpl;
@override @useResult
$Res call({
 List<AppNotificationDto> list, int pageNum, int pageSize, int unread
});




}
/// @nodoc
class __$NotificationListDataDtoCopyWithImpl<$Res>
    implements _$NotificationListDataDtoCopyWith<$Res> {
  __$NotificationListDataDtoCopyWithImpl(this._self, this._then);

  final _NotificationListDataDto _self;
  final $Res Function(_NotificationListDataDto) _then;

/// Create a copy of NotificationListDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = null,Object? pageNum = null,Object? pageSize = null,Object? unread = null,}) {
  return _then(_NotificationListDataDto(
list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<AppNotificationDto>,pageNum: null == pageNum ? _self.pageNum : pageNum // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,unread: null == unread ? _self.unread : unread // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
