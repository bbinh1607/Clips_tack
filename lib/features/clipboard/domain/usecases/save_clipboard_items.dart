import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:clips_tack/features/clipboard/domain/repositories/clipboard_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SaveClipboardItems {
  const SaveClipboardItems(this._repository);

  final ClipboardRepository _repository;

  Future<void> call(List<ClipboardItem> items) {
    return _repository.saveItems(items);
  }
}
