// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clipboard_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClipboardState {

 List<ClipboardItem> get items; String get searchQuery;
/// Create a copy of ClipboardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClipboardStateCopyWith<ClipboardState> get copyWith => _$ClipboardStateCopyWithImpl<ClipboardState>(this as ClipboardState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClipboardState&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),searchQuery);

@override
String toString() {
  return 'ClipboardState(items: $items, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class $ClipboardStateCopyWith<$Res>  {
  factory $ClipboardStateCopyWith(ClipboardState value, $Res Function(ClipboardState) _then) = _$ClipboardStateCopyWithImpl;
@useResult
$Res call({
 List<ClipboardItem> items, String searchQuery
});




}
/// @nodoc
class _$ClipboardStateCopyWithImpl<$Res>
    implements $ClipboardStateCopyWith<$Res> {
  _$ClipboardStateCopyWithImpl(this._self, this._then);

  final ClipboardState _self;
  final $Res Function(ClipboardState) _then;

/// Create a copy of ClipboardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? searchQuery = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ClipboardItem>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ClipboardState].
extension ClipboardStatePatterns on ClipboardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClipboardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClipboardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClipboardState value)  $default,){
final _that = this;
switch (_that) {
case _ClipboardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClipboardState value)?  $default,){
final _that = this;
switch (_that) {
case _ClipboardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ClipboardItem> items,  String searchQuery)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClipboardState() when $default != null:
return $default(_that.items,_that.searchQuery);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ClipboardItem> items,  String searchQuery)  $default,) {final _that = this;
switch (_that) {
case _ClipboardState():
return $default(_that.items,_that.searchQuery);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ClipboardItem> items,  String searchQuery)?  $default,) {final _that = this;
switch (_that) {
case _ClipboardState() when $default != null:
return $default(_that.items,_that.searchQuery);case _:
  return null;

}
}

}

/// @nodoc


class _ClipboardState extends ClipboardState {
  const _ClipboardState({final  List<ClipboardItem> items = const <ClipboardItem>[], this.searchQuery = ''}): _items = items,super._();
  

 final  List<ClipboardItem> _items;
@override@JsonKey() List<ClipboardItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  String searchQuery;

/// Create a copy of ClipboardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClipboardStateCopyWith<_ClipboardState> get copyWith => __$ClipboardStateCopyWithImpl<_ClipboardState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClipboardState&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),searchQuery);

@override
String toString() {
  return 'ClipboardState(items: $items, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class _$ClipboardStateCopyWith<$Res> implements $ClipboardStateCopyWith<$Res> {
  factory _$ClipboardStateCopyWith(_ClipboardState value, $Res Function(_ClipboardState) _then) = __$ClipboardStateCopyWithImpl;
@override @useResult
$Res call({
 List<ClipboardItem> items, String searchQuery
});




}
/// @nodoc
class __$ClipboardStateCopyWithImpl<$Res>
    implements _$ClipboardStateCopyWith<$Res> {
  __$ClipboardStateCopyWithImpl(this._self, this._then);

  final _ClipboardState _self;
  final $Res Function(_ClipboardState) _then;

/// Create a copy of ClipboardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? searchQuery = null,}) {
  return _then(_ClipboardState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ClipboardItem>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
