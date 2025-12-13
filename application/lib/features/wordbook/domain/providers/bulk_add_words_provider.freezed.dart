// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bulk_add_words_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BulkAddState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkAddState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BulkAddState()';
}


}

/// @nodoc
class $BulkAddStateCopyWith<$Res>  {
$BulkAddStateCopyWith(BulkAddState _, $Res Function(BulkAddState) __);
}


/// Adds pattern-matching-related methods to [BulkAddState].
extension BulkAddStatePatterns on BulkAddState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BulkAddInitial value)?  initial,TResult Function( BulkAddLoading value)?  loading,TResult Function( BulkAddSuccess value)?  success,TResult Function( BulkAddError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BulkAddInitial() when initial != null:
return initial(_that);case BulkAddLoading() when loading != null:
return loading(_that);case BulkAddSuccess() when success != null:
return success(_that);case BulkAddError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BulkAddInitial value)  initial,required TResult Function( BulkAddLoading value)  loading,required TResult Function( BulkAddSuccess value)  success,required TResult Function( BulkAddError value)  error,}){
final _that = this;
switch (_that) {
case BulkAddInitial():
return initial(_that);case BulkAddLoading():
return loading(_that);case BulkAddSuccess():
return success(_that);case BulkAddError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BulkAddInitial value)?  initial,TResult? Function( BulkAddLoading value)?  loading,TResult? Function( BulkAddSuccess value)?  success,TResult? Function( BulkAddError value)?  error,}){
final _that = this;
switch (_that) {
case BulkAddInitial() when initial != null:
return initial(_that);case BulkAddLoading() when loading != null:
return loading(_that);case BulkAddSuccess() when success != null:
return success(_that);case BulkAddError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( int total,  int processed,  int added,  int skipped,  int failed)?  loading,TResult Function( int added,  int skipped,  int failed)?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BulkAddInitial() when initial != null:
return initial();case BulkAddLoading() when loading != null:
return loading(_that.total,_that.processed,_that.added,_that.skipped,_that.failed);case BulkAddSuccess() when success != null:
return success(_that.added,_that.skipped,_that.failed);case BulkAddError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( int total,  int processed,  int added,  int skipped,  int failed)  loading,required TResult Function( int added,  int skipped,  int failed)  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case BulkAddInitial():
return initial();case BulkAddLoading():
return loading(_that.total,_that.processed,_that.added,_that.skipped,_that.failed);case BulkAddSuccess():
return success(_that.added,_that.skipped,_that.failed);case BulkAddError():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( int total,  int processed,  int added,  int skipped,  int failed)?  loading,TResult? Function( int added,  int skipped,  int failed)?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case BulkAddInitial() when initial != null:
return initial();case BulkAddLoading() when loading != null:
return loading(_that.total,_that.processed,_that.added,_that.skipped,_that.failed);case BulkAddSuccess() when success != null:
return success(_that.added,_that.skipped,_that.failed);case BulkAddError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class BulkAddInitial implements BulkAddState {
  const BulkAddInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkAddInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BulkAddState.initial()';
}


}




/// @nodoc


class BulkAddLoading implements BulkAddState {
  const BulkAddLoading({required this.total, required this.processed, required this.added, required this.skipped, required this.failed});
  

 final  int total;
 final  int processed;
 final  int added;
 final  int skipped;
 final  int failed;

/// Create a copy of BulkAddState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkAddLoadingCopyWith<BulkAddLoading> get copyWith => _$BulkAddLoadingCopyWithImpl<BulkAddLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkAddLoading&&(identical(other.total, total) || other.total == total)&&(identical(other.processed, processed) || other.processed == processed)&&(identical(other.added, added) || other.added == added)&&(identical(other.skipped, skipped) || other.skipped == skipped)&&(identical(other.failed, failed) || other.failed == failed));
}


@override
int get hashCode => Object.hash(runtimeType,total,processed,added,skipped,failed);

@override
String toString() {
  return 'BulkAddState.loading(total: $total, processed: $processed, added: $added, skipped: $skipped, failed: $failed)';
}


}

/// @nodoc
abstract mixin class $BulkAddLoadingCopyWith<$Res> implements $BulkAddStateCopyWith<$Res> {
  factory $BulkAddLoadingCopyWith(BulkAddLoading value, $Res Function(BulkAddLoading) _then) = _$BulkAddLoadingCopyWithImpl;
@useResult
$Res call({
 int total, int processed, int added, int skipped, int failed
});




}
/// @nodoc
class _$BulkAddLoadingCopyWithImpl<$Res>
    implements $BulkAddLoadingCopyWith<$Res> {
  _$BulkAddLoadingCopyWithImpl(this._self, this._then);

  final BulkAddLoading _self;
  final $Res Function(BulkAddLoading) _then;

/// Create a copy of BulkAddState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? total = null,Object? processed = null,Object? added = null,Object? skipped = null,Object? failed = null,}) {
  return _then(BulkAddLoading(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,processed: null == processed ? _self.processed : processed // ignore: cast_nullable_to_non_nullable
as int,added: null == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as int,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class BulkAddSuccess implements BulkAddState {
  const BulkAddSuccess({required this.added, required this.skipped, required this.failed});
  

 final  int added;
 final  int skipped;
 final  int failed;

/// Create a copy of BulkAddState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkAddSuccessCopyWith<BulkAddSuccess> get copyWith => _$BulkAddSuccessCopyWithImpl<BulkAddSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkAddSuccess&&(identical(other.added, added) || other.added == added)&&(identical(other.skipped, skipped) || other.skipped == skipped)&&(identical(other.failed, failed) || other.failed == failed));
}


@override
int get hashCode => Object.hash(runtimeType,added,skipped,failed);

@override
String toString() {
  return 'BulkAddState.success(added: $added, skipped: $skipped, failed: $failed)';
}


}

/// @nodoc
abstract mixin class $BulkAddSuccessCopyWith<$Res> implements $BulkAddStateCopyWith<$Res> {
  factory $BulkAddSuccessCopyWith(BulkAddSuccess value, $Res Function(BulkAddSuccess) _then) = _$BulkAddSuccessCopyWithImpl;
@useResult
$Res call({
 int added, int skipped, int failed
});




}
/// @nodoc
class _$BulkAddSuccessCopyWithImpl<$Res>
    implements $BulkAddSuccessCopyWith<$Res> {
  _$BulkAddSuccessCopyWithImpl(this._self, this._then);

  final BulkAddSuccess _self;
  final $Res Function(BulkAddSuccess) _then;

/// Create a copy of BulkAddState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? added = null,Object? skipped = null,Object? failed = null,}) {
  return _then(BulkAddSuccess(
added: null == added ? _self.added : added // ignore: cast_nullable_to_non_nullable
as int,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class BulkAddError implements BulkAddState {
  const BulkAddError(this.message);
  

 final  String message;

/// Create a copy of BulkAddState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BulkAddErrorCopyWith<BulkAddError> get copyWith => _$BulkAddErrorCopyWithImpl<BulkAddError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BulkAddError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'BulkAddState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $BulkAddErrorCopyWith<$Res> implements $BulkAddStateCopyWith<$Res> {
  factory $BulkAddErrorCopyWith(BulkAddError value, $Res Function(BulkAddError) _then) = _$BulkAddErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$BulkAddErrorCopyWithImpl<$Res>
    implements $BulkAddErrorCopyWith<$Res> {
  _$BulkAddErrorCopyWithImpl(this._self, this._then);

  final BulkAddError _self;
  final $Res Function(BulkAddError) _then;

/// Create a copy of BulkAddState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(BulkAddError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
