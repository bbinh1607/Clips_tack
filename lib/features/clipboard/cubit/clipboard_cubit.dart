import 'dart:async';

import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/features/clipboard/data/services/clipboard_service.dart';
import 'package:clips_tack/features/clipboard/models/clipboard_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'clipboard_state.dart';

@injectable
class ClipboardCubit extends Cubit<ClipboardState> {
  @factoryMethod
  ClipboardCubit.create(ClipboardService clipboardService)
    : this(clipboardService: clipboardService);

  ClipboardCubit({
    required ClipboardService clipboardService,
    this.pollInterval = AppDuration.clipboardPolling,
    this.enableClipboardTracking = true,
  }) : _clipboardService = clipboardService,
       super(const ClipboardState()) {
    _init();

    if (enableClipboardTracking) {
      _startTracking();
    }
  }

  final ClipboardService _clipboardService;
  final Duration pollInterval;
  final bool enableClipboardTracking;

  Timer? _poller;
  String? _lastObservedClipboard;

  /// 🔥 INIT LOAD LOCAL
  Future<void> _init() async {
    try {
      final items = await _clipboardService.loadLocal();
      emit(state.copyWith(items: _sort(items)));
    } catch (_) {}
  }

  void setSearchQuery(String value) {
    emit(state.copyWith(searchQuery: value));
  }

  Future<String?> loadClipboardDraft() async {
    try {
      return _normalize(await _clipboardService.readText());
    } catch (_) {
      return null;
    }
  }

  Future<void> copyClip(ClipboardItem item) async {
    final normalized = _normalize(item.content);
    if (normalized == null) return;

    await _clipboardService.writeText(normalized);
    _lastObservedClipboard = normalized;
  }

  bool addClip(String content) {
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

    // 🔥 SAVE LOCAL
    unawaited(_clipboardService.saveLocal(nextItems));

    return true;
  }

  bool updateClip({required String id, required String content}) {
    final normalized = _normalize(content);
    if (normalized == null || _containsDuplicate(normalized, excludingId: id)) {
      return false;
    }

    var didUpdate = false;

    final nextItems = state.items
        .map((item) {
          if (item.id != id) return item;

          didUpdate = true;
          return item.copyWith(content: normalized);
        })
        .toList(growable: false);

    if (!didUpdate) return false;

    final sorted = _sort(nextItems);

    emit(state.copyWith(items: sorted));

    // 🔥 SAVE LOCAL
    unawaited(_clipboardService.saveLocal(sorted));

    return true;
  }

  void togglePin(String id) {
    final nextItems = state.items
        .map((item) {
          if (item.id != id) return item;

          return item.copyWith(isPinned: !item.isPinned);
        })
        .toList(growable: false);

    final sorted = _sort(nextItems);

    emit(state.copyWith(items: sorted));

    // 🔥 SAVE LOCAL
    unawaited(_clipboardService.saveLocal(sorted));
  }

  void deleteClip(String id) {
    final nextItems = state.items
        .where((item) => item.id != id)
        .toList(growable: false);

    emit(state.copyWith(items: nextItems));

    // 🔥 SAVE LOCAL
    unawaited(_clipboardService.saveLocal(nextItems));
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

      _lastObservedClipboard = normalized;

      final added = addClip(normalized);

      // (optional) nếu không add được thì có thể xử lý thêm ở đây
      if (!added) {
        // ignore duplicate
      }
    } catch (_) {
      // ignore clipboard errors
    }
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
