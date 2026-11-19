import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

import '../../domain/entities/voice_lang.dart';
import 'voice_key.dart';

export '../../domain/entities/voice_lang.dart';


/// Qisqa effekt tovushlari (assets/audio/sfx).
enum Sfx {
  tap('tap'),
  correct('correct'),
  wrong('error_soft'),
  tryAgain('try_again'),
  star('star'),
  celebrate('celebrate'),
  levelComplete('level_complete'),
  pop('balloon_pop'),
  flip('card_flip'),
  match('match'),
  whoosh('whoosh'),
  coin('coin'),
  chest('chest_open'),
  train('train'),
  toggle('toggle'),
  swipe('swipe');

  const Sfx(this.file);
  final String file;
}

/// Fon musiqasi (assets/audio/music).
enum Music {
  home('home'),
  lesson('lesson'),
  games('games'),
  calm('calm');

  const Music(this.file);
  final String file;
}

/// Ilovadagi barcha tovushlarni boshqaradi.
///
/// * Ovoz: avval ilova ichidagi tabiiy inson ovozi qidiriladi
///   (`assets/voice/<til>/<FNV xesh>.webm`). Topilmasa — rus va ingliz
///   uchun telefon TTS'i ishlatiladi. O'zbekcha uchun TTS ishlatilmaydi
///   (ko'p telefonlarda o'zbekcha ovoz yo'q va noto'g'ri o'qiydi).
/// * Effektlar: har bir effekt uchun alohida, oldindan yuklangan pleer —
///   bosilganda kechikishsiz chiqadi.
/// * Musiqa: past ovozda aylanib turadi, gapirilganda yanada pasayadi.
class AudioService with WidgetsBindingObserver {
  AudioService._();
  static final AudioService instance = AudioService._();

  final Map<VoiceLang, Set<String>> _available = {
    for (final l in VoiceLang.values) l: <String>{},
  };

  final AudioPlayer _voice = AudioPlayer();
  final AudioPlayer _music = AudioPlayer();
  final Map<Sfx, AudioPlayer> _sfx = {};
  final FlutterTts _tts = FlutterTts();

  bool voiceOn = true;
  bool sfxOn = true;
  bool _musicOn = true;
  Music? _currentMusic;
  bool _appVisible = true;
  int _speakToken = 0;
  String? _ttsLang;

  static const double _musicVolume = 0.22;
  static const double _musicDuckedVolume = 0.07;

  bool get musicOn => _musicOn;

  Future<void> init({
    required bool voice,
    required bool sfx,
    required bool music,
  }) async {
    voiceOn = voice;
    sfxOn = sfx;
    _musicOn = music;
    WidgetsBinding.instance.addObserver(this);

    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      for (final path in manifest.listAssets()) {
        if (!path.startsWith('assets/voice/')) continue;
        final parts = path.split('/');
        if (parts.length != 4) continue;
        final lang = switch (parts[2]) {
          'uz' => VoiceLang.uz,
          'ru' => VoiceLang.ru,
          'en' => VoiceLang.en,
          _ => null,
        };
        if (lang == null) continue;
        _available[lang]!.add(parts[3].split('.').first);
      }
    } catch (_) {
      // Manifest o'qilmasa ham ilova ishlayveradi — faqat ovozsiz.
    }

    try {
      await _tts.awaitSpeakCompletion(true);
      await _tts.setSpeechRate(0.42);
      await _tts.setPitch(1.05);
      await _tts.setVolume(1.0);
    } catch (_) {}

    // Eng ko'p ishlatiladigan effektlarni oldindan yuklab qo'yamiz.
    for (final s in const [Sfx.tap, Sfx.correct, Sfx.wrong, Sfx.star, Sfx.pop]) {
      unawaited(_sfxPlayer(s));
    }
    await _music.setLoopMode(LoopMode.one);
  }

  /// Shu matn uchun yozib olingan tabiiy ovoz bormi.
  bool hasVoice(String text, VoiceLang lang) =>
      _available[lang]!.contains(voiceKey(text));

  /// Matnni o'qiydi va tugashini kutadi. Tabiiy ovoz yoki TTS bilan
  /// o'qilgan bo'lsa `true`, umuman o'qib bo'lmasa `false`.
  /// Yangi `say` chaqirilsa, oldingisi darhol to'xtaydi.
  Future<bool> say(String text, {VoiceLang lang = VoiceLang.uz}) async {
    final token = ++_speakToken;
    await _stopVoiceOnly();
    if (!voiceOn || text.trim().isEmpty) return false;

    final key = voiceKey(text);
    if (_available[lang]!.contains(key)) {
      try {
        _duck(true);
        await _voice.setAsset('assets/voice/${lang.name}/$key.webm');
        if (token != _speakToken) return true;
        await _voice.play();
        return true;
      } catch (_) {
        return false;
      } finally {
        if (token == _speakToken) _duck(false);
      }
    }

    if (lang == VoiceLang.uz) return false;
    return _speakTts(text, lang, token);
  }

  /// Bir nechta gapni ketma-ket o'qiydi (ovozi yo'qlarini o'tkazib
  /// yuboradi). Orada boshqa `say`/`stopVoice` chaqirilsa — to'xtaydi.
  Future<void> sayAll(List<(String, VoiceLang)> lines) async {
    for (final (text, lang) in lines) {
      final before = _speakToken;
      await say(text, lang: lang);
      // say() tokenni roppa-rosa 1 ga oshiradi. Undan ko'p oshgan bo'lsa,
      // orada boshqa ovoz boshlangan — ketma-ketlikni to'xtatamiz.
      if (_speakToken != before + 1) return;
      await Future<void>.delayed(const Duration(milliseconds: 150));
      if (_speakToken != before + 1) return;
    }
  }

  Future<bool> _speakTts(String text, VoiceLang lang, int token) async {
    final code = lang == VoiceLang.ru ? 'ru-RU' : 'en-US';
    try {
      if (_ttsLang != code) {
        final ok = await _tts.isLanguageAvailable(code);
        if (ok == false) return false;
        await _tts.setLanguage(code);
        _ttsLang = code;
      }
      if (token != _speakToken) return true;
      _duck(true);
      await _tts.speak(text);
      return true;
    } catch (_) {
      return false;
    } finally {
      if (token == _speakToken) _duck(false);
    }
  }

  Future<void> stopVoice() async {
    _speakToken++;
    await _stopVoiceOnly();
    _duck(false);
  }

  Future<void> _stopVoiceOnly() async {
    try {
      if (_voice.playing) await _voice.stop();
    } catch (_) {}
    try {
      await _tts.stop();
    } catch (_) {}
  }

  Future<AudioPlayer> _sfxPlayer(Sfx s) async {
    final existing = _sfx[s];
    if (existing != null) return existing;
    final p = AudioPlayer();
    _sfx[s] = p;
    try {
      await p.setAsset('assets/audio/sfx/${s.file}.mp3');
      await p.setVolume(0.8);
    } catch (_) {}
    return p;
  }

  /// Effekt tovushini chiqaradi (kutmaydi).
  void play(Sfx s) {
    if (!sfxOn) return;
    unawaited(() async {
      try {
        final p = await _sfxPlayer(s);
        await p.seek(Duration.zero);
        if (!p.playing) await p.play();
      } catch (_) {}
    }());
  }

  /// Fon musiqasini almashtiradi. Bir xil musiqa qayta so'ralsa, uzilmaydi.
  Future<void> music(Music? m) async {
    _currentMusic = m;
    if (m == null || !_musicOn) {
      try {
        await _music.pause();
      } catch (_) {}
      return;
    }
    try {
      if (_loadedMusic != m) {
        await _music.setAsset('assets/audio/music/${m.file}.mp3');
        _loadedMusic = m;
      }
      await _music.setVolume(_musicVolume);
      if (_appVisible && !_music.playing) unawaited(_music.play());
    } catch (_) {}
  }

  Music? _loadedMusic;

  Future<void> setMusicOn(bool on) async {
    _musicOn = on;
    final wanted = _currentMusic;
    await music(on ? wanted : null);
    _currentMusic = wanted;
  }

  void _duck(bool ducked) {
    if (!_music.playing) return;
    unawaited(_music.setVolume(ducked ? _musicDuckedVolume : _musicVolume));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final visible = state == AppLifecycleState.resumed;
    if (visible == _appVisible) return;
    _appVisible = visible;
    if (!visible) {
      unawaited(stopVoice());
      unawaited(_music.pause());
    } else if (_musicOn && _currentMusic != null) {
      unawaited(_music.play());
    }
  }
}
