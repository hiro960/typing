// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diary_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DiaryUserSummary {

 String get id; String get username; String get displayName; String? get profileImageUrl;
/// Create a copy of DiaryUserSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryUserSummaryCopyWith<DiaryUserSummary> get copyWith => _$DiaryUserSummaryCopyWithImpl<DiaryUserSummary>(this as DiaryUserSummary, _$identity);

  /// Serializes this DiaryUserSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryUserSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,displayName,profileImageUrl);

@override
String toString() {
  return 'DiaryUserSummary(id: $id, username: $username, displayName: $displayName, profileImageUrl: $profileImageUrl)';
}


}

/// @nodoc
abstract mixin class $DiaryUserSummaryCopyWith<$Res>  {
  factory $DiaryUserSummaryCopyWith(DiaryUserSummary value, $Res Function(DiaryUserSummary) _then) = _$DiaryUserSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String username, String displayName, String? profileImageUrl
});




}
/// @nodoc
class _$DiaryUserSummaryCopyWithImpl<$Res>
    implements $DiaryUserSummaryCopyWith<$Res> {
  _$DiaryUserSummaryCopyWithImpl(this._self, this._then);

  final DiaryUserSummary _self;
  final $Res Function(DiaryUserSummary) _then;

/// Create a copy of DiaryUserSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? profileImageUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiaryUserSummary].
extension DiaryUserSummaryPatterns on DiaryUserSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryUserSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryUserSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryUserSummary value)  $default,){
final _that = this;
switch (_that) {
case _DiaryUserSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryUserSummary value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryUserSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String displayName,  String? profileImageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryUserSummary() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.profileImageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String displayName,  String? profileImageUrl)  $default,) {final _that = this;
switch (_that) {
case _DiaryUserSummary():
return $default(_that.id,_that.username,_that.displayName,_that.profileImageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String displayName,  String? profileImageUrl)?  $default,) {final _that = this;
switch (_that) {
case _DiaryUserSummary() when $default != null:
return $default(_that.id,_that.username,_that.displayName,_that.profileImageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiaryUserSummary implements DiaryUserSummary {
  const _DiaryUserSummary({required this.id, required this.username, required this.displayName, this.profileImageUrl});
  factory _DiaryUserSummary.fromJson(Map<String, dynamic> json) => _$DiaryUserSummaryFromJson(json);

@override final  String id;
@override final  String username;
@override final  String displayName;
@override final  String? profileImageUrl;

/// Create a copy of DiaryUserSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryUserSummaryCopyWith<_DiaryUserSummary> get copyWith => __$DiaryUserSummaryCopyWithImpl<_DiaryUserSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiaryUserSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryUserSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.profileImageUrl, profileImageUrl) || other.profileImageUrl == profileImageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,displayName,profileImageUrl);

@override
String toString() {
  return 'DiaryUserSummary(id: $id, username: $username, displayName: $displayName, profileImageUrl: $profileImageUrl)';
}


}

/// @nodoc
abstract mixin class _$DiaryUserSummaryCopyWith<$Res> implements $DiaryUserSummaryCopyWith<$Res> {
  factory _$DiaryUserSummaryCopyWith(_DiaryUserSummary value, $Res Function(_DiaryUserSummary) _then) = __$DiaryUserSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String displayName, String? profileImageUrl
});




}
/// @nodoc
class __$DiaryUserSummaryCopyWithImpl<$Res>
    implements _$DiaryUserSummaryCopyWith<$Res> {
  __$DiaryUserSummaryCopyWithImpl(this._self, this._then);

  final _DiaryUserSummary _self;
  final $Res Function(_DiaryUserSummary) _then;

/// Create a copy of DiaryUserSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? displayName = null,Object? profileImageUrl = freezed,}) {
  return _then(_DiaryUserSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,profileImageUrl: freezed == profileImageUrl ? _self.profileImageUrl : profileImageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DiaryQuotedPost {

 String get id; String get content; DiaryUserSummary get user; List<String> get imageUrls; List<String> get tags; DateTime? get createdAt;
/// Create a copy of DiaryQuotedPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryQuotedPostCopyWith<DiaryQuotedPost> get copyWith => _$DiaryQuotedPostCopyWithImpl<DiaryQuotedPost>(this as DiaryQuotedPost, _$identity);

  /// Serializes this DiaryQuotedPost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryQuotedPost&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,user,const DeepCollectionEquality().hash(imageUrls),const DeepCollectionEquality().hash(tags),createdAt);

@override
String toString() {
  return 'DiaryQuotedPost(id: $id, content: $content, user: $user, imageUrls: $imageUrls, tags: $tags, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DiaryQuotedPostCopyWith<$Res>  {
  factory $DiaryQuotedPostCopyWith(DiaryQuotedPost value, $Res Function(DiaryQuotedPost) _then) = _$DiaryQuotedPostCopyWithImpl;
@useResult
$Res call({
 String id, String content, DiaryUserSummary user, List<String> imageUrls, List<String> tags, DateTime? createdAt
});


$DiaryUserSummaryCopyWith<$Res> get user;

}
/// @nodoc
class _$DiaryQuotedPostCopyWithImpl<$Res>
    implements $DiaryQuotedPostCopyWith<$Res> {
  _$DiaryQuotedPostCopyWithImpl(this._self, this._then);

  final DiaryQuotedPost _self;
  final $Res Function(DiaryQuotedPost) _then;

/// Create a copy of DiaryQuotedPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? content = null,Object? user = null,Object? imageUrls = null,Object? tags = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as DiaryUserSummary,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of DiaryQuotedPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiaryUserSummaryCopyWith<$Res> get user {
  
  return $DiaryUserSummaryCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [DiaryQuotedPost].
extension DiaryQuotedPostPatterns on DiaryQuotedPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryQuotedPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryQuotedPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryQuotedPost value)  $default,){
final _that = this;
switch (_that) {
case _DiaryQuotedPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryQuotedPost value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryQuotedPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String content,  DiaryUserSummary user,  List<String> imageUrls,  List<String> tags,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryQuotedPost() when $default != null:
return $default(_that.id,_that.content,_that.user,_that.imageUrls,_that.tags,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String content,  DiaryUserSummary user,  List<String> imageUrls,  List<String> tags,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _DiaryQuotedPost():
return $default(_that.id,_that.content,_that.user,_that.imageUrls,_that.tags,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String content,  DiaryUserSummary user,  List<String> imageUrls,  List<String> tags,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DiaryQuotedPost() when $default != null:
return $default(_that.id,_that.content,_that.user,_that.imageUrls,_that.tags,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiaryQuotedPost implements DiaryQuotedPost {
  const _DiaryQuotedPost({required this.id, required this.content, required this.user, final  List<String> imageUrls = const <String>[], final  List<String> tags = const <String>[], this.createdAt}): _imageUrls = imageUrls,_tags = tags;
  factory _DiaryQuotedPost.fromJson(Map<String, dynamic> json) => _$DiaryQuotedPostFromJson(json);

@override final  String id;
@override final  String content;
@override final  DiaryUserSummary user;
final  List<String> _imageUrls;
@override
List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  return EqualUnmodifiableListView(_imageUrls);
}

final  List<String> _tags;
@override
List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  return EqualUnmodifiableListView(_tags);
}

@override final  DateTime? createdAt;

/// Create a copy of DiaryQuotedPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryQuotedPostCopyWith<_DiaryQuotedPost> get copyWith => __$DiaryQuotedPostCopyWithImpl<_DiaryQuotedPost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiaryQuotedPostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryQuotedPost&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.user, user) || other.user == user)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,user,const DeepCollectionEquality().hash(_imageUrls),const DeepCollectionEquality().hash(_tags),createdAt);

@override
String toString() {
  return 'DiaryQuotedPost(id: $id, content: $content, user: $user, imageUrls: $imageUrls, tags: $tags, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DiaryQuotedPostCopyWith<$Res> implements $DiaryQuotedPostCopyWith<$Res> {
  factory _$DiaryQuotedPostCopyWith(_DiaryQuotedPost value, $Res Function(_DiaryQuotedPost) _then) = __$DiaryQuotedPostCopyWithImpl;
@override @useResult
$Res call({
 String id, String content, DiaryUserSummary user, List<String> imageUrls, List<String> tags, DateTime? createdAt
});


@override $DiaryUserSummaryCopyWith<$Res> get user;

}
/// @nodoc
class __$DiaryQuotedPostCopyWithImpl<$Res>
    implements _$DiaryQuotedPostCopyWith<$Res> {
  __$DiaryQuotedPostCopyWithImpl(this._self, this._then);

  final _DiaryQuotedPost _self;
  final $Res Function(_DiaryQuotedPost) _then;

/// Create a copy of DiaryQuotedPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? content = null,Object? user = null,Object? imageUrls = null,Object? tags = null,Object? createdAt = freezed,}) {
  return _then(_DiaryQuotedPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as DiaryUserSummary,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of DiaryQuotedPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiaryUserSummaryCopyWith<$Res> get user {
  
  return $DiaryUserSummaryCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// @nodoc
mixin _$DiaryPageInfo {

 String? get nextCursor; bool get hasNextPage; int get count;
/// Create a copy of DiaryPageInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryPageInfoCopyWith<DiaryPageInfo> get copyWith => _$DiaryPageInfoCopyWithImpl<DiaryPageInfo>(this as DiaryPageInfo, _$identity);

  /// Serializes this DiaryPageInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryPageInfo&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nextCursor,hasNextPage,count);

@override
String toString() {
  return 'DiaryPageInfo(nextCursor: $nextCursor, hasNextPage: $hasNextPage, count: $count)';
}


}

/// @nodoc
abstract mixin class $DiaryPageInfoCopyWith<$Res>  {
  factory $DiaryPageInfoCopyWith(DiaryPageInfo value, $Res Function(DiaryPageInfo) _then) = _$DiaryPageInfoCopyWithImpl;
@useResult
$Res call({
 String? nextCursor, bool hasNextPage, int count
});




}
/// @nodoc
class _$DiaryPageInfoCopyWithImpl<$Res>
    implements $DiaryPageInfoCopyWith<$Res> {
  _$DiaryPageInfoCopyWithImpl(this._self, this._then);

  final DiaryPageInfo _self;
  final $Res Function(DiaryPageInfo) _then;

/// Create a copy of DiaryPageInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nextCursor = freezed,Object? hasNextPage = null,Object? count = null,}) {
  return _then(_self.copyWith(
nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DiaryPageInfo].
extension DiaryPageInfoPatterns on DiaryPageInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryPageInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryPageInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryPageInfo value)  $default,){
final _that = this;
switch (_that) {
case _DiaryPageInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryPageInfo value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryPageInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? nextCursor,  bool hasNextPage,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryPageInfo() when $default != null:
return $default(_that.nextCursor,_that.hasNextPage,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? nextCursor,  bool hasNextPage,  int count)  $default,) {final _that = this;
switch (_that) {
case _DiaryPageInfo():
return $default(_that.nextCursor,_that.hasNextPage,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? nextCursor,  bool hasNextPage,  int count)?  $default,) {final _that = this;
switch (_that) {
case _DiaryPageInfo() when $default != null:
return $default(_that.nextCursor,_that.hasNextPage,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiaryPageInfo implements DiaryPageInfo {
  const _DiaryPageInfo({this.nextCursor, this.hasNextPage = false, this.count = 0});
  factory _DiaryPageInfo.fromJson(Map<String, dynamic> json) => _$DiaryPageInfoFromJson(json);

@override final  String? nextCursor;
@override@JsonKey() final  bool hasNextPage;
@override@JsonKey() final  int count;

/// Create a copy of DiaryPageInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryPageInfoCopyWith<_DiaryPageInfo> get copyWith => __$DiaryPageInfoCopyWithImpl<_DiaryPageInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiaryPageInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryPageInfo&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nextCursor,hasNextPage,count);

@override
String toString() {
  return 'DiaryPageInfo(nextCursor: $nextCursor, hasNextPage: $hasNextPage, count: $count)';
}


}

/// @nodoc
abstract mixin class _$DiaryPageInfoCopyWith<$Res> implements $DiaryPageInfoCopyWith<$Res> {
  factory _$DiaryPageInfoCopyWith(_DiaryPageInfo value, $Res Function(_DiaryPageInfo) _then) = __$DiaryPageInfoCopyWithImpl;
@override @useResult
$Res call({
 String? nextCursor, bool hasNextPage, int count
});




}
/// @nodoc
class __$DiaryPageInfoCopyWithImpl<$Res>
    implements _$DiaryPageInfoCopyWith<$Res> {
  __$DiaryPageInfoCopyWithImpl(this._self, this._then);

  final _DiaryPageInfo _self;
  final $Res Function(_DiaryPageInfo) _then;

/// Create a copy of DiaryPageInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nextCursor = freezed,Object? hasNextPage = null,Object? count = null,}) {
  return _then(_DiaryPageInfo(
nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DiaryPost {

 String get id; String get content; List<String> get imageUrls; List<String> get tags; String? get quotedPostId; bool get shareToDiary; String get visibility; DiaryUserSummary get user; DiaryQuotedPost? get quotedPost; int get likesCount; int get commentsCount; int get quotesCount; bool get liked; bool get bookmarked; bool get isEdited; DateTime? get createdAt; DateTime? get updatedAt; DateTime? get editedAt;
/// Create a copy of DiaryPost
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryPostCopyWith<DiaryPost> get copyWith => _$DiaryPostCopyWithImpl<DiaryPost>(this as DiaryPost, _$identity);

  /// Serializes this DiaryPost to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryPost&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.imageUrls, imageUrls)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.quotedPostId, quotedPostId) || other.quotedPostId == quotedPostId)&&(identical(other.shareToDiary, shareToDiary) || other.shareToDiary == shareToDiary)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.user, user) || other.user == user)&&(identical(other.quotedPost, quotedPost) || other.quotedPost == quotedPost)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.commentsCount, commentsCount) || other.commentsCount == commentsCount)&&(identical(other.quotesCount, quotesCount) || other.quotesCount == quotesCount)&&(identical(other.liked, liked) || other.liked == liked)&&(identical(other.bookmarked, bookmarked) || other.bookmarked == bookmarked)&&(identical(other.isEdited, isEdited) || other.isEdited == isEdited)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.editedAt, editedAt) || other.editedAt == editedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,const DeepCollectionEquality().hash(imageUrls),const DeepCollectionEquality().hash(tags),quotedPostId,shareToDiary,visibility,user,quotedPost,likesCount,commentsCount,quotesCount,liked,bookmarked,isEdited,createdAt,updatedAt,editedAt);

@override
String toString() {
  return 'DiaryPost(id: $id, content: $content, imageUrls: $imageUrls, tags: $tags, quotedPostId: $quotedPostId, shareToDiary: $shareToDiary, visibility: $visibility, user: $user, quotedPost: $quotedPost, likesCount: $likesCount, commentsCount: $commentsCount, quotesCount: $quotesCount, liked: $liked, bookmarked: $bookmarked, isEdited: $isEdited, createdAt: $createdAt, updatedAt: $updatedAt, editedAt: $editedAt)';
}


}

/// @nodoc
abstract mixin class $DiaryPostCopyWith<$Res>  {
  factory $DiaryPostCopyWith(DiaryPost value, $Res Function(DiaryPost) _then) = _$DiaryPostCopyWithImpl;
@useResult
$Res call({
 String id, String content, List<String> imageUrls, List<String> tags, String? quotedPostId, bool shareToDiary, String visibility, DiaryUserSummary user, DiaryQuotedPost? quotedPost, int likesCount, int commentsCount, int quotesCount, bool liked, bool bookmarked, bool isEdited, DateTime? createdAt, DateTime? updatedAt, DateTime? editedAt
});


$DiaryUserSummaryCopyWith<$Res> get user;$DiaryQuotedPostCopyWith<$Res>? get quotedPost;

}
/// @nodoc
class _$DiaryPostCopyWithImpl<$Res>
    implements $DiaryPostCopyWith<$Res> {
  _$DiaryPostCopyWithImpl(this._self, this._then);

  final DiaryPost _self;
  final $Res Function(DiaryPost) _then;

/// Create a copy of DiaryPost
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? content = null,Object? imageUrls = null,Object? tags = null,Object? quotedPostId = freezed,Object? shareToDiary = null,Object? visibility = null,Object? user = null,Object? quotedPost = freezed,Object? likesCount = null,Object? commentsCount = null,Object? quotesCount = null,Object? liked = null,Object? bookmarked = null,Object? isEdited = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? editedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self.imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,quotedPostId: freezed == quotedPostId ? _self.quotedPostId : quotedPostId // ignore: cast_nullable_to_non_nullable
as String?,shareToDiary: null == shareToDiary ? _self.shareToDiary : shareToDiary // ignore: cast_nullable_to_non_nullable
as bool,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as DiaryUserSummary,quotedPost: freezed == quotedPost ? _self.quotedPost : quotedPost // ignore: cast_nullable_to_non_nullable
as DiaryQuotedPost?,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,commentsCount: null == commentsCount ? _self.commentsCount : commentsCount // ignore: cast_nullable_to_non_nullable
as int,quotesCount: null == quotesCount ? _self.quotesCount : quotesCount // ignore: cast_nullable_to_non_nullable
as int,liked: null == liked ? _self.liked : liked // ignore: cast_nullable_to_non_nullable
as bool,bookmarked: null == bookmarked ? _self.bookmarked : bookmarked // ignore: cast_nullable_to_non_nullable
as bool,isEdited: null == isEdited ? _self.isEdited : isEdited // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,editedAt: freezed == editedAt ? _self.editedAt : editedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of DiaryPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiaryUserSummaryCopyWith<$Res> get user {
  
  return $DiaryUserSummaryCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of DiaryPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiaryQuotedPostCopyWith<$Res>? get quotedPost {
    if (_self.quotedPost == null) {
    return null;
  }

  return $DiaryQuotedPostCopyWith<$Res>(_self.quotedPost!, (value) {
    return _then(_self.copyWith(quotedPost: value));
  });
}
}


/// Adds pattern-matching-related methods to [DiaryPost].
extension DiaryPostPatterns on DiaryPost {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryPost value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryPost() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryPost value)  $default,){
final _that = this;
switch (_that) {
case _DiaryPost():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryPost value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryPost() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String content,  List<String> imageUrls,  List<String> tags,  String? quotedPostId,  bool shareToDiary,  String visibility,  DiaryUserSummary user,  DiaryQuotedPost? quotedPost,  int likesCount,  int commentsCount,  int quotesCount,  bool liked,  bool bookmarked,  bool isEdited,  DateTime? createdAt,  DateTime? updatedAt,  DateTime? editedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryPost() when $default != null:
return $default(_that.id,_that.content,_that.imageUrls,_that.tags,_that.quotedPostId,_that.shareToDiary,_that.visibility,_that.user,_that.quotedPost,_that.likesCount,_that.commentsCount,_that.quotesCount,_that.liked,_that.bookmarked,_that.isEdited,_that.createdAt,_that.updatedAt,_that.editedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String content,  List<String> imageUrls,  List<String> tags,  String? quotedPostId,  bool shareToDiary,  String visibility,  DiaryUserSummary user,  DiaryQuotedPost? quotedPost,  int likesCount,  int commentsCount,  int quotesCount,  bool liked,  bool bookmarked,  bool isEdited,  DateTime? createdAt,  DateTime? updatedAt,  DateTime? editedAt)  $default,) {final _that = this;
switch (_that) {
case _DiaryPost():
return $default(_that.id,_that.content,_that.imageUrls,_that.tags,_that.quotedPostId,_that.shareToDiary,_that.visibility,_that.user,_that.quotedPost,_that.likesCount,_that.commentsCount,_that.quotesCount,_that.liked,_that.bookmarked,_that.isEdited,_that.createdAt,_that.updatedAt,_that.editedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String content,  List<String> imageUrls,  List<String> tags,  String? quotedPostId,  bool shareToDiary,  String visibility,  DiaryUserSummary user,  DiaryQuotedPost? quotedPost,  int likesCount,  int commentsCount,  int quotesCount,  bool liked,  bool bookmarked,  bool isEdited,  DateTime? createdAt,  DateTime? updatedAt,  DateTime? editedAt)?  $default,) {final _that = this;
switch (_that) {
case _DiaryPost() when $default != null:
return $default(_that.id,_that.content,_that.imageUrls,_that.tags,_that.quotedPostId,_that.shareToDiary,_that.visibility,_that.user,_that.quotedPost,_that.likesCount,_that.commentsCount,_that.quotesCount,_that.liked,_that.bookmarked,_that.isEdited,_that.createdAt,_that.updatedAt,_that.editedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiaryPost implements DiaryPost {
  const _DiaryPost({required this.id, required this.content, final  List<String> imageUrls = const <String>[], final  List<String> tags = const <String>[], this.quotedPostId, this.shareToDiary = true, this.visibility = 'public', required this.user, this.quotedPost, this.likesCount = 0, this.commentsCount = 0, this.quotesCount = 0, this.liked = false, this.bookmarked = false, this.isEdited = false, this.createdAt, this.updatedAt, this.editedAt}): _imageUrls = imageUrls,_tags = tags;
  factory _DiaryPost.fromJson(Map<String, dynamic> json) => _$DiaryPostFromJson(json);

@override final  String id;
@override final  String content;
 final  List<String> _imageUrls;
@override@JsonKey() List<String> get imageUrls {
  if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageUrls);
}

 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  String? quotedPostId;
@override@JsonKey() final  bool shareToDiary;
@override@JsonKey() final  String visibility;
@override final  DiaryUserSummary user;
@override final  DiaryQuotedPost? quotedPost;
@override@JsonKey() final  int likesCount;
@override@JsonKey() final  int commentsCount;
@override@JsonKey() final  int quotesCount;
@override@JsonKey() final  bool liked;
@override@JsonKey() final  bool bookmarked;
@override@JsonKey() final  bool isEdited;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override final  DateTime? editedAt;

/// Create a copy of DiaryPost
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryPostCopyWith<_DiaryPost> get copyWith => __$DiaryPostCopyWithImpl<_DiaryPost>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiaryPostToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryPost&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other._imageUrls, _imageUrls)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.quotedPostId, quotedPostId) || other.quotedPostId == quotedPostId)&&(identical(other.shareToDiary, shareToDiary) || other.shareToDiary == shareToDiary)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.user, user) || other.user == user)&&(identical(other.quotedPost, quotedPost) || other.quotedPost == quotedPost)&&(identical(other.likesCount, likesCount) || other.likesCount == likesCount)&&(identical(other.commentsCount, commentsCount) || other.commentsCount == commentsCount)&&(identical(other.quotesCount, quotesCount) || other.quotesCount == quotesCount)&&(identical(other.liked, liked) || other.liked == liked)&&(identical(other.bookmarked, bookmarked) || other.bookmarked == bookmarked)&&(identical(other.isEdited, isEdited) || other.isEdited == isEdited)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.editedAt, editedAt) || other.editedAt == editedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,const DeepCollectionEquality().hash(_imageUrls),const DeepCollectionEquality().hash(_tags),quotedPostId,shareToDiary,visibility,user,quotedPost,likesCount,commentsCount,quotesCount,liked,bookmarked,isEdited,createdAt,updatedAt,editedAt);

@override
String toString() {
  return 'DiaryPost(id: $id, content: $content, imageUrls: $imageUrls, tags: $tags, quotedPostId: $quotedPostId, shareToDiary: $shareToDiary, visibility: $visibility, user: $user, quotedPost: $quotedPost, likesCount: $likesCount, commentsCount: $commentsCount, quotesCount: $quotesCount, liked: $liked, bookmarked: $bookmarked, isEdited: $isEdited, createdAt: $createdAt, updatedAt: $updatedAt, editedAt: $editedAt)';
}


}

/// @nodoc
abstract mixin class _$DiaryPostCopyWith<$Res> implements $DiaryPostCopyWith<$Res> {
  factory _$DiaryPostCopyWith(_DiaryPost value, $Res Function(_DiaryPost) _then) = __$DiaryPostCopyWithImpl;
@override @useResult
$Res call({
 String id, String content, List<String> imageUrls, List<String> tags, String? quotedPostId, bool shareToDiary, String visibility, DiaryUserSummary user, DiaryQuotedPost? quotedPost, int likesCount, int commentsCount, int quotesCount, bool liked, bool bookmarked, bool isEdited, DateTime? createdAt, DateTime? updatedAt, DateTime? editedAt
});


@override $DiaryUserSummaryCopyWith<$Res> get user;@override $DiaryQuotedPostCopyWith<$Res>? get quotedPost;

}
/// @nodoc
class __$DiaryPostCopyWithImpl<$Res>
    implements _$DiaryPostCopyWith<$Res> {
  __$DiaryPostCopyWithImpl(this._self, this._then);

  final _DiaryPost _self;
  final $Res Function(_DiaryPost) _then;

/// Create a copy of DiaryPost
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? content = null,Object? imageUrls = null,Object? tags = null,Object? quotedPostId = freezed,Object? shareToDiary = null,Object? visibility = null,Object? user = null,Object? quotedPost = freezed,Object? likesCount = null,Object? commentsCount = null,Object? quotesCount = null,Object? liked = null,Object? bookmarked = null,Object? isEdited = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? editedAt = freezed,}) {
  return _then(_DiaryPost(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,imageUrls: null == imageUrls ? _self._imageUrls : imageUrls // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,quotedPostId: freezed == quotedPostId ? _self.quotedPostId : quotedPostId // ignore: cast_nullable_to_non_nullable
as String?,shareToDiary: null == shareToDiary ? _self.shareToDiary : shareToDiary // ignore: cast_nullable_to_non_nullable
as bool,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as DiaryUserSummary,quotedPost: freezed == quotedPost ? _self.quotedPost : quotedPost // ignore: cast_nullable_to_non_nullable
as DiaryQuotedPost?,likesCount: null == likesCount ? _self.likesCount : likesCount // ignore: cast_nullable_to_non_nullable
as int,commentsCount: null == commentsCount ? _self.commentsCount : commentsCount // ignore: cast_nullable_to_non_nullable
as int,quotesCount: null == quotesCount ? _self.quotesCount : quotesCount // ignore: cast_nullable_to_non_nullable
as int,liked: null == liked ? _self.liked : liked // ignore: cast_nullable_to_non_nullable
as bool,bookmarked: null == bookmarked ? _self.bookmarked : bookmarked // ignore: cast_nullable_to_non_nullable
as bool,isEdited: null == isEdited ? _self.isEdited : isEdited // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,editedAt: freezed == editedAt ? _self.editedAt : editedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of DiaryPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiaryUserSummaryCopyWith<$Res> get user {
  
  return $DiaryUserSummaryCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of DiaryPost
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiaryQuotedPostCopyWith<$Res>? get quotedPost {
    if (_self.quotedPost == null) {
    return null;
  }

  return $DiaryQuotedPostCopyWith<$Res>(_self.quotedPost!, (value) {
    return _then(_self.copyWith(quotedPost: value));
  });
}
}

// dart format on
