// Hallmark - mobile catalogue - design-system: design.md - designed-as-app
import 'package:ai_cv_builder/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/soft_glass_shell.dart';
import '../../../pdf_export/pdf_exporter.dart';
import '../../../template_engine/domain/entities/template_config.dart';
import '../../../template_engine/template_registry.dart';
import '../providers/resume_provider.dart';

/// Hallmark - genre: atmospheric - macrostructure: mobile catalogue
/// design-system: design.md - designed-as-app
class SoftGlassTemplateSelectionScreen extends ConsumerWidget {
  const SoftGlassTemplateSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resumeEditorProvider);
    final notifier = ref.read(resumeEditorProvider.notifier);
    final locale = ref.watch(localeProvider);
    final templates = TemplateRegistry.getAll();
    final selectedId = state.resume.templateId;
    final selected = TemplateRegistry.getTemplate(selectedId);
    final resumeData = state.resume.toJson()
      ..['photoBytes'] = state.photoBytes
      ..['contentLanguage'] = locale.languageCode;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SoftGlassBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 20, 6),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.selectDesign,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            locale.languageCode == 'tr'
                                ? 'Sizi en iyi anlatan tasarımı seçin.'
                                : 'Pick the design that represents you.',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GlassCard(
                      showShadow: false,
                      blur: 12,
                      borderRadius: 8,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 6),
                      child: Text(
                        '${templates.length} ${locale.languageCode == 'tr' ? 'şablon' : 'templates'}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
                child: GlassCard(
                  showShadow: false,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.layers_outlined,
                            color: AppColors.primaryLight, size: 17),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Selected template',
                              style: TextStyle(
                                  color: AppColors.textMuted, fontSize: 9),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              selected.config.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        selected.config.isPremium
                            ? Icons.workspace_premium_outlined
                            : Icons.check_circle_outline_rounded,
                        color: selected.config.isPremium
                            ? AppColors.warning
                            : AppColors.cyan,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.63,
                  ),
                  itemCount: templates.length,
                  itemBuilder: (context, index) {
                    final template = templates[index];
                    return _TemplateCard(
                      template: template,
                      resumeData: resumeData,
                      selected: template.config.id == selectedId,
                      onTap: () => notifier.setTemplateId(template.config.id),
                    );
                  },
                ),
              ),
              GlassCard(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                borderRadius: 14,
                blur: 22,
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: l10n.saveOnly,
                        icon: Icons.download_outlined,
                        isSecondary: true,
                        compact: true,
                        onPressed: () =>
                            _saveOnly(context, ref, notifier, l10n),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: AppButton(
                        text: l10n.saveAndPdf,
                        icon: Icons.picture_as_pdf_outlined,
                        compact: true,
                        onPressed: () => _saveAndExport(
                          context,
                          ref,
                          notifier,
                          l10n,
                          selected,
                          resumeData,
                        ),
                      ),
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

  void _saveOnly(
    BuildContext context,
    WidgetRef ref,
    ResumeEditorNotifier notifier,
    AppLocalizations l10n,
  ) {
    final result = notifier.saveCurrentResume(
      ref.read(savedResumesProvider.notifier),
      isPro: ref.read(isProUserProvider),
    );
    if (result == SaveResult.proRequired) {
      _showProPaywall(context, l10n);
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.cvSavedSuccess)));
    context.go('/');
  }

  Future<void> _saveAndExport(
    BuildContext context,
    WidgetRef ref,
    ResumeEditorNotifier notifier,
    AppLocalizations l10n,
    BaseResumeTemplate template,
    Map<String, dynamic> resumeData,
  ) async {
    final result = notifier.saveCurrentResume(
      ref.read(savedResumesProvider.notifier),
      isPro: ref.read(isProUserProvider),
    );
    if (result == SaveResult.proRequired) {
      _showProPaywall(context, l10n);
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.cvSavedDownloading)));
    await PdfExporter.savePdf(
        template: template, resumeData: resumeData, context: context);
    if (context.mounted) context.go('/');
  }

  void _showProPaywall(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: Text(l10n.proRequired),
        content: Text(l10n.proRequiredMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.maybeLater),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.upgradeToPro),
          ),
        ],
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final BaseResumeTemplate template;
  final Map<String, dynamic> resumeData;
  final bool selected;
  final VoidCallback onTap;

  const _TemplateCard({
    required this.template,
    required this.resumeData,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      scale: selected ? 1 : 0.985,
      child: GlassCard(
        selected: selected,
        showShadow: selected,
        padding: const EdgeInsets.all(8),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: ColoredBox(
                  color: Colors.white,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 380,
                      height: 540,
                      child: template.buildPreview(resumeData),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    template.config.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (template.config.isPremium)
                  const Icon(Icons.diamond_outlined,
                      color: AppColors.warning, size: 13),
                const SizedBox(width: 5),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 17,
                  height: 17,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: selected
                          ? AppColors.primaryLight
                          : AppColors.glassBorder,
                    ),
                  ),
                  child: selected
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 11)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
