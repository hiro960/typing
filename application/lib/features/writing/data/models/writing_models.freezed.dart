// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'writing_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WritingEntry {

 String get id; EntryLevel get level; String get jpText; String get koText;
/// Create a copy of WritingEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WritingEntryCopyWith<WritingEntry> get copyWith => _$WritingEntryCopyWithImpl<WritingEntry>(this as WritingEntry, _$identity);

  /// Serializes this WritingEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WritingEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.level, level) || other.level == level)&&(identical(other.jpText, jpText) || other.jpText == jpText)&&(identical(other.koText, koText) || other.koText == koText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,level,jpText,koText);

@override
String toString() {
  return 'WritingEntry(id: $id, level: $level, jpText: $jpText, koText: $koText)';
}


}

/// @nodoc
abstract mixin class $WritingEntryCopyWith<$Res>  {
  factory $WritingEntryCopyWith(WritingEntry value, $Res Function(WritingEntry) _then) = _$WritingEntryCopyWithImpl;
@useResult
$Res call({
 String id, EntryLevel level, String jpText, String koText
});




}
/// @nodoc
class _$WritingEntryCopyWithImpl<$Res>
    implements $WritingEntryCopyWith<$Res> {
  _$WritingEntryCopyWithImpl(this._self, this._then);

  final WritingEntry _self;
  final $Res Function(WritingEntry) _then;

/// Create a copy of WritingEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? level = null,Object? jpText = null,Object? koText = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as EntryLevel,jpText: null == jpText ? _self.jpText : jpText // ignore: cast_nullable_to_non_nullable
as String,koText: null == koText ? _self.koText : koText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WritingEntry].
extension WritingEntryPatterns on WritingEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WritingEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WritingEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WritingEntry value)  $default,){
final _that = this;
switch (_that) {
case _WritingEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WritingEntry value)?  $default,){
final _that = this;
switch (_that) {
case _WritingEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  EntryLevel level,  String jpText,  String koText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WritingEntry() when $default != null:
return $default(_that.id,_that.level,_that.jpText,_that.koText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  EntryLevel level,  String jpText,  String koText)  $default,) {final _that = this;
switch (_that) {
case _WritingEntry():
return $default(_that.id,_that.level,_that.jpText,_that.koText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  EntryLevel level,  String jpText,  String koText)?  $default,) {final _that = this;
switch (_that) {
case _WritingEntry() when $default != null:
return $default(_that.id,_that.level,_that.jpText,_that.koText);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WritingEntry implements WritingEntry {
  const _WritingEntry({required this.id, required this.level, required this.jpText, required this.koText});
  factory _WritingEntry.fromJson(Map<String, dynamic> json) => _$WritingEntryFromJson(json);

@override final  String id;
@override final  EntryLevel level;
@override final  String jpText;
@override final  String koText;

/// Create a copy of WritingEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WritingEntryCopyWith<_WritingEntry> get copyWith => __$WritingEntryCopyWithImpl<_WritingEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WritingEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WritingEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.level, level) || other.level == level)&&(identical(other.jpText, jpText) || other.jpText == jpText)&&(identical(other.koText, koText) || other.koText == koText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,level,jpText,koText);

@override
String toString() {
  return 'WritingEntry(id: $id, level: $level, jpText: $jpText, koText: $koText)';
}


}

/// @nodoc
abstract mixin class _$WritingEntryCopyWith<$Res> implements $WritingEntryCopyWith<$Res> {
  factory _$WritingEntryCopyWith(_WritingEntry value, $Res Function(_WritingEntry) _then) = __$WritingEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, EntryLevel level, String jpText, String koText
});




}
/// @nodoc
class __$WritingEntryCopyWithImpl<$Res>
    implements _$WritingEntryCopyWith<$Res> {
  __$WritingEntryCopyWithImpl(this._self, this._then);

  final _WritingEntry _self;
  final $Res Function(_WritingEntry) _then;

/// Create a copy of WritingEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? level = null,Object? jpText = null,Object? koText = null,}) {
  return _then(_WritingEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as EntryLevel,jpText: null == jpText ? _self.jpText : jpText // ignore: cast_nullable_to_non_nullable
as String,koText: null == koText ? _self.koText : koText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$WritingTopic {

 String get id; String get name; String get description; String get patternId; List<WritingEntry> get entries;
/// Create a copy of WritingTopic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WritingTopicCopyWith<WritingTopic> get copyWith => _$WritingTopicCopyWithImpl<WritingTopic>(this as WritingTopic, _$identity);

  /// Serializes this WritingTopic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WritingTopic&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.patternId, patternId) || other.patternId == patternId)&&const DeepCollectionEquality().equals(other.entries, entries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,patternId,const DeepCollectionEquality().hash(entries));

@override
String toString() {
  return 'WritingTopic(id: $id, name: $name, description: $description, patternId: $patternId, entries: $entries)';
}


}

/// @nodoc
abstract mixin class $WritingTopicCopyWith<$Res>  {
  factory $WritingTopicCopyWith(WritingTopic value, $Res Function(WritingTopic) _then) = _$WritingTopicCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, String patternId, List<WritingEntry> entries
});




}
/// @nodoc
class _$WritingTopicCopyWithImpl<$Res>
    implements $WritingTopicCopyWith<$Res> {
  _$WritingTopicCopyWithImpl(this._self, this._then);

  final WritingTopic _self;
  final $Res Function(WritingTopic) _then;

/// Create a copy of WritingTopic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? patternId = null,Object? entries = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,patternId: null == patternId ? _self.patternId : patternId // ignore: cast_nullable_to_non_nullable
as String,entries: null == entries ? _self.entries : entries // ignore: cast_nullable_to_non_nullable
as List<WritingEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [WritingTopic].
extension WritingTopicPatterns on WritingTopic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WritingTopic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WritingTopic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WritingTopic value)  $default,){
final _that = this;
switch (_that) {
case _WritingTopic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WritingTopic value)?  $default,){
final _that = this;
switch (_that) {
case _WritingTopic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String patternId,  List<WritingEntry> entries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WritingTopic() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.patternId,_that.entries);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String patternId,  List<WritingEntry> entries)  $default,) {final _that = this;
switch (_that) {
case _WritingTopic():
return $default(_that.id,_that.name,_that.description,_that.patternId,_that.entries);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  String patternId,  List<WritingEntry> entries)?  $default,) {final _that = this;
switch (_that) {
case _WritingTopic() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.patternId,_that.entries);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WritingTopic implements WritingTopic {
  const _WritingTopic({required this.id, required this.name, required this.description, required this.patternId, required final  List<WritingEntry> entries}): _entries = entries;
  factory _WritingTopic.fromJson(Map<String, dynamic> json) => _$WritingTopicFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
@override final  String patternId;
 final  List<WritingEntry> _entries;
@override List<WritingEntry> get entries {
  if (_entries is EqualUnmodifiableListView) return _entries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_entries);
}


/// Create a copy of WritingTopic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WritingTopicCopyWith<_WritingTopic> get copyWith => __$WritingTopicCopyWithImpl<_WritingTopic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WritingTopicToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WritingTopic&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.patternId, patternId) || other.patternId == patternId)&&const DeepCollectionEquality().equals(other._entries, _entries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,patternId,const DeepCollectionEquality().hash(_entries));

@override
String toString() {
  return 'WritingTopic(id: $id, name: $name, description: $description, patternId: $patternId, entries: $entries)';
}


}

/// @nodoc
abstract mixin class _$WritingTopicCopyWith<$Res> implements $WritingTopicCopyWith<$Res> {
  factory _$WritingTopicCopyWith(_WritingTopic value, $Res Function(_WritingTopic) _then) = __$WritingTopicCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, String patternId, List<WritingEntry> entries
});




}
/// @nodoc
class __$WritingTopicCopyWithImpl<$Res>
    implements _$WritingTopicCopyWith<$Res> {
  __$WritingTopicCopyWithImpl(this._self, this._then);

  final _WritingTopic _self;
  final $Res Function(_WritingTopic) _then;

/// Create a copy of WritingTopic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? patternId = null,Object? entries = null,}) {
  return _then(_WritingTopic(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,patternId: null == patternId ? _self.patternId : patternId // ignore: cast_nullable_to_non_nullable
as String,entries: null == entries ? _self._entries : entries // ignore: cast_nullable_to_non_nullable
as List<WritingEntry>,
  ));
}


}


/// @nodoc
mixin _$WritingPattern {

 String get id; String get name; String get description; String get icon; List<WritingTopic> get topics;
/// Create a copy of WritingPattern
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WritingPatternCopyWith<WritingPattern> get copyWith => _$WritingPatternCopyWithImpl<WritingPattern>(this as WritingPattern, _$identity);

  /// Serializes this WritingPattern to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WritingPattern&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other.topics, topics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,icon,const DeepCollectionEquality().hash(topics));

@override
String toString() {
  return 'WritingPattern(id: $id, name: $name, description: $description, icon: $icon, topics: $topics)';
}


}

/// @nodoc
abstract mixin class $WritingPatternCopyWith<$Res>  {
  factory $WritingPatternCopyWith(WritingPattern value, $Res Function(WritingPattern) _then) = _$WritingPatternCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, String icon, List<WritingTopic> topics
});




}
/// @nodoc
class _$WritingPatternCopyWithImpl<$Res>
    implements $WritingPatternCopyWith<$Res> {
  _$WritingPatternCopyWithImpl(this._self, this._then);

  final WritingPattern _self;
  final $Res Function(WritingPattern) _then;

/// Create a copy of WritingPattern
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? icon = null,Object? topics = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,topics: null == topics ? _self.topics : topics // ignore: cast_nullable_to_non_nullable
as List<WritingTopic>,
  ));
}

}


/// Adds pattern-matching-related methods to [WritingPattern].
extension WritingPatternPatterns on WritingPattern {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WritingPattern value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WritingPattern() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WritingPattern value)  $default,){
final _that = this;
switch (_that) {
case _WritingPattern():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WritingPattern value)?  $default,){
final _that = this;
switch (_that) {
case _WritingPattern() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String icon,  List<WritingTopic> topics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WritingPattern() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.icon,_that.topics);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String icon,  List<WritingTopic> topics)  $default,) {final _that = this;
switch (_that) {
case _WritingPattern():
return $default(_that.id,_that.name,_that.description,_that.icon,_that.topics);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  String icon,  List<WritingTopic> topics)?  $default,) {final _that = this;
switch (_that) {
case _WritingPattern() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.icon,_that.topics);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WritingPattern implements WritingPattern {
  const _WritingPattern({required this.id, required this.name, required this.description, required this.icon, required final  List<WritingTopic> topics}): _topics = topics;
  factory _WritingPattern.fromJson(Map<String, dynamic> json) => _$WritingPatternFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
@override final  String icon;
 final  List<WritingTopic> _topics;
@override List<WritingTopic> get topics {
  if (_topics is EqualUnmodifiableListView) return _topics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topics);
}


/// Create a copy of WritingPattern
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WritingPatternCopyWith<_WritingPattern> get copyWith => __$WritingPatternCopyWithImpl<_WritingPattern>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WritingPatternToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WritingPattern&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other._topics, _topics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,icon,const DeepCollectionEquality().hash(_topics));

@override
String toString() {
  return 'WritingPattern(id: $id, name: $name, description: $description, icon: $icon, topics: $topics)';
}


}

/// @nodoc
abstract mixin class _$WritingPatternCopyWith<$Res> implements $WritingPatternCopyWith<$Res> {
  factory _$WritingPatternCopyWith(_WritingPattern value, $Res Function(_WritingPattern) _then) = __$WritingPatternCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, String icon, List<WritingTopic> topics
});




}
/// @nodoc
class __$WritingPatternCopyWithImpl<$Res>
    implements _$WritingPatternCopyWith<$Res> {
  __$WritingPatternCopyWithImpl(this._self, this._then);

  final _WritingPattern _self;
  final $Res Function(_WritingPattern) _then;

/// Create a copy of WritingPattern
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? icon = null,Object? topics = null,}) {
  return _then(_WritingPattern(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,topics: null == topics ? _self._topics : topics // ignore: cast_nullable_to_non_nullable
as List<WritingTopic>,
  ));
}


}


/// @nodoc
mixin _$EntryResult {

 String get entryId; bool get correct; DateTime get timestamp;
/// Create a copy of EntryResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EntryResultCopyWith<EntryResult> get copyWith => _$EntryResultCopyWithImpl<EntryResult>(this as EntryResult, _$identity);

  /// Serializes this EntryResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EntryResult&&(identical(other.entryId, entryId) || other.entryId == entryId)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entryId,correct,timestamp);

@override
String toString() {
  return 'EntryResult(entryId: $entryId, correct: $correct, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $EntryResultCopyWith<$Res>  {
  factory $EntryResultCopyWith(EntryResult value, $Res Function(EntryResult) _then) = _$EntryResultCopyWithImpl;
@useResult
$Res call({
 String entryId, bool correct, DateTime timestamp
});




}
/// @nodoc
class _$EntryResultCopyWithImpl<$Res>
    implements $EntryResultCopyWith<$Res> {
  _$EntryResultCopyWithImpl(this._self, this._then);

  final EntryResult _self;
  final $Res Function(EntryResult) _then;

/// Create a copy of EntryResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entryId = null,Object? correct = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
entryId: null == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as String,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [EntryResult].
extension EntryResultPatterns on EntryResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EntryResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EntryResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EntryResult value)  $default,){
final _that = this;
switch (_that) {
case _EntryResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EntryResult value)?  $default,){
final _that = this;
switch (_that) {
case _EntryResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String entryId,  bool correct,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EntryResult() when $default != null:
return $default(_that.entryId,_that.correct,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String entryId,  bool correct,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _EntryResult():
return $default(_that.entryId,_that.correct,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String entryId,  bool correct,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _EntryResult() when $default != null:
return $default(_that.entryId,_that.correct,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EntryResult implements EntryResult {
  const _EntryResult({required this.entryId, required this.correct, required this.timestamp});
  factory _EntryResult.fromJson(Map<String, dynamic> json) => _$EntryResultFromJson(json);

@override final  String entryId;
@override final  bool correct;
@override final  DateTime timestamp;

/// Create a copy of EntryResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EntryResultCopyWith<_EntryResult> get copyWith => __$EntryResultCopyWithImpl<_EntryResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EntryResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EntryResult&&(identical(other.entryId, entryId) || other.entryId == entryId)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entryId,correct,timestamp);

@override
String toString() {
  return 'EntryResult(entryId: $entryId, correct: $correct, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$EntryResultCopyWith<$Res> implements $EntryResultCopyWith<$Res> {
  factory _$EntryResultCopyWith(_EntryResult value, $Res Function(_EntryResult) _then) = __$EntryResultCopyWithImpl;
@override @useResult
$Res call({
 String entryId, bool correct, DateTime timestamp
});




}
/// @nodoc
class __$EntryResultCopyWithImpl<$Res>
    implements _$EntryResultCopyWith<$Res> {
  __$EntryResultCopyWithImpl(this._self, this._then);

  final _EntryResult _self;
  final $Res Function(_EntryResult) _then;

/// Create a copy of EntryResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entryId = null,Object? correct = null,Object? timestamp = null,}) {
  return _then(_EntryResult(
entryId: null == entryId ? _self.entryId : entryId // ignore: cast_nullable_to_non_nullable
as String,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$WritingCompletion {

 String get id; String get patternId; String get topicId; WritingMode get mode; int get timeSpent;// 経過時間（秒）
 DateTime get completedAt; List<EntryResult> get results;
/// Create a copy of WritingCompletion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WritingCompletionCopyWith<WritingCompletion> get copyWith => _$WritingCompletionCopyWithImpl<WritingCompletion>(this as WritingCompletion, _$identity);

  /// Serializes this WritingCompletion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WritingCompletion&&(identical(other.id, id) || other.id == id)&&(identical(other.patternId, patternId) || other.patternId == patternId)&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.timeSpent, timeSpent) || other.timeSpent == timeSpent)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patternId,topicId,mode,timeSpent,completedAt,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'WritingCompletion(id: $id, patternId: $patternId, topicId: $topicId, mode: $mode, timeSpent: $timeSpent, completedAt: $completedAt, results: $results)';
}


}

/// @nodoc
abstract mixin class $WritingCompletionCopyWith<$Res>  {
  factory $WritingCompletionCopyWith(WritingCompletion value, $Res Function(WritingCompletion) _then) = _$WritingCompletionCopyWithImpl;
@useResult
$Res call({
 String id, String patternId, String topicId, WritingMode mode, int timeSpent, DateTime completedAt, List<EntryResult> results
});




}
/// @nodoc
class _$WritingCompletionCopyWithImpl<$Res>
    implements $WritingCompletionCopyWith<$Res> {
  _$WritingCompletionCopyWithImpl(this._self, this._then);

  final WritingCompletion _self;
  final $Res Function(WritingCompletion) _then;

/// Create a copy of WritingCompletion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? patternId = null,Object? topicId = null,Object? mode = null,Object? timeSpent = null,Object? completedAt = null,Object? results = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patternId: null == patternId ? _self.patternId : patternId // ignore: cast_nullable_to_non_nullable
as String,topicId: null == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as WritingMode,timeSpent: null == timeSpent ? _self.timeSpent : timeSpent // ignore: cast_nullable_to_non_nullable
as int,completedAt: null == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<EntryResult>,
  ));
}

}


/// Adds pattern-matching-related methods to [WritingCompletion].
extension WritingCompletionPatterns on WritingCompletion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WritingCompletion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WritingCompletion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WritingCompletion value)  $default,){
final _that = this;
switch (_that) {
case _WritingCompletion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WritingCompletion value)?  $default,){
final _that = this;
switch (_that) {
case _WritingCompletion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String patternId,  String topicId,  WritingMode mode,  int timeSpent,  DateTime completedAt,  List<EntryResult> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WritingCompletion() when $default != null:
return $default(_that.id,_that.patternId,_that.topicId,_that.mode,_that.timeSpent,_that.completedAt,_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String patternId,  String topicId,  WritingMode mode,  int timeSpent,  DateTime completedAt,  List<EntryResult> results)  $default,) {final _that = this;
switch (_that) {
case _WritingCompletion():
return $default(_that.id,_that.patternId,_that.topicId,_that.mode,_that.timeSpent,_that.completedAt,_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String patternId,  String topicId,  WritingMode mode,  int timeSpent,  DateTime completedAt,  List<EntryResult> results)?  $default,) {final _that = this;
switch (_that) {
case _WritingCompletion() when $default != null:
return $default(_that.id,_that.patternId,_that.topicId,_that.mode,_that.timeSpent,_that.completedAt,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WritingCompletion implements WritingCompletion {
  const _WritingCompletion({required this.id, required this.patternId, required this.topicId, required this.mode, required this.timeSpent, required this.completedAt, required final  List<EntryResult> results}): _results = results;
  factory _WritingCompletion.fromJson(Map<String, dynamic> json) => _$WritingCompletionFromJson(json);

@override final  String id;
@override final  String patternId;
@override final  String topicId;
@override final  WritingMode mode;
@override final  int timeSpent;
// 経過時間（秒）
@override final  DateTime completedAt;
 final  List<EntryResult> _results;
@override List<EntryResult> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of WritingCompletion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WritingCompletionCopyWith<_WritingCompletion> get copyWith => __$WritingCompletionCopyWithImpl<_WritingCompletion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WritingCompletionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WritingCompletion&&(identical(other.id, id) || other.id == id)&&(identical(other.patternId, patternId) || other.patternId == patternId)&&(identical(other.topicId, topicId) || other.topicId == topicId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.timeSpent, timeSpent) || other.timeSpent == timeSpent)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,patternId,topicId,mode,timeSpent,completedAt,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'WritingCompletion(id: $id, patternId: $patternId, topicId: $topicId, mode: $mode, timeSpent: $timeSpent, completedAt: $completedAt, results: $results)';
}


}

/// @nodoc
abstract mixin class _$WritingCompletionCopyWith<$Res> implements $WritingCompletionCopyWith<$Res> {
  factory _$WritingCompletionCopyWith(_WritingCompletion value, $Res Function(_WritingCompletion) _then) = __$WritingCompletionCopyWithImpl;
@override @useResult
$Res call({
 String id, String patternId, String topicId, WritingMode mode, int timeSpent, DateTime completedAt, List<EntryResult> results
});




}
/// @nodoc
class __$WritingCompletionCopyWithImpl<$Res>
    implements _$WritingCompletionCopyWith<$Res> {
  __$WritingCompletionCopyWithImpl(this._self, this._then);

  final _WritingCompletion _self;
  final $Res Function(_WritingCompletion) _then;

/// Create a copy of WritingCompletion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? patternId = null,Object? topicId = null,Object? mode = null,Object? timeSpent = null,Object? completedAt = null,Object? results = null,}) {
  return _then(_WritingCompletion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,patternId: null == patternId ? _self.patternId : patternId // ignore: cast_nullable_to_non_nullable
as String,topicId: null == topicId ? _self.topicId : topicId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as WritingMode,timeSpent: null == timeSpent ? _self.timeSpent : timeSpent // ignore: cast_nullable_to_non_nullable
as int,completedAt: null == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<EntryResult>,
  ));
}


}


/// @nodoc
mixin _$WritingStats {

 int get totalCompletions; int get totalCorrect; int get totalAttempts; Map<String, int> get patternCompletions;
/// Create a copy of WritingStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WritingStatsCopyWith<WritingStats> get copyWith => _$WritingStatsCopyWithImpl<WritingStats>(this as WritingStats, _$identity);

  /// Serializes this WritingStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WritingStats&&(identical(other.totalCompletions, totalCompletions) || other.totalCompletions == totalCompletions)&&(identical(other.totalCorrect, totalCorrect) || other.totalCorrect == totalCorrect)&&(identical(other.totalAttempts, totalAttempts) || other.totalAttempts == totalAttempts)&&const DeepCollectionEquality().equals(other.patternCompletions, patternCompletions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalCompletions,totalCorrect,totalAttempts,const DeepCollectionEquality().hash(patternCompletions));

@override
String toString() {
  return 'WritingStats(totalCompletions: $totalCompletions, totalCorrect: $totalCorrect, totalAttempts: $totalAttempts, patternCompletions: $patternCompletions)';
}


}

/// @nodoc
abstract mixin class $WritingStatsCopyWith<$Res>  {
  factory $WritingStatsCopyWith(WritingStats value, $Res Function(WritingStats) _then) = _$WritingStatsCopyWithImpl;
@useResult
$Res call({
 int totalCompletions, int totalCorrect, int totalAttempts, Map<String, int> patternCompletions
});




}
/// @nodoc
class _$WritingStatsCopyWithImpl<$Res>
    implements $WritingStatsCopyWith<$Res> {
  _$WritingStatsCopyWithImpl(this._self, this._then);

  final WritingStats _self;
  final $Res Function(WritingStats) _then;

/// Create a copy of WritingStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalCompletions = null,Object? totalCorrect = null,Object? totalAttempts = null,Object? patternCompletions = null,}) {
  return _then(_self.copyWith(
totalCompletions: null == totalCompletions ? _self.totalCompletions : totalCompletions // ignore: cast_nullable_to_non_nullable
as int,totalCorrect: null == totalCorrect ? _self.totalCorrect : totalCorrect // ignore: cast_nullable_to_non_nullable
as int,totalAttempts: null == totalAttempts ? _self.totalAttempts : totalAttempts // ignore: cast_nullable_to_non_nullable
as int,patternCompletions: null == patternCompletions ? _self.patternCompletions : patternCompletions // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [WritingStats].
extension WritingStatsPatterns on WritingStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WritingStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WritingStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WritingStats value)  $default,){
final _that = this;
switch (_that) {
case _WritingStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WritingStats value)?  $default,){
final _that = this;
switch (_that) {
case _WritingStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalCompletions,  int totalCorrect,  int totalAttempts,  Map<String, int> patternCompletions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WritingStats() when $default != null:
return $default(_that.totalCompletions,_that.totalCorrect,_that.totalAttempts,_that.patternCompletions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalCompletions,  int totalCorrect,  int totalAttempts,  Map<String, int> patternCompletions)  $default,) {final _that = this;
switch (_that) {
case _WritingStats():
return $default(_that.totalCompletions,_that.totalCorrect,_that.totalAttempts,_that.patternCompletions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalCompletions,  int totalCorrect,  int totalAttempts,  Map<String, int> patternCompletions)?  $default,) {final _that = this;
switch (_that) {
case _WritingStats() when $default != null:
return $default(_that.totalCompletions,_that.totalCorrect,_that.totalAttempts,_that.patternCompletions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WritingStats implements WritingStats {
  const _WritingStats({this.totalCompletions = 0, this.totalCorrect = 0, this.totalAttempts = 0, final  Map<String, int> patternCompletions = const {}}): _patternCompletions = patternCompletions;
  factory _WritingStats.fromJson(Map<String, dynamic> json) => _$WritingStatsFromJson(json);

@override@JsonKey() final  int totalCompletions;
@override@JsonKey() final  int totalCorrect;
@override@JsonKey() final  int totalAttempts;
 final  Map<String, int> _patternCompletions;
@override@JsonKey() Map<String, int> get patternCompletions {
  if (_patternCompletions is EqualUnmodifiableMapView) return _patternCompletions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_patternCompletions);
}


/// Create a copy of WritingStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WritingStatsCopyWith<_WritingStats> get copyWith => __$WritingStatsCopyWithImpl<_WritingStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WritingStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WritingStats&&(identical(other.totalCompletions, totalCompletions) || other.totalCompletions == totalCompletions)&&(identical(other.totalCorrect, totalCorrect) || other.totalCorrect == totalCorrect)&&(identical(other.totalAttempts, totalAttempts) || other.totalAttempts == totalAttempts)&&const DeepCollectionEquality().equals(other._patternCompletions, _patternCompletions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalCompletions,totalCorrect,totalAttempts,const DeepCollectionEquality().hash(_patternCompletions));

@override
String toString() {
  return 'WritingStats(totalCompletions: $totalCompletions, totalCorrect: $totalCorrect, totalAttempts: $totalAttempts, patternCompletions: $patternCompletions)';
}


}

/// @nodoc
abstract mixin class _$WritingStatsCopyWith<$Res> implements $WritingStatsCopyWith<$Res> {
  factory _$WritingStatsCopyWith(_WritingStats value, $Res Function(_WritingStats) _then) = __$WritingStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalCompletions, int totalCorrect, int totalAttempts, Map<String, int> patternCompletions
});




}
/// @nodoc
class __$WritingStatsCopyWithImpl<$Res>
    implements _$WritingStatsCopyWith<$Res> {
  __$WritingStatsCopyWithImpl(this._self, this._then);

  final _WritingStats _self;
  final $Res Function(_WritingStats) _then;

/// Create a copy of WritingStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalCompletions = null,Object? totalCorrect = null,Object? totalAttempts = null,Object? patternCompletions = null,}) {
  return _then(_WritingStats(
totalCompletions: null == totalCompletions ? _self.totalCompletions : totalCompletions // ignore: cast_nullable_to_non_nullable
as int,totalCorrect: null == totalCorrect ? _self.totalCorrect : totalCorrect // ignore: cast_nullable_to_non_nullable
as int,totalAttempts: null == totalAttempts ? _self.totalAttempts : totalAttempts // ignore: cast_nullable_to_non_nullable
as int,patternCompletions: null == patternCompletions ? _self._patternCompletions : patternCompletions // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}

// dart format on
