import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/basics.dart';
import '../../bloc/settings_cubit.dart';
import '../home/home_screen.dart';
import '../onboarding/onboarding_screen.dart';

/// Qisqa (0.9 s) brend ekrani. Barcha yuklash main() da tugagan bo'ladi,
/// shuning uchun bu yerda hech narsa kutilmaydi.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 900), _next);
  }

  void _next() {
    if (!mounted) return;
    final onboarded = context.read<SettingsCubit>().state.onboarded;
    Navigator.of(context).pushReplacement(
      softRoute(onboarded ? const HomeScreen() : const OnboardingScreen()),
    );
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Scaffold(
      backgroundColor: AppColors.teal,
      body: Center(
        child: ScaleTransition(
          scale: CurvedAnimation(parent: _c, curve: Curves.easeOutBack),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Ziko(mood: ZikoMood.hello, size: 150, bob: false),
              const SizedBox(height: 18),
              Text(
                s.t('appName'),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
              ),
              const SizedBox(height: 6),
              Text(
                s.t('tagline'),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.85)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
