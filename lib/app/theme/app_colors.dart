// Hallmark - pre-emit critique: P5 H5 E4 S5 R4 V4
// Genre: atmospheric - theme: Soft Glass Refined - anchor: petrol blue
import 'package:flutter/material.dart';

/// Soft Glass Refined color tokens shared by every product screen.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF2F8DFF);
  static const Color primaryLight = Color(0xFF72B5FF);
  static const Color primaryDark = Color(0xFF1767C8);
  static const Color primaryIndigo = primary;
  static const Color accentViolet = primaryLight;
  static const Color cyan = Color(0xFF65D5EE);

  static const Color secondary = cyan;
  static const Color success = Color(0xFF67DFC5);
  static const Color successGreen = success;
  static const Color warning = Color(0xFFF2C66D);
  static const Color error = Color(0xFFFF7F8B);

  static const Color darkBackground = Color(0xFF092845);
  static const Color darkSurface = Color(0xFF173F64);
  static const Color surfaceDark = darkSurface;
  static const Color darkCard = Color(0xFF1C496F);
  static const Color darkBorder = Color(0xFF52799A);

  static const Color glassBackground = Color(0x1AFFFFFF);
  static const Color glassBackgroundStrong = Color(0x2BFFFFFF);
  static const Color glassBorder = Color(0x4DFFFFFF);
  static const Color glassBorderSoft = Color(0x26FFFFFF);
  static const Color glassShadow = Color(0x4700152D);

  static const Color lightBackground = Color(0xFFF4F8FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFEAF2F8);
  static const Color lightBorder = Color(0xFFD6E2EC);

  static const Color textPrimary = Color(0xFFF7FBFF);
  static const Color textSecondary = Color(0xFFC8D9E8);
  static const Color textMuted = Color(0xFF91ACC2);
  static const Color textPrimaryDark = textPrimary;
  static const Color textSecondaryDark = textSecondary;
  static const Color textPrimaryLight = Color(0xFF102C43);
  static const Color textSecondaryLight = Color(0xFF526A7D);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF259BFF), Color(0xFF3478F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [Color(0xFF174B77), Color(0xFF103B63), Color(0xFF092845)],
    stops: [0, 0.48, 1],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x30FFFFFF), Color(0x0FFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
