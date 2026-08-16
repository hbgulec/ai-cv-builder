import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../domain/entities/template_config.dart';

/// Executive Pro — Premium template for C-level and senior management.
/// Dark header with timeline-style experience and sophisticated accent.
class ExecutiveProTemplate extends BaseResumeTemplate {
  @override
  TemplateConfig get config => const TemplateConfig(
        id: 'executive_pro',
        name: 'Executive Pro',
        description: 'Premium dark-header layout with timeline experience for senior leadership',
        isPremium: true,
        category: 'executive',
        primaryColor: Color(0xFF111827),
        accentColor: Color(0xFFF59E0B),
        thumbnailAsset: 'assets/templates/executive_pro_thumb.png',
      );

  @override
  Widget buildPreview(Map<String, dynamic> resumeData) {
    final langCode = getLanguageCode(resumeData);
    final isTr = langCode == 'tr';
    final header = safeToMap(resumeData['header']);
    final summary = resumeData['summary'] as String? ?? '';
    final experiences = safeToListOfMap(resumeData['workExperiences']);
    final educations = safeToListOfMap(resumeData['educationList']);
    final projects = safeToListOfMap(resumeData['projects']);
    final skills = safeToListOfMap(resumeData['skills']);
    final photoBytes = resolvePhotoBytes(resumeData);
    final hasPhoto = photoBytes != null && photoBytes.isNotEmpty;

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dark header band
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
            decoration: const BoxDecoration(
              color: Color(0xFF111827),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amber monogram circle
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFF59E0B), width: 2),
                  ),
                  child: ClipOval(
                    child: hasPhoto
                        ? Image.memory(
                            photoBytes!,
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          )
                        : Center(
                            child: Text(
                              (header['fullName'] ?? 'E').toString().isNotEmpty
                                  ? (header['fullName'] ?? 'N').toString().substring(0, 1).toUpperCase()
                                  : 'N',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFF59E0B)),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (header['fullName'] ?? 'Your Name').toString(),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        (header['professionalTitle'] ?? '').toString(),
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFFF59E0B)),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        [header['email'], header['phone'], header['location']]
                            .where((e) => e != null && e.toString().isNotEmpty)
                            .join('  |  '),
                        style: TextStyle(
                            fontSize: 8, color: Colors.white.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (summary.isNotEmpty) ...[
                  _proSectionTitle(isTr ? 'Yönetici Profili' : 'Executive Profile'),
                  const SizedBox(height: 4),
                  Text(summary,
                      style: const TextStyle(
                          fontSize: 10, color: Color(0xFF374151), height: 1.5)),
                  const SizedBox(height: 14),
                ],

                if (experiences.isNotEmpty) ...[
                  _proSectionTitle(isTr ? 'Kariyer Zaman Çizelgesi' : 'Career Timeline'),
                  const SizedBox(height: 6),
                  ...experiences.map((exp) {
                    final e = exp;
                    final dateRange = formatDateRange(e['startDate'], e['endDate'], e['isCurrent'], languageCode: langCode);
                    final compLoc = [e['company'], e['location'], dateRange]
                        .where((s) => s != null && s.toString().isNotEmpty)
                        .join(' • ');
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Timeline dot + line
                          Column(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFF59E0B),
                                ),
                              ),
                              Container(
                                width: 1.5,
                                height: 35,
                                color: const Color(0xFFE5E7EB),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text((e['jobTitle'] ?? '').toString(),
                                    style: const TextStyle(
                                        fontSize: 11, fontWeight: FontWeight.w700)),
                                if (compLoc.isNotEmpty)
                                  Text(compLoc,
                                      style: const TextStyle(
                                          fontSize: 10, color: Color(0xFFF59E0B))),
                                if (e['bulletPoints'] != null)
                                  ...((e['bulletPoints'] as List).map((b) => Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text('→ $b',
                                            style: const TextStyle(
                                                fontSize: 9, color: Color(0xFF6B7280))),
                                      ))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],

                if (educations.isNotEmpty) ...[
                  _proSectionTitle(isTr ? 'Eğitim' : 'Education'),
                  const SizedBox(height: 6),
                  ...educations.map((edu) {
                    final e = edu;
                    final dateRange = formatDateRange(e['startDate'], e['endDate'], e['isCurrent'], languageCode: langCode);
                    final instLocGpa = [
                      e['institution'],
                      e['location'],
                      dateRange,
                      e['gpa'] != null && e['gpa'].toString().isNotEmpty ? 'GPA: ${e['gpa']}' : null
                    ].where((s) => s != null && s.toString().isNotEmpty).join(' • ');
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text((e['degree'] ?? '').toString(),
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
                          if (instLocGpa.isNotEmpty)
                            Text(instLocGpa,
                                style: const TextStyle(
                                    fontSize: 10, color: Color(0xFF6B7280))),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                ],

                if (projects.isNotEmpty) ...[
                  _proSectionTitle(isTr ? 'Projeler' : 'Projects'),
                  const SizedBox(height: 6),
                  ...projects.map((proj) {
                    final p = proj;
                    final title = (p['title'] ?? '').toString();
                    final url = (p['url'] ?? '').toString();
                    final desc = (p['description'] ?? '').toString();
                    final techs = p['technologies'] is List ? (p['technologies'] as List).join(', ') : '';
                    final techLabel = isTr ? 'Teknolojiler' : 'Tech';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(url.isNotEmpty ? '$title ($url)' : title,
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF111827))),
                          if (desc.isNotEmpty)
                            Text(desc, style: const TextStyle(fontSize: 10, color: Color(0xFF374151))),
                          if (techs.isNotEmpty)
                            Text('$techLabel: $techs', style: const TextStyle(fontSize: 9, color: Color(0xFFF59E0B), fontStyle: FontStyle.italic)),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 10),
                ],

                if (skills.isNotEmpty) ...[
                  _proSectionTitle(isTr ? 'Uzmanlık Alanları' : 'Key Expertise'),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: skills.map((s) {
                      final skill = s;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
                        ),
                        child: Text((skill['name'] ?? '').toString(),
                            style: const TextStyle(
                                fontSize: 9,
                                color: Color(0xFF92400E),
                                fontWeight: FontWeight.w500)),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _proSectionTitle(String title) {
    return Row(
      children: [
        Container(width: 3, height: 14, color: const Color(0xFFF59E0B)),
        const SizedBox(width: 8),
        Text(title.toUpperCase(),
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
                letterSpacing: 1.5)),
      ],
    );
  }

  @override
  pw.Page buildPdfPage(
    Map<String, dynamic> resumeData,
    pw.Font regularFont,
    pw.Font boldFont,
  ) {
    final langCode = getLanguageCode(resumeData);
    final isTr = langCode == 'tr';
    final header = safeToMap(resumeData['header']);
    final summary = resumeData['summary'] as String? ?? '';
    final experiences = safeToListOfMap(resumeData['workExperiences']);
    final educations = safeToListOfMap(resumeData['educationList']);
    final projects = safeToListOfMap(resumeData['projects']);
    final skills = safeToListOfMap(resumeData['skills']);
    final pdfPhotoBytes = resolvePhotoBytes(resumeData);

    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Dark header
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 28),
            color: PdfColor.fromHex('#111827'),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                if (pdfPhotoBytes != null) ...[
                  pw.ClipOval(
                    child: pw.Image(
                      pw.MemoryImage(pdfPhotoBytes),
                      width: 52,
                      height: 52,
                      fit: pw.BoxFit.cover,
                    ),
                  ),
                  pw.SizedBox(width: 16),
                ],
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text((header['fullName'] ?? '').toString(),
                          style: pw.TextStyle(
                              font: boldFont, fontSize: 22, color: PdfColors.white)),
                      pw.SizedBox(height: 2),
                      pw.Text((header['professionalTitle'] ?? '').toString(),
                          style: pw.TextStyle(
                              font: regularFont,
                              fontSize: 12,
                              color: PdfColor.fromHex('#F59E0B'))),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        [header['email'], header['phone'], header['location']]
                            .where((e) => e != null && e.toString().isNotEmpty)
                            .join('  |  '),
                        style: pw.TextStyle(
                            font: regularFont, fontSize: 9, color: PdfColors.grey400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body
          pw.Padding(
            padding: const pw.EdgeInsets.all(40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (summary.isNotEmpty) ...[
                  pw.Text(isTr ? 'YÖNETİCİ PROFİLİ' : 'EXECUTIVE PROFILE',
                      style: pw.TextStyle(font: boldFont, fontSize: 10, letterSpacing: 1.5)),
                  pw.SizedBox(height: 4),
                  pw.Text(summary,
                      style: pw.TextStyle(font: regularFont, fontSize: 9, lineSpacing: 3)),
                  pw.SizedBox(height: 14),
                ],

                if (experiences.isNotEmpty) ...[
                  pw.Text(isTr ? 'KARİYER ZAMAN ÇİZELGESİ' : 'CAREER TIMELINE',
                      style: pw.TextStyle(font: boldFont, fontSize: 10, letterSpacing: 1.5)),
                  pw.SizedBox(height: 6),
                  ...experiences.map((exp) {
                    final e = exp;
                    final dateRange = formatDateRange(e['startDate'], e['endDate'], e['isCurrent'], languageCode: langCode);
                    final compLoc = [e['company'], e['location'], dateRange]
                        .where((s) => s != null && s.toString().isNotEmpty)
                        .join(' • ');
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 8),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text((e['jobTitle'] ?? '').toString(),
                              style: pw.TextStyle(font: boldFont, fontSize: 10)),
                          if (compLoc.isNotEmpty)
                            pw.Text(compLoc,
                                style: pw.TextStyle(
                                    font: regularFont,
                                    fontSize: 9,
                                    color: PdfColor.fromHex('#F59E0B'))),
                          if (e['bulletPoints'] != null)
                            ...((e['bulletPoints'] as List).map((b) => pw.Padding(
                                  padding: const pw.EdgeInsets.only(top: 2),
                                  child: pw.Text('• $b',
                                      style: pw.TextStyle(font: regularFont, fontSize: 9)),
                                ))),
                        ],
                      ),
                    );
                  }),
                ],

                if (educations.isNotEmpty) ...[
                  pw.SizedBox(height: 8),
                  pw.Text(isTr ? 'EĞİTİM' : 'EDUCATION',
                      style: pw.TextStyle(font: boldFont, fontSize: 10, letterSpacing: 1.5)),
                  pw.SizedBox(height: 6),
                  ...educations.map((edu) {
                    final e = edu;
                    final dateRange = formatDateRange(e['startDate'], e['endDate'], e['isCurrent'], languageCode: langCode);
                    final instLocGpa = [
                      e['institution'],
                      e['location'],
                      dateRange,
                      e['gpa'] != null && e['gpa'].toString().isNotEmpty ? 'GPA: ${e['gpa']}' : null
                    ].where((s) => s != null && s.toString().isNotEmpty).join(' • ');
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 6),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text((e['degree'] ?? '').toString(),
                              style: pw.TextStyle(font: boldFont, fontSize: 10)),
                          if (instLocGpa.isNotEmpty)
                            pw.Text(instLocGpa,
                                style: pw.TextStyle(font: regularFont, fontSize: 9, color: PdfColors.grey700)),
                        ],
                      ),
                    );
                  }),
                ],

                if (projects.isNotEmpty) ...[
                  pw.SizedBox(height: 8),
                  pw.Text(isTr ? 'PROJELER' : 'PROJECTS',
                      style: pw.TextStyle(font: boldFont, fontSize: 10, letterSpacing: 1.5)),
                  pw.SizedBox(height: 6),
                  ...projects.map((proj) {
                    final p = proj;
                    final title = (p['title'] ?? '').toString();
                    final url = (p['url'] ?? '').toString();
                    final desc = (p['description'] ?? '').toString();
                    final techs = p['technologies'] is List ? (p['technologies'] as List).join(', ') : '';
                    final techLabel = isTr ? 'Teknolojiler' : 'Tech';
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 6),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(url.isNotEmpty ? '$title ($url)' : title,
                              style: pw.TextStyle(font: boldFont, fontSize: 10)),
                          if (desc.isNotEmpty)
                            pw.Text(desc, style: pw.TextStyle(font: regularFont, fontSize: 9)),
                          if (techs.isNotEmpty)
                            pw.Text('$techLabel: $techs', style: pw.TextStyle(font: regularFont, fontSize: 8, color: PdfColor.fromHex('#F59E0B'))),
                        ],
                      ),
                    );
                  }),
                ],

                if (skills.isNotEmpty) ...[
                  pw.SizedBox(height: 8),
                  pw.Text(isTr ? 'UZMANLIK ALANLARI' : 'KEY EXPERTISE',
                      style: pw.TextStyle(font: boldFont, fontSize: 10, letterSpacing: 1.5)),
                  pw.SizedBox(height: 4),
                  pw.Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: skills.map((s) {
                      final skill = s;
                      return pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromHex('#FEF3C7'),
                          borderRadius: pw.BorderRadius.circular(4),
                        ),
                        child: pw.Text((skill['name'] ?? '').toString(),
                            style: pw.TextStyle(
                                font: regularFont,
                                fontSize: 8,
                                color: PdfColor.fromHex('#92400E'))),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
