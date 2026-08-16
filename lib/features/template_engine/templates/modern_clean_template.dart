import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../domain/entities/template_config.dart';

/// Modern Clean — Premium template with subtle color accents and modern typography.
class ModernCleanTemplate extends BaseResumeTemplate {
  @override
  TemplateConfig get config => const TemplateConfig(
        id: 'modern_clean',
        name: 'Modern Clean',
        description: 'Contemporary layout with color accents and refined spacing',
        isPremium: true,
        category: 'modern',
        primaryColor: Color(0xFF4F46E5),
        accentColor: Color(0xFF818CF8),
        thumbnailAsset: 'assets/templates/modern_clean_thumb.png',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Colored header bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (header['fullName'] ?? 'Your Name').toString(),
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 2),
                Text(
                  (header['professionalTitle'] ?? '').toString(),
                  style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85)),
                ),
                const SizedBox(height: 6),
                Text(
                  [header['email'], header['phone'], header['location']]
                      .where((e) => e != null && e.toString().isNotEmpty)
                      .join('  •  '),
                  style: TextStyle(fontSize: 9, color: Colors.white.withValues(alpha: 0.7)),
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
                  _sectionHeader(isTr ? 'Hakkımda' : 'About'),
                  Text(summary,
                      style: const TextStyle(fontSize: 10, color: Color(0xFF374151), height: 1.5)),
                  const SizedBox(height: 14),
                ],
                if (experiences.isNotEmpty) ...[
                  _sectionHeader(isTr ? 'Deneyim' : 'Experience'),
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
                          Container(
                            width: 3,
                            height: 40,
                            margin: const EdgeInsets.only(right: 10, top: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4F46E5),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text((e['jobTitle'] ?? '').toString(),
                                    style: const TextStyle(
                                        fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
                                if (compLoc.isNotEmpty)
                                  Text(compLoc,
                                      style: const TextStyle(
                                          fontSize: 10, color: Color(0xFF4F46E5))),
                                if (e['bulletPoints'] != null)
                                  ...((e['bulletPoints'] as List).map((b) => Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text('• $b',
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
                  const SizedBox(height: 10),
                  _sectionHeader(isTr ? 'Eğitim' : 'Education'),
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
                  const SizedBox(height: 10),
                  _sectionHeader(isTr ? 'Projeler' : 'Projects'),
                  ...projects.map((proj) {
                    final p = proj;
                    final title = (p['title'] ?? '').toString();
                    final url = (p['url'] ?? '').toString();
                    final desc = (p['description'] ?? '').toString();
                    final techs = p['technologies'] is List ? (p['technologies'] as List).join(', ') : '';
                    final techLabel = isTr ? 'Teknolojiler' : 'Tech';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(url.isNotEmpty ? '$title ($url)' : title,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1F2937))),
                          if (desc.isNotEmpty)
                            Text(desc, style: const TextStyle(fontSize: 10, color: Color(0xFF374151))),
                          if (techs.isNotEmpty)
                            Text('$techLabel: $techs', style: const TextStyle(fontSize: 9, color: Color(0xFF4F46E5), fontStyle: FontStyle.italic)),
                        ],
                      ),
                    );
                  }),
                ],
                if (skills.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _sectionHeader(isTr ? 'Yetenekler' : 'Skills'),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: skills.map((s) {
                      final skill = s;
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text((skill['name'] ?? '').toString(),
                            style: const TextStyle(fontSize: 9, color: Color(0xFF4338CA))),
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

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(title,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4F46E5))),
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
      margin: pw.EdgeInsets.zero,
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Header bar
          pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 28),
            color: PdfColor.fromHex('#4F46E5'),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text((header['fullName'] ?? '').toString(),
                    style: pw.TextStyle(
                        font: boldFont, fontSize: 22, color: PdfColors.white)),
                pw.SizedBox(height: 2),
                pw.Text((header['professionalTitle'] ?? '').toString(),
                    style: pw.TextStyle(
                        font: regularFont, fontSize: 12, color: PdfColors.white)),
                pw.SizedBox(height: 6),
                pw.Text(
                  [header['email'], header['phone'], header['location']]
                      .where((e) => e != null && e.toString().isNotEmpty)
                      .join('  •  '),
                  style: pw.TextStyle(
                      font: regularFont, fontSize: 9, color: PdfColors.grey300),
                ),
              ],
            ),
          ),

          pw.Padding(
            padding: const pw.EdgeInsets.all(40),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (summary.isNotEmpty) ...[
                  pw.Text(isTr ? 'Hakkımda' : 'About',
                      style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 12,
                          color: PdfColor.fromHex('#4F46E5'))),
                  pw.SizedBox(height: 4),
                  pw.Text(summary,
                      style: pw.TextStyle(font: regularFont, fontSize: 9, lineSpacing: 3)),
                  pw.SizedBox(height: 14),
                ],

                if (experiences.isNotEmpty) ...[
                  pw.Text(isTr ? 'Deneyim' : 'Experience',
                      style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 12,
                          color: PdfColor.fromHex('#4F46E5'))),
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
                                    color: PdfColor.fromHex('#4F46E5'))),
                          if (e['bulletPoints'] != null)
                            ...((e['bulletPoints'] as List).map((b) => pw.Padding(
                                  padding: const pw.EdgeInsets.only(top: 2),
                                  child: pw.Text('• $b',
                                      style: pw.TextStyle(
                                          font: regularFont, fontSize: 9)),
                                ))),
                        ],
                      ),
                    );
                  }),
                ],

                if (educations.isNotEmpty) ...[
                  pw.SizedBox(height: 8),
                  pw.Text(isTr ? 'Eğitim' : 'Education',
                      style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 12,
                          color: PdfColor.fromHex('#4F46E5'))),
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
                  pw.Text(isTr ? 'Projeler' : 'Projects',
                      style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 12,
                          color: PdfColor.fromHex('#4F46E5'))),
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
                            pw.Text('$techLabel: $techs', style: pw.TextStyle(font: regularFont, fontSize: 8, color: PdfColor.fromHex('#4F46E5'))),
                        ],
                      ),
                    );
                  }),
                ],

                if (skills.isNotEmpty) ...[
                  pw.SizedBox(height: 8),
                  pw.Text(isTr ? 'Yetenekler' : 'Skills',
                      style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 12,
                          color: PdfColor.fromHex('#4F46E5'))),
                  pw.SizedBox(height: 4),
                  pw.Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: skills.map((s) {
                      final skill = s;
                      return pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: pw.BoxDecoration(
                          color: PdfColor.fromHex('#EEF2FF'),
                          borderRadius: pw.BorderRadius.circular(12),
                        ),
                        child: pw.Text((skill['name'] ?? '').toString(),
                            style: pw.TextStyle(
                                font: regularFont,
                                fontSize: 8,
                                color: PdfColor.fromHex('#4338CA'))),
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
