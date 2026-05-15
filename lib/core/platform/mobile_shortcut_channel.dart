import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

abstract final class MobileShortcutAction {
  static const createClip = 'create_clip';
  static const searchClips = 'search_clips';
  static const openPinned = 'open_pinned';
  static const openHome = 'open_home';
}

abstract final class MobileShortcutChannel {
  static const _channel = MethodChannel('clips_tack/mobile_shortcuts');
  static final _actions = StreamController<String>.broadcast();
  static final searchFocusRequests = ValueNotifier<int>(0);

  static bool _isInitialized = false;

  static Stream<String> get actions => _actions.stream;

  static void initialize() {
    if (_isInitialized) {
      return;
    }

    _isInitialized = true;
    _channel.setMethodCallHandler((call) async {
      if (call.method != 'onShortcutAction') {
        return null;
      }

      final action = call.arguments;
      if (action is String && action.isNotEmpty) {
        _actions.add(action);
      }

      return null;
    });
  }

  static Future<String?> getInitialAction() async {
    initialize();
    try {
      return _channel.invokeMethod<String>('getInitialAction');
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearInitialAction() async {
    initialize();
    try {
      await _channel.invokeMethod<void>('clearInitialAction');
    } catch (_) {}
  }

  static Future<void> updateWidgets() async {
    initialize();
    try {
      await _channel.invokeMethod<void>('updateWidgets');
    } catch (_) {}
  }

  static void requestSearchFocus() {
    searchFocusRequests.value++;
  }
}
