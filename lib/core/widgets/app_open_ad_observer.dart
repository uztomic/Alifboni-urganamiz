import 'package:flutter/widgets.dart';
import '../services/ads_service.dart';

/// Shows an App Open ad whenever the app returns to the foreground after
/// having been backgrounded — never on the very first cold-start resume,
/// so the first thing a child sees when opening the app is the app
/// itself, not an ad.
class AppOpenAdObserver extends StatefulWidget {
  final Widget child;
  const AppOpenAdObserver({super.key, required this.child});

  @override
  State<AppOpenAdObserver> createState() => _AppOpenAdObserverState();
}

class _AppOpenAdObserverState extends State<AppOpenAdObserver> with WidgetsBindingObserver {
  bool _hasBeenBackgrounded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _hasBeenBackgrounded = true;
    } else if (state == AppLifecycleState.resumed && _hasBeenBackgrounded) {
      AdsService.instance.showAppOpenAdIfAvailable();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
