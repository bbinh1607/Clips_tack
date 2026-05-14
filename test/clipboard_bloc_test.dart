import 'package:clips_tack/features/clipboard/data/services/clipboard_service.dart';
import 'package:clips_tack/features/clipboard/models/clipboard_item.dart';
import 'package:clips_tack/features/clipboard/presentation/bloc/clipboard_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('pins clips to the top and rejects duplicates', () async {
    final bloc = ClipboardBloc(
      clipboardService: _FakeClipboardService(),
      enableClipboardTracking: false,
    );
    addTearDown(bloc.close);

    expect(await bloc.addClip('Call +1 202 555 0199'), isTrue);
    expect(await bloc.addClip('https://openai.com'), isTrue);
    expect(await bloc.addClip('https://openai.com'), isFalse);

    final phoneId = bloc.state.items
        .firstWhere((item) => item.content.contains('+1 202 555 0199'))
        .id;

    bloc.togglePin(phoneId);
    await pumpEventQueue();

    expect(bloc.state.items.first.content, 'Call +1 202 555 0199');
    expect(bloc.state.items.first.isPinned, isTrue);
  });

  test('editing rejects duplicate content from another clip', () async {
    final bloc = ClipboardBloc(
      clipboardService: _FakeClipboardService(),
      enableClipboardTracking: false,
    );
    addTearDown(bloc.close);

    await bloc.addClip('Morning standup at 10');
    await bloc.addClip('https://flutter.dev');

    final noteId = bloc.state.items
        .firstWhere((item) => item.content == 'Morning standup at 10')
        .id;

    expect(
      await bloc.updateClip(id: noteId, content: 'https://flutter.dev'),
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
  Future<List<ClipboardItem>> loadLocal() async => <ClipboardItem>[];

  @override
  Future<void> saveLocal(List<ClipboardItem> items) async {}
}
