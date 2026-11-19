import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Ranglar tizimi: iliq qaymoqrang fon, to'q siyohrang matn va har bir
/// bo'lim uchun bitta yorqin urg'u rangi. Bolalar uchun yetarlicha
/// kontrastli (matn/fon ≥ 4.5:1).
abstract final class AppColors {
  static const background = Color(0xFFFFF6E9);
  static const surface = Colors.white;
  static const ink = Color(0xFF2B2350);
  static const inkSoft = Color(0xFF6B6491);
  static const line = Color(0xFFEDE3D3);

  static const teal = Color(0xFF0E8C86); // Alifbo (Ziyrak "Harflar" rangi)
  static const coral = Color(0xFFFF6B5B); // Darslar
  static const sun = Color(0xFFFFB627); // Yulduzlar, mukofot
  static const grape = Color(0xFF7C5CFF); // O'yinlar
  static const leaf = Color(0xFF3DBE6B); // To'g'ri javob, So'zlar
  static const sky = Color(0xFF2EA8FF); // Bilimdon
  static const berry = Color(0xFFE84A8A); // Ertaklar
  static const night = Color(0xFF26235C);

  static const correct = Color(0xFF2FB56A);
  static const wrong = Color(0xFFFF5C5C);

  /// Rangning yorqin (yuqori) va to'q (pastki) tusli gradienti.
  static LinearGradient gradient(Color c) => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color.lerp(c, Colors.white, 0.18)!, c],
      );

  /// Tugma pastidagi "qalinlik" (3D) uchun to'qroq tus.
  static Color shade(Color c, [double amount = 0.22]) =>
      Color.lerp(c, Colors.black, amount)!;

  static Color tint(Color c, [double amount = 0.85]) =>
      Color.lerp(c, Colors.white, amount)!;
}

abstract final class AppFonts {
  static const ui = 'Nunito';

  /// Harflar uchun — savod o'rgatishga mo'ljallangan Andika shrifti.
  static const letters = 'Andika';
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: AppFonts.ui,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.teal,
        surface: AppColors.surface,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );
    final text = base.textTheme.apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
      fontFamily: AppFonts.ui,
    );
    return base.copyWith(
      textTheme: text.copyWith(
        headlineMedium: text.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
        titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        bodyLarge: text.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        bodyMedium: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        foregroundColor: AppColors.ink,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontFamily: AppFonts.ui,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          color: AppColors.ink,
        ),
      ),
      splashFactory: InkSparkle.splashFactory,
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? Colors.white : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.leaf : null,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentTextStyle: const TextStyle(
          fontFamily: AppFonts.ui,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
