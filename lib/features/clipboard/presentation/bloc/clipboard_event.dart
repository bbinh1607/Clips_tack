part of 'clipboard_bloc.dart';

sealed class ClipboardEvent {
  const ClipboardEvent();
}

final class ClipboardStarted extends ClipboardEvent {
  const ClipboardStarted();
}

final class ClipboardSearchChanged extends ClipboardEvent {
  const ClipboardSearchChanged(this.query);

  final String query;
}

final class ClipboardDraftRequested extends ClipboardEvent {
  const ClipboardDraftRequested(this.completer);

  final Completer<String?> completer;
}

final class ClipboardClipCopied extends ClipboardEvent {
  const ClipboardClipCopied({required this.item, required this.completer});

  final ClipboardItem item;
  final Completer<void> completer;
}

final class ClipboardClipAdded extends ClipboardEvent {
  const ClipboardClipAdded({required this.content, required this.completer});

  final String content;
  final Completer<bool> completer;
}

final class ClipboardClipUpdated extends ClipboardEvent {
  const ClipboardClipUpdated({
    required this.id,
    required this.content,
    required this.completer,
  });

  final String id;
  final String content;
  final Completer<bool> completer;
}

final class ClipboardClipPinToggled extends ClipboardEvent {
  const ClipboardClipPinToggled(this.id);

  final String id;
}

final class ClipboardClipDeleted extends ClipboardEvent {
  const ClipboardClipDeleted(this.id);

  final String id;
}

final class _ClipboardExternalTextObserved extends ClipboardEvent {
  const _ClipboardExternalTextObserved(this.content);

  final String content;
}
