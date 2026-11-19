import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Reklama (oldingi versiyadagi hajmda):
///
/// * Banner — barcha menyu sahifalarida.
/// * Interstitial — har 2-dars/o'yin tugagach VA har 4-bo'lim ochilganda
///   (kamida 60 soniya oralig'ida).
/// * App Open — ilovaga 30 soniyadan ko'proq vaqtdan keyin qaytilganda
///   (birinchi ochilishda emas).
///
/// Dars, o'yin yoki ertak ICHIDA hech qachon reklama chiqmaydi
/// ([activityActive]) va hech narsa reklama bilan qulflanmaydi.
/// Barcha so'rovlar "child-directed" va G reytingli (Google Play Families).
/// Debug rejimda Google test ID'lari ishlatiladi.
class AdsService {
  AdsService._();
  static final AdsService instance = AdsService._();

  final Completer<void> _ready = Completer<void>();
  Future<void> get ready => _ready.future;

  InterstitialAd? _interstitial;
  AppOpenAd? _appOpen;
  DateTime? _appOpenLoadedAt;
  int _interAttempt = 0;
  int _openAttempt = 0;
  int _completed = 0;
  int _navigations = 0;
  DateTime? _lastFullscreen;
  bool _showing = false;
  DateTime? _backgroundedAt;

  /// Dars/o'yin/ertak ochiq bo'lsa — to'liq ekranli reklama yo'q.
  /// (Hisoblagich: sahifa almashganda yangisi eskisidan oldin ochiladi.)
  int _activityDepth = 0;
  bool get activityActive => _activityDepth > 0;
  void enterActivity() => _activityDepth++;
  void exitActivity() => _activityDepth = (_activityDepth - 1).clamp(0, 1 << 20);

  static const _minGap = Duration(seconds: 60);

  bool get supported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  bool get _real => !kDebugMode && Platform.isAndroid;

  String get bannerUnitId => _real
      ? 'ca-app-pub-6629898898338853/9644061460'
      : 'ca-app-pub-3940256099942544/6300978111';
  String get _interstitialUnitId => _real
      ? 'ca-app-pub-6629898898338853/8330979798'
      : 'ca-app-pub-3940256099942544/1033173712';
  String get _appOpenUnitId => _real
      ? 'ca-app-pub-6629898898338853/2890950853'
      : 'ca-app-pub-3940256099942544/9257395921';

  Future<void> init() async {
    if (!supported) return;
    try {
      await MobileAds.instance.initialize();
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
          tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.yes,
          maxAdContentRating: MaxAdContentRating.g,
        ),
      );
      _loadInterstitial();
      _loadAppOpen();
    } catch (_) {
      // Reklama ishlamasa ham ilova to'liq ishlaydi.
    } finally {
      if (!_ready.isCompleted) _ready.complete();
    }
  }

  Duration _backoff(int attempt) => Duration(seconds: (10 * (1 << attempt)).clamp(10, 300));

  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: _interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interAttempt = 0;
          _interstitial = ad;
        },
        onAdFailedToLoad: (_) {
          _interstitial = null;
          Future.delayed(_backoff(_interAttempt), _loadInterstitial);
          _interAttempt = (_interAttempt + 1).clamp(0, 5);
        },
      ),
    );
  }

  void _loadAppOpen() {
    AppOpenAd.load(
      adUnitId: _appOpenUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _openAttempt = 0;
          _appOpen = ad;
          _appOpenLoadedAt = DateTime.now();
        },
        onAdFailedToLoad: (_) {
          _appOpen = null;
          Future.delayed(_backoff(_openAttempt), _loadAppOpen);
          _openAttempt = (_openAttempt + 1).clamp(0, 5);
        },
      ),
    );
  }

  bool get _gapOk {
    final last = _lastFullscreen;
    return last == null || DateTime.now().difference(last) >= _minGap;
  }

  /// Dars/o'yin/test tugaganda (natija ekranidan oldin) chaqiriladi.
  Future<void> onActivityCompleted() async {
    if (!supported) return;
    _completed++;
    if (_completed % 2 == 0) await _showInterstitial(ignoreActivity: true);
  }

  /// Menyudan bo'lim ochilganda chaqiriladi.
  void onNavigation() {
    if (!supported) return;
    _navigations++;
    if (_navigations % 4 == 0) _showInterstitial();
  }

  Future<void> _showInterstitial({bool ignoreActivity = false}) async {
    final ad = _interstitial;
    if (ad == null || _showing || !_gapOk) return;
    if (activityActive && !ignoreActivity) return;
    _interstitial = null;
    _showing = true;
    final done = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _showing = false;
        _lastFullscreen = DateTime.now();
        _loadInterstitial();
        if (!done.isCompleted) done.complete();
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        _showing = false;
        _loadInterstitial();
        if (!done.isCompleted) done.complete();
      },
    );
    try {
      await ad.show();
      await done.future.timeout(const Duration(minutes: 2), onTimeout: () {});
    } catch (_) {
      _showing = false;
    }
  }

  void onBackground() => _backgroundedAt = DateTime.now();

  /// Ilova qayta ochilganda: 30 s dan ko'p tashqarida bo'lgan bo'lsa va
  /// bola dars ichida bo'lmasa — App Open reklama.
  void onForeground() {
    final since = _backgroundedAt;
    _backgroundedAt = null;
    if (!supported || since == null) return;
    if (DateTime.now().difference(since) < const Duration(seconds: 30)) return;
    final ad = _appOpen;
    final loadedAt = _appOpenLoadedAt;
    if (ad == null || loadedAt == null || _showing || activityActive || !_gapOk) return;
    if (DateTime.now().difference(loadedAt) > const Duration(hours: 4)) {
      ad.dispose();
      _appOpen = null;
      _loadAppOpen();
      return;
    }
    _appOpen = null;
    _showing = true;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _showing = false;
        _lastFullscreen = DateTime.now();
        _loadAppOpen();
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        _showing = false;
        _loadAppOpen();
      },
    );
    ad.show();
  }
}
