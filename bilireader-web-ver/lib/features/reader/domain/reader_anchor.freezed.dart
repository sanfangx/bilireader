// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reader_anchor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReaderAnchor {

 int get articleId; int get chapterId; String get chapterName;/// 章內字元偏移（供垂直與分頁模式互相定位）。
 int get sourceTextOffset;/// 去除 HTML tag / ruby 注音等不可見內容後的可見文字偏移。
 int get visibleTextOffset;/// 目前所在 block 序號與型別。
 int get blockIndex; String get blockType;/// 錨點落在圖片 block 時的圖片序號與 URL。
 int? get imageIndex; String? get imageUrl;/// 錨點附近可見字，供章節更新造成 offset 漂移時近似搜尋修復。
 String get textQuote;/// 章內百分比 0.0-1.0（顯示 / fallback）。
 double get progressInChapter; int get createdAt; int get updatedAt;
/// Create a copy of ReaderAnchor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReaderAnchorCopyWith<ReaderAnchor> get copyWith => _$ReaderAnchorCopyWithImpl<ReaderAnchor>(this as ReaderAnchor, _$identity);

  /// Serializes this ReaderAnchor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReaderAnchor&&(identical(other.articleId, articleId) || other.articleId == articleId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.chapterName, chapterName) || other.chapterName == chapterName)&&(identical(other.sourceTextOffset, sourceTextOffset) || other.sourceTextOffset == sourceTextOffset)&&(identical(other.visibleTextOffset, visibleTextOffset) || other.visibleTextOffset == visibleTextOffset)&&(identical(other.blockIndex, blockIndex) || other.blockIndex == blockIndex)&&(identical(other.blockType, blockType) || other.blockType == blockType)&&(identical(other.imageIndex, imageIndex) || other.imageIndex == imageIndex)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.textQuote, textQuote) || other.textQuote == textQuote)&&(identical(other.progressInChapter, progressInChapter) || other.progressInChapter == progressInChapter)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleId,chapterId,chapterName,sourceTextOffset,visibleTextOffset,blockIndex,blockType,imageIndex,imageUrl,textQuote,progressInChapter,createdAt,updatedAt);

@override
String toString() {
  return 'ReaderAnchor(articleId: $articleId, chapterId: $chapterId, chapterName: $chapterName, sourceTextOffset: $sourceTextOffset, visibleTextOffset: $visibleTextOffset, blockIndex: $blockIndex, blockType: $blockType, imageIndex: $imageIndex, imageUrl: $imageUrl, textQuote: $textQuote, progressInChapter: $progressInChapter, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ReaderAnchorCopyWith<$Res>  {
  factory $ReaderAnchorCopyWith(ReaderAnchor value, $Res Function(ReaderAnchor) _then) = _$ReaderAnchorCopyWithImpl;
@useResult
$Res call({
 int articleId, int chapterId, String chapterName, int sourceTextOffset, int visibleTextOffset, int blockIndex, String blockType, int? imageIndex, String? imageUrl, String textQuote, double progressInChapter, int createdAt, int updatedAt
});




}
/// @nodoc
class _$ReaderAnchorCopyWithImpl<$Res>
    implements $ReaderAnchorCopyWith<$Res> {
  _$ReaderAnchorCopyWithImpl(this._self, this._then);

  final ReaderAnchor _self;
  final $Res Function(ReaderAnchor) _then;

/// Create a copy of ReaderAnchor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? articleId = null,Object? chapterId = null,Object? chapterName = null,Object? sourceTextOffset = null,Object? visibleTextOffset = null,Object? blockIndex = null,Object? blockType = null,Object? imageIndex = freezed,Object? imageUrl = freezed,Object? textQuote = null,Object? progressInChapter = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
articleId: null == articleId ? _self.articleId : articleId // ignore: cast_nullable_to_non_nullable
as int,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as int,chapterName: null == chapterName ? _self.chapterName : chapterName // ignore: cast_nullable_to_non_nullable
as String,sourceTextOffset: null == sourceTextOffset ? _self.sourceTextOffset : sourceTextOffset // ignore: cast_nullable_to_non_nullable
as int,visibleTextOffset: null == visibleTextOffset ? _self.visibleTextOffset : visibleTextOffset // ignore: cast_nullable_to_non_nullable
as int,blockIndex: null == blockIndex ? _self.blockIndex : blockIndex // ignore: cast_nullable_to_non_nullable
as int,blockType: null == blockType ? _self.blockType : blockType // ignore: cast_nullable_to_non_nullable
as String,imageIndex: freezed == imageIndex ? _self.imageIndex : imageIndex // ignore: cast_nullable_to_non_nullable
as int?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,textQuote: null == textQuote ? _self.textQuote : textQuote // ignore: cast_nullable_to_non_nullable
as String,progressInChapter: null == progressInChapter ? _self.progressInChapter : progressInChapter // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReaderAnchor].
extension ReaderAnchorPatterns on ReaderAnchor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReaderAnchor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReaderAnchor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReaderAnchor value)  $default,){
final _that = this;
switch (_that) {
case _ReaderAnchor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReaderAnchor value)?  $default,){
final _that = this;
switch (_that) {
case _ReaderAnchor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int articleId,  int chapterId,  String chapterName,  int sourceTextOffset,  int visibleTextOffset,  int blockIndex,  String blockType,  int? imageIndex,  String? imageUrl,  String textQuote,  double progressInChapter,  int createdAt,  int updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReaderAnchor() when $default != null:
return $default(_that.articleId,_that.chapterId,_that.chapterName,_that.sourceTextOffset,_that.visibleTextOffset,_that.blockIndex,_that.blockType,_that.imageIndex,_that.imageUrl,_that.textQuote,_that.progressInChapter,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int articleId,  int chapterId,  String chapterName,  int sourceTextOffset,  int visibleTextOffset,  int blockIndex,  String blockType,  int? imageIndex,  String? imageUrl,  String textQuote,  double progressInChapter,  int createdAt,  int updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ReaderAnchor():
return $default(_that.articleId,_that.chapterId,_that.chapterName,_that.sourceTextOffset,_that.visibleTextOffset,_that.blockIndex,_that.blockType,_that.imageIndex,_that.imageUrl,_that.textQuote,_that.progressInChapter,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int articleId,  int chapterId,  String chapterName,  int sourceTextOffset,  int visibleTextOffset,  int blockIndex,  String blockType,  int? imageIndex,  String? imageUrl,  String textQuote,  double progressInChapter,  int createdAt,  int updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ReaderAnchor() when $default != null:
return $default(_that.articleId,_that.chapterId,_that.chapterName,_that.sourceTextOffset,_that.visibleTextOffset,_that.blockIndex,_that.blockType,_that.imageIndex,_that.imageUrl,_that.textQuote,_that.progressInChapter,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReaderAnchor implements ReaderAnchor {
  const _ReaderAnchor({required this.articleId, required this.chapterId, required this.chapterName, required this.sourceTextOffset, this.visibleTextOffset = 0, this.blockIndex = 0, this.blockType = 'text', this.imageIndex, this.imageUrl, this.textQuote = '', this.progressInChapter = 0.0, this.createdAt = 0, this.updatedAt = 0});
  factory _ReaderAnchor.fromJson(Map<String, dynamic> json) => _$ReaderAnchorFromJson(json);

@override final  int articleId;
@override final  int chapterId;
@override final  String chapterName;
/// 章內字元偏移（供垂直與分頁模式互相定位）。
@override final  int sourceTextOffset;
/// 去除 HTML tag / ruby 注音等不可見內容後的可見文字偏移。
@override@JsonKey() final  int visibleTextOffset;
/// 目前所在 block 序號與型別。
@override@JsonKey() final  int blockIndex;
@override@JsonKey() final  String blockType;
/// 錨點落在圖片 block 時的圖片序號與 URL。
@override final  int? imageIndex;
@override final  String? imageUrl;
/// 錨點附近可見字，供章節更新造成 offset 漂移時近似搜尋修復。
@override@JsonKey() final  String textQuote;
/// 章內百分比 0.0-1.0（顯示 / fallback）。
@override@JsonKey() final  double progressInChapter;
@override@JsonKey() final  int createdAt;
@override@JsonKey() final  int updatedAt;

/// Create a copy of ReaderAnchor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReaderAnchorCopyWith<_ReaderAnchor> get copyWith => __$ReaderAnchorCopyWithImpl<_ReaderAnchor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReaderAnchorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReaderAnchor&&(identical(other.articleId, articleId) || other.articleId == articleId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.chapterName, chapterName) || other.chapterName == chapterName)&&(identical(other.sourceTextOffset, sourceTextOffset) || other.sourceTextOffset == sourceTextOffset)&&(identical(other.visibleTextOffset, visibleTextOffset) || other.visibleTextOffset == visibleTextOffset)&&(identical(other.blockIndex, blockIndex) || other.blockIndex == blockIndex)&&(identical(other.blockType, blockType) || other.blockType == blockType)&&(identical(other.imageIndex, imageIndex) || other.imageIndex == imageIndex)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.textQuote, textQuote) || other.textQuote == textQuote)&&(identical(other.progressInChapter, progressInChapter) || other.progressInChapter == progressInChapter)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,articleId,chapterId,chapterName,sourceTextOffset,visibleTextOffset,blockIndex,blockType,imageIndex,imageUrl,textQuote,progressInChapter,createdAt,updatedAt);

@override
String toString() {
  return 'ReaderAnchor(articleId: $articleId, chapterId: $chapterId, chapterName: $chapterName, sourceTextOffset: $sourceTextOffset, visibleTextOffset: $visibleTextOffset, blockIndex: $blockIndex, blockType: $blockType, imageIndex: $imageIndex, imageUrl: $imageUrl, textQuote: $textQuote, progressInChapter: $progressInChapter, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReaderAnchorCopyWith<$Res> implements $ReaderAnchorCopyWith<$Res> {
  factory _$ReaderAnchorCopyWith(_ReaderAnchor value, $Res Function(_ReaderAnchor) _then) = __$ReaderAnchorCopyWithImpl;
@override @useResult
$Res call({
 int articleId, int chapterId, String chapterName, int sourceTextOffset, int visibleTextOffset, int blockIndex, String blockType, int? imageIndex, String? imageUrl, String textQuote, double progressInChapter, int createdAt, int updatedAt
});




}
/// @nodoc
class __$ReaderAnchorCopyWithImpl<$Res>
    implements _$ReaderAnchorCopyWith<$Res> {
  __$ReaderAnchorCopyWithImpl(this._self, this._then);

  final _ReaderAnchor _self;
  final $Res Function(_ReaderAnchor) _then;

/// Create a copy of ReaderAnchor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? articleId = null,Object? chapterId = null,Object? chapterName = null,Object? sourceTextOffset = null,Object? visibleTextOffset = null,Object? blockIndex = null,Object? blockType = null,Object? imageIndex = freezed,Object? imageUrl = freezed,Object? textQuote = null,Object? progressInChapter = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ReaderAnchor(
articleId: null == articleId ? _self.articleId : articleId // ignore: cast_nullable_to_non_nullable
as int,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as int,chapterName: null == chapterName ? _self.chapterName : chapterName // ignore: cast_nullable_to_non_nullable
as String,sourceTextOffset: null == sourceTextOffset ? _self.sourceTextOffset : sourceTextOffset // ignore: cast_nullable_to_non_nullable
as int,visibleTextOffset: null == visibleTextOffset ? _self.visibleTextOffset : visibleTextOffset // ignore: cast_nullable_to_non_nullable
as int,blockIndex: null == blockIndex ? _self.blockIndex : blockIndex // ignore: cast_nullable_to_non_nullable
as int,blockType: null == blockType ? _self.blockType : blockType // ignore: cast_nullable_to_non_nullable
as String,imageIndex: freezed == imageIndex ? _self.imageIndex : imageIndex // ignore: cast_nullable_to_non_nullable
as int?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,textQuote: null == textQuote ? _self.textQuote : textQuote // ignore: cast_nullable_to_non_nullable
as String,progressInChapter: null == progressInChapter ? _self.progressInChapter : progressInChapter // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
