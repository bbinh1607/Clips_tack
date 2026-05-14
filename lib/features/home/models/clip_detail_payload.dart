import 'dart:ui';

import 'package:clips_tack/features/clipboard/models/clipboard_item.dart';

class ClipDetailPayload {
  const ClipDetailPayload({required this.item, this.sourceRect});

  final ClipboardItem item;
  final Rect? sourceRect;
}
