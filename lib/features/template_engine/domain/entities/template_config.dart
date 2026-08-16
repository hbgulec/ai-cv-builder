import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;

/// Configuration model for each resume template.
/// Decoupled from data: templates only define how data is visually rendered.
class TemplateConfig {
  final String id;
  final String name;
  final String description;
  final bool isPremium;
  final String category; // 'ats', 'modern', 'executive'
  final Color primaryColor;
  final Color accentColor;
  final String thumbnailAsset;

  const TemplateConfig({
    required this.id,
    required this.name,
    required this.description,
    required this.isPremium,
    required this.category,
    required this.primaryColor,
    required this.accentColor,
    required this.thumbnailAsset,
  });
}

/// Abstract base class for all resume template renderers
abstract class BaseResumeTemplate {
  TemplateConfig get config;

  /// Helper to resolve image bytes from photoBytes or photoPath (base64 string or file)
  Uint8List? resolvePhotoBytes(Map<String, dynamic> resumeData) {
    // 1. Direct Uint8List bytes (from editor state)
    final photoBytes = resumeData['photoBytes'];
    if (photoBytes is Uint8List && photoBytes.isNotEmpty) {
      return photoBytes;
    }
    if (photoBytes is List<int> && photoBytes.isNotEmpty) {
      return Uint8List.fromList(photoBytes);
    }
    // 2. Try photoPath — could be base64 string, data URI, or file path
    final photoPath = resumeData['photoPath'] as String?;
    if (photoPath != null && photoPath.isNotEmpty) {
      // 2a. Data URI format
      if (photoPath.startsWith('data:image')) {
        try {
          final base64Data = photoPath.split(',').last;
          return base64Decode(base64Data);
        } catch (_) {}
      }
      // 2b. Try raw base64 decode (cheap to attempt)
      try {
        final decoded = base64Decode(photoPath);
        if (decoded.isNotEmpty) return decoded;
      } catch (_) {}
      // 2c. File path fallback (native only)
      if (!kIsWeb) {
        try {
          final file = File(photoPath);
          if (file.existsSync()) {
            return file.readAsBytesSync();
          }
        } catch (_) {}
      }
    }
    return null;
  }

  /// Helper to safely convert map/object to Map<String, dynamic>
  Map<String, dynamic> safeToMap(dynamic val) {
    if (val == null) return {};
    if (val is Map<String, dynamic>) return val;
    if (val is Map) {
      return val.map((k, v) => MapEntry(k.toString(), v));
    }
    try {
      final json = (val as dynamic).toJson();
      if (json is Map<String, dynamic>) return json;
      if (json is Map) {
        return json.map((k, v) => MapEntry(k.toString(), v));
      }
    } catch (_) {}
    return {};
  }

  /// Helper to safely convert list of items to List<Map<String, dynamic>>
  List<Map<String, dynamic>> safeToListOfMap(dynamic val) {
    if (val is! List) return [];
    return val.map((item) => safeToMap(item)).toList();
  }

  /// Helper to get active language code ('tr' or 'en') from resumeData
  String getLanguageCode(Map<String, dynamic> resumeData) {
    final lang = (resumeData['contentLanguage'] ??
            resumeData['languageCode'] ??
            resumeData['language'] ??
            'en')
        .toString()
        .toLowerCase();
    return lang.startsWith('tr') ? 'tr' : 'en';
  }

  /// Helper to safely format date range strings (e.g. 01/2020 - 12/2022 or 05/2021 - Present/Halen)
  String formatDateRange(dynamic startDateVal, dynamic endDateVal, dynamic isCurrentVal, {String languageCode = 'en'}) {
    String formatSingle(dynamic val) {
      if (val == null) return '';
      if (val is DateTime) {
        return '${val.month.toString().padLeft(2, '0')}/${val.year}';
      }
      final s = val.toString().trim();
      if (s.isEmpty) return '';
      try {
        final dt = DateTime.parse(s);
        return '${dt.month.toString().padLeft(2, '0')}/${dt.year}';
      } catch (_) {}

      final clean = s.replaceAll(RegExp(r'[/\.\-\s]+'), '/');
      final parts = clean.split('/');
      if (parts.length == 2) {
        final p1 = int.tryParse(parts[0]);
        final p2 = int.tryParse(parts[1]);
        if (p1 != null && p2 != null) {
          if (p1 >= 1 && p1 <= 12 && p2 > 1000) {
            return '${p1.toString().padLeft(2, '0')}/$p2';
          }
          if (p1 > 1000 && p2 >= 1 && p2 <= 12) {
            return '${p2.toString().padLeft(2, '0')}/$p1';
          }
        }
      }
      return s;
    }

    final startStr = formatSingle(startDateVal);
    final bool isCurrent = isCurrentVal == true || isCurrentVal.toString().toLowerCase() == 'true';
    final presentLabel = languageCode.startsWith('tr') ? 'Halen' : 'Present';
    final endStr = isCurrent ? presentLabel : formatSingle(endDateVal);

    if (startStr.isEmpty && endStr.isEmpty) return '';
    if (startStr.isNotEmpty && endStr.isNotEmpty) return '$startStr - $endStr';
    if (startStr.isNotEmpty) return startStr;
    return endStr;
  }

  /// Builds a Flutter Widget preview of the resume (for live canvas)
  Widget buildPreview(Map<String, dynamic> resumeData);

  /// Builds a PDF Page for vector export inside the worker isolate
  pw.Page buildPdfPage(
    Map<String, dynamic> resumeData,
    pw.Font regularFont,
    pw.Font boldFont,
  );
}
