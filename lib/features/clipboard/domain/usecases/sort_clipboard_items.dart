import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SortClipboardItems {
  List<ClipboardItem> call(List<ClipboardItem> items) {
    final sorted = [...items];

    sorted.sort((a, b) {
      if (a.isPinned != b.isPinned) {
        return a.isPinned ? -1 : 1;
      }
      return b.createdAt.compareTo(a.createdAt);
    });

    return sorted;
  }
}
