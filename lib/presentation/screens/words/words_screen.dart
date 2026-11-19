import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/l10n/strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/voice_lines.dart';
import '../../../data/content/words.dart';
import '../../../domain/services/lesson_engine.dart';
import '../../bloc/progress_cubit.dart';
import '../../widgets/banner_ad_view.dart';
import '../../widgets/basics.dart';
import '../lessons/lesson_screen.dart';
import '../quiz/quiz_screen.dart';

/// Lug'at bo'limlari.
class WordsScreen extends StatelessWidget {
  const WordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Scaffold(
      body: SoftBackground(
        accent: AppColors.leaf,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              ScreenHeader(title: s.t('wordsTitle')),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: vocabulary.length,
                  itemBuilder: (context, i) {
                    final c = vocabulary[i];
                    return TopicCard(
                      title: s.t(c.id),
                      icon: c.icon,
                      color: c.color,
                      onTap: () => go<void>(context, CategoryScreen(category: c)),
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

String _translation(VocabWord w, S s) => switch (s.lang) {
      UiLang.ru => w.ru,
      UiLang.en => w.en,
      _ => w.ru,
    };

/// Bitta bo'lim so'zlari.
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key, required this.category});
  final VocabCategory category;

  List<Question> _quiz(S s) {
    final r = Random();
    final words = [...category.words]..shuffle(r);
    return [
      for (final w in words.take(8))
        () {
          final others = (category.words
                  .where((x) => x != w && (x.emoji != w.emoji || x.swatch != w.swatch))
                  .toList()
                ..shuffle(r))
              .take(2);
          final opts = [w, ...others]..shuffle(r);
          return ChoiceQuestion(
            text: s.t('q_listen'),
            voice: [uz(w.uz)],
            style: OptionStyle.picture,
            correct: opts.indexOf(w),
            onCorrect: uz(w.uz),
            options: [for (final o in opts) Option(label: '', emoji: o.emoji, swatch: o.swatch)],
          );
        }(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final c = category;
    return Scaffold(
      body: SoftBackground(
        accent: c.color,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              ScreenHeader(title: s.t(c.id)),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 170,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: c.words.length,
                  itemBuilder: (context, i) {
                    final w = c.words[i];
                    return Bouncy(
                      onTap: () {
                        AudioService.instance.say(w.uz);
                        showWordSheet(context, w, c.color);
                      },
                      sound: null,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [BoxShadow(color: AppColors.tint(c.color, 0.6), offset: const Offset(0, 5))],
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: LayoutBuilder(
                                builder: (_, box) => PictureBadge(
                                  emoji: w.emoji,
                                  swatch: w.swatch,
                                  size: min(box.maxWidth, box.maxHeight) * 0.9,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(s.uzText(w.uz),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                            Text(_translation(w, s),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 13, color: AppColors.inkSoft)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: ChunkyButton(
                  label: s.t('wordsQuiz'),
                  icon: Icons.hearing_rounded,
                  color: c.color,
                  onTap: () => go<void>(
                    context,
                    LessonScreen(
                      title: s.t(c.id),
                      color: c.color,
                      buildQuestions: () => _quiz(s),
                      onSave: (ctx, _) => ctx.read<ProgressCubit>().gamePlayed(),
                      music: Music.games,
                    ),
                  ),
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

/// So'z kartochkasi: uch tilda o'qish.
Future<void> showWordSheet(BuildContext context, VocabWord w, Color color) {
  final s = context.sRead;
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PictureBadge(emoji: w.emoji, swatch: w.swatch, size: 150),
            const SizedBox(height: 16),
            _LangRow(flag: 'UZ', text: s.uzText(w.uz), color: color, onTap: () => AudioService.instance.say(w.uz)),
            _LangRow(
                flag: 'RU', text: w.ru, color: AppColors.sky, onTap: () => AudioService.instance.say(w.ru, lang: VoiceLang.ru)),
            _LangRow(
                flag: 'EN', text: w.en, color: AppColors.berry, onTap: () => AudioService.instance.say(w.en, lang: VoiceLang.en)),
          ],
        ),
      ),
    ),
  );
}

class _LangRow extends StatelessWidget {
  const _LangRow({required this.flag, required this.text, required this.color, required this.onTap});
  final String flag, text;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Bouncy(
        onTap: onTap,
        sound: null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
                child: Text(flag, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(text, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800))),
              Icon(Icons.volume_up_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }
}
