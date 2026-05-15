import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/features/clipboard/domain/entities/clipboard_item.dart';
import 'package:clips_tack/features/clipboard/domain/usecases/clipboard_usecases.dart';
import 'package:injectable/injectable.dart';

import 'clipboard_state.dart';
export 'clipboard_state.dart';

part 'clipboard_event.dart';

@injectable
class ClipboardBloc extends Bloc<ClipboardEvent, ClipboardState> {
  @factoryMethod
  ClipboardBloc.create(ClipboardUseCases useCases) : this(useCases: useCases);

  ClipboardBloc({
    required ClipboardUseCases useCases,
    this.pollInterval = AppDuration.clipboardPolling,
    this.enableClipboardTracking = true,
  }) : _useCases = useCases,
       super(const ClipboardState()) {
    on<ClipboardStarted>(_onStarted);
    on<ClipboardSearchChanged>(_onSearchChanged);
    on<ClipboardDraftRequested>(_onDraftRequested);
    on<ClipboardClipCopied>(_onClipCopied);
    on<ClipboardClipAdded>(_onClipAdded);
    on<ClipboardClipUpdated>(_onClipUpdated);
    on<ClipboardClipPinToggled>(_onClipPinToggled);
    on<ClipboardClipDeleted>(_onClipDeleted);
    on<_ClipboardExternalTextObserved>(_onExternalTextObserved);

    add(const ClipboardStarted());

    if (enableClipboardTracking) {
      _startTracking();
    }
  }

  final ClipboardUseCases _useCases;
  final Duration pollInterval;
  final bool enableClipboardTracking;

  Timer? _poller;
  String? _lastObservedClipboard;

  void setSearchQuery(String value) {
    add(ClipboardSearchChanged(value));
  }

  Future<String?> loadClipboardDraft() {
    final completer = Completer<String?>();
    add(ClipboardDraftRequested(completer));
    return completer.future;
  }

  Future<void> copyClip(ClipboardItem item) {
    final completer = Completer<void>();
    add(ClipboardClipCopied(item: item, completer: completer));
    return completer.future;
  }

  Future<bool> addClip(String content) {
    final completer = Completer<bool>();
    add(ClipboardClipAdded(content: content, completer: completer));
    return completer.future;
  }

  Future<bool> updateClip({required String id, required String content}) {
    final completer = Completer<bool>();
    add(ClipboardClipUpdated(id: id, content: content, completer: completer));
    return completer.future;
  }

  void togglePin(String id) {
    add(ClipboardClipPinToggled(id));
  }

  void deleteClip(String id) {
    add(ClipboardClipDeleted(id));
  }

  Future<void> _onStarted(
    ClipboardStarted event,
    Emitter<ClipboardState> emit,
  ) async {
    try {
      final items = await _useCases.loadItems();
      emit(state.copyWith(items: items));
    } catch (_) {}
  }

  void _onSearchChanged(
    ClipboardSearchChanged event,
    Emitter<ClipboardState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _onDraftRequested(
    ClipboardDraftRequested event,
    Emitter<ClipboardState> emit,
  ) async {
    try {
      event.completer.complete(_normalize(await _useCases.readClipboardText()));
    } catch (_) {
      event.completer.complete(null);
    }
  }

  Future<void> _onClipCopied(
    ClipboardClipCopied event,
    Emitter<ClipboardState> emit,
  ) async {
    final normalized = _normalize(event.item.content);

    if (normalized == null) {
      event.completer.complete();
      return;
    }

    try {
      await _useCases.writeClipboardText(normalized);
      _lastObservedClipboard = normalized;
      event.completer.complete();
    } catch (error, stackTrace) {
      event.completer.completeError(error, stackTrace);
    }
  }

  void _onClipAdded(ClipboardClipAdded event, Emitter<ClipboardState> emit) {
    final result = _useCases.addItem(
      content: event.content,
      currentItems: state.items,
    );

    if (result.didChange) {
      emit(state.copyWith(items: result.items));
      _persist(result.items);
    }

    event.completer.complete(result.didChange);
  }

  void _onClipUpdated(
    ClipboardClipUpdated event,
    Emitter<ClipboardState> emit,
  ) {
    final result = _useCases.updateItem(
      id: event.id,
      content: event.content,
      currentItems: state.items,
    );

    if (result.didChange) {
      emit(state.copyWith(items: result.items));
      _persist(result.items);
    }

    event.completer.complete(result.didChange);
  }

  void _onClipPinToggled(
    ClipboardClipPinToggled event,
    Emitter<ClipboardState> emit,
  ) {
    final result = _useCases.togglePin(id: event.id, currentItems: state.items);

    if (result.didChange) {
      emit(state.copyWith(items: result.items));
      _persist(result.items);
    }
  }

  void _onClipDeleted(
    ClipboardClipDeleted event,
    Emitter<ClipboardState> emit,
  ) {
    final result = _useCases.deleteItem(
      id: event.id,
      currentItems: state.items,
    );

    if (result.didChange) {
      emit(state.copyWith(items: result.items));
      _persist(result.items);
    }
  }

  void _onExternalTextObserved(
    _ClipboardExternalTextObserved event,
    Emitter<ClipboardState> emit,
  ) {
    _lastObservedClipboard = event.content;
    final result = _useCases.addItem(
      content: event.content,
      currentItems: state.items,
    );

    if (result.didChange) {
      emit(state.copyWith(items: result.items));
      _persist(result.items);
    }
  }

  void _startTracking() {
    unawaited(_syncClipboard());

    _poller = Timer.periodic(pollInterval, (_) {
      unawaited(_syncClipboard());
    });
  }

  Future<void> _syncClipboard() async {
    try {
      final normalized = _normalize(await _useCases.readClipboardText());

      if (normalized == null || normalized == _lastObservedClipboard) {
        return;
      }

      if (!isClosed) {
        add(_ClipboardExternalTextObserved(normalized));
      }
    } catch (_) {}
  }

  void _persist(List<ClipboardItem> items) {
    unawaited(_useCases.saveItems(items).catchError((_) {}));
  }

  String? _normalize(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  @override
  Future<void> close() {
    _poller?.cancel();
    return super.close();
  }
}
