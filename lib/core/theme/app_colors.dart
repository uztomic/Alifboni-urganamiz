import 'package:flutter/material.dart';

/// Bright, playful palette for a children's learning app.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFFFFF8EC);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color primary = Color(0xFFFF7A59); // warm coral
  static const Color secondary = Color(0xFF4ECDC4); // teal
  static const Color yellow = Color(0xFFFFD166);
  static const Color pink = Color(0xFFFF6FA5);
  static const Color blue = Color(0xFF4D96FF);
  static const Color green = Color(0xFF6BCB77);
  static const Color purple = Color(0xFFA78BFA);

  static const Color textDark = Color(0xFF3A3A3A);
  static const Color textLight = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF6BCB77);
  static const Color error = Color(0xFFFF6B6B);
  static const Color star = Color(0xFFFFD166);

  static const List<Color> cardPalette = [
    primary,
    secondary,
    yellow,
    pink,
    blue,
    green,
    purple,
  ];

  static Color forIndex(int index) =>
      cardPalette[index % cardPalette.length];

  /// A soft light-to-dark diagonal gradient derived from [base], used to
  /// give flat brand colors some depth on cards without hand-authoring a
  /// gradient per color.
  static LinearGradient gradientFor(Color base) {
    final hsl = HSLColor.fromColor(base);
    final light = hsl.withLightness((hsl.lightness + 0.10).clamp(0.0, 1.0)).toColor();
    final dark = hsl.withLightness((hsl.lightness - 0.10).clamp(0.0, 1.0)).toColor();
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [light, dark],
    );
  }
}
