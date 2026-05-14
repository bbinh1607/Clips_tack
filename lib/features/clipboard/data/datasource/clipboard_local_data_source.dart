import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/clipboard_item.dart';

abstract class ClipboardLocalDataSource {
  Future<List<ClipboardItem>> load();
  Future<void> save(List<ClipboardItem> items);
}

@LazySingleton(as: ClipboardLocalDataSource)
class ClipboardLocalDataSourceImpl implements ClipboardLocalDataSource {
  static const _key = 'clips';

  @override
  Future<List<ClipboardItem>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) {
      return <ClipboardItem>[];
    }

    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is! List) {
        return <ClipboardItem>[];
      }

      return decoded
          .whereType<Map<String, dynamic>>()
          .map(ClipboardItem.fromJson)
          .toList(growable: false);
    } catch (_) {
      return <ClipboardItem>[];
    }
  }

  @override
  Future<void> save(List<ClipboardItem> items) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = jsonEncode(items.map((e) => e.toJson()).toList());

    await prefs.setString(_key, jsonString);
  }
}
