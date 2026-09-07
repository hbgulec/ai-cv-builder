import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ai_cv_builder/features/template_engine/resume_page_data.dart';
import 'package:ai_cv_builder/features/template_engine/template_registry.dart';
import 'package:ai_cv_builder/features/template_engine/widgets/resume_template_canvas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Uint8List photo;
  setUpAll(() async {
    final recorder = ui.PictureRecorder();
    ui.Canvas(recorder).drawColor(const Color(0xFF2563EB), ui.BlendMode.src);
    final picture = recorder.endRecording();
    final image = await picture.toImage(4, 4);
    photo = (await image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
    image.dispose();
    picture.dispose();
  });
  for (final id in [
    'otago',
    'cambridge',
    'toronto',
    'stanford',
    'monaco',
    'tokyo',
    'berkeley'
  ]) {
    final template = TemplateRegistry.getTemplate(id);
    Map<String, dynamic> data(bool hasPhoto) => {
          'templateId': id,
          'header': {
            'fullName': 'Photo Optional',
            'professionalTitle': 'Developer',
            'email': 'contact@example.com',
          },
          'summary': 'A short professional summary.',
          if (hasPhoto) 'photoBytes': photo,
        };

    testWidgets('$id removes photo, placeholder and photo gap when deselected',
        (tester) async {
      double? photoContactY;
      for (final hasPhoto in [true, false, true, false]) {
        final page = ResumePageData.split(data(hasPhoto)).first;
        await tester.pumpWidget(MaterialApp(
            home: Scaffold(
                body: Center(
          child: ResumeTemplateCanvas(template: template, resumeData: page),
        ))));
        await tester.pump();
        expect(tester.takeException(), isNull, reason: '$id photo=$hasPhoto');
        expect(find.byType(Image), hasPhoto ? findsOneWidget : findsNothing);
        expect(find.byType(ClipOval), hasPhoto ? findsOneWidget : findsNothing);
        expect(find.text('PO'), findsNothing);
        expect(find.byType(Icon), findsNothing);
        final contact = find.textContaining('contact@example.com');
        expect(contact, findsOneWidget);
        final y = tester.getTopLeft(contact).dy;
        if (hasPhoto) {
          photoContactY = y;
        } else if (['otago', 'stanford', 'monaco', 'tokyo', 'berkeley']
            .contains(id)) {
          expect(y, lessThan(photoContactY!),
              reason: 'The removed photo must reclaim vertical space');
        }
      }
      // Picker cards must use the same optional-photo behavior.
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
        body: ResumeTemplateCanvas(
            template: template,
            resumeData: ResumePageData.thumbnail(data(false))),
      )));
      expect(tester.takeException(), isNull);
      expect(find.byType(Image), findsNothing);
      expect(find.text('PO'), findsNothing);
    });

    test('$id exports an image only when a photo is selected', () async {
      for (final hasPhoto in [false, true]) {
        final document = pw.Document(compress: false);
        for (final page in ResumePageData.split(data(hasPhoto))) {
          document.addPage(template.buildPdfPage(
              page, pw.Font.helvetica(), pw.Font.helveticaBold()));
        }
        final bytes = await document.save();
        expect(bytes, isNotEmpty);
        expect(RegExp(r'/Subtype\s*/Image').hasMatch(latin1.decode(bytes)),
            hasPhoto,
            reason: '$id PDF photo=$hasPhoto');
      }
    });
  }
}
