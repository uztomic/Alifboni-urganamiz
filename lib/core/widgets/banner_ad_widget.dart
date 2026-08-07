import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ads_service.dart';

/// A banner ad that quietly collapses to nothing if it fails to load
/// (e.g. no internet, or — very likely for a brand-new AdMob account —
/// no fill yet), instead of leaving an empty gray box. Retries a few
/// times with backoff, since "no fill" for a newly created ad unit is
/// often transient.
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  static const _maxAttempts = 4;

  BannerAd? _bannerAd;
  bool _isLoaded = false;
  int _attempt = 0;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _scheduleLoad();
  }

  Future<void> _scheduleLoad() async {
    // The Mobile Ads SDK is initialized fire-and-forget in main(), so this
    // widget can build (e.g. Home, right after the splash delay) before
    // it's ready; loading before that silently fails with no retry.
    await AdsService.instance.ready;
    if (_disposed) return;
    _loadBanner();
  }

  void _loadBanner() {
    final banner = BannerAd(
      adUnitId: AdsService.instance.bannerUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (_disposed) {
            ad.dispose();
            return;
          }
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _attempt++;
          if (_disposed || _attempt >= _maxAttempts) return;
          Future.delayed(Duration(seconds: 5 * _attempt), () {
            if (!_disposed) _loadBanner();
          });
        },
      ),
    );
    _bannerAd = banner;
    banner.load();
  }

  @override
  void dispose() {
    _disposed = true;
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _bannerAd;
    if (!_isLoaded || ad == null) return const SizedBox.shrink();
    return Container(
      alignment: Alignment.center,
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}
