import 'package:ai_cv_builder/features/resume_builder/domain/entities/resume_entity.dart';
import 'package:ai_cv_builder/features/resume_builder/presentation/providers/resume_provider.dart';
import 'package:ai_cv_builder/features/template_engine/template_registry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('template catalogue contains ten free and six PRO templates', () {
    expect(TemplateRegistry.getAll(), hasLength(16));
    expect(TemplateRegistry.getFreeTemplates(),
        hasLength(TemplateRegistry.freeTemplateCount));
    expect(TemplateRegistry.getPremiumTemplates(),
        hasLength(TemplateRegistry.premiumTemplateCount));
    expect(
      TemplateRegistry.getPremiumTemplates()
          .map((template) => template.config.id),
      containsAll(<String>[
        'harvard',
        'stanford',
        'oxford',
        'executive_pro',
        'monaco',
        'tokyo',
      ]),
    );
  });

  test('a free user cannot save a PRO template', () {
    final resume = ResumeEntity(
      id: 'b4efbc99-4c58-431a-b2e8-722dbabdb5b0',
      title: 'Product Manager CV',
      header: const HeaderInfo(fullName: 'Alex Morgan'),
      createdAt: DateTime(2026, 8, 23),
      updatedAt: DateTime(2026, 8, 23),
      templateId: 'harvard',
    );
    final notifier = ResumeEditorNotifier(resume);
    final saved = StateController<List<ResumeEntity>>(<ResumeEntity>[]);
    addTearDown(saved.dispose);

    final result = notifier.saveCurrentResume(
      saved,
      isPro: false,
      selectedTemplateIsPremium: true,
    );

    expect(result, SaveResult.proRequired);
    expect(saved.state, isEmpty);
  });
}
