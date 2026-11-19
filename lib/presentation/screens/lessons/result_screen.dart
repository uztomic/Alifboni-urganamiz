import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/basics.dart';
import '../../widgets/review_prompt.dart';

/// Dars/test natijasi: yulduzlar, Ziko va keyingi qadam.
class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.title,
    required this.color,
    required this.stars,
    required this.correct,
    required this.total,
    required this.retry,
    this.next,
  });

  final String title;
  final Color color;
  final int stars;
  final int correct;
  final int total;
  final Widget Function() retry;
  final Widget Function()? next;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..forward();
  int _confetti = 0;

  @override
  void initState() {
    super.initState();
    AudioService.instance.music(Music.calm);
    for (var i = 0; i < widget.stars; i++) {
      Future.delayed(Duration(milliseconds: 350 + i * 330), () {
        if (mounted) AudioService.instance.play(Sfx.star);
      });
    }
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _confetti++);
    });
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) maybeAskForReview(context);
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final headline = switch (widget.stars) {
      3 => s.t('resGreat'),
      2 => s.t('resGood'),
      _ => s.t('resTry'),
    };
    return Scaffold(
      body: SoftBackground(
        accent: widget.color,
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Spacer(),
                    Ziko(mood: widget.stars >= 2 ? ZikoMood.happy : ZikoMood.think, size: 160),
                    const SizedBox(height: 12),
                    Text(headline, style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(widget.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, color: AppColors.inkSoft)),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var i = 0; i < 3; i++)
                          AnimatedBuilder(
                            animation: _c,
                            builder: (_, __) {
                              final start = 0.2 + i * 0.22;
                              final t = ((_c.value - start) / 0.25).clamp(0.0, 1.0);
                              final scale = Curves.elasticOut.transform(t);
                              final got = i < widget.stars;
                              return Transform.scale(
                                scale: got ? scale : 1,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: i == 1 ? 24 : 0),
                                  child: Icon(
                                    Icons.star_rounded,
                                    size: i == 1 ? 96 : 76,
                                    color: got ? AppColors.sun : const Color(0xFFE2DACB),
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(s.t('resCorrect', [widget.correct, widget.total]),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    if (widget.next != null) ...[
                      ChunkyButton(
                        label: s.t('nextLesson'),
                        color: widget.color,
                        icon: Icons.arrow_forward_rounded,
                        onTap: () => Navigator.of(context).pushReplacement(softRoute(widget.next!())),
                      ),
                      const SizedBox(height: 14),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: ChunkyButton(
                            label: s.t('again'),
                            color: AppColors.sky,
                            icon: Icons.refresh_rounded,
                            onTap: () => Navigator.of(context).pushReplacement(softRoute(widget.retry())),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ChunkyButton(
                            label: s.t('toMenu'),
                            color: AppColors.inkSoft,
                            icon: Icons.home_rounded,
                            onTap: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned.fill(child: Confetti(trigger: _confetti)),
            ],
          ),
        ),
      ),
    );
  }
}
