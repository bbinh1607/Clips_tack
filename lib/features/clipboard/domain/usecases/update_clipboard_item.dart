import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/clipboard_mutation_result.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/sort_clipboard_items.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UpdateClipboardItem {
  const UpdateClipboardItem(this._sortItems);

  final SortClipboardItems _sortItems;

  ClipboardMutationResult call({
    required String id,
    required String content,
    required List<ClipboardItem> currentItems,
  }) {
    final normalized = _normalize(content);
    if (normalized == null ||
        _containsDuplicate(currentItems, normalized, excludingId: id)) {
      return ClipboardMutationResult(didChange: false, items: currentItems);
    }

    var didUpdate = false;
    final nextItems = currentItems
        .map((item) {
          if (item.id != id) {
            return item;
          }

          didUpdate = true;
          return item.copyWith(content: normalized);
        })
        .toList(growable: false);

    if (!didUpdate) {
      return ClipboardMutationResult(didChange: false, items: currentItems);
    }

    return ClipboardMutationResult(
      didChange: true,
      items: _sortItems(nextItems),
    );
  }

  bool _containsDuplicate(
    List<ClipboardItem> items,
    String content, {
    required String excludingId,
  }) {
    return items.any(
      (item) => item.content == content && item.id != excludingId,
    );
  }

  String? _normalize(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
