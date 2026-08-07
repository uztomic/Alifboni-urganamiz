import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class StarRating extends StatelessWidget {
  final int stars; // 0-3
  final double size;
  const StarRating({super.key, required this.stars, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final filled = i < stars;
        return Icon(
          filled ? Icons.star_rounded : Icons.star_border_rounded,
          color: filled ? AppColors.star : Colors.white70,
          size: size,
        );
      }),
    );
  }
}
