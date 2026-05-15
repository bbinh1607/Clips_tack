import 'dart:ui';

import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';

class ClipDetailPayload {
  const ClipDetailPayload({
    required this.item,
    this.sourceRect,
    this.items = const <ClipboardItem>[],
  });

  final ClipboardItem item;
  final Rect? sourceRect;
  final List<ClipboardItem> items;
}
