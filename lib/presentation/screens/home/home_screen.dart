import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app.dart';
import '../../../core/ads/ads_service.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/banner_ad_view.dart';
import '../../widgets/basics.dart';
import '../../widgets/parent_gate.dart';
import '../../../data/content/alphabets.dart';
import '../../bloc/progress_cubit.dart';
import '../../bloc/settings_cubit.dart';
import '../alphabet/alphabet_screen.dart';
import '../games/games_screen.dart';
import '../lessons/lesson_path_screen.dart';
import '../parent/parent_screen.dart';
import '../quiz/quiz_screen.dart';
import '../tales/tales_screen.dart';
import '../words/words_screen.dart';
import 'script_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => AudioService.instance.music(Music.home));
  }

  /// Ichki sahifadan qaytganda bosh sahifa musiqasini tiklaydi.
  Future<void> _open(Widget page) async {
    AdsService.instance.onNavigation();
    await go<void>(context, page);
    if (mounted) AudioService.instance.music(Music.home);
  }

  Future<void> _openParents() async {
    final ok = await showParentGate(context, context.sRead);
    if (ok && mounted) _open(const ParentScreen());
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final settings = context.watch<SettingsCubit>().state;
    final progress = context.watch<ProgressCubit>().state;
    final alphabet = alphabetOf(settings.script);
    final learned = progress.learnedCount(alphabet.id);
    final name = settings.childName;

    return Scaffold(
      body: SoftBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  children: [
                    // --- Yuqori qator: yulduzlar, ketma-ket kunlar, ota-onalar ---
                    Row(
                      children: [
                        _Chip(icon: Icons.star_rounded, color: AppColors.sun, label: '${progress.totalStars}'),
                        const SizedBox(width: 8),
                        _Chip(
                          icon: Icons.local_fire_department_rounded,
                          color: AppColors.coral,
                          label: '${progress.streak}',
                        ),
                        const Spacer(),
                        RoundButton(
                          icon: Icons.family_restroom_rounded,
                          tooltip: s.t('parents'),
                          onTap: _openParents,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // --- Salomlashish ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Ziko(mood: ZikoMood.hello, size: 96),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 18),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(22),
                                topRight: Radius.circular(22),
                                bottomRight: Radius.circular(22),
                                bottomLeft: Radius.circular(6),
                              ),
                              boxShadow: [BoxShadow(color: AppColors.line, offset: const Offset(0, 4))],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name.isEmpty ? s.t('hello') : s.t('helloName', [s.uzText(name)]),
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                                ),
                                Text(s.t('homeQuestion'), style: const TextStyle(fontSize: 15, color: AppColors.inkSoft)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // --- Alifbo (asosiy karta) ---
                    _HeroCard(
                      title: s.t('secAlphabet'),
                      subtitle: s.t(alphabet.titleKey),
                      badge: alphabet.badge,
                      color: alphabet.color,
                      progress: learned / alphabet.letters.length,
                      progressLabel: s.t('learnedOf', [learned, alphabet.letters.length]),
                      onTap: () => _open(const AlphabetScreen()),
                      onSwitch: () => showScriptPicker(context),
                      switchLabel: s.t('chooseScript'),
                    ),
                    const SizedBox(height: 14),
                    // --- Bo'limlar ---
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.98,
                      children: [
                        _SectionCard(
                          title: s.t('secLessons'),
                          subtitle: s.t('secLessonsSub'),
                          icon: 'trophy',
                          color: AppColors.coral,
                          badge: '${progress.lessonsDone(alphabet.id)}/12',
                          onTap: () => _open(const LessonPathScreen()),
                        ),
                        _SectionCard(
                          title: s.t('secGames'),
                          subtitle: s.t('secGamesSub'),
                          icon: 'joystick',
                          color: AppColors.grape,
                          onTap: () => _open(const GamesScreen()),
                        ),
                        _SectionCard(
                          title: s.t('secWords'),
                          subtitle: s.t('secWordsSub'),
                          icon: 'books',
                          color: AppColors.leaf,
                          onTap: () => _open(const WordsScreen()),
                        ),
                        _SectionCard(
                          title: s.t('secQuiz'),
                          subtitle: s.t('secQuizSub'),
                          icon: 'brain',
                          color: AppColors.sky,
                          onTap: () => _open(const QuizScreen()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _WideCard(
                      title: s.t('secTales'),
                      subtitle: s.t('secTalesSub'),
                      color: AppColors.berry,
                      onTap: () => _open(const TalesScreen()),
                    ),
                  ],
                ),
              ),
              const BannerAdView(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.color, required this.label});
  final IconData icon;
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 6, 14, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: AppColors.line, offset: const Offset(0, 3))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.color,
    required this.progress,
    required this.progressLabel,
    required this.onTap,
    required this.onSwitch,
    required this.switchLabel,
  });

  final String title, subtitle, badge, progressLabel, switchLabel;
  final Color color;
  final double progress;
  final VoidCallback onTap, onSwitch;

  @override
  Widget build(BuildContext context) {
    return Bouncy(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 18, 16, 18),
        decoration: BoxDecoration(
          gradient: AppColors.gradient(color),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: AppColors.shade(color), offset: const Offset(0, 6))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white)),
                  const SizedBox(height: 4),
                  Bouncy(
                    onTap: onSwitch,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12, 6, 8, 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              subtitle,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                          ),
                          const Icon(Icons.expand_more_rounded, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      minHeight: 10,
                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(progressLabel,
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Colors.white.withValues(alpha: 0.9))),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
              alignment: Alignment.center,
              child: Text(
                badge,
                style: TextStyle(fontFamily: AppFonts.letters, fontSize: 50, fontWeight: FontWeight.w700, color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.badge,
  });

  final String title, subtitle, icon;
  final Color color;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Bouncy(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppColors.tint(color, 0.7), width: 2),
          boxShadow: [BoxShadow(color: AppColors.tint(color, 0.55), offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.tint(color, 0.85), borderRadius: BorderRadius.circular(20)),
                  child: Image.asset('assets/images/icons/$icon.png'),
                ),
                const Spacer(),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
                    child: Text(badge!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
                  ),
              ],
            ),
            const Spacer(),
            Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: AppColors.shade(color, 0.25))),
            Text(subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13.5, color: AppColors.inkSoft)),
          ],
        ),
      ),
    );
  }
}

class _WideCard extends StatelessWidget {
  const _WideCard({required this.title, required this.subtitle, required this.color, required this.onTap});
  final String title, subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Bouncy(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: AppColors.night,
          borderRadius: BorderRadius.circular(26),
          boxShadow: const [BoxShadow(color: Color(0xFF15133A), offset: Offset(0, 5))],
        ),
        child: Row(
          children: [
            const Ziko(mood: ZikoMood.sleep, size: 64, bob: false),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: Colors.white)),
                  Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.75))),
                ],
              ),
            ),
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}
