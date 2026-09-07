import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../domain/entities/template_config.dart';

enum SignatureResumeVariant { lisbon, toronto, monaco, tokyo }

/// Four distinct international resume archetypes with shared data fidelity.
class SignatureResumeTemplate extends BaseResumeTemplate {
  SignatureResumeTemplate.lisbon() : variant = SignatureResumeVariant.lisbon;
  SignatureResumeTemplate.toronto() : variant = SignatureResumeVariant.toronto;
  SignatureResumeTemplate.monaco() : variant = SignatureResumeVariant.monaco;
  SignatureResumeTemplate.tokyo() : variant = SignatureResumeVariant.tokyo;

  final SignatureResumeVariant variant;
  Color _selectedColor = const Color(0xFFB4533C);
  PdfColor _selectedPdfColor = PdfColor.fromHex('#B4533C');

  @override
  TemplateConfig get config => switch (variant) {
        SignatureResumeVariant.lisbon => const TemplateConfig(
            id: 'lisbon',
            name: 'Lisbon',
            description: 'Warm editorial grid with a compact information rail',
            isPremium: false,
            category: 'modern',
            primaryColor: Color(0xFFB4533C),
            accentColor: Color(0xFFE6A06F),
            thumbnailAsset: 'assets/templates/lisbon.png'),
        SignatureResumeVariant.toronto => const TemplateConfig(
            id: 'toronto',
            name: 'Toronto',
            description: 'ATS-friendly chronology with a crisp timeline',
            isPremium: false,
            category: 'ats',
            primaryColor: Color(0xFF315E73),
            accentColor: Color(0xFF72A7B7),
            thumbnailAsset: 'assets/templates/toronto.png'),
        SignatureResumeVariant.monaco => const TemplateConfig(
            id: 'monaco',
            name: 'Monaco',
            description:
                'Luxury executive split with restrained gold detailing',
            isPremium: true,
            category: 'executive',
            primaryColor: Color(0xFF171717),
            accentColor: Color(0xFFC9A45D),
            thumbnailAsset: 'assets/templates/monaco.png'),
        SignatureResumeVariant.tokyo => const TemplateConfig(
            id: 'tokyo',
            name: 'Tokyo',
            description:
                'Asymmetric editorial composition for creative leaders',
            isPremium: true,
            category: 'creative',
            primaryColor: Color(0xFFB4232D),
            accentColor: Color(0xFFE7B7AA),
            thumbnailAsset: 'assets/templates/tokyo.png'),
      };

  Color get accent => variant == SignatureResumeVariant.monaco
      ? config.accentColor
      : _selectedColor;
  Color get primary => _selectedColor;
  PdfColor get pdfAccent => variant == SignatureResumeVariant.monaco
      ? PdfColor.fromHex('#C9A45D')
      : _selectedPdfColor;
  PdfColor get pdfPrimary => _selectedPdfColor;

  @override
  Widget buildPreview(Map<String, dynamic> resumeData) {
    _selectedColor = templateColor(resumeData, fallback: config.primaryColor);
    final content = _Content(this, resumeData);
    return switch (variant) {
      SignatureResumeVariant.lisbon => _lisbon(content),
      SignatureResumeVariant.toronto => _toronto(content),
      SignatureResumeVariant.monaco => _monaco(content),
      SignatureResumeVariant.tokyo => _tokyo(content),
    };
  }

  Widget _lisbon(_Content content) => Container(
        height: 538,
        color: const Color(0xFFFFFBF5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (content.firstPage) ...[
              Container(height: 9, color: accent),
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 18, 26, 14),
                child: _identity(content, serif: true),
              ),
              const Divider(height: 1, indent: 26, endIndent: 26),
            ],
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    26, content.firstPage ? 16 : 26, 26, 22),
                child: content.firstPage
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 104, child: _lisbonAside(content)),
                          Container(
                            width: 1,
                            height: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 17),
                            color: const Color(0xFFE7D8C8),
                          ),
                          Expanded(
                            child: _sections(
                              content,
                              includeSkills: false,
                              includeLanguages: false,
                            ),
                          ),
                        ],
                      )
                    : _sections(content, dense: true),
              ),
            ),
          ],
        ),
      );

  Widget _toronto(_Content content) => Container(
        height: 538,
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (content.firstPage) ...[
              Row(
                children: [
                  Expanded(child: _identity(content)),
                  if (content.photoBytes != null)
                    Container(
                      width: 48,
                      height: 48,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: accent, width: 2),
                      ),
                      child: ClipOval(
                        child: Image.memory(
                          content.photoBytes!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
              if (content.contact.isNotEmpty) ...[
                const SizedBox(height: 7),
                Text(
                  content.contact,
                  style: const TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 8,
                  ),
                ),
              ],
              const SizedBox(height: 15),
            ],
            Expanded(child: _timelineSections(content)),
          ],
        ),
      );

  Widget _monaco(_Content content) => SizedBox(
        height: 538,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 142,
              color: primary,
              padding: const EdgeInsets.fromLTRB(20, 26, 18, 22),
              child: _monacoRail(content),
            ),
            Expanded(
              child: Container(
                color: const Color(0xFFF5F0E7),
                padding: EdgeInsets.fromLTRB(
                    24, content.firstPage ? 28 : 30, 24, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (content.firstPage) ...[
                      Text(
                        content.name,
                        style: const TextStyle(
                          color: Color(0xFF171717),
                          fontSize: 27,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'serif',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'MONACO / EXECUTIVE DOSSIER',
                        style: TextStyle(
                          color: accent,
                          fontSize: 7,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                    Expanded(
                      child: _sections(
                        content,
                        premium: true,
                        includeSkills: false,
                        includeLanguages: false,
                        dense: !content.firstPage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget _tokyo(_Content content) => Container(
        height: 538,
        color: const Color(0xFFFFFAF3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (content.firstPage)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(27, 24, 18, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (content.photoBytes != null)
                              ClipOval(
                                child: Image.memory(
                                  content.photoBytes!,
                                  width: 54,
                                  height: 54,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if (content.contact.isNotEmpty) ...[
                              if (content.photoBytes != null)
                                const SizedBox(height: 13),
                              Text(
                                content.contact,
                                style: const TextStyle(
                                  color: Color(0xFF514C48),
                                  fontSize: 7,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 158,
                      color: primary,
                      padding: const EdgeInsets.fromLTRB(19, 25, 18, 21),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            content.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                              height: 1.05,
                            ),
                          ),
                          if (content.role.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              content.role,
                              style: const TextStyle(
                                color: Color(0xFFFFE6DF),
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    27, content.firstPage ? 20 : 27, 27, 24),
                child: _numberedSections(content),
              ),
            ),
          ],
        ),
      );

  Widget _identity(_Content content, {bool serif = false}) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content.name,
            style: TextStyle(
              color: const Color(0xFF27211E),
              fontSize: serif ? 27 : 24,
              fontWeight: serif ? FontWeight.w500 : FontWeight.w800,
              fontFamily: serif ? 'serif' : null,
            ),
          ),
          if (content.role.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              content.role,
              style: TextStyle(
                color: accent,
                fontSize: 8,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ],
      );

  Widget _lisbonAside(_Content content) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (content.contact.isNotEmpty)
            _section(
              content.label('Contact', 'İletişim'),
              Text(content.contact, style: _body(false)),
              compact: true,
            ),
          if (content.skills.isNotEmpty)
            _plainList(
              content.label('Skills', 'Yetenekler'),
              content.skills
                  .map((item) => (item['name'] ?? '').toString())
                  .where(_notEmpty)
                  .toList(),
            ),
          if (content.languages.isNotEmpty)
            _plainList(
              content.label('Languages', 'Diller'),
              content.languages.map(content.languageLine).toList(),
            ),
        ],
      );

  Widget _monacoRail(_Content content) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (content.firstPage) ...[
            if (content.photoBytes != null)
              Center(
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: accent, width: 2),
                  ),
                  child: ClipOval(
                    child: Image.memory(content.photoBytes!, fit: BoxFit.cover),
                  ),
                ),
              ),
            Container(
              width: 28,
              height: 2,
              margin: EdgeInsets.only(
                  top: content.photoBytes != null ? 13 : 0, bottom: 13),
              color: accent,
            ),
            if (content.role.isNotEmpty)
              Text(
                content.role,
                style: TextStyle(
                  color: accent,
                  fontSize: 8,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.3,
                ),
              ),
            if (content.contact.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                content.contact,
                style: const TextStyle(
                  color: Color(0xFFF3EDE3),
                  fontSize: 7.5,
                  height: 1.5,
                ),
              ),
            ],
          ],
          if (content.sidebarSkills.isNotEmpty) ...[
            const SizedBox(height: 18),
            _darkList(
              content.label('Skills', 'Yetenekler'),
              content.sidebarSkills
                  .map((item) => (item['name'] ?? '').toString())
                  .where(_notEmpty)
                  .toList(),
            ),
          ],
          if (content.sidebarLanguages.isNotEmpty) ...[
            const SizedBox(height: 12),
            _darkList(
              content.label('Languages', 'Diller'),
              content.sidebarLanguages.map(content.languageLine).toList(),
            ),
          ],
        ],
      );

  Widget _plainList(String title, List<String> values) => _section(
        title,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: values
              .where(_notEmpty)
              .map(
                (value) => Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Color(0xFF604D45),
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        compact: true,
      );

  Widget _darkList(String title, List<String> values) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: accent,
              fontSize: 7,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          ...values.where(_notEmpty).map(
                (value) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Color(0xFFF5F0E7),
                      fontSize: 7.5,
                    ),
                  ),
                ),
              ),
        ],
      );

  Widget _timelineSections(_Content content) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _data(content)
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            color: accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: 1,
                          height: 36,
                          color: const Color(0xFFCBD5E1),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _section(item.key, item.value, compact: true),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      );

  Widget _numberedSections(_Content content) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _data(content)
            .indexed
            .map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 33,
                      child: Text(
                        '${(entry.$1 + 1).toString().padLeft(2, '0')}.',
                        style: TextStyle(
                          color: accent,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _section(
                        entry.$2.key,
                        entry.$2.value,
                        compact: true,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      );

  Widget _sections(
    _Content content, {
    bool premium = false,
    bool includeSkills = true,
    bool includeLanguages = true,
    bool dense = false,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _data(
          content,
          includeSkills: includeSkills,
          includeLanguages: includeLanguages,
          dense: dense,
        )
            .map(
              (item) => _section(
                item.key,
                item.value,
                premium: premium,
                dense: dense,
              ),
            )
            .toList(),
      );

  List<MapEntry<String, Widget>> _data(
    _Content content, {
    bool includeSkills = true,
    bool includeLanguages = true,
    bool dense = false,
  }) {
    final result = <MapEntry<String, Widget>>[];
    if (content.summary.isNotEmpty) {
      result.add(
        MapEntry(
          content.label('Profile', 'Profil'),
          Text(content.summary, style: _body(false)),
        ),
      );
    }
    if (content.experiences.isNotEmpty) {
      result.add(
        MapEntry(
          content.label('Experience', 'Deneyim'),
          _entryList(
            content.experiences,
            content.experienceWidgets,
            dense: dense,
          ),
        ),
      );
    }
    if (content.educations.isNotEmpty) {
      result.add(
        MapEntry(
          content.label('Education', 'Eğitim'),
          _entryList(
            content.educations,
            content.educationWidgets,
            dense: dense,
          ),
        ),
      );
    }
    if (content.projects.isNotEmpty) {
      result.add(
        MapEntry(
          content.label('Projects', 'Projeler'),
          _entryList(
            content.projects,
            content.projectWidgets,
            dense: dense,
          ),
        ),
      );
    }
    if (includeSkills && content.skills.isNotEmpty) {
      result.add(
        MapEntry(
          content.label('Skills', 'Yetenekler'),
          Wrap(
            spacing: 5,
            runSpacing: 4,
            children: content.skills
                .map((item) => (item['name'] ?? '').toString())
                .where(_notEmpty)
                .map(
                  (name) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    color: accent.withValues(alpha: .10),
                    child: Text(
                      name,
                      style: TextStyle(
                        color: accent,
                        fontSize: 7,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    }
    if (includeLanguages && content.languages.isNotEmpty) {
      result.add(
        MapEntry(
          content.label('Languages', 'Diller'),
          Text(
            content.languages.map(content.languageLine).join('  /  '),
            style: const TextStyle(
              color: Color(0xFF3F3A37),
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
    return result;
  }

  Widget _entryList(
    List<Map<String, dynamic>> items,
    List<Widget> Function(Map<String, dynamic>) builder, {
    bool dense = false,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: dense ? 5 : 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: builder(item),
                ),
              ),
            )
            .toList(),
      );

  Widget _section(
    String title,
    Widget child, {
    bool compact = false,
    bool premium = false,
    bool dense = false,
  }) =>
      Padding(
        padding: EdgeInsets.only(bottom: compact ? 0 : (dense ? 9 : 13)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (premium) ...[
                  Container(width: 18, height: 1.5, color: accent),
                  const SizedBox(width: 7),
                ],
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    color: premium ? const Color(0xFF171717) : accent,
                    fontSize: compact ? 8 : 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            child,
          ],
        ),
      );

  TextStyle _body(bool dark) => TextStyle(
        color: dark ? const Color(0xFFF5F0E7) : const Color(0xFF403B38),
        fontSize: 8,
        height: 1.4,
      );

  @override
  pw.Page buildPdfPage(
    Map<String, dynamic> resumeData,
    pw.Font regularFont,
    pw.Font boldFont,
  ) {
    _selectedPdfColor =
        templatePdfColor(resumeData, fallback: config.primaryColor);
    final content = _Content(this, resumeData);
    if (variant == SignatureResumeVariant.monaco) {
      return _pdfMonaco(content, regularFont, boldFont);
    }
    return _pdfHorizontal(content, regularFont, boldFont);
  }

  pw.Page _pdfHorizontal(_Content content, pw.Font regular, pw.Font bold) {
    final background = variant == SignatureResumeVariant.lisbon
        ? PdfColor.fromHex('#FFFBF5')
        : variant == SignatureResumeVariant.tokyo
            ? PdfColor.fromHex('#FFFAF3')
            : PdfColors.white;
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (_) => pw.Container(
        color: background,
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (content.firstPage && variant == SignatureResumeVariant.lisbon)
              pw.Container(height: 11, color: pdfAccent),
            if (content.firstPage)
              pw.Container(
                width: double.infinity,
                color:
                    variant == SignatureResumeVariant.tokyo ? pdfPrimary : null,
                padding: const pw.EdgeInsets.fromLTRB(44, 34, 44, 24),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (content.photoBytes != null &&
                        variant != SignatureResumeVariant.lisbon) ...[
                      pw.ClipOval(
                          child: pw.Image(pw.MemoryImage(content.photoBytes!),
                              width: 68, height: 68, fit: pw.BoxFit.cover)),
                      pw.SizedBox(height: 12),
                    ],
                    pw.Text(
                      content.name,
                      style: pw.TextStyle(
                        font: bold,
                        fontSize: 27,
                        color: variant == SignatureResumeVariant.tokyo
                            ? PdfColors.white
                            : PdfColors.grey900,
                      ),
                    ),
                    if (content.role.isNotEmpty) ...[
                      pw.SizedBox(height: 5),
                      pw.Text(
                        content.role,
                        style: pw.TextStyle(
                          font: bold,
                          fontSize: 8,
                          color: variant == SignatureResumeVariant.tokyo
                              ? PdfColors.grey200
                              : pdfAccent,
                        ),
                      ),
                    ],
                    if (content.contact.isNotEmpty &&
                        variant != SignatureResumeVariant.lisbon) ...[
                      pw.SizedBox(height: 7),
                      pw.Text(
                        content.contact,
                        style: pw.TextStyle(
                          font: regular,
                          fontSize: 8,
                          color: variant == SignatureResumeVariant.tokyo
                              ? PdfColors.grey200
                              : PdfColors.grey600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            pw.Expanded(
              child: pw.Padding(
                padding: pw.EdgeInsets.fromLTRB(
                    44, content.firstPage ? 15 : 40, 44, 40),
                child: variant == SignatureResumeVariant.lisbon &&
                        content.firstPage
                    ? pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(
                            width: 125,
                            child: _pdfLisbonAside(content, regular, bold),
                          ),
                          pw.Container(
                            width: 1,
                            height: double.infinity,
                            margin:
                                const pw.EdgeInsets.symmetric(horizontal: 22),
                            color: PdfColor.fromHex('#E7D8C8'),
                          ),
                          pw.Expanded(
                            child: _pdfSections(
                              content,
                              regular,
                              bold,
                              includeSkills: false,
                              includeLanguages: false,
                            ),
                          ),
                        ],
                      )
                    : _pdfSections(content, regular, bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  pw.Page _pdfMonaco(_Content content, pw.Font regular, pw.Font bold) =>
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (_) => pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Container(
              width: 220,
              color: pdfPrimary,
              padding: const pw.EdgeInsets.fromLTRB(30, 43, 28, 38),
              child: _pdfMonacoRail(content, regular, bold),
            ),
            pw.Expanded(
              child: pw.Container(
                color: PdfColor.fromHex('#F5F0E7'),
                padding: const pw.EdgeInsets.fromLTRB(38, 45, 38, 40),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (content.firstPage) ...[
                      pw.Text(
                        content.name,
                        style: pw.TextStyle(
                          font: bold,
                          fontSize: 28,
                          color: PdfColors.grey900,
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        'MONACO / EXECUTIVE DOSSIER',
                        style: pw.TextStyle(
                          font: bold,
                          fontSize: 7,
                          color: pdfAccent,
                        ),
                      ),
                      pw.SizedBox(height: 24),
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

  pw.Widget _pdfLisbonAside(
    _Content content,
    pw.Font regular,
    pw.Font bold,
  ) {
    final children = <pw.Widget>[];
    if (content.contact.isNotEmpty) {
      children.addAll([
        _pdfMiniTitle(content.label('Contact', 'İletişim'), bold),
        pw.Text(
          content.contact,
          style: pw.TextStyle(
            font: regular,
            fontSize: 7.5,
            color: PdfColors.grey700,
          ),
        ),
        pw.SizedBox(height: 15),
      ]);
    }
    if (content.skills.isNotEmpty) {
      children.addAll([
        _pdfMiniTitle(content.label('Skills', 'Yetenekler'), bold),
        ...content.skills
            .map((item) => (item['name'] ?? '').toString())
            .where(_notEmpty)
            .map(
              (name) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 4),
                child: pw.Text(
                  name,
                  style: pw.TextStyle(font: regular, fontSize: 8),
                ),
              ),
            ),
        pw.SizedBox(height: 11),
      ]);
    }
    if (content.languages.isNotEmpty) {
      children.addAll([
        _pdfMiniTitle(content.label('Languages', 'Diller'), bold),
        ...content.languages.map(
          (item) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 4),
            child: pw.Text(
              content.languageLine(item),
              style: pw.TextStyle(font: regular, fontSize: 8),
            ),
          ),
        ),
      ]);
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: children,
    );
  }

  pw.Widget _pdfMonacoRail(
    _Content content,
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
                    width: 68,
                    height: 68,
                    fit: pw.BoxFit.cover,
                  ),
                ),
              ),
            if (content.photoBytes != null) pw.SizedBox(height: 16),
            if (content.role.isNotEmpty)
              pw.Text(
                content.role,
                style: pw.TextStyle(
                  font: bold,
                  fontSize: 8,
                  color: pdfAccent,
                ),
              ),
            if (content.contact.isNotEmpty) ...[
              pw.SizedBox(height: 17),
              pw.Text(
                content.contact,
                style: pw.TextStyle(
                  font: regular,
                  fontSize: 7.5,
                  color: PdfColors.grey200,
                ),
              ),
            ],
          ],
          if (content.sidebarSkills.isNotEmpty) ...[
            pw.SizedBox(height: 22),
            _pdfDarkList(
              content.label('Skills', 'Yetenekler'),
              content.sidebarSkills
                  .map((item) => (item['name'] ?? '').toString())
                  .where(_notEmpty)
                  .toList(),
              regular,
              bold,
            ),
          ],
          if (content.sidebarLanguages.isNotEmpty) ...[
            pw.SizedBox(height: 18),
            _pdfDarkList(
              content.label('Languages', 'Diller'),
              content.sidebarLanguages.map(content.languageLine).toList(),
              regular,
              bold,
            ),
          ],
        ],
      );

  pw.Widget _pdfDarkList(
    String title,
    List<String> values,
    pw.Font regular,
    pw.Font bold,
  ) =>
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title.toUpperCase(),
            style: pw.TextStyle(font: bold, fontSize: 7, color: pdfAccent),
          ),
          pw.SizedBox(height: 6),
          ...values.where(_notEmpty).map(
                (value) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4),
                  child: pw.Text(
                    value,
                    style: pw.TextStyle(
                      font: regular,
                      fontSize: 7.5,
                      color: PdfColors.grey200,
                    ),
                  ),
                ),
              ),
        ],
      );

  pw.Widget _pdfMiniTitle(String title, pw.Font bold) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 6),
        child: pw.Text(
          title.toUpperCase(),
          style: pw.TextStyle(
            font: bold,
            fontSize: 8,
            color: pdfAccent,
            letterSpacing: 1,
          ),
        ),
      );

  pw.Widget _pdfSections(
    _Content content,
    pw.Font regular,
    pw.Font bold, {
    bool includeSkills = true,
    bool includeLanguages = true,
  }) {
    final sections = <MapEntry<String, List<pw.Widget>>>[];
    if (content.summary.isNotEmpty) {
      sections.add(
        MapEntry(
          content.label('Profile', 'Profil'),
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
        ),
      );
    }
    if (content.experiences.isNotEmpty) {
      sections.add(
        MapEntry(
          content.label('Experience', 'Deneyim'),
          content.experiences
              .map((item) => _pdfExperience(content, item, regular, bold))
              .toList(),
        ),
      );
    }
    if (content.educations.isNotEmpty) {
      sections.add(
        MapEntry(
          content.label('Education', 'Eğitim'),
          content.educations
              .map((item) => _pdfEducation(content, item, regular, bold))
              .toList(),
        ),
      );
    }
    if (content.projects.isNotEmpty) {
      sections.add(
        MapEntry(
          content.label('Projects', 'Projeler'),
          content.projects
              .map((item) => _pdfProject(content, item, regular, bold))
              .toList(),
        ),
      );
    }
    if (includeSkills && content.skills.isNotEmpty) {
      sections.add(
        MapEntry(
          content.label('Skills', 'Yetenekler'),
          [
            pw.Text(
              content.skills
                  .map((item) => (item['name'] ?? '').toString())
                  .where(_notEmpty)
                  .join('  /  '),
              style: pw.TextStyle(
                font: bold,
                fontSize: 8,
                color: pdfAccent,
              ),
            ),
          ],
        ),
      );
    }
    if (includeLanguages && content.languages.isNotEmpty) {
      sections.add(
        MapEntry(
          content.label('Languages', 'Diller'),
          [
            pw.Text(
              content.languages.map(content.languageLine).join('  /  '),
              style: pw.TextStyle(
                font: regular,
                fontSize: 8,
                color: PdfColors.grey800,
              ),
            ),
          ],
        ),
      );
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: sections
          .map(
            (entry) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 14),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    entry.key.toUpperCase(),
                    style: pw.TextStyle(
                      font: bold,
                      fontSize: 9,
                      color: pdfAccent,
                      letterSpacing: 1.1,
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  ...entry.value,
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  pw.Widget _pdfExperience(
    _Content content,
    Map<String, dynamic> item,
    pw.Font regular,
    pw.Font bold,
  ) =>
      pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 8),
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
    _Content content,
    Map<String, dynamic> item,
    pw.Font regular,
    pw.Font bold,
  ) =>
      pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 8),
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
    _Content content,
    Map<String, dynamic> item,
    pw.Font regular,
    pw.Font bold,
  ) =>
      pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 8),
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
                  color: pdfAccent,
                ),
              ),
            if (content.stringList(item['technologies']).isNotEmpty)
              pw.Text(
                content.label('Tech: ', 'Teknolojiler: ') +
                    content.stringList(item['technologies']).join(', '),
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

class _Content {
  _Content(this.renderer, Map<String, dynamic> data)
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
    final pageSidebarSkills = renderer.safeToListOfMap(data['_sidebarSkills']);
    final pageSidebarLanguages =
        renderer.safeToListOfMap(data['_sidebarLanguages']);
    sidebarSkills = pageSidebarSkills.isEmpty ? skills : pageSidebarSkills;
    sidebarLanguages =
        pageSidebarLanguages.isEmpty ? languages : pageSidebarLanguages;
  }

  final SignatureResumeTemplate renderer;
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

  String get contact => [
        header['email'],
        header['phone'],
        header['location'],
        header['linkedinUrl'],
        header['githubUrl'],
        header['portfolioUrl'],
      ].where(_notEmpty).join('  /  ');

  String get initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2);
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

  String educationMeta(Map<String, dynamic> item) => [
        item['institution'],
        item['location'],
        dateFor(item),
        _notEmpty(item['gpa']) ? 'GPA: ${item['gpa']}' : null,
      ].where(_notEmpty).join('  /  ');

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
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  List<Widget> experienceWidgets(Map<String, dynamic> item) => [
        Text(
          (item['jobTitle'] ?? '').toString(),
          style: const TextStyle(
            color: Color(0xFF27211E),
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (experienceMeta(item).isNotEmpty)
          Text(
            experienceMeta(item),
            style: const TextStyle(color: Color(0xFF5E5752), fontSize: 7.5),
          ),
        ...stringList(item['bulletPoints']).map(
          (bullet) => Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              '• $bullet',
              style: const TextStyle(
                color: Color(0xFF403B38),
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
            color: Color(0xFF27211E),
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (educationMeta(item).isNotEmpty)
          Text(
            educationMeta(item),
            style: const TextStyle(color: Color(0xFF5E5752), fontSize: 7.5),
          ),
        ...stringList(item['highlights']).map(
          (highlight) => Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              '• $highlight',
              style: const TextStyle(color: Color(0xFF403B38), fontSize: 7.5),
            ),
          ),
        ),
      ];

  List<Widget> projectWidgets(Map<String, dynamic> item) => [
        Text(
          (item['title'] ?? '').toString(),
          style: const TextStyle(
            color: Color(0xFF27211E),
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (_notEmpty(item['description']))
          Text(
            item['description'].toString(),
            style: const TextStyle(color: Color(0xFF403B38), fontSize: 7.5),
          ),
        if (_notEmpty(item['url']))
          Text(
            item['url'].toString(),
            style: TextStyle(
              color: renderer.accent,
              fontSize: 7.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (stringList(item['technologies']).isNotEmpty)
          Text(
            label('Tech: ', 'Teknolojiler: ') +
                stringList(item['technologies']).join(', '),
            style: const TextStyle(
              color: Color(0xFF5E5752),
              fontSize: 7.5,
              fontStyle: FontStyle.italic,
            ),
          ),
      ];
}

bool _notEmpty(dynamic value) =>
    value != null && value.toString().trim().isNotEmpty;
