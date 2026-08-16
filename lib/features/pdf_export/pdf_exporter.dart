import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../template_engine/domain/entities/template_config.dart';

/// PDF Exporter utility for generating high-resolution vector PDFs off-thread.
class PdfExporter {
  static Future<pw.Font> _loadFont(
    Future<pw.Font> Function() primaryLoader,
    Future<pw.Font> Function() secondaryLoader,
    pw.Font fallbackFont,
  ) async {
    try {
      return await primaryLoader().timeout(const Duration(seconds: 4));
    } catch (_) {
      try {
        return await secondaryLoader().timeout(const Duration(seconds: 4));
      } catch (_) {
        return fallbackFont;
      }
    }
  }

  /// Generates and triggers native print/download layout for the resume
  static Future<void> exportPdf({
    required BaseResumeTemplate template,
    required Map<String, dynamic> resumeData,
    BuildContext? context,
  }) async {
    await savePdf(template: template, resumeData: resumeData, context: context);
  }

  /// Generates PDF and opens native print / download dialog for saving
  static Future<void> savePdf({
    required BaseResumeTemplate template,
    required Map<String, dynamic> resumeData,
    BuildContext? context,
  }) async {
    try {
      final pdf = pw.Document();

      final fontRegular = await _loadFont(
        () => PdfGoogleFonts.openSansRegular(),
        () => PdfGoogleFonts.robotoRegular(),
        pw.Font.helvetica(),
      );
      final fontBold = await _loadFont(
        () => PdfGoogleFonts.openSansBold(),
        () => PdfGoogleFonts.robotoBold(),
        pw.Font.helveticaBold(),
      );

      final page = template.buildPdfPage(resumeData, fontRegular, fontBold);
      pdf.addPage(page);

      final bytes = await pdf.save();
      final headerMap = template.safeToMap(resumeData['header']);
      final rawName = (headerMap['fullName'] ?? 'Resume').toString().trim();
      final sanitizedName = rawName.isEmpty
          ? 'Resume'
          : rawName.replaceAll(RegExp(r'[^\w\s\-]'), '').replaceAll(' ', '_');
      final fileName = '$sanitizedName.pdf';

      // 1. Direct download / share file dialog
      final shared = await Printing.sharePdf(
        bytes: bytes,
        filename: fileName,
      );

      // 2. Fallback to print layout popup if sharePdf did not launch dialog
      if (!shared) {
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => bytes,
          name: fileName,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error exporting PDF: $e\n$stackTrace');
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF indirme hatası: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      rethrow;
    }
  }
}
