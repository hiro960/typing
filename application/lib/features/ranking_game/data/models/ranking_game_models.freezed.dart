// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ranking_game_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RankingGameWord {

 String get word; String get meaning;
/// Create a copy of RankingGameWord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankingGameWordCopyWith<RankingGameWord> get copyWith => _$RankingGameWordCopyWithImpl<RankingGameWord>(this as RankingGameWord, _$identity);

  /// Serializes this RankingGameWord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankingGameWord&&(identical(other.word, word) || other.word == word)&&(identical(other.meaning, meaning) || other.meaning == meaning));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,meaning);

@override
String toString() {
  return 'RankingGameWord(word: $word, meaning: $meaning)';
}


}

/// @nodoc
abstract mixin class $RankingGameWordCopyWith<$Res>  {
  factory $RankingGameWordCopyWith(RankingGameWord value, $Res Function(RankingGameWord) _then) = _$RankingGameWordCopyWithImpl;
@useResult
$Res call({
 String word, String meaning
});




}
/// @nodoc
class _$RankingGameWordCopyWithImpl<$Res>
    implements $RankingGameWordCopyWith<$Res> {
  _$RankingGameWordCopyWithImpl(this._self, this._then);

  final RankingGameWord _self;
  final $Res Function(RankingGameWord) _then;

/// Create a copy of RankingGameWord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? word = null,Object? meaning = null,}) {
  return _then(_self.copyWith(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RankingGameWord].
extension RankingGameWordPatterns on RankingGameWord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankingGameWord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankingGameWord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankingGameWord value)  $default,){
final _that = this;
switch (_that) {
case _RankingGameWord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankingGameWord value)?  $default,){
final _that = this;
switch (_that) {
case _RankingGameWord() when $default != null:
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
case _RankingGameWord() when $default != null:
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
case _RankingGameWord():
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
case _RankingGameWord() when $default != null:
return $default(_that.word,_that.meaning);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RankingGameWord implements RankingGameWord {
  const _RankingGameWord({required this.word, required this.meaning});
  factory _RankingGameWord.fromJson(Map<String, dynamic> json) => _$RankingGameWordFromJson(json);

@override final  String word;
@override final  String meaning;

/// Create a copy of RankingGameWord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankingGameWordCopyWith<_RankingGameWord> get copyWith => __$RankingGameWordCopyWithImpl<_RankingGameWord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RankingGameWordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankingGameWord&&(identical(other.word, word) || other.word == word)&&(identical(other.meaning, meaning) || other.meaning == meaning));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,meaning);

@override
String toString() {
  return 'RankingGameWord(word: $word, meaning: $meaning)';
}


}

/// @nodoc
abstract mixin class _$RankingGameWordCopyWith<$Res> implements $RankingGameWordCopyWith<$Res> {
  factory _$RankingGameWordCopyWith(_RankingGameWord value, $Res Function(_RankingGameWord) _then) = __$RankingGameWordCopyWithImpl;
@override @useResult
$Res call({
 String word, String meaning
});




}
/// @nodoc
class __$RankingGameWordCopyWithImpl<$Res>
    implements _$RankingGameWordCopyWith<$Res> {
  __$RankingGameWordCopyWithImpl(this._self, this._then);

  final _RankingGameWord _self;
  final $Res Function(_RankingGameWord) _then;

/// Create a copy of RankingGameWord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? word = null,Object? meaning = null,}) {
  return _then(_RankingGameWord(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RankingGameResult {

 String get id; String get difficulty; int get score; int get correctCount; int get maxCombo; int get totalBonusTime; double get avgInputSpeed; int get characterLevel; DateTime get playedAt;
/// Create a copy of RankingGameResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankingGameResultCopyWith<RankingGameResult> get copyWith => _$RankingGameResultCopyWithImpl<RankingGameResult>(this as RankingGameResult, _$identity);

  /// Serializes this RankingGameResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankingGameResult&&(identical(other.id, id) || other.id == id)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.score, score) || other.score == score)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.maxCombo, maxCombo) || other.maxCombo == maxCombo)&&(identical(other.totalBonusTime, totalBonusTime) || other.totalBonusTime == totalBonusTime)&&(identical(other.avgInputSpeed, avgInputSpeed) || other.avgInputSpeed == avgInputSpeed)&&(identical(other.characterLevel, characterLevel) || other.characterLevel == characterLevel)&&(identical(other.playedAt, playedAt) || other.playedAt == playedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,difficulty,score,correctCount,maxCombo,totalBonusTime,avgInputSpeed,characterLevel,playedAt);

@override
String toString() {
  return 'RankingGameResult(id: $id, difficulty: $difficulty, score: $score, correctCount: $correctCount, maxCombo: $maxCombo, totalBonusTime: $totalBonusTime, avgInputSpeed: $avgInputSpeed, characterLevel: $characterLevel, playedAt: $playedAt)';
}


}

/// @nodoc
abstract mixin class $RankingGameResultCopyWith<$Res>  {
  factory $RankingGameResultCopyWith(RankingGameResult value, $Res Function(RankingGameResult) _then) = _$RankingGameResultCopyWithImpl;
@useResult
$Res call({
 String id, String difficulty, int score, int correctCount, int maxCombo, int totalBonusTime, double avgInputSpeed, int characterLevel, DateTime playedAt
});




}
/// @nodoc
class _$RankingGameResultCopyWithImpl<$Res>
    implements $RankingGameResultCopyWith<$Res> {
  _$RankingGameResultCopyWithImpl(this._self, this._then);

  final RankingGameResult _self;
  final $Res Function(RankingGameResult) _then;

/// Create a copy of RankingGameResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? difficulty = null,Object? score = null,Object? correctCount = null,Object? maxCombo = null,Object? totalBonusTime = null,Object? avgInputSpeed = null,Object? characterLevel = null,Object? playedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,maxCombo: null == maxCombo ? _self.maxCombo : maxCombo // ignore: cast_nullable_to_non_nullable
as int,totalBonusTime: null == totalBonusTime ? _self.totalBonusTime : totalBonusTime // ignore: cast_nullable_to_non_nullable
as int,avgInputSpeed: null == avgInputSpeed ? _self.avgInputSpeed : avgInputSpeed // ignore: cast_nullable_to_non_nullable
as double,characterLevel: null == characterLevel ? _self.characterLevel : characterLevel // ignore: cast_nullable_to_non_nullable
as int,playedAt: null == playedAt ? _self.playedAt : playedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RankingGameResult].
extension RankingGameResultPatterns on RankingGameResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankingGameResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankingGameResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankingGameResult value)  $default,){
final _that = this;
switch (_that) {
case _RankingGameResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankingGameResult value)?  $default,){
final _that = this;
switch (_that) {
case _RankingGameResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String difficulty,  int score,  int correctCount,  int maxCombo,  int totalBonusTime,  double avgInputSpeed,  int characterLevel,  DateTime playedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RankingGameResult() when $default != null:
return $default(_that.id,_that.difficulty,_that.score,_that.correctCount,_that.maxCombo,_that.totalBonusTime,_that.avgInputSpeed,_that.characterLevel,_that.playedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String difficulty,  int score,  int correctCount,  int maxCombo,  int totalBonusTime,  double avgInputSpeed,  int characterLevel,  DateTime playedAt)  $default,) {final _that = this;
switch (_that) {
case _RankingGameResult():
return $default(_that.id,_that.difficulty,_that.score,_that.correctCount,_that.maxCombo,_that.totalBonusTime,_that.avgInputSpeed,_that.characterLevel,_that.playedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String difficulty,  int score,  int correctCount,  int maxCombo,  int totalBonusTime,  double avgInputSpeed,  int characterLevel,  DateTime playedAt)?  $default,) {final _that = this;
switch (_that) {
case _RankingGameResult() when $default != null:
return $default(_that.id,_that.difficulty,_that.score,_that.correctCount,_that.maxCombo,_that.totalBonusTime,_that.avgInputSpeed,_that.characterLevel,_that.playedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RankingGameResult implements RankingGameResult {
  const _RankingGameResult({required this.id, required this.difficulty, required this.score, required this.correctCount, required this.maxCombo, required this.totalBonusTime, required this.avgInputSpeed, required this.characterLevel, required this.playedAt});
  factory _RankingGameResult.fromJson(Map<String, dynamic> json) => _$RankingGameResultFromJson(json);

@override final  String id;
@override final  String difficulty;
@override final  int score;
@override final  int correctCount;
@override final  int maxCombo;
@override final  int totalBonusTime;
@override final  double avgInputSpeed;
@override final  int characterLevel;
@override final  DateTime playedAt;

/// Create a copy of RankingGameResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankingGameResultCopyWith<_RankingGameResult> get copyWith => __$RankingGameResultCopyWithImpl<_RankingGameResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RankingGameResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankingGameResult&&(identical(other.id, id) || other.id == id)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.score, score) || other.score == score)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.maxCombo, maxCombo) || other.maxCombo == maxCombo)&&(identical(other.totalBonusTime, totalBonusTime) || other.totalBonusTime == totalBonusTime)&&(identical(other.avgInputSpeed, avgInputSpeed) || other.avgInputSpeed == avgInputSpeed)&&(identical(other.characterLevel, characterLevel) || other.characterLevel == characterLevel)&&(identical(other.playedAt, playedAt) || other.playedAt == playedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,difficulty,score,correctCount,maxCombo,totalBonusTime,avgInputSpeed,characterLevel,playedAt);

@override
String toString() {
  return 'RankingGameResult(id: $id, difficulty: $difficulty, score: $score, correctCount: $correctCount, maxCombo: $maxCombo, totalBonusTime: $totalBonusTime, avgInputSpeed: $avgInputSpeed, characterLevel: $characterLevel, playedAt: $playedAt)';
}


}

/// @nodoc
abstract mixin class _$RankingGameResultCopyWith<$Res> implements $RankingGameResultCopyWith<$Res> {
  factory _$RankingGameResultCopyWith(_RankingGameResult value, $Res Function(_RankingGameResult) _then) = __$RankingGameResultCopyWithImpl;
@override @useResult
$Res call({
 String id, String difficulty, int score, int correctCount, int maxCombo, int totalBonusTime, double avgInputSpeed, int characterLevel, DateTime playedAt
});




}
/// @nodoc
class __$RankingGameResultCopyWithImpl<$Res>
    implements _$RankingGameResultCopyWith<$Res> {
  __$RankingGameResultCopyWithImpl(this._self, this._then);

  final _RankingGameResult _self;
  final $Res Function(_RankingGameResult) _then;

/// Create a copy of RankingGameResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? difficulty = null,Object? score = null,Object? correctCount = null,Object? maxCombo = null,Object? totalBonusTime = null,Object? avgInputSpeed = null,Object? characterLevel = null,Object? playedAt = null,}) {
  return _then(_RankingGameResult(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,maxCombo: null == maxCombo ? _self.maxCombo : maxCombo // ignore: cast_nullable_to_non_nullable
as int,totalBonusTime: null == totalBonusTime ? _self.totalBonusTime : totalBonusTime // ignore: cast_nullable_to_non_nullable
as int,avgInputSpeed: null == avgInputSpeed ? _self.avgInputSpeed : avgInputSpeed // ignore: cast_nullable_to_non_nullable
as double,characterLevel: null == characterLevel ? _self.characterLevel : characterLevel // ignore: cast_nullable_to_non_nullable
as int,playedAt: null == playedAt ? _self.playedAt : playedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$RankingGameResultResponse {

 String get id; String get difficulty; int get score; int get correctCount; int get maxCombo; int get totalBonusTime; double get avgInputSpeed; int get characterLevel; DateTime get playedAt; RankingInfo get ranking; List<String> get achievements;
/// Create a copy of RankingGameResultResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankingGameResultResponseCopyWith<RankingGameResultResponse> get copyWith => _$RankingGameResultResponseCopyWithImpl<RankingGameResultResponse>(this as RankingGameResultResponse, _$identity);

  /// Serializes this RankingGameResultResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankingGameResultResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.score, score) || other.score == score)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.maxCombo, maxCombo) || other.maxCombo == maxCombo)&&(identical(other.totalBonusTime, totalBonusTime) || other.totalBonusTime == totalBonusTime)&&(identical(other.avgInputSpeed, avgInputSpeed) || other.avgInputSpeed == avgInputSpeed)&&(identical(other.characterLevel, characterLevel) || other.characterLevel == characterLevel)&&(identical(other.playedAt, playedAt) || other.playedAt == playedAt)&&(identical(other.ranking, ranking) || other.ranking == ranking)&&const DeepCollectionEquality().equals(other.achievements, achievements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,difficulty,score,correctCount,maxCombo,totalBonusTime,avgInputSpeed,characterLevel,playedAt,ranking,const DeepCollectionEquality().hash(achievements));

@override
String toString() {
  return 'RankingGameResultResponse(id: $id, difficulty: $difficulty, score: $score, correctCount: $correctCount, maxCombo: $maxCombo, totalBonusTime: $totalBonusTime, avgInputSpeed: $avgInputSpeed, characterLevel: $characterLevel, playedAt: $playedAt, ranking: $ranking, achievements: $achievements)';
}


}

/// @nodoc
abstract mixin class $RankingGameResultResponseCopyWith<$Res>  {
  factory $RankingGameResultResponseCopyWith(RankingGameResultResponse value, $Res Function(RankingGameResultResponse) _then) = _$RankingGameResultResponseCopyWithImpl;
@useResult
$Res call({
 String id, String difficulty, int score, int correctCount, int maxCombo, int totalBonusTime, double avgInputSpeed, int characterLevel, DateTime playedAt, RankingInfo ranking, List<String> achievements
});


$RankingInfoCopyWith<$Res> get ranking;

}
/// @nodoc
class _$RankingGameResultResponseCopyWithImpl<$Res>
    implements $RankingGameResultResponseCopyWith<$Res> {
  _$RankingGameResultResponseCopyWithImpl(this._self, this._then);

  final RankingGameResultResponse _self;
  final $Res Function(RankingGameResultResponse) _then;

/// Create a copy of RankingGameResultResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? difficulty = null,Object? score = null,Object? correctCount = null,Object? maxCombo = null,Object? totalBonusTime = null,Object? avgInputSpeed = null,Object? characterLevel = null,Object? playedAt = null,Object? ranking = null,Object? achievements = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,maxCombo: null == maxCombo ? _self.maxCombo : maxCombo // ignore: cast_nullable_to_non_nullable
as int,totalBonusTime: null == totalBonusTime ? _self.totalBonusTime : totalBonusTime // ignore: cast_nullable_to_non_nullable
as int,avgInputSpeed: null == avgInputSpeed ? _self.avgInputSpeed : avgInputSpeed // ignore: cast_nullable_to_non_nullable
as double,characterLevel: null == characterLevel ? _self.characterLevel : characterLevel // ignore: cast_nullable_to_non_nullable
as int,playedAt: null == playedAt ? _self.playedAt : playedAt // ignore: cast_nullable_to_non_nullable
as DateTime,ranking: null == ranking ? _self.ranking : ranking // ignore: cast_nullable_to_non_nullable
as RankingInfo,achievements: null == achievements ? _self.achievements : achievements // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of RankingGameResultResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RankingInfoCopyWith<$Res> get ranking {
  
  return $RankingInfoCopyWith<$Res>(_self.ranking, (value) {
    return _then(_self.copyWith(ranking: value));
  });
}
}


/// Adds pattern-matching-related methods to [RankingGameResultResponse].
extension RankingGameResultResponsePatterns on RankingGameResultResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankingGameResultResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankingGameResultResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankingGameResultResponse value)  $default,){
final _that = this;
switch (_that) {
case _RankingGameResultResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankingGameResultResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RankingGameResultResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String difficulty,  int score,  int correctCount,  int maxCombo,  int totalBonusTime,  double avgInputSpeed,  int characterLevel,  DateTime playedAt,  RankingInfo ranking,  List<String> achievements)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RankingGameResultResponse() when $default != null:
return $default(_that.id,_that.difficulty,_that.score,_that.correctCount,_that.maxCombo,_that.totalBonusTime,_that.avgInputSpeed,_that.characterLevel,_that.playedAt,_that.ranking,_that.achievements);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String difficulty,  int score,  int correctCount,  int maxCombo,  int totalBonusTime,  double avgInputSpeed,  int characterLevel,  DateTime playedAt,  RankingInfo ranking,  List<String> achievements)  $default,) {final _that = this;
switch (_that) {
case _RankingGameResultResponse():
return $default(_that.id,_that.difficulty,_that.score,_that.correctCount,_that.maxCombo,_that.totalBonusTime,_that.avgInputSpeed,_that.characterLevel,_that.playedAt,_that.ranking,_that.achievements);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String difficulty,  int score,  int correctCount,  int maxCombo,  int totalBonusTime,  double avgInputSpeed,  int characterLevel,  DateTime playedAt,  RankingInfo ranking,  List<String> achievements)?  $default,) {final _that = this;
switch (_that) {
case _RankingGameResultResponse() when $default != null:
return $default(_that.id,_that.difficulty,_that.score,_that.correctCount,_that.maxCombo,_that.totalBonusTime,_that.avgInputSpeed,_that.characterLevel,_that.playedAt,_that.ranking,_that.achievements);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RankingGameResultResponse implements RankingGameResultResponse {
  const _RankingGameResultResponse({required this.id, required this.difficulty, required this.score, required this.correctCount, required this.maxCombo, required this.totalBonusTime, required this.avgInputSpeed, required this.characterLevel, required this.playedAt, required this.ranking, final  List<String> achievements = const <String>[]}): _achievements = achievements;
  factory _RankingGameResultResponse.fromJson(Map<String, dynamic> json) => _$RankingGameResultResponseFromJson(json);

@override final  String id;
@override final  String difficulty;
@override final  int score;
@override final  int correctCount;
@override final  int maxCombo;
@override final  int totalBonusTime;
@override final  double avgInputSpeed;
@override final  int characterLevel;
@override final  DateTime playedAt;
@override final  RankingInfo ranking;
 final  List<String> _achievements;
@override@JsonKey() List<String> get achievements {
  if (_achievements is EqualUnmodifiableListView) return _achievements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_achievements);
}


/// Create a copy of RankingGameResultResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankingGameResultResponseCopyWith<_RankingGameResultResponse> get copyWith => __$RankingGameResultResponseCopyWithImpl<_RankingGameResultResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RankingGameResultResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankingGameResultResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.score, score) || other.score == score)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.maxCombo, maxCombo) || other.maxCombo == maxCombo)&&(identical(other.totalBonusTime, totalBonusTime) || other.totalBonusTime == totalBonusTime)&&(identical(other.avgInputSpeed, avgInputSpeed) || other.avgInputSpeed == avgInputSpeed)&&(identical(other.characterLevel, characterLevel) || other.characterLevel == characterLevel)&&(identical(other.playedAt, playedAt) || other.playedAt == playedAt)&&(identical(other.ranking, ranking) || other.ranking == ranking)&&const DeepCollectionEquality().equals(other._achievements, _achievements));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,difficulty,score,correctCount,maxCombo,totalBonusTime,avgInputSpeed,characterLevel,playedAt,ranking,const DeepCollectionEquality().hash(_achievements));

@override
String toString() {
  return 'RankingGameResultResponse(id: $id, difficulty: $difficulty, score: $score, correctCount: $correctCount, maxCombo: $maxCombo, totalBonusTime: $totalBonusTime, avgInputSpeed: $avgInputSpeed, characterLevel: $characterLevel, playedAt: $playedAt, ranking: $ranking, achievements: $achievements)';
}


}

/// @nodoc
abstract mixin class _$RankingGameResultResponseCopyWith<$Res> implements $RankingGameResultResponseCopyWith<$Res> {
  factory _$RankingGameResultResponseCopyWith(_RankingGameResultResponse value, $Res Function(_RankingGameResultResponse) _then) = __$RankingGameResultResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String difficulty, int score, int correctCount, int maxCombo, int totalBonusTime, double avgInputSpeed, int characterLevel, DateTime playedAt, RankingInfo ranking, List<String> achievements
});


@override $RankingInfoCopyWith<$Res> get ranking;

}
/// @nodoc
class __$RankingGameResultResponseCopyWithImpl<$Res>
    implements _$RankingGameResultResponseCopyWith<$Res> {
  __$RankingGameResultResponseCopyWithImpl(this._self, this._then);

  final _RankingGameResultResponse _self;
  final $Res Function(_RankingGameResultResponse) _then;

/// Create a copy of RankingGameResultResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? difficulty = null,Object? score = null,Object? correctCount = null,Object? maxCombo = null,Object? totalBonusTime = null,Object? avgInputSpeed = null,Object? characterLevel = null,Object? playedAt = null,Object? ranking = null,Object? achievements = null,}) {
  return _then(_RankingGameResultResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,maxCombo: null == maxCombo ? _self.maxCombo : maxCombo // ignore: cast_nullable_to_non_nullable
as int,totalBonusTime: null == totalBonusTime ? _self.totalBonusTime : totalBonusTime // ignore: cast_nullable_to_non_nullable
as int,avgInputSpeed: null == avgInputSpeed ? _self.avgInputSpeed : avgInputSpeed // ignore: cast_nullable_to_non_nullable
as double,characterLevel: null == characterLevel ? _self.characterLevel : characterLevel // ignore: cast_nullable_to_non_nullable
as int,playedAt: null == playedAt ? _self.playedAt : playedAt // ignore: cast_nullable_to_non_nullable
as DateTime,ranking: null == ranking ? _self.ranking : ranking // ignore: cast_nullable_to_non_nullable
as RankingInfo,achievements: null == achievements ? _self._achievements : achievements // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of RankingGameResultResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RankingInfoCopyWith<$Res> get ranking {
  
  return $RankingInfoCopyWith<$Res>(_self.ranking, (value) {
    return _then(_self.copyWith(ranking: value));
  });
}
}


/// @nodoc
mixin _$RankingInfo {

 int get position; int? get previousPosition; int get totalParticipants; bool get isNewBest;
/// Create a copy of RankingInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankingInfoCopyWith<RankingInfo> get copyWith => _$RankingInfoCopyWithImpl<RankingInfo>(this as RankingInfo, _$identity);

  /// Serializes this RankingInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankingInfo&&(identical(other.position, position) || other.position == position)&&(identical(other.previousPosition, previousPosition) || other.previousPosition == previousPosition)&&(identical(other.totalParticipants, totalParticipants) || other.totalParticipants == totalParticipants)&&(identical(other.isNewBest, isNewBest) || other.isNewBest == isNewBest));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,previousPosition,totalParticipants,isNewBest);

@override
String toString() {
  return 'RankingInfo(position: $position, previousPosition: $previousPosition, totalParticipants: $totalParticipants, isNewBest: $isNewBest)';
}


}

/// @nodoc
abstract mixin class $RankingInfoCopyWith<$Res>  {
  factory $RankingInfoCopyWith(RankingInfo value, $Res Function(RankingInfo) _then) = _$RankingInfoCopyWithImpl;
@useResult
$Res call({
 int position, int? previousPosition, int totalParticipants, bool isNewBest
});




}
/// @nodoc
class _$RankingInfoCopyWithImpl<$Res>
    implements $RankingInfoCopyWith<$Res> {
  _$RankingInfoCopyWithImpl(this._self, this._then);

  final RankingInfo _self;
  final $Res Function(RankingInfo) _then;

/// Create a copy of RankingInfo
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


/// Adds pattern-matching-related methods to [RankingInfo].
extension RankingInfoPatterns on RankingInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankingInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankingInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankingInfo value)  $default,){
final _that = this;
switch (_that) {
case _RankingInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankingInfo value)?  $default,){
final _that = this;
switch (_that) {
case _RankingInfo() when $default != null:
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
case _RankingInfo() when $default != null:
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
case _RankingInfo():
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
case _RankingInfo() when $default != null:
return $default(_that.position,_that.previousPosition,_that.totalParticipants,_that.isNewBest);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RankingInfo implements RankingInfo {
  const _RankingInfo({required this.position, this.previousPosition, required this.totalParticipants, required this.isNewBest});
  factory _RankingInfo.fromJson(Map<String, dynamic> json) => _$RankingInfoFromJson(json);

@override final  int position;
@override final  int? previousPosition;
@override final  int totalParticipants;
@override final  bool isNewBest;

/// Create a copy of RankingInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankingInfoCopyWith<_RankingInfo> get copyWith => __$RankingInfoCopyWithImpl<_RankingInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RankingInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankingInfo&&(identical(other.position, position) || other.position == position)&&(identical(other.previousPosition, previousPosition) || other.previousPosition == previousPosition)&&(identical(other.totalParticipants, totalParticipants) || other.totalParticipants == totalParticipants)&&(identical(other.isNewBest, isNewBest) || other.isNewBest == isNewBest));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,previousPosition,totalParticipants,isNewBest);

@override
String toString() {
  return 'RankingInfo(position: $position, previousPosition: $previousPosition, totalParticipants: $totalParticipants, isNewBest: $isNewBest)';
}


}

/// @nodoc
abstract mixin class _$RankingInfoCopyWith<$Res> implements $RankingInfoCopyWith<$Res> {
  factory _$RankingInfoCopyWith(_RankingInfo value, $Res Function(_RankingInfo) _then) = __$RankingInfoCopyWithImpl;
@override @useResult
$Res call({
 int position, int? previousPosition, int totalParticipants, bool isNewBest
});




}
/// @nodoc
class __$RankingInfoCopyWithImpl<$Res>
    implements _$RankingInfoCopyWith<$Res> {
  __$RankingInfoCopyWithImpl(this._self, this._then);

  final _RankingInfo _self;
  final $Res Function(_RankingInfo) _then;

/// Create a copy of RankingInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? position = null,Object? previousPosition = freezed,Object? totalParticipants = null,Object? isNewBest = null,}) {
  return _then(_RankingInfo(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,previousPosition: freezed == previousPosition ? _self.previousPosition : previousPosition // ignore: cast_nullable_to_non_nullable
as int?,totalParticipants: null == totalParticipants ? _self.totalParticipants : totalParticipants // ignore: cast_nullable_to_non_nullable
as int,isNewBest: null == isNewBest ? _self.isNewBest : isNewBest // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$RankingEntry {

 int get position; DiaryUserSummary get user; int get score; int get characterLevel; int get playCount; int get maxCombo;
/// Create a copy of RankingEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankingEntryCopyWith<RankingEntry> get copyWith => _$RankingEntryCopyWithImpl<RankingEntry>(this as RankingEntry, _$identity);

  /// Serializes this RankingEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankingEntry&&(identical(other.position, position) || other.position == position)&&(identical(other.user, user) || other.user == user)&&(identical(other.score, score) || other.score == score)&&(identical(other.characterLevel, characterLevel) || other.characterLevel == characterLevel)&&(identical(other.playCount, playCount) || other.playCount == playCount)&&(identical(other.maxCombo, maxCombo) || other.maxCombo == maxCombo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,user,score,characterLevel,playCount,maxCombo);

@override
String toString() {
  return 'RankingEntry(position: $position, user: $user, score: $score, characterLevel: $characterLevel, playCount: $playCount, maxCombo: $maxCombo)';
}


}

/// @nodoc
abstract mixin class $RankingEntryCopyWith<$Res>  {
  factory $RankingEntryCopyWith(RankingEntry value, $Res Function(RankingEntry) _then) = _$RankingEntryCopyWithImpl;
@useResult
$Res call({
 int position, DiaryUserSummary user, int score, int characterLevel, int playCount, int maxCombo
});


$DiaryUserSummaryCopyWith<$Res> get user;

}
/// @nodoc
class _$RankingEntryCopyWithImpl<$Res>
    implements $RankingEntryCopyWith<$Res> {
  _$RankingEntryCopyWithImpl(this._self, this._then);

  final RankingEntry _self;
  final $Res Function(RankingEntry) _then;

/// Create a copy of RankingEntry
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
/// Create a copy of RankingEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiaryUserSummaryCopyWith<$Res> get user {
  
  return $DiaryUserSummaryCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [RankingEntry].
extension RankingEntryPatterns on RankingEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankingEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankingEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankingEntry value)  $default,){
final _that = this;
switch (_that) {
case _RankingEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankingEntry value)?  $default,){
final _that = this;
switch (_that) {
case _RankingEntry() when $default != null:
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
case _RankingEntry() when $default != null:
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
case _RankingEntry():
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
case _RankingEntry() when $default != null:
return $default(_that.position,_that.user,_that.score,_that.characterLevel,_that.playCount,_that.maxCombo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RankingEntry implements RankingEntry {
  const _RankingEntry({required this.position, required this.user, required this.score, required this.characterLevel, required this.playCount, this.maxCombo = 0});
  factory _RankingEntry.fromJson(Map<String, dynamic> json) => _$RankingEntryFromJson(json);

@override final  int position;
@override final  DiaryUserSummary user;
@override final  int score;
@override final  int characterLevel;
@override final  int playCount;
@override@JsonKey() final  int maxCombo;

/// Create a copy of RankingEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankingEntryCopyWith<_RankingEntry> get copyWith => __$RankingEntryCopyWithImpl<_RankingEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RankingEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankingEntry&&(identical(other.position, position) || other.position == position)&&(identical(other.user, user) || other.user == user)&&(identical(other.score, score) || other.score == score)&&(identical(other.characterLevel, characterLevel) || other.characterLevel == characterLevel)&&(identical(other.playCount, playCount) || other.playCount == playCount)&&(identical(other.maxCombo, maxCombo) || other.maxCombo == maxCombo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,user,score,characterLevel,playCount,maxCombo);

@override
String toString() {
  return 'RankingEntry(position: $position, user: $user, score: $score, characterLevel: $characterLevel, playCount: $playCount, maxCombo: $maxCombo)';
}


}

/// @nodoc
abstract mixin class _$RankingEntryCopyWith<$Res> implements $RankingEntryCopyWith<$Res> {
  factory _$RankingEntryCopyWith(_RankingEntry value, $Res Function(_RankingEntry) _then) = __$RankingEntryCopyWithImpl;
@override @useResult
$Res call({
 int position, DiaryUserSummary user, int score, int characterLevel, int playCount, int maxCombo
});


@override $DiaryUserSummaryCopyWith<$Res> get user;

}
/// @nodoc
class __$RankingEntryCopyWithImpl<$Res>
    implements _$RankingEntryCopyWith<$Res> {
  __$RankingEntryCopyWithImpl(this._self, this._then);

  final _RankingEntry _self;
  final $Res Function(_RankingEntry) _then;

/// Create a copy of RankingEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? position = null,Object? user = null,Object? score = null,Object? characterLevel = null,Object? playCount = null,Object? maxCombo = null,}) {
  return _then(_RankingEntry(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as DiaryUserSummary,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,characterLevel: null == characterLevel ? _self.characterLevel : characterLevel // ignore: cast_nullable_to_non_nullable
as int,playCount: null == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int,maxCombo: null == maxCombo ? _self.maxCombo : maxCombo // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of RankingEntry
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
mixin _$RankingPeriodInfo {

 DateTime get start; DateTime get end;
/// Create a copy of RankingPeriodInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankingPeriodInfoCopyWith<RankingPeriodInfo> get copyWith => _$RankingPeriodInfoCopyWithImpl<RankingPeriodInfo>(this as RankingPeriodInfo, _$identity);

  /// Serializes this RankingPeriodInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankingPeriodInfo&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end);

@override
String toString() {
  return 'RankingPeriodInfo(start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class $RankingPeriodInfoCopyWith<$Res>  {
  factory $RankingPeriodInfoCopyWith(RankingPeriodInfo value, $Res Function(RankingPeriodInfo) _then) = _$RankingPeriodInfoCopyWithImpl;
@useResult
$Res call({
 DateTime start, DateTime end
});




}
/// @nodoc
class _$RankingPeriodInfoCopyWithImpl<$Res>
    implements $RankingPeriodInfoCopyWith<$Res> {
  _$RankingPeriodInfoCopyWithImpl(this._self, this._then);

  final RankingPeriodInfo _self;
  final $Res Function(RankingPeriodInfo) _then;

/// Create a copy of RankingPeriodInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? end = null,}) {
  return _then(_self.copyWith(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RankingPeriodInfo].
extension RankingPeriodInfoPatterns on RankingPeriodInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankingPeriodInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankingPeriodInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankingPeriodInfo value)  $default,){
final _that = this;
switch (_that) {
case _RankingPeriodInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankingPeriodInfo value)?  $default,){
final _that = this;
switch (_that) {
case _RankingPeriodInfo() when $default != null:
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
case _RankingPeriodInfo() when $default != null:
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
case _RankingPeriodInfo():
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
case _RankingPeriodInfo() when $default != null:
return $default(_that.start,_that.end);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RankingPeriodInfo implements RankingPeriodInfo {
  const _RankingPeriodInfo({required this.start, required this.end});
  factory _RankingPeriodInfo.fromJson(Map<String, dynamic> json) => _$RankingPeriodInfoFromJson(json);

@override final  DateTime start;
@override final  DateTime end;

/// Create a copy of RankingPeriodInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankingPeriodInfoCopyWith<_RankingPeriodInfo> get copyWith => __$RankingPeriodInfoCopyWithImpl<_RankingPeriodInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RankingPeriodInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankingPeriodInfo&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end);

@override
String toString() {
  return 'RankingPeriodInfo(start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class _$RankingPeriodInfoCopyWith<$Res> implements $RankingPeriodInfoCopyWith<$Res> {
  factory _$RankingPeriodInfoCopyWith(_RankingPeriodInfo value, $Res Function(_RankingPeriodInfo) _then) = __$RankingPeriodInfoCopyWithImpl;
@override @useResult
$Res call({
 DateTime start, DateTime end
});




}
/// @nodoc
class __$RankingPeriodInfoCopyWithImpl<$Res>
    implements _$RankingPeriodInfoCopyWith<$Res> {
  __$RankingPeriodInfoCopyWithImpl(this._self, this._then);

  final _RankingPeriodInfo _self;
  final $Res Function(_RankingPeriodInfo) _then;

/// Create a copy of RankingPeriodInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = null,}) {
  return _then(_RankingPeriodInfo(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$MyRankingInfo {

 int get position; int get score; int get characterLevel;
/// Create a copy of MyRankingInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyRankingInfoCopyWith<MyRankingInfo> get copyWith => _$MyRankingInfoCopyWithImpl<MyRankingInfo>(this as MyRankingInfo, _$identity);

  /// Serializes this MyRankingInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyRankingInfo&&(identical(other.position, position) || other.position == position)&&(identical(other.score, score) || other.score == score)&&(identical(other.characterLevel, characterLevel) || other.characterLevel == characterLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,score,characterLevel);

@override
String toString() {
  return 'MyRankingInfo(position: $position, score: $score, characterLevel: $characterLevel)';
}


}

/// @nodoc
abstract mixin class $MyRankingInfoCopyWith<$Res>  {
  factory $MyRankingInfoCopyWith(MyRankingInfo value, $Res Function(MyRankingInfo) _then) = _$MyRankingInfoCopyWithImpl;
@useResult
$Res call({
 int position, int score, int characterLevel
});




}
/// @nodoc
class _$MyRankingInfoCopyWithImpl<$Res>
    implements $MyRankingInfoCopyWith<$Res> {
  _$MyRankingInfoCopyWithImpl(this._self, this._then);

  final MyRankingInfo _self;
  final $Res Function(MyRankingInfo) _then;

/// Create a copy of MyRankingInfo
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


/// Adds pattern-matching-related methods to [MyRankingInfo].
extension MyRankingInfoPatterns on MyRankingInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyRankingInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyRankingInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyRankingInfo value)  $default,){
final _that = this;
switch (_that) {
case _MyRankingInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyRankingInfo value)?  $default,){
final _that = this;
switch (_that) {
case _MyRankingInfo() when $default != null:
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
case _MyRankingInfo() when $default != null:
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
case _MyRankingInfo():
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
case _MyRankingInfo() when $default != null:
return $default(_that.position,_that.score,_that.characterLevel);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyRankingInfo implements MyRankingInfo {
  const _MyRankingInfo({required this.position, required this.score, required this.characterLevel});
  factory _MyRankingInfo.fromJson(Map<String, dynamic> json) => _$MyRankingInfoFromJson(json);

@override final  int position;
@override final  int score;
@override final  int characterLevel;

/// Create a copy of MyRankingInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyRankingInfoCopyWith<_MyRankingInfo> get copyWith => __$MyRankingInfoCopyWithImpl<_MyRankingInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyRankingInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyRankingInfo&&(identical(other.position, position) || other.position == position)&&(identical(other.score, score) || other.score == score)&&(identical(other.characterLevel, characterLevel) || other.characterLevel == characterLevel));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,position,score,characterLevel);

@override
String toString() {
  return 'MyRankingInfo(position: $position, score: $score, characterLevel: $characterLevel)';
}


}

/// @nodoc
abstract mixin class _$MyRankingInfoCopyWith<$Res> implements $MyRankingInfoCopyWith<$Res> {
  factory _$MyRankingInfoCopyWith(_MyRankingInfo value, $Res Function(_MyRankingInfo) _then) = __$MyRankingInfoCopyWithImpl;
@override @useResult
$Res call({
 int position, int score, int characterLevel
});




}
/// @nodoc
class __$MyRankingInfoCopyWithImpl<$Res>
    implements _$MyRankingInfoCopyWith<$Res> {
  __$MyRankingInfoCopyWithImpl(this._self, this._then);

  final _MyRankingInfo _self;
  final $Res Function(_MyRankingInfo) _then;

/// Create a copy of MyRankingInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? position = null,Object? score = null,Object? characterLevel = null,}) {
  return _then(_MyRankingInfo(
position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,characterLevel: null == characterLevel ? _self.characterLevel : characterLevel // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$RankingDataResponse {

 RankingPeriodInfo get period; List<RankingEntry> get rankings; MyRankingInfo? get myRanking; int get totalParticipants;
/// Create a copy of RankingDataResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankingDataResponseCopyWith<RankingDataResponse> get copyWith => _$RankingDataResponseCopyWithImpl<RankingDataResponse>(this as RankingDataResponse, _$identity);

  /// Serializes this RankingDataResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankingDataResponse&&(identical(other.period, period) || other.period == period)&&const DeepCollectionEquality().equals(other.rankings, rankings)&&(identical(other.myRanking, myRanking) || other.myRanking == myRanking)&&(identical(other.totalParticipants, totalParticipants) || other.totalParticipants == totalParticipants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,period,const DeepCollectionEquality().hash(rankings),myRanking,totalParticipants);

@override
String toString() {
  return 'RankingDataResponse(period: $period, rankings: $rankings, myRanking: $myRanking, totalParticipants: $totalParticipants)';
}


}

/// @nodoc
abstract mixin class $RankingDataResponseCopyWith<$Res>  {
  factory $RankingDataResponseCopyWith(RankingDataResponse value, $Res Function(RankingDataResponse) _then) = _$RankingDataResponseCopyWithImpl;
@useResult
$Res call({
 RankingPeriodInfo period, List<RankingEntry> rankings, MyRankingInfo? myRanking, int totalParticipants
});


$RankingPeriodInfoCopyWith<$Res> get period;$MyRankingInfoCopyWith<$Res>? get myRanking;

}
/// @nodoc
class _$RankingDataResponseCopyWithImpl<$Res>
    implements $RankingDataResponseCopyWith<$Res> {
  _$RankingDataResponseCopyWithImpl(this._self, this._then);

  final RankingDataResponse _self;
  final $Res Function(RankingDataResponse) _then;

/// Create a copy of RankingDataResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? period = null,Object? rankings = null,Object? myRanking = freezed,Object? totalParticipants = null,}) {
  return _then(_self.copyWith(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as RankingPeriodInfo,rankings: null == rankings ? _self.rankings : rankings // ignore: cast_nullable_to_non_nullable
as List<RankingEntry>,myRanking: freezed == myRanking ? _self.myRanking : myRanking // ignore: cast_nullable_to_non_nullable
as MyRankingInfo?,totalParticipants: null == totalParticipants ? _self.totalParticipants : totalParticipants // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of RankingDataResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RankingPeriodInfoCopyWith<$Res> get period {
  
  return $RankingPeriodInfoCopyWith<$Res>(_self.period, (value) {
    return _then(_self.copyWith(period: value));
  });
}/// Create a copy of RankingDataResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyRankingInfoCopyWith<$Res>? get myRanking {
    if (_self.myRanking == null) {
    return null;
  }

  return $MyRankingInfoCopyWith<$Res>(_self.myRanking!, (value) {
    return _then(_self.copyWith(myRanking: value));
  });
}
}


/// Adds pattern-matching-related methods to [RankingDataResponse].
extension RankingDataResponsePatterns on RankingDataResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankingDataResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankingDataResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankingDataResponse value)  $default,){
final _that = this;
switch (_that) {
case _RankingDataResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankingDataResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RankingDataResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RankingPeriodInfo period,  List<RankingEntry> rankings,  MyRankingInfo? myRanking,  int totalParticipants)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RankingDataResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RankingPeriodInfo period,  List<RankingEntry> rankings,  MyRankingInfo? myRanking,  int totalParticipants)  $default,) {final _that = this;
switch (_that) {
case _RankingDataResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RankingPeriodInfo period,  List<RankingEntry> rankings,  MyRankingInfo? myRanking,  int totalParticipants)?  $default,) {final _that = this;
switch (_that) {
case _RankingDataResponse() when $default != null:
return $default(_that.period,_that.rankings,_that.myRanking,_that.totalParticipants);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RankingDataResponse implements RankingDataResponse {
  const _RankingDataResponse({required this.period, final  List<RankingEntry> rankings = const <RankingEntry>[], this.myRanking, required this.totalParticipants}): _rankings = rankings;
  factory _RankingDataResponse.fromJson(Map<String, dynamic> json) => _$RankingDataResponseFromJson(json);

@override final  RankingPeriodInfo period;
 final  List<RankingEntry> _rankings;
@override@JsonKey() List<RankingEntry> get rankings {
  if (_rankings is EqualUnmodifiableListView) return _rankings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rankings);
}

@override final  MyRankingInfo? myRanking;
@override final  int totalParticipants;

/// Create a copy of RankingDataResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankingDataResponseCopyWith<_RankingDataResponse> get copyWith => __$RankingDataResponseCopyWithImpl<_RankingDataResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RankingDataResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankingDataResponse&&(identical(other.period, period) || other.period == period)&&const DeepCollectionEquality().equals(other._rankings, _rankings)&&(identical(other.myRanking, myRanking) || other.myRanking == myRanking)&&(identical(other.totalParticipants, totalParticipants) || other.totalParticipants == totalParticipants));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,period,const DeepCollectionEquality().hash(_rankings),myRanking,totalParticipants);

@override
String toString() {
  return 'RankingDataResponse(period: $period, rankings: $rankings, myRanking: $myRanking, totalParticipants: $totalParticipants)';
}


}

/// @nodoc
abstract mixin class _$RankingDataResponseCopyWith<$Res> implements $RankingDataResponseCopyWith<$Res> {
  factory _$RankingDataResponseCopyWith(_RankingDataResponse value, $Res Function(_RankingDataResponse) _then) = __$RankingDataResponseCopyWithImpl;
@override @useResult
$Res call({
 RankingPeriodInfo period, List<RankingEntry> rankings, MyRankingInfo? myRanking, int totalParticipants
});


@override $RankingPeriodInfoCopyWith<$Res> get period;@override $MyRankingInfoCopyWith<$Res>? get myRanking;

}
/// @nodoc
class __$RankingDataResponseCopyWithImpl<$Res>
    implements _$RankingDataResponseCopyWith<$Res> {
  __$RankingDataResponseCopyWithImpl(this._self, this._then);

  final _RankingDataResponse _self;
  final $Res Function(_RankingDataResponse) _then;

/// Create a copy of RankingDataResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? period = null,Object? rankings = null,Object? myRanking = freezed,Object? totalParticipants = null,}) {
  return _then(_RankingDataResponse(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as RankingPeriodInfo,rankings: null == rankings ? _self._rankings : rankings // ignore: cast_nullable_to_non_nullable
as List<RankingEntry>,myRanking: freezed == myRanking ? _self.myRanking : myRanking // ignore: cast_nullable_to_non_nullable
as MyRankingInfo?,totalParticipants: null == totalParticipants ? _self.totalParticipants : totalParticipants // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of RankingDataResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RankingPeriodInfoCopyWith<$Res> get period {
  
  return $RankingPeriodInfoCopyWith<$Res>(_self.period, (value) {
    return _then(_self.copyWith(period: value));
  });
}/// Create a copy of RankingDataResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MyRankingInfoCopyWith<$Res>? get myRanking {
    if (_self.myRanking == null) {
    return null;
  }

  return $MyRankingInfoCopyWith<$Res>(_self.myRanking!, (value) {
    return _then(_self.copyWith(myRanking: value));
  });
}
}


/// @nodoc
mixin _$BestScoreByDifficulty {

 int get all; int get beginner; int get intermediate; int get advanced;
/// Create a copy of BestScoreByDifficulty
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BestScoreByDifficultyCopyWith<BestScoreByDifficulty> get copyWith => _$BestScoreByDifficultyCopyWithImpl<BestScoreByDifficulty>(this as BestScoreByDifficulty, _$identity);

  /// Serializes this BestScoreByDifficulty to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BestScoreByDifficulty&&(identical(other.all, all) || other.all == all)&&(identical(other.beginner, beginner) || other.beginner == beginner)&&(identical(other.intermediate, intermediate) || other.intermediate == intermediate)&&(identical(other.advanced, advanced) || other.advanced == advanced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,all,beginner,intermediate,advanced);

@override
String toString() {
  return 'BestScoreByDifficulty(all: $all, beginner: $beginner, intermediate: $intermediate, advanced: $advanced)';
}


}

/// @nodoc
abstract mixin class $BestScoreByDifficultyCopyWith<$Res>  {
  factory $BestScoreByDifficultyCopyWith(BestScoreByDifficulty value, $Res Function(BestScoreByDifficulty) _then) = _$BestScoreByDifficultyCopyWithImpl;
@useResult
$Res call({
 int all, int beginner, int intermediate, int advanced
});




}
/// @nodoc
class _$BestScoreByDifficultyCopyWithImpl<$Res>
    implements $BestScoreByDifficultyCopyWith<$Res> {
  _$BestScoreByDifficultyCopyWithImpl(this._self, this._then);

  final BestScoreByDifficulty _self;
  final $Res Function(BestScoreByDifficulty) _then;

/// Create a copy of BestScoreByDifficulty
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


/// Adds pattern-matching-related methods to [BestScoreByDifficulty].
extension BestScoreByDifficultyPatterns on BestScoreByDifficulty {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BestScoreByDifficulty value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BestScoreByDifficulty() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BestScoreByDifficulty value)  $default,){
final _that = this;
switch (_that) {
case _BestScoreByDifficulty():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BestScoreByDifficulty value)?  $default,){
final _that = this;
switch (_that) {
case _BestScoreByDifficulty() when $default != null:
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
case _BestScoreByDifficulty() when $default != null:
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
case _BestScoreByDifficulty():
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
case _BestScoreByDifficulty() when $default != null:
return $default(_that.all,_that.beginner,_that.intermediate,_that.advanced);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BestScoreByDifficulty implements BestScoreByDifficulty {
  const _BestScoreByDifficulty({required this.all, required this.beginner, required this.intermediate, required this.advanced});
  factory _BestScoreByDifficulty.fromJson(Map<String, dynamic> json) => _$BestScoreByDifficultyFromJson(json);

@override final  int all;
@override final  int beginner;
@override final  int intermediate;
@override final  int advanced;

/// Create a copy of BestScoreByDifficulty
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BestScoreByDifficultyCopyWith<_BestScoreByDifficulty> get copyWith => __$BestScoreByDifficultyCopyWithImpl<_BestScoreByDifficulty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BestScoreByDifficultyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BestScoreByDifficulty&&(identical(other.all, all) || other.all == all)&&(identical(other.beginner, beginner) || other.beginner == beginner)&&(identical(other.intermediate, intermediate) || other.intermediate == intermediate)&&(identical(other.advanced, advanced) || other.advanced == advanced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,all,beginner,intermediate,advanced);

@override
String toString() {
  return 'BestScoreByDifficulty(all: $all, beginner: $beginner, intermediate: $intermediate, advanced: $advanced)';
}


}

/// @nodoc
abstract mixin class _$BestScoreByDifficultyCopyWith<$Res> implements $BestScoreByDifficultyCopyWith<$Res> {
  factory _$BestScoreByDifficultyCopyWith(_BestScoreByDifficulty value, $Res Function(_BestScoreByDifficulty) _then) = __$BestScoreByDifficultyCopyWithImpl;
@override @useResult
$Res call({
 int all, int beginner, int intermediate, int advanced
});




}
/// @nodoc
class __$BestScoreByDifficultyCopyWithImpl<$Res>
    implements _$BestScoreByDifficultyCopyWith<$Res> {
  __$BestScoreByDifficultyCopyWithImpl(this._self, this._then);

  final _BestScoreByDifficulty _self;
  final $Res Function(_BestScoreByDifficulty) _then;

/// Create a copy of BestScoreByDifficulty
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? all = null,Object? beginner = null,Object? intermediate = null,Object? advanced = null,}) {
  return _then(_BestScoreByDifficulty(
all: null == all ? _self.all : all // ignore: cast_nullable_to_non_nullable
as int,beginner: null == beginner ? _self.beginner : beginner // ignore: cast_nullable_to_non_nullable
as int,intermediate: null == intermediate ? _self.intermediate : intermediate // ignore: cast_nullable_to_non_nullable
as int,advanced: null == advanced ? _self.advanced : advanced // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$MonthlyRankingByDifficulty {

 int? get all; int? get beginner; int? get intermediate; int? get advanced;
/// Create a copy of MonthlyRankingByDifficulty
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyRankingByDifficultyCopyWith<MonthlyRankingByDifficulty> get copyWith => _$MonthlyRankingByDifficultyCopyWithImpl<MonthlyRankingByDifficulty>(this as MonthlyRankingByDifficulty, _$identity);

  /// Serializes this MonthlyRankingByDifficulty to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyRankingByDifficulty&&(identical(other.all, all) || other.all == all)&&(identical(other.beginner, beginner) || other.beginner == beginner)&&(identical(other.intermediate, intermediate) || other.intermediate == intermediate)&&(identical(other.advanced, advanced) || other.advanced == advanced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,all,beginner,intermediate,advanced);

@override
String toString() {
  return 'MonthlyRankingByDifficulty(all: $all, beginner: $beginner, intermediate: $intermediate, advanced: $advanced)';
}


}

/// @nodoc
abstract mixin class $MonthlyRankingByDifficultyCopyWith<$Res>  {
  factory $MonthlyRankingByDifficultyCopyWith(MonthlyRankingByDifficulty value, $Res Function(MonthlyRankingByDifficulty) _then) = _$MonthlyRankingByDifficultyCopyWithImpl;
@useResult
$Res call({
 int? all, int? beginner, int? intermediate, int? advanced
});




}
/// @nodoc
class _$MonthlyRankingByDifficultyCopyWithImpl<$Res>
    implements $MonthlyRankingByDifficultyCopyWith<$Res> {
  _$MonthlyRankingByDifficultyCopyWithImpl(this._self, this._then);

  final MonthlyRankingByDifficulty _self;
  final $Res Function(MonthlyRankingByDifficulty) _then;

/// Create a copy of MonthlyRankingByDifficulty
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


/// Adds pattern-matching-related methods to [MonthlyRankingByDifficulty].
extension MonthlyRankingByDifficultyPatterns on MonthlyRankingByDifficulty {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyRankingByDifficulty value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyRankingByDifficulty() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyRankingByDifficulty value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyRankingByDifficulty():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyRankingByDifficulty value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyRankingByDifficulty() when $default != null:
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
case _MonthlyRankingByDifficulty() when $default != null:
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
case _MonthlyRankingByDifficulty():
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
case _MonthlyRankingByDifficulty() when $default != null:
return $default(_that.all,_that.beginner,_that.intermediate,_that.advanced);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthlyRankingByDifficulty implements MonthlyRankingByDifficulty {
  const _MonthlyRankingByDifficulty({this.all, this.beginner, this.intermediate, this.advanced});
  factory _MonthlyRankingByDifficulty.fromJson(Map<String, dynamic> json) => _$MonthlyRankingByDifficultyFromJson(json);

@override final  int? all;
@override final  int? beginner;
@override final  int? intermediate;
@override final  int? advanced;

/// Create a copy of MonthlyRankingByDifficulty
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyRankingByDifficultyCopyWith<_MonthlyRankingByDifficulty> get copyWith => __$MonthlyRankingByDifficultyCopyWithImpl<_MonthlyRankingByDifficulty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyRankingByDifficultyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyRankingByDifficulty&&(identical(other.all, all) || other.all == all)&&(identical(other.beginner, beginner) || other.beginner == beginner)&&(identical(other.intermediate, intermediate) || other.intermediate == intermediate)&&(identical(other.advanced, advanced) || other.advanced == advanced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,all,beginner,intermediate,advanced);

@override
String toString() {
  return 'MonthlyRankingByDifficulty(all: $all, beginner: $beginner, intermediate: $intermediate, advanced: $advanced)';
}


}

/// @nodoc
abstract mixin class _$MonthlyRankingByDifficultyCopyWith<$Res> implements $MonthlyRankingByDifficultyCopyWith<$Res> {
  factory _$MonthlyRankingByDifficultyCopyWith(_MonthlyRankingByDifficulty value, $Res Function(_MonthlyRankingByDifficulty) _then) = __$MonthlyRankingByDifficultyCopyWithImpl;
@override @useResult
$Res call({
 int? all, int? beginner, int? intermediate, int? advanced
});




}
/// @nodoc
class __$MonthlyRankingByDifficultyCopyWithImpl<$Res>
    implements _$MonthlyRankingByDifficultyCopyWith<$Res> {
  __$MonthlyRankingByDifficultyCopyWithImpl(this._self, this._then);

  final _MonthlyRankingByDifficulty _self;
  final $Res Function(_MonthlyRankingByDifficulty) _then;

/// Create a copy of MonthlyRankingByDifficulty
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? all = freezed,Object? beginner = freezed,Object? intermediate = freezed,Object? advanced = freezed,}) {
  return _then(_MonthlyRankingByDifficulty(
all: freezed == all ? _self.all : all // ignore: cast_nullable_to_non_nullable
as int?,beginner: freezed == beginner ? _self.beginner : beginner // ignore: cast_nullable_to_non_nullable
as int?,intermediate: freezed == intermediate ? _self.intermediate : intermediate // ignore: cast_nullable_to_non_nullable
as int?,advanced: freezed == advanced ? _self.advanced : advanced // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$RankingGameAchievements {

 int get maxCombo; int get maxCharacterLevel; int get totalBonusTimeEarned;
/// Create a copy of RankingGameAchievements
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankingGameAchievementsCopyWith<RankingGameAchievements> get copyWith => _$RankingGameAchievementsCopyWithImpl<RankingGameAchievements>(this as RankingGameAchievements, _$identity);

  /// Serializes this RankingGameAchievements to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankingGameAchievements&&(identical(other.maxCombo, maxCombo) || other.maxCombo == maxCombo)&&(identical(other.maxCharacterLevel, maxCharacterLevel) || other.maxCharacterLevel == maxCharacterLevel)&&(identical(other.totalBonusTimeEarned, totalBonusTimeEarned) || other.totalBonusTimeEarned == totalBonusTimeEarned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,maxCombo,maxCharacterLevel,totalBonusTimeEarned);

@override
String toString() {
  return 'RankingGameAchievements(maxCombo: $maxCombo, maxCharacterLevel: $maxCharacterLevel, totalBonusTimeEarned: $totalBonusTimeEarned)';
}


}

/// @nodoc
abstract mixin class $RankingGameAchievementsCopyWith<$Res>  {
  factory $RankingGameAchievementsCopyWith(RankingGameAchievements value, $Res Function(RankingGameAchievements) _then) = _$RankingGameAchievementsCopyWithImpl;
@useResult
$Res call({
 int maxCombo, int maxCharacterLevel, int totalBonusTimeEarned
});




}
/// @nodoc
class _$RankingGameAchievementsCopyWithImpl<$Res>
    implements $RankingGameAchievementsCopyWith<$Res> {
  _$RankingGameAchievementsCopyWithImpl(this._self, this._then);

  final RankingGameAchievements _self;
  final $Res Function(RankingGameAchievements) _then;

/// Create a copy of RankingGameAchievements
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


/// Adds pattern-matching-related methods to [RankingGameAchievements].
extension RankingGameAchievementsPatterns on RankingGameAchievements {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankingGameAchievements value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankingGameAchievements() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankingGameAchievements value)  $default,){
final _that = this;
switch (_that) {
case _RankingGameAchievements():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankingGameAchievements value)?  $default,){
final _that = this;
switch (_that) {
case _RankingGameAchievements() when $default != null:
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
case _RankingGameAchievements() when $default != null:
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
case _RankingGameAchievements():
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
case _RankingGameAchievements() when $default != null:
return $default(_that.maxCombo,_that.maxCharacterLevel,_that.totalBonusTimeEarned);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RankingGameAchievements implements RankingGameAchievements {
  const _RankingGameAchievements({required this.maxCombo, required this.maxCharacterLevel, required this.totalBonusTimeEarned});
  factory _RankingGameAchievements.fromJson(Map<String, dynamic> json) => _$RankingGameAchievementsFromJson(json);

@override final  int maxCombo;
@override final  int maxCharacterLevel;
@override final  int totalBonusTimeEarned;

/// Create a copy of RankingGameAchievements
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankingGameAchievementsCopyWith<_RankingGameAchievements> get copyWith => __$RankingGameAchievementsCopyWithImpl<_RankingGameAchievements>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RankingGameAchievementsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankingGameAchievements&&(identical(other.maxCombo, maxCombo) || other.maxCombo == maxCombo)&&(identical(other.maxCharacterLevel, maxCharacterLevel) || other.maxCharacterLevel == maxCharacterLevel)&&(identical(other.totalBonusTimeEarned, totalBonusTimeEarned) || other.totalBonusTimeEarned == totalBonusTimeEarned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,maxCombo,maxCharacterLevel,totalBonusTimeEarned);

@override
String toString() {
  return 'RankingGameAchievements(maxCombo: $maxCombo, maxCharacterLevel: $maxCharacterLevel, totalBonusTimeEarned: $totalBonusTimeEarned)';
}


}

/// @nodoc
abstract mixin class _$RankingGameAchievementsCopyWith<$Res> implements $RankingGameAchievementsCopyWith<$Res> {
  factory _$RankingGameAchievementsCopyWith(_RankingGameAchievements value, $Res Function(_RankingGameAchievements) _then) = __$RankingGameAchievementsCopyWithImpl;
@override @useResult
$Res call({
 int maxCombo, int maxCharacterLevel, int totalBonusTimeEarned
});




}
/// @nodoc
class __$RankingGameAchievementsCopyWithImpl<$Res>
    implements _$RankingGameAchievementsCopyWith<$Res> {
  __$RankingGameAchievementsCopyWithImpl(this._self, this._then);

  final _RankingGameAchievements _self;
  final $Res Function(_RankingGameAchievements) _then;

/// Create a copy of RankingGameAchievements
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? maxCombo = null,Object? maxCharacterLevel = null,Object? totalBonusTimeEarned = null,}) {
  return _then(_RankingGameAchievements(
maxCombo: null == maxCombo ? _self.maxCombo : maxCombo // ignore: cast_nullable_to_non_nullable
as int,maxCharacterLevel: null == maxCharacterLevel ? _self.maxCharacterLevel : maxCharacterLevel // ignore: cast_nullable_to_non_nullable
as int,totalBonusTimeEarned: null == totalBonusTimeEarned ? _self.totalBonusTimeEarned : totalBonusTimeEarned // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$RankingGameUserStats {

 int get totalPlays; BestScoreByDifficulty get bestScore; MonthlyRankingByDifficulty get monthlyRanking; RankingGameAchievements get achievements; List<RankingGameResult> get recentResults;
/// Create a copy of RankingGameUserStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankingGameUserStatsCopyWith<RankingGameUserStats> get copyWith => _$RankingGameUserStatsCopyWithImpl<RankingGameUserStats>(this as RankingGameUserStats, _$identity);

  /// Serializes this RankingGameUserStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankingGameUserStats&&(identical(other.totalPlays, totalPlays) || other.totalPlays == totalPlays)&&(identical(other.bestScore, bestScore) || other.bestScore == bestScore)&&(identical(other.monthlyRanking, monthlyRanking) || other.monthlyRanking == monthlyRanking)&&(identical(other.achievements, achievements) || other.achievements == achievements)&&const DeepCollectionEquality().equals(other.recentResults, recentResults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalPlays,bestScore,monthlyRanking,achievements,const DeepCollectionEquality().hash(recentResults));

@override
String toString() {
  return 'RankingGameUserStats(totalPlays: $totalPlays, bestScore: $bestScore, monthlyRanking: $monthlyRanking, achievements: $achievements, recentResults: $recentResults)';
}


}

/// @nodoc
abstract mixin class $RankingGameUserStatsCopyWith<$Res>  {
  factory $RankingGameUserStatsCopyWith(RankingGameUserStats value, $Res Function(RankingGameUserStats) _then) = _$RankingGameUserStatsCopyWithImpl;
@useResult
$Res call({
 int totalPlays, BestScoreByDifficulty bestScore, MonthlyRankingByDifficulty monthlyRanking, RankingGameAchievements achievements, List<RankingGameResult> recentResults
});


$BestScoreByDifficultyCopyWith<$Res> get bestScore;$MonthlyRankingByDifficultyCopyWith<$Res> get monthlyRanking;$RankingGameAchievementsCopyWith<$Res> get achievements;

}
/// @nodoc
class _$RankingGameUserStatsCopyWithImpl<$Res>
    implements $RankingGameUserStatsCopyWith<$Res> {
  _$RankingGameUserStatsCopyWithImpl(this._self, this._then);

  final RankingGameUserStats _self;
  final $Res Function(RankingGameUserStats) _then;

/// Create a copy of RankingGameUserStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalPlays = null,Object? bestScore = null,Object? monthlyRanking = null,Object? achievements = null,Object? recentResults = null,}) {
  return _then(_self.copyWith(
totalPlays: null == totalPlays ? _self.totalPlays : totalPlays // ignore: cast_nullable_to_non_nullable
as int,bestScore: null == bestScore ? _self.bestScore : bestScore // ignore: cast_nullable_to_non_nullable
as BestScoreByDifficulty,monthlyRanking: null == monthlyRanking ? _self.monthlyRanking : monthlyRanking // ignore: cast_nullable_to_non_nullable
as MonthlyRankingByDifficulty,achievements: null == achievements ? _self.achievements : achievements // ignore: cast_nullable_to_non_nullable
as RankingGameAchievements,recentResults: null == recentResults ? _self.recentResults : recentResults // ignore: cast_nullable_to_non_nullable
as List<RankingGameResult>,
  ));
}
/// Create a copy of RankingGameUserStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BestScoreByDifficultyCopyWith<$Res> get bestScore {
  
  return $BestScoreByDifficultyCopyWith<$Res>(_self.bestScore, (value) {
    return _then(_self.copyWith(bestScore: value));
  });
}/// Create a copy of RankingGameUserStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonthlyRankingByDifficultyCopyWith<$Res> get monthlyRanking {
  
  return $MonthlyRankingByDifficultyCopyWith<$Res>(_self.monthlyRanking, (value) {
    return _then(_self.copyWith(monthlyRanking: value));
  });
}/// Create a copy of RankingGameUserStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RankingGameAchievementsCopyWith<$Res> get achievements {
  
  return $RankingGameAchievementsCopyWith<$Res>(_self.achievements, (value) {
    return _then(_self.copyWith(achievements: value));
  });
}
}


/// Adds pattern-matching-related methods to [RankingGameUserStats].
extension RankingGameUserStatsPatterns on RankingGameUserStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankingGameUserStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankingGameUserStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankingGameUserStats value)  $default,){
final _that = this;
switch (_that) {
case _RankingGameUserStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankingGameUserStats value)?  $default,){
final _that = this;
switch (_that) {
case _RankingGameUserStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalPlays,  BestScoreByDifficulty bestScore,  MonthlyRankingByDifficulty monthlyRanking,  RankingGameAchievements achievements,  List<RankingGameResult> recentResults)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RankingGameUserStats() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalPlays,  BestScoreByDifficulty bestScore,  MonthlyRankingByDifficulty monthlyRanking,  RankingGameAchievements achievements,  List<RankingGameResult> recentResults)  $default,) {final _that = this;
switch (_that) {
case _RankingGameUserStats():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalPlays,  BestScoreByDifficulty bestScore,  MonthlyRankingByDifficulty monthlyRanking,  RankingGameAchievements achievements,  List<RankingGameResult> recentResults)?  $default,) {final _that = this;
switch (_that) {
case _RankingGameUserStats() when $default != null:
return $default(_that.totalPlays,_that.bestScore,_that.monthlyRanking,_that.achievements,_that.recentResults);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RankingGameUserStats implements RankingGameUserStats {
  const _RankingGameUserStats({required this.totalPlays, required this.bestScore, required this.monthlyRanking, required this.achievements, final  List<RankingGameResult> recentResults = const <RankingGameResult>[]}): _recentResults = recentResults;
  factory _RankingGameUserStats.fromJson(Map<String, dynamic> json) => _$RankingGameUserStatsFromJson(json);

@override final  int totalPlays;
@override final  BestScoreByDifficulty bestScore;
@override final  MonthlyRankingByDifficulty monthlyRanking;
@override final  RankingGameAchievements achievements;
 final  List<RankingGameResult> _recentResults;
@override@JsonKey() List<RankingGameResult> get recentResults {
  if (_recentResults is EqualUnmodifiableListView) return _recentResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentResults);
}


/// Create a copy of RankingGameUserStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankingGameUserStatsCopyWith<_RankingGameUserStats> get copyWith => __$RankingGameUserStatsCopyWithImpl<_RankingGameUserStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RankingGameUserStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankingGameUserStats&&(identical(other.totalPlays, totalPlays) || other.totalPlays == totalPlays)&&(identical(other.bestScore, bestScore) || other.bestScore == bestScore)&&(identical(other.monthlyRanking, monthlyRanking) || other.monthlyRanking == monthlyRanking)&&(identical(other.achievements, achievements) || other.achievements == achievements)&&const DeepCollectionEquality().equals(other._recentResults, _recentResults));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalPlays,bestScore,monthlyRanking,achievements,const DeepCollectionEquality().hash(_recentResults));

@override
String toString() {
  return 'RankingGameUserStats(totalPlays: $totalPlays, bestScore: $bestScore, monthlyRanking: $monthlyRanking, achievements: $achievements, recentResults: $recentResults)';
}


}

/// @nodoc
abstract mixin class _$RankingGameUserStatsCopyWith<$Res> implements $RankingGameUserStatsCopyWith<$Res> {
  factory _$RankingGameUserStatsCopyWith(_RankingGameUserStats value, $Res Function(_RankingGameUserStats) _then) = __$RankingGameUserStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalPlays, BestScoreByDifficulty bestScore, MonthlyRankingByDifficulty monthlyRanking, RankingGameAchievements achievements, List<RankingGameResult> recentResults
});


@override $BestScoreByDifficultyCopyWith<$Res> get bestScore;@override $MonthlyRankingByDifficultyCopyWith<$Res> get monthlyRanking;@override $RankingGameAchievementsCopyWith<$Res> get achievements;

}
/// @nodoc
class __$RankingGameUserStatsCopyWithImpl<$Res>
    implements _$RankingGameUserStatsCopyWith<$Res> {
  __$RankingGameUserStatsCopyWithImpl(this._self, this._then);

  final _RankingGameUserStats _self;
  final $Res Function(_RankingGameUserStats) _then;

/// Create a copy of RankingGameUserStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalPlays = null,Object? bestScore = null,Object? monthlyRanking = null,Object? achievements = null,Object? recentResults = null,}) {
  return _then(_RankingGameUserStats(
totalPlays: null == totalPlays ? _self.totalPlays : totalPlays // ignore: cast_nullable_to_non_nullable
as int,bestScore: null == bestScore ? _self.bestScore : bestScore // ignore: cast_nullable_to_non_nullable
as BestScoreByDifficulty,monthlyRanking: null == monthlyRanking ? _self.monthlyRanking : monthlyRanking // ignore: cast_nullable_to_non_nullable
as MonthlyRankingByDifficulty,achievements: null == achievements ? _self.achievements : achievements // ignore: cast_nullable_to_non_nullable
as RankingGameAchievements,recentResults: null == recentResults ? _self._recentResults : recentResults // ignore: cast_nullable_to_non_nullable
as List<RankingGameResult>,
  ));
}

/// Create a copy of RankingGameUserStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BestScoreByDifficultyCopyWith<$Res> get bestScore {
  
  return $BestScoreByDifficultyCopyWith<$Res>(_self.bestScore, (value) {
    return _then(_self.copyWith(bestScore: value));
  });
}/// Create a copy of RankingGameUserStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MonthlyRankingByDifficultyCopyWith<$Res> get monthlyRanking {
  
  return $MonthlyRankingByDifficultyCopyWith<$Res>(_self.monthlyRanking, (value) {
    return _then(_self.copyWith(monthlyRanking: value));
  });
}/// Create a copy of RankingGameUserStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RankingGameAchievementsCopyWith<$Res> get achievements {
  
  return $RankingGameAchievementsCopyWith<$Res>(_self.achievements, (value) {
    return _then(_self.copyWith(achievements: value));
  });
}
}


/// @nodoc
mixin _$RankingGameStatsSummary {

 BestScoreByDifficulty get bestScore;
/// Create a copy of RankingGameStatsSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankingGameStatsSummaryCopyWith<RankingGameStatsSummary> get copyWith => _$RankingGameStatsSummaryCopyWithImpl<RankingGameStatsSummary>(this as RankingGameStatsSummary, _$identity);

  /// Serializes this RankingGameStatsSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankingGameStatsSummary&&(identical(other.bestScore, bestScore) || other.bestScore == bestScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bestScore);

@override
String toString() {
  return 'RankingGameStatsSummary(bestScore: $bestScore)';
}


}

/// @nodoc
abstract mixin class $RankingGameStatsSummaryCopyWith<$Res>  {
  factory $RankingGameStatsSummaryCopyWith(RankingGameStatsSummary value, $Res Function(RankingGameStatsSummary) _then) = _$RankingGameStatsSummaryCopyWithImpl;
@useResult
$Res call({
 BestScoreByDifficulty bestScore
});


$BestScoreByDifficultyCopyWith<$Res> get bestScore;

}
/// @nodoc
class _$RankingGameStatsSummaryCopyWithImpl<$Res>
    implements $RankingGameStatsSummaryCopyWith<$Res> {
  _$RankingGameStatsSummaryCopyWithImpl(this._self, this._then);

  final RankingGameStatsSummary _self;
  final $Res Function(RankingGameStatsSummary) _then;

/// Create a copy of RankingGameStatsSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bestScore = null,}) {
  return _then(_self.copyWith(
bestScore: null == bestScore ? _self.bestScore : bestScore // ignore: cast_nullable_to_non_nullable
as BestScoreByDifficulty,
  ));
}
/// Create a copy of RankingGameStatsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BestScoreByDifficultyCopyWith<$Res> get bestScore {
  
  return $BestScoreByDifficultyCopyWith<$Res>(_self.bestScore, (value) {
    return _then(_self.copyWith(bestScore: value));
  });
}
}


/// Adds pattern-matching-related methods to [RankingGameStatsSummary].
extension RankingGameStatsSummaryPatterns on RankingGameStatsSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankingGameStatsSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankingGameStatsSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankingGameStatsSummary value)  $default,){
final _that = this;
switch (_that) {
case _RankingGameStatsSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankingGameStatsSummary value)?  $default,){
final _that = this;
switch (_that) {
case _RankingGameStatsSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BestScoreByDifficulty bestScore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RankingGameStatsSummary() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BestScoreByDifficulty bestScore)  $default,) {final _that = this;
switch (_that) {
case _RankingGameStatsSummary():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BestScoreByDifficulty bestScore)?  $default,) {final _that = this;
switch (_that) {
case _RankingGameStatsSummary() when $default != null:
return $default(_that.bestScore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RankingGameStatsSummary implements RankingGameStatsSummary {
  const _RankingGameStatsSummary({required this.bestScore});
  factory _RankingGameStatsSummary.fromJson(Map<String, dynamic> json) => _$RankingGameStatsSummaryFromJson(json);

@override final  BestScoreByDifficulty bestScore;

/// Create a copy of RankingGameStatsSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankingGameStatsSummaryCopyWith<_RankingGameStatsSummary> get copyWith => __$RankingGameStatsSummaryCopyWithImpl<_RankingGameStatsSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RankingGameStatsSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankingGameStatsSummary&&(identical(other.bestScore, bestScore) || other.bestScore == bestScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,bestScore);

@override
String toString() {
  return 'RankingGameStatsSummary(bestScore: $bestScore)';
}


}

/// @nodoc
abstract mixin class _$RankingGameStatsSummaryCopyWith<$Res> implements $RankingGameStatsSummaryCopyWith<$Res> {
  factory _$RankingGameStatsSummaryCopyWith(_RankingGameStatsSummary value, $Res Function(_RankingGameStatsSummary) _then) = __$RankingGameStatsSummaryCopyWithImpl;
@override @useResult
$Res call({
 BestScoreByDifficulty bestScore
});


@override $BestScoreByDifficultyCopyWith<$Res> get bestScore;

}
/// @nodoc
class __$RankingGameStatsSummaryCopyWithImpl<$Res>
    implements _$RankingGameStatsSummaryCopyWith<$Res> {
  __$RankingGameStatsSummaryCopyWithImpl(this._self, this._then);

  final _RankingGameStatsSummary _self;
  final $Res Function(_RankingGameStatsSummary) _then;

/// Create a copy of RankingGameStatsSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bestScore = null,}) {
  return _then(_RankingGameStatsSummary(
bestScore: null == bestScore ? _self.bestScore : bestScore // ignore: cast_nullable_to_non_nullable
as BestScoreByDifficulty,
  ));
}

/// Create a copy of RankingGameStatsSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BestScoreByDifficultyCopyWith<$Res> get bestScore {
  
  return $BestScoreByDifficultyCopyWith<$Res>(_self.bestScore, (value) {
    return _then(_self.copyWith(bestScore: value));
  });
}
}

/// @nodoc
mixin _$ComboMeterState {

 int get currentKeys; int get currentMilestone; int get totalBonusTime;
/// Create a copy of ComboMeterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComboMeterStateCopyWith<ComboMeterState> get copyWith => _$ComboMeterStateCopyWithImpl<ComboMeterState>(this as ComboMeterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComboMeterState&&(identical(other.currentKeys, currentKeys) || other.currentKeys == currentKeys)&&(identical(other.currentMilestone, currentMilestone) || other.currentMilestone == currentMilestone)&&(identical(other.totalBonusTime, totalBonusTime) || other.totalBonusTime == totalBonusTime));
}


@override
int get hashCode => Object.hash(runtimeType,currentKeys,currentMilestone,totalBonusTime);

@override
String toString() {
  return 'ComboMeterState(currentKeys: $currentKeys, currentMilestone: $currentMilestone, totalBonusTime: $totalBonusTime)';
}


}

/// @nodoc
abstract mixin class $ComboMeterStateCopyWith<$Res>  {
  factory $ComboMeterStateCopyWith(ComboMeterState value, $Res Function(ComboMeterState) _then) = _$ComboMeterStateCopyWithImpl;
@useResult
$Res call({
 int currentKeys, int currentMilestone, int totalBonusTime
});




}
/// @nodoc
class _$ComboMeterStateCopyWithImpl<$Res>
    implements $ComboMeterStateCopyWith<$Res> {
  _$ComboMeterStateCopyWithImpl(this._self, this._then);

  final ComboMeterState _self;
  final $Res Function(ComboMeterState) _then;

/// Create a copy of ComboMeterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentKeys = null,Object? currentMilestone = null,Object? totalBonusTime = null,}) {
  return _then(_self.copyWith(
currentKeys: null == currentKeys ? _self.currentKeys : currentKeys // ignore: cast_nullable_to_non_nullable
as int,currentMilestone: null == currentMilestone ? _self.currentMilestone : currentMilestone // ignore: cast_nullable_to_non_nullable
as int,totalBonusTime: null == totalBonusTime ? _self.totalBonusTime : totalBonusTime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ComboMeterState].
extension ComboMeterStatePatterns on ComboMeterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComboMeterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComboMeterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComboMeterState value)  $default,){
final _that = this;
switch (_that) {
case _ComboMeterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComboMeterState value)?  $default,){
final _that = this;
switch (_that) {
case _ComboMeterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentKeys,  int currentMilestone,  int totalBonusTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComboMeterState() when $default != null:
return $default(_that.currentKeys,_that.currentMilestone,_that.totalBonusTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentKeys,  int currentMilestone,  int totalBonusTime)  $default,) {final _that = this;
switch (_that) {
case _ComboMeterState():
return $default(_that.currentKeys,_that.currentMilestone,_that.totalBonusTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentKeys,  int currentMilestone,  int totalBonusTime)?  $default,) {final _that = this;
switch (_that) {
case _ComboMeterState() when $default != null:
return $default(_that.currentKeys,_that.currentMilestone,_that.totalBonusTime);case _:
  return null;

}
}

}

/// @nodoc


class _ComboMeterState extends ComboMeterState {
  const _ComboMeterState({this.currentKeys = 0, this.currentMilestone = 0, this.totalBonusTime = 0}): super._();
  

@override@JsonKey() final  int currentKeys;
@override@JsonKey() final  int currentMilestone;
@override@JsonKey() final  int totalBonusTime;

/// Create a copy of ComboMeterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComboMeterStateCopyWith<_ComboMeterState> get copyWith => __$ComboMeterStateCopyWithImpl<_ComboMeterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComboMeterState&&(identical(other.currentKeys, currentKeys) || other.currentKeys == currentKeys)&&(identical(other.currentMilestone, currentMilestone) || other.currentMilestone == currentMilestone)&&(identical(other.totalBonusTime, totalBonusTime) || other.totalBonusTime == totalBonusTime));
}


@override
int get hashCode => Object.hash(runtimeType,currentKeys,currentMilestone,totalBonusTime);

@override
String toString() {
  return 'ComboMeterState(currentKeys: $currentKeys, currentMilestone: $currentMilestone, totalBonusTime: $totalBonusTime)';
}


}

/// @nodoc
abstract mixin class _$ComboMeterStateCopyWith<$Res> implements $ComboMeterStateCopyWith<$Res> {
  factory _$ComboMeterStateCopyWith(_ComboMeterState value, $Res Function(_ComboMeterState) _then) = __$ComboMeterStateCopyWithImpl;
@override @useResult
$Res call({
 int currentKeys, int currentMilestone, int totalBonusTime
});




}
/// @nodoc
class __$ComboMeterStateCopyWithImpl<$Res>
    implements _$ComboMeterStateCopyWith<$Res> {
  __$ComboMeterStateCopyWithImpl(this._self, this._then);

  final _ComboMeterState _self;
  final $Res Function(_ComboMeterState) _then;

/// Create a copy of ComboMeterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentKeys = null,Object? currentMilestone = null,Object? totalBonusTime = null,}) {
  return _then(_ComboMeterState(
currentKeys: null == currentKeys ? _self.currentKeys : currentKeys // ignore: cast_nullable_to_non_nullable
as int,currentMilestone: null == currentMilestone ? _self.currentMilestone : currentMilestone // ignore: cast_nullable_to_non_nullable
as int,totalBonusTime: null == totalBonusTime ? _self.totalBonusTime : totalBonusTime // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$RankingGameSessionState {

 String get difficulty; int get remainingTimeMs; int get score; int get correctCount; int get currentCombo; int get maxCombo; ComboMeterState get comboMeter; int get characterLevel; RankingGameWord? get currentWord; String get inputBuffer; int get currentPosition;// 字母レベルの現在位置
 bool get isPlaying; bool get isFinished; List<RankingGameWord> get wordQueue; int get totalBonusTime; int get wordIndex; DateTime? get startTime; InputResultType get lastInputResult; DateTime? get lastInputTime;
/// Create a copy of RankingGameSessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankingGameSessionStateCopyWith<RankingGameSessionState> get copyWith => _$RankingGameSessionStateCopyWithImpl<RankingGameSessionState>(this as RankingGameSessionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankingGameSessionState&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.remainingTimeMs, remainingTimeMs) || other.remainingTimeMs == remainingTimeMs)&&(identical(other.score, score) || other.score == score)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.currentCombo, currentCombo) || other.currentCombo == currentCombo)&&(identical(other.maxCombo, maxCombo) || other.maxCombo == maxCombo)&&(identical(other.comboMeter, comboMeter) || other.comboMeter == comboMeter)&&(identical(other.characterLevel, characterLevel) || other.characterLevel == characterLevel)&&(identical(other.currentWord, currentWord) || other.currentWord == currentWord)&&(identical(other.inputBuffer, inputBuffer) || other.inputBuffer == inputBuffer)&&(identical(other.currentPosition, currentPosition) || other.currentPosition == currentPosition)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished)&&const DeepCollectionEquality().equals(other.wordQueue, wordQueue)&&(identical(other.totalBonusTime, totalBonusTime) || other.totalBonusTime == totalBonusTime)&&(identical(other.wordIndex, wordIndex) || other.wordIndex == wordIndex)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.lastInputResult, lastInputResult) || other.lastInputResult == lastInputResult)&&(identical(other.lastInputTime, lastInputTime) || other.lastInputTime == lastInputTime));
}


@override
int get hashCode => Object.hashAll([runtimeType,difficulty,remainingTimeMs,score,correctCount,currentCombo,maxCombo,comboMeter,characterLevel,currentWord,inputBuffer,currentPosition,isPlaying,isFinished,const DeepCollectionEquality().hash(wordQueue),totalBonusTime,wordIndex,startTime,lastInputResult,lastInputTime]);

@override
String toString() {
  return 'RankingGameSessionState(difficulty: $difficulty, remainingTimeMs: $remainingTimeMs, score: $score, correctCount: $correctCount, currentCombo: $currentCombo, maxCombo: $maxCombo, comboMeter: $comboMeter, characterLevel: $characterLevel, currentWord: $currentWord, inputBuffer: $inputBuffer, currentPosition: $currentPosition, isPlaying: $isPlaying, isFinished: $isFinished, wordQueue: $wordQueue, totalBonusTime: $totalBonusTime, wordIndex: $wordIndex, startTime: $startTime, lastInputResult: $lastInputResult, lastInputTime: $lastInputTime)';
}


}

/// @nodoc
abstract mixin class $RankingGameSessionStateCopyWith<$Res>  {
  factory $RankingGameSessionStateCopyWith(RankingGameSessionState value, $Res Function(RankingGameSessionState) _then) = _$RankingGameSessionStateCopyWithImpl;
@useResult
$Res call({
 String difficulty, int remainingTimeMs, int score, int correctCount, int currentCombo, int maxCombo, ComboMeterState comboMeter, int characterLevel, RankingGameWord? currentWord, String inputBuffer, int currentPosition, bool isPlaying, bool isFinished, List<RankingGameWord> wordQueue, int totalBonusTime, int wordIndex, DateTime? startTime, InputResultType lastInputResult, DateTime? lastInputTime
});


$ComboMeterStateCopyWith<$Res> get comboMeter;$RankingGameWordCopyWith<$Res>? get currentWord;

}
/// @nodoc
class _$RankingGameSessionStateCopyWithImpl<$Res>
    implements $RankingGameSessionStateCopyWith<$Res> {
  _$RankingGameSessionStateCopyWithImpl(this._self, this._then);

  final RankingGameSessionState _self;
  final $Res Function(RankingGameSessionState) _then;

/// Create a copy of RankingGameSessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? difficulty = null,Object? remainingTimeMs = null,Object? score = null,Object? correctCount = null,Object? currentCombo = null,Object? maxCombo = null,Object? comboMeter = null,Object? characterLevel = null,Object? currentWord = freezed,Object? inputBuffer = null,Object? currentPosition = null,Object? isPlaying = null,Object? isFinished = null,Object? wordQueue = null,Object? totalBonusTime = null,Object? wordIndex = null,Object? startTime = freezed,Object? lastInputResult = null,Object? lastInputTime = freezed,}) {
  return _then(_self.copyWith(
difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,remainingTimeMs: null == remainingTimeMs ? _self.remainingTimeMs : remainingTimeMs // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,currentCombo: null == currentCombo ? _self.currentCombo : currentCombo // ignore: cast_nullable_to_non_nullable
as int,maxCombo: null == maxCombo ? _self.maxCombo : maxCombo // ignore: cast_nullable_to_non_nullable
as int,comboMeter: null == comboMeter ? _self.comboMeter : comboMeter // ignore: cast_nullable_to_non_nullable
as ComboMeterState,characterLevel: null == characterLevel ? _self.characterLevel : characterLevel // ignore: cast_nullable_to_non_nullable
as int,currentWord: freezed == currentWord ? _self.currentWord : currentWord // ignore: cast_nullable_to_non_nullable
as RankingGameWord?,inputBuffer: null == inputBuffer ? _self.inputBuffer : inputBuffer // ignore: cast_nullable_to_non_nullable
as String,currentPosition: null == currentPosition ? _self.currentPosition : currentPosition // ignore: cast_nullable_to_non_nullable
as int,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,wordQueue: null == wordQueue ? _self.wordQueue : wordQueue // ignore: cast_nullable_to_non_nullable
as List<RankingGameWord>,totalBonusTime: null == totalBonusTime ? _self.totalBonusTime : totalBonusTime // ignore: cast_nullable_to_non_nullable
as int,wordIndex: null == wordIndex ? _self.wordIndex : wordIndex // ignore: cast_nullable_to_non_nullable
as int,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,lastInputResult: null == lastInputResult ? _self.lastInputResult : lastInputResult // ignore: cast_nullable_to_non_nullable
as InputResultType,lastInputTime: freezed == lastInputTime ? _self.lastInputTime : lastInputTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of RankingGameSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComboMeterStateCopyWith<$Res> get comboMeter {
  
  return $ComboMeterStateCopyWith<$Res>(_self.comboMeter, (value) {
    return _then(_self.copyWith(comboMeter: value));
  });
}/// Create a copy of RankingGameSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RankingGameWordCopyWith<$Res>? get currentWord {
    if (_self.currentWord == null) {
    return null;
  }

  return $RankingGameWordCopyWith<$Res>(_self.currentWord!, (value) {
    return _then(_self.copyWith(currentWord: value));
  });
}
}


/// Adds pattern-matching-related methods to [RankingGameSessionState].
extension RankingGameSessionStatePatterns on RankingGameSessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankingGameSessionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankingGameSessionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankingGameSessionState value)  $default,){
final _that = this;
switch (_that) {
case _RankingGameSessionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankingGameSessionState value)?  $default,){
final _that = this;
switch (_that) {
case _RankingGameSessionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String difficulty,  int remainingTimeMs,  int score,  int correctCount,  int currentCombo,  int maxCombo,  ComboMeterState comboMeter,  int characterLevel,  RankingGameWord? currentWord,  String inputBuffer,  int currentPosition,  bool isPlaying,  bool isFinished,  List<RankingGameWord> wordQueue,  int totalBonusTime,  int wordIndex,  DateTime? startTime,  InputResultType lastInputResult,  DateTime? lastInputTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RankingGameSessionState() when $default != null:
return $default(_that.difficulty,_that.remainingTimeMs,_that.score,_that.correctCount,_that.currentCombo,_that.maxCombo,_that.comboMeter,_that.characterLevel,_that.currentWord,_that.inputBuffer,_that.currentPosition,_that.isPlaying,_that.isFinished,_that.wordQueue,_that.totalBonusTime,_that.wordIndex,_that.startTime,_that.lastInputResult,_that.lastInputTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String difficulty,  int remainingTimeMs,  int score,  int correctCount,  int currentCombo,  int maxCombo,  ComboMeterState comboMeter,  int characterLevel,  RankingGameWord? currentWord,  String inputBuffer,  int currentPosition,  bool isPlaying,  bool isFinished,  List<RankingGameWord> wordQueue,  int totalBonusTime,  int wordIndex,  DateTime? startTime,  InputResultType lastInputResult,  DateTime? lastInputTime)  $default,) {final _that = this;
switch (_that) {
case _RankingGameSessionState():
return $default(_that.difficulty,_that.remainingTimeMs,_that.score,_that.correctCount,_that.currentCombo,_that.maxCombo,_that.comboMeter,_that.characterLevel,_that.currentWord,_that.inputBuffer,_that.currentPosition,_that.isPlaying,_that.isFinished,_that.wordQueue,_that.totalBonusTime,_that.wordIndex,_that.startTime,_that.lastInputResult,_that.lastInputTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String difficulty,  int remainingTimeMs,  int score,  int correctCount,  int currentCombo,  int maxCombo,  ComboMeterState comboMeter,  int characterLevel,  RankingGameWord? currentWord,  String inputBuffer,  int currentPosition,  bool isPlaying,  bool isFinished,  List<RankingGameWord> wordQueue,  int totalBonusTime,  int wordIndex,  DateTime? startTime,  InputResultType lastInputResult,  DateTime? lastInputTime)?  $default,) {final _that = this;
switch (_that) {
case _RankingGameSessionState() when $default != null:
return $default(_that.difficulty,_that.remainingTimeMs,_that.score,_that.correctCount,_that.currentCombo,_that.maxCombo,_that.comboMeter,_that.characterLevel,_that.currentWord,_that.inputBuffer,_that.currentPosition,_that.isPlaying,_that.isFinished,_that.wordQueue,_that.totalBonusTime,_that.wordIndex,_that.startTime,_that.lastInputResult,_that.lastInputTime);case _:
  return null;

}
}

}

/// @nodoc


class _RankingGameSessionState extends RankingGameSessionState {
  const _RankingGameSessionState({required this.difficulty, required this.remainingTimeMs, this.score = 0, this.correctCount = 0, this.currentCombo = 0, this.maxCombo = 0, this.comboMeter = const ComboMeterState(), this.characterLevel = 0, this.currentWord, this.inputBuffer = '', this.currentPosition = 0, this.isPlaying = false, this.isFinished = false, final  List<RankingGameWord> wordQueue = const <RankingGameWord>[], this.totalBonusTime = 0, this.wordIndex = 0, this.startTime, this.lastInputResult = InputResultType.none, this.lastInputTime}): _wordQueue = wordQueue,super._();
  

@override final  String difficulty;
@override final  int remainingTimeMs;
@override@JsonKey() final  int score;
@override@JsonKey() final  int correctCount;
@override@JsonKey() final  int currentCombo;
@override@JsonKey() final  int maxCombo;
@override@JsonKey() final  ComboMeterState comboMeter;
@override@JsonKey() final  int characterLevel;
@override final  RankingGameWord? currentWord;
@override@JsonKey() final  String inputBuffer;
@override@JsonKey() final  int currentPosition;
// 字母レベルの現在位置
@override@JsonKey() final  bool isPlaying;
@override@JsonKey() final  bool isFinished;
 final  List<RankingGameWord> _wordQueue;
@override@JsonKey() List<RankingGameWord> get wordQueue {
  if (_wordQueue is EqualUnmodifiableListView) return _wordQueue;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wordQueue);
}

@override@JsonKey() final  int totalBonusTime;
@override@JsonKey() final  int wordIndex;
@override final  DateTime? startTime;
@override@JsonKey() final  InputResultType lastInputResult;
@override final  DateTime? lastInputTime;

/// Create a copy of RankingGameSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankingGameSessionStateCopyWith<_RankingGameSessionState> get copyWith => __$RankingGameSessionStateCopyWithImpl<_RankingGameSessionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankingGameSessionState&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.remainingTimeMs, remainingTimeMs) || other.remainingTimeMs == remainingTimeMs)&&(identical(other.score, score) || other.score == score)&&(identical(other.correctCount, correctCount) || other.correctCount == correctCount)&&(identical(other.currentCombo, currentCombo) || other.currentCombo == currentCombo)&&(identical(other.maxCombo, maxCombo) || other.maxCombo == maxCombo)&&(identical(other.comboMeter, comboMeter) || other.comboMeter == comboMeter)&&(identical(other.characterLevel, characterLevel) || other.characterLevel == characterLevel)&&(identical(other.currentWord, currentWord) || other.currentWord == currentWord)&&(identical(other.inputBuffer, inputBuffer) || other.inputBuffer == inputBuffer)&&(identical(other.currentPosition, currentPosition) || other.currentPosition == currentPosition)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished)&&const DeepCollectionEquality().equals(other._wordQueue, _wordQueue)&&(identical(other.totalBonusTime, totalBonusTime) || other.totalBonusTime == totalBonusTime)&&(identical(other.wordIndex, wordIndex) || other.wordIndex == wordIndex)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.lastInputResult, lastInputResult) || other.lastInputResult == lastInputResult)&&(identical(other.lastInputTime, lastInputTime) || other.lastInputTime == lastInputTime));
}


@override
int get hashCode => Object.hashAll([runtimeType,difficulty,remainingTimeMs,score,correctCount,currentCombo,maxCombo,comboMeter,characterLevel,currentWord,inputBuffer,currentPosition,isPlaying,isFinished,const DeepCollectionEquality().hash(_wordQueue),totalBonusTime,wordIndex,startTime,lastInputResult,lastInputTime]);

@override
String toString() {
  return 'RankingGameSessionState(difficulty: $difficulty, remainingTimeMs: $remainingTimeMs, score: $score, correctCount: $correctCount, currentCombo: $currentCombo, maxCombo: $maxCombo, comboMeter: $comboMeter, characterLevel: $characterLevel, currentWord: $currentWord, inputBuffer: $inputBuffer, currentPosition: $currentPosition, isPlaying: $isPlaying, isFinished: $isFinished, wordQueue: $wordQueue, totalBonusTime: $totalBonusTime, wordIndex: $wordIndex, startTime: $startTime, lastInputResult: $lastInputResult, lastInputTime: $lastInputTime)';
}


}

/// @nodoc
abstract mixin class _$RankingGameSessionStateCopyWith<$Res> implements $RankingGameSessionStateCopyWith<$Res> {
  factory _$RankingGameSessionStateCopyWith(_RankingGameSessionState value, $Res Function(_RankingGameSessionState) _then) = __$RankingGameSessionStateCopyWithImpl;
@override @useResult
$Res call({
 String difficulty, int remainingTimeMs, int score, int correctCount, int currentCombo, int maxCombo, ComboMeterState comboMeter, int characterLevel, RankingGameWord? currentWord, String inputBuffer, int currentPosition, bool isPlaying, bool isFinished, List<RankingGameWord> wordQueue, int totalBonusTime, int wordIndex, DateTime? startTime, InputResultType lastInputResult, DateTime? lastInputTime
});


@override $ComboMeterStateCopyWith<$Res> get comboMeter;@override $RankingGameWordCopyWith<$Res>? get currentWord;

}
/// @nodoc
class __$RankingGameSessionStateCopyWithImpl<$Res>
    implements _$RankingGameSessionStateCopyWith<$Res> {
  __$RankingGameSessionStateCopyWithImpl(this._self, this._then);

  final _RankingGameSessionState _self;
  final $Res Function(_RankingGameSessionState) _then;

/// Create a copy of RankingGameSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? difficulty = null,Object? remainingTimeMs = null,Object? score = null,Object? correctCount = null,Object? currentCombo = null,Object? maxCombo = null,Object? comboMeter = null,Object? characterLevel = null,Object? currentWord = freezed,Object? inputBuffer = null,Object? currentPosition = null,Object? isPlaying = null,Object? isFinished = null,Object? wordQueue = null,Object? totalBonusTime = null,Object? wordIndex = null,Object? startTime = freezed,Object? lastInputResult = null,Object? lastInputTime = freezed,}) {
  return _then(_RankingGameSessionState(
difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,remainingTimeMs: null == remainingTimeMs ? _self.remainingTimeMs : remainingTimeMs // ignore: cast_nullable_to_non_nullable
as int,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,correctCount: null == correctCount ? _self.correctCount : correctCount // ignore: cast_nullable_to_non_nullable
as int,currentCombo: null == currentCombo ? _self.currentCombo : currentCombo // ignore: cast_nullable_to_non_nullable
as int,maxCombo: null == maxCombo ? _self.maxCombo : maxCombo // ignore: cast_nullable_to_non_nullable
as int,comboMeter: null == comboMeter ? _self.comboMeter : comboMeter // ignore: cast_nullable_to_non_nullable
as ComboMeterState,characterLevel: null == characterLevel ? _self.characterLevel : characterLevel // ignore: cast_nullable_to_non_nullable
as int,currentWord: freezed == currentWord ? _self.currentWord : currentWord // ignore: cast_nullable_to_non_nullable
as RankingGameWord?,inputBuffer: null == inputBuffer ? _self.inputBuffer : inputBuffer // ignore: cast_nullable_to_non_nullable
as String,currentPosition: null == currentPosition ? _self.currentPosition : currentPosition // ignore: cast_nullable_to_non_nullable
as int,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,wordQueue: null == wordQueue ? _self._wordQueue : wordQueue // ignore: cast_nullable_to_non_nullable
as List<RankingGameWord>,totalBonusTime: null == totalBonusTime ? _self.totalBonusTime : totalBonusTime // ignore: cast_nullable_to_non_nullable
as int,wordIndex: null == wordIndex ? _self.wordIndex : wordIndex // ignore: cast_nullable_to_non_nullable
as int,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,lastInputResult: null == lastInputResult ? _self.lastInputResult : lastInputResult // ignore: cast_nullable_to_non_nullable
as InputResultType,lastInputTime: freezed == lastInputTime ? _self.lastInputTime : lastInputTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of RankingGameSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ComboMeterStateCopyWith<$Res> get comboMeter {
  
  return $ComboMeterStateCopyWith<$Res>(_self.comboMeter, (value) {
    return _then(_self.copyWith(comboMeter: value));
  });
}/// Create a copy of RankingGameSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RankingGameWordCopyWith<$Res>? get currentWord {
    if (_self.currentWord == null) {
    return null;
  }

  return $RankingGameWordCopyWith<$Res>(_self.currentWord!, (value) {
    return _then(_self.copyWith(currentWord: value));
  });
}
}


/// @nodoc
mixin _$WordDataFile {

 String get version; String get difficulty; List<RankingGameWord> get words;
/// Create a copy of WordDataFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WordDataFileCopyWith<WordDataFile> get copyWith => _$WordDataFileCopyWithImpl<WordDataFile>(this as WordDataFile, _$identity);

  /// Serializes this WordDataFile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WordDataFile&&(identical(other.version, version) || other.version == version)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other.words, words));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,difficulty,const DeepCollectionEquality().hash(words));

@override
String toString() {
  return 'WordDataFile(version: $version, difficulty: $difficulty, words: $words)';
}


}

/// @nodoc
abstract mixin class $WordDataFileCopyWith<$Res>  {
  factory $WordDataFileCopyWith(WordDataFile value, $Res Function(WordDataFile) _then) = _$WordDataFileCopyWithImpl;
@useResult
$Res call({
 String version, String difficulty, List<RankingGameWord> words
});




}
/// @nodoc
class _$WordDataFileCopyWithImpl<$Res>
    implements $WordDataFileCopyWith<$Res> {
  _$WordDataFileCopyWithImpl(this._self, this._then);

  final WordDataFile _self;
  final $Res Function(WordDataFile) _then;

/// Create a copy of WordDataFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? difficulty = null,Object? words = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as List<RankingGameWord>,
  ));
}

}


/// Adds pattern-matching-related methods to [WordDataFile].
extension WordDataFilePatterns on WordDataFile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WordDataFile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WordDataFile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WordDataFile value)  $default,){
final _that = this;
switch (_that) {
case _WordDataFile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WordDataFile value)?  $default,){
final _that = this;
switch (_that) {
case _WordDataFile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String version,  String difficulty,  List<RankingGameWord> words)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WordDataFile() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String version,  String difficulty,  List<RankingGameWord> words)  $default,) {final _that = this;
switch (_that) {
case _WordDataFile():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String version,  String difficulty,  List<RankingGameWord> words)?  $default,) {final _that = this;
switch (_that) {
case _WordDataFile() when $default != null:
return $default(_that.version,_that.difficulty,_that.words);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WordDataFile implements WordDataFile {
  const _WordDataFile({required this.version, required this.difficulty, final  List<RankingGameWord> words = const <RankingGameWord>[]}): _words = words;
  factory _WordDataFile.fromJson(Map<String, dynamic> json) => _$WordDataFileFromJson(json);

@override final  String version;
@override final  String difficulty;
 final  List<RankingGameWord> _words;
@override@JsonKey() List<RankingGameWord> get words {
  if (_words is EqualUnmodifiableListView) return _words;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_words);
}


/// Create a copy of WordDataFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WordDataFileCopyWith<_WordDataFile> get copyWith => __$WordDataFileCopyWithImpl<_WordDataFile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WordDataFileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WordDataFile&&(identical(other.version, version) || other.version == version)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other._words, _words));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,version,difficulty,const DeepCollectionEquality().hash(_words));

@override
String toString() {
  return 'WordDataFile(version: $version, difficulty: $difficulty, words: $words)';
}


}

/// @nodoc
abstract mixin class _$WordDataFileCopyWith<$Res> implements $WordDataFileCopyWith<$Res> {
  factory _$WordDataFileCopyWith(_WordDataFile value, $Res Function(_WordDataFile) _then) = __$WordDataFileCopyWithImpl;
@override @useResult
$Res call({
 String version, String difficulty, List<RankingGameWord> words
});




}
/// @nodoc
class __$WordDataFileCopyWithImpl<$Res>
    implements _$WordDataFileCopyWith<$Res> {
  __$WordDataFileCopyWithImpl(this._self, this._then);

  final _WordDataFile _self;
  final $Res Function(_WordDataFile) _then;

/// Create a copy of WordDataFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? difficulty = null,Object? words = null,}) {
  return _then(_WordDataFile(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String,words: null == words ? _self._words : words // ignore: cast_nullable_to_non_nullable
as List<RankingGameWord>,
  ));
}


}

// dart format on
