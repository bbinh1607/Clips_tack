import 'package:clips_tack/features/clipboard/domain/usecases/add_clipboard_item.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/delete_clipboard_item.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/load_clipboard_items.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/read_clipboard_text.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/save_clipboard_items.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/toggle_clipboard_pin.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/update_clipboard_item.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/write_clipboard_text.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ClipboardUseCases {
  const ClipboardUseCases(
    this.loadItems,
    this.saveItems,
    this.readClipboardText,
    this.writeClipboardText,
    this.addItem,
    this.updateItem,
    this.togglePin,
    this.deleteItem,
  );

  final LoadClipboardItems loadItems;
  final SaveClipboardItems saveItems;
  final ReadClipboardText readClipboardText;
  final WriteClipboardText writeClipboardText;
  final AddClipboardItem addItem;
  final UpdateClipboardItem updateItem;
  final ToggleClipboardPin togglePin;
  final DeleteClipboardItem deleteItem;
}
