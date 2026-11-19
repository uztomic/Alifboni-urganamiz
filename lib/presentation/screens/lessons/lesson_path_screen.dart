import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/l10n/strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/content/alphabets.dart';
import '../../../data/content/emoji_index.dart';
import '../../../data/content/lessons.dart';
import '../../../domain/entities/alphabet.dart';
import '../../../domain/services/lesson_engine.dart';
import '../../bloc/progress_cubit.dart';
import '../../bloc/settings_cubit.dart';
import '../../widgets/banner_ad_view.dart';
import '../../widgets/basics.dart';
import '../home/script_picker.dart';
import 'lesson_screen.dart';

/// [index]-dars uchun o'ynatgich sahifasini quradi.
LessonScreen buildLessonScreen({
  required Alphabet alphabet,
  required int index,
  required S s,
  required int Function() introOffset,
}) {
  final def = lessons[index];
  return LessonScreen(
    title: s.t(def.titleKey),
    color: def.color,
    intro: alphabet.id.isUzbek ? def.uzIntro() : const [],
    buildQuestions: () => LessonEngine(
      alphabet: alphabet,
      s: s,
      hasVoice: AudioService.instance.hasVoice,
      sentences: sentences,
      emojiFor: emojiForWord,
    ).build(def.type, introOffset: def.type == LessonType.intro ? introOffset() : 0),
    onSave: (context, stars) => context.read<ProgressCubit>().saveLesson(alphabet.id, def.id, stars),
    next: index < lessons.length - 1
        ? () => buildLessonScreen(alphabet: alphabet, index: index + 1, s: s, introOffset: introOffset)
        : null,
  );
}

/// "Harflar vodiysi" — 12 ta dars yo'l bo'ylab.
class LessonPathScreen extends StatelessWidget {
  const LessonPathScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final scriptId = context.watch<SettingsCubit>().state.script;
    final a = alphabetOf(scriptId);
    final progress = context.watch<ProgressCubit>().state;

    // Tavsiya etilgan keyingi dars — birinchi yulduzsiz dars.
    final nextIndex = lessons.indexWhere((l) => progress.starsFor(a.id, l.id) == 0);

    return Scaffold(
      body: SoftBackground(
        accent: AppColors.coral,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              ScreenHeader(
                title: s.t('lessonsTitle'),
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
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
                  itemCount: lessons.length + 1,
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            const Ziko(mood: ZikoMood.think, size: 70),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(s.t('lessonsIntro'),
                                  style: const TextStyle(fontSize: 15, color: AppColors.inkSoft, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      );
                    }
                    final idx = i - 1;
                    final def = lessons[idx];
                    final stars = progress.starsFor(a.id, def.id);
                    // Ilon izi: chap-o'rta-o'ng-o'rta...
                    final shift = math.sin(idx * math.pi / 2) * 0.55;
                    return Align(
                      alignment: Alignment(shift, 0),
                      child: _LessonNode(
                        number: idx + 1,
                        title: s.t(def.titleKey),
                        icon: def.icon,
                        color: def.color,
                        stars: stars,
                        highlight: idx == nextIndex,
                        onTap: () => go<void>(
                          context,
                          buildLessonScreen(
                            alphabet: a,
                            index: idx,
                            s: s,
                            introOffset: context.read<SettingsCubit>().takeIntroOffset,
                          ),
                        ),
                      ),
                    );
                  },
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

class _LessonNode extends StatefulWidget {
  const _LessonNode({
    required this.number,
    required this.title,
    required this.icon,
    required this.color,
    required this.stars,
    required this.highlight,
    required this.onTap,
  });

  final int number;
  final String title, icon;
  final Color color;
  final int stars;
  final bool highlight;
  final VoidCallback onTap;

  @override
  State<_LessonNode> createState() => _LessonNodeState();
}

class _LessonNodeState extends State<_LessonNode> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));

  @override
  void initState() {
    super.initState();
    if (widget.highlight) _c.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _LessonNode old) {
    super.didUpdateWidget(old);
    if (widget.highlight && !_c.isAnimating) _c.repeat(reverse: true);
    if (!widget.highlight && _c.isAnimating) _c.stop();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final done = widget.stars > 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Bouncy(
        onTap: widget.onTap,
        child: SizedBox(
          width: 170,
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _c,
                builder: (_, child) => Transform.scale(scale: 1 + 0.06 * _c.value, child: child),
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: done ? widget.color : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.highlight ? AppColors.sun : AppColors.tint(widget.color, done ? 0.3 : 0.55),
                      width: widget.highlight ? 5 : 3,
                    ),
                    boxShadow: [BoxShadow(color: done ? AppColors.shade(widget.color) : AppColors.tint(widget.color, 0.55), offset: const Offset(0, 6))],
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Image.asset('assets/images/icons/${widget.icon}.png'),
                ),
              ),
              const SizedBox(height: 6),
              StarRow(stars: widget.stars, size: 22),
              Text(
                '${widget.number}. ${widget.title}',
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
