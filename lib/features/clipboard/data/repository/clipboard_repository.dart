import 'package:clips_tack/features/clipboard/data/datasource/clipboard_local_data_source.dart';
import 'package:injectable/injectable.dart';

import '../../models/clipboard_item.dart';

@lazySingleton
class ClipboardRepository {
  ClipboardRepository(this._local);

  final ClipboardLocalDataSource _local;

  Future<List<ClipboardItem>> load() => _local.load();

  Future<void> save(List<ClipboardItem> items) => _local.save(items);
}
