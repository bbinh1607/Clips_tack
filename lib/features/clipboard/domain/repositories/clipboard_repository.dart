import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';

abstract interface class ClipboardRepository {
  Future<List<ClipboardItem>> loadItems();
  Future<void> saveItems(List<ClipboardItem> items);
  Future<String?> readClipboardText();
  Future<void> writeClipboardText(String text);
}
