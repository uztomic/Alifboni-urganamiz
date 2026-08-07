import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_page_route.dart';
import '../../home/presentation/home_screen.dart';
import '../../onboarding/presentation/onboarding_screen.dart';
import '../../settings/bloc/settings_cubit.dart';

/// Animated splash: the owl mascot bounces in, the title fades up, then the
/// app hands off to onboarding (first launch) or home. Purely a branded
/// pause layered on top of an already-initialized app (see main.dart), so
/// it doesn't compromise the <2s launch-time target in TZ 10.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _owlScale;
  late final Animation<double> _owlRotation;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _owlScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.2, end: 1.15)
          .chain(CurveTween(curve: Curves.easeOutBack)), weight: 65),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOut)), weight: 35),
    ]).animate(_controller);

    _owlRotation = Tween<double>(begin: -0.35, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.65, curve: Curves.easeOutBack)),
    );

    _titleFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.85, curve: Curves.easeOut),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.35, 0.85, curve: Curves.easeOutCubic)),
    );
    _taglineFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();
    _scheduleNavigation();
  }

  Future<void> _scheduleNavigation() async {
    await Future.delayed(const Duration(milliseconds: 1700));
    if (!mounted) return;
    final hasChosenLanguage = context.read<SettingsCubit>().state.hasChosenLanguage;
    pushReplacementAnimated(
      context,
      hasChosenLanguage ? const HomeScreen() : const OnboardingScreen(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _owlRotation.value,
                  child: Transform.scale(scale: _owlScale.value, child: child),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: Image.asset(
                  'assets/logo/logo.png',
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeTransition(
              opacity: _titleFade,
              child: SlideTransition(
                position: _titleSlide,
                child: const Text(
                  "Alifbo & Lug'at",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            FadeTransition(
              opacity: _taglineFade,
              child: const Text(
                'Eshit • Ko\'r • Chiz',
                style: TextStyle(fontSize: 15, color: Colors.white70, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 40),
            FadeTransition(
              opacity: _taglineFade,
              child: const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
