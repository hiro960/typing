// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'original_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OriginalContent {

 String get id; String get title; String get text; String get audioPath; int get durationSeconds; int get practiceCount; List<TextSegment> get segments; DateTime get createdAt; DateTime get updatedAt; DateTime? get lastPracticed;
/// Create a copy of OriginalContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OriginalContentCopyWith<OriginalContent> get copyWith => _$OriginalContentCopyWithImpl<OriginalContent>(this as OriginalContent, _$identity);

  /// Serializes this OriginalContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OriginalContent&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.text, text) || other.text == text)&&(identical(other.audioPath, audioPath) || other.audioPath == audioPath)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.practiceCount, practiceCount) || other.practiceCount == practiceCount)&&const DeepCollectionEquality().equals(other.segments, segments)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lastPracticed, lastPracticed) || other.lastPracticed == lastPracticed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,text,audioPath,durationSeconds,practiceCount,const DeepCollectionEquality().hash(segments),createdAt,updatedAt,lastPracticed);

@override
String toString() {
  return 'OriginalContent(id: $id, title: $title, text: $text, audioPath: $audioPath, durationSeconds: $durationSeconds, practiceCount: $practiceCount, segments: $segments, createdAt: $createdAt, updatedAt: $updatedAt, lastPracticed: $lastPracticed)';
}


}

/// @nodoc
abstract mixin class $OriginalContentCopyWith<$Res>  {
  factory $OriginalContentCopyWith(OriginalContent value, $Res Function(OriginalContent) _then) = _$OriginalContentCopyWithImpl;
@useResult
$Res call({
 String id, String title, String text, String audioPath, int durationSeconds, int practiceCount, List<TextSegment> segments, DateTime createdAt, DateTime updatedAt, DateTime? lastPracticed
});




}
/// @nodoc
class _$OriginalContentCopyWithImpl<$Res>
    implements $OriginalContentCopyWith<$Res> {
  _$OriginalContentCopyWithImpl(this._self, this._then);

  final OriginalContent _self;
  final $Res Function(OriginalContent) _then;

/// Create a copy of OriginalContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? text = null,Object? audioPath = null,Object? durationSeconds = null,Object? practiceCount = null,Object? segments = null,Object? createdAt = null,Object? updatedAt = null,Object? lastPracticed = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,audioPath: null == audioPath ? _self.audioPath : audioPath // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,practiceCount: null == practiceCount ? _self.practiceCount : practiceCount // ignore: cast_nullable_to_non_nullable
as int,segments: null == segments ? _self.segments : segments // ignore: cast_nullable_to_non_nullable
as List<TextSegment>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastPracticed: freezed == lastPracticed ? _self.lastPracticed : lastPracticed // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [OriginalContent].
extension OriginalContentPatterns on OriginalContent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OriginalContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OriginalContent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OriginalContent value)  $default,){
final _that = this;
switch (_that) {
case _OriginalContent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OriginalContent value)?  $default,){
final _that = this;
switch (_that) {
case _OriginalContent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String text,  String audioPath,  int durationSeconds,  int practiceCount,  List<TextSegment> segments,  DateTime createdAt,  DateTime updatedAt,  DateTime? lastPracticed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OriginalContent() when $default != null:
return $default(_that.id,_that.title,_that.text,_that.audioPath,_that.durationSeconds,_that.practiceCount,_that.segments,_that.createdAt,_that.updatedAt,_that.lastPracticed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String text,  String audioPath,  int durationSeconds,  int practiceCount,  List<TextSegment> segments,  DateTime createdAt,  DateTime updatedAt,  DateTime? lastPracticed)  $default,) {final _that = this;
switch (_that) {
case _OriginalContent():
return $default(_that.id,_that.title,_that.text,_that.audioPath,_that.durationSeconds,_that.practiceCount,_that.segments,_that.createdAt,_that.updatedAt,_that.lastPracticed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String text,  String audioPath,  int durationSeconds,  int practiceCount,  List<TextSegment> segments,  DateTime createdAt,  DateTime updatedAt,  DateTime? lastPracticed)?  $default,) {final _that = this;
switch (_that) {
case _OriginalContent() when $default != null:
return $default(_that.id,_that.title,_that.text,_that.audioPath,_that.durationSeconds,_that.practiceCount,_that.segments,_that.createdAt,_that.updatedAt,_that.lastPracticed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OriginalContent extends OriginalContent {
  const _OriginalContent({required this.id, required this.title, required this.text, required this.audioPath, this.durationSeconds = 0, this.practiceCount = 0, final  List<TextSegment> segments = const <TextSegment>[], required this.createdAt, required this.updatedAt, this.lastPracticed}): _segments = segments,super._();
  factory _OriginalContent.fromJson(Map<String, dynamic> json) => _$OriginalContentFromJson(json);

@override final  String id;
@override final  String title;
@override final  String text;
@override final  String audioPath;
@override@JsonKey() final  int durationSeconds;
@override@JsonKey() final  int practiceCount;
 final  List<TextSegment> _segments;
@override@JsonKey() List<TextSegment> get segments {
  if (_segments is EqualUnmodifiableListView) return _segments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_segments);
}

@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  DateTime? lastPracticed;

/// Create a copy of OriginalContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OriginalContentCopyWith<_OriginalContent> get copyWith => __$OriginalContentCopyWithImpl<_OriginalContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OriginalContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OriginalContent&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.text, text) || other.text == text)&&(identical(other.audioPath, audioPath) || other.audioPath == audioPath)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.practiceCount, practiceCount) || other.practiceCount == practiceCount)&&const DeepCollectionEquality().equals(other._segments, _segments)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lastPracticed, lastPracticed) || other.lastPracticed == lastPracticed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,text,audioPath,durationSeconds,practiceCount,const DeepCollectionEquality().hash(_segments),createdAt,updatedAt,lastPracticed);

@override
String toString() {
  return 'OriginalContent(id: $id, title: $title, text: $text, audioPath: $audioPath, durationSeconds: $durationSeconds, practiceCount: $practiceCount, segments: $segments, createdAt: $createdAt, updatedAt: $updatedAt, lastPracticed: $lastPracticed)';
}


}

/// @nodoc
abstract mixin class _$OriginalContentCopyWith<$Res> implements $OriginalContentCopyWith<$Res> {
  factory _$OriginalContentCopyWith(_OriginalContent value, $Res Function(_OriginalContent) _then) = __$OriginalContentCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String text, String audioPath, int durationSeconds, int practiceCount, List<TextSegment> segments, DateTime createdAt, DateTime updatedAt, DateTime? lastPracticed
});




}
/// @nodoc
class __$OriginalContentCopyWithImpl<$Res>
    implements _$OriginalContentCopyWith<$Res> {
  __$OriginalContentCopyWithImpl(this._self, this._then);

  final _OriginalContent _self;
  final $Res Function(_OriginalContent) _then;

/// Create a copy of OriginalContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? text = null,Object? audioPath = null,Object? durationSeconds = null,Object? practiceCount = null,Object? segments = null,Object? createdAt = null,Object? updatedAt = null,Object? lastPracticed = freezed,}) {
  return _then(_OriginalContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,audioPath: null == audioPath ? _self.audioPath : audioPath // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,practiceCount: null == practiceCount ? _self.practiceCount : practiceCount // ignore: cast_nullable_to_non_nullable
as int,segments: null == segments ? _self._segments : segments // ignore: cast_nullable_to_non_nullable
as List<TextSegment>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastPracticed: freezed == lastPracticed ? _self.lastPracticed : lastPracticed // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$OriginalContentDataFile {

 String get version; List<OriginalContent> get contents;
/// Create a copy of OriginalContentDataFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OriginalContentDataFileCopyWith<OriginalContentDataFile> get copyWith => _$OriginalContentDataFileCopyWithImpl<OriginalContentDataFile>(this as OriginalContentDataFile, _$identity);

  /// Serializes this OriginalContentDataFile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OriginalContentDataFile&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.contents, contents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(contents));

@override
String toString() {
  return 'OriginalContentDataFile(version: $version, contents: $contents)';
}


}

/// @nodoc
abstract mixin class $OriginalContentDataFileCopyWith<$Res>  {
  factory $OriginalContentDataFileCopyWith(OriginalContentDataFile value, $Res Function(OriginalContentDataFile) _then) = _$OriginalContentDataFileCopyWithImpl;
@useResult
$Res call({
 String version, List<OriginalContent> contents
});




}
/// @nodoc
class _$OriginalContentDataFileCopyWithImpl<$Res>
    implements $OriginalContentDataFileCopyWith<$Res> {
  _$OriginalContentDataFileCopyWithImpl(this._self, this._then);

  final OriginalContentDataFile _self;
  final $Res Function(OriginalContentDataFile) _then;

/// Create a copy of OriginalContentDataFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? contents = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,contents: null == contents ? _self.contents : contents // ignore: cast_nullable_to_non_nullable
as List<OriginalContent>,
  ));
}

}


/// Adds pattern-matching-related methods to [OriginalContentDataFile].
extension OriginalContentDataFilePatterns on OriginalContentDataFile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OriginalContentDataFile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OriginalContentDataFile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OriginalContentDataFile value)  $default,){
final _that = this;
switch (_that) {
case _OriginalContentDataFile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OriginalContentDataFile value)?  $default,){
final _that = this;
switch (_that) {
case _OriginalContentDataFile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  List<OriginalContent> contents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OriginalContentDataFile() when $default != null:
return $default(_that.version,_that.contents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  List<OriginalContent> contents)  $default,) {final _that = this;
switch (_that) {
case _OriginalContentDataFile():
return $default(_that.version,_that.contents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  List<OriginalContent> contents)?  $default,) {final _that = this;
switch (_that) {
case _OriginalContentDataFile() when $default != null:
return $default(_that.version,_that.contents);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OriginalContentDataFile implements OriginalContentDataFile {
  const _OriginalContentDataFile({this.version = '1.0.0', final  List<OriginalContent> contents = const <OriginalContent>[]}): _contents = contents;
  factory _OriginalContentDataFile.fromJson(Map<String, dynamic> json) => _$OriginalContentDataFileFromJson(json);

@override@JsonKey() final  String version;
 final  List<OriginalContent> _contents;
@override@JsonKey() List<OriginalContent> get contents {
  if (_contents is EqualUnmodifiableListView) return _contents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contents);
}


/// Create a copy of OriginalContentDataFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OriginalContentDataFileCopyWith<_OriginalContentDataFile> get copyWith => __$OriginalContentDataFileCopyWithImpl<_OriginalContentDataFile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OriginalContentDataFileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OriginalContentDataFile&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._contents, _contents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(_contents));

@override
String toString() {
  return 'OriginalContentDataFile(version: $version, contents: $contents)';
}


}

/// @nodoc
abstract mixin class _$OriginalContentDataFileCopyWith<$Res> implements $OriginalContentDataFileCopyWith<$Res> {
  factory _$OriginalContentDataFileCopyWith(_OriginalContentDataFile value, $Res Function(_OriginalContentDataFile) _then) = __$OriginalContentDataFileCopyWithImpl;
@override @useResult
$Res call({
 String version, List<OriginalContent> contents
});




}
/// @nodoc
class __$OriginalContentDataFileCopyWithImpl<$Res>
    implements _$OriginalContentDataFileCopyWith<$Res> {
  __$OriginalContentDataFileCopyWithImpl(this._self, this._then);

  final _OriginalContentDataFile _self;
  final $Res Function(_OriginalContentDataFile) _then;

/// Create a copy of OriginalContentDataFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? contents = null,}) {
  return _then(_OriginalContentDataFile(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,contents: null == contents ? _self._contents : contents // ignore: cast_nullable_to_non_nullable
as List<OriginalContent>,
  ));
}


}

/// @nodoc
mixin _$OriginalContentSessionState {

 OriginalContent get content; bool get isPlaying; PlaybackSpeed get playbackSpeed; Duration get currentPosition; Duration get totalDuration; int get currentSegmentIndex; bool get showMeaning;/// リピートモードの対象セグメントインデックス（-1 = リピートなし）
 int get repeatSegmentIndex;
/// Create a copy of OriginalContentSessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OriginalContentSessionStateCopyWith<OriginalContentSessionState> get copyWith => _$OriginalContentSessionStateCopyWithImpl<OriginalContentSessionState>(this as OriginalContentSessionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OriginalContentSessionState&&(identical(other.content, content) || other.content == content)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.playbackSpeed, playbackSpeed) || other.playbackSpeed == playbackSpeed)&&(identical(other.currentPosition, currentPosition) || other.currentPosition == currentPosition)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration)&&(identical(other.currentSegmentIndex, currentSegmentIndex) || other.currentSegmentIndex == currentSegmentIndex)&&(identical(other.showMeaning, showMeaning) || other.showMeaning == showMeaning)&&(identical(other.repeatSegmentIndex, repeatSegmentIndex) || other.repeatSegmentIndex == repeatSegmentIndex));
}


@override
int get hashCode => Object.hash(runtimeType,content,isPlaying,playbackSpeed,currentPosition,totalDuration,currentSegmentIndex,showMeaning,repeatSegmentIndex);

@override
String toString() {
  return 'OriginalContentSessionState(content: $content, isPlaying: $isPlaying, playbackSpeed: $playbackSpeed, currentPosition: $currentPosition, totalDuration: $totalDuration, currentSegmentIndex: $currentSegmentIndex, showMeaning: $showMeaning, repeatSegmentIndex: $repeatSegmentIndex)';
}


}

/// @nodoc
abstract mixin class $OriginalContentSessionStateCopyWith<$Res>  {
  factory $OriginalContentSessionStateCopyWith(OriginalContentSessionState value, $Res Function(OriginalContentSessionState) _then) = _$OriginalContentSessionStateCopyWithImpl;
@useResult
$Res call({
 OriginalContent content, bool isPlaying, PlaybackSpeed playbackSpeed, Duration currentPosition, Duration totalDuration, int currentSegmentIndex, bool showMeaning, int repeatSegmentIndex
});


$OriginalContentCopyWith<$Res> get content;

}
/// @nodoc
class _$OriginalContentSessionStateCopyWithImpl<$Res>
    implements $OriginalContentSessionStateCopyWith<$Res> {
  _$OriginalContentSessionStateCopyWithImpl(this._self, this._then);

  final OriginalContentSessionState _self;
  final $Res Function(OriginalContentSessionState) _then;

/// Create a copy of OriginalContentSessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? isPlaying = null,Object? playbackSpeed = null,Object? currentPosition = null,Object? totalDuration = null,Object? currentSegmentIndex = null,Object? showMeaning = null,Object? repeatSegmentIndex = null,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as OriginalContent,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,playbackSpeed: null == playbackSpeed ? _self.playbackSpeed : playbackSpeed // ignore: cast_nullable_to_non_nullable
as PlaybackSpeed,currentPosition: null == currentPosition ? _self.currentPosition : currentPosition // ignore: cast_nullable_to_non_nullable
as Duration,totalDuration: null == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as Duration,currentSegmentIndex: null == currentSegmentIndex ? _self.currentSegmentIndex : currentSegmentIndex // ignore: cast_nullable_to_non_nullable
as int,showMeaning: null == showMeaning ? _self.showMeaning : showMeaning // ignore: cast_nullable_to_non_nullable
as bool,repeatSegmentIndex: null == repeatSegmentIndex ? _self.repeatSegmentIndex : repeatSegmentIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of OriginalContentSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OriginalContentCopyWith<$Res> get content {
  
  return $OriginalContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [OriginalContentSessionState].
extension OriginalContentSessionStatePatterns on OriginalContentSessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OriginalContentSessionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OriginalContentSessionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OriginalContentSessionState value)  $default,){
final _that = this;
switch (_that) {
case _OriginalContentSessionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OriginalContentSessionState value)?  $default,){
final _that = this;
switch (_that) {
case _OriginalContentSessionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OriginalContent content,  bool isPlaying,  PlaybackSpeed playbackSpeed,  Duration currentPosition,  Duration totalDuration,  int currentSegmentIndex,  bool showMeaning,  int repeatSegmentIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OriginalContentSessionState() when $default != null:
return $default(_that.content,_that.isPlaying,_that.playbackSpeed,_that.currentPosition,_that.totalDuration,_that.currentSegmentIndex,_that.showMeaning,_that.repeatSegmentIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OriginalContent content,  bool isPlaying,  PlaybackSpeed playbackSpeed,  Duration currentPosition,  Duration totalDuration,  int currentSegmentIndex,  bool showMeaning,  int repeatSegmentIndex)  $default,) {final _that = this;
switch (_that) {
case _OriginalContentSessionState():
return $default(_that.content,_that.isPlaying,_that.playbackSpeed,_that.currentPosition,_that.totalDuration,_that.currentSegmentIndex,_that.showMeaning,_that.repeatSegmentIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OriginalContent content,  bool isPlaying,  PlaybackSpeed playbackSpeed,  Duration currentPosition,  Duration totalDuration,  int currentSegmentIndex,  bool showMeaning,  int repeatSegmentIndex)?  $default,) {final _that = this;
switch (_that) {
case _OriginalContentSessionState() when $default != null:
return $default(_that.content,_that.isPlaying,_that.playbackSpeed,_that.currentPosition,_that.totalDuration,_that.currentSegmentIndex,_that.showMeaning,_that.repeatSegmentIndex);case _:
  return null;

}
}

}

/// @nodoc


class _OriginalContentSessionState extends OriginalContentSessionState {
  const _OriginalContentSessionState({required this.content, this.isPlaying = false, this.playbackSpeed = PlaybackSpeed.x1_0, this.currentPosition = Duration.zero, this.totalDuration = Duration.zero, this.currentSegmentIndex = -1, this.showMeaning = true, this.repeatSegmentIndex = -1}): super._();
  

@override final  OriginalContent content;
@override@JsonKey() final  bool isPlaying;
@override@JsonKey() final  PlaybackSpeed playbackSpeed;
@override@JsonKey() final  Duration currentPosition;
@override@JsonKey() final  Duration totalDuration;
@override@JsonKey() final  int currentSegmentIndex;
@override@JsonKey() final  bool showMeaning;
/// リピートモードの対象セグメントインデックス（-1 = リピートなし）
@override@JsonKey() final  int repeatSegmentIndex;

/// Create a copy of OriginalContentSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OriginalContentSessionStateCopyWith<_OriginalContentSessionState> get copyWith => __$OriginalContentSessionStateCopyWithImpl<_OriginalContentSessionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OriginalContentSessionState&&(identical(other.content, content) || other.content == content)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.playbackSpeed, playbackSpeed) || other.playbackSpeed == playbackSpeed)&&(identical(other.currentPosition, currentPosition) || other.currentPosition == currentPosition)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration)&&(identical(other.currentSegmentIndex, currentSegmentIndex) || other.currentSegmentIndex == currentSegmentIndex)&&(identical(other.showMeaning, showMeaning) || other.showMeaning == showMeaning)&&(identical(other.repeatSegmentIndex, repeatSegmentIndex) || other.repeatSegmentIndex == repeatSegmentIndex));
}


@override
int get hashCode => Object.hash(runtimeType,content,isPlaying,playbackSpeed,currentPosition,totalDuration,currentSegmentIndex,showMeaning,repeatSegmentIndex);

@override
String toString() {
  return 'OriginalContentSessionState(content: $content, isPlaying: $isPlaying, playbackSpeed: $playbackSpeed, currentPosition: $currentPosition, totalDuration: $totalDuration, currentSegmentIndex: $currentSegmentIndex, showMeaning: $showMeaning, repeatSegmentIndex: $repeatSegmentIndex)';
}


}

/// @nodoc
abstract mixin class _$OriginalContentSessionStateCopyWith<$Res> implements $OriginalContentSessionStateCopyWith<$Res> {
  factory _$OriginalContentSessionStateCopyWith(_OriginalContentSessionState value, $Res Function(_OriginalContentSessionState) _then) = __$OriginalContentSessionStateCopyWithImpl;
@override @useResult
$Res call({
 OriginalContent content, bool isPlaying, PlaybackSpeed playbackSpeed, Duration currentPosition, Duration totalDuration, int currentSegmentIndex, bool showMeaning, int repeatSegmentIndex
});


@override $OriginalContentCopyWith<$Res> get content;

}
/// @nodoc
class __$OriginalContentSessionStateCopyWithImpl<$Res>
    implements _$OriginalContentSessionStateCopyWith<$Res> {
  __$OriginalContentSessionStateCopyWithImpl(this._self, this._then);

  final _OriginalContentSessionState _self;
  final $Res Function(_OriginalContentSessionState) _then;

/// Create a copy of OriginalContentSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? isPlaying = null,Object? playbackSpeed = null,Object? currentPosition = null,Object? totalDuration = null,Object? currentSegmentIndex = null,Object? showMeaning = null,Object? repeatSegmentIndex = null,}) {
  return _then(_OriginalContentSessionState(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as OriginalContent,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,playbackSpeed: null == playbackSpeed ? _self.playbackSpeed : playbackSpeed // ignore: cast_nullable_to_non_nullable
as PlaybackSpeed,currentPosition: null == currentPosition ? _self.currentPosition : currentPosition // ignore: cast_nullable_to_non_nullable
as Duration,totalDuration: null == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as Duration,currentSegmentIndex: null == currentSegmentIndex ? _self.currentSegmentIndex : currentSegmentIndex // ignore: cast_nullable_to_non_nullable
as int,showMeaning: null == showMeaning ? _self.showMeaning : showMeaning // ignore: cast_nullable_to_non_nullable
as bool,repeatSegmentIndex: null == repeatSegmentIndex ? _self.repeatSegmentIndex : repeatSegmentIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of OriginalContentSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OriginalContentCopyWith<$Res> get content {
  
  return $OriginalContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}

// dart format on
