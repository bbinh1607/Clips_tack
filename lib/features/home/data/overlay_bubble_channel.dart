import 'package:flutter/services.dart';

class OverlayBubbleChannel {
  const OverlayBubbleChannel();

  static const _channel = MethodChannel('clips_tack/overlay');

  Future<bool> hasPermission() {
    return _invokeBool('hasPermission');
  }

  Future<bool> requestPermission() {
    return _invokeBool('requestPermission');
  }

  Future<bool> startBubble() {
    return _invokeBool('startBubble');
  }

  Future<bool> stopBubble() {
    return _invokeBool('stopBubble');
  }

  Future<bool> isBubbleRunning() {
    return _invokeBool('isBubbleRunning');
  }

  Future<bool> _invokeBool(String method) async {
    try {
      return await _channel.invokeMethod<bool>(method) ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}
