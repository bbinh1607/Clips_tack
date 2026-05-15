import 'dart:convert';

import 'package:clips_tack/core/platform/mobile_shortcut_channel.dart';
import 'package:clips_tack/features/clipboard/data/models/clipboard_item_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class ClipboardLocalDataSource {
  Future<List<ClipboardItemModel>> loadItems();
  Future<void> saveItems(List<ClipboardItemModel> items);
}

@LazySingleton(as: ClipboardLocalDataSource)
class ClipboardLocalDataSourceImpl implements ClipboardLocalDataSource {
  static const _key = 'clips';

  @override
  Future<List<ClipboardItemModel>> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) {
      return <ClipboardItemModel>[];
    }

    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is! List) {
        return <ClipboardItemModel>[];
      }

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(ClipboardItemModel.fromJson)
          .toList(growable: false);
    } catch (_) {
      return <ClipboardItemModel>[];
    }
  }

  @override
  Future<void> saveItems(List<ClipboardItemModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(items.map((item) => item.toJson()).toList());

    await prefs.setString(_key, jsonString);
    try {
      await MobileShortcutChannel.updateWidgets();
    } catch (_) {}
  }
}
