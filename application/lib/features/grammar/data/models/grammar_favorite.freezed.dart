// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grammar_favorite.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GrammarFavorite {

 String get grammarId; DateTime get addedAt; String? get note;
/// Create a copy of GrammarFavorite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GrammarFavoriteCopyWith<GrammarFavorite> get copyWith => _$GrammarFavoriteCopyWithImpl<GrammarFavorite>(this as GrammarFavorite, _$identity);

  /// Serializes this GrammarFavorite to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GrammarFavorite&&(identical(other.grammarId, grammarId) || other.grammarId == grammarId)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,grammarId,addedAt,note);

@override
String toString() {
  return 'GrammarFavorite(grammarId: $grammarId, addedAt: $addedAt, note: $note)';
}


}

/// @nodoc
abstract mixin class $GrammarFavoriteCopyWith<$Res>  {
  factory $GrammarFavoriteCopyWith(GrammarFavorite value, $Res Function(GrammarFavorite) _then) = _$GrammarFavoriteCopyWithImpl;
@useResult
$Res call({
 String grammarId, DateTime addedAt, String? note
});




}
/// @nodoc
class _$GrammarFavoriteCopyWithImpl<$Res>
    implements $GrammarFavoriteCopyWith<$Res> {
  _$GrammarFavoriteCopyWithImpl(this._self, this._then);

  final GrammarFavorite _self;
  final $Res Function(GrammarFavorite) _then;

/// Create a copy of GrammarFavorite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? grammarId = null,Object? addedAt = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
grammarId: null == grammarId ? _self.grammarId : grammarId // ignore: cast_nullable_to_non_nullable
as String,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GrammarFavorite].
extension GrammarFavoritePatterns on GrammarFavorite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GrammarFavorite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GrammarFavorite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GrammarFavorite value)  $default,){
final _that = this;
switch (_that) {
case _GrammarFavorite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GrammarFavorite value)?  $default,){
final _that = this;
switch (_that) {
case _GrammarFavorite() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String grammarId,  DateTime addedAt,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GrammarFavorite() when $default != null:
return $default(_that.grammarId,_that.addedAt,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String grammarId,  DateTime addedAt,  String? note)  $default,) {final _that = this;
switch (_that) {
case _GrammarFavorite():
return $default(_that.grammarId,_that.addedAt,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String grammarId,  DateTime addedAt,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _GrammarFavorite() when $default != null:
return $default(_that.grammarId,_that.addedAt,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GrammarFavorite implements GrammarFavorite {
  const _GrammarFavorite({required this.grammarId, required this.addedAt, this.note});
  factory _GrammarFavorite.fromJson(Map<String, dynamic> json) => _$GrammarFavoriteFromJson(json);

@override final  String grammarId;
@override final  DateTime addedAt;
@override final  String? note;

/// Create a copy of GrammarFavorite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GrammarFavoriteCopyWith<_GrammarFavorite> get copyWith => __$GrammarFavoriteCopyWithImpl<_GrammarFavorite>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GrammarFavoriteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GrammarFavorite&&(identical(other.grammarId, grammarId) || other.grammarId == grammarId)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,grammarId,addedAt,note);

@override
String toString() {
  return 'GrammarFavorite(grammarId: $grammarId, addedAt: $addedAt, note: $note)';
}


}

/// @nodoc
abstract mixin class _$GrammarFavoriteCopyWith<$Res> implements $GrammarFavoriteCopyWith<$Res> {
  factory _$GrammarFavoriteCopyWith(_GrammarFavorite value, $Res Function(_GrammarFavorite) _then) = __$GrammarFavoriteCopyWithImpl;
@override @useResult
$Res call({
 String grammarId, DateTime addedAt, String? note
});




}
/// @nodoc
class __$GrammarFavoriteCopyWithImpl<$Res>
    implements _$GrammarFavoriteCopyWith<$Res> {
  __$GrammarFavoriteCopyWithImpl(this._self, this._then);

  final _GrammarFavorite _self;
  final $Res Function(_GrammarFavorite) _then;

/// Create a copy of GrammarFavorite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? grammarId = null,Object? addedAt = null,Object? note = freezed,}) {
  return _then(_GrammarFavorite(
grammarId: null == grammarId ? _self.grammarId : grammarId // ignore: cast_nullable_to_non_nullable
as String,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
