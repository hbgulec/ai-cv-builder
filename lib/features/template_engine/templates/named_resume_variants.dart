import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../domain/entities/template_config.dart';

enum NamedResumeVariant {
  auckland,
  edinburgh,
  princeton,
  berkeley,
  harvard,
  stanford,
  cambridge,
  oxford,
}

enum _VariantLayout {
  topBand,
  centered,
  paper,
  leftRail,
  formal,
  rightRail,
  block,
  monograph
}

/// Catalogue renderer with distinct document architecture for every named CV.
class NamedResumeVariantTemplate extends BaseResumeTemplate {
  NamedResumeVariantTemplate(this.variant);

  final NamedResumeVariant variant;

  _VariantLayout get _layout => switch (variant) {
        NamedResumeVariant.auckland => _VariantLayout.topBand,
        NamedResumeVariant.edinburgh => _VariantLayout.centered,
        NamedResumeVariant.princeton => _VariantLayout.paper,
        NamedResumeVariant.berkeley => _VariantLayout.leftRail,
        NamedResumeVariant.harvard => _VariantLayout.formal,
        NamedResumeVariant.stanford => _VariantLayout.rightRail,
        NamedResumeVariant.cambridge => _VariantLayout.block,
        NamedResumeVariant.oxford => _VariantLayout.monograph,
      };

  Color get _baseAccent => switch (variant) {
        NamedResumeVariant.auckland => const Color(0xFF2563EB),
        NamedResumeVariant.edinburgh => const Color(0xFF0F3B5C),
        NamedResumeVariant.princeton => const Color(0xFF5B4636),
        NamedResumeVariant.berkeley => const Color(0xFF0F766E),
        NamedResumeVariant.harvard => const Color(0xFF6B1D32),
        NamedResumeVariant.stanford => const Color(0xFF1F2937),
        NamedResumeVariant.cambridge => const Color(0xFF173B6C),
        NamedResumeVariant.oxford => const Color(0xFF7C5A34),
      };

  Color _previewAccent = const Color(0xFF2563EB);
  Color get _accent => _previewAccent;
  double get _sectionBottomSpacing => switch (variant) {
        NamedResumeVariant.auckland => 13,
        NamedResumeVariant.edinburgh => 10,
        NamedResumeVariant.princeton => 10.5,
        NamedResumeVariant.harvard => 8.5,
        NamedResumeVariant.cambridge => 7,
        NamedResumeVariant.oxford => 6,
        _ => 14,
      };
  double get _detailBottomSpacing => switch (variant) {
        NamedResumeVariant.auckland => 7,
        NamedResumeVariant.edinburgh => 7,
        NamedResumeVariant.princeton => 7,
        NamedResumeVariant.harvard => 6,
        NamedResumeVariant.cambridge => 1.5,
        NamedResumeVariant.oxford => 2,
        _ => 8,
      };

  @override
  TemplateConfig get config => throw UnimplementedError(
        'Use a named template wrapper to access this renderer configuration.',
      );

  @override
  Widget buildPreview(Map<String, dynamic> resumeData) {
    _previewAccent = templateColor(resumeData, fallback: _baseAccent);
    final content = _ResumeContent(this, resumeData);
    return switch (_layout) {
      _VariantLayout.topBand => _topBandPreview(content),
      _VariantLayout.centered => _centeredPreview(content),
      _VariantLayout.paper => _paperPreview(content),
      _VariantLayout.leftRail => _railPreview(content, isRight: false),
      _VariantLayout.formal => _formalPreview(content),
      _VariantLayout.rightRail => _railPreview(content, isRight: true),
      _VariantLayout.block => _blockPreview(content),
      _VariantLayout.monograph => _monographPreview(content),
    };
  }

  Widget _topBandPreview(_ResumeContent content) => Container(
        color: Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (content.firstPage) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 16),
              color: _accent,
              child: _identity(content, Colors.white, const Color(0xFFDBEAFE)),
            ),
            Container(height: 7, color: _accent.withValues(alpha: .34)),
          ],
          Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              content.firstPage ? 24 : 30,
              24,
              24,
            ),
            child: _sections(content, _SectionTreatment.rule),
          ),
        ]),
      );

  Widget _centeredPreview(_ResumeContent content) => Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(30, 24, 30, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (content.firstPage) ...[
              _identity(content, _accent, const Color(0xFF64748B),
                  centered: true),
              const SizedBox(height: 13),
              Divider(color: _accent, thickness: 1.2),
              const SizedBox(height: 8),
            ],
            _sections(content, _SectionTreatment.editorial),
          ],
        ),
      );

  Widget _paperPreview(_ResumeContent content) => Container(
        color: const Color(0xFFFFFCF7),
        padding: const EdgeInsets.fromLTRB(28, 26, 28, 30),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (content.firstPage) ...[
            Container(width: 42, height: 4, color: _accent),
            const SizedBox(height: 16),
            _identity(content, _accent, const Color(0xFF806D5A), serif: true),
            const SizedBox(height: 14),
          ],
          _sections(content, _SectionTreatment.monograph),
        ]),
      );

  Widget _railPreview(_ResumeContent content, {required bool isRight}) {
    final rail = Container(
      width: isRight ? 78 : 88,
      padding: const EdgeInsets.all(12),
      color: _accent,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (content.firstPage) ...[
          if (content.photoBytes != null) ...[
            ClipOval(
              child: Image.memory(
                content.photoBytes!,
                width: 42,
                height: 42,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 14),
          ],
          Text(content.label('CONTACT', 'İLETİŞİM'),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1)),
          const SizedBox(height: 5),
          Text(content.contact,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: .88),
                  fontSize: 7,
                  height: 1.45)),
        ],
        if (content.sidebarSkills.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(content.label('SKILLS', 'YETENEKLER'),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1)),
          const SizedBox(height: 5),
          ...content.sidebarSkills.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text((item['name'] ?? '').toString(),
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: .88),
                        fontSize: 7)),
              )),
        ],
        if (content.sidebarLanguages.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(content.label('LANGUAGES', 'DİLLER'),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1)),
          const SizedBox(height: 5),
          ...content.sidebarLanguages.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  [item['language'], item['proficiency']]
                      .where(_notEmpty)
                      .join(' · '),
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: .88), fontSize: 7),
                ),
              )),
        ],
      ]),
    );
    final body = Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 26),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (content.firstPage) ...[
            _identity(content, _accent, const Color(0xFF64748B),
                showContact: false),
            const SizedBox(height: 16),
          ],
          _sections(content,
              isRight ? _SectionTreatment.rule : _SectionTreatment.card),
        ]),
      ),
    );
    return SizedBox(
      height: 538,
      child: Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(
              color: isRight ? const Color(0xFFF8FAFC) : Colors.white,
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: isRight ? null : 0,
            right: isRight ? 0 : null,
            width: isRight ? 78 : 88,
            child: ColoredBox(color: _accent),
          ),
          Positioned.fill(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: isRight ? [body, rail] : [rail, body],
            ),
          ),
        ],
      ),
    );
  }

  Widget _formalPreview(_ResumeContent content) => Container(
        color: Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (content.firstPage) ...[
            Container(height: 9, color: _accent),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 20, 28, 16),
              child: _identity(content, const Color(0xFF2A1520), _accent,
                  uppercase: true),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 28),
              height: 1.4,
              color: _accent,
            ),
          ],
          Padding(
            padding: EdgeInsets.fromLTRB(
              28,
              content.firstPage ? 18 : 28,
              28,
              30,
            ),
            child: _sections(content, _SectionTreatment.numbered),
          ),
        ]),
      );

  Widget _blockPreview(_ResumeContent content) => Container(
        color: Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (content.firstPage)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 18),
              color: _accent,
              child: Row(children: [
                Expanded(
                  child: _identity(
                    content,
                    Colors.white,
                    Colors.white.withValues(alpha: .74),
                  ),
                ),
                if (content.photoBytes != null) ...[
                  const SizedBox(width: 16),
                  ClipOval(
                    child: Image.memory(
                      content.photoBytes!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ]),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              24,
              content.firstPage ? 18 : 28,
              24,
              26,
            ),
            child: _sections(content, _SectionTreatment.block),
          ),
        ]),
      );

  Widget _monographPreview(_ResumeContent content) => Container(
        color: const Color(0xFFFFFDF9),
        padding: const EdgeInsets.fromLTRB(30, 24, 30, 28),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (content.firstPage) ...[
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Expanded(
                child: Text(content.name,
                    style: const TextStyle(
                        color: Color(0xFF332318),
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'serif')),
              ),
              Text('OXFORD',
                  style: TextStyle(
                      color: _accent,
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2)),
            ]),
            const SizedBox(height: 5),
            Text(content.role, style: TextStyle(color: _accent, fontSize: 10)),
            const SizedBox(height: 7),
            Text(content.contact,
                style: const TextStyle(color: Color(0xFF8B7B6C), fontSize: 8)),
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFD8C6B3)),
            const SizedBox(height: 10),
          ],
          _sections(content, _SectionTreatment.monograph),
        ]),
      );

  Widget _identity(
    _ResumeContent content,
    Color titleColor,
    Color detailColor, {
    bool centered = false,
    bool serif = false,
    bool uppercase = false,
    bool showContact = true,
  }) =>
      Column(
        crossAxisAlignment:
            centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Text(uppercase ? content.name.toUpperCase() : content.name,
              textAlign: centered ? TextAlign.center : TextAlign.left,
              style: TextStyle(
                  color: titleColor,
                  fontSize: serif ? 25 : 22,
                  fontWeight: uppercase ? FontWeight.w800 : FontWeight.w700,
                  fontFamily: serif ? 'serif' : null,
                  letterSpacing: uppercase ? 1.1 : .3)),
          if (content.role.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(content.role,
                textAlign: centered ? TextAlign.center : TextAlign.left,
                style: TextStyle(color: detailColor, fontSize: 10)),
          ],
          if (showContact && content.contact.isNotEmpty) ...[
            const SizedBox(height: 7),
            Text(content.contact,
                textAlign: centered ? TextAlign.center : TextAlign.left,
                style: TextStyle(color: detailColor, fontSize: 8)),
          ],
        ],
      );

  Widget _sections(_ResumeContent content, _SectionTreatment treatment) {
    final sections = <Widget>[];
    void add(String title, Widget child) => sections.add(
          _section(title, child, treatment, sections.length + 1),
        );
    if (content.summary.isNotEmpty) {
      add(
          content.label('Summary', 'Özet'),
          Text(content.summary,
              style: const TextStyle(
                  fontSize: 9, color: Color(0xFF475569), height: 1.45)));
    }
    if (content.experiences.isNotEmpty) {
      add(
          content.label('Experience', 'Deneyim'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content.experiences
                .map((item) => _previewExperience(item, content))
                .toList(),
          ));
    }
    if (content.educations.isNotEmpty) {
      add(
          content.label('Education', 'Eğitim'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content.educations
                .map((item) => _previewEducation(item, content))
                .toList(),
          ));
    }
    if (content.projects.isNotEmpty) {
      add(
          content.label('Projects', 'Projeler'),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content.projects
                .map((item) => _previewProject(item, content))
                .toList(),
          ));
    }
    if (content.skills.isNotEmpty &&
        _layout != _VariantLayout.leftRail &&
        _layout != _VariantLayout.rightRail) {
      add(
          content.label('Skills', 'Yetenekler'),
          Wrap(
            spacing: 5,
            runSpacing: 4,
            children: content.skills
                .map((item) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: _accent.withValues(alpha: .08),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text((item['name'] ?? '').toString(),
                          style: TextStyle(
                              fontSize: 8,
                              color: _accent,
                              fontWeight: FontWeight.w600)),
                    ))
                .toList(),
          ));
    }
    if (content.languages.isNotEmpty &&
        _layout != _VariantLayout.leftRail &&
        _layout != _VariantLayout.rightRail) {
      add(
          content.label('Languages', 'Diller'),
          Wrap(
            spacing: 5,
            runSpacing: 4,
            children: content.languages
                .map((item) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: _accent.withValues(alpha: .08),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        [item['language'], item['proficiency']]
                            .where(_notEmpty)
                            .join(' · '),
                        style: TextStyle(
                            fontSize: 8,
                            color: _accent,
                            fontWeight: FontWeight.w600),
                      ),
                    ))
                .toList(),
          ));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: sections);
  }

  Widget _section(
    String title,
    Widget child,
    _SectionTreatment treatment,
    int index,
  ) {
    final heading = switch (treatment) {
      _SectionTreatment.rule => Row(children: [
          Container(width: 4, height: 13, color: _accent),
          const SizedBox(width: 6),
          _heading(title),
        ]),
      _SectionTreatment.editorial => _heading(title, letterSpacing: 1.3),
      _SectionTreatment.monograph => Row(children: [
          Expanded(child: _heading(title, serif: true)),
          Container(width: 44, height: 1, color: _accent.withValues(alpha: .4)),
        ]),
      _SectionTreatment.card => Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          color: _accent,
          child: _heading(title, white: true, size: 8)),
      _SectionTreatment.numbered => Row(children: [
          Container(
              width: 18,
              height: 18,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: _accent, shape: BoxShape.circle),
              child: Text('$index',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w700))),
          const SizedBox(width: 7),
          _heading(title),
        ]),
      _SectionTreatment.block => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
              border: Border(left: BorderSide(color: _accent, width: 3))),
          child: _heading(title, size: 9)),
    };
    return Padding(
      padding: EdgeInsets.only(bottom: _sectionBottomSpacing),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        heading,
        const SizedBox(height: 6),
        child,
      ]),
    );
  }

  Widget _heading(String title,
          {bool white = false,
          bool serif = false,
          double size = 10,
          double letterSpacing = .8}) =>
      Text(title.toUpperCase(),
          style: TextStyle(
              fontSize: size,
              color: white ? Colors.white : _accent,
              fontWeight: FontWeight.w800,
              fontFamily: serif ? 'serif' : null,
              letterSpacing: letterSpacing));

  Widget _previewExperience(
          Map<String, dynamic> item, _ResumeContent content) =>
      _previewDetail(
        item['jobTitle'],
        [item['company'], item['location'], content.dateFor(item)]
            .where(_notEmpty)
            .join('  |  '),
        extraLines: content
            .stringList(item, 'bulletPoints')
            .map((value) => '• $value')
            .toList(),
      );

  Widget _previewEducation(Map<String, dynamic> item, _ResumeContent content) =>
      _previewDetail(
        item['degree'],
        [
          item['institution'],
          item['location'],
          content.dateFor(item),
          _notEmpty(item['gpa']) ? 'GPA: ${item['gpa']}' : null,
        ].where(_notEmpty).join('  |  '),
        extraLines: content.stringList(item, 'highlights'),
      );

  Widget _previewProject(Map<String, dynamic> item, _ResumeContent content) =>
      _previewDetail(
        item['title'],
        (item['description'] ?? '').toString(),
        extraLines: [
          if (_notEmpty(item['url']))
            '${content.label('Link', 'Bağlantı')}: ${item['url']}',
          if (content.stringList(item, 'technologies').isNotEmpty)
            '${content.label('Technologies', 'Teknolojiler')}: ${content.stringList(item, 'technologies').join(', ')}',
        ],
      );

  Widget _previewDetail(
    dynamic title,
    String detail, {
    List<String> extraLines = const [],
  }) =>
      Padding(
        padding: EdgeInsets.only(bottom: _detailBottomSpacing),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text((title ?? '').toString(),
              style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F2937))),
          if (detail.isNotEmpty)
            Text(detail,
                style: const TextStyle(fontSize: 8, color: Color(0xFF64748B))),
          ...extraLines.where((line) => line.trim().isNotEmpty).map(
                (line) => Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(line,
                      style: const TextStyle(
                          fontSize: 8, color: Color(0xFF475569), height: 1.3)),
                ),
              ),
        ]),
      );

  @override
  pw.Page buildPdfPage(
    Map<String, dynamic> resumeData,
    pw.Font regularFont,
    pw.Font boldFont,
  ) {
    final content = _ResumeContent(this, resumeData);
    final accent = templatePdfColor(resumeData, fallback: _baseAccent);
    return switch (_layout) {
      _VariantLayout.topBand =>
        _pdfTopBand(content, regularFont, boldFont, accent),
      _VariantLayout.centered =>
        _pdfCentered(content, regularFont, boldFont, accent),
      _VariantLayout.paper => _pdfPaper(content, regularFont, boldFont, accent),
      _VariantLayout.leftRail =>
        _pdfRail(content, regularFont, boldFont, accent, false),
      _VariantLayout.formal =>
        _pdfFormal(content, regularFont, boldFont, accent),
      _VariantLayout.rightRail =>
        _pdfRail(content, regularFont, boldFont, accent, true),
      _VariantLayout.block => _pdfBlock(content, regularFont, boldFont, accent),
      _VariantLayout.monograph =>
        _pdfMonograph(content, regularFont, boldFont, accent),
    };
  }

  pw.Page _pdfTopBand(_ResumeContent c, pw.Font r, pw.Font b, PdfColor a) =>
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (_) => pw.Column(children: [
                if (c.firstPage) ...[
                  pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.fromLTRB(42, 30, 42, 24),
                      color: a,
                      child: _pdfIdentity(
                          c, r, b, PdfColors.white, PdfColors.grey200)),
                  pw.Container(height: 9, color: a),
                ],
                pw.Padding(
                    padding: const pw.EdgeInsets.all(42),
                    child: _pdfSections(c, r, b, a, _PdfTreatment.rule)),
              ]));

  pw.Page _pdfCentered(_ResumeContent c, pw.Font r, pw.Font b, PdfColor a) =>
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(46),
          build: (_) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                  children: [
                    if (c.firstPage) ...[
                      _pdfIdentity(c, r, b, a, PdfColors.grey600,
                          centered: true),
                      pw.SizedBox(height: 14),
                      pw.Divider(color: a, thickness: 1.2),
                      pw.SizedBox(height: 10),
                    ],
                    _pdfSections(c, r, b, a, _PdfTreatment.editorial),
                  ]));

  pw.Page _pdfPaper(_ResumeContent c, pw.Font r, pw.Font b, PdfColor a) =>
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (_) => pw.Container(
              color: PdfColor.fromHex('#FFFCF7'),
              padding: const pw.EdgeInsets.fromLTRB(48, 48, 48, 42),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (c.firstPage) ...[
                      pw.Container(width: 46, height: 5, color: a),
                      pw.SizedBox(height: 20),
                      _pdfIdentity(c, r, b, a, PdfColor.fromHex('#806D5A'),
                          serif: true),
                      pw.SizedBox(height: 18),
                    ],
                    _pdfSections(c, r, b, a, _PdfTreatment.monograph),
                  ])));

  pw.Page _pdfRail(
      _ResumeContent c, pw.Font r, pw.Font b, PdfColor a, bool right) {
    final rail = pw.Container(
        width: right ? 115 : 135,
        color: a,
        padding: const pw.EdgeInsets.all(18),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (c.firstPage) ...[
                if (c.photoBytes != null) ...[
                  pw.ClipOval(
                    child: pw.Image(
                      pw.MemoryImage(c.photoBytes!),
                      width: 58,
                      height: 58,
                      fit: pw.BoxFit.cover,
                    ),
                  ),
                  pw.SizedBox(height: 15),
                ],
                pw.Text(c.label('CONTACT', 'İLETİŞİM'),
                    style: pw.TextStyle(
                        font: b,
                        fontSize: 7,
                        color: PdfColors.white,
                        letterSpacing: 1.1)),
                pw.SizedBox(height: 6),
                pw.Text(c.contact,
                    style: pw.TextStyle(
                        font: r,
                        fontSize: 7,
                        lineSpacing: 2,
                        color: PdfColors.white)),
              ],
              if (c.sidebarSkills.isNotEmpty) ...[
                pw.SizedBox(height: 16),
                pw.Text(c.label('SKILLS', 'YETENEKLER'),
                    style: pw.TextStyle(
                        font: b,
                        fontSize: 7,
                        color: PdfColors.white,
                        letterSpacing: 1.1)),
                pw.SizedBox(height: 6),
                ...c.sidebarSkills.map((item) => pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 4),
                      child: pw.Text((item['name'] ?? '').toString(),
                          style: pw.TextStyle(
                              font: r, fontSize: 7, color: PdfColors.white)),
                    )),
              ],
              if (c.sidebarLanguages.isNotEmpty) ...[
                pw.SizedBox(height: 14),
                pw.Text(c.label('LANGUAGES', 'DİLLER'),
                    style: pw.TextStyle(
                        font: b,
                        fontSize: 7,
                        color: PdfColors.white,
                        letterSpacing: 1.1)),
                pw.SizedBox(height: 6),
                ...c.sidebarLanguages.map((item) => pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 4),
                      child: pw.Text(
                          [item['language'], item['proficiency']]
                              .where(_notEmpty)
                              .join(' - '),
                          style: pw.TextStyle(
                              font: r, fontSize: 7, color: PdfColors.white)),
                    )),
              ],
            ]));
    final body = pw.Expanded(
        child: pw.Padding(
            padding: const pw.EdgeInsets.fromLTRB(34, 34, 28, 34),
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (c.firstPage) ...[
                    _pdfIdentity(c, r, b, a, PdfColors.grey600,
                        showContact: false),
                    pw.SizedBox(height: 18),
                  ],
                  _pdfSections(c, r, b, a,
                      right ? _PdfTreatment.rule : _PdfTreatment.card),
                ])));
    return pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (_) => pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: right ? [body, rail] : [rail, body]));
  }

  pw.Page _pdfFormal(_ResumeContent c, pw.Font r, pw.Font b, PdfColor a) =>
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (_) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (c.firstPage) ...[
                      pw.Container(height: 11, color: a),
                      pw.Padding(
                          padding: const pw.EdgeInsets.fromLTRB(44, 30, 44, 18),
                          child: _pdfIdentity(
                              c, r, b, PdfColor.fromHex('#2A1520'), a,
                              uppercase: true)),
                      pw.Container(
                          margin: const pw.EdgeInsets.symmetric(horizontal: 44),
                          height: 1.5,
                          color: a),
                    ],
                    pw.Padding(
                        padding: const pw.EdgeInsets.fromLTRB(44, 25, 44, 40),
                        child:
                            _pdfSections(c, r, b, a, _PdfTreatment.numbered)),
                  ]));

  pw.Page _pdfBlock(_ResumeContent c, pw.Font r, pw.Font b, PdfColor a) =>
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (_) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (c.firstPage)
                      pw.Container(
                          width: double.infinity,
                          padding: const pw.EdgeInsets.fromLTRB(44, 32, 44, 28),
                          color: a,
                          child: pw.Row(children: [
                            pw.Expanded(
                                child: _pdfIdentity(c, r, b, PdfColors.white,
                                    PdfColors.grey200)),
                            if (c.photoBytes != null) ...[
                              pw.SizedBox(width: 20),
                              pw.ClipOval(
                                  child: pw.Image(pw.MemoryImage(c.photoBytes!),
                                      width: 68,
                                      height: 68,
                                      fit: pw.BoxFit.cover)),
                            ],
                          ])),
                    pw.Padding(
                        padding: const pw.EdgeInsets.fromLTRB(44, 28, 44, 40),
                        child: _pdfSections(c, r, b, a, _PdfTreatment.block)),
                  ]));

  pw.Page _pdfMonograph(_ResumeContent c, pw.Font r, pw.Font b, PdfColor a) =>
      pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (_) => pw.Container(
              color: PdfColor.fromHex('#FFFDF9'),
              padding: const pw.EdgeInsets.fromLTRB(48, 42, 48, 40),
              child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (c.firstPage) ...[
                      pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Expanded(
                                child: pw.Text(c.name,
                                    style: pw.TextStyle(
                                        font: b,
                                        fontSize: 25,
                                        color: PdfColor.fromHex('#332318')))),
                            pw.Text('OXFORD',
                                style: pw.TextStyle(
                                    font: b,
                                    fontSize: 8,
                                    color: a,
                                    letterSpacing: 2)),
                          ]),
                      pw.SizedBox(height: 5),
                      pw.Text(c.role,
                          style: pw.TextStyle(font: r, fontSize: 10, color: a)),
                      pw.SizedBox(height: 7),
                      pw.Text(c.contact,
                          style: pw.TextStyle(
                              font: r,
                              fontSize: 8,
                              color: PdfColor.fromHex('#8B7B6C'))),
                      pw.SizedBox(height: 14),
                      pw.Divider(color: PdfColor.fromHex('#D8C6B3')),
                      pw.SizedBox(height: 10),
                    ],
                    _pdfSections(c, r, b, a, _PdfTreatment.monograph),
                  ])));

  pw.Widget _pdfIdentity(
    _ResumeContent c,
    pw.Font r,
    pw.Font b,
    PdfColor title,
    PdfColor detail, {
    bool centered = false,
    bool serif = false,
    bool uppercase = false,
    bool showContact = true,
  }) =>
      pw.Column(
          crossAxisAlignment: centered
              ? pw.CrossAxisAlignment.center
              : pw.CrossAxisAlignment.start,
          children: [
            pw.Text(uppercase ? c.name.toUpperCase() : c.name,
                textAlign: centered ? pw.TextAlign.center : pw.TextAlign.left,
                style: pw.TextStyle(
                    font: b,
                    fontSize: serif ? 25 : 23,
                    color: title,
                    letterSpacing: uppercase ? 1.1 : .3)),
            if (c.role.isNotEmpty) ...[
              pw.SizedBox(height: 3),
              pw.Text(c.role,
                  textAlign: centered ? pw.TextAlign.center : pw.TextAlign.left,
                  style: pw.TextStyle(font: r, fontSize: 10, color: detail)),
            ],
            if (showContact && c.contact.isNotEmpty) ...[
              pw.SizedBox(height: 8),
              pw.Text(c.contact,
                  textAlign: centered ? pw.TextAlign.center : pw.TextAlign.left,
                  style: pw.TextStyle(font: r, fontSize: 8, color: detail)),
            ],
          ]);

  pw.Widget _pdfSections(_ResumeContent c, pw.Font r, pw.Font b, PdfColor a,
      _PdfTreatment treatment) {
    final sections = <pw.Widget>[];
    void add(String title, List<pw.Widget> body) => sections
        .add(_pdfSection(title, body, r, b, a, treatment, sections.length + 1));
    if (c.summary.isNotEmpty) {
      add(c.label('Summary', 'Özet'), [
        pw.Text(c.summary,
            style: pw.TextStyle(font: r, fontSize: 9, lineSpacing: 2.5))
      ]);
    }
    if (c.experiences.isNotEmpty) {
      add(
          c.label('Experience', 'Deneyim'),
          c.experiences
              .map((item) => _pdfDetail(
                    item['jobTitle'],
                    [item['company'], item['location'], c.dateFor(item)]
                        .where(_notEmpty)
                        .join('  |  '),
                    r,
                    b,
                    extraLines: c
                        .stringList(item, 'bulletPoints')
                        .map((value) => '- $value')
                        .toList(),
                  ))
              .toList());
    }
    if (c.educations.isNotEmpty) {
      add(
          c.label('Education', 'Eğitim'),
          c.educations
              .map((item) => _pdfDetail(
                    item['degree'],
                    [
                      item['institution'],
                      item['location'],
                      c.dateFor(item),
                      _notEmpty(item['gpa']) ? 'GPA: ${item['gpa']}' : null,
                    ].where(_notEmpty).join('  |  '),
                    r,
                    b,
                    extraLines: c.stringList(item, 'highlights'),
                  ))
              .toList());
    }
    if (c.projects.isNotEmpty) {
      add(
          c.label('Projects', 'Projeler'),
          c.projects
              .map((item) => _pdfDetail(
                    item['title'],
                    (item['description'] ?? '').toString(),
                    r,
                    b,
                    extraLines: [
                      if (_notEmpty(item['url']))
                        '${c.label('Link', 'Bağlantı')}: ${item['url']}',
                      if (c.stringList(item, 'technologies').isNotEmpty)
                        '${c.label('Technologies', 'Teknolojiler')}: ${c.stringList(item, 'technologies').join(', ')}',
                    ],
                  ))
              .toList());
    }
    if (c.skills.isNotEmpty) {
      add(c.label('Skills', 'Yetenekler'), [
        pw.Text(
            c.skills
                .map((item) => (item['name'] ?? '').toString())
                .where((value) => value.trim().isNotEmpty)
                .join('  |  '),
            style: pw.TextStyle(font: r, fontSize: 8, color: a))
      ]);
    }
    if (c.languages.isNotEmpty) {
      add(c.label('Languages', 'Diller'), [
        pw.Text(
            c.languages
                .map((item) => [item['language'], item['proficiency']]
                    .where(_notEmpty)
                    .join(' - '))
                .where((value) => value.isNotEmpty)
                .join('  |  '),
            style: pw.TextStyle(font: r, fontSize: 8, color: a))
      ]);
    }
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start, children: sections);
  }

  pw.Widget _pdfSection(String title, List<pw.Widget> body, pw.Font r,
      pw.Font b, PdfColor a, _PdfTreatment treatment, int index) {
    final heading = switch (treatment) {
      _PdfTreatment.rule => pw.Row(children: [
          pw.Container(width: 4, height: 13, color: a),
          pw.SizedBox(width: 6),
          _pdfHeading(title, b, a)
        ]),
      _PdfTreatment.editorial => _pdfHeading(title, b, a, spacing: 1.3),
      _PdfTreatment.monograph => pw.Row(children: [
          pw.Expanded(child: _pdfHeading(title, b, a, size: 13)),
          pw.Container(width: 44, height: 1, color: PdfColors.grey400)
        ]),
      _PdfTreatment.card => pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 4),
          color: a,
          child: _pdfHeading(title, b, PdfColors.white, size: 8)),
      _PdfTreatment.numbered => pw.Row(children: [
          pw.Container(
              width: 18,
              height: 18,
              alignment: pw.Alignment.center,
              decoration: pw.BoxDecoration(color: a, shape: pw.BoxShape.circle),
              child: pw.Text('$index',
                  style: pw.TextStyle(
                      font: b, fontSize: 8, color: PdfColors.white))),
          pw.SizedBox(width: 7),
          _pdfHeading(title, b, a)
        ]),
      _PdfTreatment.block => pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: pw.BoxDecoration(
              border: pw.Border(left: pw.BorderSide(color: a, width: 3))),
          child: _pdfHeading(title, b, a, size: 9)),
    };
    return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 14),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [heading, pw.SizedBox(height: 6), ...body]));
  }

  pw.Widget _pdfHeading(String title, pw.Font bold, PdfColor color,
          {double size = 10, double spacing = .8}) =>
      pw.Text(title.toUpperCase(),
          style: pw.TextStyle(
              font: bold,
              fontSize: size,
              color: color,
              letterSpacing: spacing));

  pw.Widget _pdfDetail(
    dynamic title,
    String detail,
    pw.Font r,
    pw.Font b, {
    List<String> extraLines = const [],
  }) =>
      pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 8),
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text((title ?? '').toString(),
                    style: pw.TextStyle(
                        font: b, fontSize: 9, color: PdfColors.grey900)),
                if (detail.isNotEmpty)
                  pw.Text(detail,
                      style: pw.TextStyle(
                          font: r, fontSize: 8, color: PdfColors.grey600)),
                ...extraLines.where((line) => line.trim().isNotEmpty).map(
                      (line) => pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 2),
                        child: pw.Text(line,
                            style: pw.TextStyle(
                                font: r,
                                fontSize: 8,
                                color: PdfColors.grey700)),
                      ),
                    ),
              ]));
}

enum _SectionTreatment { rule, editorial, monograph, card, numbered, block }

enum _PdfTreatment { rule, editorial, monograph, card, numbered, block }

class _ResumeContent {
  _ResumeContent(this.renderer, Map<String, dynamic> data)
      : language = renderer.getLanguageCode(data),
        firstPage = renderer.isFirstPage(data),
        photoBytes = renderer.resolvePhotoBytes(data),
        header = renderer.safeToMap(data['header']),
        summary = (data['summary'] ?? '').toString(),
        experiences = renderer.safeToListOfMap(data['workExperiences']),
        educations = renderer.safeToListOfMap(data['educationList']),
        projects = renderer.safeToListOfMap(data['projects']),
        skills = renderer.safeToListOfMap(data['skills']),
        languages = renderer.safeToListOfMap(data['languages']),
        sidebarSkills = renderer.safeToListOfMap(data['_sidebarSkills']),
        sidebarLanguages = renderer.safeToListOfMap(data['_sidebarLanguages']);

  final NamedResumeVariantTemplate renderer;
  final String language;
  final bool firstPage;
  final Uint8List? photoBytes;
  final Map<String, dynamic> header;
  final String summary;
  final List<Map<String, dynamic>> experiences;
  final List<Map<String, dynamic>> educations;
  final List<Map<String, dynamic>> projects;
  final List<Map<String, dynamic>> skills;
  final List<Map<String, dynamic>> languages;
  final List<Map<String, dynamic>> sidebarSkills;
  final List<Map<String, dynamic>> sidebarLanguages;

  String get name => (header['fullName'] ?? 'Your Name').toString();
  String get role => (header['professionalTitle'] ?? '').toString();
  String get contact => [
        header['email'],
        header['phone'],
        header['location'],
        header['linkedinUrl'],
        header['githubUrl'],
        header['portfolioUrl'],
      ].where(_notEmpty).join('  |  ');
  String get initials => name
      .trim()
      .split(RegExp(r'\s+'))
      .where((item) => item.isNotEmpty)
      .take(2)
      .map((item) => item[0].toUpperCase())
      .join();
  String label(String en, String tr) => language == 'tr' ? tr : en;
  String dateFor(Map<String, dynamic> item) => renderer.formatDateRange(
      item['startDate'], item['endDate'], item['isCurrent'],
      languageCode: language);

  List<String> stringList(Map<String, dynamic> item, String key) =>
      item[key] is List
          ? (item[key] as List)
              .map((value) => value.toString().trim())
              .where((value) => value.isNotEmpty)
              .toList()
          : const [];
}

bool _notEmpty(dynamic value) =>
    value != null && value.toString().trim().isNotEmpty;
