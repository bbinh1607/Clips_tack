// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clipboard_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClipboardItem _$ClipboardItemFromJson(Map<String, dynamic> json) =>
    _ClipboardItem(
      id: json['id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isPinned: json['isPinned'] as bool? ?? false,
    );

Map<String, dynamic> _$ClipboardItemToJson(_ClipboardItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'isPinned': instance.isPinned,
    };
