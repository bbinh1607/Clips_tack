import 'package:clips_tack/features/home/data/overlay_bubble_channel.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum OverlayBubbleFeedback { started, stopped, permissionNeeded }

class OverlayBubbleSettingsState {
  const OverlayBubbleSettingsState({
    this.hasPermission = false,
    this.isRunning = false,
    this.isBusy = true,
    this.shouldShowBubble = false,
  });

  final bool hasPermission;
  final bool isRunning;
  final bool isBusy;
  final bool shouldShowBubble;

  OverlayBubbleSettingsState copyWith({
    bool? hasPermission,
    bool? isRunning,
    bool? isBusy,
    bool? shouldShowBubble,
  }) {
    return OverlayBubbleSettingsState(
      hasPermission: hasPermission ?? this.hasPermission,
      isRunning: isRunning ?? this.isRunning,
      isBusy: isBusy ?? this.isBusy,
      shouldShowBubble: shouldShowBubble ?? this.shouldShowBubble,
    );
  }
}

class OverlayBubbleController extends ChangeNotifier {
  OverlayBubbleController({
    OverlayBubbleChannel overlayBubble = const OverlayBubbleChannel(),
  }) : _overlayBubble = overlayBubble;

  static const _overlayBubbleEnabledKey = 'overlay_bubble_enabled';

  final OverlayBubbleChannel _overlayBubble;

  OverlayBubbleSettingsState _state = const OverlayBubbleSettingsState();
  bool _isDisposed = false;

  OverlayBubbleSettingsState get state => _state;

  Future<OverlayBubbleFeedback?> refresh() async {
    final prefs = await SharedPreferences.getInstance();
    final shouldShowBubble = prefs.getBool(_overlayBubbleEnabledKey) ?? false;
    final hasPermission = await _overlayBubble.hasPermission();
    var isRunning = await _overlayBubble.isBubbleRunning();
    OverlayBubbleFeedback? feedback;

    if (hasPermission && shouldShowBubble && !isRunning) {
      await _overlayBubble.startBubble();
      await Future<void>.delayed(const Duration(milliseconds: 250));
      isRunning = await _overlayBubble.isBubbleRunning();
      if (isRunning) {
        feedback = OverlayBubbleFeedback.started;
      }
    }

    _emit(
      _state.copyWith(
        shouldShowBubble: shouldShowBubble,
        hasPermission: hasPermission,
        isRunning: isRunning,
        isBusy: false,
      ),
    );

    return _isDisposed ? null : feedback;
  }

  Future<OverlayBubbleFeedback?> setBubbleEnabled(
    bool value, {
    required Future<bool> Function() confirmPermission,
  }) async {
    _emit(_state.copyWith(isBusy: true, shouldShowBubble: value));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_overlayBubbleEnabledKey, value);

    if (!value) {
      await _overlayBubble.stopBubble();
      _emit(_state.copyWith(isRunning: false, isBusy: false));
      return _isDisposed ? null : OverlayBubbleFeedback.stopped;
    }

    if (!_state.hasPermission) {
      return _enableBubbleAfterPermissionCheck(
        prefs: prefs,
        confirmPermission: confirmPermission,
      );
    }

    return _startBubble();
  }

  Future<OverlayBubbleFeedback?> _enableBubbleAfterPermissionCheck({
    required SharedPreferences prefs,
    required Future<bool> Function() confirmPermission,
  }) async {
    final shouldRequestPermission = await confirmPermission();

    if (!shouldRequestPermission) {
      await prefs.setBool(_overlayBubbleEnabledKey, false);
      _emit(_state.copyWith(shouldShowBubble: false, isBusy: false));
      return null;
    }

    final alreadyAllowed = await _overlayBubble.requestPermission();

    if (!alreadyAllowed) {
      _emit(_state.copyWith(isBusy: false));
      return _isDisposed ? null : OverlayBubbleFeedback.permissionNeeded;
    }

    return _startBubble(hasPermission: true);
  }

  Future<OverlayBubbleFeedback?> _startBubble({bool? hasPermission}) async {
    await _overlayBubble.startBubble();
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final isRunning = await _overlayBubble.isBubbleRunning();

    _emit(
      _state.copyWith(
        hasPermission: hasPermission ?? _state.hasPermission,
        isRunning: isRunning,
        isBusy: false,
      ),
    );

    if (_isDisposed) {
      return null;
    }

    return isRunning
        ? OverlayBubbleFeedback.started
        : OverlayBubbleFeedback.permissionNeeded;
  }

  void _emit(OverlayBubbleSettingsState state) {
    if (_isDisposed) {
      return;
    }

    _state = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
