import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app.dart';
import '../../../core/ads/ads_service.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/voice_lines.dart';
import '../../../domain/services/lesson_engine.dart';
import '../../bloc/lesson_cubit.dart';
import '../../widgets/activity_scope.dart';
import '../../widgets/basics.dart';
import 'question_views.dart';
import 'result_screen.dart';

/// Dars yoki test o'ynatgichi. Mantiq — [LessonCubit] da, bu yerda faqat
/// ko'rinish, ovoz va animatsiya.
class LessonScreen extends StatelessWidget {
  const LessonScreen({
    super.key,
    required this.title,
    required this.color,
    required this.buildQuestions,
    required this.onSave,
    this.intro = const [],
    this.next,
    this.music = Music.lesson,
  });

  final String title;
  final Color color;
  final List<Question> Function() buildQuestions;

  /// Natija (0..3 yulduz) saqlanadi.
  final void Function(BuildContext context, int stars) onSave;

  /// Dars boshida o'qiladigan tushuntirish.
  final List<Line> intro;

  /// "Keyingi dars" tugmasi uchun (bo'lsa).
  final LessonScreen Function()? next;
  final Music music;

  @override
  Widget build(BuildContext context) {
    return ActivityScope(
      music: music,
      child: BlocProvider(
        create: (_) => LessonCubit(buildQuestions(), skipIntro: intro.isEmpty),
        child: _LessonView(config: this),
      ),
    );
  }
}

class _LessonView extends StatefulWidget {
  const _LessonView({required this.config});
  final LessonScreen config;

  @override
  State<_LessonView> createState() => _LessonViewState();
}

class _LessonViewState extends State<_LessonView> {
  int _confetti = 0;
  int _shake = 0;
  bool _advancing = false;
  bool _finishing = false;

  LessonScreen get cfg => widget.config;
  LessonCubit get cubit => context.read<LessonCubit>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (cubit.state.phase == LessonPhase.intro) {
        AudioService.instance.sayAll(cfg.intro);
      } else {
        _speakPrompt();
      }
    });
  }

  void _speakPrompt() {
    final st = cubit.state;
    if (st.phase != LessonPhase.playing || st.questions.isEmpty) return;
    final q = st.current;
    if (q.voice.isNotEmpty) AudioService.instance.sayAll(q.voice);
  }

  void _start() {
    AudioService.instance.stopVoice();
    cubit.start();
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) _speakPrompt();
    });
  }

  Future<void> _onSolved({Line? say}) async {
    if (_advancing) return;
    _advancing = true;
    HapticFeedback.lightImpact();
    AudioService.instance.play(Sfx.correct);
    setState(() => _confetti++);
    final ui = context.uiLang;
    final line = say ?? Praise.good(ui);
    final started = DateTime.now();
    await AudioService.instance.say(line.$1, lang: line.$2);
    final spent = DateTime.now().difference(started);
    if (spent < const Duration(milliseconds: 900)) {
      await Future<void>.delayed(const Duration(milliseconds: 900) - spent);
    }
    if (!mounted) return;
    _advancing = false;
    cubit.next();
    if (cubit.state.phase == LessonPhase.playing) {
      _speakPrompt();
    }
  }

  void _onWrong() {
    HapticFeedback.heavyImpact();
    AudioService.instance.play(Sfx.wrong);
    setState(() => _shake++);
    if (cubit.state.mistakesHere == 1) {
      final line = Praise.wrong(context.uiLang);
      AudioService.instance.say(line.$1, lang: line.$2);
    }
  }

  Future<void> _finish(LessonState st) async {
    if (_finishing) return;
    _finishing = true;
    final stars = st.stars;
    cfg.onSave(context, stars);
    AudioService.instance.play(Sfx.levelComplete);
    final done = Praise.lessonDone(context.uiLang);
    unawaited(AudioService.instance.say(done.$1, lang: done.$2));
    await Future<void>.delayed(const Duration(milliseconds: 700));
    await AdsService.instance.onActivityCompleted();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(softRoute(ResultScreen(
      title: cfg.title,
      color: cfg.color,
      stars: stars,
      correct: st.firstTryCorrect,
      total: st.total,
      retry: () => LessonScreen(
        title: cfg.title,
        color: cfg.color,
        buildQuestions: cfg.buildQuestions,
        onSave: cfg.onSave,
        intro: const [],
        next: cfg.next,
        music: cfg.music,
      ),
      next: cfg.next,
    )));
  }

  Future<bool> _confirmQuit() async {
    final s = context.sRead;
    final st = cubit.state;
    if (st.phase != LessonPhase.playing || st.index == 0) return true;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.t('quitTitle'), style: const TextStyle(fontWeight: FontWeight.w900)),
        content: Text(s.t('quitBody')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(s.t('quitYes'))),
          FilledButton(onPressed: () => Navigator.pop(ctx, false), child: Text(s.t('quitNo'))),
        ],
      ),
    );
    return ok ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return BlocConsumer<LessonCubit, LessonState>(
      listenWhen: (a, b) => a.phase != b.phase,
      listener: (context, st) {
        if (st.phase == LessonPhase.finished) _finish(st);
      },
      builder: (context, st) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;
            if (await _confirmQuit() && context.mounted) Navigator.of(context).pop();
          },
          child: Scaffold(
            body: SoftBackground(
              accent: cfg.color,
              child: SafeArea(
                child: Stack(
                  children: [
                    if (st.phase == LessonPhase.intro)
                      _IntroPanel(title: cfg.title, color: cfg.color, onStart: _start, onClose: () => Navigator.of(context).pop())
                    else if (st.questions.isEmpty)
                      Center(child: Text(s.t('done')))
                    else
                      _QuestionPanel(
                        st: st,
                        color: cfg.color,
                        shake: _shake,
                        onClose: () async {
                          if (await _confirmQuit() && context.mounted) Navigator.of(context).pop();
                        },
                        onReplay: _speakPrompt,
                        onPick: (i) {
                          final q = st.current as ChoiceQuestion;
                          if (cubit.choose(i)) {
                            _onSolved(say: q.onCorrect);
                          } else {
                            _onWrong();
                          }
                        },
                        onBuilt: () {
                          final q = st.current as BuildQuestion;
                          cubit.complete();
                          _onSolved(say: q.word);
                        },
                        onMistake: () {
                          cubit.mistake();
                          if (cubit.state.mistakesHere == 1) {
                            final line = Praise.wrong(context.uiLang);
                            AudioService.instance.say(line.$1, lang: line.$2);
                          }
                        },
                        onTraced: () {
                          cubit.complete();
                          _onSolved();
                        },
                        onIntroNext: () {
                          cubit.complete();
                          cubit.next();
                          _speakPrompt();
                        },
                      ),
                    Positioned.fill(child: Confetti(trigger: _confetti)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _IntroPanel extends StatelessWidget {
  const _IntroPanel({required this.title, required this.color, required this.onStart, required this.onClose});
  final String title;
  final Color color;
  final VoidCallback onStart, onClose;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: RoundButton(icon: Icons.close_rounded, onTap: onClose),
          ),
        ),
        const Spacer(),
        const Ziko(mood: ZikoMood.hello, size: 170),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.shade(color, 0.2))),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: ChunkyButton(label: s.t('start'), color: color, icon: Icons.play_arrow_rounded, onTap: onStart),
        ),
      ],
    );
  }
}

class _QuestionPanel extends StatelessWidget {
  const _QuestionPanel({
    required this.st,
    required this.color,
    required this.shake,
    required this.onClose,
    required this.onReplay,
    required this.onPick,
    required this.onBuilt,
    required this.onMistake,
    required this.onTraced,
    required this.onIntroNext,
  });

  final LessonState st;
  final Color color;
  final int shake;
  final VoidCallback onClose, onReplay, onBuilt, onMistake, onTraced, onIntroNext;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final q = st.current;
    final Widget body = switch (q) {
      final ChoiceQuestion c => ChoiceView(
          key: ValueKey('c${st.index}'),
          q: c,
          color: color,
          wrongPicks: st.wrongPicks,
          solvedIndex: st.solvedIndex,
          onPick: onPick,
          shakeCount: shake,
        ),
      final BuildQuestion b => BuildView(key: ValueKey('b${st.index}'), q: b, color: color, onDone: onBuilt, onMistake: onMistake),
      final TraceQuestion t => TraceView(key: ValueKey('t${st.index}'), q: t, color: color, onDone: onTraced),
      final IntroQuestion i => IntroView(key: ValueKey('i${st.index}'), q: i, color: color, onReplay: onReplay),
    };

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          child: Row(
            children: [
              RoundButton(icon: Icons.close_rounded, onTap: onClose),
              const SizedBox(width: 14),
              Expanded(child: StepBar(value: st.progress, color: color)),
              const SizedBox(width: 12),
              Text(s.t('questionOf', [st.index + 1, st.total]),
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  q.text,
                  style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900, height: 1.25),
                ),
              ),
              if (q.voice.isNotEmpty || q is IntroQuestion) ...[
                const SizedBox(width: 10),
                RoundButton(icon: Icons.volume_up_rounded, color: color, iconColor: Colors.white, onTap: onReplay),
              ],
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: ScaleTransition(scale: Tween(begin: 0.96, end: 1.0).animate(anim), child: child),
              ),
              child: body,
            ),
          ),
        ),
        if (q is IntroQuestion)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: ChunkyButton(label: s.t('next'), color: color, icon: Icons.arrow_forward_rounded, onTap: onIntroNext),
          ),
      ],
    );
  }
}
