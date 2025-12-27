// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'integrated_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$IntegratedStats {

 int get totalTimeSpent; int get streakDays; double get maxWpm; double get avgWpm; double get maxAccuracy; double get avgAccuracy; int get activeDays; StatsBreakdown get breakdown; List<DailyActivityTrend> get dailyTrend;
/// Create a copy of IntegratedStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IntegratedStatsCopyWith<IntegratedStats> get copyWith => _$IntegratedStatsCopyWithImpl<IntegratedStats>(this as IntegratedStats, _$identity);

  /// Serializes this IntegratedStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IntegratedStats&&(identical(other.totalTimeSpent, totalTimeSpent) || other.totalTimeSpent == totalTimeSpent)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.maxWpm, maxWpm) || other.maxWpm == maxWpm)&&(identical(other.avgWpm, avgWpm) || other.avgWpm == avgWpm)&&(identical(other.maxAccuracy, maxAccuracy) || other.maxAccuracy == maxAccuracy)&&(identical(other.avgAccuracy, avgAccuracy) || other.avgAccuracy == avgAccuracy)&&(identical(other.activeDays, activeDays) || other.activeDays == activeDays)&&(identical(other.breakdown, breakdown) || other.breakdown == breakdown)&&const DeepCollectionEquality().equals(other.dailyTrend, dailyTrend));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalTimeSpent,streakDays,maxWpm,avgWpm,maxAccuracy,avgAccuracy,activeDays,breakdown,const DeepCollectionEquality().hash(dailyTrend));

@override
String toString() {
  return 'IntegratedStats(totalTimeSpent: $totalTimeSpent, streakDays: $streakDays, maxWpm: $maxWpm, avgWpm: $avgWpm, maxAccuracy: $maxAccuracy, avgAccuracy: $avgAccuracy, activeDays: $activeDays, breakdown: $breakdown, dailyTrend: $dailyTrend)';
}


}

/// @nodoc
abstract mixin class $IntegratedStatsCopyWith<$Res>  {
  factory $IntegratedStatsCopyWith(IntegratedStats value, $Res Function(IntegratedStats) _then) = _$IntegratedStatsCopyWithImpl;
@useResult
$Res call({
 int totalTimeSpent, int streakDays, double maxWpm, double avgWpm, double maxAccuracy, double avgAccuracy, int activeDays, StatsBreakdown breakdown, List<DailyActivityTrend> dailyTrend
});


$StatsBreakdownCopyWith<$Res> get breakdown;

}
/// @nodoc
class _$IntegratedStatsCopyWithImpl<$Res>
    implements $IntegratedStatsCopyWith<$Res> {
  _$IntegratedStatsCopyWithImpl(this._self, this._then);

  final IntegratedStats _self;
  final $Res Function(IntegratedStats) _then;

/// Create a copy of IntegratedStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalTimeSpent = null,Object? streakDays = null,Object? maxWpm = null,Object? avgWpm = null,Object? maxAccuracy = null,Object? avgAccuracy = null,Object? activeDays = null,Object? breakdown = null,Object? dailyTrend = null,}) {
  return _then(_self.copyWith(
totalTimeSpent: null == totalTimeSpent ? _self.totalTimeSpent : totalTimeSpent // ignore: cast_nullable_to_non_nullable
as int,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,maxWpm: null == maxWpm ? _self.maxWpm : maxWpm // ignore: cast_nullable_to_non_nullable
as double,avgWpm: null == avgWpm ? _self.avgWpm : avgWpm // ignore: cast_nullable_to_non_nullable
as double,maxAccuracy: null == maxAccuracy ? _self.maxAccuracy : maxAccuracy // ignore: cast_nullable_to_non_nullable
as double,avgAccuracy: null == avgAccuracy ? _self.avgAccuracy : avgAccuracy // ignore: cast_nullable_to_non_nullable
as double,activeDays: null == activeDays ? _self.activeDays : activeDays // ignore: cast_nullable_to_non_nullable
as int,breakdown: null == breakdown ? _self.breakdown : breakdown // ignore: cast_nullable_to_non_nullable
as StatsBreakdown,dailyTrend: null == dailyTrend ? _self.dailyTrend : dailyTrend // ignore: cast_nullable_to_non_nullable
as List<DailyActivityTrend>,
  ));
}
/// Create a copy of IntegratedStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatsBreakdownCopyWith<$Res> get breakdown {
  
  return $StatsBreakdownCopyWith<$Res>(_self.breakdown, (value) {
    return _then(_self.copyWith(breakdown: value));
  });
}
}


/// Adds pattern-matching-related methods to [IntegratedStats].
extension IntegratedStatsPatterns on IntegratedStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IntegratedStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IntegratedStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IntegratedStats value)  $default,){
final _that = this;
switch (_that) {
case _IntegratedStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IntegratedStats value)?  $default,){
final _that = this;
switch (_that) {
case _IntegratedStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalTimeSpent,  int streakDays,  double maxWpm,  double avgWpm,  double maxAccuracy,  double avgAccuracy,  int activeDays,  StatsBreakdown breakdown,  List<DailyActivityTrend> dailyTrend)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IntegratedStats() when $default != null:
return $default(_that.totalTimeSpent,_that.streakDays,_that.maxWpm,_that.avgWpm,_that.maxAccuracy,_that.avgAccuracy,_that.activeDays,_that.breakdown,_that.dailyTrend);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalTimeSpent,  int streakDays,  double maxWpm,  double avgWpm,  double maxAccuracy,  double avgAccuracy,  int activeDays,  StatsBreakdown breakdown,  List<DailyActivityTrend> dailyTrend)  $default,) {final _that = this;
switch (_that) {
case _IntegratedStats():
return $default(_that.totalTimeSpent,_that.streakDays,_that.maxWpm,_that.avgWpm,_that.maxAccuracy,_that.avgAccuracy,_that.activeDays,_that.breakdown,_that.dailyTrend);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalTimeSpent,  int streakDays,  double maxWpm,  double avgWpm,  double maxAccuracy,  double avgAccuracy,  int activeDays,  StatsBreakdown breakdown,  List<DailyActivityTrend> dailyTrend)?  $default,) {final _that = this;
switch (_that) {
case _IntegratedStats() when $default != null:
return $default(_that.totalTimeSpent,_that.streakDays,_that.maxWpm,_that.avgWpm,_that.maxAccuracy,_that.avgAccuracy,_that.activeDays,_that.breakdown,_that.dailyTrend);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IntegratedStats implements IntegratedStats {
  const _IntegratedStats({required this.totalTimeSpent, required this.streakDays, required this.maxWpm, required this.avgWpm, required this.maxAccuracy, required this.avgAccuracy, required this.activeDays, required this.breakdown, final  List<DailyActivityTrend> dailyTrend = const <DailyActivityTrend>[]}): _dailyTrend = dailyTrend;
  factory _IntegratedStats.fromJson(Map<String, dynamic> json) => _$IntegratedStatsFromJson(json);

@override final  int totalTimeSpent;
@override final  int streakDays;
@override final  double maxWpm;
@override final  double avgWpm;
@override final  double maxAccuracy;
@override final  double avgAccuracy;
@override final  int activeDays;
@override final  StatsBreakdown breakdown;
 final  List<DailyActivityTrend> _dailyTrend;
@override@JsonKey() List<DailyActivityTrend> get dailyTrend {
  if (_dailyTrend is EqualUnmodifiableListView) return _dailyTrend;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dailyTrend);
}


/// Create a copy of IntegratedStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IntegratedStatsCopyWith<_IntegratedStats> get copyWith => __$IntegratedStatsCopyWithImpl<_IntegratedStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IntegratedStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IntegratedStats&&(identical(other.totalTimeSpent, totalTimeSpent) || other.totalTimeSpent == totalTimeSpent)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.maxWpm, maxWpm) || other.maxWpm == maxWpm)&&(identical(other.avgWpm, avgWpm) || other.avgWpm == avgWpm)&&(identical(other.maxAccuracy, maxAccuracy) || other.maxAccuracy == maxAccuracy)&&(identical(other.avgAccuracy, avgAccuracy) || other.avgAccuracy == avgAccuracy)&&(identical(other.activeDays, activeDays) || other.activeDays == activeDays)&&(identical(other.breakdown, breakdown) || other.breakdown == breakdown)&&const DeepCollectionEquality().equals(other._dailyTrend, _dailyTrend));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalTimeSpent,streakDays,maxWpm,avgWpm,maxAccuracy,avgAccuracy,activeDays,breakdown,const DeepCollectionEquality().hash(_dailyTrend));

@override
String toString() {
  return 'IntegratedStats(totalTimeSpent: $totalTimeSpent, streakDays: $streakDays, maxWpm: $maxWpm, avgWpm: $avgWpm, maxAccuracy: $maxAccuracy, avgAccuracy: $avgAccuracy, activeDays: $activeDays, breakdown: $breakdown, dailyTrend: $dailyTrend)';
}


}

/// @nodoc
abstract mixin class _$IntegratedStatsCopyWith<$Res> implements $IntegratedStatsCopyWith<$Res> {
  factory _$IntegratedStatsCopyWith(_IntegratedStats value, $Res Function(_IntegratedStats) _then) = __$IntegratedStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalTimeSpent, int streakDays, double maxWpm, double avgWpm, double maxAccuracy, double avgAccuracy, int activeDays, StatsBreakdown breakdown, List<DailyActivityTrend> dailyTrend
});


@override $StatsBreakdownCopyWith<$Res> get breakdown;

}
/// @nodoc
class __$IntegratedStatsCopyWithImpl<$Res>
    implements _$IntegratedStatsCopyWith<$Res> {
  __$IntegratedStatsCopyWithImpl(this._self, this._then);

  final _IntegratedStats _self;
  final $Res Function(_IntegratedStats) _then;

/// Create a copy of IntegratedStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalTimeSpent = null,Object? streakDays = null,Object? maxWpm = null,Object? avgWpm = null,Object? maxAccuracy = null,Object? avgAccuracy = null,Object? activeDays = null,Object? breakdown = null,Object? dailyTrend = null,}) {
  return _then(_IntegratedStats(
totalTimeSpent: null == totalTimeSpent ? _self.totalTimeSpent : totalTimeSpent // ignore: cast_nullable_to_non_nullable
as int,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,maxWpm: null == maxWpm ? _self.maxWpm : maxWpm // ignore: cast_nullable_to_non_nullable
as double,avgWpm: null == avgWpm ? _self.avgWpm : avgWpm // ignore: cast_nullable_to_non_nullable
as double,maxAccuracy: null == maxAccuracy ? _self.maxAccuracy : maxAccuracy // ignore: cast_nullable_to_non_nullable
as double,avgAccuracy: null == avgAccuracy ? _self.avgAccuracy : avgAccuracy // ignore: cast_nullable_to_non_nullable
as double,activeDays: null == activeDays ? _self.activeDays : activeDays // ignore: cast_nullable_to_non_nullable
as int,breakdown: null == breakdown ? _self.breakdown : breakdown // ignore: cast_nullable_to_non_nullable
as StatsBreakdown,dailyTrend: null == dailyTrend ? _self._dailyTrend : dailyTrend // ignore: cast_nullable_to_non_nullable
as List<DailyActivityTrend>,
  ));
}

/// Create a copy of IntegratedStats
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatsBreakdownCopyWith<$Res> get breakdown {
  
  return $StatsBreakdownCopyWith<$Res>(_self.breakdown, (value) {
    return _then(_self.copyWith(breakdown: value));
  });
}
}


/// @nodoc
mixin _$StatsBreakdown {

 ActivityBreakdown get lesson; ActivityBreakdown get rankingGame; ActivityBreakdown get quickTranslation; ActivityBreakdown get writing; ActivityBreakdown get hanjaQuiz; ActivityBreakdown get shadowing;
/// Create a copy of StatsBreakdown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatsBreakdownCopyWith<StatsBreakdown> get copyWith => _$StatsBreakdownCopyWithImpl<StatsBreakdown>(this as StatsBreakdown, _$identity);

  /// Serializes this StatsBreakdown to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatsBreakdown&&(identical(other.lesson, lesson) || other.lesson == lesson)&&(identical(other.rankingGame, rankingGame) || other.rankingGame == rankingGame)&&(identical(other.quickTranslation, quickTranslation) || other.quickTranslation == quickTranslation)&&(identical(other.writing, writing) || other.writing == writing)&&(identical(other.hanjaQuiz, hanjaQuiz) || other.hanjaQuiz == hanjaQuiz)&&(identical(other.shadowing, shadowing) || other.shadowing == shadowing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lesson,rankingGame,quickTranslation,writing,hanjaQuiz,shadowing);

@override
String toString() {
  return 'StatsBreakdown(lesson: $lesson, rankingGame: $rankingGame, quickTranslation: $quickTranslation, writing: $writing, hanjaQuiz: $hanjaQuiz, shadowing: $shadowing)';
}


}

/// @nodoc
abstract mixin class $StatsBreakdownCopyWith<$Res>  {
  factory $StatsBreakdownCopyWith(StatsBreakdown value, $Res Function(StatsBreakdown) _then) = _$StatsBreakdownCopyWithImpl;
@useResult
$Res call({
 ActivityBreakdown lesson, ActivityBreakdown rankingGame, ActivityBreakdown quickTranslation, ActivityBreakdown writing, ActivityBreakdown hanjaQuiz, ActivityBreakdown shadowing
});


$ActivityBreakdownCopyWith<$Res> get lesson;$ActivityBreakdownCopyWith<$Res> get rankingGame;$ActivityBreakdownCopyWith<$Res> get quickTranslation;$ActivityBreakdownCopyWith<$Res> get writing;$ActivityBreakdownCopyWith<$Res> get hanjaQuiz;$ActivityBreakdownCopyWith<$Res> get shadowing;

}
/// @nodoc
class _$StatsBreakdownCopyWithImpl<$Res>
    implements $StatsBreakdownCopyWith<$Res> {
  _$StatsBreakdownCopyWithImpl(this._self, this._then);

  final StatsBreakdown _self;
  final $Res Function(StatsBreakdown) _then;

/// Create a copy of StatsBreakdown
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lesson = null,Object? rankingGame = null,Object? quickTranslation = null,Object? writing = null,Object? hanjaQuiz = null,Object? shadowing = null,}) {
  return _then(_self.copyWith(
lesson: null == lesson ? _self.lesson : lesson // ignore: cast_nullable_to_non_nullable
as ActivityBreakdown,rankingGame: null == rankingGame ? _self.rankingGame : rankingGame // ignore: cast_nullable_to_non_nullable
as ActivityBreakdown,quickTranslation: null == quickTranslation ? _self.quickTranslation : quickTranslation // ignore: cast_nullable_to_non_nullable
as ActivityBreakdown,writing: null == writing ? _self.writing : writing // ignore: cast_nullable_to_non_nullable
as ActivityBreakdown,hanjaQuiz: null == hanjaQuiz ? _self.hanjaQuiz : hanjaQuiz // ignore: cast_nullable_to_non_nullable
as ActivityBreakdown,shadowing: null == shadowing ? _self.shadowing : shadowing // ignore: cast_nullable_to_non_nullable
as ActivityBreakdown,
  ));
}
/// Create a copy of StatsBreakdown
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityBreakdownCopyWith<$Res> get lesson {
  
  return $ActivityBreakdownCopyWith<$Res>(_self.lesson, (value) {
    return _then(_self.copyWith(lesson: value));
  });
}/// Create a copy of StatsBreakdown
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityBreakdownCopyWith<$Res> get rankingGame {
  
  return $ActivityBreakdownCopyWith<$Res>(_self.rankingGame, (value) {
    return _then(_self.copyWith(rankingGame: value));
  });
}/// Create a copy of StatsBreakdown
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityBreakdownCopyWith<$Res> get quickTranslation {
  
  return $ActivityBreakdownCopyWith<$Res>(_self.quickTranslation, (value) {
    return _then(_self.copyWith(quickTranslation: value));
  });
}/// Create a copy of StatsBreakdown
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityBreakdownCopyWith<$Res> get writing {
  
  return $ActivityBreakdownCopyWith<$Res>(_self.writing, (value) {
    return _then(_self.copyWith(writing: value));
  });
}/// Create a copy of StatsBreakdown
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityBreakdownCopyWith<$Res> get hanjaQuiz {
  
  return $ActivityBreakdownCopyWith<$Res>(_self.hanjaQuiz, (value) {
    return _then(_self.copyWith(hanjaQuiz: value));
  });
}/// Create a copy of StatsBreakdown
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityBreakdownCopyWith<$Res> get shadowing {
  
  return $ActivityBreakdownCopyWith<$Res>(_self.shadowing, (value) {
    return _then(_self.copyWith(shadowing: value));
  });
}
}


/// Adds pattern-matching-related methods to [StatsBreakdown].
extension StatsBreakdownPatterns on StatsBreakdown {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StatsBreakdown value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StatsBreakdown() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StatsBreakdown value)  $default,){
final _that = this;
switch (_that) {
case _StatsBreakdown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StatsBreakdown value)?  $default,){
final _that = this;
switch (_that) {
case _StatsBreakdown() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ActivityBreakdown lesson,  ActivityBreakdown rankingGame,  ActivityBreakdown quickTranslation,  ActivityBreakdown writing,  ActivityBreakdown hanjaQuiz,  ActivityBreakdown shadowing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StatsBreakdown() when $default != null:
return $default(_that.lesson,_that.rankingGame,_that.quickTranslation,_that.writing,_that.hanjaQuiz,_that.shadowing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ActivityBreakdown lesson,  ActivityBreakdown rankingGame,  ActivityBreakdown quickTranslation,  ActivityBreakdown writing,  ActivityBreakdown hanjaQuiz,  ActivityBreakdown shadowing)  $default,) {final _that = this;
switch (_that) {
case _StatsBreakdown():
return $default(_that.lesson,_that.rankingGame,_that.quickTranslation,_that.writing,_that.hanjaQuiz,_that.shadowing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ActivityBreakdown lesson,  ActivityBreakdown rankingGame,  ActivityBreakdown quickTranslation,  ActivityBreakdown writing,  ActivityBreakdown hanjaQuiz,  ActivityBreakdown shadowing)?  $default,) {final _that = this;
switch (_that) {
case _StatsBreakdown() when $default != null:
return $default(_that.lesson,_that.rankingGame,_that.quickTranslation,_that.writing,_that.hanjaQuiz,_that.shadowing);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StatsBreakdown implements StatsBreakdown {
  const _StatsBreakdown({required this.lesson, required this.rankingGame, this.quickTranslation = const ActivityBreakdown(count: 0, timeSpent: 0, avgAccuracy: 0), this.writing = const ActivityBreakdown(count: 0, timeSpent: 0, avgAccuracy: 0), this.hanjaQuiz = const ActivityBreakdown(count: 0, timeSpent: 0, avgAccuracy: 0), this.shadowing = const ActivityBreakdown(count: 0, timeSpent: 0, avgAccuracy: 0)});
  factory _StatsBreakdown.fromJson(Map<String, dynamic> json) => _$StatsBreakdownFromJson(json);

@override final  ActivityBreakdown lesson;
@override final  ActivityBreakdown rankingGame;
@override@JsonKey() final  ActivityBreakdown quickTranslation;
@override@JsonKey() final  ActivityBreakdown writing;
@override@JsonKey() final  ActivityBreakdown hanjaQuiz;
@override@JsonKey() final  ActivityBreakdown shadowing;

/// Create a copy of StatsBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatsBreakdownCopyWith<_StatsBreakdown> get copyWith => __$StatsBreakdownCopyWithImpl<_StatsBreakdown>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatsBreakdownToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatsBreakdown&&(identical(other.lesson, lesson) || other.lesson == lesson)&&(identical(other.rankingGame, rankingGame) || other.rankingGame == rankingGame)&&(identical(other.quickTranslation, quickTranslation) || other.quickTranslation == quickTranslation)&&(identical(other.writing, writing) || other.writing == writing)&&(identical(other.hanjaQuiz, hanjaQuiz) || other.hanjaQuiz == hanjaQuiz)&&(identical(other.shadowing, shadowing) || other.shadowing == shadowing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lesson,rankingGame,quickTranslation,writing,hanjaQuiz,shadowing);

@override
String toString() {
  return 'StatsBreakdown(lesson: $lesson, rankingGame: $rankingGame, quickTranslation: $quickTranslation, writing: $writing, hanjaQuiz: $hanjaQuiz, shadowing: $shadowing)';
}


}

/// @nodoc
abstract mixin class _$StatsBreakdownCopyWith<$Res> implements $StatsBreakdownCopyWith<$Res> {
  factory _$StatsBreakdownCopyWith(_StatsBreakdown value, $Res Function(_StatsBreakdown) _then) = __$StatsBreakdownCopyWithImpl;
@override @useResult
$Res call({
 ActivityBreakdown lesson, ActivityBreakdown rankingGame, ActivityBreakdown quickTranslation, ActivityBreakdown writing, ActivityBreakdown hanjaQuiz, ActivityBreakdown shadowing
});


@override $ActivityBreakdownCopyWith<$Res> get lesson;@override $ActivityBreakdownCopyWith<$Res> get rankingGame;@override $ActivityBreakdownCopyWith<$Res> get quickTranslation;@override $ActivityBreakdownCopyWith<$Res> get writing;@override $ActivityBreakdownCopyWith<$Res> get hanjaQuiz;@override $ActivityBreakdownCopyWith<$Res> get shadowing;

}
/// @nodoc
class __$StatsBreakdownCopyWithImpl<$Res>
    implements _$StatsBreakdownCopyWith<$Res> {
  __$StatsBreakdownCopyWithImpl(this._self, this._then);

  final _StatsBreakdown _self;
  final $Res Function(_StatsBreakdown) _then;

/// Create a copy of StatsBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lesson = null,Object? rankingGame = null,Object? quickTranslation = null,Object? writing = null,Object? hanjaQuiz = null,Object? shadowing = null,}) {
  return _then(_StatsBreakdown(
lesson: null == lesson ? _self.lesson : lesson // ignore: cast_nullable_to_non_nullable
as ActivityBreakdown,rankingGame: null == rankingGame ? _self.rankingGame : rankingGame // ignore: cast_nullable_to_non_nullable
as ActivityBreakdown,quickTranslation: null == quickTranslation ? _self.quickTranslation : quickTranslation // ignore: cast_nullable_to_non_nullable
as ActivityBreakdown,writing: null == writing ? _self.writing : writing // ignore: cast_nullable_to_non_nullable
as ActivityBreakdown,hanjaQuiz: null == hanjaQuiz ? _self.hanjaQuiz : hanjaQuiz // ignore: cast_nullable_to_non_nullable
as ActivityBreakdown,shadowing: null == shadowing ? _self.shadowing : shadowing // ignore: cast_nullable_to_non_nullable
as ActivityBreakdown,
  ));
}

/// Create a copy of StatsBreakdown
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityBreakdownCopyWith<$Res> get lesson {
  
  return $ActivityBreakdownCopyWith<$Res>(_self.lesson, (value) {
    return _then(_self.copyWith(lesson: value));
  });
}/// Create a copy of StatsBreakdown
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityBreakdownCopyWith<$Res> get rankingGame {
  
  return $ActivityBreakdownCopyWith<$Res>(_self.rankingGame, (value) {
    return _then(_self.copyWith(rankingGame: value));
  });
}/// Create a copy of StatsBreakdown
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityBreakdownCopyWith<$Res> get quickTranslation {
  
  return $ActivityBreakdownCopyWith<$Res>(_self.quickTranslation, (value) {
    return _then(_self.copyWith(quickTranslation: value));
  });
}/// Create a copy of StatsBreakdown
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityBreakdownCopyWith<$Res> get writing {
  
  return $ActivityBreakdownCopyWith<$Res>(_self.writing, (value) {
    return _then(_self.copyWith(writing: value));
  });
}/// Create a copy of StatsBreakdown
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityBreakdownCopyWith<$Res> get hanjaQuiz {
  
  return $ActivityBreakdownCopyWith<$Res>(_self.hanjaQuiz, (value) {
    return _then(_self.copyWith(hanjaQuiz: value));
  });
}/// Create a copy of StatsBreakdown
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActivityBreakdownCopyWith<$Res> get shadowing {
  
  return $ActivityBreakdownCopyWith<$Res>(_self.shadowing, (value) {
    return _then(_self.copyWith(shadowing: value));
  });
}
}


/// @nodoc
mixin _$ActivityBreakdown {

 int get count; int get timeSpent; double get avgAccuracy;
/// Create a copy of ActivityBreakdown
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityBreakdownCopyWith<ActivityBreakdown> get copyWith => _$ActivityBreakdownCopyWithImpl<ActivityBreakdown>(this as ActivityBreakdown, _$identity);

  /// Serializes this ActivityBreakdown to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityBreakdown&&(identical(other.count, count) || other.count == count)&&(identical(other.timeSpent, timeSpent) || other.timeSpent == timeSpent)&&(identical(other.avgAccuracy, avgAccuracy) || other.avgAccuracy == avgAccuracy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,timeSpent,avgAccuracy);

@override
String toString() {
  return 'ActivityBreakdown(count: $count, timeSpent: $timeSpent, avgAccuracy: $avgAccuracy)';
}


}

/// @nodoc
abstract mixin class $ActivityBreakdownCopyWith<$Res>  {
  factory $ActivityBreakdownCopyWith(ActivityBreakdown value, $Res Function(ActivityBreakdown) _then) = _$ActivityBreakdownCopyWithImpl;
@useResult
$Res call({
 int count, int timeSpent, double avgAccuracy
});




}
/// @nodoc
class _$ActivityBreakdownCopyWithImpl<$Res>
    implements $ActivityBreakdownCopyWith<$Res> {
  _$ActivityBreakdownCopyWithImpl(this._self, this._then);

  final ActivityBreakdown _self;
  final $Res Function(ActivityBreakdown) _then;

/// Create a copy of ActivityBreakdown
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? timeSpent = null,Object? avgAccuracy = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,timeSpent: null == timeSpent ? _self.timeSpent : timeSpent // ignore: cast_nullable_to_non_nullable
as int,avgAccuracy: null == avgAccuracy ? _self.avgAccuracy : avgAccuracy // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ActivityBreakdown].
extension ActivityBreakdownPatterns on ActivityBreakdown {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActivityBreakdown value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActivityBreakdown() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActivityBreakdown value)  $default,){
final _that = this;
switch (_that) {
case _ActivityBreakdown():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActivityBreakdown value)?  $default,){
final _that = this;
switch (_that) {
case _ActivityBreakdown() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  int timeSpent,  double avgAccuracy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActivityBreakdown() when $default != null:
return $default(_that.count,_that.timeSpent,_that.avgAccuracy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  int timeSpent,  double avgAccuracy)  $default,) {final _that = this;
switch (_that) {
case _ActivityBreakdown():
return $default(_that.count,_that.timeSpent,_that.avgAccuracy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  int timeSpent,  double avgAccuracy)?  $default,) {final _that = this;
switch (_that) {
case _ActivityBreakdown() when $default != null:
return $default(_that.count,_that.timeSpent,_that.avgAccuracy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActivityBreakdown implements ActivityBreakdown {
  const _ActivityBreakdown({required this.count, required this.timeSpent, required this.avgAccuracy});
  factory _ActivityBreakdown.fromJson(Map<String, dynamic> json) => _$ActivityBreakdownFromJson(json);

@override final  int count;
@override final  int timeSpent;
@override final  double avgAccuracy;

/// Create a copy of ActivityBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityBreakdownCopyWith<_ActivityBreakdown> get copyWith => __$ActivityBreakdownCopyWithImpl<_ActivityBreakdown>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityBreakdownToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityBreakdown&&(identical(other.count, count) || other.count == count)&&(identical(other.timeSpent, timeSpent) || other.timeSpent == timeSpent)&&(identical(other.avgAccuracy, avgAccuracy) || other.avgAccuracy == avgAccuracy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,timeSpent,avgAccuracy);

@override
String toString() {
  return 'ActivityBreakdown(count: $count, timeSpent: $timeSpent, avgAccuracy: $avgAccuracy)';
}


}

/// @nodoc
abstract mixin class _$ActivityBreakdownCopyWith<$Res> implements $ActivityBreakdownCopyWith<$Res> {
  factory _$ActivityBreakdownCopyWith(_ActivityBreakdown value, $Res Function(_ActivityBreakdown) _then) = __$ActivityBreakdownCopyWithImpl;
@override @useResult
$Res call({
 int count, int timeSpent, double avgAccuracy
});




}
/// @nodoc
class __$ActivityBreakdownCopyWithImpl<$Res>
    implements _$ActivityBreakdownCopyWith<$Res> {
  __$ActivityBreakdownCopyWithImpl(this._self, this._then);

  final _ActivityBreakdown _self;
  final $Res Function(_ActivityBreakdown) _then;

/// Create a copy of ActivityBreakdown
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? timeSpent = null,Object? avgAccuracy = null,}) {
  return _then(_ActivityBreakdown(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,timeSpent: null == timeSpent ? _self.timeSpent : timeSpent // ignore: cast_nullable_to_non_nullable
as int,avgAccuracy: null == avgAccuracy ? _self.avgAccuracy : avgAccuracy // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$DailyActivityTrend {

 String get date; int get lessonTime; int get rankingGameTime; int get quickTranslationTime; int get writingTime; int get hanjaQuizTime; int get shadowingTime; double? get wpm; double? get accuracy;
/// Create a copy of DailyActivityTrend
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyActivityTrendCopyWith<DailyActivityTrend> get copyWith => _$DailyActivityTrendCopyWithImpl<DailyActivityTrend>(this as DailyActivityTrend, _$identity);

  /// Serializes this DailyActivityTrend to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyActivityTrend&&(identical(other.date, date) || other.date == date)&&(identical(other.lessonTime, lessonTime) || other.lessonTime == lessonTime)&&(identical(other.rankingGameTime, rankingGameTime) || other.rankingGameTime == rankingGameTime)&&(identical(other.quickTranslationTime, quickTranslationTime) || other.quickTranslationTime == quickTranslationTime)&&(identical(other.writingTime, writingTime) || other.writingTime == writingTime)&&(identical(other.hanjaQuizTime, hanjaQuizTime) || other.hanjaQuizTime == hanjaQuizTime)&&(identical(other.shadowingTime, shadowingTime) || other.shadowingTime == shadowingTime)&&(identical(other.wpm, wpm) || other.wpm == wpm)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,lessonTime,rankingGameTime,quickTranslationTime,writingTime,hanjaQuizTime,shadowingTime,wpm,accuracy);

@override
String toString() {
  return 'DailyActivityTrend(date: $date, lessonTime: $lessonTime, rankingGameTime: $rankingGameTime, quickTranslationTime: $quickTranslationTime, writingTime: $writingTime, hanjaQuizTime: $hanjaQuizTime, shadowingTime: $shadowingTime, wpm: $wpm, accuracy: $accuracy)';
}


}

/// @nodoc
abstract mixin class $DailyActivityTrendCopyWith<$Res>  {
  factory $DailyActivityTrendCopyWith(DailyActivityTrend value, $Res Function(DailyActivityTrend) _then) = _$DailyActivityTrendCopyWithImpl;
@useResult
$Res call({
 String date, int lessonTime, int rankingGameTime, int quickTranslationTime, int writingTime, int hanjaQuizTime, int shadowingTime, double? wpm, double? accuracy
});




}
/// @nodoc
class _$DailyActivityTrendCopyWithImpl<$Res>
    implements $DailyActivityTrendCopyWith<$Res> {
  _$DailyActivityTrendCopyWithImpl(this._self, this._then);

  final DailyActivityTrend _self;
  final $Res Function(DailyActivityTrend) _then;

/// Create a copy of DailyActivityTrend
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? lessonTime = null,Object? rankingGameTime = null,Object? quickTranslationTime = null,Object? writingTime = null,Object? hanjaQuizTime = null,Object? shadowingTime = null,Object? wpm = freezed,Object? accuracy = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,lessonTime: null == lessonTime ? _self.lessonTime : lessonTime // ignore: cast_nullable_to_non_nullable
as int,rankingGameTime: null == rankingGameTime ? _self.rankingGameTime : rankingGameTime // ignore: cast_nullable_to_non_nullable
as int,quickTranslationTime: null == quickTranslationTime ? _self.quickTranslationTime : quickTranslationTime // ignore: cast_nullable_to_non_nullable
as int,writingTime: null == writingTime ? _self.writingTime : writingTime // ignore: cast_nullable_to_non_nullable
as int,hanjaQuizTime: null == hanjaQuizTime ? _self.hanjaQuizTime : hanjaQuizTime // ignore: cast_nullable_to_non_nullable
as int,shadowingTime: null == shadowingTime ? _self.shadowingTime : shadowingTime // ignore: cast_nullable_to_non_nullable
as int,wpm: freezed == wpm ? _self.wpm : wpm // ignore: cast_nullable_to_non_nullable
as double?,accuracy: freezed == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyActivityTrend].
extension DailyActivityTrendPatterns on DailyActivityTrend {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyActivityTrend value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyActivityTrend() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyActivityTrend value)  $default,){
final _that = this;
switch (_that) {
case _DailyActivityTrend():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyActivityTrend value)?  $default,){
final _that = this;
switch (_that) {
case _DailyActivityTrend() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  int lessonTime,  int rankingGameTime,  int quickTranslationTime,  int writingTime,  int hanjaQuizTime,  int shadowingTime,  double? wpm,  double? accuracy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyActivityTrend() when $default != null:
return $default(_that.date,_that.lessonTime,_that.rankingGameTime,_that.quickTranslationTime,_that.writingTime,_that.hanjaQuizTime,_that.shadowingTime,_that.wpm,_that.accuracy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  int lessonTime,  int rankingGameTime,  int quickTranslationTime,  int writingTime,  int hanjaQuizTime,  int shadowingTime,  double? wpm,  double? accuracy)  $default,) {final _that = this;
switch (_that) {
case _DailyActivityTrend():
return $default(_that.date,_that.lessonTime,_that.rankingGameTime,_that.quickTranslationTime,_that.writingTime,_that.hanjaQuizTime,_that.shadowingTime,_that.wpm,_that.accuracy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  int lessonTime,  int rankingGameTime,  int quickTranslationTime,  int writingTime,  int hanjaQuizTime,  int shadowingTime,  double? wpm,  double? accuracy)?  $default,) {final _that = this;
switch (_that) {
case _DailyActivityTrend() when $default != null:
return $default(_that.date,_that.lessonTime,_that.rankingGameTime,_that.quickTranslationTime,_that.writingTime,_that.hanjaQuizTime,_that.shadowingTime,_that.wpm,_that.accuracy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyActivityTrend implements DailyActivityTrend {
  const _DailyActivityTrend({required this.date, required this.lessonTime, required this.rankingGameTime, this.quickTranslationTime = 0, this.writingTime = 0, this.hanjaQuizTime = 0, this.shadowingTime = 0, this.wpm, this.accuracy});
  factory _DailyActivityTrend.fromJson(Map<String, dynamic> json) => _$DailyActivityTrendFromJson(json);

@override final  String date;
@override final  int lessonTime;
@override final  int rankingGameTime;
@override@JsonKey() final  int quickTranslationTime;
@override@JsonKey() final  int writingTime;
@override@JsonKey() final  int hanjaQuizTime;
@override@JsonKey() final  int shadowingTime;
@override final  double? wpm;
@override final  double? accuracy;

/// Create a copy of DailyActivityTrend
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyActivityTrendCopyWith<_DailyActivityTrend> get copyWith => __$DailyActivityTrendCopyWithImpl<_DailyActivityTrend>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyActivityTrendToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyActivityTrend&&(identical(other.date, date) || other.date == date)&&(identical(other.lessonTime, lessonTime) || other.lessonTime == lessonTime)&&(identical(other.rankingGameTime, rankingGameTime) || other.rankingGameTime == rankingGameTime)&&(identical(other.quickTranslationTime, quickTranslationTime) || other.quickTranslationTime == quickTranslationTime)&&(identical(other.writingTime, writingTime) || other.writingTime == writingTime)&&(identical(other.hanjaQuizTime, hanjaQuizTime) || other.hanjaQuizTime == hanjaQuizTime)&&(identical(other.shadowingTime, shadowingTime) || other.shadowingTime == shadowingTime)&&(identical(other.wpm, wpm) || other.wpm == wpm)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,lessonTime,rankingGameTime,quickTranslationTime,writingTime,hanjaQuizTime,shadowingTime,wpm,accuracy);

@override
String toString() {
  return 'DailyActivityTrend(date: $date, lessonTime: $lessonTime, rankingGameTime: $rankingGameTime, quickTranslationTime: $quickTranslationTime, writingTime: $writingTime, hanjaQuizTime: $hanjaQuizTime, shadowingTime: $shadowingTime, wpm: $wpm, accuracy: $accuracy)';
}


}

/// @nodoc
abstract mixin class _$DailyActivityTrendCopyWith<$Res> implements $DailyActivityTrendCopyWith<$Res> {
  factory _$DailyActivityTrendCopyWith(_DailyActivityTrend value, $Res Function(_DailyActivityTrend) _then) = __$DailyActivityTrendCopyWithImpl;
@override @useResult
$Res call({
 String date, int lessonTime, int rankingGameTime, int quickTranslationTime, int writingTime, int hanjaQuizTime, int shadowingTime, double? wpm, double? accuracy
});




}
/// @nodoc
class __$DailyActivityTrendCopyWithImpl<$Res>
    implements _$DailyActivityTrendCopyWith<$Res> {
  __$DailyActivityTrendCopyWithImpl(this._self, this._then);

  final _DailyActivityTrend _self;
  final $Res Function(_DailyActivityTrend) _then;

/// Create a copy of DailyActivityTrend
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? lessonTime = null,Object? rankingGameTime = null,Object? quickTranslationTime = null,Object? writingTime = null,Object? hanjaQuizTime = null,Object? shadowingTime = null,Object? wpm = freezed,Object? accuracy = freezed,}) {
  return _then(_DailyActivityTrend(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,lessonTime: null == lessonTime ? _self.lessonTime : lessonTime // ignore: cast_nullable_to_non_nullable
as int,rankingGameTime: null == rankingGameTime ? _self.rankingGameTime : rankingGameTime // ignore: cast_nullable_to_non_nullable
as int,quickTranslationTime: null == quickTranslationTime ? _self.quickTranslationTime : quickTranslationTime // ignore: cast_nullable_to_non_nullable
as int,writingTime: null == writingTime ? _self.writingTime : writingTime // ignore: cast_nullable_to_non_nullable
as int,hanjaQuizTime: null == hanjaQuizTime ? _self.hanjaQuizTime : hanjaQuizTime // ignore: cast_nullable_to_non_nullable
as int,shadowingTime: null == shadowingTime ? _self.shadowingTime : shadowingTime // ignore: cast_nullable_to_non_nullable
as int,wpm: freezed == wpm ? _self.wpm : wpm // ignore: cast_nullable_to_non_nullable
as double?,accuracy: freezed == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
