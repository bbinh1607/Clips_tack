import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/clipboard_mutation_result.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteClipboardItem {
  const DeleteClipboardItem();

  ClipboardMutationResult call({
    required String id,
    required List<ClipboardItem> currentItems,
  }) {
    final nextItems = currentItems
        .where((item) => item.id != id)
        .toList(growable: false);

    return ClipboardMutationResult(
      didChange: nextItems.length != currentItems.length,
      items: nextItems,
    );
  }
}
