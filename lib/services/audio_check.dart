import 'package:flutter/services.dart';

class AudioCheck {
  static const MethodChannel _channel = MethodChannel('audio_check');

  static Future<bool> get areSpeakersActive async {
    final bool isActive = await _channel.invokeMethod('areSpeakersActive');
    return isActive;
  }
}
