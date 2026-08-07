import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ads_service.dart';

/// A native ad rendered via the "listTile" factory registered natively in
/// MainActivity.kt. Meant to be dropped into a grid/list among real
/// content (e.g. the vocabulary category grid). Collapses to nothing if
/// the ad fails to load, retrying a few times with backoff first (see
/// BannerAdWidget for why: SDK-not-ready-yet and no-fill are both
/// transient and worth a retry rather than giving up for good).
class NativeAdCard extends StatefulWidget {
  const NativeAdCard({super.key});

  @override
  State<NativeAdCard> createState() => _NativeAdCardState();
}

class _NativeAdCardState extends State<NativeAdCard> {
  static const _maxAttempts = 4;

  NativeAd? _nativeAd;
  bool _isLoaded = false;
  int _attempt = 0;
  bool _disposed = false;

  @override
  void initState() {
    super.initState();
    _scheduleLoad();
  }

  Future<void> _scheduleLoad() async {
    await AdsService.instance.ready;
    if (_disposed) return;
    _loadAd();
  }

  void _loadAd() {
    final ad = NativeAd(
      adUnitId: AdsService.instance.nativeUnitId,
      factoryId: AdsService.nativeAdFactoryId,
      request: const AdRequest(),
      listener: NativeAdListener(
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
            if (!_disposed) _loadAd();
          });
        },
      ),
    );
    _nativeAd = ad;
    ad.load();
  }

  @override
  void dispose() {
    _disposed = true;
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _nativeAd;
    if (!_isLoaded || ad == null) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(height: 84, child: AdWidget(ad: ad)),
    );
  }
}
