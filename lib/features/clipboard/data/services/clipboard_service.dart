import 'package:clips_tack/features/clipboard/data/repository/clipboard_repository.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

import '../../models/clipboard_item.dart';

abstract interface class ClipboardService {
  Future<String?> readText();
  Future<void> writeText(String text);

  Future<List<ClipboardItem>> loadLocal();
  Future<void> saveLocal(List<ClipboardItem> items);
}

@LazySingleton(as: ClipboardService)
class SystemClipboardService implements ClipboardService {
  SystemClipboardService(this._repository);

  final ClipboardRepository _repository;

  // 🔹 SYSTEM CLIPBOARD
  @override
  Future<String?> readText() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }

  @override
  Future<void> writeText(String text) {
    return Clipboard.setData(ClipboardData(text: text));
  }

  // 🔹 LOCAL STORAGE (qua repository)
  @override
  Future<List<ClipboardItem>> loadLocal() {
    return _repository.load();
  }

  @override
  Future<void> saveLocal(List<ClipboardItem> items) {
    return _repository.save(items);
  }
}
