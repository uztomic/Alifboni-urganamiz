import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app.dart';
import '../../../core/l10n/strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/content/emoji_index.dart';
import '../../../data/content/quizzes.dart';
import '../../../domain/services/quiz_builder.dart';
import '../../bloc/progress_cubit.dart';
import '../../widgets/banner_ad_view.dart';
import '../../widgets/basics.dart';
import '../lessons/lesson_screen.dart';

LessonScreen _quizScreen(QuizTopic t, S s, int index) => LessonScreen(
      title: s.t(t.id),
      color: t.color,
      buildQuestions: () => buildQuiz(t, s: s, emojiFor: emojiForWord),
      onSave: (context, stars) => context.read<ProgressCubit>().saveQuiz(t.id, stars),
      next: index < quizTopics.length - 1 ? () => _quizScreen(quizTopics[index + 1], s, index + 1) : null,
    );

/// "Bilimdon" — Ziyrak darslaridan savol-javob mavzulari.
class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final progress = context.watch<ProgressCubit>().state;
    return Scaffold(
      body: SoftBackground(
        accent: AppColors.sky,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              ScreenHeader(title: s.t('quizTitle')),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  children: [
                    Row(
                      children: [
                        const Ziko(mood: ZikoMood.think, size: 76),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            s.isUzbek ? s.t('quizIntro') : '${s.t('quizIntro')} ${s.t('onlyUzbek')}',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.inkSoft),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: quizTopics.length,
                      itemBuilder: (context, i) {
                        final t = quizTopics[i];
                        return TopicCard(
                          title: s.t(t.id),
                          subtitle: '${t.items.length}',
                          icon: t.icon,
                          color: t.color,
                          stars: progress.quizStars[t.id] ?? 0,
                          onTap: () => go<void>(context, _quizScreen(t, s, i)),
                        );
                      },
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

/// Mavzu kartochkasi (Bilimdon, So'zlar, O'yinlar uchun umumiy).
class TopicCard extends StatelessWidget {
  const TopicCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.subtitle,
    this.stars,
  });

  final String title, icon;
  final String? subtitle;
  final Color color;
  final int? stars;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Bouncy(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppColors.tint(color, 0.65), width: 2),
          boxShadow: [BoxShadow(color: AppColors.tint(color, 0.5), offset: const Offset(0, 5))],
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.tint(color, 0.86), borderRadius: BorderRadius.circular(20)),
                child: Image.asset('assets/images/icons/$icon.png'),
              ),
            ),
            const SizedBox(height: 8),
            Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.shade(color, 0.25))),
            if (stars != null) StarRow(stars: stars!, size: 20),
          ],
        ),
      ),
    );
  }
}
