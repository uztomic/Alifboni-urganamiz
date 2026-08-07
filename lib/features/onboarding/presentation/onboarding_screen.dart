import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_languages.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_page_route.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/playful_background.dart';
import '../../home/presentation/home_screen.dart';
import '../../settings/bloc/settings_cubit.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final owlBounce = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.4, end: 1.1)
          .chain(CurveTween(curve: Curves.easeOutBack)), weight: 70),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOut)), weight: 30),
    ]).animate(_controller);

    return Scaffold(
      body: PlayfulBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8),
                ScaleTransition(
                  scale: owlBounce,
                  child: const Text('🦉', style: TextStyle(fontSize: 64)),
                ),
                const SizedBox(height: 12),
                FadeSlideIn(
                  child: Text(
                    "Alifbo & Lug'at",
                    style: GoogleFonts.baloo2(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                FadeSlideIn(
                  baseDelay: const Duration(milliseconds: 80),
                  child: Text(
                    'Choose your language / Tilni tanlang',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(fontSize: 15, color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    itemCount: kInterfaceLanguages.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.5,
                    ),
                    itemBuilder: (context, index) {
                      final lang = kInterfaceLanguages[index];
                      return FadeSlideIn(
                        index: index,
                        baseDelay: const Duration(milliseconds: 45),
                        child: _LanguageCard(
                          language: lang,
                          color: AppColors.forIndex(index),
                          onTap: () {
                            context.read<SettingsCubit>().changeLanguage(lang.locale);
                            pushReplacementAnimated(context, const HomeScreen());
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageCard extends StatefulWidget {
  final InterfaceLanguage language;
  final Color color;
  final VoidCallback onTap;
  const _LanguageCard({required this.language, required this.color, required this.onTap});

  @override
  State<_LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<_LanguageCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.94),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: widget.color.withValues(alpha: 0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(widget.language.flag, style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.language.nativeName,
                style: GoogleFonts.baloo2(fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.textDark),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
