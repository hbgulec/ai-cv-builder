import 'package:flutter/material.dart';
import 'package:ai_cv_builder/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/soft_glass_shell.dart';
import '../../../pdf_export/pdf_exporter.dart';
import '../../../template_engine/template_registry.dart';
import '../../../template_engine/domain/entities/template_config.dart';
import '../../../template_engine/resume_page_data.dart';
import '../../../template_engine/widgets/resume_template_canvas.dart';
import '../../data/services/supabase_resume_sync_service.dart';
import '../../domain/entities/resume_entity.dart';
import '../providers/resume_provider.dart';
import '../widgets/resume_version_history_sheet.dart';

class ResumeViewScreen extends ConsumerWidget {
  final String resumeId;

  const ResumeViewScreen({super.key, required this.resumeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeLocale = ref.watch(localeProvider);
    final resumes = ref.watch(savedResumesProvider);
    final resume = resumes.firstWhere(
      (r) => r.id == resumeId,
      orElse: () => ref.watch(resumeEditorProvider).resume,
    );
    final template = TemplateRegistry.getTemplate(resume.templateId);
    final resumeData = resume.toJson();
    resumeData['photoBytes'] = ref.watch(resumeEditorProvider).photoBytes;
    resumeData['contentLanguage'] = activeLocale.languageCode;
    final previewPages = ResumePageData.split(resumeData);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SoftGlassBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: AppColors.textPrimary),
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            resume.title.isNotEmpty ? resume.title : 'CV',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            resume.header.fullName,
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    AppButton(
                      text: l10n.downloadPdf,
                      icon: Icons.picture_as_pdf_rounded,
                      compact: true,
                      onPressed: () async {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.preparingPdf)),
                          );
                        }
                        await PdfExporter.savePdf(
                          template: template,
                          resumeData: resumeData,
                          context: context,
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GlassCard(
                  borderRadius: 12,
                  blur: 16,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.previewCv,
                              style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  height: 1.1),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.previewCvSubtitle,
                              style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                  height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.cyan, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            '${resume.atsScore}',
                            style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => _openVersionHistory(
                      context,
                      ref,
                      resume,
                      activeLocale.languageCode == 'tr',
                    ),
                    icon: const Icon(Icons.history_rounded, size: 17),
                    label: Text(
                      l10n.versionHistory,
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.cyan,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: [
                      for (var pageIndex = 0;
                          pageIndex < previewPages.length;
                          pageIndex++) ...[
                        _ResumePagePreview(
                          template: template,
                          resumeData: previewPages[pageIndex],
                        ),
                        if (previewPages.length > 1)
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: Text(
                              activeLocale.languageCode == 'tr'
                                  ? 'Sayfa ${pageIndex + 1} / ${previewPages.length}'
                                  : 'Page ${pageIndex + 1} / ${previewPages.length}',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        const SizedBox(height: 14),
                      ],
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  context.push('/editor?id=${resume.id}'),
                              icon: const Icon(Icons.edit_rounded),
                              label: Text(l10n.edit),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.preparingPdf),
                                    ),
                                  );
                                }
                                await PdfExporter.savePdf(
                                  template: template,
                                  resumeData: resumeData,
                                  context: context,
                                );
                              },
                              icon: const Icon(Icons.picture_as_pdf_rounded),
                              label: Text(l10n.downloadPdf),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openVersionHistory(
    BuildContext context,
    WidgetRef ref,
    ResumeEntity resume,
    bool isTurkish,
  ) async {
    final syncService = ref.read(supabaseResumeSyncServiceProvider);
    final version = await showResumeVersionHistory(
      context,
      versions: syncService.loadVersions(resume.id),
      isTurkish: isTurkish,
    );
    if (!context.mounted || version == null) {
      return;
    }

    final restoredResume = await syncService.restoreVersion(version);
    if (!context.mounted) {
      return;
    }
    final saved = ref.read(savedResumesProvider.notifier);
    saved.state = [
      for (final item in saved.state)
        if (item.id == restoredResume.id) restoredResume else item,
    ];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isTurkish
              ? 'Önceki sürüm geri yüklendi.'
              : 'Previous version restored.',
        ),
      ),
    );
  }
}

class _ResumePagePreview extends StatelessWidget {
  const _ResumePagePreview({
    required this.template,
    required this.resumeData,
  });

  final BaseResumeTemplate template;
  final Map<String, dynamic> resumeData;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 12,
      blur: 14,
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Container(
          color: Colors.white,
          child: AspectRatio(
            aspectRatio: 1 / 1.42,
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
    );
  }
}
