import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// TZ 7.3: a rounded, easy-to-read font family for kids. Baloo 2 for big
/// display text (letters, headings), Nunito for body copy. Fetched via
/// google_fonts on first use and cached on-device afterwards; if the
/// device is offline on first launch, Flutter silently falls back to the
/// system font until a connection is available (see TZ addendum).
class AppTheme {
  AppTheme._();

  static TextStyle display({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w800,
    Color color = AppColors.textDark,
  }) =>
      GoogleFonts.baloo2(fontSize: fontSize, fontWeight: fontWeight, color: color);

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );

    final bodyTextTheme = GoogleFonts.nunitoTextTheme(base.textTheme).apply(
      bodyColor: AppColors.textDark,
      displayColor: AppColors.textDark,
    );

    final textTheme = bodyTextTheme.copyWith(
      headlineLarge: GoogleFonts.baloo2(fontSize: 30, fontWeight: FontWeight.w800, color: AppColors.textDark),
      headlineMedium: GoogleFonts.baloo2(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textDark),
      headlineSmall: GoogleFonts.baloo2(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textDark),
      titleLarge: GoogleFonts.baloo2(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textDark),
      titleMedium: GoogleFonts.baloo2(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textDark),
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textDark,
        centerTitle: true,
        titleTextStyle: GoogleFonts.baloo2(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(64, 64),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
          textStyle: GoogleFonts.baloo2(fontSize: 18, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        labelStyle: GoogleFonts.nunito(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide.none,
        ),
      ),
      splashFactory: InkRipple.splashFactory,
    );
  }
}
