// Hallmark - mobile workbench - design-system: design.md - designed-as-app
import 'package:ai_cv_builder/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/soft_glass_shell.dart';
import '../../../pdf_export/pdf_exporter.dart';
import '../../../template_engine/template_registry.dart';
import '../../domain/entities/resume_entity.dart';
import '../../data/services/supabase_resume_sync_service.dart';
import '../providers/resume_provider.dart';

/// Hallmark - genre: atmospheric - macrostructure: mobile workbench
/// design-system: design.md - designed-as-app
class SoftGlassDashboardScreen extends ConsumerStatefulWidget {
  const SoftGlassDashboardScreen({super.key});

  @override
  ConsumerState<SoftGlassDashboardScreen> createState() =>
      _SoftGlassDashboardScreenState();
}

class _SoftGlassDashboardScreenState
    extends ConsumerState<SoftGlassDashboardScreen> {
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(_loadResumes);
  }

  Future<void> _loadResumes() async {
    final resumes =
        await ref.read(supabaseResumeSyncServiceProvider).loadResumes();
    if (!mounted) {
      return;
    }
    ref.read(savedResumesProvider.notifier).state = resumes;
  }

  @override
  Widget build(BuildContext context) {
    final resumes = ref.watch(savedResumesProvider);
    final locale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;
    final score = _averageAts(resumes);
    final firstName = _firstName(resumes, locale.languageCode);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: SoftGlassBackground(
        child: SafeArea(
          bottom: false,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: _AppHeader(
                    locale: locale,
                    l10n: l10n,
                    onLocaleChanged: (code) =>
                        ref.read(localeProvider.notifier).state = Locale(code),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: SoftReveal(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          locale.languageCode == 'tr'
                              ? 'Merhaba $firstName'
                              : 'Hi $firstName',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          locale.languageCode == 'tr'
                              ? 'Fırsatların önünü açan bir CV hazırlayın.'
                              : 'Create a resume that opens doors.',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: SoftReveal(
                    offset: 18,
                    child: _ResumeScoreCard(
                      score: score,
                      hasResume: resumes.isNotEmpty,
                      onImprove: () => context.push(
                          '/editor?id=${resumes.isEmpty ? '' : resumes.first.id}'),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: SoftReveal(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionTitle(title: 'Get Started'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                text: l10n.createNewCv,
                                icon: Icons.note_add_outlined,
                                isSecondary: true,
                                compact: true,
                                onPressed: () => context.push('/editor'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: AppButton(
                                text: locale.languageCode == 'tr'
                                    ? 'İlan Tara'
                                    : 'Scan Job Description',
                                icon: Icons.document_scanner_outlined,
                                isSecondary: true,
                                compact: true,
                                onPressed: () =>
                                    _showComingSoon(context, locale),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _SectionTitle(title: l10n.yourResumes),
                      TextButton(
                        onPressed: resumes.isEmpty
                            ? null
                            : () => setState(() => _isEditMode = !_isEditMode),
                        child: Text(
                            _isEditMode ? l10n.done : l10n.editYourResumes),
                      ),
                    ],
                  ),
                ),
              ),
              if (resumes.isEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: GlassCard(
                      showShadow: false,
                      child: Column(
                        children: [
                          const Icon(
                            Icons.description_outlined,
                            color: AppColors.textMuted,
                            size: 34,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            l10n.noResumesYet,
                            textAlign: TextAlign.center,
                            style:
                                const TextStyle(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 12),
                          AppButton(
                            text: l10n.createFirstResume,
                            icon: Icons.add_rounded,
                            onPressed: () => context.push('/editor'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList.separated(
                    itemCount: resumes.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final resume = resumes[index];
                      final template =
                          TemplateRegistry.getTemplate(resume.templateId);
                      final resumeData = resume.toJson()
                        ..['contentLanguage'] = locale.languageCode;
                      return _CompactResumeCard(
                        resume: resume,
                        isEditMode: _isEditMode,
                        templateName: template.config.name,
                        onOpen: () => context.push('/view?id=${resume.id}'),
                        onEdit: () => context.push('/editor?id=${resume.id}'),
                        onDuplicate: () =>
                            _duplicateResume(context, l10n, resume),
                        onDelete: () =>
                            _confirmDelete(context, l10n, resume.id),
                        onPdf: () => PdfExporter.savePdf(
                          template: template,
                          resumeData: resumeData,
                          context: context,
                        ),
                      );
                    },
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 104)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SoftGlassDock(
        selectedIndex: 0,
        onCreate: () => context.push('/editor'),
        onDestinationSelected: (index) {
          if (index == 2) context.push('/template-select');
          if (index == 3) context.push('/account');
        },
      ),
    );
  }

  String _firstName(List<ResumeEntity> resumes, String languageCode) {
    if (resumes.isEmpty || resumes.first.header.fullName.trim().isEmpty) {
      return languageCode == 'tr' ? 'Alex' : 'Alex';
    }
    return resumes.first.header.fullName.trim().split(RegExp(r'\s+')).first;
  }

  int _averageAts(List<ResumeEntity> resumes) {
    if (resumes.isEmpty) return 0;
    return (resumes.fold<int>(0, (sum, item) => sum + item.atsScore) /
            resumes.length)
        .round();
  }

  void _showComingSoon(BuildContext context, Locale locale) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          locale.languageCode == 'tr'
              ? 'Bu özellik yakında eklenecek.'
              : 'This feature is coming soon.',
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    AppLocalizations l10n,
    String resumeId,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.darkSurface,
        title: Text(l10n.deleteResumeTitle),
        content: Text(l10n.deleteResumeMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              final saved = ref.read(savedResumesProvider.notifier);
              saved.state =
                  saved.state.where((item) => item.id != resumeId).toList();
              if (saved.state.isEmpty) setState(() => _isEditMode = false);
              ref
                  .read(supabaseResumeSyncServiceProvider)
                  .deleteResume(resumeId);
            },
            child: Text(l10n.confirmDelete),
          ),
        ],
      ),
    );
  }

  void _duplicateResume(
    BuildContext context,
    AppLocalizations l10n,
    ResumeEntity original,
  ) {
    final resumes = ref.read(savedResumesProvider);
    final now = DateTime.now();
    final duplicated = original.copyWith(
      id: const Uuid().v4(),
      title: original.title.isEmpty
          ? 'CV (${l10n.copySuffix})'
          : '${original.title} (${l10n.copySuffix})',
      createdAt: now,
      updatedAt: now,
    );
    ref.read(savedResumesProvider.notifier).state = [...resumes, duplicated];
    ref.read(supabaseResumeSyncServiceProvider).saveResume(duplicated);
  }
}

class _AppHeader extends StatelessWidget {
  final Locale locale;
  final AppLocalizations l10n;
  final ValueChanged<String> onLocaleChanged;

  const _AppHeader({
    required this.locale,
    required this.l10n,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: const Icon(Icons.description_outlined,
              color: AppColors.textPrimary, size: 16),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            l10n.appTitle,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        PopupMenuButton<String>(
          tooltip: l10n.language,
          color: AppColors.darkSurface,
          onSelected: onLocaleChanged,
          itemBuilder: (_) => [
            PopupMenuItem(value: 'en', child: Text(l10n.english)),
            PopupMenuItem(value: 'tr', child: Text(l10n.turkish)),
          ],
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              locale.languageCode.toUpperCase(),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          tooltip: 'Notifications',
          icon: const Icon(Icons.notifications_none_rounded, size: 20),
          color: AppColors.textPrimary,
        ),
      ],
    );
  }
}

class _ResumeScoreCard extends StatelessWidget {
  final int score;
  final bool hasResume;
  final VoidCallback onImprove;

  const _ResumeScoreCard({
    required this.score,
    required this.hasResume,
    required this.onImprove,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedScore = hasResume ? score : 0;
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Resume Score',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _ScoreRing(score: resolvedScore),
              const SizedBox(width: 18),
              const Expanded(
                child: Column(
                  children: [
                    _ScoreBar(label: 'Structure', value: 0.78),
                    SizedBox(height: 9),
                    _ScoreBar(label: 'Content', value: 0.88),
                    SizedBox(height: 9),
                    _ScoreBar(label: 'Keywords', value: 0.66),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: hasResume ? onImprove : null,
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.chevron_right_rounded, size: 16),
              label: const Text('Improve now'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(horizontal: 6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreRing extends StatelessWidget {
  final int score;

  const _ScoreRing({required this.score});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: score / 100,
              strokeWidth: 4,
              backgroundColor: Colors.white.withValues(alpha: 0.12),
              valueColor: const AlwaysStoppedAnimation(AppColors.cyan),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$score',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                score >= 80 ? 'Good Match' : 'Keep Building',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 7),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreBar extends StatelessWidget {
  final String label;
  final double value;

  const _ScoreBar({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 54,
          child: Text(label,
              style:
                  const TextStyle(color: AppColors.textSecondary, fontSize: 9)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 5,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation(AppColors.cyan),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _CompactResumeCard extends StatelessWidget {
  final ResumeEntity resume;
  final String templateName;
  final bool isEditMode;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onPdf;
  final VoidCallback onDuplicate;
  final VoidCallback onDelete;

  const _CompactResumeCard({
    required this.resume,
    required this.templateName,
    required this.isEditMode,
    required this.onOpen,
    required this.onEdit,
    required this.onPdf,
    required this.onDuplicate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      showShadow: false,
      onTap: isEditMode ? null : onOpen,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Icon(Icons.description_outlined,
                color: AppColors.textPrimary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  resume.title.isEmpty ? 'Untitled Resume' : resume.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  templateName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 9),
                ),
                if (isEditMode) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _SmallAction(label: 'Edit', onTap: onEdit),
                      _SmallAction(label: 'PDF', onTap: onPdf),
                      _SmallAction(label: 'Copy', onTap: onDuplicate),
                      _SmallAction(
                          label: 'Delete', onTap: onDelete, danger: true),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryLight, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Text(
              '${resume.atsScore}',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallAction extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool danger;

  const _SmallAction(
      {required this.label, required this.onTap, this.danger = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: TextStyle(
            color: danger ? AppColors.error : AppColors.primaryLight,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
