import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// A big, rounded, colorful tappable card used across the app for
/// module/alphabet/category selection grids. Meets the >=60x60dp
/// touch-target requirement from TZ 7.1 by a wide margin. Uses a soft
/// gradient + an inset "badge" behind the emoji so flat brand colors read
/// as playful and dimensional rather than flat rectangles.
class BigActionCard extends StatefulWidget {
  final String emoji;
  final String title;
  final String? subtitle;
  final Color color;
  final VoidCallback? onTap;
  final bool locked;

  const BigActionCard({
    super.key,
    required this.emoji,
    required this.title,
    this.subtitle,
    required this.color,
    this.onTap,
    this.locked = false,
  });

  @override
  State<BigActionCard> createState() => _BigActionCardState();
}

class _BigActionCardState extends State<BigActionCard> {
  double _scale = 1.0;

  void _setScale(double v) => setState(() => _scale = v);

  @override
  Widget build(BuildContext context) {
    final gradient = AppColors.gradientFor(widget.color);
    return GestureDetector(
      onTapDown: widget.onTap == null ? null : (_) => _setScale(0.94),
      onTapUp: widget.onTap == null ? null : (_) => _setScale(1.0),
      onTapCancel: widget.onTap == null ? null : () => _setScale(1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Opacity(
          opacity: widget.locked ? 0.55 : 1.0,
          child: Container(
            constraints: const BoxConstraints(minHeight: 96, minWidth: 96),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.45),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.28),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(widget.emoji, style: const TextStyle(fontSize: 34)),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.baloo2(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    shadows: const [Shadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 1))],
                  ),
                ),
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
                if (widget.locked) ...[
                  const SizedBox(height: 6),
                  const Icon(Icons.lock_rounded, color: Colors.white70, size: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
