import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../domain/entities/template_config.dart';

/// ATS Pure — Free Tier template with minimal styling for maximum ATS compatibility.
/// Ultra-clean layout with no colors or decorative elements.
class AtsPureTemplate extends BaseResumeTemplate {
  @override
  TemplateConfig get config => const TemplateConfig(
        id: 'ats_pure',
        name: 'ATS Pure',
        description: 'Ultra-minimal layout — zero decoration for 100% ATS parse-ability',
        isPremium: false,
        category: 'ats',
        primaryColor: Color(0xFF000000),
        accentColor: Color(0xFF6B7280),
        thumbnailAsset: 'assets/templates/ats_pure_thumb.png',
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
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name centered
          Center(
            child: Text(
              (header['fullName'] ?? 'Your Name').toString().toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Center(
            child: Text(
              (header['professionalTitle'] ?? '').toString(),
              style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              [header['email'], header['phone'], header['location']]
                  .where((e) => e != null && e.toString().isNotEmpty)
                  .join(' | '),
              style: const TextStyle(fontSize: 9, color: Color(0xFF9CA3AF)),
            ),
          ),
          const Divider(height: 20, thickness: 0.5, color: Colors.black54),

          // Summary
          if (summary.isNotEmpty) ...[
            _sectionTitle(isTr ? 'Özet' : 'Summary'),
            const SizedBox(height: 3),
            Text(summary,
                style: const TextStyle(fontSize: 10, color: Color(0xFF374151), height: 1.4)),
            const SizedBox(height: 10),
          ],

          // Experience
          if (experiences.isNotEmpty) ...[
            _sectionTitle(isTr ? 'Deneyim' : 'Experience'),
            ...experiences.map((exp) {
              final e = exp;
              final loc = (e['location'] ?? '').toString();
              final dateRange = formatDateRange(e['startDate'], e['endDate'], e['isCurrent'], languageCode: langCode);
              final compLocDate = [e['company'], loc, dateRange].where((s) => s != null && s.toString().isNotEmpty).join(' | ');
              final headerStr = '${e['jobTitle'] ?? ''}${compLocDate.isNotEmpty ? ' — $compLocDate' : ''}';
              return Padding(
                padding: const EdgeInsets.only(bottom: 6, top: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(headerStr,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black)),
                    if (e['bulletPoints'] != null)
                      ...((e['bulletPoints'] as List).map((b) => Padding(
                            padding: const EdgeInsets.only(left: 10, top: 1),
                            child: Text('- $b',
                                style: const TextStyle(fontSize: 9, color: Color(0xFF4B5563))),
                          ))),
                  ],
                ),
              );
            }),
          ],

          // Education
          if (educations.isNotEmpty) ...[
            _sectionTitle(isTr ? 'Eğitim' : 'Education'),
            ...educations.map((edu) {
              final e = edu;
              final degree = (e['degree'] ?? '').toString();
              final inst = (e['institution'] ?? '').toString();
              final loc = (e['location'] ?? '').toString();
              final gpa = (e['gpa'] ?? '').toString();
              final dateRange = formatDateRange(e['startDate'], e['endDate'], e['isCurrent'], languageCode: langCode);
              final mainText = [degree, inst].where((s) => s.isNotEmpty).join(' — ');
              final subText = [loc, dateRange, gpa.isNotEmpty ? 'GPA: $gpa' : ''].where((s) => s.isNotEmpty).join(' | ');
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mainText, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black)),
                    if (subText.isNotEmpty)
                      Text(subText, style: const TextStyle(fontSize: 9, color: Color(0xFF4B5563))),
                  ],
                ),
              );
            }),
          ],

          // Projects
          if (projects.isNotEmpty) ...[
            const SizedBox(height: 6),
            _sectionTitle(isTr ? 'Projeler' : 'Projects'),
            ...projects.map((proj) {
              final p = proj;
              final title = (p['title'] ?? '').toString();
              final url = (p['url'] ?? '').toString();
              final desc = (p['description'] ?? '').toString();
              final techs = p['technologies'] is List ? (p['technologies'] as List).join(', ') : '';
              final techLabel = isTr ? 'Teknolojiler' : 'Tech';
              return Padding(
                padding: const EdgeInsets.only(bottom: 6, top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(url.isNotEmpty ? '$title ($url)' : title,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black)),
                    if (desc.isNotEmpty)
                      Text(desc, style: const TextStyle(fontSize: 9, color: Color(0xFF374151))),
                    if (techs.isNotEmpty)
                      Text('$techLabel: $techs', style: const TextStyle(fontSize: 9, color: Color(0xFF6B7280), fontStyle: FontStyle.italic)),
                  ],
                ),
              );
            }),
          ],

          // Skills
          if (skills.isNotEmpty) ...[
            const SizedBox(height: 6),
            _sectionTitle(isTr ? 'Yetenekler' : 'Skills'),
            const SizedBox(height: 2),
            Text(
              skills.map((s) => safeToMap(s)['name'] ?? '').join(', '),
              style: const TextStyle(fontSize: 10, color: Color(0xFF374151)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(),
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: Colors.black)),
        const Divider(height: 6, thickness: 0.5, color: Colors.black26),
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

    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(44),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Center(
            child: pw.Text(
              (header['fullName'] ?? 'Your Name').toString().toUpperCase(),
              style: pw.TextStyle(font: boldFont, fontSize: 20, letterSpacing: 2),
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Center(
            child: pw.Text((header['professionalTitle'] ?? '').toString(),
                style: pw.TextStyle(font: regularFont, fontSize: 11, color: PdfColors.grey700)),
          ),
          pw.SizedBox(height: 4),
          pw.Center(
            child: pw.Text(
              [header['email'], header['phone'], header['location']]
                  .where((e) => e != null && e.toString().isNotEmpty)
                  .join(' | '),
              style: pw.TextStyle(font: regularFont, fontSize: 9, color: PdfColors.grey600),
            ),
          ),
          pw.Divider(thickness: 0.5),
          pw.SizedBox(height: 6),

          if (summary.isNotEmpty) ...[
            _pdfSectionTitle(isTr ? 'Özet' : 'Summary', boldFont),
            pw.Text(summary,
                style: pw.TextStyle(font: regularFont, fontSize: 9, lineSpacing: 2.5)),
            pw.SizedBox(height: 10),
          ],

          if (experiences.isNotEmpty) ...[
            _pdfSectionTitle(isTr ? 'Deneyim' : 'Experience', boldFont),
            ...experiences.map((exp) {
              final e = exp;
              final loc = (e['location'] ?? '').toString();
              final dateRange = formatDateRange(e['startDate'], e['endDate'], e['isCurrent'], languageCode: langCode);
              final compLocDate = [e['company'], loc, dateRange].where((s) => s != null && s.toString().isNotEmpty).join(' | ');
              final headerStr = '${e['jobTitle'] ?? ''}${compLocDate.isNotEmpty ? ' — $compLocDate' : ''}';
              return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 6),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(headerStr,
                        style: pw.TextStyle(font: boldFont, fontSize: 10)),
                    if (e['bulletPoints'] != null)
                      ...((e['bulletPoints'] as List).map((b) => pw.Padding(
                            padding: const pw.EdgeInsets.only(left: 10, top: 1),
                            child: pw.Text('- $b',
                                style: pw.TextStyle(font: regularFont, fontSize: 9)),
                          ))),
                  ],
                ),
              );
            }),
          ],

          if (educations.isNotEmpty) ...[
            _pdfSectionTitle(isTr ? 'Eğitim' : 'Education', boldFont),
            ...educations.map((edu) {
              final e = edu;
              final degree = (e['degree'] ?? '').toString();
              final inst = (e['institution'] ?? '').toString();
              final loc = (e['location'] ?? '').toString();
              final gpa = (e['gpa'] ?? '').toString();
              final dateRange = formatDateRange(e['startDate'], e['endDate'], e['isCurrent'], languageCode: langCode);
              final mainText = [degree, inst].where((s) => s.isNotEmpty).join(' — ');
              final subText = [loc, dateRange, gpa.isNotEmpty ? 'GPA: $gpa' : ''].where((s) => s.isNotEmpty).join(' | ');
              return pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 4),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(mainText, style: pw.TextStyle(font: boldFont, fontSize: 9)),
                    if (subText.isNotEmpty)
                      pw.Text(subText, style: pw.TextStyle(font: regularFont, fontSize: 8, color: PdfColors.grey700)),
                  ],
                ),
              );
            }),
          ],

          if (projects.isNotEmpty) ...[
            pw.SizedBox(height: 6),
            _pdfSectionTitle(isTr ? 'Projeler' : 'Projects', boldFont),
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
                        style: pw.TextStyle(font: boldFont, fontSize: 9)),
                    if (desc.isNotEmpty)
                      pw.Text(desc, style: pw.TextStyle(font: regularFont, fontSize: 8)),
                    if (techs.isNotEmpty)
                      pw.Text('$techLabel: $techs', style: pw.TextStyle(font: regularFont, fontSize: 8, color: PdfColors.grey700)),
                  ],
                ),
              );
            }),
          ],

          if (skills.isNotEmpty) ...[
            pw.SizedBox(height: 8),
            _pdfSectionTitle(isTr ? 'Yetenekler' : 'Skills', boldFont),
            pw.Text(
              skills.map((s) => safeToMap(s)['name'] ?? '').join(', '),
              style: pw.TextStyle(font: regularFont, fontSize: 9),
            ),
          ],
        ],
      ),
    );
  }

  pw.Widget _pdfSectionTitle(String title, pw.Font boldFont) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title.toUpperCase(),
            style: pw.TextStyle(font: boldFont, fontSize: 10, letterSpacing: 1.5)),
        pw.Divider(thickness: 0.5),
        pw.SizedBox(height: 3),
      ],
    );
  }
}
