import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../domain/entities/template_config.dart';
import 'ats_classic_template.dart';
import 'ats_pure_template.dart';
import 'modern_clean_template.dart';
import 'modern_creative_template.dart';
import 'executive_minimal_template.dart';
import 'executive_pro_template.dart';

/// Auckland — Modern Clean style with light grey header bar (FREE)
class AucklandTemplate extends BaseResumeTemplate {
  final _renderer = ModernCleanTemplate();

  @override
  TemplateConfig get config => const TemplateConfig(
        id: 'auckland',
        name: 'Auckland',
        description: 'Clean header bar with subtle border accents',
        isPremium: false,
        category: 'modern',
        primaryColor: Color(0xFF3B82F6),
        accentColor: Color(0xFF60A5FA),
        thumbnailAsset: 'assets/templates/auckland.png',
      );

  @override
  Widget buildPreview(Map<String, dynamic> resumeData) => _renderer.buildPreview(resumeData);

  @override
  pw.Page buildPdfPage(Map<String, dynamic> resumeData, pw.Font regularFont, pw.Font boldFont) =>
      _renderer.buildPdfPage(resumeData, regularFont, boldFont);
}

/// Edinburgh — Executive Minimal with top accent bar (FREE)
class EdinburghTemplate extends BaseResumeTemplate {
  final _renderer = ExecutiveMinimalTemplate();

  @override
  TemplateConfig get config => const TemplateConfig(
        id: 'edinburgh',
        name: 'Edinburgh',
        description: 'Elegant top banner layout with executive serif typography',
        isPremium: false,
        category: 'executive',
        primaryColor: Color(0xFF1E3A8A),
        accentColor: Color(0xFF3B82F6),
        thumbnailAsset: 'assets/templates/edinburgh.png',
      );

  @override
  Widget buildPreview(Map<String, dynamic> resumeData) => _renderer.buildPreview(resumeData);

  @override
  pw.Page buildPdfPage(Map<String, dynamic> resumeData, pw.Font regularFont, pw.Font boldFont) =>
      _renderer.buildPdfPage(resumeData, regularFont, boldFont);
}

/// Princeton — Classic Minimal layout (FREE)
class PrincetonTemplate extends BaseResumeTemplate {
  final _renderer = AtsPureTemplate();

  @override
  TemplateConfig get config => const TemplateConfig(
        id: 'princeton',
        name: 'Princeton',
        description: 'Ultra-clean single column layout optimized for maximum readability',
        isPremium: false,
        category: 'ats',
        primaryColor: Color(0xFF0F172A),
        accentColor: Color(0xFF475569),
        thumbnailAsset: 'assets/templates/princeton.png',
      );

  @override
  Widget buildPreview(Map<String, dynamic> resumeData) => _renderer.buildPreview(resumeData);

  @override
  pw.Page buildPdfPage(Map<String, dynamic> resumeData, pw.Font regularFont, pw.Font boldFont) =>
      _renderer.buildPdfPage(resumeData, regularFont, boldFont);
}

/// Otago — Modern Creative layout (PRO)
class OtagoTemplate extends BaseResumeTemplate {
  final _renderer = ModernCreativeTemplate();

  @override
  TemplateConfig get config => const TemplateConfig(
        id: 'otago',
        name: 'Otago',
        description: 'Vibrant creative template with pill skill tags and bold headers',
        isPremium: true,
        category: 'modern',
        primaryColor: Color(0xFF8B5CF6),
        accentColor: Color(0xFFA78BFA),
        thumbnailAsset: 'assets/templates/otago.png',
      );

  @override
  Widget buildPreview(Map<String, dynamic> resumeData) => _renderer.buildPreview(resumeData);

  @override
  pw.Page buildPdfPage(Map<String, dynamic> resumeData, pw.Font regularFont, pw.Font boldFont) =>
      _renderer.buildPdfPage(resumeData, regularFont, boldFont);
}

/// Berkeley — Clean Modern layout (PRO)
class BerkeleyTemplate extends BaseResumeTemplate {
  final _renderer = ModernCleanTemplate();

  @override
  TemplateConfig get config => const TemplateConfig(
        id: 'berkeley',
        name: 'Berkeley',
        description: 'Contemporary tech layout with slate accents',
        isPremium: true,
        category: 'modern',
        primaryColor: Color(0xFF0284C7),
        accentColor: Color(0xFF38BDF8),
        thumbnailAsset: 'assets/templates/berkeley.png',
      );

  @override
  Widget buildPreview(Map<String, dynamic> resumeData) => _renderer.buildPreview(resumeData);

  @override
  pw.Page buildPdfPage(Map<String, dynamic> resumeData, pw.Font regularFont, pw.Font boldFont) =>
      _renderer.buildPdfPage(resumeData, regularFont, boldFont);
}

/// Harvard — Executive Pro split sidebar (PRO)
class HarvardTemplate extends BaseResumeTemplate {
  final _renderer = ExecutiveProTemplate();

  @override
  TemplateConfig get config => const TemplateConfig(
        id: 'harvard',
        name: 'Harvard',
        description: 'Prestigious split sidebar layout with dark blue accent',
        isPremium: true,
        category: 'executive',
        primaryColor: Color(0xFF1E293B),
        accentColor: Color(0xFF3B82F6),
        thumbnailAsset: 'assets/templates/harvard.png',
      );

  @override
  Widget buildPreview(Map<String, dynamic> resumeData) => _renderer.buildPreview(resumeData);

  @override
  pw.Page buildPdfPage(Map<String, dynamic> resumeData, pw.Font regularFont, pw.Font boldFont) =>
      _renderer.buildPdfPage(resumeData, regularFont, boldFont);
}

/// Stanford — Dark minimal layout (PRO)
class StanfordTemplate extends BaseResumeTemplate {
  final _renderer = ExecutiveProTemplate();

  @override
  TemplateConfig get config => const TemplateConfig(
        id: 'stanford',
        name: 'Stanford',
        description: 'Dark-themed left column sidebar with crisp white body',
        isPremium: true,
        category: 'executive',
        primaryColor: Color(0xFF334155),
        accentColor: Color(0xFF64748B),
        thumbnailAsset: 'assets/templates/stanford.png',
      );

  @override
  Widget buildPreview(Map<String, dynamic> resumeData) => _renderer.buildPreview(resumeData);

  @override
  pw.Page buildPdfPage(Map<String, dynamic> resumeData, pw.Font regularFont, pw.Font boldFont) =>
      _renderer.buildPdfPage(resumeData, regularFont, boldFont);
}

/// Cambridge — Classic navy header (PRO)
class CambridgeTemplate extends BaseResumeTemplate {
  final _renderer = ModernCleanTemplate();

  @override
  TemplateConfig get config => const TemplateConfig(
        id: 'cambridge',
        name: 'Cambridge',
        description: 'Deep navy top banner header with clean grid',
        isPremium: true,
        category: 'ats',
        primaryColor: Color(0xFF172554),
        accentColor: Color(0xFF2563EB),
        thumbnailAsset: 'assets/templates/cambridge.png',
      );

  @override
  Widget buildPreview(Map<String, dynamic> resumeData) => _renderer.buildPreview(resumeData);

  @override
  pw.Page buildPdfPage(Map<String, dynamic> resumeData, pw.Font regularFont, pw.Font boldFont) =>
      _renderer.buildPdfPage(resumeData, regularFont, boldFont);
}

/// Oxford — Minimalist Executive (PRO)
class OxfordTemplate extends BaseResumeTemplate {
  final _renderer = AtsClassicTemplate();

  @override
  TemplateConfig get config => const TemplateConfig(
        id: 'oxford',
        name: 'Oxford',
        description: 'Refined classic layout with subtle horizontal dividers',
        isPremium: true,
        category: 'ats',
        primaryColor: Color(0xFF1E1B4B),
        accentColor: Color(0xFF4338CA),
        thumbnailAsset: 'assets/templates/oxford.png',
      );

  @override
  Widget buildPreview(Map<String, dynamic> resumeData) => _renderer.buildPreview(resumeData);

  @override
  pw.Page buildPdfPage(Map<String, dynamic> resumeData, pw.Font regularFont, pw.Font boldFont) =>
      _renderer.buildPdfPage(resumeData, regularFont, boldFont);
}
