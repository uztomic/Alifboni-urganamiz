import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_page_route.dart';
import '../../../core/widgets/banner_ad_widget.dart';
import '../../../core/widgets/big_action_card.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/mascot_bubble.dart';
import '../../../core/widgets/playful_background.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../alphabet/presentation/alphabet_select_screen.dart';
import '../../nature/presentation/nature_category_screen.dart';
import '../../progress/bloc/progress_cubit.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../vocabulary/presentation/category_select_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final streak = context.watch<ProgressCubit>().state.streak;

    return Scaffold(
      body: PlayfulBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: FadeSlideIn(
                  child: Row(
                    children: [
                      Expanded(child: MascotBubble(message: l10n.appTitle)),
                      const SizedBox(width: 8),
                      _StreakBadge(streak: streak, label: l10n.homeStreakLabel(streak)),
                      const SizedBox(width: 8),
                      _RoundIconButton(
                        icon: Icons.settings_rounded,
                        tooltip: l10n.homeSettings,
                        onPressed: () => pushAnimated(context, const SettingsScreen()),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: FadeSlideIn(
                                  index: 0,
                                  baseDelay: const Duration(milliseconds: 90),
                                  child: AspectRatio(
                                    aspectRatio: 0.92,
                                    child: BigActionCard(
                                      emoji: '🔤',
                                      title: l10n.homeAlphabetModule,
                                      subtitle: l10n.homeAlphabetModuleSubtitle,
                                      color: AppColors.primary,
                                      onTap: () =>
                                          pushAnimated(context, const AlphabetSelectScreen()),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: FadeSlideIn(
                                  index: 1,
                                  baseDelay: const Duration(milliseconds: 90),
                                  child: AspectRatio(
                                    aspectRatio: 0.92,
                                    child: BigActionCard(
                                      emoji: '📚',
                                      title: l10n.homeVocabularyModule,
                                      subtitle: l10n.homeVocabularyModuleSubtitle,
                                      color: AppColors.secondary,
                                      onTap: () =>
                                          pushAnimated(context, const CategorySelectScreen()),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          FadeSlideIn(
                            index: 2,
                            baseDelay: const Duration(milliseconds: 90),
                            child: _WideActionCard(
                              emoji: '🌿',
                              title: l10n.homeNatureModule,
                              subtitle: l10n.homeNatureModuleSubtitle,
                              color: AppColors.green,
                              onTap: () => pushAnimated(context, const NatureCategoryScreen()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const BannerAdWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class _WideActionCard extends StatefulWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _WideActionCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  State<_WideActionCard> createState() => _WideActionCardState();
}

class _WideActionCardState extends State<_WideActionCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            gradient: AppColors.gradientFor(widget.color),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
            boxShadow: [
              BoxShadow(color: widget.color.withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 8)),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.28),
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text(widget.emoji, style: const TextStyle(fontSize: 32))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: GoogleFonts.baloo2(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.9)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.24),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  const _RoundIconButton({required this.icon, required this.tooltip, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(),
      elevation: 2,
      child: IconButton(
        tooltip: tooltip,
        icon: Icon(icon, size: 24, color: AppColors.textDark),
        onPressed: onPressed,
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  final int streak;
  final String label;
  const _StreakBadge({required this.streak, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: AppColors.gradientFor(AppColors.yellow),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: AppColors.yellow.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 18)),
          const SizedBox(width: 4),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: child,
            ),
            child: Text(
              '$streak',
              key: ValueKey(streak),
              style: GoogleFonts.baloo2(fontWeight: FontWeight.w800, fontSize: 16, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}
