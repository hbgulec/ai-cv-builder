import 'package:flutter/material.dart';
import 'package:ai_cv_builder/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../pdf_export/pdf_exporter.dart';
import '../../../template_engine/template_registry.dart';
import '../../domain/entities/resume_entity.dart';
import '../providers/resume_provider.dart';

class ResumeDashboardScreen extends ConsumerStatefulWidget {
  const ResumeDashboardScreen({super.key});

  @override
  ConsumerState<ResumeDashboardScreen> createState() => _ResumeDashboardScreenState();
}

class _ResumeDashboardScreenState extends ConsumerState<ResumeDashboardScreen> {
  bool _isEditMode = false;

  @override
  Widget build(BuildContext context) {
    final resumes = ref.watch(savedResumesProvider);
    final currentLocale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;
    final atsAverage = _averageAts(resumes);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.darkBackgroundGradient),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                sliver: SliverToBoxAdapter(
                  child: _TopBar(
                    currentLocale: currentLocale,
                    l10n: l10n,
                    onLocaleChanged: (code) => ref.read(localeProvider.notifier).state = Locale(code),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: GlassCard(
                    borderRadius: 24,
                    blur: 18,
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.22)),
                          ),
                          child: Text(l10n.heroBadge, style: const TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.w700, fontSize: 11)),
                        ),
                        const SizedBox(height: 14),
                        Text(l10n.heroTitle, style: const TextStyle(fontSize: 28, height: 1.05, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                        const SizedBox(height: 8),
                        Text(l10n.heroSubtitle, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.45)),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => context.push('/editor'),
                            icon: const Icon(Icons.add_rounded),
                            label: Text(l10n.createNewCv),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(child: _StatCard(label: 'Resumes', value: '${resumes.length}', accent: AppColors.primaryLight)),
                      const SizedBox(width: 10),
                      Expanded(child: _StatCard(label: 'ATS Avg', value: '$atsAverage', accent: AppColors.success)),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.yourResumes, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                      TextButton(
                        onPressed: resumes.isEmpty ? null : () => setState(() => _isEditMode = !_isEditMode),
                        child: Text(_isEditMode ? l10n.done : l10n.editYourResumes),
                      ),
                    ],
                  ),
                ),
              ),
              if (resumes.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.article_outlined, size: 54, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          Text(l10n.noResumesYet, style: const TextStyle(color: AppColors.textSecondary)),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => context.push('/editor'),
                              icon: const Icon(Icons.add_rounded),
                              label: Text(l10n.createFirstResume),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverList.separated(
                    itemCount: resumes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final resume = resumes[index];
                      final template = TemplateRegistry.getTemplate(resume.templateId);
                      final resumeData = resume.toJson()..['contentLanguage'] = currentLocale.languageCode;

                      return _ResumeCard(
                        resume: resume,
                        templateName: template.config.name,
                        atsScore: resume.atsScore,
                        isEditMode: _isEditMode,
                        onOpen: () => context.push('/view?id=${resume.id}'),
                        onEdit: () => context.push('/editor?id=${resume.id}'),
                        onDelete: () => _showDeleteConfirmation(context, l10n, resume.id),
                        onDuplicate: () => _duplicateResume(context, l10n, resume),
                        onPdf: () async {
                          await PdfExporter.savePdf(
                            template: template,
                            resumeData: resumeData,
                            context: context,
                          );
                        },
                      );
                    },
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 92)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 1) context.push('/template-select');
          if (index == 2) context.push('/editor');
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.layers_outlined), selectedIcon: Icon(Icons.layers_rounded), label: 'Templates'),
          NavigationDestination(icon: Icon(Icons.edit_outlined), selectedIcon: Icon(Icons.edit_rounded), label: 'Editor'),
        ],
      ),
    );
  }

  int _averageAts(List<dynamic> resumes) {
    if (resumes.isEmpty) return 0;
    final total = resumes.fold<int>(0, (sum, item) => sum + (item.atsScore as int));
    return (total / resumes.length).round();
  }

  void _showDeleteConfirmation(BuildContext context, AppLocalizations l10n, String resumeId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: Text(l10n.deleteResumeTitle, style: const TextStyle(color: AppColors.textPrimary)),
        content: Text(l10n.deleteResumeMessage, style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              final notifier = ref.read(savedResumesProvider.notifier);
              notifier.state = notifier.state.where((r) => r.id != resumeId).toList();
              if (notifier.state.isEmpty) setState(() => _isEditMode = false);
            },
            child: Text(l10n.confirmDelete),
          ),
        ],
      ),
    );
  }

  void _duplicateResume(BuildContext context, AppLocalizations l10n, ResumeEntity original) {
    final resumes = ref.read(savedResumesProvider);
    final isPro = ref.read(isProUserProvider);
    if (!isPro && resumes.length >= 3) {
      _showProPaywall(context, l10n);
      return;
    }

    final duplicated = original.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: original.title.isEmpty ? 'CV (${l10n.copySuffix})' : '${original.title} (${l10n.copySuffix})',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    ref.read(savedResumesProvider.notifier).state = [...resumes, duplicated];
  }

  void _showProPaywall(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: Text(l10n.proRequired, style: const TextStyle(color: AppColors.textPrimary)),
        content: Text(l10n.proRequiredMessage, style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(l10n.maybeLater)),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(l10n.upgradeToPro)),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final Locale currentLocale;
  final AppLocalizations l10n;
  final ValueChanged<String> onLocaleChanged;

  const _TopBar({required this.currentLocale, required this.l10n, required this.onLocaleChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.appTitle,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                l10n.atsOptimizedSub,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        PopupMenuButton<String>(
          tooltip: l10n.language,
          onSelected: onLocaleChanged,
          itemBuilder: (_) => [
            PopupMenuItem(value: 'en', child: Text(l10n.english)),
            PopupMenuItem(value: 'tr', child: Text(l10n.turkish)),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.glassBackground,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: Text(
              currentLocale.languageCode == 'tr' ? 'TR' : 'EN',
              style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => context.push('/editor'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          child: const Icon(Icons.add_rounded, size: 18),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color accent;

  const _StatCard({required this.label, required this.value, required this.accent});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 20,
      blur: 14,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: accent, fontSize: 26, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _ResumeCard extends StatelessWidget {
  final ResumeEntity resume;
  final String templateName;
  final int atsScore;
  final bool isEditMode;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;
  final VoidCallback onPdf;

  const _ResumeCard({
    required this.resume,
    required this.templateName,
    required this.atsScore,
    required this.isEditMode,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
    required this.onDuplicate,
    required this.onPdf,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: isEditMode ? null : onOpen,
      borderRadius: 22,
      blur: 14,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resume.title,
                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w800, fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      resume.header.fullName,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 2),
                ),
                child: Center(
                  child: Text(
                    '$atsScore',
                    style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(templateName, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: onEdit, child: const Text('Edit'))),
              const SizedBox(width: 8),
              Expanded(child: ElevatedButton(onPressed: onPdf, child: const Text('PDF'))),
            ],
          ),
          if (isEditMode) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: TextButton(onPressed: onDuplicate, child: const Text('Duplicate'))),
                Expanded(child: TextButton(onPressed: onDelete, child: const Text('Delete'))),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
