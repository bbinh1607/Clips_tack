import 'package:clips_tack/features/clipboard/data/datasources/clipboard_local_data_source.dart';
import 'package:clips_tack/features/clipboard/data/datasources/clipboard_system_data_source.dart';
import 'package:clips_tack/features/clipboard/data/models/clipboard_item_model.dart';
import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:clips_tack/features/clipboard/domain/repositories/clipboard_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ClipboardRepository)
class ClipboardRepositoryImpl implements ClipboardRepository {
  const ClipboardRepositoryImpl(this._localDataSource, this._systemDataSource);

  final ClipboardLocalDataSource _localDataSource;
  final ClipboardSystemDataSource _systemDataSource;

  @override
  Future<List<ClipboardItem>> loadItems() async {
    final models = await _localDataSource.loadItems();
    return models.map((model) => model.toEntity()).toList(growable: false);
  }

  @override
  Future<void> saveItems(List<ClipboardItem> items) {
    final models = items.map(ClipboardItemModel.fromEntity).toList();
    return _localDataSource.saveItems(models);
  }

  @override
  Future<String?> readClipboardText() {
    return _systemDataSource.readText();
  }

  @override
  Future<void> writeClipboardText(String text) {
    return _systemDataSource.writeText(text);
  }
}
