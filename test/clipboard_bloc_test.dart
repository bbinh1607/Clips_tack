import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:clips_tack/features/clipboard/domain/repositories/clipboard_repository.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/add_clipboard_item.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/clipboard_usecases.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/delete_clipboard_item.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/load_clipboard_items.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/read_clipboard_text.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/save_clipboard_items.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/sort_clipboard_items.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/toggle_clipboard_pin.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/update_clipboard_item.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/write_clipboard_text.dart';
import 'package:clips_tack/features/clipboard/presentation/bloc/clipboard_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('pins clips to the top and rejects duplicates', () async {
    final bloc = ClipboardBloc(
      useCases: _buildUseCases(_FakeClipboardRepository()),
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
      useCases: _buildUseCases(_FakeClipboardRepository()),
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

ClipboardUseCases _buildUseCases(ClipboardRepository repository) {
  final sortItems = SortClipboardItems();

  return ClipboardUseCases(
    LoadClipboardItems(repository, sortItems),
    SaveClipboardItems(repository),
    ReadClipboardText(repository),
    WriteClipboardText(repository),
    AddClipboardItem(sortItems),
    UpdateClipboardItem(sortItems),
    ToggleClipboardPin(sortItems),
    const DeleteClipboardItem(),
  );
}

class _FakeClipboardRepository implements ClipboardRepository {
  @override
  Future<String?> readClipboardText() async => null;

  @override
  Future<void> writeClipboardText(String text) async {}

  @override
  Future<List<ClipboardItem>> loadItems() async => <ClipboardItem>[];

  @override
  Future<void> saveItems(List<ClipboardItem> items) async {}
}
