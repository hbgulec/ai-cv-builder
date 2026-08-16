import 'package:flutter/material.dart';

/// AppColors defines the curated color system for AI CV Builder
class AppColors {
  // Primary Palette - restrained indigo for a serious product feel
  static const Color primary = Color(0xFF3559E0);
  static const Color primaryLight = Color(0xFF5B7CFF);
  static const Color primaryDark = Color(0xFF233B99);
  static const Color primaryIndigo = Color(0xFF3559E0);
  static const Color accentViolet = Color(0xFF5B7CFF);

  // Secondary & Functional Colors
  static const Color secondary = Color(0xFF0EA5E9); // Sky 500
  static const Color success = Color(0xFF10B981); // Emerald 500
  static const Color successGreen = Color(0xFF10B981); // Emerald 500 alias
  static const Color warning = Color(0xFFAF580C); // Amber 600
  static const Color error = Color(0xFFEF4444); // Red 500

  // Dark Theme Background & Surface Tokens
  static const Color darkBackground = Color(0xFF0B1220);
  static const Color darkSurface = Color(0xFF121C2E);
  static const Color surfaceDark = Color(0xFF121C2E);
  static const Color darkCard = Color(0xFF1A2740);
  static const Color darkBorder = Color(0xFF27344D);

  // Glassmorphism Token Shortcuts
  static final Color glassBackground = Colors.white.withValues(alpha: 0.04);
  static final Color glassBorder = Colors.white.withValues(alpha: 0.10);

  // Light Theme Tokens
  static const Color lightBackground = Color(0xFFF7F8FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF1F4F9);
  static const Color lightBorder = Color(0xFFE1E7F0);

  // Text Color Hierarchy
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFFB2BED3);
  static const Color textMuted = Color(0xFF7E8BA3);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFFB2BED3);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF5F6C81);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3559E0), Color(0xFF5B7CFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [Color(0xFF0B1220), Color(0xFF121C2E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0x33FFFFFF),
      Color(0x0DFFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
