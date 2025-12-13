// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listening_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListeningSettings {

/// 再生速度 (0.5 ~ 1.5)
 double get speechRate;/// 日本語から韓国語への間隔 (ミリ秒)
 int get japaneseToKoreanMs;/// 単語間の間隔 (ミリ秒)
 int get wordToWordMs;
/// Create a copy of ListeningSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListeningSettingsCopyWith<ListeningSettings> get copyWith => _$ListeningSettingsCopyWithImpl<ListeningSettings>(this as ListeningSettings, _$identity);

  /// Serializes this ListeningSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListeningSettings&&(identical(other.speechRate, speechRate) || other.speechRate == speechRate)&&(identical(other.japaneseToKoreanMs, japaneseToKoreanMs) || other.japaneseToKoreanMs == japaneseToKoreanMs)&&(identical(other.wordToWordMs, wordToWordMs) || other.wordToWordMs == wordToWordMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,speechRate,japaneseToKoreanMs,wordToWordMs);

@override
String toString() {
  return 'ListeningSettings(speechRate: $speechRate, japaneseToKoreanMs: $japaneseToKoreanMs, wordToWordMs: $wordToWordMs)';
}


}

/// @nodoc
abstract mixin class $ListeningSettingsCopyWith<$Res>  {
  factory $ListeningSettingsCopyWith(ListeningSettings value, $Res Function(ListeningSettings) _then) = _$ListeningSettingsCopyWithImpl;
@useResult
$Res call({
 double speechRate, int japaneseToKoreanMs, int wordToWordMs
});




}
/// @nodoc
class _$ListeningSettingsCopyWithImpl<$Res>
    implements $ListeningSettingsCopyWith<$Res> {
  _$ListeningSettingsCopyWithImpl(this._self, this._then);

  final ListeningSettings _self;
  final $Res Function(ListeningSettings) _then;

/// Create a copy of ListeningSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? speechRate = null,Object? japaneseToKoreanMs = null,Object? wordToWordMs = null,}) {
  return _then(_self.copyWith(
speechRate: null == speechRate ? _self.speechRate : speechRate // ignore: cast_nullable_to_non_nullable
as double,japaneseToKoreanMs: null == japaneseToKoreanMs ? _self.japaneseToKoreanMs : japaneseToKoreanMs // ignore: cast_nullable_to_non_nullable
as int,wordToWordMs: null == wordToWordMs ? _self.wordToWordMs : wordToWordMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ListeningSettings].
extension ListeningSettingsPatterns on ListeningSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListeningSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListeningSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListeningSettings value)  $default,){
final _that = this;
switch (_that) {
case _ListeningSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListeningSettings value)?  $default,){
final _that = this;
switch (_that) {
case _ListeningSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double speechRate,  int japaneseToKoreanMs,  int wordToWordMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListeningSettings() when $default != null:
return $default(_that.speechRate,_that.japaneseToKoreanMs,_that.wordToWordMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double speechRate,  int japaneseToKoreanMs,  int wordToWordMs)  $default,) {final _that = this;
switch (_that) {
case _ListeningSettings():
return $default(_that.speechRate,_that.japaneseToKoreanMs,_that.wordToWordMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double speechRate,  int japaneseToKoreanMs,  int wordToWordMs)?  $default,) {final _that = this;
switch (_that) {
case _ListeningSettings() when $default != null:
return $default(_that.speechRate,_that.japaneseToKoreanMs,_that.wordToWordMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ListeningSettings implements ListeningSettings {
  const _ListeningSettings({this.speechRate = 1.0, this.japaneseToKoreanMs = 500, this.wordToWordMs = 1000});
  factory _ListeningSettings.fromJson(Map<String, dynamic> json) => _$ListeningSettingsFromJson(json);

/// 再生速度 (0.5 ~ 1.5)
@override@JsonKey() final  double speechRate;
/// 日本語から韓国語への間隔 (ミリ秒)
@override@JsonKey() final  int japaneseToKoreanMs;
/// 単語間の間隔 (ミリ秒)
@override@JsonKey() final  int wordToWordMs;

/// Create a copy of ListeningSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListeningSettingsCopyWith<_ListeningSettings> get copyWith => __$ListeningSettingsCopyWithImpl<_ListeningSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListeningSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListeningSettings&&(identical(other.speechRate, speechRate) || other.speechRate == speechRate)&&(identical(other.japaneseToKoreanMs, japaneseToKoreanMs) || other.japaneseToKoreanMs == japaneseToKoreanMs)&&(identical(other.wordToWordMs, wordToWordMs) || other.wordToWordMs == wordToWordMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,speechRate,japaneseToKoreanMs,wordToWordMs);

@override
String toString() {
  return 'ListeningSettings(speechRate: $speechRate, japaneseToKoreanMs: $japaneseToKoreanMs, wordToWordMs: $wordToWordMs)';
}


}

/// @nodoc
abstract mixin class _$ListeningSettingsCopyWith<$Res> implements $ListeningSettingsCopyWith<$Res> {
  factory _$ListeningSettingsCopyWith(_ListeningSettings value, $Res Function(_ListeningSettings) _then) = __$ListeningSettingsCopyWithImpl;
@override @useResult
$Res call({
 double speechRate, int japaneseToKoreanMs, int wordToWordMs
});




}
/// @nodoc
class __$ListeningSettingsCopyWithImpl<$Res>
    implements _$ListeningSettingsCopyWith<$Res> {
  __$ListeningSettingsCopyWithImpl(this._self, this._then);

  final _ListeningSettings _self;
  final $Res Function(_ListeningSettings) _then;

/// Create a copy of ListeningSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? speechRate = null,Object? japaneseToKoreanMs = null,Object? wordToWordMs = null,}) {
  return _then(_ListeningSettings(
speechRate: null == speechRate ? _self.speechRate : speechRate // ignore: cast_nullable_to_non_nullable
as double,japaneseToKoreanMs: null == japaneseToKoreanMs ? _self.japaneseToKoreanMs : japaneseToKoreanMs // ignore: cast_nullable_to_non_nullable
as int,wordToWordMs: null == wordToWordMs ? _self.wordToWordMs : wordToWordMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
