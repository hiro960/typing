// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shadowing_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TextSegment {

 int get index; String get text; String get meaning; double get startTime; double get endTime;
/// Create a copy of TextSegment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TextSegmentCopyWith<TextSegment> get copyWith => _$TextSegmentCopyWithImpl<TextSegment>(this as TextSegment, _$identity);

  /// Serializes this TextSegment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TextSegment&&(identical(other.index, index) || other.index == index)&&(identical(other.text, text) || other.text == text)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,text,meaning,startTime,endTime);

@override
String toString() {
  return 'TextSegment(index: $index, text: $text, meaning: $meaning, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class $TextSegmentCopyWith<$Res>  {
  factory $TextSegmentCopyWith(TextSegment value, $Res Function(TextSegment) _then) = _$TextSegmentCopyWithImpl;
@useResult
$Res call({
 int index, String text, String meaning, double startTime, double endTime
});




}
/// @nodoc
class _$TextSegmentCopyWithImpl<$Res>
    implements $TextSegmentCopyWith<$Res> {
  _$TextSegmentCopyWithImpl(this._self, this._then);

  final TextSegment _self;
  final $Res Function(TextSegment) _then;

/// Create a copy of TextSegment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = null,Object? text = null,Object? meaning = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_self.copyWith(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as double,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TextSegment].
extension TextSegmentPatterns on TextSegment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TextSegment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TextSegment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TextSegment value)  $default,){
final _that = this;
switch (_that) {
case _TextSegment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TextSegment value)?  $default,){
final _that = this;
switch (_that) {
case _TextSegment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int index,  String text,  String meaning,  double startTime,  double endTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TextSegment() when $default != null:
return $default(_that.index,_that.text,_that.meaning,_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int index,  String text,  String meaning,  double startTime,  double endTime)  $default,) {final _that = this;
switch (_that) {
case _TextSegment():
return $default(_that.index,_that.text,_that.meaning,_that.startTime,_that.endTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int index,  String text,  String meaning,  double startTime,  double endTime)?  $default,) {final _that = this;
switch (_that) {
case _TextSegment() when $default != null:
return $default(_that.index,_that.text,_that.meaning,_that.startTime,_that.endTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TextSegment implements TextSegment {
  const _TextSegment({required this.index, required this.text, required this.meaning, required this.startTime, required this.endTime});
  factory _TextSegment.fromJson(Map<String, dynamic> json) => _$TextSegmentFromJson(json);

@override final  int index;
@override final  String text;
@override final  String meaning;
@override final  double startTime;
@override final  double endTime;

/// Create a copy of TextSegment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TextSegmentCopyWith<_TextSegment> get copyWith => __$TextSegmentCopyWithImpl<_TextSegment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TextSegmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TextSegment&&(identical(other.index, index) || other.index == index)&&(identical(other.text, text) || other.text == text)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,text,meaning,startTime,endTime);

@override
String toString() {
  return 'TextSegment(index: $index, text: $text, meaning: $meaning, startTime: $startTime, endTime: $endTime)';
}


}

/// @nodoc
abstract mixin class _$TextSegmentCopyWith<$Res> implements $TextSegmentCopyWith<$Res> {
  factory _$TextSegmentCopyWith(_TextSegment value, $Res Function(_TextSegment) _then) = __$TextSegmentCopyWithImpl;
@override @useResult
$Res call({
 int index, String text, String meaning, double startTime, double endTime
});




}
/// @nodoc
class __$TextSegmentCopyWithImpl<$Res>
    implements _$TextSegmentCopyWith<$Res> {
  __$TextSegmentCopyWithImpl(this._self, this._then);

  final _TextSegment _self;
  final $Res Function(_TextSegment) _then;

/// Create a copy of TextSegment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = null,Object? text = null,Object? meaning = null,Object? startTime = null,Object? endTime = null,}) {
  return _then(_TextSegment(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as double,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ShadowingContent {

 String get id; String get title; String get text; String get meaning; String get audioPath; int get durationSeconds; String? get tip; List<TextSegment> get segments;
/// Create a copy of ShadowingContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShadowingContentCopyWith<ShadowingContent> get copyWith => _$ShadowingContentCopyWithImpl<ShadowingContent>(this as ShadowingContent, _$identity);

  /// Serializes this ShadowingContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShadowingContent&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.text, text) || other.text == text)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.audioPath, audioPath) || other.audioPath == audioPath)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.tip, tip) || other.tip == tip)&&const DeepCollectionEquality().equals(other.segments, segments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,text,meaning,audioPath,durationSeconds,tip,const DeepCollectionEquality().hash(segments));

@override
String toString() {
  return 'ShadowingContent(id: $id, title: $title, text: $text, meaning: $meaning, audioPath: $audioPath, durationSeconds: $durationSeconds, tip: $tip, segments: $segments)';
}


}

/// @nodoc
abstract mixin class $ShadowingContentCopyWith<$Res>  {
  factory $ShadowingContentCopyWith(ShadowingContent value, $Res Function(ShadowingContent) _then) = _$ShadowingContentCopyWithImpl;
@useResult
$Res call({
 String id, String title, String text, String meaning, String audioPath, int durationSeconds, String? tip, List<TextSegment> segments
});




}
/// @nodoc
class _$ShadowingContentCopyWithImpl<$Res>
    implements $ShadowingContentCopyWith<$Res> {
  _$ShadowingContentCopyWithImpl(this._self, this._then);

  final ShadowingContent _self;
  final $Res Function(ShadowingContent) _then;

/// Create a copy of ShadowingContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? text = null,Object? meaning = null,Object? audioPath = null,Object? durationSeconds = null,Object? tip = freezed,Object? segments = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,audioPath: null == audioPath ? _self.audioPath : audioPath // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,tip: freezed == tip ? _self.tip : tip // ignore: cast_nullable_to_non_nullable
as String?,segments: null == segments ? _self.segments : segments // ignore: cast_nullable_to_non_nullable
as List<TextSegment>,
  ));
}

}


/// Adds pattern-matching-related methods to [ShadowingContent].
extension ShadowingContentPatterns on ShadowingContent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShadowingContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShadowingContent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShadowingContent value)  $default,){
final _that = this;
switch (_that) {
case _ShadowingContent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShadowingContent value)?  $default,){
final _that = this;
switch (_that) {
case _ShadowingContent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String text,  String meaning,  String audioPath,  int durationSeconds,  String? tip,  List<TextSegment> segments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShadowingContent() when $default != null:
return $default(_that.id,_that.title,_that.text,_that.meaning,_that.audioPath,_that.durationSeconds,_that.tip,_that.segments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String text,  String meaning,  String audioPath,  int durationSeconds,  String? tip,  List<TextSegment> segments)  $default,) {final _that = this;
switch (_that) {
case _ShadowingContent():
return $default(_that.id,_that.title,_that.text,_that.meaning,_that.audioPath,_that.durationSeconds,_that.tip,_that.segments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String text,  String meaning,  String audioPath,  int durationSeconds,  String? tip,  List<TextSegment> segments)?  $default,) {final _that = this;
switch (_that) {
case _ShadowingContent() when $default != null:
return $default(_that.id,_that.title,_that.text,_that.meaning,_that.audioPath,_that.durationSeconds,_that.tip,_that.segments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShadowingContent implements ShadowingContent {
  const _ShadowingContent({required this.id, required this.title, required this.text, required this.meaning, required this.audioPath, required this.durationSeconds, this.tip, final  List<TextSegment> segments = const <TextSegment>[]}): _segments = segments;
  factory _ShadowingContent.fromJson(Map<String, dynamic> json) => _$ShadowingContentFromJson(json);

@override final  String id;
@override final  String title;
@override final  String text;
@override final  String meaning;
@override final  String audioPath;
@override final  int durationSeconds;
@override final  String? tip;
 final  List<TextSegment> _segments;
@override@JsonKey() List<TextSegment> get segments {
  if (_segments is EqualUnmodifiableListView) return _segments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_segments);
}


/// Create a copy of ShadowingContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShadowingContentCopyWith<_ShadowingContent> get copyWith => __$ShadowingContentCopyWithImpl<_ShadowingContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShadowingContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShadowingContent&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.text, text) || other.text == text)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.audioPath, audioPath) || other.audioPath == audioPath)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.tip, tip) || other.tip == tip)&&const DeepCollectionEquality().equals(other._segments, _segments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,text,meaning,audioPath,durationSeconds,tip,const DeepCollectionEquality().hash(_segments));

@override
String toString() {
  return 'ShadowingContent(id: $id, title: $title, text: $text, meaning: $meaning, audioPath: $audioPath, durationSeconds: $durationSeconds, tip: $tip, segments: $segments)';
}


}

/// @nodoc
abstract mixin class _$ShadowingContentCopyWith<$Res> implements $ShadowingContentCopyWith<$Res> {
  factory _$ShadowingContentCopyWith(_ShadowingContent value, $Res Function(_ShadowingContent) _then) = __$ShadowingContentCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String text, String meaning, String audioPath, int durationSeconds, String? tip, List<TextSegment> segments
});




}
/// @nodoc
class __$ShadowingContentCopyWithImpl<$Res>
    implements _$ShadowingContentCopyWith<$Res> {
  __$ShadowingContentCopyWithImpl(this._self, this._then);

  final _ShadowingContent _self;
  final $Res Function(_ShadowingContent) _then;

/// Create a copy of ShadowingContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? text = null,Object? meaning = null,Object? audioPath = null,Object? durationSeconds = null,Object? tip = freezed,Object? segments = null,}) {
  return _then(_ShadowingContent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,audioPath: null == audioPath ? _self.audioPath : audioPath // ignore: cast_nullable_to_non_nullable
as String,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,tip: freezed == tip ? _self.tip : tip // ignore: cast_nullable_to_non_nullable
as String?,segments: null == segments ? _self._segments : segments // ignore: cast_nullable_to_non_nullable
as List<TextSegment>,
  ));
}


}


/// @nodoc
mixin _$ShadowingDataFile {

 String get version; String get level; List<ShadowingContent> get contents;
/// Create a copy of ShadowingDataFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShadowingDataFileCopyWith<ShadowingDataFile> get copyWith => _$ShadowingDataFileCopyWithImpl<ShadowingDataFile>(this as ShadowingDataFile, _$identity);

  /// Serializes this ShadowingDataFile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShadowingDataFile&&(identical(other.version, version) || other.version == version)&&(identical(other.level, level) || other.level == level)&&const DeepCollectionEquality().equals(other.contents, contents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,level,const DeepCollectionEquality().hash(contents));

@override
String toString() {
  return 'ShadowingDataFile(version: $version, level: $level, contents: $contents)';
}


}

/// @nodoc
abstract mixin class $ShadowingDataFileCopyWith<$Res>  {
  factory $ShadowingDataFileCopyWith(ShadowingDataFile value, $Res Function(ShadowingDataFile) _then) = _$ShadowingDataFileCopyWithImpl;
@useResult
$Res call({
 String version, String level, List<ShadowingContent> contents
});




}
/// @nodoc
class _$ShadowingDataFileCopyWithImpl<$Res>
    implements $ShadowingDataFileCopyWith<$Res> {
  _$ShadowingDataFileCopyWithImpl(this._self, this._then);

  final ShadowingDataFile _self;
  final $Res Function(ShadowingDataFile) _then;

/// Create a copy of ShadowingDataFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? level = null,Object? contents = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,contents: null == contents ? _self.contents : contents // ignore: cast_nullable_to_non_nullable
as List<ShadowingContent>,
  ));
}

}


/// Adds pattern-matching-related methods to [ShadowingDataFile].
extension ShadowingDataFilePatterns on ShadowingDataFile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShadowingDataFile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShadowingDataFile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShadowingDataFile value)  $default,){
final _that = this;
switch (_that) {
case _ShadowingDataFile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShadowingDataFile value)?  $default,){
final _that = this;
switch (_that) {
case _ShadowingDataFile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  String level,  List<ShadowingContent> contents)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShadowingDataFile() when $default != null:
return $default(_that.version,_that.level,_that.contents);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  String level,  List<ShadowingContent> contents)  $default,) {final _that = this;
switch (_that) {
case _ShadowingDataFile():
return $default(_that.version,_that.level,_that.contents);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  String level,  List<ShadowingContent> contents)?  $default,) {final _that = this;
switch (_that) {
case _ShadowingDataFile() when $default != null:
return $default(_that.version,_that.level,_that.contents);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShadowingDataFile implements ShadowingDataFile {
  const _ShadowingDataFile({required this.version, required this.level, final  List<ShadowingContent> contents = const <ShadowingContent>[]}): _contents = contents;
  factory _ShadowingDataFile.fromJson(Map<String, dynamic> json) => _$ShadowingDataFileFromJson(json);

@override final  String version;
@override final  String level;
 final  List<ShadowingContent> _contents;
@override@JsonKey() List<ShadowingContent> get contents {
  if (_contents is EqualUnmodifiableListView) return _contents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contents);
}


/// Create a copy of ShadowingDataFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShadowingDataFileCopyWith<_ShadowingDataFile> get copyWith => __$ShadowingDataFileCopyWithImpl<_ShadowingDataFile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShadowingDataFileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShadowingDataFile&&(identical(other.version, version) || other.version == version)&&(identical(other.level, level) || other.level == level)&&const DeepCollectionEquality().equals(other._contents, _contents));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,level,const DeepCollectionEquality().hash(_contents));

@override
String toString() {
  return 'ShadowingDataFile(version: $version, level: $level, contents: $contents)';
}


}

/// @nodoc
abstract mixin class _$ShadowingDataFileCopyWith<$Res> implements $ShadowingDataFileCopyWith<$Res> {
  factory _$ShadowingDataFileCopyWith(_ShadowingDataFile value, $Res Function(_ShadowingDataFile) _then) = __$ShadowingDataFileCopyWithImpl;
@override @useResult
$Res call({
 String version, String level, List<ShadowingContent> contents
});




}
/// @nodoc
class __$ShadowingDataFileCopyWithImpl<$Res>
    implements _$ShadowingDataFileCopyWith<$Res> {
  __$ShadowingDataFileCopyWithImpl(this._self, this._then);

  final _ShadowingDataFile _self;
  final $Res Function(_ShadowingDataFile) _then;

/// Create a copy of ShadowingDataFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? level = null,Object? contents = null,}) {
  return _then(_ShadowingDataFile(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,contents: null == contents ? _self._contents : contents // ignore: cast_nullable_to_non_nullable
as List<ShadowingContent>,
  ));
}


}


/// @nodoc
mixin _$ShadowingProgress {

 String get contentId; int get practiceCount; DateTime? get lastPracticed;
/// Create a copy of ShadowingProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShadowingProgressCopyWith<ShadowingProgress> get copyWith => _$ShadowingProgressCopyWithImpl<ShadowingProgress>(this as ShadowingProgress, _$identity);

  /// Serializes this ShadowingProgress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShadowingProgress&&(identical(other.contentId, contentId) || other.contentId == contentId)&&(identical(other.practiceCount, practiceCount) || other.practiceCount == practiceCount)&&(identical(other.lastPracticed, lastPracticed) || other.lastPracticed == lastPracticed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contentId,practiceCount,lastPracticed);

@override
String toString() {
  return 'ShadowingProgress(contentId: $contentId, practiceCount: $practiceCount, lastPracticed: $lastPracticed)';
}


}

/// @nodoc
abstract mixin class $ShadowingProgressCopyWith<$Res>  {
  factory $ShadowingProgressCopyWith(ShadowingProgress value, $Res Function(ShadowingProgress) _then) = _$ShadowingProgressCopyWithImpl;
@useResult
$Res call({
 String contentId, int practiceCount, DateTime? lastPracticed
});




}
/// @nodoc
class _$ShadowingProgressCopyWithImpl<$Res>
    implements $ShadowingProgressCopyWith<$Res> {
  _$ShadowingProgressCopyWithImpl(this._self, this._then);

  final ShadowingProgress _self;
  final $Res Function(ShadowingProgress) _then;

/// Create a copy of ShadowingProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contentId = null,Object? practiceCount = null,Object? lastPracticed = freezed,}) {
  return _then(_self.copyWith(
contentId: null == contentId ? _self.contentId : contentId // ignore: cast_nullable_to_non_nullable
as String,practiceCount: null == practiceCount ? _self.practiceCount : practiceCount // ignore: cast_nullable_to_non_nullable
as int,lastPracticed: freezed == lastPracticed ? _self.lastPracticed : lastPracticed // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ShadowingProgress].
extension ShadowingProgressPatterns on ShadowingProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShadowingProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShadowingProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShadowingProgress value)  $default,){
final _that = this;
switch (_that) {
case _ShadowingProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShadowingProgress value)?  $default,){
final _that = this;
switch (_that) {
case _ShadowingProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String contentId,  int practiceCount,  DateTime? lastPracticed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShadowingProgress() when $default != null:
return $default(_that.contentId,_that.practiceCount,_that.lastPracticed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String contentId,  int practiceCount,  DateTime? lastPracticed)  $default,) {final _that = this;
switch (_that) {
case _ShadowingProgress():
return $default(_that.contentId,_that.practiceCount,_that.lastPracticed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String contentId,  int practiceCount,  DateTime? lastPracticed)?  $default,) {final _that = this;
switch (_that) {
case _ShadowingProgress() when $default != null:
return $default(_that.contentId,_that.practiceCount,_that.lastPracticed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShadowingProgress extends ShadowingProgress {
  const _ShadowingProgress({required this.contentId, this.practiceCount = 0, this.lastPracticed}): super._();
  factory _ShadowingProgress.fromJson(Map<String, dynamic> json) => _$ShadowingProgressFromJson(json);

@override final  String contentId;
@override@JsonKey() final  int practiceCount;
@override final  DateTime? lastPracticed;

/// Create a copy of ShadowingProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShadowingProgressCopyWith<_ShadowingProgress> get copyWith => __$ShadowingProgressCopyWithImpl<_ShadowingProgress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShadowingProgressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShadowingProgress&&(identical(other.contentId, contentId) || other.contentId == contentId)&&(identical(other.practiceCount, practiceCount) || other.practiceCount == practiceCount)&&(identical(other.lastPracticed, lastPracticed) || other.lastPracticed == lastPracticed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contentId,practiceCount,lastPracticed);

@override
String toString() {
  return 'ShadowingProgress(contentId: $contentId, practiceCount: $practiceCount, lastPracticed: $lastPracticed)';
}


}

/// @nodoc
abstract mixin class _$ShadowingProgressCopyWith<$Res> implements $ShadowingProgressCopyWith<$Res> {
  factory _$ShadowingProgressCopyWith(_ShadowingProgress value, $Res Function(_ShadowingProgress) _then) = __$ShadowingProgressCopyWithImpl;
@override @useResult
$Res call({
 String contentId, int practiceCount, DateTime? lastPracticed
});




}
/// @nodoc
class __$ShadowingProgressCopyWithImpl<$Res>
    implements _$ShadowingProgressCopyWith<$Res> {
  __$ShadowingProgressCopyWithImpl(this._self, this._then);

  final _ShadowingProgress _self;
  final $Res Function(_ShadowingProgress) _then;

/// Create a copy of ShadowingProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contentId = null,Object? practiceCount = null,Object? lastPracticed = freezed,}) {
  return _then(_ShadowingProgress(
contentId: null == contentId ? _self.contentId : contentId // ignore: cast_nullable_to_non_nullable
as String,practiceCount: null == practiceCount ? _self.practiceCount : practiceCount // ignore: cast_nullable_to_non_nullable
as int,lastPracticed: freezed == lastPracticed ? _self.lastPracticed : lastPracticed // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$ShadowingLevelStats {

 ShadowingLevel get level; int get totalCount; int get masteredCount; int get practicedCount;
/// Create a copy of ShadowingLevelStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShadowingLevelStatsCopyWith<ShadowingLevelStats> get copyWith => _$ShadowingLevelStatsCopyWithImpl<ShadowingLevelStats>(this as ShadowingLevelStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShadowingLevelStats&&(identical(other.level, level) || other.level == level)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.masteredCount, masteredCount) || other.masteredCount == masteredCount)&&(identical(other.practicedCount, practicedCount) || other.practicedCount == practicedCount));
}


@override
int get hashCode => Object.hash(runtimeType,level,totalCount,masteredCount,practicedCount);

@override
String toString() {
  return 'ShadowingLevelStats(level: $level, totalCount: $totalCount, masteredCount: $masteredCount, practicedCount: $practicedCount)';
}


}

/// @nodoc
abstract mixin class $ShadowingLevelStatsCopyWith<$Res>  {
  factory $ShadowingLevelStatsCopyWith(ShadowingLevelStats value, $Res Function(ShadowingLevelStats) _then) = _$ShadowingLevelStatsCopyWithImpl;
@useResult
$Res call({
 ShadowingLevel level, int totalCount, int masteredCount, int practicedCount
});




}
/// @nodoc
class _$ShadowingLevelStatsCopyWithImpl<$Res>
    implements $ShadowingLevelStatsCopyWith<$Res> {
  _$ShadowingLevelStatsCopyWithImpl(this._self, this._then);

  final ShadowingLevelStats _self;
  final $Res Function(ShadowingLevelStats) _then;

/// Create a copy of ShadowingLevelStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? totalCount = null,Object? masteredCount = null,Object? practicedCount = null,}) {
  return _then(_self.copyWith(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as ShadowingLevel,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,masteredCount: null == masteredCount ? _self.masteredCount : masteredCount // ignore: cast_nullable_to_non_nullable
as int,practicedCount: null == practicedCount ? _self.practicedCount : practicedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ShadowingLevelStats].
extension ShadowingLevelStatsPatterns on ShadowingLevelStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShadowingLevelStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShadowingLevelStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShadowingLevelStats value)  $default,){
final _that = this;
switch (_that) {
case _ShadowingLevelStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShadowingLevelStats value)?  $default,){
final _that = this;
switch (_that) {
case _ShadowingLevelStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ShadowingLevel level,  int totalCount,  int masteredCount,  int practicedCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShadowingLevelStats() when $default != null:
return $default(_that.level,_that.totalCount,_that.masteredCount,_that.practicedCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ShadowingLevel level,  int totalCount,  int masteredCount,  int practicedCount)  $default,) {final _that = this;
switch (_that) {
case _ShadowingLevelStats():
return $default(_that.level,_that.totalCount,_that.masteredCount,_that.practicedCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ShadowingLevel level,  int totalCount,  int masteredCount,  int practicedCount)?  $default,) {final _that = this;
switch (_that) {
case _ShadowingLevelStats() when $default != null:
return $default(_that.level,_that.totalCount,_that.masteredCount,_that.practicedCount);case _:
  return null;

}
}

}

/// @nodoc


class _ShadowingLevelStats implements ShadowingLevelStats {
  const _ShadowingLevelStats({required this.level, required this.totalCount, this.masteredCount = 0, this.practicedCount = 0});
  

@override final  ShadowingLevel level;
@override final  int totalCount;
@override@JsonKey() final  int masteredCount;
@override@JsonKey() final  int practicedCount;

/// Create a copy of ShadowingLevelStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShadowingLevelStatsCopyWith<_ShadowingLevelStats> get copyWith => __$ShadowingLevelStatsCopyWithImpl<_ShadowingLevelStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShadowingLevelStats&&(identical(other.level, level) || other.level == level)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.masteredCount, masteredCount) || other.masteredCount == masteredCount)&&(identical(other.practicedCount, practicedCount) || other.practicedCount == practicedCount));
}


@override
int get hashCode => Object.hash(runtimeType,level,totalCount,masteredCount,practicedCount);

@override
String toString() {
  return 'ShadowingLevelStats(level: $level, totalCount: $totalCount, masteredCount: $masteredCount, practicedCount: $practicedCount)';
}


}

/// @nodoc
abstract mixin class _$ShadowingLevelStatsCopyWith<$Res> implements $ShadowingLevelStatsCopyWith<$Res> {
  factory _$ShadowingLevelStatsCopyWith(_ShadowingLevelStats value, $Res Function(_ShadowingLevelStats) _then) = __$ShadowingLevelStatsCopyWithImpl;
@override @useResult
$Res call({
 ShadowingLevel level, int totalCount, int masteredCount, int practicedCount
});




}
/// @nodoc
class __$ShadowingLevelStatsCopyWithImpl<$Res>
    implements _$ShadowingLevelStatsCopyWith<$Res> {
  __$ShadowingLevelStatsCopyWithImpl(this._self, this._then);

  final _ShadowingLevelStats _self;
  final $Res Function(_ShadowingLevelStats) _then;

/// Create a copy of ShadowingLevelStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? totalCount = null,Object? masteredCount = null,Object? practicedCount = null,}) {
  return _then(_ShadowingLevelStats(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as ShadowingLevel,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,masteredCount: null == masteredCount ? _self.masteredCount : masteredCount // ignore: cast_nullable_to_non_nullable
as int,practicedCount: null == practicedCount ? _self.practicedCount : practicedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ShadowingSessionState {

 ShadowingContent get content; bool get isPlaying; PlaybackSpeed get playbackSpeed; Duration get currentPosition; Duration get totalDuration; int get currentSegmentIndex; bool get showMeaning;/// リピートモードの対象セグメントインデックス（-1 = リピートなし）
 int get repeatSegmentIndex;
/// Create a copy of ShadowingSessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShadowingSessionStateCopyWith<ShadowingSessionState> get copyWith => _$ShadowingSessionStateCopyWithImpl<ShadowingSessionState>(this as ShadowingSessionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShadowingSessionState&&(identical(other.content, content) || other.content == content)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.playbackSpeed, playbackSpeed) || other.playbackSpeed == playbackSpeed)&&(identical(other.currentPosition, currentPosition) || other.currentPosition == currentPosition)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration)&&(identical(other.currentSegmentIndex, currentSegmentIndex) || other.currentSegmentIndex == currentSegmentIndex)&&(identical(other.showMeaning, showMeaning) || other.showMeaning == showMeaning)&&(identical(other.repeatSegmentIndex, repeatSegmentIndex) || other.repeatSegmentIndex == repeatSegmentIndex));
}


@override
int get hashCode => Object.hash(runtimeType,content,isPlaying,playbackSpeed,currentPosition,totalDuration,currentSegmentIndex,showMeaning,repeatSegmentIndex);

@override
String toString() {
  return 'ShadowingSessionState(content: $content, isPlaying: $isPlaying, playbackSpeed: $playbackSpeed, currentPosition: $currentPosition, totalDuration: $totalDuration, currentSegmentIndex: $currentSegmentIndex, showMeaning: $showMeaning, repeatSegmentIndex: $repeatSegmentIndex)';
}


}

/// @nodoc
abstract mixin class $ShadowingSessionStateCopyWith<$Res>  {
  factory $ShadowingSessionStateCopyWith(ShadowingSessionState value, $Res Function(ShadowingSessionState) _then) = _$ShadowingSessionStateCopyWithImpl;
@useResult
$Res call({
 ShadowingContent content, bool isPlaying, PlaybackSpeed playbackSpeed, Duration currentPosition, Duration totalDuration, int currentSegmentIndex, bool showMeaning, int repeatSegmentIndex
});


$ShadowingContentCopyWith<$Res> get content;

}
/// @nodoc
class _$ShadowingSessionStateCopyWithImpl<$Res>
    implements $ShadowingSessionStateCopyWith<$Res> {
  _$ShadowingSessionStateCopyWithImpl(this._self, this._then);

  final ShadowingSessionState _self;
  final $Res Function(ShadowingSessionState) _then;

/// Create a copy of ShadowingSessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? isPlaying = null,Object? playbackSpeed = null,Object? currentPosition = null,Object? totalDuration = null,Object? currentSegmentIndex = null,Object? showMeaning = null,Object? repeatSegmentIndex = null,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as ShadowingContent,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,playbackSpeed: null == playbackSpeed ? _self.playbackSpeed : playbackSpeed // ignore: cast_nullable_to_non_nullable
as PlaybackSpeed,currentPosition: null == currentPosition ? _self.currentPosition : currentPosition // ignore: cast_nullable_to_non_nullable
as Duration,totalDuration: null == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as Duration,currentSegmentIndex: null == currentSegmentIndex ? _self.currentSegmentIndex : currentSegmentIndex // ignore: cast_nullable_to_non_nullable
as int,showMeaning: null == showMeaning ? _self.showMeaning : showMeaning // ignore: cast_nullable_to_non_nullable
as bool,repeatSegmentIndex: null == repeatSegmentIndex ? _self.repeatSegmentIndex : repeatSegmentIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ShadowingSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShadowingContentCopyWith<$Res> get content {
  
  return $ShadowingContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [ShadowingSessionState].
extension ShadowingSessionStatePatterns on ShadowingSessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShadowingSessionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShadowingSessionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShadowingSessionState value)  $default,){
final _that = this;
switch (_that) {
case _ShadowingSessionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShadowingSessionState value)?  $default,){
final _that = this;
switch (_that) {
case _ShadowingSessionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ShadowingContent content,  bool isPlaying,  PlaybackSpeed playbackSpeed,  Duration currentPosition,  Duration totalDuration,  int currentSegmentIndex,  bool showMeaning,  int repeatSegmentIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShadowingSessionState() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ShadowingContent content,  bool isPlaying,  PlaybackSpeed playbackSpeed,  Duration currentPosition,  Duration totalDuration,  int currentSegmentIndex,  bool showMeaning,  int repeatSegmentIndex)  $default,) {final _that = this;
switch (_that) {
case _ShadowingSessionState():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ShadowingContent content,  bool isPlaying,  PlaybackSpeed playbackSpeed,  Duration currentPosition,  Duration totalDuration,  int currentSegmentIndex,  bool showMeaning,  int repeatSegmentIndex)?  $default,) {final _that = this;
switch (_that) {
case _ShadowingSessionState() when $default != null:
return $default(_that.content,_that.isPlaying,_that.playbackSpeed,_that.currentPosition,_that.totalDuration,_that.currentSegmentIndex,_that.showMeaning,_that.repeatSegmentIndex);case _:
  return null;

}
}

}

/// @nodoc


class _ShadowingSessionState extends ShadowingSessionState {
  const _ShadowingSessionState({required this.content, this.isPlaying = false, this.playbackSpeed = PlaybackSpeed.x1_0, this.currentPosition = Duration.zero, this.totalDuration = Duration.zero, this.currentSegmentIndex = -1, this.showMeaning = true, this.repeatSegmentIndex = -1}): super._();
  

@override final  ShadowingContent content;
@override@JsonKey() final  bool isPlaying;
@override@JsonKey() final  PlaybackSpeed playbackSpeed;
@override@JsonKey() final  Duration currentPosition;
@override@JsonKey() final  Duration totalDuration;
@override@JsonKey() final  int currentSegmentIndex;
@override@JsonKey() final  bool showMeaning;
/// リピートモードの対象セグメントインデックス（-1 = リピートなし）
@override@JsonKey() final  int repeatSegmentIndex;

/// Create a copy of ShadowingSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShadowingSessionStateCopyWith<_ShadowingSessionState> get copyWith => __$ShadowingSessionStateCopyWithImpl<_ShadowingSessionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShadowingSessionState&&(identical(other.content, content) || other.content == content)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.playbackSpeed, playbackSpeed) || other.playbackSpeed == playbackSpeed)&&(identical(other.currentPosition, currentPosition) || other.currentPosition == currentPosition)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration)&&(identical(other.currentSegmentIndex, currentSegmentIndex) || other.currentSegmentIndex == currentSegmentIndex)&&(identical(other.showMeaning, showMeaning) || other.showMeaning == showMeaning)&&(identical(other.repeatSegmentIndex, repeatSegmentIndex) || other.repeatSegmentIndex == repeatSegmentIndex));
}


@override
int get hashCode => Object.hash(runtimeType,content,isPlaying,playbackSpeed,currentPosition,totalDuration,currentSegmentIndex,showMeaning,repeatSegmentIndex);

@override
String toString() {
  return 'ShadowingSessionState(content: $content, isPlaying: $isPlaying, playbackSpeed: $playbackSpeed, currentPosition: $currentPosition, totalDuration: $totalDuration, currentSegmentIndex: $currentSegmentIndex, showMeaning: $showMeaning, repeatSegmentIndex: $repeatSegmentIndex)';
}


}

/// @nodoc
abstract mixin class _$ShadowingSessionStateCopyWith<$Res> implements $ShadowingSessionStateCopyWith<$Res> {
  factory _$ShadowingSessionStateCopyWith(_ShadowingSessionState value, $Res Function(_ShadowingSessionState) _then) = __$ShadowingSessionStateCopyWithImpl;
@override @useResult
$Res call({
 ShadowingContent content, bool isPlaying, PlaybackSpeed playbackSpeed, Duration currentPosition, Duration totalDuration, int currentSegmentIndex, bool showMeaning, int repeatSegmentIndex
});


@override $ShadowingContentCopyWith<$Res> get content;

}
/// @nodoc
class __$ShadowingSessionStateCopyWithImpl<$Res>
    implements _$ShadowingSessionStateCopyWith<$Res> {
  __$ShadowingSessionStateCopyWithImpl(this._self, this._then);

  final _ShadowingSessionState _self;
  final $Res Function(_ShadowingSessionState) _then;

/// Create a copy of ShadowingSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? isPlaying = null,Object? playbackSpeed = null,Object? currentPosition = null,Object? totalDuration = null,Object? currentSegmentIndex = null,Object? showMeaning = null,Object? repeatSegmentIndex = null,}) {
  return _then(_ShadowingSessionState(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as ShadowingContent,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,playbackSpeed: null == playbackSpeed ? _self.playbackSpeed : playbackSpeed // ignore: cast_nullable_to_non_nullable
as PlaybackSpeed,currentPosition: null == currentPosition ? _self.currentPosition : currentPosition // ignore: cast_nullable_to_non_nullable
as Duration,totalDuration: null == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as Duration,currentSegmentIndex: null == currentSegmentIndex ? _self.currentSegmentIndex : currentSegmentIndex // ignore: cast_nullable_to_non_nullable
as int,showMeaning: null == showMeaning ? _self.showMeaning : showMeaning // ignore: cast_nullable_to_non_nullable
as bool,repeatSegmentIndex: null == repeatSegmentIndex ? _self.repeatSegmentIndex : repeatSegmentIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ShadowingSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ShadowingContentCopyWith<$Res> get content {
  
  return $ShadowingContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}

// dart format on
