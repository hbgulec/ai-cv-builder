import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'font_byte_loader.dart';

/// Persistent long-lived Worker Isolate for off-main-thread vector PDF generation.
/// Keeps a bidirectional SendPort/ReceivePort channel alive to avoid
/// spawning new isolates on every render request (prevents memory churn).
class PdfWorkerIsolate {
  static SendPort? _isolateSendPort;
  static final Map<String, Completer<List<int>>> _pendingRequests = {};
  static bool _isInitialized = false;

  /// Initialize the persistent worker isolate.
  /// Pre-loads font bytes on the main thread and transfers them
  /// to the isolate for Turkish Unicode glyph rendering.
  static Future<void> initialize() async {
    if (_isInitialized) return;

    // Pre-load font bytes on main thread (rootBundle is not available inside isolates)
    await FontByteLoader.preload();

    final receivePort = ReceivePort();
    await Isolate.spawn(
      _workerEntryPoint,
      {
        'sendPort': receivePort.sendPort,
        'fontInterRegular': FontByteLoader.interRegular,
        'fontInterBold': FontByteLoader.interBold,
      },
    );

    // First message from isolate is its SendPort
    final completer = Completer<SendPort>();
    receivePort.listen((message) {
      if (message is SendPort) {
        completer.complete(message);
      } else if (message is Map<String, dynamic>) {
        final String reqId = message['reqId'];
        if (message.containsKey('error')) {
          _pendingRequests.remove(reqId)?.completeError(
            Exception(message['error']),
          );
        } else {
          final List<int> pdfBytes = message['pdfBytes'];
          _pendingRequests.remove(reqId)?.complete(pdfBytes);
        }
      }
    });

    _isolateSendPort = await completer.future;
    _isInitialized = true;
  }

  /// Renders a vector PDF from resume JSON data.
  /// Returns raw PDF bytes for saving/sharing.
  static Future<List<int>> renderPdf(Map<String, dynamic> resumeJson) async {
    await initialize();

    final reqId = DateTime.now().microsecondsSinceEpoch.toString();
    final completer = Completer<List<int>>();
    _pendingRequests[reqId] = completer;

    _isolateSendPort!.send({
      'reqId': reqId,
      'resumeJson': resumeJson,
    });

    return completer.future;
  }

  /// Disposes the persistent isolate (call on app shutdown)
  static void dispose() {
    _isolateSendPort = null;
    _isInitialized = false;
    _pendingRequests.clear();
  }

  /// Worker isolate entry point — runs in a separate Dart isolate
  static void _workerEntryPoint(Map<String, dynamic> initData) {
    final SendPort mainSendPort = initData['sendPort'];
    final Uint8List fontInterRegular = initData['fontInterRegular'];
    final Uint8List fontInterBold = initData['fontInterBold'];

    // Initialize PDF fonts from transferred byte buffers
    final ttfRegular = pw.Font.ttf(fontInterRegular.buffer.asByteData());
    final ttfBold = pw.Font.ttf(fontInterBold.buffer.asByteData());

    // Create a ReceivePort for incoming render commands
    final commandPort = ReceivePort();

    // Send our SendPort back to the main isolate
    mainSendPort.send(commandPort.sendPort);

    commandPort.listen((message) async {
      try {
        final String reqId = message['reqId'];
        final Map<String, dynamic> resumeJson = Map<String, dynamic>.from(message['resumeJson']);

        // Build a simple PDF document
        final doc = pw.Document();

        // Build header content
        final header = resumeJson['header'] as Map<String, dynamic>? ?? {};
        final summary = resumeJson['summary'] as String? ?? '';
        final experiences = resumeJson['workExperiences'] as List? ?? [];
        final educations = resumeJson['educationList'] as List? ?? [];
        final skills = resumeJson['skills'] as List? ?? [];

        doc.addPage(
          pw.Page(
            margin: const pw.EdgeInsets.all(40),
            build: (context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  header['fullName'] ?? '',
                  style: pw.TextStyle(font: ttfBold, fontSize: 22),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  header['professionalTitle'] ?? '',
                  style: pw.TextStyle(font: ttfRegular, fontSize: 12),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  [header['email'], header['phone'], header['location']]
                      .where((e) => e != null && e.toString().isNotEmpty)
                      .join(' | '),
                  style: pw.TextStyle(font: ttfRegular, fontSize: 9),
                ),
                pw.Divider(thickness: 1),
                pw.SizedBox(height: 8),

                if (summary.isNotEmpty) ...[
                  pw.Text('PROFESSIONAL SUMMARY',
                      style: pw.TextStyle(font: ttfBold, fontSize: 10, letterSpacing: 1)),
                  pw.SizedBox(height: 4),
                  pw.Text(summary,
                      style: pw.TextStyle(font: ttfRegular, fontSize: 9, lineSpacing: 3)),
                  pw.SizedBox(height: 12),
                ],

                if (experiences.isNotEmpty) ...[
                  pw.Text('WORK EXPERIENCE',
                      style: pw.TextStyle(font: ttfBold, fontSize: 10, letterSpacing: 1)),
                  pw.Divider(thickness: 0.5),
                  ...experiences.map((exp) {
                    final e = exp is Map<String, dynamic> ? exp : {};
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 8),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(e['jobTitle'] ?? '',
                              style: pw.TextStyle(font: ttfBold, fontSize: 10)),
                          pw.Text('${e['company'] ?? ''} | ${e['location'] ?? ''}',
                              style: pw.TextStyle(font: ttfRegular, fontSize: 9)),
                          if (e['bulletPoints'] is List)
                            ...((e['bulletPoints'] as List).map((b) => pw.Padding(
                                  padding: const pw.EdgeInsets.only(left: 8, top: 2),
                                  child: pw.Text('• $b',
                                      style: pw.TextStyle(font: ttfRegular, fontSize: 9)),
                                ))),
                        ],
                      ),
                    );
                  }),
                ],

                if (educations.isNotEmpty) ...[
                  pw.SizedBox(height: 8),
                  pw.Text('EDUCATION',
                      style: pw.TextStyle(font: ttfBold, fontSize: 10, letterSpacing: 1)),
                  pw.Divider(thickness: 0.5),
                  ...educations.map((edu) {
                    final e = edu is Map<String, dynamic> ? edu : {};
                    return pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 4),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(e['degree'] ?? '',
                              style: pw.TextStyle(font: ttfBold, fontSize: 10)),
                          pw.Text(e['institution'] ?? '',
                              style: pw.TextStyle(font: ttfRegular, fontSize: 9)),
                        ],
                      ),
                    );
                  }),
                ],

                if (skills.isNotEmpty) ...[
                  pw.SizedBox(height: 8),
                  pw.Text('SKILLS',
                      style: pw.TextStyle(font: ttfBold, fontSize: 10, letterSpacing: 1)),
                  pw.SizedBox(height: 4),
                  pw.Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: skills.map((s) {
                      final skill = s is Map<String, dynamic> ? s : {};
                      return pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(width: 0.5),
                          borderRadius: pw.BorderRadius.circular(3),
                        ),
                        child: pw.Text(skill['name'] ?? '',
                            style: pw.TextStyle(font: ttfRegular, fontSize: 8)),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        );

        final pdfBytes = await doc.save();
        mainSendPort.send({
          'reqId': reqId,
          'pdfBytes': pdfBytes,
        });
      } catch (e) {
        final String reqId = message['reqId'] ?? 'unknown';
        mainSendPort.send({
          'reqId': reqId,
          'error': e.toString(),
        });
      }
    });
  }
}
