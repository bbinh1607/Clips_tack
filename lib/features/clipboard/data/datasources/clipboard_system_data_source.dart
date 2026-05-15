import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';

abstract interface class ClipboardSystemDataSource {
  Future<String?> readText();
  Future<void> writeText(String text);
}

@LazySingleton(as: ClipboardSystemDataSource)
class ClipboardSystemDataSourceImpl implements ClipboardSystemDataSource {
  @override
  Future<String?> readText() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }

  @override
  Future<void> writeText(String text) {
    return Clipboard.setData(ClipboardData(text: text));
  }
}
