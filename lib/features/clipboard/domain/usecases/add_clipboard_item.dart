import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/clipboard_mutation_result.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/sort_clipboard_items.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AddClipboardItem {
  const AddClipboardItem(this._sortItems);

  final SortClipboardItems _sortItems;

  ClipboardMutationResult call({
    required String content,
    required List<ClipboardItem> currentItems,
  }) {
    final normalized = _normalize(content);
    if (normalized == null || _containsDuplicate(currentItems, normalized)) {
      return ClipboardMutationResult(didChange: false, items: currentItems);
    }

    final now = DateTime.now();
    final nextItems = _sortItems([
      ClipboardItem(
        id: '${now.microsecondsSinceEpoch}-${normalized.hashCode}',
        content: normalized,
        createdAt: now,
      ),
      ...currentItems,
    ]);

    return ClipboardMutationResult(didChange: true, items: nextItems);
  }

  bool _containsDuplicate(List<ClipboardItem> items, String content) {
    return items.any((item) => item.content == content);
  }

  String? _normalize(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
