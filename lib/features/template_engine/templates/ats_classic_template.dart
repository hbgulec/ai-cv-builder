import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;

import '../domain/entities/template_config.dart';
import 'structured_resume_template.dart';

/// ATS-focused single-column resume with conservative document styling.
class AtsClassicTemplate extends BaseResumeTemplate {
  static const _config = TemplateConfig(
    id: 'ats_classic',
    name: 'ATS Classic',
    description:
        'Clean, single-column ATS-optimized layout with standard formatting',
    isPremium: false,
    category: 'ats',
    primaryColor: Color(0xFF1E293B),
    accentColor: Color(0xFF334155),
    thumbnailAsset: 'assets/templates/ats_classic_thumb.png',
  );

  late final _renderer = StructuredResumeTemplate(
    config: _config,
    style: StructuredResumeStyle.classic,
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
