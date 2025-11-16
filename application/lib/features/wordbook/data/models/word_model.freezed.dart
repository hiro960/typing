// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'word_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Word {

 String get id; String get userId; String get word; String get meaning; String? get example;@JsonKey(unknownEnumValue: WordStatus.REVIEWING) WordStatus get status;@JsonKey(unknownEnumValue: WordCategory.WORDS) WordCategory get category; DateTime? get lastReviewedAt; int get reviewCount; double get successRate; List<String> get tags; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of Word
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WordCopyWith<Word> get copyWith => _$WordCopyWithImpl<Word>(this as Word, _$identity);

  /// Serializes this Word to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Word&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.word, word) || other.word == word)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.example, example) || other.example == example)&&(identical(other.status, status) || other.status == status)&&(identical(other.category, category) || other.category == category)&&(identical(other.lastReviewedAt, lastReviewedAt) || other.lastReviewedAt == lastReviewedAt)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.successRate, successRate) || other.successRate == successRate)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,word,meaning,example,status,category,lastReviewedAt,reviewCount,successRate,const DeepCollectionEquality().hash(tags),createdAt,updatedAt);

@override
String toString() {
  return 'Word(id: $id, userId: $userId, word: $word, meaning: $meaning, example: $example, status: $status, category: $category, lastReviewedAt: $lastReviewedAt, reviewCount: $reviewCount, successRate: $successRate, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $WordCopyWith<$Res>  {
  factory $WordCopyWith(Word value, $Res Function(Word) _then) = _$WordCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String word, String meaning, String? example,@JsonKey(unknownEnumValue: WordStatus.REVIEWING) WordStatus status,@JsonKey(unknownEnumValue: WordCategory.WORDS) WordCategory category, DateTime? lastReviewedAt, int reviewCount, double successRate, List<String> tags, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$WordCopyWithImpl<$Res>
    implements $WordCopyWith<$Res> {
  _$WordCopyWithImpl(this._self, this._then);

  final Word _self;
  final $Res Function(Word) _then;

/// Create a copy of Word
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? word = null,Object? meaning = null,Object? example = freezed,Object? status = null,Object? category = null,Object? lastReviewedAt = freezed,Object? reviewCount = null,Object? successRate = null,Object? tags = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,example: freezed == example ? _self.example : example // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WordStatus,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as WordCategory,lastReviewedAt: freezed == lastReviewedAt ? _self.lastReviewedAt : lastReviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,successRate: null == successRate ? _self.successRate : successRate // ignore: cast_nullable_to_non_nullable
as double,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Word].
extension WordPatterns on Word {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Word value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Word() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Word value)  $default,){
final _that = this;
switch (_that) {
case _Word():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Word value)?  $default,){
final _that = this;
switch (_that) {
case _Word() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String word,  String meaning,  String? example, @JsonKey(unknownEnumValue: WordStatus.REVIEWING)  WordStatus status, @JsonKey(unknownEnumValue: WordCategory.WORDS)  WordCategory category,  DateTime? lastReviewedAt,  int reviewCount,  double successRate,  List<String> tags,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Word() when $default != null:
return $default(_that.id,_that.userId,_that.word,_that.meaning,_that.example,_that.status,_that.category,_that.lastReviewedAt,_that.reviewCount,_that.successRate,_that.tags,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String word,  String meaning,  String? example, @JsonKey(unknownEnumValue: WordStatus.REVIEWING)  WordStatus status, @JsonKey(unknownEnumValue: WordCategory.WORDS)  WordCategory category,  DateTime? lastReviewedAt,  int reviewCount,  double successRate,  List<String> tags,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Word():
return $default(_that.id,_that.userId,_that.word,_that.meaning,_that.example,_that.status,_that.category,_that.lastReviewedAt,_that.reviewCount,_that.successRate,_that.tags,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String word,  String meaning,  String? example, @JsonKey(unknownEnumValue: WordStatus.REVIEWING)  WordStatus status, @JsonKey(unknownEnumValue: WordCategory.WORDS)  WordCategory category,  DateTime? lastReviewedAt,  int reviewCount,  double successRate,  List<String> tags,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Word() when $default != null:
return $default(_that.id,_that.userId,_that.word,_that.meaning,_that.example,_that.status,_that.category,_that.lastReviewedAt,_that.reviewCount,_that.successRate,_that.tags,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Word implements Word {
  const _Word({required this.id, required this.userId, required this.word, required this.meaning, this.example, @JsonKey(unknownEnumValue: WordStatus.REVIEWING) required this.status, @JsonKey(unknownEnumValue: WordCategory.WORDS) required this.category, this.lastReviewedAt, this.reviewCount = 0, this.successRate = 0.0, final  List<String> tags = const <String>[], this.createdAt, this.updatedAt}): _tags = tags;
  factory _Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String word;
@override final  String meaning;
@override final  String? example;
@override@JsonKey(unknownEnumValue: WordStatus.REVIEWING) final  WordStatus status;
@override@JsonKey(unknownEnumValue: WordCategory.WORDS) final  WordCategory category;
@override final  DateTime? lastReviewedAt;
@override@JsonKey() final  int reviewCount;
@override@JsonKey() final  double successRate;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Word
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WordCopyWith<_Word> get copyWith => __$WordCopyWithImpl<_Word>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Word&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.word, word) || other.word == word)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.example, example) || other.example == example)&&(identical(other.status, status) || other.status == status)&&(identical(other.category, category) || other.category == category)&&(identical(other.lastReviewedAt, lastReviewedAt) || other.lastReviewedAt == lastReviewedAt)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.successRate, successRate) || other.successRate == successRate)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,word,meaning,example,status,category,lastReviewedAt,reviewCount,successRate,const DeepCollectionEquality().hash(_tags),createdAt,updatedAt);

@override
String toString() {
  return 'Word(id: $id, userId: $userId, word: $word, meaning: $meaning, example: $example, status: $status, category: $category, lastReviewedAt: $lastReviewedAt, reviewCount: $reviewCount, successRate: $successRate, tags: $tags, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$WordCopyWith<$Res> implements $WordCopyWith<$Res> {
  factory _$WordCopyWith(_Word value, $Res Function(_Word) _then) = __$WordCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String word, String meaning, String? example,@JsonKey(unknownEnumValue: WordStatus.REVIEWING) WordStatus status,@JsonKey(unknownEnumValue: WordCategory.WORDS) WordCategory category, DateTime? lastReviewedAt, int reviewCount, double successRate, List<String> tags, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$WordCopyWithImpl<$Res>
    implements _$WordCopyWith<$Res> {
  __$WordCopyWithImpl(this._self, this._then);

  final _Word _self;
  final $Res Function(_Word) _then;

/// Create a copy of Word
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? word = null,Object? meaning = null,Object? example = freezed,Object? status = null,Object? category = null,Object? lastReviewedAt = freezed,Object? reviewCount = null,Object? successRate = null,Object? tags = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Word(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,example: freezed == example ? _self.example : example // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WordStatus,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as WordCategory,lastReviewedAt: freezed == lastReviewedAt ? _self.lastReviewedAt : lastReviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,successRate: null == successRate ? _self.successRate : successRate // ignore: cast_nullable_to_non_nullable
as double,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
