import 'dart:convert';

import 'package:ai_cv_builder/core/providers/locale_provider.dart';
import 'package:ai_cv_builder/features/resume_builder/domain/entities/resume_entity.dart';
import 'package:ai_cv_builder/features/resume_builder/presentation/providers/resume_provider.dart';
import 'package:ai_cv_builder/features/resume_builder/presentation/screens/resume_editor_screen.dart';
import 'package:ai_cv_builder/features/resume_builder/presentation/screens/resume_view_screen.dart';
import 'package:ai_cv_builder/features/resume_builder/presentation/widgets/template_preview_sheet.dart';
import 'package:ai_cv_builder/features/template_engine/resume_page_data.dart';
import 'package:ai_cv_builder/features/template_engine/template_registry.dart';
import 'package:ai_cv_builder/features/template_engine/widgets/resume_template_canvas.dart';
import 'package:ai_cv_builder/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  final resume = ResumeEntity(
    id: 'b4efbc99-4c58-431a-b2e8-722dbabdb5b0',
    title: 'Detailed CV',
    header: const HeaderInfo(
      fullName: 'Identity Anchor',
      professionalTitle: 'Mobile Architect',
      email: 'identity@example.com',
      phone: '+90 555 000 00 00',
      location: 'Istanbul',
      linkedinUrl: 'linkedin.com/in/identity',
      githubUrl: 'github.com/identity',
      portfolioUrl: 'identity.dev',
    ),
    summary: 'A focused professional summary for a mobile preview.',
    workExperiences: [
      WorkExperience(
        id: 'experience-1',
        jobTitle: 'Architect',
        company: 'Studio',
        location: 'Ankara',
        startDate: DateTime(2024, 1),
        isCurrent: true,
        bulletPoints: const ['Outcome marker 42 improved reliability.'],
      ),
    ],
    educationList: [
      Education(
        id: 'education-1',
        degree: 'Architecture',
        institution: 'University',
        location: 'Izmir',
        startDate: DateTime(2020, 9),
        endDate: DateTime(2024, 6),
        highlights: const ['Graduated with distinction.'],
      ),
    ],
    projects: const [
      Project(
        id: 'project-1',
        title: 'Portfolio',
        description: 'Residential design project.',
        url: 'github.com/identity/portfolio',
        technologies: ['RiverpodX'],
      ),
    ],
    skills: const [
      Skill(id: 'skill-1', name: 'AutoCAD'),
      Skill(id: 'skill-2', name: 'Design'),
    ],
    languages: const [
      LanguageProficiency(
        id: 'language-1',
        language: 'Turkish',
        proficiency: 'Native',
      ),
    ],
    createdAt: DateTime(2026, 8, 23),
    updatedAt: DateTime(2026, 8, 23),
    templateId: 'edinburgh',
  );

  Map<String, dynamic> denseResumeData(
    String templateId, {
    int experienceCount = 3,
    int educationCount = 2,
    int projectCount = 3,
  }) {
    final data = resume
        .copyWith(
          templateId: templateId,
          contentLanguage: 'tr',
          header: resume.header.copyWith(
            fullName: 'Hasan Basri Güleç',
            professionalTitle: 'Mobil uygulama geliştiricisi',
          ),
        )
        .toJson();
    data['summary'] =
        'Son derece motivasyonlu, mobil uygulama geliştiricisi olarak '
        'kariyerine devam eden bir profesyonelim. Özellikle ölçeklenebilir '
        'ürünler geliştirme, teknik çalışmalara yatkınlık ve projelere değer '
        'katma konularında deneyim sahibiyim.';
    data['workExperiences'] = List.generate(
      experienceCount,
      (index) => {
        'id': 'experience-$index',
        'jobTitle': 'Yazılım Geliştirici',
        'company': 'AWEF',
        'location': 'Konya',
        'startDate': '2026-08-01T00:00:00.000',
        'isCurrent': true,
        'bulletPoints': ['AWEFAWEF'],
      },
    );
    data['educationList'] = List.generate(
      educationCount,
      (index) => {
        'id': 'education-$index',
        'degree': 'Bilgisayar Mühendisliği',
        'institution': 'AWEFAWEF Üniversitesi',
        'startDate': '2022-08-01T00:00:00.000',
        'endDate': '2026-08-01T00:00:00.000',
      },
    );
    data['projects'] = List.generate(
      projectCount,
      (index) => {
        'id': 'project-$index',
        'title': 'Proje $index',
        'description': 'Mobil uygulama projesi',
        'url': 'github.com/example',
        'technologies': ['Flutter'],
      },
    );
    data['skills'] = [
      {'id': 'skill-1', 'name': 'Flutter'},
      {'id': 'skill-2', 'name': 'Dart'},
      {'id': 'skill-3', 'name': 'Riverpod'},
    ];
    data['languages'] = [
      {'id': 'language-1', 'language': 'Türkçe', 'proficiency': ''},
      {'id': 'language-2', 'language': 'İngilizce', 'proficiency': ''},
    ];
    return data;
  }

  testWidgets('Turkish locale translates editor sections and preview actions',
      (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 900);
    container.read(localeProvider.notifier).state = const Locale('tr');

    Widget localizedApp(Widget home) => UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: const Locale('tr'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: home,
          ),
        );

    await tester.pumpWidget(localizedApp(const ResumeEditorScreen()));
    await tester.pump();
    for (final field in tester.widgetList<TextField>(find.byType(TextField))) {
      expect(field.hintLocales, const [Locale('tr')]);
    }
    final notifier = container.read(resumeEditorProvider.notifier);
    notifier.addWorkExperience(
      const WorkExperience(
        id: 'localized-experience',
        jobTitle: '',
        company: '',
      ),
    );
    notifier.addEducation(
      const Education(
        id: 'localized-education',
        degree: '',
        institution: '',
      ),
    );
    notifier.addProject(
      const Project(
        id: 'localized-project',
        title: '',
        description: '',
      ),
    );
    await tester.pump();

    for (final english in [
      'Experience',
      'Education',
      'Skills',
      'Summary',
      'Skill',
      'Add skill',
      'Save',
      'Delete',
    ]) {
      expect(
        find.text(english, skipOffstage: false),
        findsNothing,
        reason: english,
      );
    }
    for (final turkish in [
      'Deneyim',
      'Eğitim',
      'Yetenekler',
      'Özet',
      'Kaydet',
      'Sil',
    ]) {
      expect(
        find.text(turkish, skipOffstage: false),
        findsWidgets,
        reason: turkish,
      );
    }

    await tester.pumpWidget(
      localizedApp(const ResumeViewScreen(resumeId: 'active-resume')),
    );
    await tester.pump();

    expect(find.text('Edit', skipOffstage: false), findsNothing);
    expect(find.text('Düzenle', skipOffstage: false), findsOneWidget);
  });

  testWidgets(
      'saved experience, education and project cards stay collapsed after step changes',
      (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(430, 900);
    container.read(savedResumesProvider.notifier).state = [resume];

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ResumeEditorScreen(resumeId: resume.id),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final notifier = container.read(resumeEditorProvider.notifier);

    bool hasVisibleField(String value) => tester
        .widgetList<TextField>(find.byType(TextField))
        .any((field) => field.controller?.text == value);

    for (final section in <(int, String)>[
      (1, 'Architect'),
      (2, 'Architecture'),
      (5, 'Portfolio'),
    ]) {
      notifier.updateStep(section.$1);
      await tester.pumpAndSettle();
      expect(hasVisibleField(section.$2), isFalse,
          reason: 'Saved ${section.$2} card should start collapsed');

      await tester.tap(find.text(section.$2));
      await tester.pumpAndSettle();
      expect(hasVisibleField(section.$2), isTrue);

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(hasVisibleField(section.$2), isFalse);

      notifier.updateStep(section.$1 == 1 ? 2 : 1);
      await tester.pumpAndSettle();
      notifier.updateStep(section.$1);
      await tester.pumpAndSettle();
      expect(hasVisibleField(section.$2), isFalse,
          reason: 'Saved ${section.$2} card reopened after returning');
    }

    for (final section in <int>[1, 2, 5]) {
      notifier.updateStep(section);
      switch (section) {
        case 1:
          notifier.addWorkExperience(
            const WorkExperience(
              id: 'new-experience',
              jobTitle: '',
              company: '',
            ),
          );
        case 2:
          notifier.addEducation(
            const Education(
              id: 'new-education',
              degree: '',
              institution: '',
            ),
          );
        case 5:
          notifier.addProject(
            const Project(
              id: 'new-project',
              title: '',
              description: '',
            ),
          );
      }
      await tester.pumpAndSettle();
      expect(find.widgetWithText(ElevatedButton, 'Save'), findsOneWidget,
          reason: 'A new card in step $section should start expanded');
    }
  });

  test('catalogue exposes 10 free and 6 premium templates', () {
    expect(TemplateRegistry.getAll(), hasLength(16));
    expect(TemplateRegistry.getFreeTemplates(), hasLength(10));
    expect(TemplateRegistry.getPremiumTemplates(), hasLength(6));
  });

  test('every template exposes five distinct color choices', () {
    for (final template in TemplateRegistry.getAll()) {
      final colors = template.config.colorOptions;
      expect(colors, hasLength(5), reason: template.config.name);
      expect(
        colors.map((color) => color.toARGB32()).toSet(),
        hasLength(5),
        reason: template.config.name,
      );
    }
  });

  test('template color survives JSON persistence', () {
    final encoded = jsonDecode(
      jsonEncode(resume.copyWith(templateColorIndex: 4).toJson()),
    ) as Map<String, dynamic>;
    final restored = ResumeEntity.fromJson(encoded);

    expect(restored.templateColorIndex, 4);
  });

  test('Turkish characters survive JSON persistence', () {
    final turkishResume = resume.copyWith(
      header: resume.header.copyWith(
        professionalTitle: 'Yazılım Mühendisi',
        location: 'İstanbul, Türkiye',
      ),
      summary: 'Ölçeklenebilir ürünler geliştiriyorum.',
    );
    final encoded = jsonDecode(
      jsonEncode(turkishResume.toJson()),
    ) as Map<String, dynamic>;
    final restored = ResumeEntity.fromJson(encoded);

    expect(restored.header.professionalTitle, 'Yazılım Mühendisi');
    expect(restored.header.location, 'İstanbul, Türkiye');
    expect(restored.summary, 'Ölçeklenebilir ürünler geliştiriyorum.');
  });

  test('languages without a selected level stay level-free', () {
    const language = LanguageProficiency(
      id: 'language-no-level',
      language: 'Türkçe',
    );
    expect(language.proficiency, isEmpty);

    final data = resume.copyWith(
      templateId: 'edinburgh',
      languages: const [language],
    ).toJson();
    final languageData = ResumePageData.split(data)
        .expand((page) => page['languages'] as List)
        .single as Map<String, dynamic>;
    expect(languageData['proficiency'], isEmpty);

    final legacyData = resume.copyWith(templateId: 'edinburgh').toJson();
    legacyData['languages'] = [
      {
        'id': 'legacy-language',
        'language': 'English',
        'proficiency': 'Intermediate',
      },
    ];
    final legacyLanguage = ResumePageData.split(legacyData)
        .expand((page) => page['languages'] as List)
        .single as Map<String, dynamic>;
    expect(legacyLanguage['proficiency'], isEmpty);
  });

  testWidgets('all templates render every entered detail without overflow',
      (tester) async {
    for (final template in TemplateRegistry.getAll()) {
      for (var colorIndex = 0; colorIndex < 5; colorIndex++) {
        final data = resume
            .copyWith(
              templateId: template.config.id,
              templateColorIndex: colorIndex,
            )
            .toJson();
        final pages = ResumePageData.split(data);
        var sawCity = false;
        var sawAchievement = false;
        var sawProjectLink = false;
        var sawTechnology = false;
        var sawLanguage = false;

        for (final page in pages) {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SizedBox(
                  width: 340,
                  height: 480,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    alignment: Alignment.topCenter,
                    child: ResumeTemplateCanvas(
                      template: template,
                      resumeData: page,
                    ),
                  ),
                ),
              ),
            ),
          );

          expect(tester.takeException(), isNull, reason: template.config.name);
          sawCity =
              sawCity || find.textContaining('Ankara').evaluate().isNotEmpty;
          sawAchievement = sawAchievement ||
              find.textContaining('Outcome marker 42').evaluate().isNotEmpty;
          sawProjectLink = sawProjectLink ||
              find
                  .textContaining('github.com/identity/portfolio')
                  .evaluate()
                  .isNotEmpty;
          sawTechnology = sawTechnology ||
              find.textContaining('RiverpodX').evaluate().isNotEmpty;
          sawLanguage = sawLanguage ||
              find.textContaining('Turkish').evaluate().isNotEmpty;
        }

        expect(sawCity, isTrue, reason: template.config.name);
        expect(sawAchievement, isTrue, reason: template.config.name);
        expect(sawProjectLink, isTrue, reason: template.config.name);
        expect(sawTechnology, isTrue, reason: template.config.name);
        expect(sawLanguage, isTrue, reason: template.config.name);
      }
    }
  });

  test('all templates and colors generate PDF output', () async {
    final document = pw.Document();
    final regular = pw.Font.helvetica();
    final bold = pw.Font.helveticaBold();

    for (final template in TemplateRegistry.getAll()) {
      for (var colorIndex = 0; colorIndex < 5; colorIndex++) {
        final data = resume
            .copyWith(
              templateId: template.config.id,
              templateColorIndex: colorIndex,
            )
            .toJson();
        for (final pageData in ResumePageData.split(data)) {
          document.addPage(
            template.buildPdfPage(pageData, regular, bold),
          );
        }
      }
    }

    final bytes = await document.save();
    expect(bytes, isNotEmpty);
  });

  test('pagination preserves order and never duplicates an entity', () {
    final data = resume.toJson();
    data['summary'] = List.filled(120, 'Detailed').join(' ');
    data['workExperiences'] = List.generate(
      9,
      (index) => {
        'id': 'experience-$index',
        'jobTitle': 'Role $index',
        'company': 'Company $index',
        'location': 'City $index',
        'bulletPoints': List.generate(3, (bullet) => 'Result $bullet'),
      },
    );
    data['educationList'] = List.generate(
      3,
      (index) => {
        'id': 'education-$index',
        'degree': 'Degree $index',
        'institution': 'School $index',
      },
    );
    data['projects'] = List.generate(
      4,
      (index) => {
        'id': 'project-$index',
        'title': 'Project $index',
        'description': 'Description $index',
      },
    );

    final pages = ResumePageData.split(data);

    expect(pages.length, greaterThan(1));
    expect(pages.first['_isFirstPage'], isTrue);
    for (final page in pages.skip(1)) {
      expect(page['_isFirstPage'], isFalse);
    }

    for (final key in ['workExperiences', 'educationList', 'projects']) {
      final ids = pages
          .expand((page) => page[key] as List)
          .map((item) => (item as Map)['id'])
          .toList();
      expect(ids.toSet(), hasLength(ids.length), reason: key);
    }

    final orderedRoles = pages
        .expand((page) => page['workExperiences'] as List)
        .map((item) => (item as Map)['jobTitle'])
        .toList();
    expect(
      orderedRoles,
      List.generate(9, (index) => 'Role $index'),
    );
  });

  testWidgets('Monaco continues linearly without duplicate content',
      (tester) async {
    final data = resume.copyWith(templateId: 'monaco').toJson();
    data['summary'] =
        'Results-driven mobile developer with hands-on experience building '
        'scalable Flutter applications and reliable end-to-end products.';
    data['workExperiences'] = List.generate(
      3,
      (index) => {
        'id': 'experience-$index',
        'jobTitle': 'Yazılımcı',
        'company': 'Akınsoft',
        'location': 'Konya',
        'bulletPoints': [
          'Designed and supported a production feature.',
        ],
      },
    );
    data['educationList'] = List.generate(
      3,
      (index) => {
        'id': 'education-$index',
        'degree': 'Bilgisayar Mühendisliği',
        'institution': 'KTO Karatay',
        'location': 'Konya',
      },
    );
    data['projects'] = List.generate(
      3,
      (index) => {
        'id': 'project-$index',
        'title': 'Project $index',
        'description': 'Production-ready mobile application.',
        'url': 'github.com/example/project-$index',
        'technologies': ['Flutter'],
      },
    );

    final pages = ResumePageData.split(data);

    expect(pages.length, lessThanOrEqualTo(2));
    expect(
      pages.expand((page) => page['workExperiences'] as List),
      hasLength(3),
    );
    expect(
      pages.expand((page) => page['educationList'] as List),
      hasLength(3),
    );
    expect(
      pages.expand((page) => page['projects'] as List),
      hasLength(3),
    );

    for (final page in pages) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: ResumeTemplateCanvas(
                template: TemplateRegistry.getTemplate('monaco'),
                resumeData: page,
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Executive Pro uses at most two overflow-free pages',
      (tester) async {
    final data = denseResumeData('executive_pro');
    final pages = ResumePageData.split(data);

    expect(pages.length, lessThanOrEqualTo(2));
    expect(pages.first['workExperiences'], hasLength(3));
    expect(
      pages.expand((page) => page['educationList'] as List),
      hasLength(2),
    );
    expect(
      pages.expand((page) => page['projects'] as List),
      hasLength(3),
    );

    for (final page in pages) {
      await tester.pumpWidget(
        MaterialApp(
          home: SingleChildScrollView(
            child: Center(
              child: ResumeTemplateCanvas(
                template: TemplateRegistry.getTemplate('executive_pro'),
                resumeData: page,
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(ResumeTemplateCanvas)).height,
        ResumeTemplateCanvas.logicalHeight,
      );
    }

    final document = pw.Document();
    final template = TemplateRegistry.getTemplate('executive_pro');
    for (final page in pages) {
      document.addPage(
        template.buildPdfPage(
          page,
          pw.Font.helvetica(),
          pw.Font.helveticaBold(),
        ),
      );
    }
    expect(await document.save(), isNotEmpty);
  });

  test('dense resumes preserve every section in linear order', () {
    for (final template in TemplateRegistry.getAll()) {
      final pages = ResumePageData.split(
        denseResumeData(
          template.config.id,
          experienceCount: 7,
          educationCount: 4,
          projectCount: 5,
        ),
      );

      expect(pages.length, greaterThan(1), reason: template.config.name);
      expect(
        pages
            .expand((page) => page['workExperiences'] as List)
            .map((item) => (item as Map)['id']),
        List.generate(7, (index) => 'experience-$index'),
        reason: template.config.name,
      );
      expect(
        pages
            .expand((page) => page['educationList'] as List)
            .map((item) => (item as Map)['id']),
        List.generate(4, (index) => 'education-$index'),
        reason: template.config.name,
      );
      expect(
        pages
            .expand((page) => page['projects'] as List)
            .map((item) => (item as Map)['id']),
        List.generate(5, (index) => 'project-$index'),
        reason: template.config.name,
      );
    }
  });

  for (final template in TemplateRegistry.getAll()) {
    testWidgets('${template.config.id} dense pages stay within the A4 canvas',
        (tester) async {
      final pages = ResumePageData.split(
        denseResumeData(
          template.config.id,
          experienceCount: 7,
          educationCount: 4,
          projectCount: 5,
        ),
      );

      for (var pageIndex = 0; pageIndex < pages.length; pageIndex++) {
        final page = pages[pageIndex];
        await tester.pumpWidget(
          MaterialApp(
            home: SingleChildScrollView(
              child: Center(
                child: ResumeTemplateCanvas(
                  template: template,
                  resumeData: page,
                ),
              ),
            ),
          ),
        );

        expect(
          tester.takeException(),
          isNull,
          reason: '${template.config.name} page ${pageIndex + 1}',
        );
        expect(
          tester.getSize(find.byType(ResumeTemplateCanvas)).height,
          ResumeTemplateCanvas.logicalHeight,
          reason: template.config.name,
        );
      }
    });
  }

  for (final template in TemplateRegistry.getAll()) {
    testWidgets(
        '${template.config.id} user-density resume fits at most two pages',
        (tester) async {
      final data = denseResumeData(
        template.config.id,
        experienceCount: 3,
        educationCount: 3,
        projectCount: 3,
      );
      final pages = ResumePageData.split(data);

      expect(pages.length, lessThanOrEqualTo(2));
      expect(
        pages.expand((page) => page['workExperiences'] as List),
        hasLength(3),
      );
      expect(
        pages.expand((page) => page['educationList'] as List),
        hasLength(3),
      );
      expect(
        pages.expand((page) => page['projects'] as List),
        hasLength(3),
      );
      if ({'otago', 'berkeley', 'stanford', 'monaco'}
          .contains(template.config.id)) {
        expect(pages.first['_sidebarSkills'], hasLength(3));
        expect(pages.first['_sidebarLanguages'], hasLength(2));
      } else {
        expect(
          pages.expand((page) => page['skills'] as List),
          hasLength(3),
        );
        expect(
          pages.expand((page) => page['languages'] as List),
          hasLength(2),
        );
      }
      for (var pageIndex = 0; pageIndex < pages.length; pageIndex++) {
        final page = pages[pageIndex];
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 340,
                height: 480,
                child: FittedBox(
                  fit: BoxFit.contain,
                  alignment: Alignment.topCenter,
                  child: ResumeTemplateCanvas(
                    template: template,
                    resumeData: page,
                  ),
                ),
              ),
            ),
          ),
        );
        expect(
          tester.takeException(),
          isNull,
          reason: '${template.config.id} page ${pageIndex + 1}',
        );
      }
    });
  }

  testWidgets('continuation pages never repeat identity or sidebar details',
      (tester) async {
    const sidebarIds = {'otago', 'berkeley', 'stanford', 'monaco'};

    for (final template in TemplateRegistry.getAll()) {
      final data = resume.copyWith(templateId: template.config.id).toJson();
      data['workExperiences'] = List.generate(
        10,
        (index) => {
          'id': 'experience-$index',
          'jobTitle': 'Role $index',
          'company': 'Company $index',
          'bulletPoints': List.generate(3, (bullet) => 'Result $bullet'),
        },
      );
      data['skills'] = [
        {'id': 'skill-sidebar', 'name': 'SIDEBAR_UNIQUE'},
      ];
      final pages = ResumePageData.split(data);
      expect(pages.length, greaterThan(1), reason: template.config.name);

      for (final page in pages.skip(1)) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 340,
                height: 480,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: ResumeTemplateCanvas(
                    template: template,
                    resumeData: page,
                  ),
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull, reason: template.config.name);
        expect(
          find.text('Identity Anchor'),
          findsNothing,
          reason: template.config.name,
        );
        expect(
          find.textContaining('identity@example.com'),
          findsNothing,
          reason: template.config.name,
        );
        if (sidebarIds.contains(template.config.id)) {
          expect(
            find.textContaining('SIDEBAR_UNIQUE'),
            findsNothing,
            reason: template.config.name,
          );
        }
      }
    }
  });

  testWidgets('color swatches update the active resume instantly',
      (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final template = TemplateRegistry.getTemplate('auckland');
    container
        .read(resumeEditorProvider.notifier)
        .loadResume(resume.copyWith(templateId: 'auckland'));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: TemplatePreviewSheet(
              template: template,
              onSaveOnly: (_) async {},
              onSaveAndExport: (_, __) async {},
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.bySemanticsLabel('Color option 5'));
    await tester.pump();

    expect(
      container.read(resumeEditorProvider).resume.templateColorIndex,
      4,
    );
  });

  testWidgets('template preview is stable at supported mobile widths',
      (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final template = TemplateRegistry.getTemplate('otago');
    container
        .read(resumeEditorProvider.notifier)
        .loadResume(resume.copyWith(templateId: 'otago'));

    for (final width in <double>[320, 375, 414, 768]) {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = Size(width, 800);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Scaffold(
              body: TemplatePreviewSheet(
                template: template,
                onSaveOnly: (_) async {},
                onSaveAndExport: (_, __) async {},
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull, reason: '$width px');
      expect(find.text('Save only'), findsOneWidget);
      expect(find.text('Save & download PDF'), findsOneWidget);
    }
  });
  testWidgets('photo-enabled identity areas render the selected image',
      (tester) async {
    final photoBytes = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIHWP4z8DwHwAFgAI/ScLKKgAAAABJRU5ErkJggg==',
    );

    for (final templateId in ['cambridge', 'toronto', 'tokyo']) {
      final data = resume.copyWith(templateId: templateId).toJson();
      data['photoBytes'] = photoBytes;
      final template = TemplateRegistry.getTemplate(templateId);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResumeTemplateCanvas(
              template: template,
              resumeData: ResumePageData.split(data).first,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(tester.takeException(), isNull, reason: templateId);
      expect(find.byType(Image), findsAtLeastNWidgets(1), reason: templateId);
    }
  });

  testWidgets('Turkish resume content is preserved without casing loss',
      (tester) async {
    final data = resume
        .copyWith(
          templateId: 'monaco',
          header: resume.header.copyWith(
            professionalTitle: 'Yazılım Mühendisi',
            location: 'İstanbul, Türkiye',
          ),
          summary: 'Öğrenme odaklı, ölçeklenebilir ürünler geliştiriyorum.',
        )
        .toJson();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResumeTemplateCanvas(
            template: TemplateRegistry.getTemplate('monaco'),
            resumeData: ResumePageData.split(data).first,
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Yazılım Mühendisi'), findsOneWidget);
    expect(find.textContaining('İstanbul, Türkiye'), findsOneWidget);
    final fontFallback = tester.widget<DefaultTextStyle>(
      find.byKey(const ValueKey('resume-unicode-font-fallback')),
    );
    expect(fontFallback.style.fontFamily, 'Roboto');
    expect(fontFallback.style.fontFamilyFallback, contains('Noto Sans'));
  });
}
