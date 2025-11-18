// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diary_comment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DiaryComment {

 String get id; String get postId; String get content; DiaryUserSummary get user; int get likesCount; bool get liked; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of DiaryComment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryCommentCopyWith<DiaryComment> get copyWith => _$DiaryCommentCopyWithImpl<DiaryComment>(this as DiaryComment, _$identity);

  /// Serializes this DiaryComment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryComment&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.content, content) || other.content == content)&&(identical(other.user, user) || other.user == user)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.liked, liked) || other.liked == liked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postId,content,user,likesCount,liked,createdAt,updatedAt);

@override
String toString() {
  return 'DiaryComment(id: $id, postId: $postId, content: $content, user: $user, likesCount: $likesCount, liked: $liked, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DiaryCommentCopyWith<$Res>  {
  factory $DiaryCommentCopyWith(DiaryComment value, $Res Function(DiaryComment) _then) = _$DiaryCommentCopyWithImpl;
@useResult
$Res call({
 String id, String postId, String content, DiaryUserSummary user, int likesCount, bool liked, DateTime? createdAt, DateTime? updatedAt
});


$DiaryUserSummaryCopyWith<$Res> get user;

}
/// @nodoc
class _$DiaryCommentCopyWithImpl<$Res>
    implements $DiaryCommentCopyWith<$Res> {
  _$DiaryCommentCopyWithImpl(this._self, this._then);

  final DiaryComment _self;
  final $Res Function(DiaryComment) _then;

/// Create a copy of DiaryComment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? postId = null,Object? content = null,Object? user = null,Object? likesCount = null,Object? liked = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as DiaryUserSummary,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,liked: null == liked ? _self.liked : liked // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of DiaryComment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiaryUserSummaryCopyWith<$Res> get user {
  
  return $DiaryUserSummaryCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [DiaryComment].
extension DiaryCommentPatterns on DiaryComment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryComment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryComment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryComment value)  $default,){
final _that = this;
switch (_that) {
case _DiaryComment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryComment value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryComment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String postId,  String content,  DiaryUserSummary user,  int likesCount,  bool liked,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryComment() when $default != null:
return $default(_that.id,_that.postId,_that.content,_that.user,_that.likesCount,_that.liked,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String postId,  String content,  DiaryUserSummary user,  int likesCount,  bool liked,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DiaryComment():
return $default(_that.id,_that.postId,_that.content,_that.user,_that.likesCount,_that.liked,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String postId,  String content,  DiaryUserSummary user,  int likesCount,  bool liked,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DiaryComment() when $default != null:
return $default(_that.id,_that.postId,_that.content,_that.user,_that.likesCount,_that.liked,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiaryComment implements DiaryComment {
  const _DiaryComment({required this.id, required this.postId, required this.content, required this.user, this.likesCount = 0, this.liked = false, this.createdAt, this.updatedAt});
  factory _DiaryComment.fromJson(Map<String, dynamic> json) => _$DiaryCommentFromJson(json);

@override final  String id;
@override final  String postId;
@override final  String content;
@override final  DiaryUserSummary user;
@override@JsonKey() final  int likesCount;
@override@JsonKey() final  bool liked;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of DiaryComment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryCommentCopyWith<_DiaryComment> get copyWith => __$DiaryCommentCopyWithImpl<_DiaryComment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiaryCommentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryComment&&(identical(other.id, id) || other.id == id)&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.content, content) || other.content == content)&&(identical(other.user, user) || other.user == user)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.liked, liked) || other.liked == liked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,postId,content,user,likesCount,liked,createdAt,updatedAt);

@override
String toString() {
  return 'DiaryComment(id: $id, postId: $postId, content: $content, user: $user, likesCount: $likesCount, liked: $liked, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DiaryCommentCopyWith<$Res> implements $DiaryCommentCopyWith<$Res> {
  factory _$DiaryCommentCopyWith(_DiaryComment value, $Res Function(_DiaryComment) _then) = __$DiaryCommentCopyWithImpl;
@override @useResult
$Res call({
 String id, String postId, String content, DiaryUserSummary user, int likesCount, bool liked, DateTime? createdAt, DateTime? updatedAt
});


@override $DiaryUserSummaryCopyWith<$Res> get user;

}
/// @nodoc
class __$DiaryCommentCopyWithImpl<$Res>
    implements _$DiaryCommentCopyWith<$Res> {
  __$DiaryCommentCopyWithImpl(this._self, this._then);

  final _DiaryComment _self;
  final $Res Function(_DiaryComment) _then;

/// Create a copy of DiaryComment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? postId = null,Object? content = null,Object? user = null,Object? likesCount = null,Object? liked = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_DiaryComment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,postId: null == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as DiaryUserSummary,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,liked: null == liked ? _self.liked : liked // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of DiaryComment
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiaryUserSummaryCopyWith<$Res> get user {
  
  return $DiaryUserSummaryCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
