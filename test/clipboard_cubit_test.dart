import 'package:clips_tack/features/clipboard/cubit/clipboard_cubit.dart';
import 'package:clips_tack/features/clipboard/data/services/clipboard_service.dart';
import 'package:clips_tack/features/clipboard/models/clipboard_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('pins clips to the top and rejects duplicates', () {
    final cubit = ClipboardCubit(
      clipboardService: _FakeClipboardService(),
      enableClipboardTracking: false,
    );
    addTearDown(cubit.close);

    expect(cubit.addClip('Call +1 202 555 0199'), isTrue);
    expect(cubit.addClip('https://openai.com'), isTrue);
    expect(cubit.addClip('https://openai.com'), isFalse);

    final phoneId = cubit.state.items
        .firstWhere((item) => item.content.contains('+1 202 555 0199'))
        .id;

    cubit.togglePin(phoneId);

    expect(cubit.state.items.first.content, 'Call +1 202 555 0199');
    expect(cubit.state.items.first.isPinned, isTrue);
  });

  test('editing rejects duplicate content from another clip', () {
    final cubit = ClipboardCubit(
      clipboardService: _FakeClipboardService(),
      enableClipboardTracking: false,
    );
    addTearDown(cubit.close);

    cubit.addClip('Morning standup at 10');
    cubit.addClip('https://flutter.dev');

    final noteId = cubit.state.items
        .firstWhere((item) => item.content == 'Morning standup at 10')
        .id;

    expect(
      cubit.updateClip(id: noteId, content: 'https://flutter.dev'),
      isFalse,
    );
  });
}

class _FakeClipboardService implements ClipboardService {
  @override
  Future<String?> readText() async => null;

  @override
  Future<void> writeText(String text) async {}

  @override
  Future<List<ClipboardItem>> loadLocal() {
    // TODO: implement loadLocal
    throw UnimplementedError();
  }

  @override
  Future<void> saveLocal(List<ClipboardItem> items) {
    // TODO: implement saveLocal
    throw UnimplementedError();
  }
}
