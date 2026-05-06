import 'package:freezed_annotation/freezed_annotation.dart';

part 'clipboard_item.freezed.dart';
part 'clipboard_item.g.dart';

enum ClipKind { text, link, phone }

@freezed
abstract class ClipboardItem with _$ClipboardItem {
  const ClipboardItem._();

  const factory ClipboardItem({
    required String id,
    required String content,
    required DateTime createdAt,
    @Default(false) bool isPinned,
  }) = _ClipboardItem;

  factory ClipboardItem.fromJson(Map<String, dynamic> json) =>
      _$ClipboardItemFromJson(json);

  ClipKind get kind => _detectKind(content);

  String get preview => content.replaceAll(RegExp(r'\s+'), ' ').trim();

  bool matchesQuery(String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return true;
    }

    return content.toLowerCase().contains(normalizedQuery);
  }
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
