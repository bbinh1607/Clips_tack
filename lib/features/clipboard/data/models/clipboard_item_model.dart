import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';

class ClipboardItemModel extends ClipboardItem {
  const ClipboardItemModel({
    required super.id,
    required super.content,
    required super.createdAt,
    super.isPinned,
  });

  factory ClipboardItemModel.fromEntity(ClipboardItem item) {
    return ClipboardItemModel(
      id: item.id,
      content: item.content,
      createdAt: item.createdAt,
      isPinned: item.isPinned,
    );
  }

  factory ClipboardItemModel.fromJson(Map<String, dynamic> json) {
    return ClipboardItemModel(
      id: json['id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isPinned: json['isPinned'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'isPinned': isPinned,
    };
  }

  ClipboardItem toEntity() {
    return ClipboardItem(
      id: id,
      content: content,
      createdAt: createdAt,
      isPinned: isPinned,
    );
  }
}
