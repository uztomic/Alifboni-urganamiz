import 'package:flutter_tts/flutter_tts.dart';

/// On-device text-to-speech playback. Used instead of pre-recorded audio
/// files so the app stays fully offline without bundling large audio assets.
class TtsService {
  TtsService._();
  static final TtsService instance = TtsService._();

  final FlutterTts _tts = FlutterTts();
  String? _currentLocale;
  bool _enabled = true;

  Future<void> init({bool enabled = true, double speed = 0.45}) async {
    _enabled = enabled;
    await _tts.setSpeechRate(speed);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.1);
    // Warm up the native TTS engine now, during the splash screen's
    // already-existing pause, instead of on the child's first "listen"
    // tap. Binding to the underlying Android TextToSpeech service is the
    // slow part (not switching locales afterwards), so doing it once
    // here up front is what makes the very first real speak() feel
    // instant instead of delayed.
    try {
      await _tts.setLanguage('en-US');
      _currentLocale = 'en-US';
    } catch (_) {
      // No en-US voice on this device — engine still gets warmed up.
    }
  }

  void setEnabled(bool enabled) => _enabled = enabled;

  Future<void> setSpeed(double speed) async {
    await _tts.setSpeechRate(speed);
  }

  Future<void> speak(String text, {required String locale}) async {
    if (!_enabled || text.trim().isEmpty) return;
    try {
      if (_currentLocale != locale) {
        await _tts.setLanguage(locale);
        _currentLocale = locale;
      }
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {
      // Device may not have this language's voice installed; fail silently
      // so the UI still works without sound.
    }
  }

  Future<void> stop() => _tts.stop();
}
