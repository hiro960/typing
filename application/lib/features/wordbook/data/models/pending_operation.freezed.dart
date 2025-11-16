// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pending_operation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PendingOperation {

 String get id; String get operationType; String? get tempId; String? get wordId; Map<String, dynamic> get data; DateTime get createdAt; int get retryCount; DateTime? get lastAttemptAt;
/// Create a copy of PendingOperation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingOperationCopyWith<PendingOperation> get copyWith => _$PendingOperationCopyWithImpl<PendingOperation>(this as PendingOperation, _$identity);

  /// Serializes this PendingOperation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingOperation&&(identical(other.id, id) || other.id == id)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.tempId, tempId) || other.tempId == tempId)&&(identical(other.wordId, wordId) || other.wordId == wordId)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.lastAttemptAt, lastAttemptAt) || other.lastAttemptAt == lastAttemptAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,operationType,tempId,wordId,const DeepCollectionEquality().hash(data),createdAt,retryCount,lastAttemptAt);

@override
String toString() {
  return 'PendingOperation(id: $id, operationType: $operationType, tempId: $tempId, wordId: $wordId, data: $data, createdAt: $createdAt, retryCount: $retryCount, lastAttemptAt: $lastAttemptAt)';
}


}

/// @nodoc
abstract mixin class $PendingOperationCopyWith<$Res>  {
  factory $PendingOperationCopyWith(PendingOperation value, $Res Function(PendingOperation) _then) = _$PendingOperationCopyWithImpl;
@useResult
$Res call({
 String id, String operationType, String? tempId, String? wordId, Map<String, dynamic> data, DateTime createdAt, int retryCount, DateTime? lastAttemptAt
});




}
/// @nodoc
class _$PendingOperationCopyWithImpl<$Res>
    implements $PendingOperationCopyWith<$Res> {
  _$PendingOperationCopyWithImpl(this._self, this._then);

  final PendingOperation _self;
  final $Res Function(PendingOperation) _then;

/// Create a copy of PendingOperation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? operationType = null,Object? tempId = freezed,Object? wordId = freezed,Object? data = null,Object? createdAt = null,Object? retryCount = null,Object? lastAttemptAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,tempId: freezed == tempId ? _self.tempId : tempId // ignore: cast_nullable_to_non_nullable
as String?,wordId: freezed == wordId ? _self.wordId : wordId // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,lastAttemptAt: freezed == lastAttemptAt ? _self.lastAttemptAt : lastAttemptAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PendingOperation].
extension PendingOperationPatterns on PendingOperation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingOperation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingOperation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingOperation value)  $default,){
final _that = this;
switch (_that) {
case _PendingOperation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingOperation value)?  $default,){
final _that = this;
switch (_that) {
case _PendingOperation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String operationType,  String? tempId,  String? wordId,  Map<String, dynamic> data,  DateTime createdAt,  int retryCount,  DateTime? lastAttemptAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PendingOperation() when $default != null:
return $default(_that.id,_that.operationType,_that.tempId,_that.wordId,_that.data,_that.createdAt,_that.retryCount,_that.lastAttemptAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String operationType,  String? tempId,  String? wordId,  Map<String, dynamic> data,  DateTime createdAt,  int retryCount,  DateTime? lastAttemptAt)  $default,) {final _that = this;
switch (_that) {
case _PendingOperation():
return $default(_that.id,_that.operationType,_that.tempId,_that.wordId,_that.data,_that.createdAt,_that.retryCount,_that.lastAttemptAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String operationType,  String? tempId,  String? wordId,  Map<String, dynamic> data,  DateTime createdAt,  int retryCount,  DateTime? lastAttemptAt)?  $default,) {final _that = this;
switch (_that) {
case _PendingOperation() when $default != null:
return $default(_that.id,_that.operationType,_that.tempId,_that.wordId,_that.data,_that.createdAt,_that.retryCount,_that.lastAttemptAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PendingOperation implements PendingOperation {
  const _PendingOperation({required this.id, required this.operationType, this.tempId, this.wordId, required final  Map<String, dynamic> data, required this.createdAt, this.retryCount = 0, this.lastAttemptAt}): _data = data;
  factory _PendingOperation.fromJson(Map<String, dynamic> json) => _$PendingOperationFromJson(json);

@override final  String id;
@override final  String operationType;
@override final  String? tempId;
@override final  String? wordId;
 final  Map<String, dynamic> _data;
@override Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}

@override final  DateTime createdAt;
@override@JsonKey() final  int retryCount;
@override final  DateTime? lastAttemptAt;

/// Create a copy of PendingOperation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingOperationCopyWith<_PendingOperation> get copyWith => __$PendingOperationCopyWithImpl<_PendingOperation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PendingOperationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingOperation&&(identical(other.id, id) || other.id == id)&&(identical(other.operationType, operationType) || other.operationType == operationType)&&(identical(other.tempId, tempId) || other.tempId == tempId)&&(identical(other.wordId, wordId) || other.wordId == wordId)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.lastAttemptAt, lastAttemptAt) || other.lastAttemptAt == lastAttemptAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,operationType,tempId,wordId,const DeepCollectionEquality().hash(_data),createdAt,retryCount,lastAttemptAt);

@override
String toString() {
  return 'PendingOperation(id: $id, operationType: $operationType, tempId: $tempId, wordId: $wordId, data: $data, createdAt: $createdAt, retryCount: $retryCount, lastAttemptAt: $lastAttemptAt)';
}


}

/// @nodoc
abstract mixin class _$PendingOperationCopyWith<$Res> implements $PendingOperationCopyWith<$Res> {
  factory _$PendingOperationCopyWith(_PendingOperation value, $Res Function(_PendingOperation) _then) = __$PendingOperationCopyWithImpl;
@override @useResult
$Res call({
 String id, String operationType, String? tempId, String? wordId, Map<String, dynamic> data, DateTime createdAt, int retryCount, DateTime? lastAttemptAt
});




}
/// @nodoc
class __$PendingOperationCopyWithImpl<$Res>
    implements _$PendingOperationCopyWith<$Res> {
  __$PendingOperationCopyWithImpl(this._self, this._then);

  final _PendingOperation _self;
  final $Res Function(_PendingOperation) _then;

/// Create a copy of PendingOperation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? operationType = null,Object? tempId = freezed,Object? wordId = freezed,Object? data = null,Object? createdAt = null,Object? retryCount = null,Object? lastAttemptAt = freezed,}) {
  return _then(_PendingOperation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,operationType: null == operationType ? _self.operationType : operationType // ignore: cast_nullable_to_non_nullable
as String,tempId: freezed == tempId ? _self.tempId : tempId // ignore: cast_nullable_to_non_nullable
as String?,wordId: freezed == wordId ? _self.wordId : wordId // ignore: cast_nullable_to_non_nullable
as String?,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,lastAttemptAt: freezed == lastAttemptAt ? _self.lastAttemptAt : lastAttemptAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
