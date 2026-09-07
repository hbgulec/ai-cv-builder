import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:ai_cv_builder/features/template_engine/resume_page_data.dart';
import 'package:ai_cv_builder/features/template_engine/template_registry.dart';
import 'package:ai_cv_builder/features/template_engine/widgets/resume_template_canvas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const recordKeys = [
  'workExperiences',
  'educationList',
  'projects',
  'skills',
  'languages'
];

Map<String, dynamic> screenshotResume(String id, {int scale = 1}) => {
      'templateId': id,
      'contentLanguage': 'tr',
      'header': {
        'fullName': 'Hasan Basri G\u00fcle\u00e7',
        'professionalTitle': 'Mobil uygulama geli\u015ftiricisi',
        'email': 'hasan@example.com',
        'phone': '05304618787',
        'location': 'Konya, T\u00fcrkiye',
      },
      'summary': 'Results-driven developer with hands-on experience at a software '
          'company. Proficient in Flutter, Dart, and scalable applications. Holds '
          'an academic background in computer engineering. Demonstrated ability '
          'to design and deliver high-impact end-to-end projects.',
      'workExperiences': List.generate(
          4 * scale,
          (i) => {
                'id': '6e623256-75e1-4326-9d36-experience-$i',
                'jobTitle': 'Yaz\u0131l\u0131m Geli\u015ftirici $i',
                'company': 'Ak\u0131nsoft',
                'location': 'Konya',
                'startDate': '2026-09-01T00:00:00.000',
                'isCurrent': true,
                'bulletPoints': List.generate(
                    [4, 3, 3, 1][i % 4], (j) => 'Proje geli\u015ftirme $i.$j'),
              }),
      'educationList': List.generate(
          3 * scale,
          (i) => {
                'id': 'education-$i',
                'degree': 'Bilgisayar M\u00fchendisli\u011fi',
                'institution': 'KTO Karatay',
                'startDate': '2022-09-01T00:00:00.000',
                'endDate': '2026-09-01T00:00:00.000',
              }),
      'projects': List.generate(
          4 * scale,
          (i) => {
                'id': 'project-$i',
                'title': 'Mobil Proje $i',
                'description': i % 4 == 3
                    ? 'Mobil uygulama\nBildirimler\nTakvim\nNotlar'
                    : 'Mobil uygulama',
                'url': 'github.com/proje-$i',
                'technologies': ['Flutter'],
              }),
      'skills': ['Flutter', 'Dart', 'Riverpod', 'Git']
          .map((s) => {'id': s, 'name': s})
          .toList(),
      'languages': ['T\u00fcrk\u00e7e', '\u0130ngilizce']
          .map((s) => {'id': s, 'language': s, 'proficiency': ''})
          .toList(),
    };

Map<String, dynamic> copyPage(Map<String, dynamic> page) => {
      ...page,
      for (final key in recordKeys)
        key: List<Map<String, dynamic>>.from(page[key] as List),
    };

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Ahem's square glyphs hide the sparse-page regression. Use the SDK's real
    // Roboto metrics, without network access or a machine-specific font path.
    final config = File('.dart_tool/package_config.json').absolute;
    final packages =
        (jsonDecode(await config.readAsString()) as Map)['packages'] as List;
    final flutter =
        packages.cast<Map>().singleWhere((p) => p['name'] == 'flutter');
    final root = config.uri.resolve('${flutter['rootUri']}/');
    final fonts = root.resolve('../../bin/cache/artifacts/material_fonts/');
    for (final family in ['Roboto', 'serif']) {
      final loader = FontLoader(family);
      for (final weight in ['regular', 'bold', 'italic']) {
        loader.addFont(File.fromUri(fonts.resolve('roboto-$weight.ttf'))
            .readAsBytes()
            .then((bytes) => ByteData.sublistView(bytes)));
      }
      await loader.load();
    }
  });

  Future<List<FlutterErrorDetails>> render(
    WidgetTester tester,
    String id,
    Map<String, dynamic> page,
  ) async {
    // Flutter reports a RenderFlex overflow only once per render object.
    // Use a fresh tree so later candidate pages cannot hide a repeated error.
    await tester.pumpWidget(const SizedBox.shrink());
    final errors = <FlutterErrorDetails>[];
    final previous = FlutterError.onError;
    FlutterError.onError = errors.add;
    try {
      await tester.pumpWidget(MaterialApp(
        // Deliberately hostile UI typography must not change the document.
        theme: ThemeData(
            textTheme: const TextTheme(
                bodyMedium:
                    TextStyle(fontSize: 30, height: 2, letterSpacing: 3))),
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.7)),
          child: Scaffold(
              body: SingleChildScrollView(
                  child: Center(
            child: RepaintBoundary(
                key: const ValueKey('page-image'),
                child: ResumeTemplateCanvas(
                    template: TemplateRegistry.getTemplate(id),
                    resumeData: page)),
          ))),
        ),
      ));
    } finally {
      FlutterError.onError = previous;
    }
    return errors;
  }

  for (final template in TemplateRegistry.getAll()) {
    final id = template.config.id;
    for (final scale in [1, 3]) {
      testWidgets(
          '$id: real-font pages are full, ordered and overflow-free (x$scale)',
          (tester) async {
        final data = screenshotResume(id, scale: scale);
        final pages = ResumePageData.split(data);
        expect(pages.length, greaterThan(1));
        for (final key in recordKeys.take(3)) {
          expect(pages.expand((p) => p[key] as List).map((e) => e['id']),
              (data[key] as List).map((e) => e['id']),
              reason: '$id $key');
        }
        for (var i = 0; i < pages.length; i++) {
          final errors = await render(tester, id, pages[i]);
          expect(errors, isEmpty,
              reason: '$id page ${i + 1}: ${errors.map((e) => e.exception)}');
          if (const bool.fromEnvironment('WRITE_PAGINATION_REVIEW') &&
              scale == 1) {
            await tester.runAsync(() async {
              final boundary = tester.renderObject<RenderRepaintBoundary>(
                  find.byKey(const ValueKey('page-image')));
              final image = await boundary.toImage(pixelRatio: 2);
              final bytes =
                  await image.toByteData(format: ui.ImageByteFormat.png);
              final file = File('build/pagination-review/$id-${i + 1}.png');
              await file.parent.create(recursive: true);
              await file.writeAsBytes(bytes!.buffer.asUint8List());
              image.dispose();
            });
          }
          if (i == pages.length - 1) continue;
          final next = pages[i + 1];
          final key =
              recordKeys.firstWhere((key) => (next[key] as List).isNotEmpty);
          final candidate = copyPage(pages[i]);
          (candidate[key] as List).add((next[key] as List).first);
          final overflow = await render(tester, id, candidate);
          expect(overflow, isNotEmpty,
              reason: '$id page ${i + 1} left space for the next $key record');
          expect(
              overflow
                  .every((e) => e.exceptionAsString().contains('overflowed')),
              isTrue);
        }
      });
    }

    test('$id: invisible metadata cannot change pagination', () {
      final data = screenshotResume(id);
      final before = ResumePageData.split(data);
      for (final key in recordKeys) {
        for (final item in data[key] as List) {
          item['id'] = List.filled(100, 'long-invisible-id').join();
          item['updatedAt'] = List.filled(100, 'metadata').join();
        }
      }
      final after = ResumePageData.split(data);
      expect(after.length, before.length);
      for (var i = 0; i < before.length; i++) {
        for (final key in recordKeys) {
          expect(
              (after[i][key] as List).length, (before[i][key] as List).length);
        }
      }
    });
  }

  testWidgets(
      'long summary and oversized record keep every word and fit every page',
      (tester) async {
    for (final id in ['auckland', 'monaco', 'lisbon', 'executive_pro']) {
      final data = screenshotResume(id);
      data['summary'] = List.generate(900, (i) => 'summary$i').join(' ');
      data['workExperiences'] = [
        {
          'id': 'long-record',
          'jobTitle': 'Developer',
          'company': 'Studio',
          'bulletPoints': List.generate(45,
              (i) => 'Result $i ${List.filled(12, 'achievement').join(' ')}'),
        }
      ];
      final pages = ResumePageData.split(data);
      expect(pages.map((p) => p['summary']).join(), data['summary']);
      final expected =
          ((data['workExperiences'] as List).first['bulletPoints'] as List)
              .join(' ');
      final actual = pages
          .expand((p) => p['workExperiences'] as List)
          .expand((e) => e['bulletPoints'] as List)
          .join(' ');
      String normalize(String s) => s.replaceAll(RegExp(r'\s+'), ' ').trim();
      expect(normalize(actual), normalize(expected));
      for (final page in pages) {
        expect(await render(tester, id, page), isEmpty,
            reason: '$id ${page['_pageIndex']}');
      }
    }
  });

  testWidgets(
      'long sidebar lists flow independently without repeating identity',
      (tester) async {
    for (final id in ['otago', 'berkeley', 'stanford', 'monaco', 'lisbon']) {
      final data = screenshotResume(id, scale: 2);
      data['skills'] = List.generate(
          70, (i) => {'id': 'skill-$i', 'name': 'Development $i'});
      data['languages'] = List.generate(
          30,
          (i) => {
                'id': 'language-$i',
                'language': 'Language $i',
                'proficiency': ''
              });
      final pages = ResumePageData.split(data);
      for (final key in ['skills', 'languages']) {
        final pageKey = id == 'lisbon'
            ? key
            : (key == 'skills' ? '_sidebarSkills' : '_sidebarLanguages');
        expect(pages.expand((p) => p[pageKey] as List).map((e) => e['id']),
            (data[key] as List).map((e) => e['id']),
            reason: '$id $key');
      }
      for (var i = 0; i < pages.length; i++) {
        expect(await render(tester, id, pages[i]), isEmpty,
            reason: '$id page ${i + 1}');
        if (i > 0) {
          expect(find.textContaining('hasan@example.com'), findsNothing);
        }
      }
    }
  });

  testWidgets('unbroken Unicode text is split without dropping characters',
      (tester) async {
    final data = screenshotResume('monaco');
    data['summary'] = List.filled(1500, '\u0131\u015f\u011f\u00fc').join();
    final pages = ResumePageData.split(data);
    expect(pages.map((p) => p['summary']).join(), data['summary']);
    for (final page in pages) {
      expect(await render(tester, 'monaco', page), isEmpty);
    }
  });
}
