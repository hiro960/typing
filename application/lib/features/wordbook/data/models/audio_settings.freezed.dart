// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AudioSettings {

 double get speechRate; bool get autoPlay; String? get voiceEngine;
/// Create a copy of AudioSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioSettingsCopyWith<AudioSettings> get copyWith => _$AudioSettingsCopyWithImpl<AudioSettings>(this as AudioSettings, _$identity);

  /// Serializes this AudioSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioSettings&&(identical(other.speechRate, speechRate) || other.speechRate == speechRate)&&(identical(other.autoPlay, autoPlay) || other.autoPlay == autoPlay)&&(identical(other.voiceEngine, voiceEngine) || other.voiceEngine == voiceEngine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,speechRate,autoPlay,voiceEngine);

@override
String toString() {
  return 'AudioSettings(speechRate: $speechRate, autoPlay: $autoPlay, voiceEngine: $voiceEngine)';
}


}

/// @nodoc
abstract mixin class $AudioSettingsCopyWith<$Res>  {
  factory $AudioSettingsCopyWith(AudioSettings value, $Res Function(AudioSettings) _then) = _$AudioSettingsCopyWithImpl;
@useResult
$Res call({
 double speechRate, bool autoPlay, String? voiceEngine
});




}
/// @nodoc
class _$AudioSettingsCopyWithImpl<$Res>
    implements $AudioSettingsCopyWith<$Res> {
  _$AudioSettingsCopyWithImpl(this._self, this._then);

  final AudioSettings _self;
  final $Res Function(AudioSettings) _then;

/// Create a copy of AudioSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? speechRate = null,Object? autoPlay = null,Object? voiceEngine = freezed,}) {
  return _then(_self.copyWith(
speechRate: null == speechRate ? _self.speechRate : speechRate // ignore: cast_nullable_to_non_nullable
as double,autoPlay: null == autoPlay ? _self.autoPlay : autoPlay // ignore: cast_nullable_to_non_nullable
as bool,voiceEngine: freezed == voiceEngine ? _self.voiceEngine : voiceEngine // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AudioSettings].
extension AudioSettingsPatterns on AudioSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudioSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudioSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudioSettings value)  $default,){
final _that = this;
switch (_that) {
case _AudioSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudioSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AudioSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double speechRate,  bool autoPlay,  String? voiceEngine)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudioSettings() when $default != null:
return $default(_that.speechRate,_that.autoPlay,_that.voiceEngine);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double speechRate,  bool autoPlay,  String? voiceEngine)  $default,) {final _that = this;
switch (_that) {
case _AudioSettings():
return $default(_that.speechRate,_that.autoPlay,_that.voiceEngine);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double speechRate,  bool autoPlay,  String? voiceEngine)?  $default,) {final _that = this;
switch (_that) {
case _AudioSettings() when $default != null:
return $default(_that.speechRate,_that.autoPlay,_that.voiceEngine);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AudioSettings implements AudioSettings {
  const _AudioSettings({this.speechRate = 0.5, this.autoPlay = false, this.voiceEngine});
  factory _AudioSettings.fromJson(Map<String, dynamic> json) => _$AudioSettingsFromJson(json);

@override@JsonKey() final  double speechRate;
@override@JsonKey() final  bool autoPlay;
@override final  String? voiceEngine;

/// Create a copy of AudioSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioSettingsCopyWith<_AudioSettings> get copyWith => __$AudioSettingsCopyWithImpl<_AudioSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AudioSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioSettings&&(identical(other.speechRate, speechRate) || other.speechRate == speechRate)&&(identical(other.autoPlay, autoPlay) || other.autoPlay == autoPlay)&&(identical(other.voiceEngine, voiceEngine) || other.voiceEngine == voiceEngine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,speechRate,autoPlay,voiceEngine);

@override
String toString() {
  return 'AudioSettings(speechRate: $speechRate, autoPlay: $autoPlay, voiceEngine: $voiceEngine)';
}


}

/// @nodoc
abstract mixin class _$AudioSettingsCopyWith<$Res> implements $AudioSettingsCopyWith<$Res> {
  factory _$AudioSettingsCopyWith(_AudioSettings value, $Res Function(_AudioSettings) _then) = __$AudioSettingsCopyWithImpl;
@override @useResult
$Res call({
 double speechRate, bool autoPlay, String? voiceEngine
});




}
/// @nodoc
class __$AudioSettingsCopyWithImpl<$Res>
    implements _$AudioSettingsCopyWith<$Res> {
  __$AudioSettingsCopyWithImpl(this._self, this._then);

  final _AudioSettings _self;
  final $Res Function(_AudioSettings) _then;

/// Create a copy of AudioSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? speechRate = null,Object? autoPlay = null,Object? voiceEngine = freezed,}) {
  return _then(_AudioSettings(
speechRate: null == speechRate ? _self.speechRate : speechRate // ignore: cast_nullable_to_non_nullable
as double,autoPlay: null == autoPlay ? _self.autoPlay : autoPlay // ignore: cast_nullable_to_non_nullable
as bool,voiceEngine: freezed == voiceEngine ? _self.voiceEngine : voiceEngine // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
