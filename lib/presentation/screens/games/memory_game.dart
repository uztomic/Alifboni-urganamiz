import 'dart:math';

import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/voice_lines.dart';
import '../../../domain/entities/alphabet.dart';
import '../../widgets/activity_scope.dart';
import '../../widgets/basics.dart';
import 'game_common.dart';

class _Card {
  _Card(this.pairId, this.label, this.letter);
  final int pairId;
  final String label;
  final Letter letter;
  bool open = false;
  bool matched = false;
}

/// "Juftini top": katta va kichik harf juftlarini topish (6 juft).
class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key, required this.alphabet});
  final Alphabet alphabet;

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  static const _pairs = 6;
  final _r = Random();
  late List<_Card> _cards;
  final List<int> _open = [];
  int _moves = 0;
  int _found = 0;
  bool _busy = false;
  int _confetti = 0;

  @override
  void initState() {
    super.initState();
    final letters = (widget.alphabet.realLetters.where((l) => l.upper != l.lower).toList()..shuffle(_r)).take(_pairs).toList();
    _cards = [
      for (var i = 0; i < letters.length; i++) ...[
        _Card(i, letters[i].upper, letters[i]),
        _Card(i, letters[i].lower, letters[i]),
      ],
    ]..shuffle(_r);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.alphabet.id.isUzbek) {
        AudioService.instance.say(Lines.memoryIntro.$1);
      }
    });
  }

  Future<void> _flip(int i) async {
    final c = _cards[i];
    if (_busy || c.open || c.matched) return;
    AudioService.instance.play(Sfx.flip);
    setState(() {
      c.open = true;
      _open.add(i);
    });
    if (_open.length < 2) {
      AudioService.instance.say(c.letter.say, lang: c.letter.sayLang);
      return;
    }
    _busy = true;
    _moves++;
    final a = _cards[_open[0]], b = _cards[_open[1]];
    if (a.pairId == b.pairId) {
      AudioService.instance.play(Sfx.match);
      await Future<void>.delayed(const Duration(milliseconds: 350));
      if (!mounted) return;
      setState(() {
        a.matched = b.matched = true;
        _found++;
        _confetti++;
      });
      if (widget.alphabet.id.isUzbek && _found < _pairs) {
        AudioService.instance.say(Lines.memoryHit.$1);
      } else {
        AudioService.instance.say(b.letter.say, lang: b.letter.sayLang);
      }
      _open.clear();
      _busy = false;
      if (_found == _pairs) _win();
    } else {
      await Future<void>.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;
      setState(() {
        a.open = b.open = false;
      });
      _open.clear();
      _busy = false;
    }
  }

  Future<void> _win() async {
    final s = context.sRead;
    final line = Praise.allPairs(context.uiLang);
    await AudioService.instance.say(line.$1, lang: line.$2);
    if (!mounted) return;
    final stars = _moves <= _pairs + 3 ? 3 : (_moves <= _pairs * 2 + 2 ? 2 : 1);
    await finishGame(
      context,
      title: s.t('g_memory'),
      color: AppColors.grape,
      stars: stars,
      correct: _pairs,
      total: _moves,
      retry: () => MemoryGame(alphabet: widget.alphabet),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return ActivityScope(
      music: Music.games,
      child: Scaffold(
        body: SoftBackground(
          accent: AppColors.grape,
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    ScreenHeader(
                      title: s.t('g_memory'),
                      trailing: Text(s.t('moves', [_moves]), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: StepBar(value: _found / _pairs, color: AppColors.grape),
                    ),
                    Expanded(
                      child: LayoutBuilder(builder: (context, c) {
                        const cols = 3;
                        final rows = (_cards.length / cols).ceil();
                        final w = (c.maxWidth - 24 * 2 - 12 * (cols - 1)) / cols;
                        final h = (c.maxHeight - 24 - 12 * (rows - 1)) / rows;
                        final size = min(w, h / 1.15);
                        return Center(
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: [
                              for (var i = 0; i < _cards.length; i++)
                                _FlipCard(card: _cards[i], width: size, height: size * 1.15, onTap: () => _flip(i)),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                Positioned.fill(child: Confetti(trigger: _confetti)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FlipCard extends StatelessWidget {
  const _FlipCard({required this.card, required this.width, required this.height, required this.onTap});
  final _Card card;
  final double width, height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final faceUp = card.open || card.matched;
    return Bouncy(
      onTap: onTap,
      sound: null,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: faceUp ? 1 : 0),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInOut,
        builder: (_, t, __) {
          final showFront = t >= 0.5;
          final angle = t * pi;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0015)
              ..rotateY(angle),
            child: showFront
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: _face(front: true),
                  )
                : _face(front: false),
          );
        },
      ),
    );
  }

  Widget _face({required bool front}) {
    final matched = card.matched;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: front ? null : AppColors.gradient(AppColors.grape),
        color: front ? (matched ? const Color(0xFFE5F8EC) : Colors.white) : null,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: front ? (matched ? AppColors.correct : AppColors.tint(AppColors.grape, 0.5)) : Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: front ? AppColors.tint(AppColors.grape, 0.6) : AppColors.shade(AppColors.grape),
            offset: const Offset(0, 5),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: front
          ? FittedBox(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(card.label,
                    style: TextStyle(
                        fontFamily: AppFonts.letters,
                        fontSize: 60,
                        fontWeight: FontWeight.w700,
                        color: matched ? AppColors.correct : AppColors.ink)),
              ),
            )
          : Image.asset('assets/images/icons/question.png', width: width * 0.45),
    );
  }
}
