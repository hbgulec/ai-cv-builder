import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;

import '../domain/entities/template_config.dart';
import 'structured_resume_template.dart';

/// Premium dark-header resume for senior and executive profiles.
class ExecutiveProTemplate extends BaseResumeTemplate {
  static const _config = TemplateConfig(
    id: 'executive_pro',
    name: 'Executive Pro',
    description:
        'Premium dark-header layout with timeline experience for senior leadership',
    isPremium: true,
    category: 'executive',
    primaryColor: Color(0xFF111827),
    accentColor: Color(0xFFF59E0B),
    thumbnailAsset: 'assets/templates/executive_pro_thumb.png',
  );

  late final _renderer = StructuredResumeTemplate(
    config: _config,
    style: StructuredResumeStyle.executive,
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
