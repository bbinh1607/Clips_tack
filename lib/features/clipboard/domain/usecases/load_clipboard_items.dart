import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:clips_tack/features/clipboard/domain/repositories/clipboard_repository.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/sort_clipboard_items.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LoadClipboardItems {
  const LoadClipboardItems(this._repository, this._sortItems);

  final ClipboardRepository _repository;
  final SortClipboardItems _sortItems;

  Future<List<ClipboardItem>> call() async {
    return _sortItems(await _repository.loadItems());
  }
}
