import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../domain/entities/template_config.dart';

/// Executive Minimal — Premium template for senior/executive-level professionals.
/// Refined typography, generous whitespace, understated elegance.
class ExecutiveMinimalTemplate extends BaseResumeTemplate {
  @override
  TemplateConfig get config => const TemplateConfig(
        id: 'executive_minimal',
        name: 'Executive Minimal',
        description: 'Refined executive layout with elegant spacing and serif accents',
        isPremium: true,
        category: 'executive',
        primaryColor: Color(0xFF1F2937),
        accentColor: Color(0xFFB45309),
        thumbnailAsset: 'assets/templates/executive_minimal_thumb.png',
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

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name & title with gold accent line
          Center(
            child: Column(
              children: [
                Text(
                  (header['fullName'] ?? 'Your Name').toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF1F2937),
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 4),
                Container(width: 40, height: 2, color: const Color(0xFFB45309)),
                const SizedBox(height: 6),
                Text(
                  (header['professionalTitle'] ?? '').toString(),
                  style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFB45309),
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Text(
                  [header['email'], header['phone'], header['location']]
                      .where((e) => e != null && e.toString().isNotEmpty)
                      .join('  ·  '),
                  style: const TextStyle(fontSize: 9, color: Color(0xFF9CA3AF)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (summary.isNotEmpty) ...[
            _execSectionTitle(isTr ? 'Yönetici Özeti' : 'Executive Summary'),
            Text(summary,
                style: const TextStyle(
                    fontSize: 10, color: Color(0xFF4B5563), height: 1.6, fontStyle: FontStyle.italic)),
            const SizedBox(height: 16),
          ],

          if (experiences.isNotEmpty) ...[
            _execSectionTitle(isTr ? 'Mesleki Deneyim' : 'Professional Experience'),
            ...experiences.map((exp) {
              final e = exp;
              final dateRange = formatDateRange(e['startDate'], e['endDate'], e['isCurrent'], languageCode: langCode);
              final compLocDate = [e['company'], e['location'], dateRange]
                  .where((s) => s != null && s.toString().isNotEmpty)
                  .join('  ·  ');
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text((e['jobTitle'] ?? '').toString(),
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2937))),
                      ],
                    ),
                    if (compLocDate.isNotEmpty)
                      Text(compLocDate,
                          style: const TextStyle(
                              fontSize: 10, color: Color(0xFFB45309), fontWeight: FontWeight.w500)),
                    if (e['bulletPoints'] != null)
                      ...((e['bulletPoints'] as List).map((b) => Padding(
                            padding: const EdgeInsets.only(top: 3, left: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 4,
                                  height: 4,
                                  margin: const EdgeInsets.only(top: 4, right: 6),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFB45309),
                                  ),
                                ),
                                Expanded(
                                  child: Text(b.toString(),
                                      style: const TextStyle(
                                          fontSize: 9, color: Color(0xFF6B7280), height: 1.4)),
                                ),
                              ],
                            ),
                          ))),
                  ],
                ),
              );
            }),
          ],

          if (educations.isNotEmpty) ...[
            _execSectionTitle(isTr ? 'Eğitim' : 'Education'),
            ...educations.map((edu) {
              final e = edu;
              final dateRange = formatDateRange(e['startDate'], e['endDate'], e['isCurrent'], languageCode: langCode);
              final instLocGpa = [
                e['institution'],
                e['location'],
                dateRange,
                e['gpa'] != null && e['gpa'].toString().isNotEmpty ? 'GPA: ${e['gpa']}' : null
              ].where((s) => s != null && s.toString().isNotEmpty).join('  ·  ');
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text((e['degree'] ?? '').toString(),
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
                    if (instLocGpa.isNotEmpty)
                      Text(instLocGpa,
                          style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                  ],
                ),
              );
            }),
          ],

          if (projects.isNotEmpty) ...[
            const SizedBox(height: 8),
            _execSectionTitle(isTr ? 'Projeler' : 'Projects'),
            ...projects.map((proj) {
              final p = proj;
              final title = (p['title'] ?? '').toString();
              final url = (p['url'] ?? '').toString();
              final desc = (p['description'] ?? '').toString();
              final techs = p['technologies'] is List ? (p['technologies'] as List).join(', ') : '';
              final techLabel = isTr ? 'Teknolojiler' : 'Technologies';
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(url.isNotEmpty ? '$title ($url)' : title,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
                    if (desc.isNotEmpty)
                      Text(desc, style: const TextStyle(fontSize: 10, color: Color(0xFF4B5563))),
                    if (techs.isNotEmpty)
                      Text('$techLabel: $techs', style: const TextStyle(fontSize: 9, color: Color(0xFFB45309), fontStyle: FontStyle.italic)),
                  ],
                ),
              );
            }),
          ],

          if (skills.isNotEmpty) ...[
            const SizedBox(height: 8),
            _execSectionTitle(isTr ? 'Temel Yetkinlikler' : 'Core Competencies'),
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: skills.map((s) {
                final skill = s;
                return Text((skill['name'] ?? '').toString(),
                    style: const TextStyle(fontSize: 10, color: Color(0xFF4B5563)));
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _execSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(title.toUpperCase(),
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                  letterSpacing: 2)),
          const SizedBox(width: 12),
          Expanded(child: Container(height: 0.5, color: const Color(0xFFD1D5DB))),
        ],
      ),
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

    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(horizontal: 48, vertical: 40),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Column(children: [
              pw.Text((header['fullName'] ?? '').toString(),
                  style: pw.TextStyle(font: boldFont, fontSize: 24, letterSpacing: 3)),
              pw.SizedBox(height: 4),
              pw.Container(width: 40, height: 2, color: PdfColor.fromHex('#B45309')),
              pw.SizedBox(height: 6),
              pw.Text((header['professionalTitle'] ?? '').toString(),
                  style: pw.TextStyle(
                      font: regularFont,
                      fontSize: 11,
                      color: PdfColor.fromHex('#B45309'),
                      letterSpacing: 2)),
              pw.SizedBox(height: 6),
              pw.Text(
                [header['email'], header['phone'], header['location']]
                    .where((e) => e != null && e.toString().isNotEmpty)
                    .join('  ·  '),
                style: pw.TextStyle(font: regularFont, fontSize: 9, color: PdfColors.grey600),
              ),
            ]),
          ),
          pw.SizedBox(height: 20),

          if (summary.isNotEmpty) ...[
            pw.Text(isTr ? 'YÖNETİCİ ÖZETİ' : 'EXECUTIVE SUMMARY',
                style: pw.TextStyle(font: boldFont, fontSize: 10, letterSpacing: 2)),
            pw.Divider(thickness: 0.5),
            pw.SizedBox(height: 4),
            pw.Text(summary,
                style: pw.TextStyle(
                    font: regularFont, fontSize: 9, fontStyle: pw.FontStyle.italic, lineSpacing: 3)),
            pw.SizedBox(height: 14),
          ],

          if (experiences.isNotEmpty) ...[
            pw.Text(isTr ? 'MESLEKİ DENEYİM' : 'PROFESSIONAL EXPERIENCE',
                style: pw.TextStyle(font: boldFont, fontSize: 10, letterSpacing: 2)),
            pw.Divider(thickness: 0.5),
            pw.SizedBox(height: 4),
            ...experiences.map((exp) {
              final e = exp;
              final dateRange = formatDateRange(e['startDate'], e['endDate'], e['isCurrent'], languageCode: langCode);
              final compLocDate = [e['company'], e['location'], dateRange]
                  .where((s) => s != null && s.toString().isNotEmpty)
                  .join('  ·  ');
              return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text((e['jobTitle'] ?? '').toString(),
                        style: pw.TextStyle(font: boldFont, fontSize: 10)),
                    if (compLocDate.isNotEmpty)
                      pw.Text(compLocDate,
                          style: pw.TextStyle(
                              font: regularFont,
                              fontSize: 9,
                              color: PdfColor.fromHex('#B45309'))),
                    if (e['bulletPoints'] != null)
                      ...((e['bulletPoints'] as List).map((b) => pw.Padding(
                            padding: const pw.EdgeInsets.only(top: 2, left: 6),
                            child: pw.Text('• $b',
                                style: pw.TextStyle(font: regularFont, fontSize: 9)),
                          ))),
                  ],
                ),
              );
            }),
          ],

          if (educations.isNotEmpty) ...[
            pw.Text(isTr ? 'EĞİTİM' : 'EDUCATION',
                style: pw.TextStyle(font: boldFont, fontSize: 10, letterSpacing: 2)),
            pw.Divider(thickness: 0.5),
            pw.SizedBox(height: 4),
            ...educations.map((edu) {
              final e = edu;
              final dateRange = formatDateRange(e['startDate'], e['endDate'], e['isCurrent'], languageCode: langCode);
              final instLocGpa = [
                e['institution'],
                e['location'],
                dateRange,
                e['gpa'] != null && e['gpa'].toString().isNotEmpty ? 'GPA: ${e['gpa']}' : null
              ].where((s) => s != null && s.toString().isNotEmpty).join('  ·  ');
              return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 6),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text((e['degree'] ?? '').toString(),
                        style: pw.TextStyle(font: boldFont, fontSize: 10)),
                    if (instLocGpa.isNotEmpty)
                      pw.Text(instLocGpa,
                          style: pw.TextStyle(font: regularFont, fontSize: 9, color: PdfColors.grey600)),
                  ],
                ),
              );
            }),
          ],

          if (projects.isNotEmpty) ...[
            pw.SizedBox(height: 8),
            pw.Text(isTr ? 'PROJELER' : 'PROJECTS',
                style: pw.TextStyle(font: boldFont, fontSize: 10, letterSpacing: 2)),
            pw.Divider(thickness: 0.5),
            pw.SizedBox(height: 4),
            ...projects.map((proj) {
              final p = proj;
              final title = (p['title'] ?? '').toString();
              final url = (p['url'] ?? '').toString();
              final desc = (p['description'] ?? '').toString();
              final techs = p['technologies'] is List ? (p['technologies'] as List).join(', ') : '';
              final techLabel = isTr ? 'Teknolojiler' : 'Technologies';
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
                      pw.Text('$techLabel: $techs', style: pw.TextStyle(font: regularFont, fontSize: 8, color: PdfColor.fromHex('#B45309'))),
                  ],
                ),
              );
            }),
          ],

          if (skills.isNotEmpty) ...[
            pw.SizedBox(height: 8),
            pw.Text(isTr ? 'TEMEL YETKİNLİKLER' : 'CORE COMPETENCIES',
                style: pw.TextStyle(font: boldFont, fontSize: 10, letterSpacing: 2)),
            pw.Divider(thickness: 0.5),
            pw.SizedBox(height: 4),
            pw.Text(
              skills.map((s) => safeToMap(s)['name'] ?? '').join('  •  '),
              style: pw.TextStyle(font: regularFont, fontSize: 9),
            ),
          ],
        ],
      ),
    );
  }
}
