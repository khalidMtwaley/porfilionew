import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppColors {
  static const background = Color(0xFF0A0A0F);
  static const surface = Color(0xFF12121A);
  static const surfaceElevated = Color(0xFF1A1A24);
  static const border = Color(0xFF333342);
  static const accent = Color(0xFF64FFDA);
  static const accentSoft = Color(0xFF00BFA5);
  static const textPrimary = Color(0xFFE6E6F0);
  static const textSecondary = Color(0xFFB0B0C4);
  static const textMuted = Color(0xFF8C8CA0);
}

abstract final class AppTheme {
  static ThemeData get dark {
    const scheme = ColorScheme.dark(
      primary: AppColors.accent,
      onPrimary: AppColors.background,
      secondary: AppColors.accentSoft,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      outline: AppColors.border,
    );

    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(
          AppColors.accent.withValues(alpha: 0.35),
        ),
        radius: const Radius.circular(8),
        thickness: const WidgetStatePropertyAll(8),
      ),
    );
  }

  /// Monospace accent font used for section numbers and code-like labels.
  static TextStyle mono({
    double size = 14,
    Color color = AppColors.accent,
    FontWeight weight = FontWeight.w500,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: size,
      color: color,
      fontWeight: weight,
    );
  }
}
