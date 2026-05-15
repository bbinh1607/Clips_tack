import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/clipboard_mutation_result.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/sort_clipboard_items.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ToggleClipboardPin {
  const ToggleClipboardPin(this._sortItems);

  final SortClipboardItems _sortItems;

  ClipboardMutationResult call({
    required String id,
    required List<ClipboardItem> currentItems,
  }) {
    var didUpdate = false;
    final nextItems = currentItems
        .map((item) {
          if (item.id != id) {
            return item;
          }

          didUpdate = true;
          return item.copyWith(isPinned: !item.isPinned);
        })
        .toList(growable: false);

    return ClipboardMutationResult(
      didChange: didUpdate,
      items: didUpdate ? _sortItems(nextItems) : currentItems,
    );
  }
}
