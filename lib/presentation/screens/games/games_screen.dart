import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/content/alphabets.dart';
import '../../../data/content/emoji_index.dart';
import '../../../data/content/lessons.dart';
import '../../../domain/services/lesson_engine.dart';
import '../../bloc/progress_cubit.dart';
import '../../bloc/settings_cubit.dart';
import '../../widgets/banner_ad_view.dart';
import '../../widgets/basics.dart';
import '../home/script_picker.dart';
import '../lessons/lesson_screen.dart';
import 'balloon_game.dart';
import 'memory_game.dart';
import 'train_game.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final a = alphabetOf(context.watch<SettingsCubit>().state.script);

    final List<(String, String, String, Color, Widget Function())> games = [
      (s.t('g_balloons'), s.t('g_balloonsSub'), 'balloon', AppColors.coral, () => BalloonGame(alphabet: a)),
      (s.t('g_memory'), s.t('g_memorySub'), 'cards', AppColors.grape, () => MemoryGame(alphabet: a)),
      (s.t('g_train'), s.t('g_trainSub'), 'locomotive', AppColors.sun, () => TrainGame(alphabet: a)),
      (
        s.t('g_picture'),
        s.t('g_pictureSub'),
        'puzzle',
        AppColors.leaf,
        () => LessonScreen(
              title: s.t('g_picture'),
              color: AppColors.leaf,
              music: Music.games,
              buildQuestions: () => LessonEngine(
                alphabet: a,
                s: s,
                hasVoice: AudioService.instance.hasVoice,
                sentences: sentences,
                emojiFor: emojiForWord,
              ).build(LessonType.firstLetter),
              onSave: (ctx, _) => ctx.read<ProgressCubit>().gamePlayed(),
            ),
      ),
    ];

    return Scaffold(
      body: SoftBackground(
        accent: AppColors.grape,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              ScreenHeader(
                title: s.t('secGames'),
                trailing: Bouncy(
                  onTap: () => showScriptPicker(context),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 6, 6, 6),
                    decoration: BoxDecoration(color: a.color, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(a.badge,
                            style: const TextStyle(
                                fontFamily: AppFonts.letters, fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                        const Icon(Icons.expand_more_rounded, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  children: [
                    for (final (title, sub, icon, color, page) in games)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Bouncy(
                          onTap: () => go<void>(context, page()),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              gradient: AppColors.gradient(color),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [BoxShadow(color: AppColors.shade(color), offset: const Offset(0, 6))],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 84,
                                  height: 84,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
                                  child: Image.asset('assets/images/icons/$icon.png'),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(title,
                                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                                      const SizedBox(height: 2),
                                      Text(sub,
                                          style: TextStyle(
                                              fontSize: 14.5, fontWeight: FontWeight.w700, color: Colors.white.withValues(alpha: 0.9))),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 40),
                              ],
                            ),
                          ),
                        ),
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
