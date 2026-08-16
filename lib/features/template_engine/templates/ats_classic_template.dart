import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../domain/entities/template_config.dart';

/// ATS Classic — Free Tier template optimized for maximum ATS parse-ability.
/// Clean single-column layout, zero graphics, standard formatting.
class AtsClassicTemplate extends BaseResumeTemplate {
  @override
  TemplateConfig get config => const TemplateConfig(
        id: 'ats_classic',
        name: 'ATS Classic',
        description: 'Clean, single-column ATS-optimized layout with standard formatting',
        isPremium: false,
        category: 'ats',
        primaryColor: Color(0xFF1E293B),
        accentColor: Color(0xFF334155),
        thumbnailAsset: 'assets/templates/ats_classic_thumb.png',
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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            (header['fullName'] ?? 'Your Name').toString(),
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            (header['professionalTitle'] ?? 'Professional Title').toString(),
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 4),
          Text(
            [
              header['email'],
              header['phone'],
              header['location'],
            ].where((e) => e != null && e.toString().isNotEmpty).join(' • '),
            style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
          ),
          const Divider(height: 20, thickness: 1.5, color: Color(0xFF1E293B)),

          // Summary
          if (summary.isNotEmpty) ...[
            Text(isTr ? 'PROFESYONEL ÖZET' : 'PROFESSIONAL SUMMARY',
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                    letterSpacing: 1)),
            const SizedBox(height: 4),
            Text(summary, style: const TextStyle(fontSize: 10, color: Color(0xFF475569), height: 1.4)),
            const SizedBox(height: 12),
          ],

          // Experience
          if (experiences.isNotEmpty) ...[
            Text(isTr ? 'İŞ DENEYİMİ' : 'WORK EXPERIENCE',
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                    letterSpacing: 1)),
            const Divider(height: 8, thickness: 0.5),
            ...experiences.map((exp) {
              final e = exp;
              final dateRange = formatDateRange(e['startDate'], e['endDate'], e['isCurrent'], languageCode: langCode);
              final compLocDate = [e['company'], e['location'], dateRange]
                  .where((s) => s != null && s.toString().isNotEmpty)
                  .join(' | ');
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            (e['jobTitle'] ?? '').toString(),
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                          ),
                        ),
                      ],
                    ),
                    if (compLocDate.isNotEmpty)
                      Text(
                        compLocDate,
                        style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                      ),
                    if (e['bulletPoints'] != null)
                      ...((e['bulletPoints'] as List).map((b) => Padding(
                            padding: const EdgeInsets.only(left: 8, top: 2),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(fontSize: 10)),
                                Expanded(
                                  child: Text(b.toString(),
                                      style: const TextStyle(fontSize: 10, color: Color(0xFF475569))),
                                ),
                              ],
                            ),
                          ))),
                  ],
                ),
              );
            }),
          ],

          // Education
          if (educations.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(isTr ? 'EĞİTİM' : 'EDUCATION',
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                    letterSpacing: 1)),
            const Divider(height: 8, thickness: 0.5),
            ...educations.map((edu) {
              final e = edu;
              final dateRange = formatDateRange(e['startDate'], e['endDate'], e['isCurrent'], languageCode: langCode);
              final instLocGpa = [
                e['institution'],
                e['location'],
                dateRange,
                e['gpa'] != null && e['gpa'].toString().isNotEmpty ? 'GPA: ${e['gpa']}' : null
              ].where((s) => s != null && s.toString().isNotEmpty).join(' | ');
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text((e['degree'] ?? '').toString(),
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                    if (instLocGpa.isNotEmpty)
                      Text(instLocGpa,
                          style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                  ],
                ),
              );
            }),
          ],

          // Projects
          if (projects.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(isTr ? 'PROJELER' : 'PROJECTS',
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                    letterSpacing: 1)),
            const Divider(height: 8, thickness: 0.5),
            ...projects.map((proj) {
              final p = proj;
              final title = (p['title'] ?? '').toString();
              final url = (p['url'] ?? '').toString();
              final desc = (p['description'] ?? '').toString();
              final techs = p['technologies'] is List ? (p['technologies'] as List).join(', ') : '';
              final techLabel = isTr ? 'Teknolojiler' : 'Technologies';
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(url.isNotEmpty ? '$title ($url)' : title,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                    if (desc.isNotEmpty)
                      Text(desc, style: const TextStyle(fontSize: 10, color: Color(0xFF475569))),
                    if (techs.isNotEmpty)
                      Text('$techLabel: $techs', style: const TextStyle(fontSize: 9, color: Color(0xFF64748B), fontStyle: FontStyle.italic)),
                  ],
                ),
              );
            }),
          ],

          // Skills
          if (skills.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(isTr ? 'YETENEKLER' : 'SKILLS',
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                    letterSpacing: 1)),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: skills.map((s) {
                final skill = s;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text((skill['name'] ?? '').toString(),
                      style: const TextStyle(fontSize: 9, color: Color(0xFF334155))),
                );
              }).toList(),
            ),
          ],
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
      margin: const pw.EdgeInsets.all(40),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text((header['fullName'] ?? 'Your Name').toString(),
              style: pw.TextStyle(font: boldFont, fontSize: 22)),
          pw.SizedBox(height: 2),
          pw.Text((header['professionalTitle'] ?? '').toString(),
              style: pw.TextStyle(font: regularFont, fontSize: 12, color: PdfColors.grey700)),
          pw.SizedBox(height: 4),
          pw.Text(
            [header['email'], header['phone'], header['location']]
                .where((e) => e != null && e.toString().isNotEmpty)
                .join(' | '),
            style: pw.TextStyle(font: regularFont, fontSize: 9, color: PdfColors.grey600),
          ),
          pw.Divider(thickness: 1.5, color: PdfColors.grey900),
          pw.SizedBox(height: 8),

          if (summary.isNotEmpty) ...[
            pw.Text(isTr ? 'PROFESYONEL ÖZET' : 'PROFESSIONAL SUMMARY',
                style: pw.TextStyle(font: boldFont, fontSize: 10, letterSpacing: 1)),
            pw.SizedBox(height: 4),
            pw.Text(summary,
                style: pw.TextStyle(font: regularFont, fontSize: 9, lineSpacing: 3)),
            pw.SizedBox(height: 12),
          ],

          if (experiences.isNotEmpty) ...[
            pw.Text(isTr ? 'İŞ DENEYİMİ' : 'WORK EXPERIENCE',
                style: pw.TextStyle(font: boldFont, fontSize: 10, letterSpacing: 1)),
            pw.Divider(thickness: 0.5),
            ...experiences.map((exp) {
              final e = exp;
              final dateRange = formatDateRange(e['startDate'], e['endDate'], e['isCurrent'], languageCode: langCode);
              final compLocDate = [e['company'], e['location'], dateRange]
                  .where((s) => s != null && s.toString().isNotEmpty)
                  .join(' | ');
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
                              font: regularFont, fontSize: 9, color: PdfColors.grey700)),
                    if (e['bulletPoints'] != null)
                      ...((e['bulletPoints'] as List).map((b) => pw.Padding(
                            padding: const pw.EdgeInsets.only(left: 8, top: 2),
                            child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('•  ',
                                    style: pw.TextStyle(font: regularFont, fontSize: 9)),
                                pw.Expanded(
                                  child: pw.Text(b.toString(),
                                      style: pw.TextStyle(font: regularFont, fontSize: 9)),
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
            pw.SizedBox(height: 8),
            pw.Text(isTr ? 'EĞİTİM' : 'EDUCATION',
                style: pw.TextStyle(font: boldFont, fontSize: 10, letterSpacing: 1)),
            pw.Divider(thickness: 0.5),
            ...educations.map((edu) {
              final e = edu;
              final dateRange = formatDateRange(e['startDate'], e['endDate'], e['isCurrent'], languageCode: langCode);
              final instLocGpa = [
                e['institution'],
                e['location'],
                dateRange,
                e['gpa'] != null && e['gpa'].toString().isNotEmpty ? 'GPA: ${e['gpa']}' : null
              ].where((s) => s != null && s.toString().isNotEmpty).join(' | ');
              return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 4),
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
                style: pw.TextStyle(font: boldFont, fontSize: 10, letterSpacing: 1)),
            pw.Divider(thickness: 0.5),
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
                      pw.Text('$techLabel: $techs', style: pw.TextStyle(font: regularFont, fontSize: 8, color: PdfColors.grey700)),
                  ],
                ),
              );
            }),
          ],

          if (skills.isNotEmpty) ...[
            pw.SizedBox(height: 8),
            pw.Text(isTr ? 'YETENEKLER' : 'SKILLS',
                style: pw.TextStyle(font: boldFont, fontSize: 10, letterSpacing: 1)),
            pw.SizedBox(height: 4),
            pw.Wrap(
              spacing: 6,
              runSpacing: 4,
              children: skills.map((s) {
                final skill = s;
                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey400),
                    borderRadius: pw.BorderRadius.circular(3),
                  ),
                  child: pw.Text((skill['name'] ?? '').toString(),
                      style: pw.TextStyle(font: regularFont, fontSize: 8)),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
