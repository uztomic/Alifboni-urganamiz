import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../../app.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/alphabet.dart';
import '../../widgets/activity_scope.dart';
import '../../widgets/basics.dart';
import 'game_common.dart';

class _Balloon {
  _Balloon({required this.id, required this.x, required this.y, required this.speed, required this.letter, required this.color, required this.phase});
  final int id;
  double x; // 0..1
  double y; // px, pastdan yuqoriga kamayadi
  final double speed; // px/s
  final Letter letter;
  final Color color;
  final double phase;
  bool popped = false;
  double popT = 0;
  int shake = 0;
}

/// "Harf ovi": kerakli harfli sharlarni yorish. 3 bosqich, har birida 5 ta.
class BalloonGame extends StatefulWidget {
  const BalloonGame({super.key, required this.alphabet});
  final Alphabet alphabet;

  @override
  State<BalloonGame> createState() => _BalloonGameState();
}

class _BalloonGameState extends State<BalloonGame> with SingleTickerProviderStateMixin {
  static const _rounds = 3;
  static const _perRound = 5;
  static const _colors = [AppColors.coral, AppColors.sky, AppColors.sun, AppColors.grape, AppColors.leaf, AppColors.berry];

  final _r = Random();
  late final Ticker _ticker = createTicker(_tick);
  final List<_Balloon> _balloons = [];
  Duration _last = Duration.zero;
  double _spawnIn = 0;
  int _nextId = 0;
  Size _size = Size.zero;

  late List<Letter> _targets;
  int _round = 0;
  int _hits = 0;
  int _misses = 0;
  int _totalMisses = 0;
  int _confetti = 0;
  bool _between = false;

  Letter get _target => _targets[_round];

  @override
  void initState() {
    super.initState();
    final letters = widget.alphabet.realLetters..shuffle(_r);
    _targets = letters.take(_rounds).toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _announce();
      _ticker.start();
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _announce() {
    AudioService.instance.sayAll(findLetterVoice(widget.alphabet, _target));
  }

  void _tick(Duration now) {
    final dt = _last == Duration.zero ? 0.016 : (now - _last).inMicroseconds / 1e6;
    _last = now;
    if (_size == Size.zero) return;
    _spawnIn -= dt;
    if (_spawnIn <= 0 && !_between) {
      _spawn();
      _spawnIn = 0.75 + _r.nextDouble() * 0.5;
    }
    for (final b in _balloons) {
      if (b.popped) {
        b.popT += dt * 4;
      } else {
        b.y -= b.speed * dt;
      }
    }
    _balloons.removeWhere((b) => b.y < -140 || b.popT >= 1);
    setState(() {});
  }

  void _spawn() {
    final all = widget.alphabet.realLetters;
    final isTarget = _r.nextDouble() < 0.4;
    final letter = isTarget ? _target : all.where((l) => l != _target).elementAt(_r.nextInt(all.length - 1));
    // Bir-birining ustiga tushmasligi uchun bo'sh ustun tanlaymiz
    double x = 0.12 + _r.nextDouble() * 0.76;
    for (var i = 0; i < 6; i++) {
      final crowded = _balloons.any((b) => (b.x - x).abs() < 0.2 && b.y > _size.height - 160);
      if (!crowded) break;
      x = 0.12 + _r.nextDouble() * 0.76;
    }
    _balloons.add(_Balloon(
      id: _nextId++,
      x: x,
      y: _size.height + 20,
      speed: 90 + _r.nextDouble() * 60 + _round * 18,
      letter: letter,
      color: _colors[_r.nextInt(_colors.length)],
      phase: _r.nextDouble() * pi * 2,
    ));
  }

  void _tap(_Balloon b) {
    if (b.popped || _between) return;
    if (b.letter == _target) {
      b.popped = true;
      HapticFeedback.lightImpact();
      AudioService.instance.play(Sfx.pop);
      _hits++;
      if (_hits >= _perRound) _nextRound();
    } else {
      b.shake++;
      _misses++;
      _totalMisses++;
      AudioService.instance.play(Sfx.wrong);
      AudioService.instance.say(b.letter.say, lang: b.letter.sayLang);
    }
  }

  Future<void> _nextRound() async {
    _between = true;
    setState(() => _confetti++);
    AudioService.instance.play(Sfx.star);
    for (final b in _balloons) {
      b.popped = true;
    }
    await Future<void>.delayed(const Duration(milliseconds: 1300));
    if (!mounted) return;
    if (_round >= _rounds - 1) {
      _ticker.stop();
      final s = context.sRead;
      final total = _rounds * _perRound;
      final stars = _totalMisses <= 2 ? 3 : (_totalMisses <= 6 ? 2 : 1);
      await finishGame(
        context,
        title: s.t('g_balloons'),
        color: AppColors.coral,
        stars: stars,
        correct: total,
        total: total + _totalMisses,
        retry: () => BalloonGame(alphabet: widget.alphabet),
      );
      return;
    }
    setState(() {
      _round++;
      _hits = 0;
      _misses = 0;
      _between = false;
    });
    _announce();
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return ActivityScope(
      music: Music.games,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF8FD3FF), Color(0xFFDDF3FF)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    children: [
                      RoundButton(icon: Icons.close_rounded, onTap: () => Navigator.of(context).pop()),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(s.t('popLetter', [_target.upper]),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                      ),
                      Bouncy(
                        onTap: _announce,
                        sound: null,
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [BoxShadow(color: Color(0x33000000), offset: Offset(0, 4))],
                          ),
                          alignment: Alignment.center,
                          child: Text(_target.upper,
                              style: const TextStyle(
                                  fontFamily: AppFonts.letters, fontSize: 38, fontWeight: FontWeight.w700, color: AppColors.coral)),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Text(s.t('round', [_round + 1]), style: const TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(width: 12),
                      Expanded(child: StepBar(value: _hits / _perRound, color: AppColors.coral)),
                    ],
                  ),
                ),
                Expanded(
                  child: LayoutBuilder(builder: (context, c) {
                    _size = Size(c.maxWidth, c.maxHeight);
                    return Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        for (final b in _balloons) _balloonWidget(b, c.maxWidth),
                        Positioned.fill(child: Confetti(trigger: _confetti)),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _balloonWidget(_Balloon b, double width) {
    const w = 84.0, h = 104.0;
    final sway = sin(b.y / 60 + b.phase) * 10;
    final scale = b.popped ? 1 + b.popT * 0.6 : 1.0;
    final opacity = b.popped ? (1 - b.popT).clamp(0.0, 1.0) : 1.0;
    return Positioned(
      key: ValueKey(b.id),
      left: b.x * width - w / 2 + sway,
      top: b.y,
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => _tap(b),
            child: _ShakeOnce(
              trigger: b.shake,
              child: SizedBox(
                width: w,
                height: h + 30,
                child: CustomPaint(
                  painter: _BalloonPainter(b.color),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Center(
                      child: Text(b.letter.upper,
                          style: const TextStyle(
                              fontFamily: AppFonts.letters, fontSize: 40, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShakeOnce extends StatefulWidget {
  const _ShakeOnce({required this.trigger, required this.child});
  final int trigger;
  final Widget child;

  @override
  State<_ShakeOnce> createState() => _ShakeOnceState();
}

class _ShakeOnceState extends State<_ShakeOnce> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 380));

  @override
  void didUpdateWidget(covariant _ShakeOnce old) {
    super.didUpdateWidget(old);
    if (old.trigger != widget.trigger) _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (_, child) => Transform.rotate(angle: sin(_c.value * pi * 6) * 0.18 * (1 - _c.value), child: child),
        child: widget.child,
      );
}

class _BalloonPainter extends CustomPainter {
  _BalloonPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final body = Rect.fromLTWH(0, 0, size.width, size.height - 30);
    final paint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.35, -0.45),
        radius: 0.9,
        colors: [Color.lerp(color, Colors.white, 0.35)!, color, Color.lerp(color, Colors.black, 0.15)!],
      ).createShader(body);
    canvas.drawOval(body, paint);
    // tugun
    final knot = Path()
      ..moveTo(size.width / 2 - 7, body.bottom + 6)
      ..lineTo(size.width / 2 + 7, body.bottom + 6)
      ..lineTo(size.width / 2, body.bottom - 2)
      ..close();
    canvas.drawPath(knot, Paint()..color = Color.lerp(color, Colors.black, 0.2)!);
    // ip
    final string = Path()
      ..moveTo(size.width / 2, body.bottom + 6)
      ..quadraticBezierTo(size.width / 2 + 8, body.bottom + 16, size.width / 2, size.height);
    canvas.drawPath(
      string,
      Paint()
        ..color = const Color(0x88444444)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
    // yaltirash
    canvas.drawOval(
      Rect.fromLTWH(size.width * 0.2, body.height * 0.14, size.width * 0.18, body.height * 0.2),
      Paint()..color = Colors.white.withValues(alpha: 0.45),
    );
  }

  @override
  bool shouldRepaint(covariant _BalloonPainter old) => old.color != color;
}
