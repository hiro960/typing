// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'translation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TranslationResult {

 String get sourceText; String get translatedText; TranslationDirection get direction; DateTime get createdAt;
/// Create a copy of TranslationResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranslationResultCopyWith<TranslationResult> get copyWith => _$TranslationResultCopyWithImpl<TranslationResult>(this as TranslationResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranslationResult&&(identical(other.sourceText, sourceText) || other.sourceText == sourceText)&&(identical(other.translatedText, translatedText) || other.translatedText == translatedText)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,sourceText,translatedText,direction,createdAt);

@override
String toString() {
  return 'TranslationResult(sourceText: $sourceText, translatedText: $translatedText, direction: $direction, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TranslationResultCopyWith<$Res>  {
  factory $TranslationResultCopyWith(TranslationResult value, $Res Function(TranslationResult) _then) = _$TranslationResultCopyWithImpl;
@useResult
$Res call({
 String sourceText, String translatedText, TranslationDirection direction, DateTime createdAt
});




}
/// @nodoc
class _$TranslationResultCopyWithImpl<$Res>
    implements $TranslationResultCopyWith<$Res> {
  _$TranslationResultCopyWithImpl(this._self, this._then);

  final TranslationResult _self;
  final $Res Function(TranslationResult) _then;

/// Create a copy of TranslationResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sourceText = null,Object? translatedText = null,Object? direction = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
sourceText: null == sourceText ? _self.sourceText : sourceText // ignore: cast_nullable_to_non_nullable
as String,translatedText: null == translatedText ? _self.translatedText : translatedText // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TranslationDirection,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TranslationResult].
extension TranslationResultPatterns on TranslationResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranslationResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranslationResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranslationResult value)  $default,){
final _that = this;
switch (_that) {
case _TranslationResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranslationResult value)?  $default,){
final _that = this;
switch (_that) {
case _TranslationResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sourceText,  String translatedText,  TranslationDirection direction,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranslationResult() when $default != null:
return $default(_that.sourceText,_that.translatedText,_that.direction,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sourceText,  String translatedText,  TranslationDirection direction,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _TranslationResult():
return $default(_that.sourceText,_that.translatedText,_that.direction,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sourceText,  String translatedText,  TranslationDirection direction,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TranslationResult() when $default != null:
return $default(_that.sourceText,_that.translatedText,_that.direction,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _TranslationResult implements TranslationResult {
  const _TranslationResult({required this.sourceText, required this.translatedText, required this.direction, required this.createdAt});
  

@override final  String sourceText;
@override final  String translatedText;
@override final  TranslationDirection direction;
@override final  DateTime createdAt;

/// Create a copy of TranslationResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranslationResultCopyWith<_TranslationResult> get copyWith => __$TranslationResultCopyWithImpl<_TranslationResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranslationResult&&(identical(other.sourceText, sourceText) || other.sourceText == sourceText)&&(identical(other.translatedText, translatedText) || other.translatedText == translatedText)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,sourceText,translatedText,direction,createdAt);

@override
String toString() {
  return 'TranslationResult(sourceText: $sourceText, translatedText: $translatedText, direction: $direction, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TranslationResultCopyWith<$Res> implements $TranslationResultCopyWith<$Res> {
  factory _$TranslationResultCopyWith(_TranslationResult value, $Res Function(_TranslationResult) _then) = __$TranslationResultCopyWithImpl;
@override @useResult
$Res call({
 String sourceText, String translatedText, TranslationDirection direction, DateTime createdAt
});




}
/// @nodoc
class __$TranslationResultCopyWithImpl<$Res>
    implements _$TranslationResultCopyWith<$Res> {
  __$TranslationResultCopyWithImpl(this._self, this._then);

  final _TranslationResult _self;
  final $Res Function(_TranslationResult) _then;

/// Create a copy of TranslationResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sourceText = null,Object? translatedText = null,Object? direction = null,Object? createdAt = null,}) {
  return _then(_TranslationResult(
sourceText: null == sourceText ? _self.sourceText : sourceText // ignore: cast_nullable_to_non_nullable
as String,translatedText: null == translatedText ? _self.translatedText : translatedText // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TranslationDirection,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$TranslationState {

 String get inputText; String? get translatedText; TranslationDirection get direction; bool get isTranslating; String? get errorMessage; List<TranslationResult> get history;
/// Create a copy of TranslationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranslationStateCopyWith<TranslationState> get copyWith => _$TranslationStateCopyWithImpl<TranslationState>(this as TranslationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranslationState&&(identical(other.inputText, inputText) || other.inputText == inputText)&&(identical(other.translatedText, translatedText) || other.translatedText == translatedText)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.isTranslating, isTranslating) || other.isTranslating == isTranslating)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other.history, history));
}


@override
int get hashCode => Object.hash(runtimeType,inputText,translatedText,direction,isTranslating,errorMessage,const DeepCollectionEquality().hash(history));

@override
String toString() {
  return 'TranslationState(inputText: $inputText, translatedText: $translatedText, direction: $direction, isTranslating: $isTranslating, errorMessage: $errorMessage, history: $history)';
}


}

/// @nodoc
abstract mixin class $TranslationStateCopyWith<$Res>  {
  factory $TranslationStateCopyWith(TranslationState value, $Res Function(TranslationState) _then) = _$TranslationStateCopyWithImpl;
@useResult
$Res call({
 String inputText, String? translatedText, TranslationDirection direction, bool isTranslating, String? errorMessage, List<TranslationResult> history
});




}
/// @nodoc
class _$TranslationStateCopyWithImpl<$Res>
    implements $TranslationStateCopyWith<$Res> {
  _$TranslationStateCopyWithImpl(this._self, this._then);

  final TranslationState _self;
  final $Res Function(TranslationState) _then;

/// Create a copy of TranslationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inputText = null,Object? translatedText = freezed,Object? direction = null,Object? isTranslating = null,Object? errorMessage = freezed,Object? history = null,}) {
  return _then(_self.copyWith(
inputText: null == inputText ? _self.inputText : inputText // ignore: cast_nullable_to_non_nullable
as String,translatedText: freezed == translatedText ? _self.translatedText : translatedText // ignore: cast_nullable_to_non_nullable
as String?,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TranslationDirection,isTranslating: null == isTranslating ? _self.isTranslating : isTranslating // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<TranslationResult>,
  ));
}

}


/// Adds pattern-matching-related methods to [TranslationState].
extension TranslationStatePatterns on TranslationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranslationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranslationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranslationState value)  $default,){
final _that = this;
switch (_that) {
case _TranslationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranslationState value)?  $default,){
final _that = this;
switch (_that) {
case _TranslationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String inputText,  String? translatedText,  TranslationDirection direction,  bool isTranslating,  String? errorMessage,  List<TranslationResult> history)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranslationState() when $default != null:
return $default(_that.inputText,_that.translatedText,_that.direction,_that.isTranslating,_that.errorMessage,_that.history);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String inputText,  String? translatedText,  TranslationDirection direction,  bool isTranslating,  String? errorMessage,  List<TranslationResult> history)  $default,) {final _that = this;
switch (_that) {
case _TranslationState():
return $default(_that.inputText,_that.translatedText,_that.direction,_that.isTranslating,_that.errorMessage,_that.history);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String inputText,  String? translatedText,  TranslationDirection direction,  bool isTranslating,  String? errorMessage,  List<TranslationResult> history)?  $default,) {final _that = this;
switch (_that) {
case _TranslationState() when $default != null:
return $default(_that.inputText,_that.translatedText,_that.direction,_that.isTranslating,_that.errorMessage,_that.history);case _:
  return null;

}
}

}

/// @nodoc


class _TranslationState implements TranslationState {
  const _TranslationState({this.inputText = '', this.translatedText, this.direction = TranslationDirection.jaToKo, this.isTranslating = false, this.errorMessage, final  List<TranslationResult> history = const []}): _history = history;
  

@override@JsonKey() final  String inputText;
@override final  String? translatedText;
@override@JsonKey() final  TranslationDirection direction;
@override@JsonKey() final  bool isTranslating;
@override final  String? errorMessage;
 final  List<TranslationResult> _history;
@override@JsonKey() List<TranslationResult> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}


/// Create a copy of TranslationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranslationStateCopyWith<_TranslationState> get copyWith => __$TranslationStateCopyWithImpl<_TranslationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranslationState&&(identical(other.inputText, inputText) || other.inputText == inputText)&&(identical(other.translatedText, translatedText) || other.translatedText == translatedText)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.isTranslating, isTranslating) || other.isTranslating == isTranslating)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&const DeepCollectionEquality().equals(other._history, _history));
}


@override
int get hashCode => Object.hash(runtimeType,inputText,translatedText,direction,isTranslating,errorMessage,const DeepCollectionEquality().hash(_history));

@override
String toString() {
  return 'TranslationState(inputText: $inputText, translatedText: $translatedText, direction: $direction, isTranslating: $isTranslating, errorMessage: $errorMessage, history: $history)';
}


}

/// @nodoc
abstract mixin class _$TranslationStateCopyWith<$Res> implements $TranslationStateCopyWith<$Res> {
  factory _$TranslationStateCopyWith(_TranslationState value, $Res Function(_TranslationState) _then) = __$TranslationStateCopyWithImpl;
@override @useResult
$Res call({
 String inputText, String? translatedText, TranslationDirection direction, bool isTranslating, String? errorMessage, List<TranslationResult> history
});




}
/// @nodoc
class __$TranslationStateCopyWithImpl<$Res>
    implements _$TranslationStateCopyWith<$Res> {
  __$TranslationStateCopyWithImpl(this._self, this._then);

  final _TranslationState _self;
  final $Res Function(_TranslationState) _then;

/// Create a copy of TranslationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inputText = null,Object? translatedText = freezed,Object? direction = null,Object? isTranslating = null,Object? errorMessage = freezed,Object? history = null,}) {
  return _then(_TranslationState(
inputText: null == inputText ? _self.inputText : inputText // ignore: cast_nullable_to_non_nullable
as String,translatedText: freezed == translatedText ? _self.translatedText : translatedText // ignore: cast_nullable_to_non_nullable
as String?,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TranslationDirection,isTranslating: null == isTranslating ? _self.isTranslating : isTranslating // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<TranslationResult>,
  ));
}


}

// dart format on
