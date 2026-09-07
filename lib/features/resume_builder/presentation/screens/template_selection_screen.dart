import 'package:flutter/material.dart';
import 'package:ai_cv_builder/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../pdf_export/pdf_exporter.dart';
import '../../../template_engine/domain/entities/template_config.dart';
import '../../../template_engine/template_registry.dart';
import '../../../template_engine/widgets/resume_template_canvas.dart';
import '../providers/resume_provider.dart';

class TemplateSelectionScreen extends ConsumerWidget {
  const TemplateSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final editorState = ref.watch(resumeEditorProvider);
    final notifier = ref.read(resumeEditorProvider.notifier);
    final activeLocale = ref.watch(localeProvider);
    final templates = TemplateRegistry.getAll();
    final selectedTemplateId = editorState.resume.templateId;
    final resumeData = editorState.resume.toJson();
    resumeData['photoBytes'] = editorState.photoBytes;
    resumeData['contentLanguage'] = activeLocale.languageCode;
    final selectedTemplate = TemplateRegistry.getTemplate(selectedTemplateId);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: DecoratedBox(
        decoration:
            const BoxDecoration(gradient: AppColors.darkBackgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: AppColors.textPrimary),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.selectDesign,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary)),
                          Text(l10n.standardizedTemplates,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.glassBackground,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Text(
                          selectedTemplate.config.isPremium ? 'PRO' : 'FREE',
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GlassCard(
                  borderRadius: 22,
                  blur: 16,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Soft Glass Mobile',
                                style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    height: 1.05)),
                            const SizedBox(height: 8),
                            Text(l10n.selectDesign,
                                style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                    height: 1.4)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              width: 2),
                        ),
                        child: Center(
                          child: Text(
                              '${selectedTemplate.config.isPremium ? 1 : 0}',
                              style: const TextStyle(
                                  color: AppColors.primaryLight,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 22)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  itemCount: templates.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final template = templates[index];
                    final isSelected = template.config.id == selectedTemplateId;
                    return _TemplateTile(
                      template: template,
                      isSelected: isSelected,
                      resumeData: resumeData,
                      onSelect: () =>
                          notifier.setTemplateId(template.config.id),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                decoration: const BoxDecoration(
                  color: AppColors.glassBackground,
                  border: Border(top: BorderSide(color: AppColors.glassBorder)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Selected',
                            style: TextStyle(
                                color: AppColors.textMuted, fontSize: 11)),
                        Text(selectedTemplate.config.name,
                            style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              final isPro = ref.read(isProUserProvider);
                              final result = notifier.saveCurrentResume(
                                  ref.read(savedResumesProvider.notifier),
                                  isPro: isPro,
                                  selectedTemplateIsPremium:
                                      selectedTemplate.config.isPremium);
                              if (result == SaveResult.proRequired) {
                                _showProPaywall(context, l10n);
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.cvSavedSuccess)));
                              context.go('/');
                            },
                            child: Text(l10n.saveOnly),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              final isPro = ref.read(isProUserProvider);
                              final result = notifier.saveCurrentResume(
                                  ref.read(savedResumesProvider.notifier),
                                  isPro: isPro,
                                  selectedTemplateIsPremium:
                                      selectedTemplate.config.isPremium);
                              if (result == SaveResult.proRequired) {
                                _showProPaywall(context, l10n);
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(l10n.cvSavedDownloading)));
                              await PdfExporter.savePdf(
                                  template: selectedTemplate,
                                  resumeData: resumeData,
                                  context: context);
                              if (context.mounted) context.go('/');
                            },
                            child: Text(l10n.saveAndPdf),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showProPaywall(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: Text(l10n.proRequired,
            style: const TextStyle(color: AppColors.textPrimary)),
        content: Text(l10n.proRequiredMessage,
            style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.maybeLater)),
          ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.upgradeToPro)),
        ],
      ),
    );
  }
}

class _TemplateTile extends StatelessWidget {
  final BaseResumeTemplate template;
  final bool isSelected;
  final Map<String, dynamic> resumeData;
  final VoidCallback onSelect;

  const _TemplateTile(
      {required this.template,
      required this.isSelected,
      required this.resumeData,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final config = template.config;
    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: AppColors.glassBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color:
                  isSelected ? AppColors.primaryLight : AppColors.glassBorder,
              width: isSelected ? 1.4 : 1),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(config.name,
                      style: TextStyle(
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                ),
                if (config.isPremium)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999)),
                    child: const Text('PRO',
                        style: TextStyle(
                            color: AppColors.primaryLight,
                            fontSize: 9,
                            fontWeight: FontWeight.w800)),
                  ),
                if (isSelected) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.check_circle_rounded,
                      color: AppColors.primaryLight, size: 18),
                ],
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                color: Colors.white,
                child: AspectRatio(
                  aspectRatio: 1 / 1.38,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    alignment: Alignment.topCenter,
                    child: ResumeTemplateCanvas(
                      template: template,
                      resumeData: resumeData,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
