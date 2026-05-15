import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';

class ClipboardMutationResult {
  const ClipboardMutationResult({required this.didChange, required this.items});

  final bool didChange;
  final List<ClipboardItem> items;
}
