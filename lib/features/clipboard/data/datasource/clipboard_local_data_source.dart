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

    if (jsonString == null) return [];

    final List decoded = jsonDecode(jsonString);

    return decoded.map((e) => ClipboardItem.fromJson(e)).toList();
  }

  @override
  Future<void> save(List<ClipboardItem> items) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = jsonEncode(items.map((e) => e.toJson()).toList());

    await prefs.setString(_key, jsonString);
  }
}
