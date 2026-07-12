// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PrivateConversationDto {

 int get peerId; String? get peerName; int? get peerAvatar; String? get peerAvatarUrl; String? get lastContent; int get lastFromId; String? get lastFromName; int get lastMessageId; int get lastPostdate; int get unreadCount;
/// Create a copy of PrivateConversationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivateConversationDtoCopyWith<PrivateConversationDto> get copyWith => _$PrivateConversationDtoCopyWithImpl<PrivateConversationDto>(this as PrivateConversationDto, _$identity);

  /// Serializes this PrivateConversationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivateConversationDto&&(identical(other.peerId, peerId) || other.peerId == peerId)&&(identical(other.peerName, peerName) || other.peerName == peerName)&&(identical(other.peerAvatar, peerAvatar) || other.peerAvatar == peerAvatar)&&(identical(other.peerAvatarUrl, peerAvatarUrl) || other.peerAvatarUrl == peerAvatarUrl)&&(identical(other.lastContent, lastContent) || other.lastContent == lastContent)&&(identical(other.lastFromId, lastFromId) || other.lastFromId == lastFromId)&&(identical(other.lastFromName, lastFromName) || other.lastFromName == lastFromName)&&(identical(other.lastMessageId, lastMessageId) || other.lastMessageId == lastMessageId)&&(identical(other.lastPostdate, lastPostdate) || other.lastPostdate == lastPostdate)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,peerId,peerName,peerAvatar,peerAvatarUrl,lastContent,lastFromId,lastFromName,lastMessageId,lastPostdate,unreadCount);

@override
String toString() {
  return 'PrivateConversationDto(peerId: $peerId, peerName: $peerName, peerAvatar: $peerAvatar, peerAvatarUrl: $peerAvatarUrl, lastContent: $lastContent, lastFromId: $lastFromId, lastFromName: $lastFromName, lastMessageId: $lastMessageId, lastPostdate: $lastPostdate, unreadCount: $unreadCount)';
}


}

/// @nodoc
abstract mixin class $PrivateConversationDtoCopyWith<$Res>  {
  factory $PrivateConversationDtoCopyWith(PrivateConversationDto value, $Res Function(PrivateConversationDto) _then) = _$PrivateConversationDtoCopyWithImpl;
@useResult
$Res call({
 int peerId, String? peerName, int? peerAvatar, String? peerAvatarUrl, String? lastContent, int lastFromId, String? lastFromName, int lastMessageId, int lastPostdate, int unreadCount
});




}
/// @nodoc
class _$PrivateConversationDtoCopyWithImpl<$Res>
    implements $PrivateConversationDtoCopyWith<$Res> {
  _$PrivateConversationDtoCopyWithImpl(this._self, this._then);

  final PrivateConversationDto _self;
  final $Res Function(PrivateConversationDto) _then;

/// Create a copy of PrivateConversationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? peerId = null,Object? peerName = freezed,Object? peerAvatar = freezed,Object? peerAvatarUrl = freezed,Object? lastContent = freezed,Object? lastFromId = null,Object? lastFromName = freezed,Object? lastMessageId = null,Object? lastPostdate = null,Object? unreadCount = null,}) {
  return _then(_self.copyWith(
peerId: null == peerId ? _self.peerId : peerId // ignore: cast_nullable_to_non_nullable
as int,peerName: freezed == peerName ? _self.peerName : peerName // ignore: cast_nullable_to_non_nullable
as String?,peerAvatar: freezed == peerAvatar ? _self.peerAvatar : peerAvatar // ignore: cast_nullable_to_non_nullable
as int?,peerAvatarUrl: freezed == peerAvatarUrl ? _self.peerAvatarUrl : peerAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,lastContent: freezed == lastContent ? _self.lastContent : lastContent // ignore: cast_nullable_to_non_nullable
as String?,lastFromId: null == lastFromId ? _self.lastFromId : lastFromId // ignore: cast_nullable_to_non_nullable
as int,lastFromName: freezed == lastFromName ? _self.lastFromName : lastFromName // ignore: cast_nullable_to_non_nullable
as String?,lastMessageId: null == lastMessageId ? _self.lastMessageId : lastMessageId // ignore: cast_nullable_to_non_nullable
as int,lastPostdate: null == lastPostdate ? _self.lastPostdate : lastPostdate // ignore: cast_nullable_to_non_nullable
as int,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivateConversationDto].
extension PrivateConversationDtoPatterns on PrivateConversationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivateConversationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivateConversationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivateConversationDto value)  $default,){
final _that = this;
switch (_that) {
case _PrivateConversationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivateConversationDto value)?  $default,){
final _that = this;
switch (_that) {
case _PrivateConversationDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int peerId,  String? peerName,  int? peerAvatar,  String? peerAvatarUrl,  String? lastContent,  int lastFromId,  String? lastFromName,  int lastMessageId,  int lastPostdate,  int unreadCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivateConversationDto() when $default != null:
return $default(_that.peerId,_that.peerName,_that.peerAvatar,_that.peerAvatarUrl,_that.lastContent,_that.lastFromId,_that.lastFromName,_that.lastMessageId,_that.lastPostdate,_that.unreadCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int peerId,  String? peerName,  int? peerAvatar,  String? peerAvatarUrl,  String? lastContent,  int lastFromId,  String? lastFromName,  int lastMessageId,  int lastPostdate,  int unreadCount)  $default,) {final _that = this;
switch (_that) {
case _PrivateConversationDto():
return $default(_that.peerId,_that.peerName,_that.peerAvatar,_that.peerAvatarUrl,_that.lastContent,_that.lastFromId,_that.lastFromName,_that.lastMessageId,_that.lastPostdate,_that.unreadCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int peerId,  String? peerName,  int? peerAvatar,  String? peerAvatarUrl,  String? lastContent,  int lastFromId,  String? lastFromName,  int lastMessageId,  int lastPostdate,  int unreadCount)?  $default,) {final _that = this;
switch (_that) {
case _PrivateConversationDto() when $default != null:
return $default(_that.peerId,_that.peerName,_that.peerAvatar,_that.peerAvatarUrl,_that.lastContent,_that.lastFromId,_that.lastFromName,_that.lastMessageId,_that.lastPostdate,_that.unreadCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrivateConversationDto implements PrivateConversationDto {
  const _PrivateConversationDto({this.peerId = 0, this.peerName, this.peerAvatar, this.peerAvatarUrl, this.lastContent, this.lastFromId = 0, this.lastFromName, this.lastMessageId = 0, this.lastPostdate = 0, this.unreadCount = 0});
  factory _PrivateConversationDto.fromJson(Map<String, dynamic> json) => _$PrivateConversationDtoFromJson(json);

@override@JsonKey() final  int peerId;
@override final  String? peerName;
@override final  int? peerAvatar;
@override final  String? peerAvatarUrl;
@override final  String? lastContent;
@override@JsonKey() final  int lastFromId;
@override final  String? lastFromName;
@override@JsonKey() final  int lastMessageId;
@override@JsonKey() final  int lastPostdate;
@override@JsonKey() final  int unreadCount;

/// Create a copy of PrivateConversationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivateConversationDtoCopyWith<_PrivateConversationDto> get copyWith => __$PrivateConversationDtoCopyWithImpl<_PrivateConversationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrivateConversationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivateConversationDto&&(identical(other.peerId, peerId) || other.peerId == peerId)&&(identical(other.peerName, peerName) || other.peerName == peerName)&&(identical(other.peerAvatar, peerAvatar) || other.peerAvatar == peerAvatar)&&(identical(other.peerAvatarUrl, peerAvatarUrl) || other.peerAvatarUrl == peerAvatarUrl)&&(identical(other.lastContent, lastContent) || other.lastContent == lastContent)&&(identical(other.lastFromId, lastFromId) || other.lastFromId == lastFromId)&&(identical(other.lastFromName, lastFromName) || other.lastFromName == lastFromName)&&(identical(other.lastMessageId, lastMessageId) || other.lastMessageId == lastMessageId)&&(identical(other.lastPostdate, lastPostdate) || other.lastPostdate == lastPostdate)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,peerId,peerName,peerAvatar,peerAvatarUrl,lastContent,lastFromId,lastFromName,lastMessageId,lastPostdate,unreadCount);

@override
String toString() {
  return 'PrivateConversationDto(peerId: $peerId, peerName: $peerName, peerAvatar: $peerAvatar, peerAvatarUrl: $peerAvatarUrl, lastContent: $lastContent, lastFromId: $lastFromId, lastFromName: $lastFromName, lastMessageId: $lastMessageId, lastPostdate: $lastPostdate, unreadCount: $unreadCount)';
}


}

/// @nodoc
abstract mixin class _$PrivateConversationDtoCopyWith<$Res> implements $PrivateConversationDtoCopyWith<$Res> {
  factory _$PrivateConversationDtoCopyWith(_PrivateConversationDto value, $Res Function(_PrivateConversationDto) _then) = __$PrivateConversationDtoCopyWithImpl;
@override @useResult
$Res call({
 int peerId, String? peerName, int? peerAvatar, String? peerAvatarUrl, String? lastContent, int lastFromId, String? lastFromName, int lastMessageId, int lastPostdate, int unreadCount
});




}
/// @nodoc
class __$PrivateConversationDtoCopyWithImpl<$Res>
    implements _$PrivateConversationDtoCopyWith<$Res> {
  __$PrivateConversationDtoCopyWithImpl(this._self, this._then);

  final _PrivateConversationDto _self;
  final $Res Function(_PrivateConversationDto) _then;

/// Create a copy of PrivateConversationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? peerId = null,Object? peerName = freezed,Object? peerAvatar = freezed,Object? peerAvatarUrl = freezed,Object? lastContent = freezed,Object? lastFromId = null,Object? lastFromName = freezed,Object? lastMessageId = null,Object? lastPostdate = null,Object? unreadCount = null,}) {
  return _then(_PrivateConversationDto(
peerId: null == peerId ? _self.peerId : peerId // ignore: cast_nullable_to_non_nullable
as int,peerName: freezed == peerName ? _self.peerName : peerName // ignore: cast_nullable_to_non_nullable
as String?,peerAvatar: freezed == peerAvatar ? _self.peerAvatar : peerAvatar // ignore: cast_nullable_to_non_nullable
as int?,peerAvatarUrl: freezed == peerAvatarUrl ? _self.peerAvatarUrl : peerAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,lastContent: freezed == lastContent ? _self.lastContent : lastContent // ignore: cast_nullable_to_non_nullable
as String?,lastFromId: null == lastFromId ? _self.lastFromId : lastFromId // ignore: cast_nullable_to_non_nullable
as int,lastFromName: freezed == lastFromName ? _self.lastFromName : lastFromName // ignore: cast_nullable_to_non_nullable
as String?,lastMessageId: null == lastMessageId ? _self.lastMessageId : lastMessageId // ignore: cast_nullable_to_non_nullable
as int,lastPostdate: null == lastPostdate ? _self.lastPostdate : lastPostdate // ignore: cast_nullable_to_non_nullable
as int,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PrivateMessageDto {

 int get messageid; int get fromid; String? get fromname; int get toid; String? get toname; String? get content; int get postdate; int get isread; String? get title; int get quoteMessageId; int get quoteFromid; String? get quoteFromname; String? get quoteContent;
/// Create a copy of PrivateMessageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivateMessageDtoCopyWith<PrivateMessageDto> get copyWith => _$PrivateMessageDtoCopyWithImpl<PrivateMessageDto>(this as PrivateMessageDto, _$identity);

  /// Serializes this PrivateMessageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivateMessageDto&&(identical(other.messageid, messageid) || other.messageid == messageid)&&(identical(other.fromid, fromid) || other.fromid == fromid)&&(identical(other.fromname, fromname) || other.fromname == fromname)&&(identical(other.toid, toid) || other.toid == toid)&&(identical(other.toname, toname) || other.toname == toname)&&(identical(other.content, content) || other.content == content)&&(identical(other.postdate, postdate) || other.postdate == postdate)&&(identical(other.isread, isread) || other.isread == isread)&&(identical(other.title, title) || other.title == title)&&(identical(other.quoteMessageId, quoteMessageId) || other.quoteMessageId == quoteMessageId)&&(identical(other.quoteFromid, quoteFromid) || other.quoteFromid == quoteFromid)&&(identical(other.quoteFromname, quoteFromname) || other.quoteFromname == quoteFromname)&&(identical(other.quoteContent, quoteContent) || other.quoteContent == quoteContent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageid,fromid,fromname,toid,toname,content,postdate,isread,title,quoteMessageId,quoteFromid,quoteFromname,quoteContent);

@override
String toString() {
  return 'PrivateMessageDto(messageid: $messageid, fromid: $fromid, fromname: $fromname, toid: $toid, toname: $toname, content: $content, postdate: $postdate, isread: $isread, title: $title, quoteMessageId: $quoteMessageId, quoteFromid: $quoteFromid, quoteFromname: $quoteFromname, quoteContent: $quoteContent)';
}


}

/// @nodoc
abstract mixin class $PrivateMessageDtoCopyWith<$Res>  {
  factory $PrivateMessageDtoCopyWith(PrivateMessageDto value, $Res Function(PrivateMessageDto) _then) = _$PrivateMessageDtoCopyWithImpl;
@useResult
$Res call({
 int messageid, int fromid, String? fromname, int toid, String? toname, String? content, int postdate, int isread, String? title, int quoteMessageId, int quoteFromid, String? quoteFromname, String? quoteContent
});




}
/// @nodoc
class _$PrivateMessageDtoCopyWithImpl<$Res>
    implements $PrivateMessageDtoCopyWith<$Res> {
  _$PrivateMessageDtoCopyWithImpl(this._self, this._then);

  final PrivateMessageDto _self;
  final $Res Function(PrivateMessageDto) _then;

/// Create a copy of PrivateMessageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? messageid = null,Object? fromid = null,Object? fromname = freezed,Object? toid = null,Object? toname = freezed,Object? content = freezed,Object? postdate = null,Object? isread = null,Object? title = freezed,Object? quoteMessageId = null,Object? quoteFromid = null,Object? quoteFromname = freezed,Object? quoteContent = freezed,}) {
  return _then(_self.copyWith(
messageid: null == messageid ? _self.messageid : messageid // ignore: cast_nullable_to_non_nullable
as int,fromid: null == fromid ? _self.fromid : fromid // ignore: cast_nullable_to_non_nullable
as int,fromname: freezed == fromname ? _self.fromname : fromname // ignore: cast_nullable_to_non_nullable
as String?,toid: null == toid ? _self.toid : toid // ignore: cast_nullable_to_non_nullable
as int,toname: freezed == toname ? _self.toname : toname // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,postdate: null == postdate ? _self.postdate : postdate // ignore: cast_nullable_to_non_nullable
as int,isread: null == isread ? _self.isread : isread // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,quoteMessageId: null == quoteMessageId ? _self.quoteMessageId : quoteMessageId // ignore: cast_nullable_to_non_nullable
as int,quoteFromid: null == quoteFromid ? _self.quoteFromid : quoteFromid // ignore: cast_nullable_to_non_nullable
as int,quoteFromname: freezed == quoteFromname ? _self.quoteFromname : quoteFromname // ignore: cast_nullable_to_non_nullable
as String?,quoteContent: freezed == quoteContent ? _self.quoteContent : quoteContent // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivateMessageDto].
extension PrivateMessageDtoPatterns on PrivateMessageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivateMessageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivateMessageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivateMessageDto value)  $default,){
final _that = this;
switch (_that) {
case _PrivateMessageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivateMessageDto value)?  $default,){
final _that = this;
switch (_that) {
case _PrivateMessageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int messageid,  int fromid,  String? fromname,  int toid,  String? toname,  String? content,  int postdate,  int isread,  String? title,  int quoteMessageId,  int quoteFromid,  String? quoteFromname,  String? quoteContent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivateMessageDto() when $default != null:
return $default(_that.messageid,_that.fromid,_that.fromname,_that.toid,_that.toname,_that.content,_that.postdate,_that.isread,_that.title,_that.quoteMessageId,_that.quoteFromid,_that.quoteFromname,_that.quoteContent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int messageid,  int fromid,  String? fromname,  int toid,  String? toname,  String? content,  int postdate,  int isread,  String? title,  int quoteMessageId,  int quoteFromid,  String? quoteFromname,  String? quoteContent)  $default,) {final _that = this;
switch (_that) {
case _PrivateMessageDto():
return $default(_that.messageid,_that.fromid,_that.fromname,_that.toid,_that.toname,_that.content,_that.postdate,_that.isread,_that.title,_that.quoteMessageId,_that.quoteFromid,_that.quoteFromname,_that.quoteContent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int messageid,  int fromid,  String? fromname,  int toid,  String? toname,  String? content,  int postdate,  int isread,  String? title,  int quoteMessageId,  int quoteFromid,  String? quoteFromname,  String? quoteContent)?  $default,) {final _that = this;
switch (_that) {
case _PrivateMessageDto() when $default != null:
return $default(_that.messageid,_that.fromid,_that.fromname,_that.toid,_that.toname,_that.content,_that.postdate,_that.isread,_that.title,_that.quoteMessageId,_that.quoteFromid,_that.quoteFromname,_that.quoteContent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrivateMessageDto implements PrivateMessageDto {
  const _PrivateMessageDto({this.messageid = 0, this.fromid = 0, this.fromname, this.toid = 0, this.toname, this.content, this.postdate = 0, this.isread = 0, this.title, this.quoteMessageId = 0, this.quoteFromid = 0, this.quoteFromname, this.quoteContent});
  factory _PrivateMessageDto.fromJson(Map<String, dynamic> json) => _$PrivateMessageDtoFromJson(json);

@override@JsonKey() final  int messageid;
@override@JsonKey() final  int fromid;
@override final  String? fromname;
@override@JsonKey() final  int toid;
@override final  String? toname;
@override final  String? content;
@override@JsonKey() final  int postdate;
@override@JsonKey() final  int isread;
@override final  String? title;
@override@JsonKey() final  int quoteMessageId;
@override@JsonKey() final  int quoteFromid;
@override final  String? quoteFromname;
@override final  String? quoteContent;

/// Create a copy of PrivateMessageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivateMessageDtoCopyWith<_PrivateMessageDto> get copyWith => __$PrivateMessageDtoCopyWithImpl<_PrivateMessageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrivateMessageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivateMessageDto&&(identical(other.messageid, messageid) || other.messageid == messageid)&&(identical(other.fromid, fromid) || other.fromid == fromid)&&(identical(other.fromname, fromname) || other.fromname == fromname)&&(identical(other.toid, toid) || other.toid == toid)&&(identical(other.toname, toname) || other.toname == toname)&&(identical(other.content, content) || other.content == content)&&(identical(other.postdate, postdate) || other.postdate == postdate)&&(identical(other.isread, isread) || other.isread == isread)&&(identical(other.title, title) || other.title == title)&&(identical(other.quoteMessageId, quoteMessageId) || other.quoteMessageId == quoteMessageId)&&(identical(other.quoteFromid, quoteFromid) || other.quoteFromid == quoteFromid)&&(identical(other.quoteFromname, quoteFromname) || other.quoteFromname == quoteFromname)&&(identical(other.quoteContent, quoteContent) || other.quoteContent == quoteContent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,messageid,fromid,fromname,toid,toname,content,postdate,isread,title,quoteMessageId,quoteFromid,quoteFromname,quoteContent);

@override
String toString() {
  return 'PrivateMessageDto(messageid: $messageid, fromid: $fromid, fromname: $fromname, toid: $toid, toname: $toname, content: $content, postdate: $postdate, isread: $isread, title: $title, quoteMessageId: $quoteMessageId, quoteFromid: $quoteFromid, quoteFromname: $quoteFromname, quoteContent: $quoteContent)';
}


}

/// @nodoc
abstract mixin class _$PrivateMessageDtoCopyWith<$Res> implements $PrivateMessageDtoCopyWith<$Res> {
  factory _$PrivateMessageDtoCopyWith(_PrivateMessageDto value, $Res Function(_PrivateMessageDto) _then) = __$PrivateMessageDtoCopyWithImpl;
@override @useResult
$Res call({
 int messageid, int fromid, String? fromname, int toid, String? toname, String? content, int postdate, int isread, String? title, int quoteMessageId, int quoteFromid, String? quoteFromname, String? quoteContent
});




}
/// @nodoc
class __$PrivateMessageDtoCopyWithImpl<$Res>
    implements _$PrivateMessageDtoCopyWith<$Res> {
  __$PrivateMessageDtoCopyWithImpl(this._self, this._then);

  final _PrivateMessageDto _self;
  final $Res Function(_PrivateMessageDto) _then;

/// Create a copy of PrivateMessageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? messageid = null,Object? fromid = null,Object? fromname = freezed,Object? toid = null,Object? toname = freezed,Object? content = freezed,Object? postdate = null,Object? isread = null,Object? title = freezed,Object? quoteMessageId = null,Object? quoteFromid = null,Object? quoteFromname = freezed,Object? quoteContent = freezed,}) {
  return _then(_PrivateMessageDto(
messageid: null == messageid ? _self.messageid : messageid // ignore: cast_nullable_to_non_nullable
as int,fromid: null == fromid ? _self.fromid : fromid // ignore: cast_nullable_to_non_nullable
as int,fromname: freezed == fromname ? _self.fromname : fromname // ignore: cast_nullable_to_non_nullable
as String?,toid: null == toid ? _self.toid : toid // ignore: cast_nullable_to_non_nullable
as int,toname: freezed == toname ? _self.toname : toname // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,postdate: null == postdate ? _self.postdate : postdate // ignore: cast_nullable_to_non_nullable
as int,isread: null == isread ? _self.isread : isread // ignore: cast_nullable_to_non_nullable
as int,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,quoteMessageId: null == quoteMessageId ? _self.quoteMessageId : quoteMessageId // ignore: cast_nullable_to_non_nullable
as int,quoteFromid: null == quoteFromid ? _self.quoteFromid : quoteFromid // ignore: cast_nullable_to_non_nullable
as int,quoteFromname: freezed == quoteFromname ? _self.quoteFromname : quoteFromname // ignore: cast_nullable_to_non_nullable
as String?,quoteContent: freezed == quoteContent ? _self.quoteContent : quoteContent // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PrivateConversationListDataDto {

 List<PrivateConversationDto> get list; int get pageNum; int get pageSize; int get unread;
/// Create a copy of PrivateConversationListDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivateConversationListDataDtoCopyWith<PrivateConversationListDataDto> get copyWith => _$PrivateConversationListDataDtoCopyWithImpl<PrivateConversationListDataDto>(this as PrivateConversationListDataDto, _$identity);

  /// Serializes this PrivateConversationListDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivateConversationListDataDto&&const DeepCollectionEquality().equals(other.list, list)&&(identical(other.pageNum, pageNum) || other.pageNum == pageNum)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.unread, unread) || other.unread == unread));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list),pageNum,pageSize,unread);

@override
String toString() {
  return 'PrivateConversationListDataDto(list: $list, pageNum: $pageNum, pageSize: $pageSize, unread: $unread)';
}


}

/// @nodoc
abstract mixin class $PrivateConversationListDataDtoCopyWith<$Res>  {
  factory $PrivateConversationListDataDtoCopyWith(PrivateConversationListDataDto value, $Res Function(PrivateConversationListDataDto) _then) = _$PrivateConversationListDataDtoCopyWithImpl;
@useResult
$Res call({
 List<PrivateConversationDto> list, int pageNum, int pageSize, int unread
});




}
/// @nodoc
class _$PrivateConversationListDataDtoCopyWithImpl<$Res>
    implements $PrivateConversationListDataDtoCopyWith<$Res> {
  _$PrivateConversationListDataDtoCopyWithImpl(this._self, this._then);

  final PrivateConversationListDataDto _self;
  final $Res Function(PrivateConversationListDataDto) _then;

/// Create a copy of PrivateConversationListDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = null,Object? pageNum = null,Object? pageSize = null,Object? unread = null,}) {
  return _then(_self.copyWith(
list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<PrivateConversationDto>,pageNum: null == pageNum ? _self.pageNum : pageNum // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,unread: null == unread ? _self.unread : unread // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivateConversationListDataDto].
extension PrivateConversationListDataDtoPatterns on PrivateConversationListDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivateConversationListDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivateConversationListDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivateConversationListDataDto value)  $default,){
final _that = this;
switch (_that) {
case _PrivateConversationListDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivateConversationListDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _PrivateConversationListDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PrivateConversationDto> list,  int pageNum,  int pageSize,  int unread)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivateConversationListDataDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PrivateConversationDto> list,  int pageNum,  int pageSize,  int unread)  $default,) {final _that = this;
switch (_that) {
case _PrivateConversationListDataDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PrivateConversationDto> list,  int pageNum,  int pageSize,  int unread)?  $default,) {final _that = this;
switch (_that) {
case _PrivateConversationListDataDto() when $default != null:
return $default(_that.list,_that.pageNum,_that.pageSize,_that.unread);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrivateConversationListDataDto implements PrivateConversationListDataDto {
  const _PrivateConversationListDataDto({final  List<PrivateConversationDto> list = const <PrivateConversationDto>[], this.pageNum = 1, this.pageSize = 20, this.unread = 0}): _list = list;
  factory _PrivateConversationListDataDto.fromJson(Map<String, dynamic> json) => _$PrivateConversationListDataDtoFromJson(json);

 final  List<PrivateConversationDto> _list;
@override@JsonKey() List<PrivateConversationDto> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}

@override@JsonKey() final  int pageNum;
@override@JsonKey() final  int pageSize;
@override@JsonKey() final  int unread;

/// Create a copy of PrivateConversationListDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivateConversationListDataDtoCopyWith<_PrivateConversationListDataDto> get copyWith => __$PrivateConversationListDataDtoCopyWithImpl<_PrivateConversationListDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrivateConversationListDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivateConversationListDataDto&&const DeepCollectionEquality().equals(other._list, _list)&&(identical(other.pageNum, pageNum) || other.pageNum == pageNum)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.unread, unread) || other.unread == unread));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_list),pageNum,pageSize,unread);

@override
String toString() {
  return 'PrivateConversationListDataDto(list: $list, pageNum: $pageNum, pageSize: $pageSize, unread: $unread)';
}


}

/// @nodoc
abstract mixin class _$PrivateConversationListDataDtoCopyWith<$Res> implements $PrivateConversationListDataDtoCopyWith<$Res> {
  factory _$PrivateConversationListDataDtoCopyWith(_PrivateConversationListDataDto value, $Res Function(_PrivateConversationListDataDto) _then) = __$PrivateConversationListDataDtoCopyWithImpl;
@override @useResult
$Res call({
 List<PrivateConversationDto> list, int pageNum, int pageSize, int unread
});




}
/// @nodoc
class __$PrivateConversationListDataDtoCopyWithImpl<$Res>
    implements _$PrivateConversationListDataDtoCopyWith<$Res> {
  __$PrivateConversationListDataDtoCopyWithImpl(this._self, this._then);

  final _PrivateConversationListDataDto _self;
  final $Res Function(_PrivateConversationListDataDto) _then;

/// Create a copy of PrivateConversationListDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = null,Object? pageNum = null,Object? pageSize = null,Object? unread = null,}) {
  return _then(_PrivateConversationListDataDto(
list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<PrivateConversationDto>,pageNum: null == pageNum ? _self.pageNum : pageNum // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,unread: null == unread ? _self.unread : unread // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PrivateMessageHistoryDataDto {

 List<PrivateMessageDto> get list; int get pageNum; int get pageSize; int get unread;
/// Create a copy of PrivateMessageHistoryDataDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PrivateMessageHistoryDataDtoCopyWith<PrivateMessageHistoryDataDto> get copyWith => _$PrivateMessageHistoryDataDtoCopyWithImpl<PrivateMessageHistoryDataDto>(this as PrivateMessageHistoryDataDto, _$identity);

  /// Serializes this PrivateMessageHistoryDataDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PrivateMessageHistoryDataDto&&const DeepCollectionEquality().equals(other.list, list)&&(identical(other.pageNum, pageNum) || other.pageNum == pageNum)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.unread, unread) || other.unread == unread));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(list),pageNum,pageSize,unread);

@override
String toString() {
  return 'PrivateMessageHistoryDataDto(list: $list, pageNum: $pageNum, pageSize: $pageSize, unread: $unread)';
}


}

/// @nodoc
abstract mixin class $PrivateMessageHistoryDataDtoCopyWith<$Res>  {
  factory $PrivateMessageHistoryDataDtoCopyWith(PrivateMessageHistoryDataDto value, $Res Function(PrivateMessageHistoryDataDto) _then) = _$PrivateMessageHistoryDataDtoCopyWithImpl;
@useResult
$Res call({
 List<PrivateMessageDto> list, int pageNum, int pageSize, int unread
});




}
/// @nodoc
class _$PrivateMessageHistoryDataDtoCopyWithImpl<$Res>
    implements $PrivateMessageHistoryDataDtoCopyWith<$Res> {
  _$PrivateMessageHistoryDataDtoCopyWithImpl(this._self, this._then);

  final PrivateMessageHistoryDataDto _self;
  final $Res Function(PrivateMessageHistoryDataDto) _then;

/// Create a copy of PrivateMessageHistoryDataDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? list = null,Object? pageNum = null,Object? pageSize = null,Object? unread = null,}) {
  return _then(_self.copyWith(
list: null == list ? _self.list : list // ignore: cast_nullable_to_non_nullable
as List<PrivateMessageDto>,pageNum: null == pageNum ? _self.pageNum : pageNum // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,unread: null == unread ? _self.unread : unread // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PrivateMessageHistoryDataDto].
extension PrivateMessageHistoryDataDtoPatterns on PrivateMessageHistoryDataDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PrivateMessageHistoryDataDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PrivateMessageHistoryDataDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PrivateMessageHistoryDataDto value)  $default,){
final _that = this;
switch (_that) {
case _PrivateMessageHistoryDataDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PrivateMessageHistoryDataDto value)?  $default,){
final _that = this;
switch (_that) {
case _PrivateMessageHistoryDataDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PrivateMessageDto> list,  int pageNum,  int pageSize,  int unread)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PrivateMessageHistoryDataDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PrivateMessageDto> list,  int pageNum,  int pageSize,  int unread)  $default,) {final _that = this;
switch (_that) {
case _PrivateMessageHistoryDataDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PrivateMessageDto> list,  int pageNum,  int pageSize,  int unread)?  $default,) {final _that = this;
switch (_that) {
case _PrivateMessageHistoryDataDto() when $default != null:
return $default(_that.list,_that.pageNum,_that.pageSize,_that.unread);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PrivateMessageHistoryDataDto implements PrivateMessageHistoryDataDto {
  const _PrivateMessageHistoryDataDto({final  List<PrivateMessageDto> list = const <PrivateMessageDto>[], this.pageNum = 1, this.pageSize = 30, this.unread = 0}): _list = list;
  factory _PrivateMessageHistoryDataDto.fromJson(Map<String, dynamic> json) => _$PrivateMessageHistoryDataDtoFromJson(json);

 final  List<PrivateMessageDto> _list;
@override@JsonKey() List<PrivateMessageDto> get list {
  if (_list is EqualUnmodifiableListView) return _list;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_list);
}

@override@JsonKey() final  int pageNum;
@override@JsonKey() final  int pageSize;
@override@JsonKey() final  int unread;

/// Create a copy of PrivateMessageHistoryDataDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PrivateMessageHistoryDataDtoCopyWith<_PrivateMessageHistoryDataDto> get copyWith => __$PrivateMessageHistoryDataDtoCopyWithImpl<_PrivateMessageHistoryDataDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PrivateMessageHistoryDataDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PrivateMessageHistoryDataDto&&const DeepCollectionEquality().equals(other._list, _list)&&(identical(other.pageNum, pageNum) || other.pageNum == pageNum)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize)&&(identical(other.unread, unread) || other.unread == unread));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_list),pageNum,pageSize,unread);

@override
String toString() {
  return 'PrivateMessageHistoryDataDto(list: $list, pageNum: $pageNum, pageSize: $pageSize, unread: $unread)';
}


}

/// @nodoc
abstract mixin class _$PrivateMessageHistoryDataDtoCopyWith<$Res> implements $PrivateMessageHistoryDataDtoCopyWith<$Res> {
  factory _$PrivateMessageHistoryDataDtoCopyWith(_PrivateMessageHistoryDataDto value, $Res Function(_PrivateMessageHistoryDataDto) _then) = __$PrivateMessageHistoryDataDtoCopyWithImpl;
@override @useResult
$Res call({
 List<PrivateMessageDto> list, int pageNum, int pageSize, int unread
});




}
/// @nodoc
class __$PrivateMessageHistoryDataDtoCopyWithImpl<$Res>
    implements _$PrivateMessageHistoryDataDtoCopyWith<$Res> {
  __$PrivateMessageHistoryDataDtoCopyWithImpl(this._self, this._then);

  final _PrivateMessageHistoryDataDto _self;
  final $Res Function(_PrivateMessageHistoryDataDto) _then;

/// Create a copy of PrivateMessageHistoryDataDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? list = null,Object? pageNum = null,Object? pageSize = null,Object? unread = null,}) {
  return _then(_PrivateMessageHistoryDataDto(
list: null == list ? _self._list : list // ignore: cast_nullable_to_non_nullable
as List<PrivateMessageDto>,pageNum: null == pageNum ? _self.pageNum : pageNum // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,unread: null == unread ? _self.unread : unread // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
