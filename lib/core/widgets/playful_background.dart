import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Soft, oversized translucent color blobs behind [child], used on
/// high-level screens (splash, onboarding, home) so the flat cream
/// background reads as designed rather than empty. Purely decorative,
/// costs no assets, and never intercepts touches.
class PlayfulBackground extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const PlayfulBackground({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Stack(
        children: [
          Positioned(
            top: -70,
            right: -60,
            child: _Blob(color: AppColors.yellow.withValues(alpha: 0.35), size: 200),
          ),
          Positioned(
            top: 140,
            left: -80,
            child: _Blob(color: AppColors.secondary.withValues(alpha: 0.25), size: 180),
          ),
          Positioned(
            bottom: -90,
            right: -50,
            child: _Blob(color: AppColors.pink.withValues(alpha: 0.28), size: 220),
          ),
          Positioned(
            bottom: 60,
            left: -60,
            child: _Blob(color: AppColors.purple.withValues(alpha: 0.2), size: 150),
          ),
          child,
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
