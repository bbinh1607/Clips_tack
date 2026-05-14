import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/features/clipboard/data/services/clipboard_service.dart';
import 'package:clips_tack/features/clipboard/models/clipboard_item.dart';
import 'package:injectable/injectable.dart';

import 'clipboard_state.dart';
export 'clipboard_state.dart';

part 'clipboard_event.dart';

@injectable
class ClipboardBloc extends Bloc<ClipboardEvent, ClipboardState> {
  @factoryMethod
  ClipboardBloc.create(ClipboardService clipboardService)
    : this(clipboardService: clipboardService);

  ClipboardBloc({
    required ClipboardService clipboardService,
    this.pollInterval = AppDuration.clipboardPolling,
    this.enableClipboardTracking = true,
  }) : _clipboardService = clipboardService,
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

  final ClipboardService _clipboardService;
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
      final items = await _clipboardService.loadLocal();
      emit(state.copyWith(items: _sort(items)));
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
      event.completer.complete(_normalize(await _clipboardService.readText()));
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
      await _clipboardService.writeText(normalized);
      _lastObservedClipboard = normalized;
      event.completer.complete();
    } catch (error, stackTrace) {
      event.completer.completeError(error, stackTrace);
    }
  }

  void _onClipAdded(ClipboardClipAdded event, Emitter<ClipboardState> emit) {
    event.completer.complete(_addNormalizedClip(event.content, emit));
  }

  void _onClipUpdated(
    ClipboardClipUpdated event,
    Emitter<ClipboardState> emit,
  ) {
    final normalized = _normalize(event.content);

    if (normalized == null ||
        _containsDuplicate(normalized, excludingId: event.id)) {
      event.completer.complete(false);
      return;
    }

    var didUpdate = false;

    final nextItems = state.items
        .map((item) {
          if (item.id != event.id) return item;

          didUpdate = true;
          return item.copyWith(content: normalized);
        })
        .toList(growable: false);

    if (!didUpdate) {
      event.completer.complete(false);
      return;
    }

    final sorted = _sort(nextItems);

    emit(state.copyWith(items: sorted));
    _persist(sorted);
    event.completer.complete(true);
  }

  void _onClipPinToggled(
    ClipboardClipPinToggled event,
    Emitter<ClipboardState> emit,
  ) {
    final nextItems = state.items
        .map((item) {
          if (item.id != event.id) return item;

          return item.copyWith(isPinned: !item.isPinned);
        })
        .toList(growable: false);

    final sorted = _sort(nextItems);

    emit(state.copyWith(items: sorted));
    _persist(sorted);
  }

  void _onClipDeleted(
    ClipboardClipDeleted event,
    Emitter<ClipboardState> emit,
  ) {
    final nextItems = state.items
        .where((item) => item.id != event.id)
        .toList(growable: false);

    emit(state.copyWith(items: nextItems));
    _persist(nextItems);
  }

  void _onExternalTextObserved(
    _ClipboardExternalTextObserved event,
    Emitter<ClipboardState> emit,
  ) {
    _lastObservedClipboard = event.content;
    _addNormalizedClip(event.content, emit);
  }

  void _startTracking() {
    unawaited(_syncClipboard());

    _poller = Timer.periodic(pollInterval, (_) {
      unawaited(_syncClipboard());
    });
  }

  Future<void> _syncClipboard() async {
    try {
      final normalized = _normalize(await _clipboardService.readText());

      if (normalized == null || normalized == _lastObservedClipboard) {
        return;
      }

      if (!isClosed) {
        add(_ClipboardExternalTextObserved(normalized));
      }
    } catch (_) {}
  }

  bool _addNormalizedClip(String content, Emitter<ClipboardState> emit) {
    final normalized = _normalize(content);
    if (normalized == null || _containsDuplicate(normalized)) {
      return false;
    }

    final now = DateTime.now();
    final nextItems = _sort([
      ClipboardItem(
        id: '${now.microsecondsSinceEpoch}-${normalized.hashCode}',
        content: normalized,
        createdAt: now,
      ),
      ...state.items,
    ]);

    emit(state.copyWith(items: nextItems));
    _persist(nextItems);

    return true;
  }

  void _persist(List<ClipboardItem> items) {
    unawaited(_clipboardService.saveLocal(items).catchError((_) {}));
  }

  bool _containsDuplicate(String content, {String? excludingId}) {
    return state.items.any(
      (item) => item.content == content && item.id != excludingId,
    );
  }

  String? _normalize(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  List<ClipboardItem> _sort(List<ClipboardItem> items) {
    final sorted = [...items];

    sorted.sort((a, b) {
      if (a.isPinned != b.isPinned) {
        return a.isPinned ? -1 : 1;
      }
      return b.createdAt.compareTo(a.createdAt);
    });

    return sorted;
  }

  @override
  Future<void> close() {
    _poller?.cancel();
    return super.close();
  }
}
