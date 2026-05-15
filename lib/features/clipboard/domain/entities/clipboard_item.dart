import 'package:flutter/foundation.dart';

enum ClipKind { text, link, phone }

@immutable
class ClipboardItem {
  const ClipboardItem({
    required this.id,
    required this.content,
    required this.createdAt,
    this.isPinned = false,
  });

  final String id;
  final String content;
  final DateTime createdAt;
  final bool isPinned;

  ClipKind get kind => _detectKind(content);

  String get preview => content.replaceAll(RegExp(r'\s+'), ' ').trim();

  bool matchesQuery(String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return true;
    }

    return content.toLowerCase().contains(normalizedQuery);
  }

  ClipboardItem copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    bool? isPinned,
  }) {
    return ClipboardItem(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ClipboardItem &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            content == other.content &&
            createdAt == other.createdAt &&
            isPinned == other.isPinned;
  }

  @override
  int get hashCode => Object.hash(id, content, createdAt, isPinned);
}

ClipKind _detectKind(String value) {
  final trimmed = value.trim();

  if (RegExp(r'https?://', caseSensitive: false).hasMatch(trimmed)) {
    return ClipKind.link;
  }

  if (RegExp(r'(\+?\d[\d\s().-]{6,}\d)').hasMatch(trimmed)) {
    return ClipKind.phone;
  }

  return ClipKind.text;
}
