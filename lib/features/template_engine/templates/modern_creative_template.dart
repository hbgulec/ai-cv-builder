import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../domain/entities/template_config.dart';

/// Modern Creative — Premium template with two-column layout and bold design accents.
class ModernCreativeTemplate extends BaseResumeTemplate {
  @override
  TemplateConfig get config => const TemplateConfig(
        id: 'modern_creative',
        name: 'Modern Creative',
        description: 'Two-column layout with sidebar, vibrant accents and skill bars',
        isPremium: true,
        category: 'modern',
        primaryColor: Color(0xFF059669),
        accentColor: Color(0xFF34D399),
        thumbnailAsset: 'assets/templates/modern_creative_thumb.png',
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Sidebar
          Container(
            width: 120,
            color: const Color(0xFF064E3B),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar placeholder circle
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF34D399), width: 2),
                      color: const Color(0xFF065F46),
                    ),
                    child: ClipOval(
                      child: hasPhoto
                          ? Image.memory(
                              photoBytes!,
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                            )
                          : Center(
                              child: Text(
                                (header['fullName'] ?? 'N').toString().isNotEmpty
                                    ? (header['fullName'] ?? 'N').toString()[0].toUpperCase()
                                    : 'N',
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF34D399)),
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Contact info
                _sidebarLabel(isTr ? 'İLETİŞİM' : 'CONTACT'),
                const SizedBox(height: 4),
                if (header['email'] != null)
                  _sidebarItem(Icons.email_outlined, (header['email'] ?? '').toString()),
                if (header['phone'] != null)
                  _sidebarItem(Icons.phone_outlined, (header['phone'] ?? '').toString()),
                if (header['location'] != null)
                  _sidebarItem(Icons.location_on_outlined, (header['location'] ?? '').toString()),
                const SizedBox(height: 14),

                // Skills
                if (skills.isNotEmpty) ...[
                  _sidebarLabel(isTr ? 'YETENEKLER' : 'SKILLS'),
                  const SizedBox(height: 6),
                  ...skills.map((s) {
                    final skill = s;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text((skill['name'] ?? '').toString(),
                              style: const TextStyle(
                                  fontSize: 8, color: Colors.white, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 2),
                          Container(
                            height: 3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: const Color(0xFF065F46),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _skillLevel(skill['level']?.toString()),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: const Color(0xFF34D399),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],

                // Education
                if (educations.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  _sidebarLabel(isTr ? 'EĞİTİM' : 'EDUCATION'),
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
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text((e['degree'] ?? '').toString(),
                              style: const TextStyle(
                                  fontSize: 8,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                          if (instLocGpa.isNotEmpty)
                            Text(instLocGpa,
                                style: TextStyle(
                                    fontSize: 7, color: Colors.white.withValues(alpha: 0.7))),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),

          // Right Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text((header['fullName'] ?? 'Your Name').toString(),
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF064E3B))),
                  Text((header['professionalTitle'] ?? '').toString(),
                      style: const TextStyle(fontSize: 12, color: Color(0xFF059669))),
                  const SizedBox(height: 12),

                  if (summary.isNotEmpty) ...[
                    _mainSectionTitle(isTr ? 'Profil' : 'Profile'),
                    Text(summary,
                        style: const TextStyle(
                            fontSize: 10, color: Color(0xFF374151), height: 1.4)),
                    const SizedBox(height: 12),
                  ],

                  if (experiences.isNotEmpty) ...[
                    _mainSectionTitle(isTr ? 'İş Deneyimi' : 'Work Experience'),
                    ...experiences.map((exp) {
                      final e = exp;
                      final dateRange = formatDateRange(e['startDate'], e['endDate'], e['isCurrent'], languageCode: langCode);
                      final compLoc = [e['company'], e['location'], dateRange]
                          .where((s) => s != null && s.toString().isNotEmpty)
                          .join(' • ');
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text((e['jobTitle'] ?? '').toString(),
                                style: const TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.w600)),
                            if (compLoc.isNotEmpty)
                              Text(compLoc,
                                  style: const TextStyle(
                                      fontSize: 9, color: Color(0xFF059669))),
                            if (e['bulletPoints'] != null)
                              ...((e['bulletPoints'] as List).map((b) => Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text('▸ $b',
                                        style: const TextStyle(
                                            fontSize: 9, color: Color(0xFF6B7280))),
                                  ))),
                          ],
                        ),
                      );
                    }),
                  ],

                  if (projects.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _mainSectionTitle(isTr ? 'Projeler' : 'Projects'),
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
                                    fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF064E3B))),
                            if (desc.isNotEmpty)
                              Text(desc, style: const TextStyle(fontSize: 10, color: Color(0xFF374151))),
                            if (techs.isNotEmpty)
                              Text('$techLabel: $techs', style: const TextStyle(fontSize: 9, color: Color(0xFF059669), fontStyle: FontStyle.italic)),
                          ],
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _skillLevel(String? level) {
    switch (level) {
      case 'expert':
        return 1.0;
      case 'advanced':
        return 0.8;
      case 'intermediate':
        return 0.6;
      case 'beginner':
        return 0.35;
      default:
        return 0.6;
    }
  }

  Widget _sidebarLabel(String text) {
    return Text(text,
        style: const TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w700,
            color: Color(0xFF34D399),
            letterSpacing: 1.5));
  }

  Widget _sidebarItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 10, color: const Color(0xFF34D399)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(text,
                style: TextStyle(fontSize: 7, color: Colors.white.withValues(alpha: 0.85)),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _mainSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF064E3B))),
          Container(
            width: 30,
            height: 2.5,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF059669),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
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
    final pdfPhotoBytes = resolvePhotoBytes(resumeData);

    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (context) => pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Sidebar
          pw.Container(
            width: 170,
            height: double.infinity,
            color: PdfColor.fromHex('#064E3B'),
            padding: const pw.EdgeInsets.all(18),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Profile photo circle
                if (pdfPhotoBytes != null) ...[
                  pw.Center(
                    child: pw.ClipOval(
                      child: pw.Image(
                        pw.MemoryImage(pdfPhotoBytes),
                        width: 70,
                        height: 70,
                        fit: pw.BoxFit.cover,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 16),
                ] else
                  pw.SizedBox(height: 20),
                pw.Text(isTr ? 'İLETİŞİM' : 'CONTACT',
                    style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 8,
                        color: PdfColor.fromHex('#34D399'),
                        letterSpacing: 1.5)),
                pw.SizedBox(height: 6),
                if (header['email'] != null)
                  pw.Text((header['email'] ?? '').toString(),
                      style: pw.TextStyle(
                          font: regularFont, fontSize: 7, color: PdfColors.white)),
                if (header['phone'] != null)
                  pw.Text((header['phone'] ?? '').toString(),
                      style: pw.TextStyle(
                          font: regularFont, fontSize: 7, color: PdfColors.white)),
                if (header['location'] != null)
                  pw.Text((header['location'] ?? '').toString(),
                      style: pw.TextStyle(
                          font: regularFont, fontSize: 7, color: PdfColors.white)),
                pw.SizedBox(height: 18),
                if (skills.isNotEmpty) ...[
                  pw.Text(isTr ? 'YETENEKLER' : 'SKILLS',
                      style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 8,
                          color: PdfColor.fromHex('#34D399'),
                          letterSpacing: 1.5)),
                  pw.SizedBox(height: 6),
                  ...skills.map((s) {
                    final skill = s;
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 4),
                      child: pw.Text((skill['name'] ?? '').toString(),
                          style: pw.TextStyle(
                              font: regularFont, fontSize: 8, color: PdfColors.white)),
                    );
                  }),
                ],
                if (educations.isNotEmpty) ...[
                  pw.SizedBox(height: 18),
                  pw.Text(isTr ? 'EĞİTİM' : 'EDUCATION',
                      style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 8,
                          color: PdfColor.fromHex('#34D399'),
                          letterSpacing: 1.5)),
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
                              style: pw.TextStyle(
                                  font: boldFont, fontSize: 8, color: PdfColors.white)),
                          if (instLocGpa.isNotEmpty)
                            pw.Text(instLocGpa,
                                style: pw.TextStyle(
                                    font: regularFont, fontSize: 7, color: PdfColors.grey300)),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
          // Main body
          pw.Expanded(
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(28),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text((header['fullName'] ?? '').toString(),
                      style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 22,
                          color: PdfColor.fromHex('#064E3B'))),
                  pw.Text((header['professionalTitle'] ?? '').toString(),
                      style: pw.TextStyle(
                          font: regularFont,
                          fontSize: 12,
                          color: PdfColor.fromHex('#059669'))),
                  pw.SizedBox(height: 14),
                  if (summary.isNotEmpty) ...[
                    pw.Text(isTr ? 'Profil' : 'Profile',
                        style: pw.TextStyle(
                            font: boldFont,
                            fontSize: 12,
                            color: PdfColor.fromHex('#064E3B'))),
                    pw.SizedBox(height: 4),
                    pw.Text(summary,
                        style: pw.TextStyle(
                            font: regularFont, fontSize: 9, lineSpacing: 3)),
                    pw.SizedBox(height: 14),
                  ],
                  if (experiences.isNotEmpty) ...[
                    pw.Text(isTr ? 'İş Deneyimi' : 'Work Experience',
                        style: pw.TextStyle(
                            font: boldFont,
                            fontSize: 12,
                            color: PdfColor.fromHex('#064E3B'))),
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
                                      color: PdfColor.fromHex('#059669'))),
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
                  if (projects.isNotEmpty) ...[
                    pw.SizedBox(height: 10),
                    pw.Text(isTr ? 'Projeler' : 'Projects',
                        style: pw.TextStyle(
                            font: boldFont,
                            fontSize: 12,
                            color: PdfColor.fromHex('#064E3B'))),
                    pw.SizedBox(height: 6),
                    ...projects.map((proj) {
                      final p = proj;
                      final title = (p['title'] ?? '').toString();
                      final url = (p['url'] ?? '').toString();
                      final desc = (p['description'] ?? '').toString();
                      final techs = p['technologies'] is List ? (p['technologies'] as List).join(', ') : '';
                      final techLabel = isTr ? 'Teknolojiler' : 'Tech';
                      return pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 8),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(url.isNotEmpty ? '$title ($url)' : title,
                                style: pw.TextStyle(font: boldFont, fontSize: 10)),
                            if (desc.isNotEmpty)
                              pw.Text(desc, style: pw.TextStyle(font: regularFont, fontSize: 9)),
                            if (techs.isNotEmpty)
                              pw.Text('$techLabel: $techs', style: pw.TextStyle(font: regularFont, fontSize: 8, color: PdfColor.fromHex('#059669'))),
                          ],
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
