import 'package:flutter/material.dart';
import '../services/ads_service.dart';

/// Pushes [page] with a soft fade + upward-slide transition instead of the
/// platform default, used everywhere in the app for a consistent, playful
/// navigation feel. Also feeds AdsService's "every 3rd screen" interstitial
/// counter, since this helper is used for every in-app navigation.
Future<T?> pushAnimated<T>(BuildContext context, Widget page) {
  AdsService.instance.trackNavigationForInterstitial();
  return Navigator.of(context).push<T>(_buildRoute(page));
}

Future<T?> pushReplacementAnimated<T, TO>(BuildContext context, Widget page) {
  return Navigator.of(context).pushReplacement<T, TO>(_buildRoute(page));
}

PageRouteBuilder<T> _buildRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 420),
    reverseTransitionDuration: const Duration(milliseconds: 320),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
