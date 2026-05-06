// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clipboard_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClipboardItem {

 String get id; String get content; DateTime get createdAt; bool get isPinned;
/// Create a copy of ClipboardItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClipboardItemCopyWith<ClipboardItem> get copyWith => _$ClipboardItemCopyWithImpl<ClipboardItem>(this as ClipboardItem, _$identity);

  /// Serializes this ClipboardItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClipboardItem&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,createdAt,isPinned);

@override
String toString() {
  return 'ClipboardItem(id: $id, content: $content, createdAt: $createdAt, isPinned: $isPinned)';
}


}

/// @nodoc
abstract mixin class $ClipboardItemCopyWith<$Res>  {
  factory $ClipboardItemCopyWith(ClipboardItem value, $Res Function(ClipboardItem) _then) = _$ClipboardItemCopyWithImpl;
@useResult
$Res call({
 String id, String content, DateTime createdAt, bool isPinned
});




}
/// @nodoc
class _$ClipboardItemCopyWithImpl<$Res>
    implements $ClipboardItemCopyWith<$Res> {
  _$ClipboardItemCopyWithImpl(this._self, this._then);

  final ClipboardItem _self;
  final $Res Function(ClipboardItem) _then;

/// Create a copy of ClipboardItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? content = null,Object? createdAt = null,Object? isPinned = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ClipboardItem].
extension ClipboardItemPatterns on ClipboardItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClipboardItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClipboardItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClipboardItem value)  $default,){
final _that = this;
switch (_that) {
case _ClipboardItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClipboardItem value)?  $default,){
final _that = this;
switch (_that) {
case _ClipboardItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String content,  DateTime createdAt,  bool isPinned)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClipboardItem() when $default != null:
return $default(_that.id,_that.content,_that.createdAt,_that.isPinned);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String content,  DateTime createdAt,  bool isPinned)  $default,) {final _that = this;
switch (_that) {
case _ClipboardItem():
return $default(_that.id,_that.content,_that.createdAt,_that.isPinned);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String content,  DateTime createdAt,  bool isPinned)?  $default,) {final _that = this;
switch (_that) {
case _ClipboardItem() when $default != null:
return $default(_that.id,_that.content,_that.createdAt,_that.isPinned);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClipboardItem extends ClipboardItem {
  const _ClipboardItem({required this.id, required this.content, required this.createdAt, this.isPinned = false}): super._();
  factory _ClipboardItem.fromJson(Map<String, dynamic> json) => _$ClipboardItemFromJson(json);

@override final  String id;
@override final  String content;
@override final  DateTime createdAt;
@override@JsonKey() final  bool isPinned;

/// Create a copy of ClipboardItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClipboardItemCopyWith<_ClipboardItem> get copyWith => __$ClipboardItemCopyWithImpl<_ClipboardItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClipboardItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClipboardItem&&(identical(other.id, id) || other.id == id)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isPinned, isPinned) || other.isPinned == isPinned));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,content,createdAt,isPinned);

@override
String toString() {
  return 'ClipboardItem(id: $id, content: $content, createdAt: $createdAt, isPinned: $isPinned)';
}


}

/// @nodoc
abstract mixin class _$ClipboardItemCopyWith<$Res> implements $ClipboardItemCopyWith<$Res> {
  factory _$ClipboardItemCopyWith(_ClipboardItem value, $Res Function(_ClipboardItem) _then) = __$ClipboardItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String content, DateTime createdAt, bool isPinned
});




}
/// @nodoc
class __$ClipboardItemCopyWithImpl<$Res>
    implements _$ClipboardItemCopyWith<$Res> {
  __$ClipboardItemCopyWithImpl(this._self, this._then);

  final _ClipboardItem _self;
  final $Res Function(_ClipboardItem) _then;

/// Create a copy of ClipboardItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? content = null,Object? createdAt = null,Object? isPinned = null,}) {
  return _then(_ClipboardItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isPinned: null == isPinned ? _self.isPinned : isPinned // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
