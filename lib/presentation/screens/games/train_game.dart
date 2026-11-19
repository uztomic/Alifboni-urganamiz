import 'dart:math';

import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/voice_lines.dart';
import '../../../domain/entities/alphabet.dart';
import '../../widgets/activity_scope.dart';
import '../../widgets/basics.dart';
import '../lessons/question_views.dart';
import 'game_common.dart';

/// "Harf poyezdi": vagonlarni alifbo tartibida ulash. 3 bosqich × 5 harf.
class TrainGame extends StatefulWidget {
  const TrainGame({super.key, required this.alphabet});
  final Alphabet alphabet;

  @override
  State<TrainGame> createState() => _TrainGameState();
}

class _TrainGameState extends State<TrainGame> with SingleTickerProviderStateMixin {
  static const _rounds = 3;
  static const _len = 5;
  final _r = Random();
  late final AnimationController _drive =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));

  int _round = 0;
  late List<Letter> _seq;
  late List<Letter> _pool;
  int _placed = 0;
  int _mistakes = 0;
  int _shakeIdx = -1;
  int _shake = 0;
  bool _driving = false;

  @override
  void initState() {
    super.initState();
    _newRound();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.alphabet.id.isUzbek) AudioService.instance.say(Lines.orderIntro.$1);
    });
  }

  @override
  void dispose() {
    _drive.dispose();
    super.dispose();
  }

  void _newRound() {
    final letters = widget.alphabet.realLetters;
    final start = _r.nextInt(max(1, letters.length - _len));
    _seq = letters.sublist(start, min(letters.length, start + _len));
    _pool = [..._seq]..shuffle(_r);
    _placed = 0;
    _drive.value = 0;
  }

  Future<void> _tap(int i) async {
    if (_driving) return;
    final l = _pool[i];
    if (l == _seq[_placed]) {
      AudioService.instance.play(Sfx.pop);
      AudioService.instance.say(l.say, lang: l.sayLang);
      setState(() => _placed++);
      if (_placed == _seq.length) await _go();
    } else if (!_isPlaced(l)) {
      AudioService.instance.play(Sfx.wrong);
      setState(() {
        _mistakes++;
        _shakeIdx = i;
        _shake++;
      });
    }
  }

  bool _isPlaced(Letter l) => _seq.indexOf(l) < _placed;

  Future<void> _go() async {
    _driving = true;
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    AudioService.instance.play(Sfx.train);
    final line = widget.alphabet.id.isUzbek ? Lines.trainGo : Praise.good(context.uiLang);
    AudioService.instance.say(line.$1, lang: line.$2);
    await _drive.forward();
    if (!mounted) return;
    if (_round >= _rounds - 1) {
      final s = context.sRead;
      final stars = _mistakes <= 1 ? 3 : (_mistakes <= 4 ? 2 : 1);
      await finishGame(
        context,
        title: s.t('g_train'),
        color: AppColors.sun,
        stars: stars,
        correct: _rounds * _len,
        total: _rounds * _len + _mistakes,
        retry: () => TrainGame(alphabet: widget.alphabet),
      );
      return;
    }
    setState(() {
      _round++;
      _newRound();
      _driving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return ActivityScope(
      music: Music.games,
      child: Scaffold(
        body: SoftBackground(
          accent: AppColors.sun,
          child: SafeArea(
            child: Column(
              children: [
                ScreenHeader(
                  title: s.t('g_train'),
                  trailing: Text(s.t('round', [_round + 1]), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
                  child: Text(s.t('tapLettersInOrder'),
                      textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                ),
                const Spacer(),
                // Poyezd
                LayoutBuilder(builder: (context, c) {
                  final wagon = min(64.0, (c.maxWidth - 40 - 90) / _seq.length - 6);
                  return AnimatedBuilder(
                    animation: _drive,
                    builder: (_, child) => Transform.translate(
                      offset: Offset(Curves.easeInCubic.transform(_drive.value) * (c.maxWidth + 200), 0),
                      child: child,
                    ),
                    child: SizedBox(
                      height: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          for (var i = _seq.length - 1; i >= 0; i--) ...[
                            _Wagon(
                              size: wagon,
                              label: i < _placed ? _seq[i].upper : null,
                              highlight: i == _placed,
                            ),
                            const SizedBox(width: 6),
                          ],
                          // Rasm chapga qaragan — poyezd o'ngga yuradi, shuning uchun aylantiramiz.
                          Transform.flip(
                            flipX: true,
                            child: Image.asset('assets/images/icons/locomotive.png', width: 90, height: 90),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                Container(
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: const Color(0xFF8B6B4A), borderRadius: BorderRadius.circular(5)),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (var i = 0; i < _pool.length; i++)
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _isPlaced(_pool[i]) ? 0.15 : 1,
                          child: Shake(
                            trigger: _shakeIdx == i ? _shake : 0,
                            child: Bouncy(
                              onTap: _isPlaced(_pool[i]) ? null : () => _tap(i),
                              sound: null,
                              child: Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.tint(AppColors.sun, 0.3), width: 3),
                                  boxShadow: [BoxShadow(color: AppColors.tint(AppColors.sun, 0.4), offset: const Offset(0, 5))],
                                ),
                                alignment: Alignment.center,
                                child: Text(_pool[i].upper,
                                    style: const TextStyle(
                                        fontFamily: AppFonts.letters, fontSize: 38, fontWeight: FontWeight.w700, color: AppColors.ink)),
                              ),
                            ),
                          ),
                        ),
                    ],
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

class _Wagon extends StatelessWidget {
  const _Wagon({required this.size, required this.label, required this.highlight});
  final double size;
  final String? label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final filled = label != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: filled ? AppColors.coral : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: highlight ? AppColors.sun : AppColors.shade(AppColors.coral, 0.1), width: highlight ? 4 : 2),
          ),
          alignment: Alignment.center,
          child: filled
              ? FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(label!,
                        style: const TextStyle(
                            fontFamily: AppFonts.letters, fontSize: 34, fontWeight: FontWeight.w700, color: Colors.white)),
                  ),
                )
              : null,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _wheel(size),
            SizedBox(width: size * 0.25),
            _wheel(size),
          ],
        ),
      ],
    );
  }

  Widget _wheel(double s) => Container(
        width: s * 0.28,
        height: s * 0.28,
        decoration: BoxDecoration(
          color: AppColors.ink,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      );
}
