import 'package:clips_tack/features/clipboard/domain/repositories/clipboard_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class WriteClipboardText {
  const WriteClipboardText(this._repository);

  final ClipboardRepository _repository;

  Future<void> call(String text) {
    return _repository.writeClipboardText(text);
  }
}
