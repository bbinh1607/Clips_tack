import 'package:clips_tack/app/app.dart';
import 'package:clips_tack/core/di/injection.dart';
import 'package:clips_tack/features/clipboard/data/services/clipboard_service.dart';
import 'package:clips_tack/features/clipboard/models/clipboard_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() async {
    await getIt.reset();
    await configureDependencies();
    getIt
      ..unregister<ClipboardService>()
      ..registerLazySingleton<ClipboardService>(_FakeClipboardService.new);
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('renders ClipStack home chrome', (WidgetTester tester) async {
    await tester.pumpWidget(const ClipStackApp());
    await tester.pumpAndSettle();

    expect(find.text('ClipStack'), findsOneWidget);
    expect(find.text('Search clipboard...'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.byIcon(Icons.content_paste_rounded), findsOneWidget);
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
