import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';

/// Curated five-color families for live template personalization.
class ResumeTemplatePalette {
  ResumeTemplatePalette._();

  static List<Color> optionsFor(String templateId, Color fallback) {
    return switch (templateId) {
      'auckland' => _bright,
      'edinburgh' || 'cambridge' || 'ats_classic' => _navy,
      'princeton' || 'oxford' => _earth,
      'otago' || 'berkeley' || 'modern_clean' => _fresh,
      'lisbon' => _terracotta,
      'toronto' => _coastal,
      'harvard' => _burgundy,
      'stanford' => _charcoal,
      'executive_pro' => _executive,
      'monaco' => _monaco,
      'tokyo' => _editorial,
      _ => [fallback, ..._bright.skip(1)],
    };
  }

  static Color selected(
    Map<String, dynamic> resumeData, {
    required Color fallback,
  }) {
    final templateId = (resumeData['templateId'] ?? '').toString();
    final rawIndex = resumeData['templateColorIndex'];
    final index = rawIndex is int ? rawIndex.clamp(0, 4) : 0;
    return optionsFor(templateId, fallback)[index];
  }

  static PdfColor selectedPdf(
    Map<String, dynamic> resumeData, {
    required Color fallback,
  }) {
    final color = selected(resumeData, fallback: fallback);
    final hex = (color.toARGB32() & 0xFFFFFF)
        .toRadixString(16)
        .padLeft(6, '0')
        .toUpperCase();
    return PdfColor.fromHex('#$hex');
  }

  static Color darken(Color color, [double amount = .22]) {
    final hsv = HSVColor.fromColor(color);
    return hsv.withValue((hsv.value - amount).clamp(0.08, 1.0)).toColor();
  }

  static Color lighten(Color color, [double amount = .24]) {
    final hsv = HSVColor.fromColor(color);
    return hsv.withValue((hsv.value + amount).clamp(0.0, 1.0)).toColor();
  }

  static const _bright = [
    Color(0xFF2563EB),
    Color(0xFF0284C7),
    Color(0xFF4F46E5),
    Color(0xFF0F766E),
    Color(0xFFC2410C),
  ];
  static const _navy = [
    Color(0xFF173B6C),
    Color(0xFF1E3A5F),
    Color(0xFF334155),
    Color(0xFF164E63),
    Color(0xFF3F3A63),
  ];
  static const _earth = [
    Color(0xFF5B4636),
    Color(0xFF725A40),
    Color(0xFF3F5148),
    Color(0xFF62546B),
    Color(0xFF70443C),
  ];
  static const _fresh = [
    Color(0xFF047857),
    Color(0xFF0F766E),
    Color(0xFF0369A1),
    Color(0xFF4F46E5),
    Color(0xFFB45309),
  ];
  static const _terracotta = [
    Color(0xFFB4533C),
    Color(0xFFA13D2D),
    Color(0xFF9A5D32),
    Color(0xFF8A4F62),
    Color(0xFF56705B),
  ];
  static const _coastal = [
    Color(0xFF315E73),
    Color(0xFF276678),
    Color(0xFF3E5F8A),
    Color(0xFF386A63),
    Color(0xFF665A7A),
  ];
  static const _burgundy = [
    Color(0xFF6B1D32),
    Color(0xFF7F1D1D),
    Color(0xFF5B2747),
    Color(0xFF3F4A66),
    Color(0xFF4D4B2A),
  ];
  static const _charcoal = [
    Color(0xFF1F2937),
    Color(0xFF172033),
    Color(0xFF263B37),
    Color(0xFF35283C),
    Color(0xFF3B3029),
  ];
  static const _executive = [
    Color(0xFFD08A18),
    Color(0xFFB76E2B),
    Color(0xFF9B7A30),
    Color(0xFF507C72),
    Color(0xFF6679A8),
  ];
  static const _monaco = [
    Color(0xFF171717),
    Color(0xFF172033),
    Color(0xFF18362D),
    Color(0xFF302135),
    Color(0xFF34261F),
  ];
  static const _editorial = [
    Color(0xFFB4232D),
    Color(0xFFC2410C),
    Color(0xFFB12A67),
    Color(0xFF315E9A),
    Color(0xFF0F766E),
  ];
}
