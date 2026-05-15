import 'package:clips_tack/features/clipboard/domain/repositories/clipboard_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ReadClipboardText {
  const ReadClipboardText(this._repository);

  final ClipboardRepository _repository;

  Future<String?> call() {
    return _repository.readClipboardText();
  }
}
