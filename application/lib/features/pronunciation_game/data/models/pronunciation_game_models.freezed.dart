// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pronunciation_game_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PronunciationGameConfig {

 String get difficulty; bool get isPracticeMode; int? get targetQuestionCount;
/// Create a copy of PronunciationGameConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PronunciationGameConfigCopyWith<PronunciationGameConfig> get copyWith => _$PronunciationGameConfigCopyWithImpl<PronunciationGameConfig>(this as PronunciationGameConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PronunciationGameConfig&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.isPracticeMode, isPracticeMode) || other.isPracticeMode == isPracticeMode)&&(identical(other.targetQuestionCount, targetQuestionCount) || other.targetQuestionCount == targetQuestionCount));
}


@override
int get hashCode => Object.hash(runtimeType,difficulty,isPracticeMode,targetQuestionCount);

@override
String toString() {
  return 'PronunciationGameConfig(difficulty: $difficulty, isPracticeMode: $isPracticeMode, targetQuestionCount: $targetQuestionCount)';
}


}

/// @nodoc
abstract mixin class $PronunciationGameConfigCopyWith<$Res>  {
  factory $PronunciationGameConfigCopyWith(PronunciationGameConfig value, $Res Function(PronunciationGameConfig) _then) = _$PronunciationGameConfigCopyWithImpl;
@useResult
$Res call({
 String difficulty, bool isPracticeMode, int? targetQuestionCount
});




}
/// @nodoc
class _$PronunciationGameConfigCopyWithImpl<$Res>
    implements $PronunciationGameConfigCopyWith<$Res> {
  _$PronunciationGameConfigCopyWithImpl(this._self, this._then);

  final PronunciationGameConfig _self;
  final $Res Function(PronunciationGameConfig) _then;

/// Create a copy of PronunciationGameConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? difficulty = null,Object? isPracticeMode = null,Object? targetQuestionCount = freezed,}) {
  return _then(_self.copyWith(
difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,isPracticeMode: null == isPracticeMode ? _self.isPracticeMode : isPracticeMode // ignore: cast_nullable_to_non_nullable
as bool,targetQuestionCount: freezed == targetQuestionCount ? _self.targetQuestionCount : targetQuestionCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PronunciationGameConfig].
extension PronunciationGameConfigPatterns on PronunciationGameConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PronunciationGameConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PronunciationGameConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PronunciationGameConfig value)  $default,){
final _that = this;
switch (_that) {
case _PronunciationGameConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PronunciationGameConfig value)?  $default,){
final _that = this;
switch (_that) {
case _PronunciationGameConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String difficulty,  bool isPracticeMode,  int? targetQuestionCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PronunciationGameConfig() when $default != null:
return $default(_that.difficulty,_that.isPracticeMode,_that.targetQuestionCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String difficulty,  bool isPracticeMode,  int? targetQuestionCount)  $default,) {final _that = this;
switch (_that) {
case _PronunciationGameConfig():
return $default(_that.difficulty,_that.isPracticeMode,_that.targetQuestionCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String difficulty,  bool isPracticeMode,  int? targetQuestionCount)?  $default,) {final _that = this;
switch (_that) {
case _PronunciationGameConfig() when $default != null:
return $default(_that.difficulty,_that.isPracticeMode,_that.targetQuestionCount);case _:
  return null;

}
}

}

/// @nodoc


class _PronunciationGameConfig implements PronunciationGameConfig {
  const _PronunciationGameConfig({required this.difficulty, this.isPracticeMode = false, this.targetQuestionCount});
  

@override final  String difficulty;
@override@JsonKey() final  bool isPracticeMode;
@override final  int? targetQuestionCount;

/// Create a copy of PronunciationGameConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PronunciationGameConfigCopyWith<_PronunciationGameConfig> get copyWith => __$PronunciationGameConfigCopyWithImpl<_PronunciationGameConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PronunciationGameConfig&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.isPracticeMode, isPracticeMode) || other.isPracticeMode == isPracticeMode)&&(identical(other.targetQuestionCount, targetQuestionCount) || other.targetQuestionCount == targetQuestionCount));
}


@override
int get hashCode => Object.hash(runtimeType,difficulty,isPracticeMode,targetQuestionCount);

@override
String toString() {
  return 'PronunciationGameConfig(difficulty: $difficulty, isPracticeMode: $isPracticeMode, targetQuestionCount: $targetQuestionCount)';
}


}

/// @nodoc
abstract mixin class _$PronunciationGameConfigCopyWith<$Res> implements $PronunciationGameConfigCopyWith<$Res> {
  factory _$PronunciationGameConfigCopyWith(_PronunciationGameConfig value, $Res Function(_PronunciationGameConfig) _then) = __$PronunciationGameConfigCopyWithImpl;
@override @useResult
$Res call({
 String difficulty, bool isPracticeMode, int? targetQuestionCount
});




}
/// @nodoc
class __$PronunciationGameConfigCopyWithImpl<$Res>
    implements _$PronunciationGameConfigCopyWith<$Res> {
  __$PronunciationGameConfigCopyWithImpl(this._self, this._then);

  final _PronunciationGameConfig _self;
  final $Res Function(_PronunciationGameConfig) _then;

/// Create a copy of PronunciationGameConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? difficulty = null,Object? isPracticeMode = null,Object? targetQuestionCount = freezed,}) {
  return _then(_PronunciationGameConfig(
difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,isPracticeMode: null == isPracticeMode ? _self.isPracticeMode : isPracticeMode // ignore: cast_nullable_to_non_nullable
as bool,targetQuestionCount: freezed == targetQuestionCount ? _self.targetQuestionCount : targetQuestionCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$PronunciationGameWord {

 String get word; String get meaning;
/// Create a copy of PronunciationGameWord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PronunciationGameWordCopyWith<PronunciationGameWord> get copyWith => _$PronunciationGameWordCopyWithImpl<PronunciationGameWord>(this as PronunciationGameWord, _$identity);

  /// Serializes this PronunciationGameWord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PronunciationGameWord&&(identical(other.word, word) || other.word == word)&&(identical(other.meaning, meaning) || other.meaning == meaning));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,meaning);

@override
String toString() {
  return 'PronunciationGameWord(word: $word, meaning: $meaning)';
}


}

/// @nodoc
abstract mixin class $PronunciationGameWordCopyWith<$Res>  {
  factory $PronunciationGameWordCopyWith(PronunciationGameWord value, $Res Function(PronunciationGameWord) _then) = _$PronunciationGameWordCopyWithImpl;
@useResult
$Res call({
 String word, String meaning
});




}
/// @nodoc
class _$PronunciationGameWordCopyWithImpl<$Res>
    implements $PronunciationGameWordCopyWith<$Res> {
  _$PronunciationGameWordCopyWithImpl(this._self, this._then);

  final PronunciationGameWord _self;
  final $Res Function(PronunciationGameWord) _then;

/// Create a copy of PronunciationGameWord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? word = null,Object? meaning = null,}) {
  return _then(_self.copyWith(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PronunciationGameWord].
extension PronunciationGameWordPatterns on PronunciationGameWord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PronunciationGameWord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PronunciationGameWord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PronunciationGameWord value)  $default,){
final _that = this;
switch (_that) {
case _PronunciationGameWord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PronunciationGameWord value)?  $default,){
final _that = this;
switch (_that) {
case _PronunciationGameWord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String word,  String meaning)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PronunciationGameWord() when $default != null:
return $default(_that.word,_that.meaning);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String word,  String meaning)  $default,) {final _that = this;
switch (_that) {
case _PronunciationGameWord():
return $default(_that.word,_that.meaning);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String word,  String meaning)?  $default,) {final _that = this;
switch (_that) {
case _PronunciationGameWord() when $default != null:
return $default(_that.word,_that.meaning);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PronunciationGameWord implements PronunciationGameWord {
  const _PronunciationGameWord({required this.word, required this.meaning});
  factory _PronunciationGameWord.fromJson(Map<String, dynamic> json) => _$PronunciationGameWordFromJson(json);

@override final  String word;
@override final  String meaning;

/// Create a copy of PronunciationGameWord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PronunciationGameWordCopyWith<_PronunciationGameWord> get copyWith => __$PronunciationGameWordCopyWithImpl<_PronunciationGameWord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PronunciationGameWordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PronunciationGameWord&&(identical(other.word, word) || other.word == word)&&(identical(other.meaning, meaning) || other.meaning == meaning));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,meaning);

@override
String toString() {
  return 'PronunciationGameWord(word: $word, meaning: $meaning)';
}


}

/// @nodoc
abstract mixin class _$PronunciationGameWordCopyWith<$Res> implements $PronunciationGameWordCopyWith<$Res> {
  factory _$PronunciationGameWordCopyWith(_PronunciationGameWord value, $Res Function(_PronunciationGameWord) _then) = __$PronunciationGameWordCopyWithImpl;
@override @useResult
$Res call({
 String word, String meaning
});




}
/// @nodoc
class __$PronunciationGameWordCopyWithImpl<$Res>
    implements _$PronunciationGameWordCopyWith<$Res> {
  __$PronunciationGameWordCopyWithImpl(this._self, this._then);

  final _PronunciationGameWord _self;
  final $Res Function(_PronunciationGameWord) _then;

/// Create a copy of PronunciationGameWord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? word = null,Object? meaning = null,}) {
  return _then(_PronunciationGameWord(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PronunciationGameResult {

 String get id; String get difficulty; int get score; int get correctCount; int get maxCombo; int get totalBonusTime; int get characterLevel; DateTime get playedAt;
/// Create a copy of PronunciationGameResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PronunciationGameResultCopyWith<PronunciationGameResult> get copyWith => _$PronunciationGameResultCopyWithImpl<PronunciationGameResult>(this as PronunciationGameResult, _$identity);

  /// Serializes this PronunciationGameResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PronunciationGameResult&&(identical(other.id, id) || other.id == id)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.score, score) || other.score == score)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.maxCombo, maxCombo) || other.maxCombo == maxCombo)&&(identical(other.totalBonusTime, totalBonusTime) || other.totalBonusTime == totalBonusTime)&&(identical(other.characterLevel, characterLevel) || other.characterLevel == characterLevel)&&(identical(other.playedAt, playedAt) || other.playedAt == playedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,difficulty,score,correctCount,maxCombo,totalBonusTime,characterLevel,playedAt);

@override
String toString() {
  return 'PronunciationGameResult(id: $id, difficulty: $difficulty, score: $score, correctCount: $correctCount, maxCombo: $maxCombo, totalBonusTime: $totalBonusTime, characterLevel: $characterLevel, playedAt: $playedAt)';
}


}

/// @nodoc
abstract mixin class $PronunciationGameResultCopyWith<$Res>  {
  factory $PronunciationGameResultCopyWith(PronunciationGameResult value, $Res Function(PronunciationGameResult) _then) = _$PronunciationGameResultCopyWithImpl;
@useResult
$Res call({
 String id, String difficulty, int score, int correctCount, int maxCombo, int totalBonusTime, int characterLevel, DateTime playedAt
});




}
/// @nodoc
class _$PronunciationGameResultCopyWithImpl<$Res>
    implements $PronunciationGameResultCopyWith<$Res> {
  _$PronunciationGameResultCopyWithImpl(this._self, this._then);

  final PronunciationGameResult _self;
  final $Res Function(PronunciationGameResult) _then;

/// Create a copy of PronunciationGameResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? difficulty = null,Object? score = null,Object? correctCount = null,Object? maxCombo = null,Object? totalBonusTime = null,Object? characterLevel = null,Object? playedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,maxCombo: null == maxCombo ? _self.maxCombo : maxCombo // ignore: cast_nullable_to_non_nullable
as int,totalBonusTime: null == totalBonusTime ? _self.totalBonusTime : totalBonusTime // ignore: cast_nullable_to_non_nullable
as int,characterLevel: null == characterLevel ? _self.characterLevel : characterLevel // ignore: cast_nullable_to_non_nullable
as int,playedAt: null == playedAt ? _self.playedAt : playedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PronunciationGameResult].
extension PronunciationGameResultPatterns on PronunciationGameResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PronunciationGameResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PronunciationGameResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PronunciationGameResult value)  $default,){
final _that = this;
switch (_that) {
case _PronunciationGameResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PronunciationGameResult value)?  $default,){
final _that = this;
switch (_that) {
case _PronunciationGameResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String difficulty,  int score,  int correctCount,  int maxCombo,  int totalBonusTime,  int characterLevel,  DateTime playedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PronunciationGameResult() when $default != null:
return $default(_that.id,_that.difficulty,_that.score,_that.correctCount,_that.maxCombo,_that.totalBonusTime,_that.characterLevel,_that.playedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String difficulty,  int score,  int correctCount,  int maxCombo,  int totalBonusTime,  int characterLevel,  DateTime playedAt)  $default,) {final _that = this;
switch (_that) {
case _PronunciationGameResult():
return $default(_that.id,_that.difficulty,_that.score,_that.correctCount,_that.maxCombo,_that.totalBonusTime,_that.characterLevel,_that.playedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String difficulty,  int score,  int correctCount,  int maxCombo,  int totalBonusTime,  int characterLevel,  DateTime playedAt)?  $default,) {final _that = this;
switch (_that) {
case _PronunciationGameResult() when $default != null:
return $default(_that.id,_that.difficulty,_that.score,_that.correctCount,_that.maxCombo,_that.totalBonusTime,_that.characterLevel,_that.playedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PronunciationGameResult implements PronunciationGameResult {
  const _PronunciationGameResult({required this.id, required this.difficulty, required this.score, required this.correctCount, required this.maxCombo, required this.totalBonusTime, required this.characterLevel, required this.playedAt});
  factory _PronunciationGameResult.fromJson(Map<String, dynamic> json) => _$PronunciationGameResultFromJson(json);

@override final  String id;
@override final  String difficulty;
@override final  int score;
@override final  int correctCount;
@override final  int maxCombo;
@override final  int totalBonusTime;
@override final  int characterLevel;
@override final  DateTime playedAt;

/// Create a copy of PronunciationGameResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PronunciationGameResultCopyWith<_PronunciationGameResult> get copyWith => __$PronunciationGameResultCopyWithImpl<_PronunciationGameResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PronunciationGameResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PronunciationGameResult&&(identical(other.id, id) || other.id == id)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.score, score) || other.score == score)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.maxCombo, maxCombo) || other.maxCombo == maxCombo)&&(identical(other.totalBonusTime, totalBonusTime) || other.totalBonusTime == totalBonusTime)&&(identical(other.characterLevel, characterLevel) || other.characterLevel == characterLevel)&&(identical(other.playedAt, playedAt) || other.playedAt == playedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,difficulty,score,correctCount,maxCombo,totalBonusTime,characterLevel,playedAt);

@override
String toString() {
  return 'PronunciationGameResult(id: $id, difficulty: $difficulty, score: $score, correctCount: $correctCount, maxCombo: $maxCombo, totalBonusTime: $totalBonusTime, characterLevel: $characterLevel, playedAt: $playedAt)';
}


}

/// @nodoc
abstract mixin class _$PronunciationGameResultCopyWith<$Res> implements $PronunciationGameResultCopyWith<$Res> {
  factory _$PronunciationGameResultCopyWith(_PronunciationGameResult value, $Res Function(_PronunciationGameResult) _then) = __$PronunciationGameResultCopyWithImpl;
@override @useResult
$Res call({
 String id, String difficulty, int score, int correctCount, int maxCombo, int totalBonusTime, int characterLevel, DateTime playedAt
});




}
/// @nodoc
class __$PronunciationGameResultCopyWithImpl<$Res>
    implements _$PronunciationGameResultCopyWith<$Res> {
  __$PronunciationGameResultCopyWithImpl(this._self, this._then);

  final _PronunciationGameResult _self;
  final $Res Function(_PronunciationGameResult) _then;

/// Create a copy of PronunciationGameResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? difficulty = null,Object? score = null,Object? correctCount = null,Object? maxCombo = null,Object? totalBonusTime = null,Object? characterLevel = null,Object? playedAt = null,}) {
  return _then(_PronunciationGameResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,maxCombo: null == maxCombo ? _self.maxCombo : maxCombo // ignore: cast_nullable_to_non_nullable
as int,totalBonusTime: null == totalBonusTime ? _self.totalBonusTime : totalBonusTime // ignore: cast_nullable_to_non_nullable
as int,characterLevel: null == characterLevel ? _self.characterLevel : characterLevel // ignore: cast_nullable_to_non_nullable
as int,playedAt: null == playedAt ? _self.playedAt : playedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$PronunciationGameResultResponse {

 String get id; String get difficulty; int get score; int get correctCount; int get maxCombo; int get totalBonusTime; int get characterLevel; DateTime get playedAt; PronunciationRankingInfo get ranking; List<String> get achievements;
/// Create a copy of PronunciationGameResultResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PronunciationGameResultResponseCopyWith<PronunciationGameResultResponse> get copyWith => _$PronunciationGameResultResponseCopyWithImpl<PronunciationGameResultResponse>(this as PronunciationGameResultResponse, _$identity);

  /// Serializes this PronunciationGameResultResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PronunciationGameResultResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.score, score) || other.score == score)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.maxCombo, maxCombo) || other.maxCombo == maxCombo)&&(identical(other.totalBonusTime, totalBonusTime) || other.totalBonusTime == totalBonusTime)&&(identical(other.characterLevel, characterLevel) || other.characterLevel == characterLevel)&&(identical(other.playedAt, playedAt) || other.playedAt == playedAt)&&(identical(other.ranking, ranking) || other.ranking == ranking)&&const DeepCollectionEquality().equals(other.achievements, achievements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,difficulty,score,correctCount,maxCombo,totalBonusTime,characterLevel,playedAt,ranking,const DeepCollectionEquality().hash(achievements));

@override
String toString() {
  return 'PronunciationGameResultResponse(id: $id, difficulty: $difficulty, score: $score, correctCount: $correctCount, maxCombo: $maxCombo, totalBonusTime: $totalBonusTime, characterLevel: $characterLevel, playedAt: $playedAt, ranking: $ranking, achievements: $achievements)';
}


}

/// @nodoc
abstract mixin class $PronunciationGameResultResponseCopyWith<$Res>  {
  factory $PronunciationGameResultResponseCopyWith(PronunciationGameResultResponse value, $Res Function(PronunciationGameResultResponse) _then) = _$PronunciationGameResultResponseCopyWithImpl;
@useResult
$Res call({
 String id, String difficulty, int score, int correctCount, int maxCombo, int totalBonusTime, int characterLevel, DateTime playedAt, PronunciationRankingInfo ranking, List<String> achievements
});


$PronunciationRankingInfoCopyWith<$Res> get ranking;

}
/// @nodoc
class _$PronunciationGameResultResponseCopyWithImpl<$Res>
    implements $PronunciationGameResultResponseCopyWith<$Res> {
  _$PronunciationGameResultResponseCopyWithImpl(this._self, this._then);

  final PronunciationGameResultResponse _self;
  final $Res Function(PronunciationGameResultResponse) _then;

/// Create a copy of PronunciationGameResultResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? difficulty = null,Object? score = null,Object? correctCount = null,Object? maxCombo = null,Object? totalBonusTime = null,Object? characterLevel = null,Object? playedAt = null,Object? ranking = null,Object? achievements = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,maxCombo: null == maxCombo ? _self.maxCombo : maxCombo // ignore: cast_nullable_to_non_nullable
as int,totalBonusTime: null == totalBonusTime ? _self.totalBonusTime : totalBonusTime // ignore: cast_nullable_to_non_nullable
as int,characterLevel: null == characterLevel ? _self.characterLevel : characterLevel // ignore: cast_nullable_to_non_nullable
as int,playedAt: null == playedAt ? _self.playedAt : playedAt // ignore: cast_nullable_to_non_nullable
as DateTime,ranking: null == ranking ? _self.ranking : ranking // ignore: cast_nullable_to_non_nullable
as PronunciationRankingInfo,achievements: null == achievements ? _self.achievements : achievements // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of PronunciationGameResultResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PronunciationRankingInfoCopyWith<$Res> get ranking {
  
  return $PronunciationRankingInfoCopyWith<$Res>(_self.ranking, (value) {
    return _then(_self.copyWith(ranking: value));
  });
}
}


/// Adds pattern-matching-related methods to [PronunciationGameResultResponse].
extension PronunciationGameResultResponsePatterns on PronunciationGameResultResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PronunciationGameResultResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PronunciationGameResultResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PronunciationGameResultResponse value)  $default,){
final _that = this;
switch (_that) {
case _PronunciationGameResultResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PronunciationGameResultResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PronunciationGameResultResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String difficulty,  int score,  int correctCount,  int maxCombo,  int totalBonusTime,  int characterLevel,  DateTime playedAt,  PronunciationRankingInfo ranking,  List<String> achievements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PronunciationGameResultResponse() when $default != null:
return $default(_that.id,_that.difficulty,_that.score,_that.correctCount,_that.maxCombo,_that.totalBonusTime,_that.characterLevel,_that.playedAt,_that.ranking,_that.achievements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String difficulty,  int score,  int correctCount,  int maxCombo,  int totalBonusTime,  int characterLevel,  DateTime playedAt,  PronunciationRankingInfo ranking,  List<String> achievements)  $default,) {final _that = this;
switch (_that) {
case _PronunciationGameResultResponse():
return $default(_that.id,_that.difficulty,_that.score,_that.correctCount,_that.maxCombo,_that.totalBonusTime,_that.characterLevel,_that.playedAt,_that.ranking,_that.achievements);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String difficulty,  int score,  int correctCount,  int maxCombo,  int totalBonusTime,  int characterLevel,  DateTime playedAt,  PronunciationRankingInfo ranking,  List<String> achievements)?  $default,) {final _that = this;
switch (_that) {
case _PronunciationGameResultResponse() when $default != null:
return $default(_that.id,_that.difficulty,_that.score,_that.correctCount,_that.maxCombo,_that.totalBonusTime,_that.characterLevel,_that.playedAt,_that.ranking,_that.achievements);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PronunciationGameResultResponse implements PronunciationGameResultResponse {
  const _PronunciationGameResultResponse({required this.id, required this.difficulty, required this.score, required this.correctCount, required this.maxCombo, required this.totalBonusTime, required this.characterLevel, required this.playedAt, required this.ranking, final  List<String> achievements = const <String>[]}): _achievements = achievements;
  factory _PronunciationGameResultResponse.fromJson(Map<String, dynamic> json) => _$PronunciationGameResultResponseFromJson(json);

@override final  String id;
@override final  String difficulty;
@override final  int score;
@override final  int correctCount;
@override final  int maxCombo;
@override final  int totalBonusTime;
@override final  int characterLevel;
@override final  DateTime playedAt;
@override final  PronunciationRankingInfo ranking;
 final  List<String> _achievements;
@override@JsonKey() List<String> get achievements {
  if (_achievements is EqualUnmodifiableListView) return _achievements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_achievements);
}


/// Create a copy of PronunciationGameResultResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PronunciationGameResultResponseCopyWith<_PronunciationGameResultResponse> get copyWith => __$PronunciationGameResultResponseCopyWithImpl<_PronunciationGameResultResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PronunciationGameResultResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PronunciationGameResultResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.score, score) || other.score == score)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.maxCombo, maxCombo) || other.maxCombo == maxCombo)&&(identical(other.totalBonusTime, totalBonusTime) || other.totalBonusTime == totalBonusTime)&&(identical(other.characterLevel, characterLevel) || other.characterLevel == characterLevel)&&(identical(other.playedAt, playedAt) || other.playedAt == playedAt)&&(identical(other.ranking, ranking) || other.ranking == ranking)&&const DeepCollectionEquality().equals(other._achievements, _achievements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,difficulty,score,correctCount,maxCombo,totalBonusTime,characterLevel,playedAt,ranking,const DeepCollectionEquality().hash(_achievements));

@override
String toString() {
  return 'PronunciationGameResultResponse(id: $id, difficulty: $difficulty, score: $score, correctCount: $correctCount, maxCombo: $maxCombo, totalBonusTime: $totalBonusTime, characterLevel: $characterLevel, playedAt: $playedAt, ranking: $ranking, achievements: $achievements)';
}


}

/// @nodoc
abstract mixin class _$PronunciationGameResultResponseCopyWith<$Res> implements $PronunciationGameResultResponseCopyWith<$Res> {
  factory _$PronunciationGameResultResponseCopyWith(_PronunciationGameResultResponse value, $Res Function(_PronunciationGameResultResponse) _then) = __$PronunciationGameResultResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String difficulty, int score, int correctCount, int maxCombo, int totalBonusTime, int characterLevel, DateTime playedAt, PronunciationRankingInfo ranking, List<String> achievements
});


@override $PronunciationRankingInfoCopyWith<$Res> get ranking;

}
/// @nodoc
class __$PronunciationGameResultResponseCopyWithImpl<$Res>
    implements _$PronunciationGameResultResponseCopyWith<$Res> {
  __$PronunciationGameResultResponseCopyWithImpl(this._self, this._then);

  final _PronunciationGameResultResponse _self;
  final $Res Function(_PronunciationGameResultResponse) _then;

/// Create a copy of PronunciationGameResultResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? difficulty = null,Object? score = null,Object? correctCount = null,Object? maxCombo = null,Object? totalBonusTime = null,Object? characterLevel = null,Object? playedAt = null,Object? ranking = null,Object? achievements = null,}) {
  return _then(_PronunciationGameResultResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,maxCombo: null == maxCombo ? _self.maxCombo : maxCombo // ignore: cast_nullable_to_non_nullable
as int,totalBonusTime: null == totalBonusTime ? _self.totalBonusTime : totalBonusTime // ignore: cast_nullable_to_non_nullable
as int,characterLevel: null == characterLevel ? _self.characterLevel : characterLevel // ignore: cast_nullable_to_non_nullable
as int,playedAt: null == playedAt ? _self.playedAt : playedAt // ignore: cast_nullable_to_non_nullable
as DateTime,ranking: null == ranking ? _self.ranking : ranking // ignore: cast_nullable_to_non_nullable
as PronunciationRankingInfo,achievements: null == achievements ? _self._achievements : achievements // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of PronunciationGameResultResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PronunciationRankingInfoCopyWith<$Res> get ranking {
  
  return $PronunciationRankingInfoCopyWith<$Res>(_self.ranking, (value) {
    return _then(_self.copyWith(ranking: value));
  });
}
}


/// @nodoc
mixin _$PronunciationRankingInfo {

 int get position; int? get previousPosition; int get totalParticipants; bool get isNewBest;
/// Create a copy of PronunciationRankingInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PronunciationRankingInfoCopyWith<PronunciationRankingInfo> get copyWith => _$PronunciationRankingInfoCopyWithImpl<PronunciationRankingInfo>(this as PronunciationRankingInfo, _$identity);

  /// Serializes this PronunciationRankingInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PronunciationRankingInfo&&(identical(other.position, position) || other.position == position)&&(identical(other.previousPosition, previousPosition) || other.previousPosition == previousPosition)&&(identical(other.totalParticipants, totalParticipants) || other.totalParticipants == totalParticipants)&&(identical(other.isNewBest, isNewBest) || other.isNewBest == isNewBest));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,previousPosition,totalParticipants,isNewBest);

@override
String toString() {
  return 'PronunciationRankingInfo(position: $position, previousPosition: $previousPosition, totalParticipants: $totalParticipants, isNewBest: $isNewBest)';
}


}

/// @nodoc
abstract mixin class $PronunciationRankingInfoCopyWith<$Res>  {
  factory $PronunciationRankingInfoCopyWith(PronunciationRankingInfo value, $Res Function(PronunciationRankingInfo) _then) = _$PronunciationRankingInfoCopyWithImpl;
@useResult
$Res call({
 int position, int? previousPosition, int totalParticipants, bool isNewBest
});




}
/// @nodoc
class _$PronunciationRankingInfoCopyWithImpl<$Res>
    implements $PronunciationRankingInfoCopyWith<$Res> {
  _$PronunciationRankingInfoCopyWithImpl(this._self, this._then);

  final PronunciationRankingInfo _self;
  final $Res Function(PronunciationRankingInfo) _then;

/// Create a copy of PronunciationRankingInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? position = null,Object? previousPosition = freezed,Object? totalParticipants = null,Object? isNewBest = null,}) {
  return _then(_self.copyWith(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,previousPosition: freezed == previousPosition ? _self.previousPosition : previousPosition // ignore: cast_nullable_to_non_nullable
as int?,totalParticipants: null == totalParticipants ? _self.totalParticipants : totalParticipants // ignore: cast_nullable_to_non_nullable
as int,isNewBest: null == isNewBest ? _self.isNewBest : isNewBest // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PronunciationRankingInfo].
extension PronunciationRankingInfoPatterns on PronunciationRankingInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PronunciationRankingInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PronunciationRankingInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PronunciationRankingInfo value)  $default,){
final _that = this;
switch (_that) {
case _PronunciationRankingInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PronunciationRankingInfo value)?  $default,){
final _that = this;
switch (_that) {
case _PronunciationRankingInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int position,  int? previousPosition,  int totalParticipants,  bool isNewBest)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PronunciationRankingInfo() when $default != null:
return $default(_that.position,_that.previousPosition,_that.totalParticipants,_that.isNewBest);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int position,  int? previousPosition,  int totalParticipants,  bool isNewBest)  $default,) {final _that = this;
switch (_that) {
case _PronunciationRankingInfo():
return $default(_that.position,_that.previousPosition,_that.totalParticipants,_that.isNewBest);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int position,  int? previousPosition,  int totalParticipants,  bool isNewBest)?  $default,) {final _that = this;
switch (_that) {
case _PronunciationRankingInfo() when $default != null:
return $default(_that.position,_that.previousPosition,_that.totalParticipants,_that.isNewBest);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PronunciationRankingInfo implements PronunciationRankingInfo {
  const _PronunciationRankingInfo({required this.position, this.previousPosition, required this.totalParticipants, required this.isNewBest});
  factory _PronunciationRankingInfo.fromJson(Map<String, dynamic> json) => _$PronunciationRankingInfoFromJson(json);

@override final  int position;
@override final  int? previousPosition;
@override final  int totalParticipants;
@override final  bool isNewBest;

/// Create a copy of PronunciationRankingInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PronunciationRankingInfoCopyWith<_PronunciationRankingInfo> get copyWith => __$PronunciationRankingInfoCopyWithImpl<_PronunciationRankingInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PronunciationRankingInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PronunciationRankingInfo&&(identical(other.position, position) || other.position == position)&&(identical(other.previousPosition, previousPosition) || other.previousPosition == previousPosition)&&(identical(other.totalParticipants, totalParticipants) || other.totalParticipants == totalParticipants)&&(identical(other.isNewBest, isNewBest) || other.isNewBest == isNewBest));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,previousPosition,totalParticipants,isNewBest);

@override
String toString() {
  return 'PronunciationRankingInfo(position: $position, previousPosition: $previousPosition, totalParticipants: $totalParticipants, isNewBest: $isNewBest)';
}


}

/// @nodoc
abstract mixin class _$PronunciationRankingInfoCopyWith<$Res> implements $PronunciationRankingInfoCopyWith<$Res> {
  factory _$PronunciationRankingInfoCopyWith(_PronunciationRankingInfo value, $Res Function(_PronunciationRankingInfo) _then) = __$PronunciationRankingInfoCopyWithImpl;
@override @useResult
$Res call({
 int position, int? previousPosition, int totalParticipants, bool isNewBest
});




}
/// @nodoc
class __$PronunciationRankingInfoCopyWithImpl<$Res>
    implements _$PronunciationRankingInfoCopyWith<$Res> {
  __$PronunciationRankingInfoCopyWithImpl(this._self, this._then);

  final _PronunciationRankingInfo _self;
  final $Res Function(_PronunciationRankingInfo) _then;

/// Create a copy of PronunciationRankingInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? position = null,Object? previousPosition = freezed,Object? totalParticipants = null,Object? isNewBest = null,}) {
  return _then(_PronunciationRankingInfo(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,previousPosition: freezed == previousPosition ? _self.previousPosition : previousPosition // ignore: cast_nullable_to_non_nullable
as int?,totalParticipants: null == totalParticipants ? _self.totalParticipants : totalParticipants // ignore: cast_nullable_to_non_nullable
as int,isNewBest: null == isNewBest ? _self.isNewBest : isNewBest // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PronunciationRankingEntry {

 int get position; DiaryUserSummary get user; int get score; int get characterLevel; int get playCount; int get maxCombo;
/// Create a copy of PronunciationRankingEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PronunciationRankingEntryCopyWith<PronunciationRankingEntry> get copyWith => _$PronunciationRankingEntryCopyWithImpl<PronunciationRankingEntry>(this as PronunciationRankingEntry, _$identity);

  /// Serializes this PronunciationRankingEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PronunciationRankingEntry&&(identical(other.position, position) || other.position == position)&&(identical(other.user, user) || other.user == user)&&(identical(other.score, score) || other.score == score)&&(identical(other.characterLevel, characterLevel) || other.characterLevel == characterLevel)&&(identical(other.playCount, playCount) || other.playCount == playCount)&&(identical(other.maxCombo, maxCombo) || other.maxCombo == maxCombo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,user,score,characterLevel,playCount,maxCombo);

@override
String toString() {
  return 'PronunciationRankingEntry(position: $position, user: $user, score: $score, characterLevel: $characterLevel, playCount: $playCount, maxCombo: $maxCombo)';
}


}

/// @nodoc
abstract mixin class $PronunciationRankingEntryCopyWith<$Res>  {
  factory $PronunciationRankingEntryCopyWith(PronunciationRankingEntry value, $Res Function(PronunciationRankingEntry) _then) = _$PronunciationRankingEntryCopyWithImpl;
@useResult
$Res call({
 int position, DiaryUserSummary user, int score, int characterLevel, int playCount, int maxCombo
});


$DiaryUserSummaryCopyWith<$Res> get user;

}
/// @nodoc
class _$PronunciationRankingEntryCopyWithImpl<$Res>
    implements $PronunciationRankingEntryCopyWith<$Res> {
  _$PronunciationRankingEntryCopyWithImpl(this._self, this._then);

  final PronunciationRankingEntry _self;
  final $Res Function(PronunciationRankingEntry) _then;

/// Create a copy of PronunciationRankingEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? position = null,Object? user = null,Object? score = null,Object? characterLevel = null,Object? playCount = null,Object? maxCombo = null,}) {
  return _then(_self.copyWith(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as DiaryUserSummary,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,characterLevel: null == characterLevel ? _self.characterLevel : characterLevel // ignore: cast_nullable_to_non_nullable
as int,playCount: null == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int,maxCombo: null == maxCombo ? _self.maxCombo : maxCombo // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of PronunciationRankingEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiaryUserSummaryCopyWith<$Res> get user {
  
  return $DiaryUserSummaryCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [PronunciationRankingEntry].
extension PronunciationRankingEntryPatterns on PronunciationRankingEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PronunciationRankingEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PronunciationRankingEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PronunciationRankingEntry value)  $default,){
final _that = this;
switch (_that) {
case _PronunciationRankingEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PronunciationRankingEntry value)?  $default,){
final _that = this;
switch (_that) {
case _PronunciationRankingEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int position,  DiaryUserSummary user,  int score,  int characterLevel,  int playCount,  int maxCombo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PronunciationRankingEntry() when $default != null:
return $default(_that.position,_that.user,_that.score,_that.characterLevel,_that.playCount,_that.maxCombo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int position,  DiaryUserSummary user,  int score,  int characterLevel,  int playCount,  int maxCombo)  $default,) {final _that = this;
switch (_that) {
case _PronunciationRankingEntry():
return $default(_that.position,_that.user,_that.score,_that.characterLevel,_that.playCount,_that.maxCombo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int position,  DiaryUserSummary user,  int score,  int characterLevel,  int playCount,  int maxCombo)?  $default,) {final _that = this;
switch (_that) {
case _PronunciationRankingEntry() when $default != null:
return $default(_that.position,_that.user,_that.score,_that.characterLevel,_that.playCount,_that.maxCombo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PronunciationRankingEntry implements PronunciationRankingEntry {
  const _PronunciationRankingEntry({required this.position, required this.user, required this.score, required this.characterLevel, required this.playCount, this.maxCombo = 0});
  factory _PronunciationRankingEntry.fromJson(Map<String, dynamic> json) => _$PronunciationRankingEntryFromJson(json);

@override final  int position;
@override final  DiaryUserSummary user;
@override final  int score;
@override final  int characterLevel;
@override final  int playCount;
@override@JsonKey() final  int maxCombo;

/// Create a copy of PronunciationRankingEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PronunciationRankingEntryCopyWith<_PronunciationRankingEntry> get copyWith => __$PronunciationRankingEntryCopyWithImpl<_PronunciationRankingEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PronunciationRankingEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PronunciationRankingEntry&&(identical(other.position, position) || other.position == position)&&(identical(other.user, user) || other.user == user)&&(identical(other.score, score) || other.score == score)&&(identical(other.characterLevel, characterLevel) || other.characterLevel == characterLevel)&&(identical(other.playCount, playCount) || other.playCount == playCount)&&(identical(other.maxCombo, maxCombo) || other.maxCombo == maxCombo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,user,score,characterLevel,playCount,maxCombo);

@override
String toString() {
  return 'PronunciationRankingEntry(position: $position, user: $user, score: $score, characterLevel: $characterLevel, playCount: $playCount, maxCombo: $maxCombo)';
}


}

/// @nodoc
abstract mixin class _$PronunciationRankingEntryCopyWith<$Res> implements $PronunciationRankingEntryCopyWith<$Res> {
  factory _$PronunciationRankingEntryCopyWith(_PronunciationRankingEntry value, $Res Function(_PronunciationRankingEntry) _then) = __$PronunciationRankingEntryCopyWithImpl;
@override @useResult
$Res call({
 int position, DiaryUserSummary user, int score, int characterLevel, int playCount, int maxCombo
});


@override $DiaryUserSummaryCopyWith<$Res> get user;

}
/// @nodoc
class __$PronunciationRankingEntryCopyWithImpl<$Res>
    implements _$PronunciationRankingEntryCopyWith<$Res> {
  __$PronunciationRankingEntryCopyWithImpl(this._self, this._then);

  final _PronunciationRankingEntry _self;
  final $Res Function(_PronunciationRankingEntry) _then;

/// Create a copy of PronunciationRankingEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? position = null,Object? user = null,Object? score = null,Object? characterLevel = null,Object? playCount = null,Object? maxCombo = null,}) {
  return _then(_PronunciationRankingEntry(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as DiaryUserSummary,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,characterLevel: null == characterLevel ? _self.characterLevel : characterLevel // ignore: cast_nullable_to_non_nullable
as int,playCount: null == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int,maxCombo: null == maxCombo ? _self.maxCombo : maxCombo // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of PronunciationRankingEntry
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
mixin _$PronunciationRankingPeriodInfo {

 DateTime get start; DateTime get end;
/// Create a copy of PronunciationRankingPeriodInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PronunciationRankingPeriodInfoCopyWith<PronunciationRankingPeriodInfo> get copyWith => _$PronunciationRankingPeriodInfoCopyWithImpl<PronunciationRankingPeriodInfo>(this as PronunciationRankingPeriodInfo, _$identity);

  /// Serializes this PronunciationRankingPeriodInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PronunciationRankingPeriodInfo&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end);

@override
String toString() {
  return 'PronunciationRankingPeriodInfo(start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class $PronunciationRankingPeriodInfoCopyWith<$Res>  {
  factory $PronunciationRankingPeriodInfoCopyWith(PronunciationRankingPeriodInfo value, $Res Function(PronunciationRankingPeriodInfo) _then) = _$PronunciationRankingPeriodInfoCopyWithImpl;
@useResult
$Res call({
 DateTime start, DateTime end
});




}
/// @nodoc
class _$PronunciationRankingPeriodInfoCopyWithImpl<$Res>
    implements $PronunciationRankingPeriodInfoCopyWith<$Res> {
  _$PronunciationRankingPeriodInfoCopyWithImpl(this._self, this._then);

  final PronunciationRankingPeriodInfo _self;
  final $Res Function(PronunciationRankingPeriodInfo) _then;

/// Create a copy of PronunciationRankingPeriodInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? end = null,}) {
  return _then(_self.copyWith(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PronunciationRankingPeriodInfo].
extension PronunciationRankingPeriodInfoPatterns on PronunciationRankingPeriodInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PronunciationRankingPeriodInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PronunciationRankingPeriodInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PronunciationRankingPeriodInfo value)  $default,){
final _that = this;
switch (_that) {
case _PronunciationRankingPeriodInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PronunciationRankingPeriodInfo value)?  $default,){
final _that = this;
switch (_that) {
case _PronunciationRankingPeriodInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime start,  DateTime end)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PronunciationRankingPeriodInfo() when $default != null:
return $default(_that.start,_that.end);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime start,  DateTime end)  $default,) {final _that = this;
switch (_that) {
case _PronunciationRankingPeriodInfo():
return $default(_that.start,_that.end);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime start,  DateTime end)?  $default,) {final _that = this;
switch (_that) {
case _PronunciationRankingPeriodInfo() when $default != null:
return $default(_that.start,_that.end);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PronunciationRankingPeriodInfo implements PronunciationRankingPeriodInfo {
  const _PronunciationRankingPeriodInfo({required this.start, required this.end});
  factory _PronunciationRankingPeriodInfo.fromJson(Map<String, dynamic> json) => _$PronunciationRankingPeriodInfoFromJson(json);

@override final  DateTime start;
@override final  DateTime end;

/// Create a copy of PronunciationRankingPeriodInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PronunciationRankingPeriodInfoCopyWith<_PronunciationRankingPeriodInfo> get copyWith => __$PronunciationRankingPeriodInfoCopyWithImpl<_PronunciationRankingPeriodInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PronunciationRankingPeriodInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PronunciationRankingPeriodInfo&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end);

@override
String toString() {
  return 'PronunciationRankingPeriodInfo(start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class _$PronunciationRankingPeriodInfoCopyWith<$Res> implements $PronunciationRankingPeriodInfoCopyWith<$Res> {
  factory _$PronunciationRankingPeriodInfoCopyWith(_PronunciationRankingPeriodInfo value, $Res Function(_PronunciationRankingPeriodInfo) _then) = __$PronunciationRankingPeriodInfoCopyWithImpl;
@override @useResult
$Res call({
 DateTime start, DateTime end
});




}
/// @nodoc
class __$PronunciationRankingPeriodInfoCopyWithImpl<$Res>
    implements _$PronunciationRankingPeriodInfoCopyWith<$Res> {
  __$PronunciationRankingPeriodInfoCopyWithImpl(this._self, this._then);

  final _PronunciationRankingPeriodInfo _self;
  final $Res Function(_PronunciationRankingPeriodInfo) _then;

/// Create a copy of PronunciationRankingPeriodInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = null,}) {
  return _then(_PronunciationRankingPeriodInfo(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$MyPronunciationRankingInfo {

 int get position; int get score; int get characterLevel;
/// Create a copy of MyPronunciationRankingInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyPronunciationRankingInfoCopyWith<MyPronunciationRankingInfo> get copyWith => _$MyPronunciationRankingInfoCopyWithImpl<MyPronunciationRankingInfo>(this as MyPronunciationRankingInfo, _$identity);

  /// Serializes this MyPronunciationRankingInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyPronunciationRankingInfo&&(identical(other.position, position) || other.position == position)&&(identical(other.score, score) || other.score == score)&&(identical(other.characterLevel, characterLevel) || other.characterLevel == characterLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,score,characterLevel);

@override
String toString() {
  return 'MyPronunciationRankingInfo(position: $position, score: $score, characterLevel: $characterLevel)';
}


}

/// @nodoc
abstract mixin class $MyPronunciationRankingInfoCopyWith<$Res>  {
  factory $MyPronunciationRankingInfoCopyWith(MyPronunciationRankingInfo value, $Res Function(MyPronunciationRankingInfo) _then) = _$MyPronunciationRankingInfoCopyWithImpl;
@useResult
$Res call({
 int position, int score, int characterLevel
});




}
/// @nodoc
class _$MyPronunciationRankingInfoCopyWithImpl<$Res>
    implements $MyPronunciationRankingInfoCopyWith<$Res> {
  _$MyPronunciationRankingInfoCopyWithImpl(this._self, this._then);

  final MyPronunciationRankingInfo _self;
  final $Res Function(MyPronunciationRankingInfo) _then;

/// Create a copy of MyPronunciationRankingInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? position = null,Object? score = null,Object? characterLevel = null,}) {
  return _then(_self.copyWith(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,characterLevel: null == characterLevel ? _self.characterLevel : characterLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MyPronunciationRankingInfo].
extension MyPronunciationRankingInfoPatterns on MyPronunciationRankingInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyPronunciationRankingInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyPronunciationRankingInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyPronunciationRankingInfo value)  $default,){
final _that = this;
switch (_that) {
case _MyPronunciationRankingInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyPronunciationRankingInfo value)?  $default,){
final _that = this;
switch (_that) {
case _MyPronunciationRankingInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int position,  int score,  int characterLevel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyPronunciationRankingInfo() when $default != null:
return $default(_that.position,_that.score,_that.characterLevel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int position,  int score,  int characterLevel)  $default,) {final _that = this;
switch (_that) {
case _MyPronunciationRankingInfo():
return $default(_that.position,_that.score,_that.characterLevel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int position,  int score,  int characterLevel)?  $default,) {final _that = this;
switch (_that) {
case _MyPronunciationRankingInfo() when $default != null:
return $default(_that.position,_that.score,_that.characterLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyPronunciationRankingInfo implements MyPronunciationRankingInfo {
  const _MyPronunciationRankingInfo({required this.position, required this.score, required this.characterLevel});
  factory _MyPronunciationRankingInfo.fromJson(Map<String, dynamic> json) => _$MyPronunciationRankingInfoFromJson(json);

@override final  int position;
@override final  int score;
@override final  int characterLevel;

/// Create a copy of MyPronunciationRankingInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyPronunciationRankingInfoCopyWith<_MyPronunciationRankingInfo> get copyWith => __$MyPronunciationRankingInfoCopyWithImpl<_MyPronunciationRankingInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyPronunciationRankingInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyPronunciationRankingInfo&&(identical(other.position, position) || other.position == position)&&(identical(other.score, score) || other.score == score)&&(identical(other.characterLevel, characterLevel) || other.characterLevel == characterLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,score,characterLevel);

@override
String toString() {
  return 'MyPronunciationRankingInfo(position: $position, score: $score, characterLevel: $characterLevel)';
}


}

/// @nodoc
abstract mixin class _$MyPronunciationRankingInfoCopyWith<$Res> implements $MyPronunciationRankingInfoCopyWith<$Res> {
  factory _$MyPronunciationRankingInfoCopyWith(_MyPronunciationRankingInfo value, $Res Function(_MyPronunciationRankingInfo) _then) = __$MyPronunciationRankingInfoCopyWithImpl;
@override @useResult
$Res call({
 int position, int score, int characterLevel
});




}
/// @nodoc
class __$MyPronunciationRankingInfoCopyWithImpl<$Res>
    implements _$MyPronunciationRankingInfoCopyWith<$Res> {
  __$MyPronunciationRankingInfoCopyWithImpl(this._self, this._then);

  final _MyPronunciationRankingInfo _self;
  final $Res Function(_MyPronunciationRankingInfo) _then;

/// Create a copy of MyPronunciationRankingInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? position = null,Object? score = null,Object? characterLevel = null,}) {
  return _then(_MyPronunciationRankingInfo(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,characterLevel: null == characterLevel ? _self.characterLevel : characterLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PronunciationRankingDataResponse {

 PronunciationRankingPeriodInfo get period; List<PronunciationRankingEntry> get rankings; MyPronunciationRankingInfo? get myRanking; int get totalParticipants;
/// Create a copy of PronunciationRankingDataResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PronunciationRankingDataResponseCopyWith<PronunciationRankingDataResponse> get copyWith => _$PronunciationRankingDataResponseCopyWithImpl<PronunciationRankingDataResponse>(this as PronunciationRankingDataResponse, _$identity);

  /// Serializes this PronunciationRankingDataResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PronunciationRankingDataResponse&&(identical(other.period, period) || other.period == period)&&const DeepCollectionEquality().equals(other.rankings, rankings)&&(identical(other.myRanking, myRanking) || other.myRanking == myRanking)&&(identical(other.totalParticipants, totalParticipants) || other.totalParticipants == totalParticipants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,period,const DeepCollectionEquality().hash(rankings),myRanking,totalParticipants);

@override
String toString() {
  return 'PronunciationRankingDataResponse(period: $period, rankings: $rankings, myRanking: $myRanking, totalParticipants: $totalParticipants)';
}


}

/// @nodoc
abstract mixin class $PronunciationRankingDataResponseCopyWith<$Res>  {
  factory $PronunciationRankingDataResponseCopyWith(PronunciationRankingDataResponse value, $Res Function(PronunciationRankingDataResponse) _then) = _$PronunciationRankingDataResponseCopyWithImpl;
@useResult
$Res call({
 PronunciationRankingPeriodInfo period, List<PronunciationRankingEntry> rankings, MyPronunciationRankingInfo? myRanking, int totalParticipants
});


$PronunciationRankingPeriodInfoCopyWith<$Res> get period;$MyPronunciationRankingInfoCopyWith<$Res>? get myRanking;

}
/// @nodoc
class _$PronunciationRankingDataResponseCopyWithImpl<$Res>
    implements $PronunciationRankingDataResponseCopyWith<$Res> {
  _$PronunciationRankingDataResponseCopyWithImpl(this._self, this._then);

  final PronunciationRankingDataResponse _self;
  final $Res Function(PronunciationRankingDataResponse) _then;

/// Create a copy of PronunciationRankingDataResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? period = null,Object? rankings = null,Object? myRanking = freezed,Object? totalParticipants = null,}) {
  return _then(_self.copyWith(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as PronunciationRankingPeriodInfo,rankings: null == rankings ? _self.rankings : rankings // ignore: cast_nullable_to_non_nullable
as List<PronunciationRankingEntry>,myRanking: freezed == myRanking ? _self.myRanking : myRanking // ignore: cast_nullable_to_non_nullable
as MyPronunciationRankingInfo?,totalParticipants: null == totalParticipants ? _self.totalParticipants : totalParticipants // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of PronunciationRankingDataResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PronunciationRankingPeriodInfoCopyWith<$Res> get period {
  
  return $PronunciationRankingPeriodInfoCopyWith<$Res>(_self.period, (value) {
    return _then(_self.copyWith(period: value));
  });
}/// Create a copy of PronunciationRankingDataResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyPronunciationRankingInfoCopyWith<$Res>? get myRanking {
    if (_self.myRanking == null) {
    return null;
  }

  return $MyPronunciationRankingInfoCopyWith<$Res>(_self.myRanking!, (value) {
    return _then(_self.copyWith(myRanking: value));
  });
}
}


/// Adds pattern-matching-related methods to [PronunciationRankingDataResponse].
extension PronunciationRankingDataResponsePatterns on PronunciationRankingDataResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PronunciationRankingDataResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PronunciationRankingDataResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PronunciationRankingDataResponse value)  $default,){
final _that = this;
switch (_that) {
case _PronunciationRankingDataResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PronunciationRankingDataResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PronunciationRankingDataResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PronunciationRankingPeriodInfo period,  List<PronunciationRankingEntry> rankings,  MyPronunciationRankingInfo? myRanking,  int totalParticipants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PronunciationRankingDataResponse() when $default != null:
return $default(_that.period,_that.rankings,_that.myRanking,_that.totalParticipants);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PronunciationRankingPeriodInfo period,  List<PronunciationRankingEntry> rankings,  MyPronunciationRankingInfo? myRanking,  int totalParticipants)  $default,) {final _that = this;
switch (_that) {
case _PronunciationRankingDataResponse():
return $default(_that.period,_that.rankings,_that.myRanking,_that.totalParticipants);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PronunciationRankingPeriodInfo period,  List<PronunciationRankingEntry> rankings,  MyPronunciationRankingInfo? myRanking,  int totalParticipants)?  $default,) {final _that = this;
switch (_that) {
case _PronunciationRankingDataResponse() when $default != null:
return $default(_that.period,_that.rankings,_that.myRanking,_that.totalParticipants);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PronunciationRankingDataResponse implements PronunciationRankingDataResponse {
  const _PronunciationRankingDataResponse({required this.period, final  List<PronunciationRankingEntry> rankings = const <PronunciationRankingEntry>[], this.myRanking, required this.totalParticipants}): _rankings = rankings;
  factory _PronunciationRankingDataResponse.fromJson(Map<String, dynamic> json) => _$PronunciationRankingDataResponseFromJson(json);

@override final  PronunciationRankingPeriodInfo period;
 final  List<PronunciationRankingEntry> _rankings;
@override@JsonKey() List<PronunciationRankingEntry> get rankings {
  if (_rankings is EqualUnmodifiableListView) return _rankings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rankings);
}

@override final  MyPronunciationRankingInfo? myRanking;
@override final  int totalParticipants;

/// Create a copy of PronunciationRankingDataResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PronunciationRankingDataResponseCopyWith<_PronunciationRankingDataResponse> get copyWith => __$PronunciationRankingDataResponseCopyWithImpl<_PronunciationRankingDataResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PronunciationRankingDataResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PronunciationRankingDataResponse&&(identical(other.period, period) || other.period == period)&&const DeepCollectionEquality().equals(other._rankings, _rankings)&&(identical(other.myRanking, myRanking) || other.myRanking == myRanking)&&(identical(other.totalParticipants, totalParticipants) || other.totalParticipants == totalParticipants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,period,const DeepCollectionEquality().hash(_rankings),myRanking,totalParticipants);

@override
String toString() {
  return 'PronunciationRankingDataResponse(period: $period, rankings: $rankings, myRanking: $myRanking, totalParticipants: $totalParticipants)';
}


}

/// @nodoc
abstract mixin class _$PronunciationRankingDataResponseCopyWith<$Res> implements $PronunciationRankingDataResponseCopyWith<$Res> {
  factory _$PronunciationRankingDataResponseCopyWith(_PronunciationRankingDataResponse value, $Res Function(_PronunciationRankingDataResponse) _then) = __$PronunciationRankingDataResponseCopyWithImpl;
@override @useResult
$Res call({
 PronunciationRankingPeriodInfo period, List<PronunciationRankingEntry> rankings, MyPronunciationRankingInfo? myRanking, int totalParticipants
});


@override $PronunciationRankingPeriodInfoCopyWith<$Res> get period;@override $MyPronunciationRankingInfoCopyWith<$Res>? get myRanking;

}
/// @nodoc
class __$PronunciationRankingDataResponseCopyWithImpl<$Res>
    implements _$PronunciationRankingDataResponseCopyWith<$Res> {
  __$PronunciationRankingDataResponseCopyWithImpl(this._self, this._then);

  final _PronunciationRankingDataResponse _self;
  final $Res Function(_PronunciationRankingDataResponse) _then;

/// Create a copy of PronunciationRankingDataResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? period = null,Object? rankings = null,Object? myRanking = freezed,Object? totalParticipants = null,}) {
  return _then(_PronunciationRankingDataResponse(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as PronunciationRankingPeriodInfo,rankings: null == rankings ? _self._rankings : rankings // ignore: cast_nullable_to_non_nullable
as List<PronunciationRankingEntry>,myRanking: freezed == myRanking ? _self.myRanking : myRanking // ignore: cast_nullable_to_non_nullable
as MyPronunciationRankingInfo?,totalParticipants: null == totalParticipants ? _self.totalParticipants : totalParticipants // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of PronunciationRankingDataResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PronunciationRankingPeriodInfoCopyWith<$Res> get period {
  
  return $PronunciationRankingPeriodInfoCopyWith<$Res>(_self.period, (value) {
    return _then(_self.copyWith(period: value));
  });
}/// Create a copy of PronunciationRankingDataResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyPronunciationRankingInfoCopyWith<$Res>? get myRanking {
    if (_self.myRanking == null) {
    return null;
  }

  return $MyPronunciationRankingInfoCopyWith<$Res>(_self.myRanking!, (value) {
    return _then(_self.copyWith(myRanking: value));
  });
}
}


/// @nodoc
mixin _$PronunciationBestScoreByDifficulty {

 int get all; int get beginner; int get intermediate; int get advanced;
/// Create a copy of PronunciationBestScoreByDifficulty
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PronunciationBestScoreByDifficultyCopyWith<PronunciationBestScoreByDifficulty> get copyWith => _$PronunciationBestScoreByDifficultyCopyWithImpl<PronunciationBestScoreByDifficulty>(this as PronunciationBestScoreByDifficulty, _$identity);

  /// Serializes this PronunciationBestScoreByDifficulty to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PronunciationBestScoreByDifficulty&&(identical(other.all, all) || other.all == all)&&(identical(other.beginner, beginner) || other.beginner == beginner)&&(identical(other.intermediate, intermediate) || other.intermediate == intermediate)&&(identical(other.advanced, advanced) || other.advanced == advanced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,all,beginner,intermediate,advanced);

@override
String toString() {
  return 'PronunciationBestScoreByDifficulty(all: $all, beginner: $beginner, intermediate: $intermediate, advanced: $advanced)';
}


}

/// @nodoc
abstract mixin class $PronunciationBestScoreByDifficultyCopyWith<$Res>  {
  factory $PronunciationBestScoreByDifficultyCopyWith(PronunciationBestScoreByDifficulty value, $Res Function(PronunciationBestScoreByDifficulty) _then) = _$PronunciationBestScoreByDifficultyCopyWithImpl;
@useResult
$Res call({
 int all, int beginner, int intermediate, int advanced
});




}
/// @nodoc
class _$PronunciationBestScoreByDifficultyCopyWithImpl<$Res>
    implements $PronunciationBestScoreByDifficultyCopyWith<$Res> {
  _$PronunciationBestScoreByDifficultyCopyWithImpl(this._self, this._then);

  final PronunciationBestScoreByDifficulty _self;
  final $Res Function(PronunciationBestScoreByDifficulty) _then;

/// Create a copy of PronunciationBestScoreByDifficulty
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? all = null,Object? beginner = null,Object? intermediate = null,Object? advanced = null,}) {
  return _then(_self.copyWith(
all: null == all ? _self.all : all // ignore: cast_nullable_to_non_nullable
as int,beginner: null == beginner ? _self.beginner : beginner // ignore: cast_nullable_to_non_nullable
as int,intermediate: null == intermediate ? _self.intermediate : intermediate // ignore: cast_nullable_to_non_nullable
as int,advanced: null == advanced ? _self.advanced : advanced // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PronunciationBestScoreByDifficulty].
extension PronunciationBestScoreByDifficultyPatterns on PronunciationBestScoreByDifficulty {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PronunciationBestScoreByDifficulty value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PronunciationBestScoreByDifficulty() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PronunciationBestScoreByDifficulty value)  $default,){
final _that = this;
switch (_that) {
case _PronunciationBestScoreByDifficulty():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PronunciationBestScoreByDifficulty value)?  $default,){
final _that = this;
switch (_that) {
case _PronunciationBestScoreByDifficulty() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int all,  int beginner,  int intermediate,  int advanced)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PronunciationBestScoreByDifficulty() when $default != null:
return $default(_that.all,_that.beginner,_that.intermediate,_that.advanced);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int all,  int beginner,  int intermediate,  int advanced)  $default,) {final _that = this;
switch (_that) {
case _PronunciationBestScoreByDifficulty():
return $default(_that.all,_that.beginner,_that.intermediate,_that.advanced);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int all,  int beginner,  int intermediate,  int advanced)?  $default,) {final _that = this;
switch (_that) {
case _PronunciationBestScoreByDifficulty() when $default != null:
return $default(_that.all,_that.beginner,_that.intermediate,_that.advanced);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PronunciationBestScoreByDifficulty implements PronunciationBestScoreByDifficulty {
  const _PronunciationBestScoreByDifficulty({required this.all, required this.beginner, required this.intermediate, required this.advanced});
  factory _PronunciationBestScoreByDifficulty.fromJson(Map<String, dynamic> json) => _$PronunciationBestScoreByDifficultyFromJson(json);

@override final  int all;
@override final  int beginner;
@override final  int intermediate;
@override final  int advanced;

/// Create a copy of PronunciationBestScoreByDifficulty
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PronunciationBestScoreByDifficultyCopyWith<_PronunciationBestScoreByDifficulty> get copyWith => __$PronunciationBestScoreByDifficultyCopyWithImpl<_PronunciationBestScoreByDifficulty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PronunciationBestScoreByDifficultyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PronunciationBestScoreByDifficulty&&(identical(other.all, all) || other.all == all)&&(identical(other.beginner, beginner) || other.beginner == beginner)&&(identical(other.intermediate, intermediate) || other.intermediate == intermediate)&&(identical(other.advanced, advanced) || other.advanced == advanced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,all,beginner,intermediate,advanced);

@override
String toString() {
  return 'PronunciationBestScoreByDifficulty(all: $all, beginner: $beginner, intermediate: $intermediate, advanced: $advanced)';
}


}

/// @nodoc
abstract mixin class _$PronunciationBestScoreByDifficultyCopyWith<$Res> implements $PronunciationBestScoreByDifficultyCopyWith<$Res> {
  factory _$PronunciationBestScoreByDifficultyCopyWith(_PronunciationBestScoreByDifficulty value, $Res Function(_PronunciationBestScoreByDifficulty) _then) = __$PronunciationBestScoreByDifficultyCopyWithImpl;
@override @useResult
$Res call({
 int all, int beginner, int intermediate, int advanced
});




}
/// @nodoc
class __$PronunciationBestScoreByDifficultyCopyWithImpl<$Res>
    implements _$PronunciationBestScoreByDifficultyCopyWith<$Res> {
  __$PronunciationBestScoreByDifficultyCopyWithImpl(this._self, this._then);

  final _PronunciationBestScoreByDifficulty _self;
  final $Res Function(_PronunciationBestScoreByDifficulty) _then;

/// Create a copy of PronunciationBestScoreByDifficulty
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? all = null,Object? beginner = null,Object? intermediate = null,Object? advanced = null,}) {
  return _then(_PronunciationBestScoreByDifficulty(
all: null == all ? _self.all : all // ignore: cast_nullable_to_non_nullable
as int,beginner: null == beginner ? _self.beginner : beginner // ignore: cast_nullable_to_non_nullable
as int,intermediate: null == intermediate ? _self.intermediate : intermediate // ignore: cast_nullable_to_non_nullable
as int,advanced: null == advanced ? _self.advanced : advanced // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PronunciationMonthlyRankingByDifficulty {

 int? get all; int? get beginner; int? get intermediate; int? get advanced;
/// Create a copy of PronunciationMonthlyRankingByDifficulty
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PronunciationMonthlyRankingByDifficultyCopyWith<PronunciationMonthlyRankingByDifficulty> get copyWith => _$PronunciationMonthlyRankingByDifficultyCopyWithImpl<PronunciationMonthlyRankingByDifficulty>(this as PronunciationMonthlyRankingByDifficulty, _$identity);

  /// Serializes this PronunciationMonthlyRankingByDifficulty to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PronunciationMonthlyRankingByDifficulty&&(identical(other.all, all) || other.all == all)&&(identical(other.beginner, beginner) || other.beginner == beginner)&&(identical(other.intermediate, intermediate) || other.intermediate == intermediate)&&(identical(other.advanced, advanced) || other.advanced == advanced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,all,beginner,intermediate,advanced);

@override
String toString() {
  return 'PronunciationMonthlyRankingByDifficulty(all: $all, beginner: $beginner, intermediate: $intermediate, advanced: $advanced)';
}


}

/// @nodoc
abstract mixin class $PronunciationMonthlyRankingByDifficultyCopyWith<$Res>  {
  factory $PronunciationMonthlyRankingByDifficultyCopyWith(PronunciationMonthlyRankingByDifficulty value, $Res Function(PronunciationMonthlyRankingByDifficulty) _then) = _$PronunciationMonthlyRankingByDifficultyCopyWithImpl;
@useResult
$Res call({
 int? all, int? beginner, int? intermediate, int? advanced
});




}
/// @nodoc
class _$PronunciationMonthlyRankingByDifficultyCopyWithImpl<$Res>
    implements $PronunciationMonthlyRankingByDifficultyCopyWith<$Res> {
  _$PronunciationMonthlyRankingByDifficultyCopyWithImpl(this._self, this._then);

  final PronunciationMonthlyRankingByDifficulty _self;
  final $Res Function(PronunciationMonthlyRankingByDifficulty) _then;

/// Create a copy of PronunciationMonthlyRankingByDifficulty
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? all = freezed,Object? beginner = freezed,Object? intermediate = freezed,Object? advanced = freezed,}) {
  return _then(_self.copyWith(
all: freezed == all ? _self.all : all // ignore: cast_nullable_to_non_nullable
as int?,beginner: freezed == beginner ? _self.beginner : beginner // ignore: cast_nullable_to_non_nullable
as int?,intermediate: freezed == intermediate ? _self.intermediate : intermediate // ignore: cast_nullable_to_non_nullable
as int?,advanced: freezed == advanced ? _self.advanced : advanced // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PronunciationMonthlyRankingByDifficulty].
extension PronunciationMonthlyRankingByDifficultyPatterns on PronunciationMonthlyRankingByDifficulty {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PronunciationMonthlyRankingByDifficulty value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PronunciationMonthlyRankingByDifficulty() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PronunciationMonthlyRankingByDifficulty value)  $default,){
final _that = this;
switch (_that) {
case _PronunciationMonthlyRankingByDifficulty():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PronunciationMonthlyRankingByDifficulty value)?  $default,){
final _that = this;
switch (_that) {
case _PronunciationMonthlyRankingByDifficulty() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? all,  int? beginner,  int? intermediate,  int? advanced)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PronunciationMonthlyRankingByDifficulty() when $default != null:
return $default(_that.all,_that.beginner,_that.intermediate,_that.advanced);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? all,  int? beginner,  int? intermediate,  int? advanced)  $default,) {final _that = this;
switch (_that) {
case _PronunciationMonthlyRankingByDifficulty():
return $default(_that.all,_that.beginner,_that.intermediate,_that.advanced);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? all,  int? beginner,  int? intermediate,  int? advanced)?  $default,) {final _that = this;
switch (_that) {
case _PronunciationMonthlyRankingByDifficulty() when $default != null:
return $default(_that.all,_that.beginner,_that.intermediate,_that.advanced);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PronunciationMonthlyRankingByDifficulty implements PronunciationMonthlyRankingByDifficulty {
  const _PronunciationMonthlyRankingByDifficulty({this.all, this.beginner, this.intermediate, this.advanced});
  factory _PronunciationMonthlyRankingByDifficulty.fromJson(Map<String, dynamic> json) => _$PronunciationMonthlyRankingByDifficultyFromJson(json);

@override final  int? all;
@override final  int? beginner;
@override final  int? intermediate;
@override final  int? advanced;

/// Create a copy of PronunciationMonthlyRankingByDifficulty
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PronunciationMonthlyRankingByDifficultyCopyWith<_PronunciationMonthlyRankingByDifficulty> get copyWith => __$PronunciationMonthlyRankingByDifficultyCopyWithImpl<_PronunciationMonthlyRankingByDifficulty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PronunciationMonthlyRankingByDifficultyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PronunciationMonthlyRankingByDifficulty&&(identical(other.all, all) || other.all == all)&&(identical(other.beginner, beginner) || other.beginner == beginner)&&(identical(other.intermediate, intermediate) || other.intermediate == intermediate)&&(identical(other.advanced, advanced) || other.advanced == advanced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,all,beginner,intermediate,advanced);

@override
String toString() {
  return 'PronunciationMonthlyRankingByDifficulty(all: $all, beginner: $beginner, intermediate: $intermediate, advanced: $advanced)';
}


}

/// @nodoc
abstract mixin class _$PronunciationMonthlyRankingByDifficultyCopyWith<$Res> implements $PronunciationMonthlyRankingByDifficultyCopyWith<$Res> {
  factory _$PronunciationMonthlyRankingByDifficultyCopyWith(_PronunciationMonthlyRankingByDifficulty value, $Res Function(_PronunciationMonthlyRankingByDifficulty) _then) = __$PronunciationMonthlyRankingByDifficultyCopyWithImpl;
@override @useResult
$Res call({
 int? all, int? beginner, int? intermediate, int? advanced
});




}
/// @nodoc
class __$PronunciationMonthlyRankingByDifficultyCopyWithImpl<$Res>
    implements _$PronunciationMonthlyRankingByDifficultyCopyWith<$Res> {
  __$PronunciationMonthlyRankingByDifficultyCopyWithImpl(this._self, this._then);

  final _PronunciationMonthlyRankingByDifficulty _self;
  final $Res Function(_PronunciationMonthlyRankingByDifficulty) _then;

/// Create a copy of PronunciationMonthlyRankingByDifficulty
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? all = freezed,Object? beginner = freezed,Object? intermediate = freezed,Object? advanced = freezed,}) {
  return _then(_PronunciationMonthlyRankingByDifficulty(
all: freezed == all ? _self.all : all // ignore: cast_nullable_to_non_nullable
as int?,beginner: freezed == beginner ? _self.beginner : beginner // ignore: cast_nullable_to_non_nullable
as int?,intermediate: freezed == intermediate ? _self.intermediate : intermediate // ignore: cast_nullable_to_non_nullable
as int?,advanced: freezed == advanced ? _self.advanced : advanced // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$PronunciationGameAchievements {

 int get maxCombo; int get maxCharacterLevel; int get totalBonusTimeEarned;
/// Create a copy of PronunciationGameAchievements
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PronunciationGameAchievementsCopyWith<PronunciationGameAchievements> get copyWith => _$PronunciationGameAchievementsCopyWithImpl<PronunciationGameAchievements>(this as PronunciationGameAchievements, _$identity);

  /// Serializes this PronunciationGameAchievements to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PronunciationGameAchievements&&(identical(other.maxCombo, maxCombo) || other.maxCombo == maxCombo)&&(identical(other.maxCharacterLevel, maxCharacterLevel) || other.maxCharacterLevel == maxCharacterLevel)&&(identical(other.totalBonusTimeEarned, totalBonusTimeEarned) || other.totalBonusTimeEarned == totalBonusTimeEarned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,maxCombo,maxCharacterLevel,totalBonusTimeEarned);

@override
String toString() {
  return 'PronunciationGameAchievements(maxCombo: $maxCombo, maxCharacterLevel: $maxCharacterLevel, totalBonusTimeEarned: $totalBonusTimeEarned)';
}


}

/// @nodoc
abstract mixin class $PronunciationGameAchievementsCopyWith<$Res>  {
  factory $PronunciationGameAchievementsCopyWith(PronunciationGameAchievements value, $Res Function(PronunciationGameAchievements) _then) = _$PronunciationGameAchievementsCopyWithImpl;
@useResult
$Res call({
 int maxCombo, int maxCharacterLevel, int totalBonusTimeEarned
});




}
/// @nodoc
class _$PronunciationGameAchievementsCopyWithImpl<$Res>
    implements $PronunciationGameAchievementsCopyWith<$Res> {
  _$PronunciationGameAchievementsCopyWithImpl(this._self, this._then);

  final PronunciationGameAchievements _self;
  final $Res Function(PronunciationGameAchievements) _then;

/// Create a copy of PronunciationGameAchievements
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? maxCombo = null,Object? maxCharacterLevel = null,Object? totalBonusTimeEarned = null,}) {
  return _then(_self.copyWith(
maxCombo: null == maxCombo ? _self.maxCombo : maxCombo // ignore: cast_nullable_to_non_nullable
as int,maxCharacterLevel: null == maxCharacterLevel ? _self.maxCharacterLevel : maxCharacterLevel // ignore: cast_nullable_to_non_nullable
as int,totalBonusTimeEarned: null == totalBonusTimeEarned ? _self.totalBonusTimeEarned : totalBonusTimeEarned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PronunciationGameAchievements].
extension PronunciationGameAchievementsPatterns on PronunciationGameAchievements {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PronunciationGameAchievements value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PronunciationGameAchievements() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PronunciationGameAchievements value)  $default,){
final _that = this;
switch (_that) {
case _PronunciationGameAchievements():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PronunciationGameAchievements value)?  $default,){
final _that = this;
switch (_that) {
case _PronunciationGameAchievements() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int maxCombo,  int maxCharacterLevel,  int totalBonusTimeEarned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PronunciationGameAchievements() when $default != null:
return $default(_that.maxCombo,_that.maxCharacterLevel,_that.totalBonusTimeEarned);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int maxCombo,  int maxCharacterLevel,  int totalBonusTimeEarned)  $default,) {final _that = this;
switch (_that) {
case _PronunciationGameAchievements():
return $default(_that.maxCombo,_that.maxCharacterLevel,_that.totalBonusTimeEarned);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int maxCombo,  int maxCharacterLevel,  int totalBonusTimeEarned)?  $default,) {final _that = this;
switch (_that) {
case _PronunciationGameAchievements() when $default != null:
return $default(_that.maxCombo,_that.maxCharacterLevel,_that.totalBonusTimeEarned);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PronunciationGameAchievements implements PronunciationGameAchievements {
  const _PronunciationGameAchievements({required this.maxCombo, required this.maxCharacterLevel, required this.totalBonusTimeEarned});
  factory _PronunciationGameAchievements.fromJson(Map<String, dynamic> json) => _$PronunciationGameAchievementsFromJson(json);

@override final  int maxCombo;
@override final  int maxCharacterLevel;
@override final  int totalBonusTimeEarned;

/// Create a copy of PronunciationGameAchievements
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PronunciationGameAchievementsCopyWith<_PronunciationGameAchievements> get copyWith => __$PronunciationGameAchievementsCopyWithImpl<_PronunciationGameAchievements>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PronunciationGameAchievementsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PronunciationGameAchievements&&(identical(other.maxCombo, maxCombo) || other.maxCombo == maxCombo)&&(identical(other.maxCharacterLevel, maxCharacterLevel) || other.maxCharacterLevel == maxCharacterLevel)&&(identical(other.totalBonusTimeEarned, totalBonusTimeEarned) || other.totalBonusTimeEarned == totalBonusTimeEarned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,maxCombo,maxCharacterLevel,totalBonusTimeEarned);

@override
String toString() {
  return 'PronunciationGameAchievements(maxCombo: $maxCombo, maxCharacterLevel: $maxCharacterLevel, totalBonusTimeEarned: $totalBonusTimeEarned)';
}


}

/// @nodoc
abstract mixin class _$PronunciationGameAchievementsCopyWith<$Res> implements $PronunciationGameAchievementsCopyWith<$Res> {
  factory _$PronunciationGameAchievementsCopyWith(_PronunciationGameAchievements value, $Res Function(_PronunciationGameAchievements) _then) = __$PronunciationGameAchievementsCopyWithImpl;
@override @useResult
$Res call({
 int maxCombo, int maxCharacterLevel, int totalBonusTimeEarned
});




}
/// @nodoc
class __$PronunciationGameAchievementsCopyWithImpl<$Res>
    implements _$PronunciationGameAchievementsCopyWith<$Res> {
  __$PronunciationGameAchievementsCopyWithImpl(this._self, this._then);

  final _PronunciationGameAchievements _self;
  final $Res Function(_PronunciationGameAchievements) _then;

/// Create a copy of PronunciationGameAchievements
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? maxCombo = null,Object? maxCharacterLevel = null,Object? totalBonusTimeEarned = null,}) {
  return _then(_PronunciationGameAchievements(
maxCombo: null == maxCombo ? _self.maxCombo : maxCombo // ignore: cast_nullable_to_non_nullable
as int,maxCharacterLevel: null == maxCharacterLevel ? _self.maxCharacterLevel : maxCharacterLevel // ignore: cast_nullable_to_non_nullable
as int,totalBonusTimeEarned: null == totalBonusTimeEarned ? _self.totalBonusTimeEarned : totalBonusTimeEarned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PronunciationGameUserStats {

 int get totalPlays; PronunciationBestScoreByDifficulty get bestScore; PronunciationMonthlyRankingByDifficulty get monthlyRanking; PronunciationGameAchievements get achievements; List<PronunciationGameResult> get recentResults;
/// Create a copy of PronunciationGameUserStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PronunciationGameUserStatsCopyWith<PronunciationGameUserStats> get copyWith => _$PronunciationGameUserStatsCopyWithImpl<PronunciationGameUserStats>(this as PronunciationGameUserStats, _$identity);

  /// Serializes this PronunciationGameUserStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PronunciationGameUserStats&&(identical(other.totalPlays, totalPlays) || other.totalPlays == totalPlays)&&(identical(other.bestScore, bestScore) || other.bestScore == bestScore)&&(identical(other.monthlyRanking, monthlyRanking) || other.monthlyRanking == monthlyRanking)&&(identical(other.achievements, achievements) || other.achievements == achievements)&&const DeepCollectionEquality().equals(other.recentResults, recentResults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalPlays,bestScore,monthlyRanking,achievements,const DeepCollectionEquality().hash(recentResults));

@override
String toString() {
  return 'PronunciationGameUserStats(totalPlays: $totalPlays, bestScore: $bestScore, monthlyRanking: $monthlyRanking, achievements: $achievements, recentResults: $recentResults)';
}


}

/// @nodoc
abstract mixin class $PronunciationGameUserStatsCopyWith<$Res>  {
  factory $PronunciationGameUserStatsCopyWith(PronunciationGameUserStats value, $Res Function(PronunciationGameUserStats) _then) = _$PronunciationGameUserStatsCopyWithImpl;
@useResult
$Res call({
 int totalPlays, PronunciationBestScoreByDifficulty bestScore, PronunciationMonthlyRankingByDifficulty monthlyRanking, PronunciationGameAchievements achievements, List<PronunciationGameResult> recentResults
});


$PronunciationBestScoreByDifficultyCopyWith<$Res> get bestScore;$PronunciationMonthlyRankingByDifficultyCopyWith<$Res> get monthlyRanking;$PronunciationGameAchievementsCopyWith<$Res> get achievements;

}
/// @nodoc
class _$PronunciationGameUserStatsCopyWithImpl<$Res>
    implements $PronunciationGameUserStatsCopyWith<$Res> {
  _$PronunciationGameUserStatsCopyWithImpl(this._self, this._then);

  final PronunciationGameUserStats _self;
  final $Res Function(PronunciationGameUserStats) _then;

/// Create a copy of PronunciationGameUserStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalPlays = null,Object? bestScore = null,Object? monthlyRanking = null,Object? achievements = null,Object? recentResults = null,}) {
  return _then(_self.copyWith(
totalPlays: null == totalPlays ? _self.totalPlays : totalPlays // ignore: cast_nullable_to_non_nullable
as int,bestScore: null == bestScore ? _self.bestScore : bestScore // ignore: cast_nullable_to_non_nullable
as PronunciationBestScoreByDifficulty,monthlyRanking: null == monthlyRanking ? _self.monthlyRanking : monthlyRanking // ignore: cast_nullable_to_non_nullable
as PronunciationMonthlyRankingByDifficulty,achievements: null == achievements ? _self.achievements : achievements // ignore: cast_nullable_to_non_nullable
as PronunciationGameAchievements,recentResults: null == recentResults ? _self.recentResults : recentResults // ignore: cast_nullable_to_non_nullable
as List<PronunciationGameResult>,
  ));
}
/// Create a copy of PronunciationGameUserStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PronunciationBestScoreByDifficultyCopyWith<$Res> get bestScore {
  
  return $PronunciationBestScoreByDifficultyCopyWith<$Res>(_self.bestScore, (value) {
    return _then(_self.copyWith(bestScore: value));
  });
}/// Create a copy of PronunciationGameUserStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PronunciationMonthlyRankingByDifficultyCopyWith<$Res> get monthlyRanking {
  
  return $PronunciationMonthlyRankingByDifficultyCopyWith<$Res>(_self.monthlyRanking, (value) {
    return _then(_self.copyWith(monthlyRanking: value));
  });
}/// Create a copy of PronunciationGameUserStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PronunciationGameAchievementsCopyWith<$Res> get achievements {
  
  return $PronunciationGameAchievementsCopyWith<$Res>(_self.achievements, (value) {
    return _then(_self.copyWith(achievements: value));
  });
}
}


/// Adds pattern-matching-related methods to [PronunciationGameUserStats].
extension PronunciationGameUserStatsPatterns on PronunciationGameUserStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PronunciationGameUserStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PronunciationGameUserStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PronunciationGameUserStats value)  $default,){
final _that = this;
switch (_that) {
case _PronunciationGameUserStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PronunciationGameUserStats value)?  $default,){
final _that = this;
switch (_that) {
case _PronunciationGameUserStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalPlays,  PronunciationBestScoreByDifficulty bestScore,  PronunciationMonthlyRankingByDifficulty monthlyRanking,  PronunciationGameAchievements achievements,  List<PronunciationGameResult> recentResults)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PronunciationGameUserStats() when $default != null:
return $default(_that.totalPlays,_that.bestScore,_that.monthlyRanking,_that.achievements,_that.recentResults);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalPlays,  PronunciationBestScoreByDifficulty bestScore,  PronunciationMonthlyRankingByDifficulty monthlyRanking,  PronunciationGameAchievements achievements,  List<PronunciationGameResult> recentResults)  $default,) {final _that = this;
switch (_that) {
case _PronunciationGameUserStats():
return $default(_that.totalPlays,_that.bestScore,_that.monthlyRanking,_that.achievements,_that.recentResults);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalPlays,  PronunciationBestScoreByDifficulty bestScore,  PronunciationMonthlyRankingByDifficulty monthlyRanking,  PronunciationGameAchievements achievements,  List<PronunciationGameResult> recentResults)?  $default,) {final _that = this;
switch (_that) {
case _PronunciationGameUserStats() when $default != null:
return $default(_that.totalPlays,_that.bestScore,_that.monthlyRanking,_that.achievements,_that.recentResults);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PronunciationGameUserStats implements PronunciationGameUserStats {
  const _PronunciationGameUserStats({required this.totalPlays, required this.bestScore, required this.monthlyRanking, required this.achievements, final  List<PronunciationGameResult> recentResults = const <PronunciationGameResult>[]}): _recentResults = recentResults;
  factory _PronunciationGameUserStats.fromJson(Map<String, dynamic> json) => _$PronunciationGameUserStatsFromJson(json);

@override final  int totalPlays;
@override final  PronunciationBestScoreByDifficulty bestScore;
@override final  PronunciationMonthlyRankingByDifficulty monthlyRanking;
@override final  PronunciationGameAchievements achievements;
 final  List<PronunciationGameResult> _recentResults;
@override@JsonKey() List<PronunciationGameResult> get recentResults {
  if (_recentResults is EqualUnmodifiableListView) return _recentResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentResults);
}


/// Create a copy of PronunciationGameUserStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PronunciationGameUserStatsCopyWith<_PronunciationGameUserStats> get copyWith => __$PronunciationGameUserStatsCopyWithImpl<_PronunciationGameUserStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PronunciationGameUserStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PronunciationGameUserStats&&(identical(other.totalPlays, totalPlays) || other.totalPlays == totalPlays)&&(identical(other.bestScore, bestScore) || other.bestScore == bestScore)&&(identical(other.monthlyRanking, monthlyRanking) || other.monthlyRanking == monthlyRanking)&&(identical(other.achievements, achievements) || other.achievements == achievements)&&const DeepCollectionEquality().equals(other._recentResults, _recentResults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalPlays,bestScore,monthlyRanking,achievements,const DeepCollectionEquality().hash(_recentResults));

@override
String toString() {
  return 'PronunciationGameUserStats(totalPlays: $totalPlays, bestScore: $bestScore, monthlyRanking: $monthlyRanking, achievements: $achievements, recentResults: $recentResults)';
}


}

/// @nodoc
abstract mixin class _$PronunciationGameUserStatsCopyWith<$Res> implements $PronunciationGameUserStatsCopyWith<$Res> {
  factory _$PronunciationGameUserStatsCopyWith(_PronunciationGameUserStats value, $Res Function(_PronunciationGameUserStats) _then) = __$PronunciationGameUserStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalPlays, PronunciationBestScoreByDifficulty bestScore, PronunciationMonthlyRankingByDifficulty monthlyRanking, PronunciationGameAchievements achievements, List<PronunciationGameResult> recentResults
});


@override $PronunciationBestScoreByDifficultyCopyWith<$Res> get bestScore;@override $PronunciationMonthlyRankingByDifficultyCopyWith<$Res> get monthlyRanking;@override $PronunciationGameAchievementsCopyWith<$Res> get achievements;

}
/// @nodoc
class __$PronunciationGameUserStatsCopyWithImpl<$Res>
    implements _$PronunciationGameUserStatsCopyWith<$Res> {
  __$PronunciationGameUserStatsCopyWithImpl(this._self, this._then);

  final _PronunciationGameUserStats _self;
  final $Res Function(_PronunciationGameUserStats) _then;

/// Create a copy of PronunciationGameUserStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalPlays = null,Object? bestScore = null,Object? monthlyRanking = null,Object? achievements = null,Object? recentResults = null,}) {
  return _then(_PronunciationGameUserStats(
totalPlays: null == totalPlays ? _self.totalPlays : totalPlays // ignore: cast_nullable_to_non_nullable
as int,bestScore: null == bestScore ? _self.bestScore : bestScore // ignore: cast_nullable_to_non_nullable
as PronunciationBestScoreByDifficulty,monthlyRanking: null == monthlyRanking ? _self.monthlyRanking : monthlyRanking // ignore: cast_nullable_to_non_nullable
as PronunciationMonthlyRankingByDifficulty,achievements: null == achievements ? _self.achievements : achievements // ignore: cast_nullable_to_non_nullable
as PronunciationGameAchievements,recentResults: null == recentResults ? _self._recentResults : recentResults // ignore: cast_nullable_to_non_nullable
as List<PronunciationGameResult>,
  ));
}

/// Create a copy of PronunciationGameUserStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PronunciationBestScoreByDifficultyCopyWith<$Res> get bestScore {
  
  return $PronunciationBestScoreByDifficultyCopyWith<$Res>(_self.bestScore, (value) {
    return _then(_self.copyWith(bestScore: value));
  });
}/// Create a copy of PronunciationGameUserStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PronunciationMonthlyRankingByDifficultyCopyWith<$Res> get monthlyRanking {
  
  return $PronunciationMonthlyRankingByDifficultyCopyWith<$Res>(_self.monthlyRanking, (value) {
    return _then(_self.copyWith(monthlyRanking: value));
  });
}/// Create a copy of PronunciationGameUserStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PronunciationGameAchievementsCopyWith<$Res> get achievements {
  
  return $PronunciationGameAchievementsCopyWith<$Res>(_self.achievements, (value) {
    return _then(_self.copyWith(achievements: value));
  });
}
}


/// @nodoc
mixin _$PronunciationGameStatsSummary {

 PronunciationBestScoreByDifficulty get bestScore;
/// Create a copy of PronunciationGameStatsSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PronunciationGameStatsSummaryCopyWith<PronunciationGameStatsSummary> get copyWith => _$PronunciationGameStatsSummaryCopyWithImpl<PronunciationGameStatsSummary>(this as PronunciationGameStatsSummary, _$identity);

  /// Serializes this PronunciationGameStatsSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PronunciationGameStatsSummary&&(identical(other.bestScore, bestScore) || other.bestScore == bestScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bestScore);

@override
String toString() {
  return 'PronunciationGameStatsSummary(bestScore: $bestScore)';
}


}

/// @nodoc
abstract mixin class $PronunciationGameStatsSummaryCopyWith<$Res>  {
  factory $PronunciationGameStatsSummaryCopyWith(PronunciationGameStatsSummary value, $Res Function(PronunciationGameStatsSummary) _then) = _$PronunciationGameStatsSummaryCopyWithImpl;
@useResult
$Res call({
 PronunciationBestScoreByDifficulty bestScore
});


$PronunciationBestScoreByDifficultyCopyWith<$Res> get bestScore;

}
/// @nodoc
class _$PronunciationGameStatsSummaryCopyWithImpl<$Res>
    implements $PronunciationGameStatsSummaryCopyWith<$Res> {
  _$PronunciationGameStatsSummaryCopyWithImpl(this._self, this._then);

  final PronunciationGameStatsSummary _self;
  final $Res Function(PronunciationGameStatsSummary) _then;

/// Create a copy of PronunciationGameStatsSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bestScore = null,}) {
  return _then(_self.copyWith(
bestScore: null == bestScore ? _self.bestScore : bestScore // ignore: cast_nullable_to_non_nullable
as PronunciationBestScoreByDifficulty,
  ));
}
/// Create a copy of PronunciationGameStatsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PronunciationBestScoreByDifficultyCopyWith<$Res> get bestScore {
  
  return $PronunciationBestScoreByDifficultyCopyWith<$Res>(_self.bestScore, (value) {
    return _then(_self.copyWith(bestScore: value));
  });
}
}


/// Adds pattern-matching-related methods to [PronunciationGameStatsSummary].
extension PronunciationGameStatsSummaryPatterns on PronunciationGameStatsSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PronunciationGameStatsSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PronunciationGameStatsSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PronunciationGameStatsSummary value)  $default,){
final _that = this;
switch (_that) {
case _PronunciationGameStatsSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PronunciationGameStatsSummary value)?  $default,){
final _that = this;
switch (_that) {
case _PronunciationGameStatsSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PronunciationBestScoreByDifficulty bestScore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PronunciationGameStatsSummary() when $default != null:
return $default(_that.bestScore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PronunciationBestScoreByDifficulty bestScore)  $default,) {final _that = this;
switch (_that) {
case _PronunciationGameStatsSummary():
return $default(_that.bestScore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PronunciationBestScoreByDifficulty bestScore)?  $default,) {final _that = this;
switch (_that) {
case _PronunciationGameStatsSummary() when $default != null:
return $default(_that.bestScore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PronunciationGameStatsSummary implements PronunciationGameStatsSummary {
  const _PronunciationGameStatsSummary({required this.bestScore});
  factory _PronunciationGameStatsSummary.fromJson(Map<String, dynamic> json) => _$PronunciationGameStatsSummaryFromJson(json);

@override final  PronunciationBestScoreByDifficulty bestScore;

/// Create a copy of PronunciationGameStatsSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PronunciationGameStatsSummaryCopyWith<_PronunciationGameStatsSummary> get copyWith => __$PronunciationGameStatsSummaryCopyWithImpl<_PronunciationGameStatsSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PronunciationGameStatsSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PronunciationGameStatsSummary&&(identical(other.bestScore, bestScore) || other.bestScore == bestScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bestScore);

@override
String toString() {
  return 'PronunciationGameStatsSummary(bestScore: $bestScore)';
}


}

/// @nodoc
abstract mixin class _$PronunciationGameStatsSummaryCopyWith<$Res> implements $PronunciationGameStatsSummaryCopyWith<$Res> {
  factory _$PronunciationGameStatsSummaryCopyWith(_PronunciationGameStatsSummary value, $Res Function(_PronunciationGameStatsSummary) _then) = __$PronunciationGameStatsSummaryCopyWithImpl;
@override @useResult
$Res call({
 PronunciationBestScoreByDifficulty bestScore
});


@override $PronunciationBestScoreByDifficultyCopyWith<$Res> get bestScore;

}
/// @nodoc
class __$PronunciationGameStatsSummaryCopyWithImpl<$Res>
    implements _$PronunciationGameStatsSummaryCopyWith<$Res> {
  __$PronunciationGameStatsSummaryCopyWithImpl(this._self, this._then);

  final _PronunciationGameStatsSummary _self;
  final $Res Function(_PronunciationGameStatsSummary) _then;

/// Create a copy of PronunciationGameStatsSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bestScore = null,}) {
  return _then(_PronunciationGameStatsSummary(
bestScore: null == bestScore ? _self.bestScore : bestScore // ignore: cast_nullable_to_non_nullable
as PronunciationBestScoreByDifficulty,
  ));
}

/// Create a copy of PronunciationGameStatsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PronunciationBestScoreByDifficultyCopyWith<$Res> get bestScore {
  
  return $PronunciationBestScoreByDifficultyCopyWith<$Res>(_self.bestScore, (value) {
    return _then(_self.copyWith(bestScore: value));
  });
}
}

/// @nodoc
mixin _$PronunciationGameSessionState {

 String get difficulty; int get remainingTimeMs; int get score; int get correctCount; int get currentCombo; int get maxCombo; int get characterLevel; PronunciationGameWord? get currentWord; String get recognizedText; bool get isListening; bool get isPlaying; bool get isFinished; List<PronunciationGameWord> get wordQueue; List<PronunciationGameWord> get completedWords;// 完了した単語リスト（正解）
 List<PronunciationGameWord> get skippedWords;// スキップした単語リスト
 int get totalBonusTime; int get wordIndex; DateTime? get startTime; PronunciationInputResultType get lastInputResult; DateTime? get lastInputTime; int get totalMistakes;// 練習モード用フィールド
 bool get isPracticeMode; int? get targetQuestionCount;
/// Create a copy of PronunciationGameSessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PronunciationGameSessionStateCopyWith<PronunciationGameSessionState> get copyWith => _$PronunciationGameSessionStateCopyWithImpl<PronunciationGameSessionState>(this as PronunciationGameSessionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PronunciationGameSessionState&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.remainingTimeMs, remainingTimeMs) || other.remainingTimeMs == remainingTimeMs)&&(identical(other.score, score) || other.score == score)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.currentCombo, currentCombo) || other.currentCombo == currentCombo)&&(identical(other.maxCombo, maxCombo) || other.maxCombo == maxCombo)&&(identical(other.characterLevel, characterLevel) || other.characterLevel == characterLevel)&&(identical(other.currentWord, currentWord) || other.currentWord == currentWord)&&(identical(other.recognizedText, recognizedText) || other.recognizedText == recognizedText)&&(identical(other.isListening, isListening) || other.isListening == isListening)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished)&&const DeepCollectionEquality().equals(other.wordQueue, wordQueue)&&const DeepCollectionEquality().equals(other.completedWords, completedWords)&&const DeepCollectionEquality().equals(other.skippedWords, skippedWords)&&(identical(other.totalBonusTime, totalBonusTime) || other.totalBonusTime == totalBonusTime)&&(identical(other.wordIndex, wordIndex) || other.wordIndex == wordIndex)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.lastInputResult, lastInputResult) || other.lastInputResult == lastInputResult)&&(identical(other.lastInputTime, lastInputTime) || other.lastInputTime == lastInputTime)&&(identical(other.totalMistakes, totalMistakes) || other.totalMistakes == totalMistakes)&&(identical(other.isPracticeMode, isPracticeMode) || other.isPracticeMode == isPracticeMode)&&(identical(other.targetQuestionCount, targetQuestionCount) || other.targetQuestionCount == targetQuestionCount));
}


@override
int get hashCode => Object.hashAll([runtimeType,difficulty,remainingTimeMs,score,correctCount,currentCombo,maxCombo,characterLevel,currentWord,recognizedText,isListening,isPlaying,isFinished,const DeepCollectionEquality().hash(wordQueue),const DeepCollectionEquality().hash(completedWords),const DeepCollectionEquality().hash(skippedWords),totalBonusTime,wordIndex,startTime,lastInputResult,lastInputTime,totalMistakes,isPracticeMode,targetQuestionCount]);

@override
String toString() {
  return 'PronunciationGameSessionState(difficulty: $difficulty, remainingTimeMs: $remainingTimeMs, score: $score, correctCount: $correctCount, currentCombo: $currentCombo, maxCombo: $maxCombo, characterLevel: $characterLevel, currentWord: $currentWord, recognizedText: $recognizedText, isListening: $isListening, isPlaying: $isPlaying, isFinished: $isFinished, wordQueue: $wordQueue, completedWords: $completedWords, skippedWords: $skippedWords, totalBonusTime: $totalBonusTime, wordIndex: $wordIndex, startTime: $startTime, lastInputResult: $lastInputResult, lastInputTime: $lastInputTime, totalMistakes: $totalMistakes, isPracticeMode: $isPracticeMode, targetQuestionCount: $targetQuestionCount)';
}


}

/// @nodoc
abstract mixin class $PronunciationGameSessionStateCopyWith<$Res>  {
  factory $PronunciationGameSessionStateCopyWith(PronunciationGameSessionState value, $Res Function(PronunciationGameSessionState) _then) = _$PronunciationGameSessionStateCopyWithImpl;
@useResult
$Res call({
 String difficulty, int remainingTimeMs, int score, int correctCount, int currentCombo, int maxCombo, int characterLevel, PronunciationGameWord? currentWord, String recognizedText, bool isListening, bool isPlaying, bool isFinished, List<PronunciationGameWord> wordQueue, List<PronunciationGameWord> completedWords, List<PronunciationGameWord> skippedWords, int totalBonusTime, int wordIndex, DateTime? startTime, PronunciationInputResultType lastInputResult, DateTime? lastInputTime, int totalMistakes, bool isPracticeMode, int? targetQuestionCount
});


$PronunciationGameWordCopyWith<$Res>? get currentWord;

}
/// @nodoc
class _$PronunciationGameSessionStateCopyWithImpl<$Res>
    implements $PronunciationGameSessionStateCopyWith<$Res> {
  _$PronunciationGameSessionStateCopyWithImpl(this._self, this._then);

  final PronunciationGameSessionState _self;
  final $Res Function(PronunciationGameSessionState) _then;

/// Create a copy of PronunciationGameSessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? difficulty = null,Object? remainingTimeMs = null,Object? score = null,Object? correctCount = null,Object? currentCombo = null,Object? maxCombo = null,Object? characterLevel = null,Object? currentWord = freezed,Object? recognizedText = null,Object? isListening = null,Object? isPlaying = null,Object? isFinished = null,Object? wordQueue = null,Object? completedWords = null,Object? skippedWords = null,Object? totalBonusTime = null,Object? wordIndex = null,Object? startTime = freezed,Object? lastInputResult = null,Object? lastInputTime = freezed,Object? totalMistakes = null,Object? isPracticeMode = null,Object? targetQuestionCount = freezed,}) {
  return _then(_self.copyWith(
difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,remainingTimeMs: null == remainingTimeMs ? _self.remainingTimeMs : remainingTimeMs // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,currentCombo: null == currentCombo ? _self.currentCombo : currentCombo // ignore: cast_nullable_to_non_nullable
as int,maxCombo: null == maxCombo ? _self.maxCombo : maxCombo // ignore: cast_nullable_to_non_nullable
as int,characterLevel: null == characterLevel ? _self.characterLevel : characterLevel // ignore: cast_nullable_to_non_nullable
as int,currentWord: freezed == currentWord ? _self.currentWord : currentWord // ignore: cast_nullable_to_non_nullable
as PronunciationGameWord?,recognizedText: null == recognizedText ? _self.recognizedText : recognizedText // ignore: cast_nullable_to_non_nullable
as String,isListening: null == isListening ? _self.isListening : isListening // ignore: cast_nullable_to_non_nullable
as bool,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,wordQueue: null == wordQueue ? _self.wordQueue : wordQueue // ignore: cast_nullable_to_non_nullable
as List<PronunciationGameWord>,completedWords: null == completedWords ? _self.completedWords : completedWords // ignore: cast_nullable_to_non_nullable
as List<PronunciationGameWord>,skippedWords: null == skippedWords ? _self.skippedWords : skippedWords // ignore: cast_nullable_to_non_nullable
as List<PronunciationGameWord>,totalBonusTime: null == totalBonusTime ? _self.totalBonusTime : totalBonusTime // ignore: cast_nullable_to_non_nullable
as int,wordIndex: null == wordIndex ? _self.wordIndex : wordIndex // ignore: cast_nullable_to_non_nullable
as int,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,lastInputResult: null == lastInputResult ? _self.lastInputResult : lastInputResult // ignore: cast_nullable_to_non_nullable
as PronunciationInputResultType,lastInputTime: freezed == lastInputTime ? _self.lastInputTime : lastInputTime // ignore: cast_nullable_to_non_nullable
as DateTime?,totalMistakes: null == totalMistakes ? _self.totalMistakes : totalMistakes // ignore: cast_nullable_to_non_nullable
as int,isPracticeMode: null == isPracticeMode ? _self.isPracticeMode : isPracticeMode // ignore: cast_nullable_to_non_nullable
as bool,targetQuestionCount: freezed == targetQuestionCount ? _self.targetQuestionCount : targetQuestionCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of PronunciationGameSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PronunciationGameWordCopyWith<$Res>? get currentWord {
    if (_self.currentWord == null) {
    return null;
  }

  return $PronunciationGameWordCopyWith<$Res>(_self.currentWord!, (value) {
    return _then(_self.copyWith(currentWord: value));
  });
}
}


/// Adds pattern-matching-related methods to [PronunciationGameSessionState].
extension PronunciationGameSessionStatePatterns on PronunciationGameSessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PronunciationGameSessionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PronunciationGameSessionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PronunciationGameSessionState value)  $default,){
final _that = this;
switch (_that) {
case _PronunciationGameSessionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PronunciationGameSessionState value)?  $default,){
final _that = this;
switch (_that) {
case _PronunciationGameSessionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String difficulty,  int remainingTimeMs,  int score,  int correctCount,  int currentCombo,  int maxCombo,  int characterLevel,  PronunciationGameWord? currentWord,  String recognizedText,  bool isListening,  bool isPlaying,  bool isFinished,  List<PronunciationGameWord> wordQueue,  List<PronunciationGameWord> completedWords,  List<PronunciationGameWord> skippedWords,  int totalBonusTime,  int wordIndex,  DateTime? startTime,  PronunciationInputResultType lastInputResult,  DateTime? lastInputTime,  int totalMistakes,  bool isPracticeMode,  int? targetQuestionCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PronunciationGameSessionState() when $default != null:
return $default(_that.difficulty,_that.remainingTimeMs,_that.score,_that.correctCount,_that.currentCombo,_that.maxCombo,_that.characterLevel,_that.currentWord,_that.recognizedText,_that.isListening,_that.isPlaying,_that.isFinished,_that.wordQueue,_that.completedWords,_that.skippedWords,_that.totalBonusTime,_that.wordIndex,_that.startTime,_that.lastInputResult,_that.lastInputTime,_that.totalMistakes,_that.isPracticeMode,_that.targetQuestionCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String difficulty,  int remainingTimeMs,  int score,  int correctCount,  int currentCombo,  int maxCombo,  int characterLevel,  PronunciationGameWord? currentWord,  String recognizedText,  bool isListening,  bool isPlaying,  bool isFinished,  List<PronunciationGameWord> wordQueue,  List<PronunciationGameWord> completedWords,  List<PronunciationGameWord> skippedWords,  int totalBonusTime,  int wordIndex,  DateTime? startTime,  PronunciationInputResultType lastInputResult,  DateTime? lastInputTime,  int totalMistakes,  bool isPracticeMode,  int? targetQuestionCount)  $default,) {final _that = this;
switch (_that) {
case _PronunciationGameSessionState():
return $default(_that.difficulty,_that.remainingTimeMs,_that.score,_that.correctCount,_that.currentCombo,_that.maxCombo,_that.characterLevel,_that.currentWord,_that.recognizedText,_that.isListening,_that.isPlaying,_that.isFinished,_that.wordQueue,_that.completedWords,_that.skippedWords,_that.totalBonusTime,_that.wordIndex,_that.startTime,_that.lastInputResult,_that.lastInputTime,_that.totalMistakes,_that.isPracticeMode,_that.targetQuestionCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String difficulty,  int remainingTimeMs,  int score,  int correctCount,  int currentCombo,  int maxCombo,  int characterLevel,  PronunciationGameWord? currentWord,  String recognizedText,  bool isListening,  bool isPlaying,  bool isFinished,  List<PronunciationGameWord> wordQueue,  List<PronunciationGameWord> completedWords,  List<PronunciationGameWord> skippedWords,  int totalBonusTime,  int wordIndex,  DateTime? startTime,  PronunciationInputResultType lastInputResult,  DateTime? lastInputTime,  int totalMistakes,  bool isPracticeMode,  int? targetQuestionCount)?  $default,) {final _that = this;
switch (_that) {
case _PronunciationGameSessionState() when $default != null:
return $default(_that.difficulty,_that.remainingTimeMs,_that.score,_that.correctCount,_that.currentCombo,_that.maxCombo,_that.characterLevel,_that.currentWord,_that.recognizedText,_that.isListening,_that.isPlaying,_that.isFinished,_that.wordQueue,_that.completedWords,_that.skippedWords,_that.totalBonusTime,_that.wordIndex,_that.startTime,_that.lastInputResult,_that.lastInputTime,_that.totalMistakes,_that.isPracticeMode,_that.targetQuestionCount);case _:
  return null;

}
}

}

/// @nodoc


class _PronunciationGameSessionState extends PronunciationGameSessionState {
  const _PronunciationGameSessionState({required this.difficulty, required this.remainingTimeMs, this.score = 0, this.correctCount = 0, this.currentCombo = 0, this.maxCombo = 0, this.characterLevel = 0, this.currentWord, this.recognizedText = '', this.isListening = false, this.isPlaying = false, this.isFinished = false, final  List<PronunciationGameWord> wordQueue = const <PronunciationGameWord>[], final  List<PronunciationGameWord> completedWords = const <PronunciationGameWord>[], final  List<PronunciationGameWord> skippedWords = const <PronunciationGameWord>[], this.totalBonusTime = 0, this.wordIndex = 0, this.startTime, this.lastInputResult = PronunciationInputResultType.none, this.lastInputTime, this.totalMistakes = 0, this.isPracticeMode = false, this.targetQuestionCount}): _wordQueue = wordQueue,_completedWords = completedWords,_skippedWords = skippedWords,super._();
  

@override final  String difficulty;
@override final  int remainingTimeMs;
@override@JsonKey() final  int score;
@override@JsonKey() final  int correctCount;
@override@JsonKey() final  int currentCombo;
@override@JsonKey() final  int maxCombo;
@override@JsonKey() final  int characterLevel;
@override final  PronunciationGameWord? currentWord;
@override@JsonKey() final  String recognizedText;
@override@JsonKey() final  bool isListening;
@override@JsonKey() final  bool isPlaying;
@override@JsonKey() final  bool isFinished;
 final  List<PronunciationGameWord> _wordQueue;
@override@JsonKey() List<PronunciationGameWord> get wordQueue {
  if (_wordQueue is EqualUnmodifiableListView) return _wordQueue;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wordQueue);
}

 final  List<PronunciationGameWord> _completedWords;
@override@JsonKey() List<PronunciationGameWord> get completedWords {
  if (_completedWords is EqualUnmodifiableListView) return _completedWords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedWords);
}

// 完了した単語リスト（正解）
 final  List<PronunciationGameWord> _skippedWords;
// 完了した単語リスト（正解）
@override@JsonKey() List<PronunciationGameWord> get skippedWords {
  if (_skippedWords is EqualUnmodifiableListView) return _skippedWords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_skippedWords);
}

// スキップした単語リスト
@override@JsonKey() final  int totalBonusTime;
@override@JsonKey() final  int wordIndex;
@override final  DateTime? startTime;
@override@JsonKey() final  PronunciationInputResultType lastInputResult;
@override final  DateTime? lastInputTime;
@override@JsonKey() final  int totalMistakes;
// 練習モード用フィールド
@override@JsonKey() final  bool isPracticeMode;
@override final  int? targetQuestionCount;

/// Create a copy of PronunciationGameSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PronunciationGameSessionStateCopyWith<_PronunciationGameSessionState> get copyWith => __$PronunciationGameSessionStateCopyWithImpl<_PronunciationGameSessionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PronunciationGameSessionState&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.remainingTimeMs, remainingTimeMs) || other.remainingTimeMs == remainingTimeMs)&&(identical(other.score, score) || other.score == score)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.currentCombo, currentCombo) || other.currentCombo == currentCombo)&&(identical(other.maxCombo, maxCombo) || other.maxCombo == maxCombo)&&(identical(other.characterLevel, characterLevel) || other.characterLevel == characterLevel)&&(identical(other.currentWord, currentWord) || other.currentWord == currentWord)&&(identical(other.recognizedText, recognizedText) || other.recognizedText == recognizedText)&&(identical(other.isListening, isListening) || other.isListening == isListening)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished)&&const DeepCollectionEquality().equals(other._wordQueue, _wordQueue)&&const DeepCollectionEquality().equals(other._completedWords, _completedWords)&&const DeepCollectionEquality().equals(other._skippedWords, _skippedWords)&&(identical(other.totalBonusTime, totalBonusTime) || other.totalBonusTime == totalBonusTime)&&(identical(other.wordIndex, wordIndex) || other.wordIndex == wordIndex)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.lastInputResult, lastInputResult) || other.lastInputResult == lastInputResult)&&(identical(other.lastInputTime, lastInputTime) || other.lastInputTime == lastInputTime)&&(identical(other.totalMistakes, totalMistakes) || other.totalMistakes == totalMistakes)&&(identical(other.isPracticeMode, isPracticeMode) || other.isPracticeMode == isPracticeMode)&&(identical(other.targetQuestionCount, targetQuestionCount) || other.targetQuestionCount == targetQuestionCount));
}


@override
int get hashCode => Object.hashAll([runtimeType,difficulty,remainingTimeMs,score,correctCount,currentCombo,maxCombo,characterLevel,currentWord,recognizedText,isListening,isPlaying,isFinished,const DeepCollectionEquality().hash(_wordQueue),const DeepCollectionEquality().hash(_completedWords),const DeepCollectionEquality().hash(_skippedWords),totalBonusTime,wordIndex,startTime,lastInputResult,lastInputTime,totalMistakes,isPracticeMode,targetQuestionCount]);

@override
String toString() {
  return 'PronunciationGameSessionState(difficulty: $difficulty, remainingTimeMs: $remainingTimeMs, score: $score, correctCount: $correctCount, currentCombo: $currentCombo, maxCombo: $maxCombo, characterLevel: $characterLevel, currentWord: $currentWord, recognizedText: $recognizedText, isListening: $isListening, isPlaying: $isPlaying, isFinished: $isFinished, wordQueue: $wordQueue, completedWords: $completedWords, skippedWords: $skippedWords, totalBonusTime: $totalBonusTime, wordIndex: $wordIndex, startTime: $startTime, lastInputResult: $lastInputResult, lastInputTime: $lastInputTime, totalMistakes: $totalMistakes, isPracticeMode: $isPracticeMode, targetQuestionCount: $targetQuestionCount)';
}


}

/// @nodoc
abstract mixin class _$PronunciationGameSessionStateCopyWith<$Res> implements $PronunciationGameSessionStateCopyWith<$Res> {
  factory _$PronunciationGameSessionStateCopyWith(_PronunciationGameSessionState value, $Res Function(_PronunciationGameSessionState) _then) = __$PronunciationGameSessionStateCopyWithImpl;
@override @useResult
$Res call({
 String difficulty, int remainingTimeMs, int score, int correctCount, int currentCombo, int maxCombo, int characterLevel, PronunciationGameWord? currentWord, String recognizedText, bool isListening, bool isPlaying, bool isFinished, List<PronunciationGameWord> wordQueue, List<PronunciationGameWord> completedWords, List<PronunciationGameWord> skippedWords, int totalBonusTime, int wordIndex, DateTime? startTime, PronunciationInputResultType lastInputResult, DateTime? lastInputTime, int totalMistakes, bool isPracticeMode, int? targetQuestionCount
});


@override $PronunciationGameWordCopyWith<$Res>? get currentWord;

}
/// @nodoc
class __$PronunciationGameSessionStateCopyWithImpl<$Res>
    implements _$PronunciationGameSessionStateCopyWith<$Res> {
  __$PronunciationGameSessionStateCopyWithImpl(this._self, this._then);

  final _PronunciationGameSessionState _self;
  final $Res Function(_PronunciationGameSessionState) _then;

/// Create a copy of PronunciationGameSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? difficulty = null,Object? remainingTimeMs = null,Object? score = null,Object? correctCount = null,Object? currentCombo = null,Object? maxCombo = null,Object? characterLevel = null,Object? currentWord = freezed,Object? recognizedText = null,Object? isListening = null,Object? isPlaying = null,Object? isFinished = null,Object? wordQueue = null,Object? completedWords = null,Object? skippedWords = null,Object? totalBonusTime = null,Object? wordIndex = null,Object? startTime = freezed,Object? lastInputResult = null,Object? lastInputTime = freezed,Object? totalMistakes = null,Object? isPracticeMode = null,Object? targetQuestionCount = freezed,}) {
  return _then(_PronunciationGameSessionState(
difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,remainingTimeMs: null == remainingTimeMs ? _self.remainingTimeMs : remainingTimeMs // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,currentCombo: null == currentCombo ? _self.currentCombo : currentCombo // ignore: cast_nullable_to_non_nullable
as int,maxCombo: null == maxCombo ? _self.maxCombo : maxCombo // ignore: cast_nullable_to_non_nullable
as int,characterLevel: null == characterLevel ? _self.characterLevel : characterLevel // ignore: cast_nullable_to_non_nullable
as int,currentWord: freezed == currentWord ? _self.currentWord : currentWord // ignore: cast_nullable_to_non_nullable
as PronunciationGameWord?,recognizedText: null == recognizedText ? _self.recognizedText : recognizedText // ignore: cast_nullable_to_non_nullable
as String,isListening: null == isListening ? _self.isListening : isListening // ignore: cast_nullable_to_non_nullable
as bool,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,wordQueue: null == wordQueue ? _self._wordQueue : wordQueue // ignore: cast_nullable_to_non_nullable
as List<PronunciationGameWord>,completedWords: null == completedWords ? _self._completedWords : completedWords // ignore: cast_nullable_to_non_nullable
as List<PronunciationGameWord>,skippedWords: null == skippedWords ? _self._skippedWords : skippedWords // ignore: cast_nullable_to_non_nullable
as List<PronunciationGameWord>,totalBonusTime: null == totalBonusTime ? _self.totalBonusTime : totalBonusTime // ignore: cast_nullable_to_non_nullable
as int,wordIndex: null == wordIndex ? _self.wordIndex : wordIndex // ignore: cast_nullable_to_non_nullable
as int,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,lastInputResult: null == lastInputResult ? _self.lastInputResult : lastInputResult // ignore: cast_nullable_to_non_nullable
as PronunciationInputResultType,lastInputTime: freezed == lastInputTime ? _self.lastInputTime : lastInputTime // ignore: cast_nullable_to_non_nullable
as DateTime?,totalMistakes: null == totalMistakes ? _self.totalMistakes : totalMistakes // ignore: cast_nullable_to_non_nullable
as int,isPracticeMode: null == isPracticeMode ? _self.isPracticeMode : isPracticeMode // ignore: cast_nullable_to_non_nullable
as bool,targetQuestionCount: freezed == targetQuestionCount ? _self.targetQuestionCount : targetQuestionCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of PronunciationGameSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PronunciationGameWordCopyWith<$Res>? get currentWord {
    if (_self.currentWord == null) {
    return null;
  }

  return $PronunciationGameWordCopyWith<$Res>(_self.currentWord!, (value) {
    return _then(_self.copyWith(currentWord: value));
  });
}
}


/// @nodoc
mixin _$PronunciationWordDataFile {

 String get version; String get difficulty; List<PronunciationGameWord> get words;
/// Create a copy of PronunciationWordDataFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PronunciationWordDataFileCopyWith<PronunciationWordDataFile> get copyWith => _$PronunciationWordDataFileCopyWithImpl<PronunciationWordDataFile>(this as PronunciationWordDataFile, _$identity);

  /// Serializes this PronunciationWordDataFile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PronunciationWordDataFile&&(identical(other.version, version) || other.version == version)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other.words, words));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,difficulty,const DeepCollectionEquality().hash(words));

@override
String toString() {
  return 'PronunciationWordDataFile(version: $version, difficulty: $difficulty, words: $words)';
}


}

/// @nodoc
abstract mixin class $PronunciationWordDataFileCopyWith<$Res>  {
  factory $PronunciationWordDataFileCopyWith(PronunciationWordDataFile value, $Res Function(PronunciationWordDataFile) _then) = _$PronunciationWordDataFileCopyWithImpl;
@useResult
$Res call({
 String version, String difficulty, List<PronunciationGameWord> words
});




}
/// @nodoc
class _$PronunciationWordDataFileCopyWithImpl<$Res>
    implements $PronunciationWordDataFileCopyWith<$Res> {
  _$PronunciationWordDataFileCopyWithImpl(this._self, this._then);

  final PronunciationWordDataFile _self;
  final $Res Function(PronunciationWordDataFile) _then;

/// Create a copy of PronunciationWordDataFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? difficulty = null,Object? words = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as List<PronunciationGameWord>,
  ));
}

}


/// Adds pattern-matching-related methods to [PronunciationWordDataFile].
extension PronunciationWordDataFilePatterns on PronunciationWordDataFile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PronunciationWordDataFile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PronunciationWordDataFile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PronunciationWordDataFile value)  $default,){
final _that = this;
switch (_that) {
case _PronunciationWordDataFile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PronunciationWordDataFile value)?  $default,){
final _that = this;
switch (_that) {
case _PronunciationWordDataFile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  String difficulty,  List<PronunciationGameWord> words)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PronunciationWordDataFile() when $default != null:
return $default(_that.version,_that.difficulty,_that.words);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  String difficulty,  List<PronunciationGameWord> words)  $default,) {final _that = this;
switch (_that) {
case _PronunciationWordDataFile():
return $default(_that.version,_that.difficulty,_that.words);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  String difficulty,  List<PronunciationGameWord> words)?  $default,) {final _that = this;
switch (_that) {
case _PronunciationWordDataFile() when $default != null:
return $default(_that.version,_that.difficulty,_that.words);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PronunciationWordDataFile implements PronunciationWordDataFile {
  const _PronunciationWordDataFile({required this.version, required this.difficulty, final  List<PronunciationGameWord> words = const <PronunciationGameWord>[]}): _words = words;
  factory _PronunciationWordDataFile.fromJson(Map<String, dynamic> json) => _$PronunciationWordDataFileFromJson(json);

@override final  String version;
@override final  String difficulty;
 final  List<PronunciationGameWord> _words;
@override@JsonKey() List<PronunciationGameWord> get words {
  if (_words is EqualUnmodifiableListView) return _words;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_words);
}


/// Create a copy of PronunciationWordDataFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PronunciationWordDataFileCopyWith<_PronunciationWordDataFile> get copyWith => __$PronunciationWordDataFileCopyWithImpl<_PronunciationWordDataFile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PronunciationWordDataFileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PronunciationWordDataFile&&(identical(other.version, version) || other.version == version)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other._words, _words));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,difficulty,const DeepCollectionEquality().hash(_words));

@override
String toString() {
  return 'PronunciationWordDataFile(version: $version, difficulty: $difficulty, words: $words)';
}


}

/// @nodoc
abstract mixin class _$PronunciationWordDataFileCopyWith<$Res> implements $PronunciationWordDataFileCopyWith<$Res> {
  factory _$PronunciationWordDataFileCopyWith(_PronunciationWordDataFile value, $Res Function(_PronunciationWordDataFile) _then) = __$PronunciationWordDataFileCopyWithImpl;
@override @useResult
$Res call({
 String version, String difficulty, List<PronunciationGameWord> words
});




}
/// @nodoc
class __$PronunciationWordDataFileCopyWithImpl<$Res>
    implements _$PronunciationWordDataFileCopyWith<$Res> {
  __$PronunciationWordDataFileCopyWithImpl(this._self, this._then);

  final _PronunciationWordDataFile _self;
  final $Res Function(_PronunciationWordDataFile) _then;

/// Create a copy of PronunciationWordDataFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? difficulty = null,Object? words = null,}) {
  return _then(_PronunciationWordDataFile(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,words: null == words ? _self._words : words // ignore: cast_nullable_to_non_nullable
as List<PronunciationGameWord>,
  ));
}


}

// dart format on
