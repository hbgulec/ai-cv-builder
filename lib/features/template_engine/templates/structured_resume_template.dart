import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../domain/entities/template_config.dart';
import '../resume_template_palette.dart';

enum StructuredResumeStyle { classic, clean, sidebar, executive }

/// Shared data-faithful renderer for the core resume archetypes.
class StructuredResumeTemplate extends BaseResumeTemplate {
  StructuredResumeTemplate({
    required this.config,
    required this.style,
  });

  @override
  final TemplateConfig config;
  final StructuredResumeStyle style;

  Color _theme = const Color(0xFF2563EB);
  PdfColor _pdfTheme = PdfColor.fromHex('#2563EB');

  Color get theme => _theme;
  Color get railColor => ResumeTemplatePalette.darken(_theme, .16);
  PdfColor get pdfTheme => _pdfTheme;

  @override
  Widget buildPreview(Map<String, dynamic> resumeData) {
    _theme = templateColor(resumeData, fallback: config.primaryColor);
    final content = _StructuredContent(this, resumeData);
    return style == StructuredResumeStyle.sidebar
        ? _sidebarPreview(content)
        : _horizontalPreview(content);
  }

  Widget _horizontalPreview(_StructuredContent content) => Container(
        height: 538,
        color: _pageBackground,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (content.firstPage) _previewHeader(content),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  27,
                  content.firstPage ? 18 : 27,
                  27,
                  24,
                ),
                child: _sections(content),
              ),
            ),
          ],
        ),
      );

  Widget _sidebarPreview(_StructuredContent content) => SizedBox(
        height: 538,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 126,
              color: railColor,
              padding: const EdgeInsets.fromLTRB(15, 22, 14, 20),
              child: _sidebarIdentity(content),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(21, 25, 21, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (content.firstPage) ...[
                      Text(
                        content.name,
                        style: TextStyle(
                          color: railColor,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (content.role.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          content.role,
                          style: TextStyle(
                            color: theme,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      const SizedBox(height: 15),
                    ],
                    Expanded(
                      child: _sections(
                        content,
                        includeSkills: false,
                        includeLanguages: false,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Color get _pageBackground => switch (style) {
        StructuredResumeStyle.classic => const Color(0xFFFFFEFC),
        StructuredResumeStyle.clean => Colors.white,
        StructuredResumeStyle.executive => const Color(0xFFFFFCF5),
        StructuredResumeStyle.sidebar => Colors.white,
      };

  Widget _previewHeader(_StructuredContent content) {
    if (style == StructuredResumeStyle.clean) {
      return Container(
        width: double.infinity,
        color: theme,
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 22),
        child: _headerIdentity(content, onDark: true),
      );
    }
    if (style == StructuredResumeStyle.executive) {
      return Container(
        width: double.infinity,
        color: const Color(0xFF111827),
        padding: const EdgeInsets.fromLTRB(28, 23, 28, 21),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerIdentity(content, onDark: true),
            Container(
              width: 55,
              height: 2,
              margin: const EdgeInsets.only(top: 12),
              color: theme,
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 25, 28, 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _headerIdentity(content, centered: true),
          Container(
            height: 1,
            margin: const EdgeInsets.only(top: 13),
            color: theme.withValues(alpha: .62),
          ),
        ],
      ),
    );
  }

  Widget _headerIdentity(
    _StructuredContent content, {
    bool onDark = false,
    bool centered = false,
  }) {
    final foreground = onDark ? Colors.white : const Color(0xFF172033);
    final secondary =
        onDark ? const Color(0xFFE5E7EB) : const Color(0xFF526173);
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          content.name,
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            color: foreground,
            fontSize: style == StructuredResumeStyle.classic ? 24 : 25,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (content.role.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            content.role,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              color:
                  style == StructuredResumeStyle.executive ? theme : secondary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        if (content.contact.isNotEmpty) ...[
          const SizedBox(height: 7),
          Text(
            content.contact,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: TextStyle(color: secondary, fontSize: 7.5),
          ),
        ],
      ],
    );
  }

  Widget _sidebarIdentity(_StructuredContent content) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (content.firstPage) ...[
            if (content.photoBytes != null)
              Center(
                child: Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.memory(content.photoBytes!, fit: BoxFit.cover),
                  ),
                ),
              ),
            if (content.contact.isNotEmpty) ...[
              if (content.photoBytes != null) const SizedBox(height: 18),
              _sidebarTitle(content.label('Contact', 'İletişim')),
              const SizedBox(height: 6),
              Text(
                content.contactLines.join('\n'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 7,
                  height: 1.45,
                ),
              ),
            ],
          ],
          if (content.sidebarSkills.isNotEmpty) ...[
            const SizedBox(height: 18),
            _sidebarTitle(content.label('Skills', 'Yetenekler')),
            const SizedBox(height: 7),
            ...content.sidebarSkills.map(
              (item) => _sidebarSkill(
                (item['name'] ?? '').toString(),
                (item['level'] ?? '').toString(),
              ),
            ),
          ],
          if (content.sidebarLanguages.isNotEmpty) ...[
            const SizedBox(height: 14),
            _sidebarTitle(content.label('Languages', 'Diller')),
            const SizedBox(height: 6),
            ...content.sidebarLanguages.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  content.languageLine(item),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 7.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      );

  Widget _sidebarTitle(String title) => Text(
        title.toUpperCase(),
        style: TextStyle(
          color: ResumeTemplatePalette.lighten(theme, .35),
          fontSize: 7.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.25,
        ),
      );

  Widget _sidebarSkill(String name, String level) => Padding(
        padding: const EdgeInsets.only(bottom: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 7.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 3),
            FractionallySizedBox(
              widthFactor: _skillLevel(level),
              child: Container(
                height: 2.5,
                decoration: BoxDecoration(
                  color: ResumeTemplatePalette.lighten(theme, .35),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      );

  double _skillLevel(String level) => switch (level.toLowerCase()) {
        'expert' => 1,
        'advanced' => .82,
        'beginner' => .38,
        _ => .62,
      };

  Widget _sections(
    _StructuredContent content, {
    bool includeSkills = true,
    bool includeLanguages = true,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (content.summary.isNotEmpty)
            _section(
              content.label('Summary', 'Özet'),
              Text(
                content.summary,
                style: const TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 8.5,
                  height: 1.38,
                ),
              ),
            ),
          if (content.experiences.isNotEmpty)
            _section(
              content.label('Experience', 'Deneyim'),
              _entryColumn(
                content.experiences,
                content.experienceWidgets,
              ),
            ),
          if (content.educations.isNotEmpty)
            _section(
              content.label('Education', 'Eğitim'),
              _entryColumn(
                content.educations,
                content.educationWidgets,
              ),
            ),
          if (content.projects.isNotEmpty)
            _section(
              content.label('Projects', 'Projeler'),
              _entryColumn(
                content.projects,
                content.projectWidgets,
              ),
            ),
          if (includeSkills && content.skills.isNotEmpty)
            _section(
              content.label('Skills', 'Yetenekler'),
              Wrap(
                spacing: 5,
                runSpacing: 4,
                children: content.skills
                    .map((item) => (item['name'] ?? '').toString())
                    .where(_notEmpty)
                    .map(
                      (name) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: theme.withValues(alpha: .10),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          name,
                          style: TextStyle(
                            color: railColor,
                            fontSize: 7,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          if (includeLanguages && content.languages.isNotEmpty)
            _section(
              content.label('Languages', 'Diller'),
              Text(
                content.languages.map(content.languageLine).join('  /  '),
                style: const TextStyle(
                  color: Color(0xFF263241),
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      );

  Widget _entryColumn(
    List<Map<String, dynamic>> items,
    List<Widget> Function(Map<String, dynamic>) builder,
  ) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (item) => Padding(
                padding: EdgeInsets.only(
                  bottom: style == StructuredResumeStyle.executive ? 7 : 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: builder(item),
                ),
              ),
            )
            .toList(),
      );

  Widget _section(String title, Widget child) => Padding(
        padding: EdgeInsets.only(
          bottom: style == StructuredResumeStyle.executive ? 8 : 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (style == StructuredResumeStyle.executive)
              Container(
                color: theme,
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 4,
                ),
                child: Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 7.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              )
            else
              Row(
                children: [
                  Container(
                    width: style == StructuredResumeStyle.classic ? 24 : 3,
                    height: style == StructuredResumeStyle.classic ? 1.5 : 13,
                    color: theme,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    title.toUpperCase(),
                    style: TextStyle(
                      color: railColor,
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.05,
                    ),
                  ),
                  if (style == StructuredResumeStyle.classic) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: .7,
                        color: const Color(0xFFD8DEE7),
                      ),
                    ),
                  ],
                ],
              ),
            const SizedBox(height: 6),
            child,
          ],
        ),
      );

  @override
  pw.Page buildPdfPage(
    Map<String, dynamic> resumeData,
    pw.Font regularFont,
    pw.Font boldFont,
  ) {
    _pdfTheme = templatePdfColor(
      resumeData,
      fallback: config.primaryColor,
    );
    final content = _StructuredContent(this, resumeData);
    return style == StructuredResumeStyle.sidebar
        ? _sidebarPdf(content, regularFont, boldFont)
        : _horizontalPdf(content, regularFont, boldFont);
  }

  pw.Page _horizontalPdf(
    _StructuredContent content,
    pw.Font regular,
    pw.Font bold,
  ) =>
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (_) => pw.Container(
          color: style == StructuredResumeStyle.executive
              ? PdfColor.fromHex('#FFFCF5')
              : PdfColors.white,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (content.firstPage) _pdfHeader(content, regular, bold),
              pw.Expanded(
                child: pw.Padding(
                  padding: pw.EdgeInsets.fromLTRB(
                    44,
                    content.firstPage ? 22 : 44,
                    44,
                    40,
                  ),
                  child: _pdfSections(content, regular, bold),
                ),
              ),
            ],
          ),
        ),
      );

  pw.Widget _pdfHeader(
    _StructuredContent content,
    pw.Font regular,
    pw.Font bold,
  ) {
    if (style == StructuredResumeStyle.clean) {
      return pw.Container(
        width: double.infinity,
        color: pdfTheme,
        padding: const pw.EdgeInsets.fromLTRB(44, 37, 44, 32),
        child: _pdfIdentity(
          content,
          regular,
          bold,
          onDark: true,
        ),
      );
    }
    if (style == StructuredResumeStyle.executive) {
      return pw.Container(
        width: double.infinity,
        color: PdfColor.fromHex('#111827'),
        padding: const pw.EdgeInsets.fromLTRB(44, 36, 44, 30),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _pdfIdentity(content, regular, bold, onDark: true),
            pw.Container(
              width: 72,
              height: 2,
              margin: const pw.EdgeInsets.only(top: 14),
              color: pdfTheme,
            ),
          ],
        ),
      );
    }
    return pw.Padding(
      padding: const pw.EdgeInsets.fromLTRB(44, 38, 44, 17),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          _pdfIdentity(
            content,
            regular,
            bold,
            centered: true,
          ),
          pw.Container(
            height: 1,
            margin: const pw.EdgeInsets.only(top: 16),
            color: pdfTheme,
          ),
        ],
      ),
    );
  }

  pw.Widget _pdfIdentity(
    _StructuredContent content,
    pw.Font regular,
    pw.Font bold, {
    bool onDark = false,
    bool centered = false,
  }) {
    final foreground = onDark ? PdfColors.white : PdfColors.grey900;
    final secondary = onDark ? PdfColors.grey200 : PdfColors.grey600;
    return pw.Column(
      crossAxisAlignment:
          centered ? pw.CrossAxisAlignment.center : pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          content.name,
          textAlign: centered ? pw.TextAlign.center : pw.TextAlign.left,
          style: pw.TextStyle(
            font: bold,
            fontSize: 27,
            color: foreground,
          ),
        ),
        if (content.role.isNotEmpty) ...[
          pw.SizedBox(height: 5),
          pw.Text(
            content.role,
            textAlign: centered ? pw.TextAlign.center : pw.TextAlign.left,
            style: pw.TextStyle(
              font: bold,
              fontSize: 9,
              color: style == StructuredResumeStyle.executive
                  ? pdfTheme
                  : secondary,
            ),
          ),
        ],
        if (content.contact.isNotEmpty) ...[
          pw.SizedBox(height: 8),
          pw.Text(
            content.contact,
            textAlign: centered ? pw.TextAlign.center : pw.TextAlign.left,
            style: pw.TextStyle(
              font: regular,
              fontSize: 7.5,
              color: secondary,
            ),
          ),
        ],
      ],
    );
  }

  pw.Page _sidebarPdf(
    _StructuredContent content,
    pw.Font regular,
    pw.Font bold,
  ) =>
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (_) => pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Container(
              width: 205,
              color: pdfTheme,
              padding: const pw.EdgeInsets.fromLTRB(27, 38, 25, 35),
              child: _pdfSidebarIdentity(content, regular, bold),
            ),
            pw.Expanded(
              child: pw.Container(
                color: PdfColors.white,
                padding: const pw.EdgeInsets.fromLTRB(35, 41, 35, 38),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (content.firstPage) ...[
                      pw.Text(
                        content.name,
                        style: pw.TextStyle(
                          font: bold,
                          fontSize: 28,
                          color: pdfTheme,
                        ),
                      ),
                      if (content.role.isNotEmpty) ...[
                        pw.SizedBox(height: 4),
                        pw.Text(
                          content.role,
                          style: pw.TextStyle(
                            font: bold,
                            fontSize: 10,
                            color: pdfTheme,
                          ),
                        ),
                      ],
                      pw.SizedBox(height: 22),
                    ],
                    _pdfSections(
                      content,
                      regular,
                      bold,
                      includeSkills: false,
                      includeLanguages: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  pw.Widget _pdfSidebarIdentity(
    _StructuredContent content,
    pw.Font regular,
    pw.Font bold,
  ) =>
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (content.firstPage) ...[
            if (content.photoBytes != null)
              pw.Center(
                child: pw.ClipOval(
                  child: pw.Image(
                    pw.MemoryImage(content.photoBytes!),
                    width: 76,
                    height: 76,
                    fit: pw.BoxFit.cover,
                  ),
                ),
              ),
            if (content.contactLines.isNotEmpty) ...[
              if (content.photoBytes != null) pw.SizedBox(height: 23),
              _pdfSidebarTitle(content.label('Contact', 'İletişim'), bold),
              pw.SizedBox(height: 7),
              ...content.contactLines.map(
                (line) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4),
                  child: pw.Text(
                    line,
                    style: pw.TextStyle(
                      font: regular,
                      fontSize: 7,
                      color: PdfColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ],
          if (content.sidebarSkills.isNotEmpty) ...[
            pw.SizedBox(height: 21),
            _pdfSidebarTitle(content.label('Skills', 'Yetenekler'), bold),
            pw.SizedBox(height: 7),
            ...content.sidebarSkills.map(
              (item) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 5),
                child: pw.Text(
                  (item['name'] ?? '').toString(),
                  style: pw.TextStyle(
                    font: bold,
                    fontSize: 7.5,
                    color: PdfColors.white,
                  ),
                ),
              ),
            ),
          ],
          if (content.sidebarLanguages.isNotEmpty) ...[
            pw.SizedBox(height: 17),
            _pdfSidebarTitle(content.label('Languages', 'Diller'), bold),
            pw.SizedBox(height: 7),
            ...content.sidebarLanguages.map(
              (item) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 5),
                child: pw.Text(
                  content.languageLine(item),
                  style: pw.TextStyle(
                    font: bold,
                    fontSize: 7.5,
                    color: PdfColors.white,
                  ),
                ),
              ),
            ),
          ],
        ],
      );

  pw.Widget _pdfSidebarTitle(String title, pw.Font bold) => pw.Text(
        title.toUpperCase(),
        style: pw.TextStyle(
          font: bold,
          fontSize: 8,
          color: PdfColors.white,
          letterSpacing: 1.2,
        ),
      );

  pw.Widget _pdfSections(
    _StructuredContent content,
    pw.Font regular,
    pw.Font bold, {
    bool includeSkills = true,
    bool includeLanguages = true,
  }) =>
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (content.summary.isNotEmpty)
            _pdfSection(
              content.label('Summary', 'Özet'),
              [
                pw.Text(
                  content.summary,
                  style: pw.TextStyle(
                    font: regular,
                    fontSize: 8.5,
                    color: PdfColors.grey800,
                    lineSpacing: 1.5,
                  ),
                ),
              ],
              bold,
            ),
          if (content.experiences.isNotEmpty)
            _pdfSection(
              content.label('Experience', 'Deneyim'),
              content.experiences
                  .map(
                    (item) => _pdfExperience(
                      content,
                      item,
                      regular,
                      bold,
                    ),
                  )
                  .toList(),
              bold,
            ),
          if (content.educations.isNotEmpty)
            _pdfSection(
              content.label('Education', 'Eğitim'),
              content.educations
                  .map(
                    (item) => _pdfEducation(
                      content,
                      item,
                      regular,
                      bold,
                    ),
                  )
                  .toList(),
              bold,
            ),
          if (content.projects.isNotEmpty)
            _pdfSection(
              content.label('Projects', 'Projeler'),
              content.projects
                  .map(
                    (item) => _pdfProject(
                      content,
                      item,
                      regular,
                      bold,
                    ),
                  )
                  .toList(),
              bold,
            ),
          if (includeSkills && content.skills.isNotEmpty)
            _pdfSection(
              content.label('Skills', 'Yetenekler'),
              [
                pw.Wrap(
                  spacing: 7,
                  runSpacing: 5,
                  children: content.skills
                      .map((item) => (item['name'] ?? '').toString())
                      .where(_notEmpty)
                      .map(
                        (name) => pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          color: PdfColor.fromHex('#EEF2F7'),
                          child: pw.Text(
                            name,
                            style: pw.TextStyle(
                              font: bold,
                              fontSize: 7,
                              color: pdfTheme,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
              bold,
            ),
          if (includeLanguages && content.languages.isNotEmpty)
            _pdfSection(
              content.label('Languages', 'Diller'),
              [
                pw.Text(
                  content.languages.map(content.languageLine).join('  /  '),
                  style: pw.TextStyle(
                    font: bold,
                    fontSize: 8,
                    color: PdfColors.grey800,
                  ),
                ),
              ],
              bold,
            ),
        ],
      );

  pw.Widget _pdfSection(
    String title,
    List<pw.Widget> children,
    pw.Font bold,
  ) =>
      pw.Padding(
        padding: pw.EdgeInsets.only(
          bottom: style == StructuredResumeStyle.executive ? 11 : 15,
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (style == StructuredResumeStyle.executive)
              pw.Container(
                color: pdfTheme,
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 4,
                ),
                child: pw.Text(
                  title.toUpperCase(),
                  style: pw.TextStyle(
                    font: bold,
                    fontSize: 8,
                    color: PdfColors.white,
                  ),
                ),
              )
            else
              pw.Text(
                title.toUpperCase(),
                style: pw.TextStyle(
                  font: bold,
                  fontSize: 9,
                  color: pdfTheme,
                  letterSpacing: 1.1,
                ),
              ),
            pw.SizedBox(height: 7),
            ...children,
          ],
        ),
      );

  pw.Widget _pdfExperience(
    _StructuredContent content,
    Map<String, dynamic> item,
    pw.Font regular,
    pw.Font bold,
  ) =>
      pw.Padding(
        padding: pw.EdgeInsets.only(
          bottom: style == StructuredResumeStyle.executive ? 7 : 8,
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              (item['jobTitle'] ?? '').toString(),
              style: pw.TextStyle(font: bold, fontSize: 9),
            ),
            if (content.experienceMeta(item).isNotEmpty)
              pw.Text(
                content.experienceMeta(item),
                style: pw.TextStyle(
                  font: regular,
                  fontSize: 7.5,
                  color: PdfColors.grey700,
                ),
              ),
            ...content.stringList(item['bulletPoints']).map(
                  (bullet) => pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 2),
                    child: pw.Text(
                      '- $bullet',
                      style: pw.TextStyle(
                        font: regular,
                        fontSize: 7.5,
                        color: PdfColors.grey800,
                      ),
                    ),
                  ),
                ),
          ],
        ),
      );

  pw.Widget _pdfEducation(
    _StructuredContent content,
    Map<String, dynamic> item,
    pw.Font regular,
    pw.Font bold,
  ) =>
      pw.Padding(
        padding: pw.EdgeInsets.only(
          bottom: style == StructuredResumeStyle.executive ? 7 : 8,
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              (item['degree'] ?? '').toString(),
              style: pw.TextStyle(font: bold, fontSize: 9),
            ),
            if (content.educationMeta(item).isNotEmpty)
              pw.Text(
                content.educationMeta(item),
                style: pw.TextStyle(
                  font: regular,
                  fontSize: 7.5,
                  color: PdfColors.grey700,
                ),
              ),
            ...content.stringList(item['highlights']).map(
                  (highlight) => pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 2),
                    child: pw.Text(
                      '- $highlight',
                      style: pw.TextStyle(font: regular, fontSize: 7.5),
                    ),
                  ),
                ),
          ],
        ),
      );

  pw.Widget _pdfProject(
    _StructuredContent content,
    Map<String, dynamic> item,
    pw.Font regular,
    pw.Font bold,
  ) {
    final technologies = content.stringList(item['technologies']).join(', ');
    final techLabel = content.label('Tech', 'Teknolojiler');
    return pw.Padding(
      padding: pw.EdgeInsets.only(
        bottom: style == StructuredResumeStyle.executive ? 7 : 8,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            (item['title'] ?? '').toString(),
            style: pw.TextStyle(font: bold, fontSize: 9),
          ),
          if (_notEmpty(item['description']))
            pw.Text(
              item['description'].toString(),
              style: pw.TextStyle(font: regular, fontSize: 7.5),
            ),
          if (_notEmpty(item['url']))
            pw.Text(
              item['url'].toString(),
              style: pw.TextStyle(
                font: regular,
                fontSize: 7.5,
                color: pdfTheme,
              ),
            ),
          if (technologies.isNotEmpty)
            pw.Text(
              '$techLabel: $technologies',
              style: pw.TextStyle(
                font: regular,
                fontSize: 7.5,
                color: PdfColors.grey700,
              ),
            ),
        ],
      ),
    );
  }
}

class _StructuredContent {
  _StructuredContent(this.renderer, Map<String, dynamic> data)
      : language = renderer.getLanguageCode(data),
        firstPage = renderer.isFirstPage(data),
        header = renderer.safeToMap(data['header']),
        summary = (data['summary'] ?? '').toString(),
        experiences = renderer.safeToListOfMap(data['workExperiences']),
        educations = renderer.safeToListOfMap(data['educationList']),
        projects = renderer.safeToListOfMap(data['projects']),
        skills = renderer.safeToListOfMap(data['skills']),
        languages = renderer.safeToListOfMap(data['languages']),
        photoBytes = renderer.resolvePhotoBytes(data) {
    final pageSkills = renderer.safeToListOfMap(data['_sidebarSkills']);
    final pageLanguages = renderer.safeToListOfMap(data['_sidebarLanguages']);
    sidebarSkills = pageSkills.isEmpty ? skills : pageSkills;
    sidebarLanguages = pageLanguages.isEmpty ? languages : pageLanguages;
  }

  final StructuredResumeTemplate renderer;
  final String language;
  final bool firstPage;
  final Map<String, dynamic> header;
  final String summary;
  final List<Map<String, dynamic>> experiences;
  final List<Map<String, dynamic>> educations;
  final List<Map<String, dynamic>> projects;
  final List<Map<String, dynamic>> skills;
  final List<Map<String, dynamic>> languages;
  final Uint8List? photoBytes;
  late final List<Map<String, dynamic>> sidebarSkills;
  late final List<Map<String, dynamic>> sidebarLanguages;

  String get name {
    final value = (header['fullName'] ?? '').toString().trim();
    return value.isEmpty ? 'Your Name' : value;
  }

  String get role => (header['professionalTitle'] ?? '').toString().trim();

  List<String> get contactLines => [
        header['email'],
        header['phone'],
        header['location'],
        header['linkedinUrl'],
        header['githubUrl'],
        header['portfolioUrl'],
      ].where(_notEmpty).map((value) => value.toString()).toList();

  String get contact => contactLines.join('  /  ');

  String get initials {
    final parts =
        name.split(RegExp(r'\s+')).where((part) => part.isNotEmpty).take(2);
    return parts.map((part) => part[0].toUpperCase()).join();
  }

  String label(String english, String turkish) =>
      language == 'tr' ? turkish : english;

  String dateFor(Map<String, dynamic> item) => renderer.formatDateRange(
        item['startDate'],
        item['endDate'],
        item['isCurrent'],
        languageCode: language,
      );

  String experienceMeta(Map<String, dynamic> item) => [
        item['company'],
        item['location'],
        dateFor(item),
      ].where(_notEmpty).join('  /  ');

  String educationMeta(Map<String, dynamic> item) {
    final gpa = (item['gpa'] ?? '').toString().trim();
    final gpaText = gpa.isEmpty ? null : 'GPA: $gpa';
    return [
      item['institution'],
      item['location'],
      dateFor(item),
      gpaText,
    ].where(_notEmpty).join('  /  ');
  }

  String languageLine(Map<String, dynamic> item) {
    final name = (item['language'] ?? '').toString().trim();
    final proficiency = (item['proficiency'] ?? '').toString().trim();
    if (name.isEmpty) return proficiency;
    if (proficiency.isEmpty) return name;
    return '$name - $proficiency';
  }

  List<String> stringList(dynamic value) {
    if (value is! List) return const [];
    return value
        .map((entry) => entry.toString().trim())
        .where((entry) => entry.isNotEmpty)
        .toList();
  }

  List<Widget> experienceWidgets(Map<String, dynamic> item) => [
        Text(
          (item['jobTitle'] ?? '').toString(),
          style: const TextStyle(
            color: Color(0xFF172033),
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (experienceMeta(item).isNotEmpty)
          Text(
            experienceMeta(item),
            style: TextStyle(
              color: renderer.theme,
              fontSize: 7.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ...stringList(item['bulletPoints']).map(
          (bullet) => Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              '• $bullet',
              style: const TextStyle(
                color: Color(0xFF374151),
                fontSize: 7.5,
                height: 1.3,
              ),
            ),
          ),
        ),
      ];

  List<Widget> educationWidgets(Map<String, dynamic> item) => [
        Text(
          (item['degree'] ?? '').toString(),
          style: const TextStyle(
            color: Color(0xFF172033),
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (educationMeta(item).isNotEmpty)
          Text(
            educationMeta(item),
            style: const TextStyle(
              color: Color(0xFF526173),
              fontSize: 7.5,
            ),
          ),
        ...stringList(item['highlights']).map(
          (highlight) => Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              '• $highlight',
              style: const TextStyle(
                color: Color(0xFF374151),
                fontSize: 7.5,
              ),
            ),
          ),
        ),
      ];

  List<Widget> projectWidgets(Map<String, dynamic> item) {
    final technologies = stringList(item['technologies']).join(', ');
    final techLabel = label('Tech', 'Teknolojiler');
    return [
      Text(
        (item['title'] ?? '').toString(),
        style: const TextStyle(
          color: Color(0xFF172033),
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
      if (_notEmpty(item['description']))
        Text(
          item['description'].toString(),
          style: const TextStyle(
            color: Color(0xFF374151),
            fontSize: 7.5,
          ),
        ),
      if (_notEmpty(item['url']))
        Text(
          item['url'].toString(),
          style: TextStyle(
            color: renderer.theme,
            fontSize: 7.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      if (technologies.isNotEmpty)
        Text(
          '$techLabel: $technologies',
          style: const TextStyle(
            color: Color(0xFF526173),
            fontSize: 7.5,
            fontStyle: FontStyle.italic,
          ),
        ),
    ];
  }
}

bool _notEmpty(dynamic value) =>
    value != null && value.toString().trim().isNotEmpty;
