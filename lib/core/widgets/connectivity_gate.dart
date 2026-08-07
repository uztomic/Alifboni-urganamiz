import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/connectivity_service.dart';
import '../theme/app_colors.dart';
import '../../l10n/generated/app_localizations.dart';

/// Wraps the whole app: while there is no real internet connection, this
/// replaces every screen with a friendly "no internet" page instead of
/// letting the app run in a half-broken state (the Nature module needs
/// live photos, and ads need a network too). Recovers automatically the
/// moment a connection is detected — no manual "retry" is required,
/// though a retry button is offered for impatient taps.
class ConnectivityGate extends StatefulWidget {
  final Widget child;
  const ConnectivityGate({super.key, required this.child});

  @override
  State<ConnectivityGate> createState() => _ConnectivityGateState();
}

class _ConnectivityGateState extends State<ConnectivityGate> {
  bool? _online;
  StreamSubscription<bool>? _sub;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    ConnectivityService.instance.start();
    _sub = ConnectivityService.instance.onStatusChange.listen(_onStatus);
    ConnectivityService.instance.checkNow().then(_onStatus);
  }

  void _onStatus(bool online) {
    if (!mounted) return;
    setState(() => _online = online);
    if (!online) {
      _pollTimer ??= Timer.periodic(
        const Duration(seconds: 4),
        (_) => ConnectivityService.instance.checkNow(),
      );
    } else {
      _pollTimer?.cancel();
      _pollTimer = null;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // widget.child (the Navigator and all its screen state) stays mounted
    // at all times — only overlaid, never torn down — so a connectivity
    // blip mid-quiz doesn't reset the child's progress.
    return Stack(
      children: [
        widget.child,
        if (_online != true)
          _NoInternetScreen(
            checking: _online == null,
            onRetry: () => ConnectivityService.instance.checkNow(),
          ),
      ],
    );
  }
}

class _NoInternetScreen extends StatelessWidget {
  final bool checking;
  final VoidCallback onRetry;
  const _NoInternetScreen({required this.checking, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: AppColors.background,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('📡', style: TextStyle(fontSize: 72)),
                  const SizedBox(height: 20),
                  Text(
                    l10n?.noInternetTitle ?? 'No internet connection',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.baloo2(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n?.noInternetBody ??
                        'Please connect to the internet to use the app.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(fontSize: 15, color: Colors.black54),
                  ),
                  const SizedBox(height: 28),
                  if (checking)
                    Column(
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 12),
                        Text(
                          l10n?.noInternetChecking ?? 'Checking...',
                          style: GoogleFonts.nunito(color: Colors.black45),
                        ),
                      ],
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(l10n?.commonRetry ?? 'Retry'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
