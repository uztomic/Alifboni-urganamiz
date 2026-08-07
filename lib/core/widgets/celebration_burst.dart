import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A short-lived confetti-style particle burst, used to celebrate a
/// correct answer / finished quiz / successful trace. Purely decorative
/// and self-disposes; wrap it around the widget it should burst from,
/// or drop it into a Stack.
class CelebrationBurst extends StatefulWidget {
  final bool play;
  final VoidCallback? onDone;

  const CelebrationBurst({super.key, required this.play, this.onDone});

  @override
  State<CelebrationBurst> createState() => _CelebrationBurstState();
}

class _Particle {
  final double angle;
  final double speed;
  final double size;
  final Color color;
  _Particle({required this.angle, required this.speed, required this.size, required this.color});
}

class _CelebrationBurstState extends State<CelebrationBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onDone?.call();
    });
    if (widget.play) _fire();
  }

  @override
  void didUpdateWidget(covariant CelebrationBurst oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.play && !oldWidget.play) _fire();
  }

  void _fire() {
    _particles
      ..clear()
      ..addAll(List.generate(18, (i) {
        return _Particle(
          angle: (i / 18) * 2 * pi + _random.nextDouble() * 0.4,
          speed: 60 + _random.nextDouble() * 60,
          size: 5 + _random.nextDouble() * 5,
          color: AppColors.cardPalette[i % AppColors.cardPalette.length],
        );
      }));
    _controller
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _BurstPainter(_particles, _controller.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _BurstPainter extends CustomPainter {
  final List<_Particle> particles;
  final double t;
  _BurstPainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    if (t == 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint();
    for (final p in particles) {
      final distance = p.speed * t;
      final dx = cos(p.angle) * distance;
      final dy = sin(p.angle) * distance + 120 * t * t; // gravity
      final opacity = (1 - t).clamp(0.0, 1.0);
      paint.color = p.color.withValues(alpha: opacity);
      canvas.drawCircle(center + Offset(dx, dy), p.size * (1 - t * 0.4), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BurstPainter oldDelegate) => true;
}
