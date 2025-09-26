import 'package:flutter/material.dart';
import '../colors/wargakita_colors.dart';
import '../typography/wargakita_text_styles.dart';

class WargakitaTheme {
  static ThemeData get mainTheme {
    return ThemeData(
      primaryColor: WargaKitaColors.primary.color,
      scaffoldBackgroundColor: WargaKitaColors.white.color,
      textTheme: TextTheme(
        headlineLarge: WargaKitaTextStyles.headlineLarge,
        bodyMedium: WargaKitaTextStyles.bodyMedium,
        bodySmall: WargaKitaTextStyles.bodySmall,
      ),
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: WargaKitaColors.primary.color,
        foregroundColor: WargaKitaColors.white.color,
        elevation: 0,
        titleTextStyle: WargaKitaTextStyles.headlineLarge.copyWith(
          color: WargaKitaColors.white.color,
          fontSize: 20,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: WargaKitaColors.primary.color,
        primary: WargaKitaColors.primary.color,
        secondary: WargaKitaColors.secondary.color,
        surface: WargaKitaColors.white.color,
        onPrimary: WargaKitaColors.white.color,
        onSecondary: WargaKitaColors.white.color,
        onSurface: WargaKitaColors.black.color,
      ),
    );
  }
}
