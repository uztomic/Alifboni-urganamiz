import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/audio/audio_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/pictures.dart';

/// Ziko — Ziyrak'ning qor qoploni. Ilova bo'ylab yo'lboshchi.
enum ZikoMood {
  hello('ziko-salom'),
  happy('ziko-xursand'),
  think('ziko-oylaydi'),
  sleep('ziko-uxlaydi');

  const ZikoMood(this.file);
  final String file;
}

class Ziko extends StatefulWidget {
  const Ziko({super.key, this.mood = ZikoMood.hello, this.size = 120, this.bob = true});
  final ZikoMood mood;
  final double size;
  final bool bob;

  @override
  State<Ziko> createState() => _ZikoState();
}

class _ZikoState extends State<Ziko> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  @override
  void initState() {
    super.initState();
    if (widget.bob) _c.repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final img = SvgPicture.asset(
      'assets/images/ziko/${widget.mood.file}.svg',
      width: widget.size,
      height: widget.size * 262 / 240,
    );
    if (!widget.bob) return img;
    return AnimatedBuilder(
      animation: _c,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, -6 * Curves.easeInOut.transform(_c.value)),
        child: child,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: KeyedSubtree(key: ValueKey(widget.mood), child: img),
      ),
    );
  }
}

/// Bosilganda biroz kichrayib, qo'yib yuborilganda "sakraydigan" tugma
/// qobig'i. Bosish tovushi va yengil tebranish beradi.
class Bouncy extends StatefulWidget {
  const Bouncy({
    super.key,
    required this.child,
    required this.onTap,
    this.sound = Sfx.tap,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Sfx? sound;
  final bool enabled;

  @override
  State<Bouncy> createState() => _BouncyState();
}

class _BouncyState extends State<Bouncy> {
  bool _down = false;

  void _set(bool v) {
    if (_down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.enabled && widget.onTap != null;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: active ? (_) => _set(true) : null,
      onTapCancel: active ? () => _set(false) : null,
      onTapUp: active ? (_) => _set(false) : null,
      onTap: active
          ? () {
              if (widget.sound != null) AudioService.instance.play(widget.sound!);
              HapticFeedback.selectionClick();
              widget.onTap!();
            }
          : null,
      child: AnimatedScale(
        scale: _down ? 0.93 : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Qalin, "3D" ko'rinishdagi asosiy tugma.
class ChunkyButton extends StatelessWidget {
  const ChunkyButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = AppColors.leaf,
    this.icon,
    this.expand = true,
    this.height = 60,
    this.textColor = Colors.white,
  });

  final String label;
  final VoidCallback? onTap;
  final Color color;
  final IconData? icon;
  final bool expand;
  final double height;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    final c = enabled ? color : const Color(0xFFCFC8BC);
    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, color: textColor, size: 26),
          const SizedBox(width: 10),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: textColor,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
    return Bouncy(
      onTap: onTap,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: c,
          borderRadius: BorderRadius.circular(height / 2.6),
          boxShadow: [
            BoxShadow(color: AppColors.shade(c), offset: const Offset(0, 5)),
          ],
        ),
        alignment: Alignment.center,
        child: content,
      ),
    );
  }
}

/// Dumaloq ikonka tugmasi (orqaga, sozlamalar, ovoz).
class RoundButton extends StatelessWidget {
  const RoundButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = AppColors.surface,
    this.iconColor = AppColors.ink,
    this.size = 52,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  final Color iconColor;
  final double size;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final btn = Bouncy(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color == AppColors.surface
                  ? AppColors.line
                  : AppColors.shade(color),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: size * 0.5),
      ),
    );
    return tooltip == null ? btn : Semantics(label: tooltip, button: true, child: btn);
  }
}

/// Sahifa sarlavhasi: orqaga tugmasi, nom va o'ng tomondagi qo'shimcha.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key, required this.title, this.trailing, this.onBack, this.color});
  final String title;
  final Widget? trailing;
  final VoidCallback? onBack;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          RoundButton(
            icon: Icons.arrow_back_rounded,
            onTap: onBack ?? () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: color ?? AppColors.ink,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Uch yulduzcha (olingan — sariq, olinmagan — kulrang).
class StarRow extends StatelessWidget {
  const StarRow({super.key, required this.stars, this.size = 18, this.max = 3});
  final int stars;
  final double size;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < max; i++)
          Icon(
            Icons.star_rounded,
            size: size,
            color: i < stars ? AppColors.sun : const Color(0xFFE2DACB),
          ),
      ],
    );
  }
}

/// Rasm: 3D rasm (ilova ichidan), bo'lmasa emoji yoki rang namunasi.
class PictureBadge extends StatelessWidget {
  const PictureBadge({super.key, this.emoji = '', this.swatch, this.size = 72});
  final String emoji;
  final Color? swatch;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (swatch != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: swatch,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: size * 0.06),
          boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 8, offset: Offset(0, 3))],
        ),
      );
    }
    final asset = Pictures.assetFor(emoji);
    if (asset != null) {
      return Image.asset(
        asset,
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        gaplessPlayback: true,
      );
    }
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Text(
          emoji,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: size * 0.72, height: 1.1),
        ),
      ),
    );
  }
}

/// Bosqich ko'rsatkichi (savollar soni).
class StepBar extends StatelessWidget {
  const StepBar({super.key, required this.value, this.color = AppColors.leaf});
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 16,
        color: const Color(0xFFEDE3D3),
        alignment: Alignment.centerLeft,
        child: AnimatedFractionallySizedBox(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          widthFactor: value.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}

/// Fon: iliq rang ustida yumshoq, harakatsiz doiralar.
class SoftBackground extends StatelessWidget {
  const SoftBackground({super.key, required this.child, this.color = AppColors.background, this.accent});
  final Widget child;
  final Color color;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final a = accent ?? AppColors.sun;
    return ColoredBox(
      color: color,
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: _blob(220, a.withValues(alpha: 0.13)),
          ),
          Positioned(
            bottom: -100,
            left: -70,
            child: _blob(260, AppColors.teal.withValues(alpha: 0.08)),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }

  Widget _blob(double s, Color c) => Container(
        width: s,
        height: s,
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      );
}

/// Yengil "konfetti" — to'g'ri javob va dars yakunida.
class Confetti extends StatefulWidget {
  const Confetti({super.key, required this.trigger});

  /// Har o'zgarganda (masalan, hisoblagich) yangi portlash.
  final int trigger;

  @override
  State<Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
  List<_Bit> _bits = const [];
  final _rnd = math.Random();

  @override
  void didUpdateWidget(covariant Confetti old) {
    super.didUpdateWidget(old);
    if (old.trigger != widget.trigger && widget.trigger > 0) _burst();
  }

  void _burst() {
    const colors = [AppColors.sun, AppColors.coral, AppColors.leaf, AppColors.sky, AppColors.grape, AppColors.berry];
    _bits = List.generate(42, (i) {
      final angle = -math.pi / 2 + (_rnd.nextDouble() - 0.5) * math.pi * 1.1;
      final speed = 380 + _rnd.nextDouble() * 420;
      return _Bit(
        dx: math.cos(angle) * speed,
        dy: math.sin(angle) * speed,
        color: colors[i % colors.length],
        size: 7 + _rnd.nextDouble() * 7,
        spin: (_rnd.nextDouble() - 0.5) * 12,
        round: _rnd.nextBool(),
      );
    });
    _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) => _c.isAnimating
            ? CustomPaint(painter: _ConfettiPainter(_bits, _c.value), size: Size.infinite)
            : const SizedBox.expand(),
      ),
    );
  }
}

class _Bit {
  const _Bit({required this.dx, required this.dy, required this.color, required this.size, required this.spin, required this.round});
  final double dx, dy, size, spin;
  final Color color;
  final bool round;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.bits, this.t);
  final List<_Bit> bits;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final origin = Offset(size.width / 2, size.height * 0.62);
    final time = t * 1.4;
    final fade = (1 - t).clamp(0.0, 1.0);
    for (final b in bits) {
      final p = origin + Offset(b.dx * time, b.dy * time + 520 * time * time);
      final paint = Paint()..color = b.color.withValues(alpha: fade);
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(b.spin * time);
      if (b.round) {
        canvas.drawCircle(Offset.zero, b.size / 2, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: b.size, height: b.size * 0.55),
            const Radius.circular(2),
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => old.t != t;
}

/// Sahifalar o'rtasida yumshoq o'tish (siljish + paydo bo'lish).
Route<T> softRoute<T>(Widget page) => PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween(begin: const Offset(0, 0.04), end: Offset.zero).animate(curved),
            child: child,
          ),
        );
      },
    );

Future<T?> go<T>(BuildContext context, Widget page) =>
    Navigator.of(context).push<T>(softRoute<T>(page));
