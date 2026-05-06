// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clip_editor_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClipEditorPayload {

 String? get clipId; String get initialContent;
/// Create a copy of ClipEditorPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClipEditorPayloadCopyWith<ClipEditorPayload> get copyWith => _$ClipEditorPayloadCopyWithImpl<ClipEditorPayload>(this as ClipEditorPayload, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClipEditorPayload&&(identical(other.clipId, clipId) || other.clipId == clipId)&&(identical(other.initialContent, initialContent) || other.initialContent == initialContent));
}


@override
int get hashCode => Object.hash(runtimeType,clipId,initialContent);

@override
String toString() {
  return 'ClipEditorPayload(clipId: $clipId, initialContent: $initialContent)';
}


}

/// @nodoc
abstract mixin class $ClipEditorPayloadCopyWith<$Res>  {
  factory $ClipEditorPayloadCopyWith(ClipEditorPayload value, $Res Function(ClipEditorPayload) _then) = _$ClipEditorPayloadCopyWithImpl;
@useResult
$Res call({
 String? clipId, String initialContent
});




}
/// @nodoc
class _$ClipEditorPayloadCopyWithImpl<$Res>
    implements $ClipEditorPayloadCopyWith<$Res> {
  _$ClipEditorPayloadCopyWithImpl(this._self, this._then);

  final ClipEditorPayload _self;
  final $Res Function(ClipEditorPayload) _then;

/// Create a copy of ClipEditorPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clipId = freezed,Object? initialContent = null,}) {
  return _then(_self.copyWith(
clipId: freezed == clipId ? _self.clipId : clipId // ignore: cast_nullable_to_non_nullable
as String?,initialContent: null == initialContent ? _self.initialContent : initialContent // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ClipEditorPayload].
extension ClipEditorPayloadPatterns on ClipEditorPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClipEditorPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClipEditorPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClipEditorPayload value)  $default,){
final _that = this;
switch (_that) {
case _ClipEditorPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClipEditorPayload value)?  $default,){
final _that = this;
switch (_that) {
case _ClipEditorPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? clipId,  String initialContent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClipEditorPayload() when $default != null:
return $default(_that.clipId,_that.initialContent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? clipId,  String initialContent)  $default,) {final _that = this;
switch (_that) {
case _ClipEditorPayload():
return $default(_that.clipId,_that.initialContent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? clipId,  String initialContent)?  $default,) {final _that = this;
switch (_that) {
case _ClipEditorPayload() when $default != null:
return $default(_that.clipId,_that.initialContent);case _:
  return null;

}
}

}

/// @nodoc


class _ClipEditorPayload implements ClipEditorPayload {
  const _ClipEditorPayload({this.clipId, this.initialContent = ''});
  

@override final  String? clipId;
@override@JsonKey() final  String initialContent;

/// Create a copy of ClipEditorPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClipEditorPayloadCopyWith<_ClipEditorPayload> get copyWith => __$ClipEditorPayloadCopyWithImpl<_ClipEditorPayload>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClipEditorPayload&&(identical(other.clipId, clipId) || other.clipId == clipId)&&(identical(other.initialContent, initialContent) || other.initialContent == initialContent));
}


@override
int get hashCode => Object.hash(runtimeType,clipId,initialContent);

@override
String toString() {
  return 'ClipEditorPayload(clipId: $clipId, initialContent: $initialContent)';
}


}

/// @nodoc
abstract mixin class _$ClipEditorPayloadCopyWith<$Res> implements $ClipEditorPayloadCopyWith<$Res> {
  factory _$ClipEditorPayloadCopyWith(_ClipEditorPayload value, $Res Function(_ClipEditorPayload) _then) = __$ClipEditorPayloadCopyWithImpl;
@override @useResult
$Res call({
 String? clipId, String initialContent
});




}
/// @nodoc
class __$ClipEditorPayloadCopyWithImpl<$Res>
    implements _$ClipEditorPayloadCopyWith<$Res> {
  __$ClipEditorPayloadCopyWithImpl(this._self, this._then);

  final _ClipEditorPayload _self;
  final $Res Function(_ClipEditorPayload) _then;

/// Create a copy of ClipEditorPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clipId = freezed,Object? initialContent = null,}) {
  return _then(_ClipEditorPayload(
clipId: freezed == clipId ? _self.clipId : clipId // ignore: cast_nullable_to_non_nullable
as String?,initialContent: null == initialContent ? _self.initialContent : initialContent // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
