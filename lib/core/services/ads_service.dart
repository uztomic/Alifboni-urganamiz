import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Wraps all AdMob ad formats used by the app: banner, interstitial,
/// rewarded, app open, and native.
///
/// Real ad unit IDs (account "Alifboni urganamiz") are only used in
/// **release** builds. Debug builds (including this development device)
/// always use Google's official test IDs — showing/tapping real ads from
/// an unregistered test device risks the AdMob account being flagged for
/// invalid traffic, so this split is a deliberate safety measure, not a
/// placeholder. Also see AndroidManifest.xml for the app ID and TZ 8.1 for
/// the "Child-directed" / COPPA requirements this account must satisfy.
class AdsService {
  AdsService._();
  static final AdsService instance = AdsService._();

  static const String nativeAdFactoryId = 'listTile';

  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  AppOpenAd? _appOpenAd;
  bool _isShowingAppOpenAd = false;
  DateTime? _appOpenAdLoadedAt;
  int _navigationCount = 0;

  final Completer<void> _readyCompleter = Completer<void>();

  /// Completes once `MobileAds.instance.initialize()` has finished.
  /// Widgets that build their own ad objects (banner, native) must await
  /// this before their first `.load()` call: those widgets can mount
  /// (e.g. the Home screen banner, right after the ~1.7s splash delay)
  /// before this fire-and-forget init finishes, and the Mobile Ads SDK
  /// silently drops load requests made before it's ready — with no retry,
  /// that widget would never show an ad for the rest of its lifetime.
  Future<void> get ready => _readyCompleter.future;

  // Was temporarily `true` to force Google's guaranteed-fill test ads for
  // on-device verification while the real AdMob account was brand new.
  // Now reverted — release builds show real ads again.
  static const bool kForceTestAdsForVerification = false;

  bool get _useRealAds =>
      !kForceTestAdsForVerification && !kDebugMode && Platform.isAndroid;

  String get bannerUnitId => _useRealAds
      ? 'ca-app-pub-6629898898338853/9644061460'
      : 'ca-app-pub-3940256099942544/6300978111'; // Google test banner

  String get nativeUnitId => _useRealAds
      ? 'ca-app-pub-6629898898338853/4391734780'
      : 'ca-app-pub-3940256099942544/2247696110'; // Google test native advanced

  String get _interstitialUnitId => _useRealAds
      ? 'ca-app-pub-6629898898338853/8330979798'
      : 'ca-app-pub-3940256099942544/1033173712'; // Google test interstitial

  String get _rewardedUnitId => _useRealAds
      ? 'ca-app-pub-6629898898338853/6467802001'
      : 'ca-app-pub-3940256099942544/5224354917'; // Google test rewarded

  String get _appOpenUnitId => _useRealAds
      ? 'ca-app-pub-6629898898338853/2890950853'
      : 'ca-app-pub-3940256099942544/9257395921'; // Google test app open

  Future<void> init() async {
    await MobileAds.instance.initialize();
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
        tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.yes,
        maxAdContentRating: MaxAdContentRating.g,
      ),
    );
    _loadInterstitial();
    _loadRewarded();
    _loadAppOpenAd();
    if (!_readyCompleter.isCompleted) _readyCompleter.complete();
  }

  /// Retries a failed ad load with capped exponential backoff (5s, 10s,
  /// 20s, ... up to 1 minute) instead of giving up for the rest of the
  /// app's lifetime. "No fill" is common — and expected, for a brand-new
  /// AdMob account still warming up — and is very often transient.
  int _interstitialAttempt = 0;
  int _rewardedAttempt = 0;
  int _appOpenAttempt = 0;

  Duration _backoff(int attempt) =>
      Duration(seconds: (5 * (1 << attempt)).clamp(5, 60));

  // ---- Interstitial ----

  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: _interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAttempt = 0;
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (_) {
          _interstitialAd = null;
          Future.delayed(_backoff(_interstitialAttempt), _loadInterstitial);
          _interstitialAttempt++;
        },
      ),
    );
  }

  /// Shows an interstitial ad if one is ready (e.g. after finishing a quiz,
  /// or before entering the parent zone). No-ops silently if no ad has
  /// loaded yet, so callers never need to branch on ad availability.
  Future<void> showInterstitial() async {
    final ad = _interstitialAd;
    if (ad == null) return;
    _interstitialAd = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        _loadInterstitial();
      },
    );
    await ad.show();
  }

  /// Call on every in-app screen navigation. Shows an interstitial on
  /// every 3rd navigation (TZ 8.2: "kamdan-kam, masalan har 3-sikldan
  /// keyin") if one happens to be loaded; otherwise no-ops silently, so
  /// callers never need to check ad state themselves.
  void trackNavigationForInterstitial() {
    _navigationCount++;
    if (_navigationCount % 3 == 0) {
      showInterstitial();
    }
  }

  // ---- Rewarded ----

  bool _rewardedLoading = false;

  void _loadRewarded() {
    if (_rewardedLoading) return;
    _rewardedLoading = true;
    RewardedAd.load(
      adUnitId: _rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedLoading = false;
          _rewardedAttempt = 0;
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (_) {
          _rewardedLoading = false;
          _rewardedAd = null;
          Future.delayed(_backoff(_rewardedAttempt), _loadRewarded);
          _rewardedAttempt++;
        },
      ),
    );
  }

  bool get isRewardedReady => _rewardedAd != null;

  /// Waits briefly for a rewarded ad to become ready instead of failing
  /// immediately. The backoff loop in [_loadRewarded] can leave up to 60s
  /// between attempts, so a child who opens the "watch ad" sheet exactly
  /// between attempts would otherwise always see "ad not ready" even
  /// though a real ad would load within a couple of seconds. This kicks
  /// off an immediate attempt (if one isn't already in flight) and polls
  /// for up to [timeout] before giving up.
  Future<bool> ensureRewardedReady({
    Duration timeout = const Duration(seconds: 6),
  }) async {
    if (isRewardedReady) return true;
    if (!_rewardedLoading) _loadRewarded();
    final deadline = DateTime.now().add(timeout);
    while (!isRewardedReady && DateTime.now().isBefore(deadline)) {
      await Future.delayed(const Duration(milliseconds: 250));
    }
    return isRewardedReady;
  }

  /// Shows a rewarded ad (e.g. to unlock a locked vocabulary category or
  /// letter). [onReward] is called only if the user watches to
  /// completion. Returns true only once the reward was actually earned —
  /// false both when no ad was ready AND when the user backed out before
  /// finishing.
  ///
  /// IMPORTANT: `RewardedAd.show()`'s Future resolves as soon as the ad
  /// *opens*, not when the user finishes watching it — awaiting it alone
  /// (as this used to) meant callers checked for the reward before it
  /// could possibly have been earned yet, so the "unlock" gate never
  /// actually unlocked even after watching the whole video. A separate
  /// Completer, fulfilled from onAdDismissedFullScreenContent (i.e. once
  /// the ad UI actually closes), is what makes this wait for real.
  Future<bool> showRewarded({required VoidCallback onReward}) async {
    final ad = _rewardedAd;
    if (ad == null) return false;
    _rewardedAd = null;

    final completer = Completer<bool>();
    var earned = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (a) {
        a.dispose();
        _loadRewarded();
        if (!completer.isCompleted) completer.complete(earned);
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        a.dispose();
        _loadRewarded();
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    unawaited(ad.show(
      onUserEarnedReward: (rewardedAd, reward) {
        earned = true;
        onReward();
      },
    ));

    return completer.future;
  }

  // ---- App open ----

  void _loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: _appOpenUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAttempt = 0;
          _appOpenAd = ad;
          _appOpenAdLoadedAt = DateTime.now();
        },
        onAdFailedToLoad: (_) {
          _appOpenAd = null;
          Future.delayed(_backoff(_appOpenAttempt), _loadAppOpenAd);
          _appOpenAttempt++;
        },
      ),
    );
  }

  bool get _isAppOpenAdFresh {
    final loadedAt = _appOpenAdLoadedAt;
    if (loadedAt == null) return false;
    return DateTime.now().difference(loadedAt) < const Duration(hours: 4);
  }

  /// Shows an app-open ad when the app returns to the foreground (never on
  /// cold start, so the very first thing a child sees is the app itself,
  /// not an ad). No-ops if none is loaded/fresh or one is already showing.
  void showAppOpenAdIfAvailable() {
    final ad = _appOpenAd;
    if (ad == null || _isShowingAppOpenAd || !_isAppOpenAdFresh) return;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) => _isShowingAppOpenAd = true,
      onAdDismissedFullScreenContent: (a) {
        _isShowingAppOpenAd = false;
        a.dispose();
        _appOpenAd = null;
        _loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (a, _) {
        _isShowingAppOpenAd = false;
        a.dispose();
        _appOpenAd = null;
        _loadAppOpenAd();
      },
    );
    ad.show();
  }
}

typedef VoidCallback = void Function();
