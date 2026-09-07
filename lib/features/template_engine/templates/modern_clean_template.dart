import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;

import '../domain/entities/template_config.dart';
import 'structured_resume_template.dart';

/// Contemporary horizontal-header resume with restrained color accents.
class ModernCleanTemplate extends BaseResumeTemplate {
  static const _config = TemplateConfig(
    id: 'modern_clean',
    name: 'Modern Clean',
    description: 'Contemporary layout with color accents and refined spacing',
    isPremium: false,
    category: 'modern',
    primaryColor: Color(0xFF4F46E5),
    accentColor: Color(0xFF818CF8),
    thumbnailAsset: 'assets/templates/modern_clean_thumb.png',
  );

  late final _renderer = StructuredResumeTemplate(
    config: _config,
    style: StructuredResumeStyle.clean,
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
