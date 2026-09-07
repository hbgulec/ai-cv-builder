// Hallmark · pre-emit critique: P5 H5 E5 S5 R5 V4
// Hallmark - mobile catalogue - design-system: design.md - designed-as-app
import 'package:ai_cv_builder/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/soft_glass_shell.dart';
import '../../../pdf_export/pdf_exporter.dart';
import '../../../template_engine/domain/entities/template_config.dart';
import '../../../template_engine/resume_page_data.dart';
import '../../../template_engine/template_registry.dart';
import '../../../template_engine/widgets/resume_template_canvas.dart';
import '../../data/services/supabase_resume_sync_service.dart';
import '../providers/resume_provider.dart';
import '../widgets/template_preview_sheet.dart';

/// Hallmark - genre: atmospheric - macrostructure: mobile catalogue
/// design-system: design.md - designed-as-app
class SoftGlassTemplateSelectionScreen extends ConsumerWidget {
  const SoftGlassTemplateSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(resumeEditorProvider);
    final notifier = ref.read(resumeEditorProvider.notifier);
    final locale = ref.watch(localeProvider);
    final allTemplates = TemplateRegistry.getAll();
    final catalogFilter = ref.watch(templateCatalogFilterProvider);
    final templates = switch (catalogFilter) {
      TemplateCatalogFilter.all => allTemplates,
      TemplateCatalogFilter.free => TemplateRegistry.getFreeTemplates(),
      TemplateCatalogFilter.pro => TemplateRegistry.getPremiumTemplates(),
    };
    final selectedId = state.resume.templateId;
    final selected = TemplateRegistry.getTemplate(selectedId);
    final resumeData = state.resume.toJson()
      ..['photoBytes'] = state.photoBytes
      ..['contentLanguage'] = locale.languageCode;
    final thumbnailData = ResumePageData.thumbnail(resumeData);
    final l10n = AppLocalizations.of(context)!;
    const freeCount = TemplateRegistry.freeTemplateCount;
    const proCount = TemplateRegistry.premiumTemplateCount;

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
                    const GlassCard(
                      showShadow: false,
                      blur: 12,
                      borderRadius: 8,
                      padding: EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 6,
                      ),
                      child: Text(
                        '$freeCount FREE · $proCount PRO',
                        style: TextStyle(
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
                        child: const Icon(
                          Icons.layers_outlined,
                          color: AppColors.primaryLight,
                          size: 17,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              locale.languageCode == 'tr'
                                  ? 'Seçili şablon'
                                  : 'Selected template',
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 9,
                              ),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Row(
                  children: [
                    _CatalogFilterChip(
                      label: locale.languageCode == 'tr' ? 'Tümü' : 'All',
                      selected: catalogFilter == TemplateCatalogFilter.all,
                      onTap: () => ref
                          .read(templateCatalogFilterProvider.notifier)
                          .state = TemplateCatalogFilter.all,
                    ),
                    const SizedBox(width: 8),
                    _CatalogFilterChip(
                      label: 'FREE',
                      selected: catalogFilter == TemplateCatalogFilter.free,
                      onTap: () => ref
                          .read(templateCatalogFilterProvider.notifier)
                          .state = TemplateCatalogFilter.free,
                    ),
                    const SizedBox(width: 8),
                    _CatalogFilterChip(
                      label: 'PRO',
                      selected: catalogFilter == TemplateCatalogFilter.pro,
                      onTap: () => ref
                          .read(templateCatalogFilterProvider.notifier)
                          .state = TemplateCatalogFilter.pro,
                    ),
                  ],
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
                    childAspectRatio: 0.657,
                  ),
                  itemCount: templates.length,
                  itemBuilder: (context, index) {
                    final template = templates[index];
                    final isSelected = template.config.id == selectedId;
                    final cardData = Map<String, dynamic>.from(thumbnailData)
                      ..['templateId'] = template.config.id
                      ..['templateColorIndex'] =
                          isSelected ? state.resume.templateColorIndex : 0;
                    return _TemplateCard(
                      template: template,
                      resumeData: cardData,
                      selected: isSelected,
                      onTap: () => _openTemplatePreview(
                        context,
                        ref,
                        notifier,
                        l10n,
                        template,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openTemplatePreview(
    BuildContext context,
    WidgetRef ref,
    ResumeEditorNotifier notifier,
    AppLocalizations l10n,
    BaseResumeTemplate template,
  ) async {
    notifier.setTemplateId(template.config.id);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: .74),
      builder: (sheetContext) => TemplatePreviewSheet(
        template: template,
        onSaveOnly: (modalContext) =>
            _saveOnly(modalContext, ref, notifier, l10n),
        onSaveAndExport: (modalContext, modalResumeData) => _saveAndExport(
          modalContext,
          ref,
          notifier,
          l10n,
          template,
          modalResumeData,
        ),
      ),
    );
  }

  Future<void> _saveOnly(
    BuildContext context,
    WidgetRef ref,
    ResumeEditorNotifier notifier,
    AppLocalizations l10n,
  ) async {
    final result = await _saveResume(ref, notifier);
    if (!context.mounted) return;
    if (result == SaveResult.proRequired) {
      _showProPaywall(context, l10n);
      return;
    }
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
    final result = await _saveResume(ref, notifier);
    if (!context.mounted) return;
    if (result == SaveResult.proRequired) {
      _showProPaywall(context, l10n);
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.cvSavedDownloading)));
    await PdfExporter.savePdf(
      template: template,
      resumeData: resumeData,
      context: context,
    );
    if (context.mounted) context.go('/');
  }

  Future<SaveResult> _saveResume(
    WidgetRef ref,
    ResumeEditorNotifier notifier,
  ) async {
    final result = notifier.saveCurrentResume(
      ref.read(savedResumesProvider.notifier),
      isPro: ref.read(isProUserProvider),
      selectedTemplateIsPremium:
          TemplateRegistry.getTemplate(notifier.currentResume.templateId)
              .config
              .isPremium,
    );
    if (result != SaveResult.success) return result;

    final currentResume = notifier.currentResume;
    final localId = currentResume.id;
    final syncedResume = await ref
        .read(supabaseResumeSyncServiceProvider)
        .saveResume(currentResume);
    if (syncedResume.id != localId) {
      notifier.loadResume(syncedResume);
    }
    return result;
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

class _CatalogFilterChip extends StatelessWidget {
  const _CatalogFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.28)
              : AppColors.glassBackground,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? AppColors.primaryLight : AppColors.glassBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.resumeData,
    required this.selected,
    required this.onTap,
  });

  final BaseResumeTemplate template;
  final Map<String, dynamic> resumeData;
  final bool selected;
  final VoidCallback onTap;

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
                child: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                    border: template.config.isPremium
                        ? Border.all(color: AppColors.warning, width: 1.4)
                        : null,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const ColoredBox(color: Colors.white),
                      FittedBox(
                        fit: BoxFit.contain,
                        alignment: Alignment.topCenter,
                        child: ResumeTemplateCanvas(
                          template: template,
                          resumeData: resumeData,
                        ),
                      ),
                    ],
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
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: .16),
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                        color: AppColors.warning.withValues(alpha: .8),
                      ),
                    ),
                    child: const Text(
                      'PRO',
                      style: TextStyle(
                        color: AppColors.warning,
                        fontSize: 7,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .7,
                      ),
                    ),
                  ),
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
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 11,
                        )
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
