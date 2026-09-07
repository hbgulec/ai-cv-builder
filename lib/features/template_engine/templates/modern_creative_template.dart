import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;

import '../domain/entities/template_config.dart';
import 'structured_resume_template.dart';

/// Creative two-column resume with a persistent full-height information rail.
class ModernCreativeTemplate extends BaseResumeTemplate {
  static const _config = TemplateConfig(
    id: 'modern_creative',
    name: 'Modern Creative',
    description:
        'Two-column layout with sidebar, vibrant accents and skill bars',
    isPremium: true,
    category: 'modern',
    primaryColor: Color(0xFF059669),
    accentColor: Color(0xFF34D399),
    thumbnailAsset: 'assets/templates/modern_creative_thumb.png',
  );

  late final _renderer = StructuredResumeTemplate(
    config: _config,
    style: StructuredResumeStyle.sidebar,
  );

  @override
  TemplateConfig get config => _config;

  @override
  Widget buildPreview(Map<String, dynamic> resumeData) =>
      _renderer.buildPreview(resumeData);

  @override
  pw.Page buildPdfPage(
    Map<String, dynamic> resumeData,
    pw.Font regularFont,
    pw.Font boldFont,
  ) =>
      _renderer.buildPdfPage(resumeData, regularFont, boldFont);
}
