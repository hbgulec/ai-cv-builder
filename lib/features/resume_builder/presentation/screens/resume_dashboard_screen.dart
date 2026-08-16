import 'package:flutter/material.dart';
import 'package:ai_cv_builder/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../pdf_export/pdf_exporter.dart';
import '../../../template_engine/template_registry.dart';
import '../../domain/entities/resume_entity.dart';
import '../providers/resume_provider.dart';

/// Resume Dashboard screen showcasing saved resumes, quick actions,
/// dynamic EN/TR language switcher, and AI CV Builder branding with glassmorphism visuals.
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

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.darkBackgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar / Header
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryIndigo.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
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
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            l10n.atsOptimizedSub,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Language Switcher Selector Button
                    PopupMenuButton<String>(
                      tooltip: l10n.language,
                      icon: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.glassBackground,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.glassBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              currentLocale.languageCode == 'tr' ? '🇹🇷 TR' : '🇺🇸 EN',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: AppColors.textSecondary),
                          ],
                        ),
                      ),
                      onSelected: (langCode) {
                        ref.read(localeProvider.notifier).state = Locale(langCode);
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'en',
                          child: Row(
                            children: [
                              const Text('🇺🇸 '),
                              Text(l10n.english),
                              if (currentLocale.languageCode == 'en') ...[
                                const Spacer(),
                                const Icon(Icons.check_rounded, size: 16, color: AppColors.primaryIndigo),
                              ],
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'tr',
                          child: Row(
                            children: [
                              const Text('🇹🇷 '),
                              Text(l10n.turkish),
                              if (currentLocale.languageCode == 'tr') ...[
                                const Spacer(),
                                const Icon(Icons.check_rounded, size: 16, color: AppColors.primaryIndigo),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),

                    AppButton(
                      text: l10n.createNewCv,
                      icon: Icons.add_rounded,
                      onPressed: () => context.push('/editor'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Welcome Hero Card
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accentViolet.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.accentViolet.withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                l10n.heroBadge,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accentViolet,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              l10n.heroTitle,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.heroSubtitle,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Image.network(
                        'https://images.unsplash.com/photo-1586281380349-632531db7ed4?w=200&q=80',
                        width: 120,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.description_outlined,
                          size: 64,
                          color: AppColors.primaryIndigo,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Section Title with Edit Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.yourResumes,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        // Edit / Done toggle button
                        if (resumes.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              setState(() => _isEditMode = !_isEditMode);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _isEditMode
                                    ? AppColors.primaryIndigo.withValues(alpha: 0.2)
                                    : AppColors.glassBackground,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _isEditMode
                                      ? AppColors.primaryIndigo.withValues(alpha: 0.5)
                                      : AppColors.glassBorder,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _isEditMode ? Icons.check_rounded : Icons.edit_outlined,
                                    size: 14,
                                    color: _isEditMode ? AppColors.primaryIndigo : AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _isEditMode ? l10n.done : l10n.editYourResumes,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: _isEditMode ? AppColors.primaryIndigo : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(width: 10),
                        Text(
                          l10n.resumesSavedCount(resumes.length),
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Resume Cards Grid
                Expanded(
                  child: resumes.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.article_outlined,
                                size: 56,
                                color: AppColors.textMuted.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                l10n.noResumesYet,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              AppButton(
                                text: l10n.createFirstResume,
                                icon: Icons.add,
                                onPressed: () => context.push('/editor'),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 320,
                            mainAxisExtent: 315,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: resumes.length,
                          itemBuilder: (context, index) {
                            final resume = resumes[index];
                            final template = TemplateRegistry.getTemplate(resume.templateId);
                            final resumeData = resume.toJson();
                            resumeData['contentLanguage'] = currentLocale.languageCode;

                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                GlassCard(
                                  onTap: _isEditMode ? null : () => context.push('/view?id=${resume.id}'),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 1. Header (Area 1: CV Title, User Full Name & Template Name Badge)
                                      Padding(
                                        padding: const EdgeInsets.only(right: 32),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              resume.title,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textPrimary,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    resume.header.fullName,
                                                    style: const TextStyle(
                                                      fontSize: 11,
                                                      color: AppColors.textSecondary,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                // Template Name Badge (Right side of user name)
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.accentViolet.withValues(alpha: 0.15),
                                                    borderRadius: BorderRadius.circular(4),
                                                    border: Border.all(
                                                      color: AppColors.accentViolet.withValues(alpha: 0.3),
                                                      width: 0.8,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    template.config.name.toUpperCase(),
                                                    style: const TextStyle(
                                                      fontSize: 8.5,
                                                      color: AppColors.accentViolet,
                                                      fontWeight: FontWeight.bold,
                                                      letterSpacing: 0.4,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      // 2. Template Thumbnail Preview (Area 2)
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: AppColors.glassBorder),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.topCenter,
                                              child: SizedBox(
                                                width: 400,
                                                height: 565,
                                                child: template.buildPreview(resumeData),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),

                                      // 3. Bottom Action Bar (Position 1: View, Edit, PDF Buttons)
                                      Row(
                                        children: [
                                          // Action 1: View Button
                                          Expanded(
                                            child: InkWell(
                                              borderRadius: BorderRadius.circular(6),
                                              onTap: () => context.push('/view?id=${resume.id}'),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withValues(alpha: 0.06),
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(color: AppColors.glassBorder.withValues(alpha: 0.5)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.visibility_outlined, size: 13, color: AppColors.textSecondary),
                                                    const SizedBox(width: 4),
                                                    Flexible(
                                                      child: Text(
                                                        l10n.view,
                                                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),

                                          // Action 2: Edit Button
                                          Expanded(
                                            child: InkWell(
                                              borderRadius: BorderRadius.circular(6),
                                              onTap: () => context.push('/editor?id=${resume.id}'),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withValues(alpha: 0.06),
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(color: AppColors.glassBorder.withValues(alpha: 0.5)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.edit_outlined, size: 13, color: AppColors.textSecondary),
                                                    const SizedBox(width: 4),
                                                    Flexible(
                                                      child: Text(
                                                        l10n.edit,
                                                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),

                                          // Action 3: PDF Export Button
                                          Expanded(
                                            child: InkWell(
                                              borderRadius: BorderRadius.circular(6),
                                              onTap: () async {
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text('PDF hazırlanıyor ve indiriliyor...'),
                                                      duration: Duration(seconds: 2),
                                                    ),
                                                  );
                                                }
                                                await PdfExporter.savePdf(
                                                  template: template,
                                                  resumeData: resumeData,
                                                  context: context,
                                                );
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primaryIndigo.withValues(alpha: 0.2),
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(color: AppColors.primaryIndigo.withValues(alpha: 0.4)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.picture_as_pdf_rounded, size: 13, color: AppColors.primaryIndigo),
                                                    const SizedBox(width: 4),
                                                    const Flexible(
                                                      child: Text(
                                                        'PDF',
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight: FontWeight.bold,
                                                          color: AppColors.primaryIndigo,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                // 3. Top-Right Corner Circular ATS Badge (Area 3)
                                Positioned(
                                  top: -6,
                                  right: -6,
                                  child: Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF6366F1), Color(0xFF10B981)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      border: Border.all(color: const Color(0xFF1E293B), width: 2.5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${resume.atsScore}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            height: 1.0,
                                          ),
                                        ),
                                        const Text(
                                          'ATS',
                                          style: TextStyle(
                                            fontSize: 7,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white70,
                                            height: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                // 6. Edit Mode Action Badges (visible only in edit mode)
                                if (_isEditMode) ...[
                                  // Badge 1: Red Delete Badge (top-left)
                                  Positioned(
                                    top: -8,
                                    left: -8,
                                    child: Tooltip(
                                      message: l10n.delete,
                                      child: GestureDetector(
                                        onTap: () => _showDeleteConfirmation(context, l10n, resume.id),
                                        child: Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: const Color(0xFFDC2626),
                                            border: Border.all(color: const Color(0xFF1E293B), width: 2),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFFDC2626).withValues(alpha: 0.5),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.remove_rounded,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Badge 2: Indigo Duplicate Badge (top-left next to delete)
                                  Positioned(
                                    top: -8,
                                    left: 26,
                                    child: Tooltip(
                                      message: l10n.duplicate,
                                      child: GestureDetector(
                                        onTap: () => _duplicateResume(context, l10n, resume),
                                        child: Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.primaryIndigo,
                                            border: Border.all(color: const Color(0xFF1E293B), width: 2),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.primaryIndigo.withValues(alpha: 0.5),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.copy_rounded,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Shows a confirmation dialog before deleting a resume.
  void _showDeleteConfirmation(BuildContext context, AppLocalizations l10n, String resumeId) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFDC2626).withValues(alpha: 0.15),
                  border: Border.all(color: const Color(0xFFDC2626).withValues(alpha: 0.3)),
                ),
                child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFDC2626), size: 24),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.deleteResumeTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.deleteResumeMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.6),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: AppColors.glassBorder),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        l10n.cancel,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        // Remove the resume from saved list
                        final notifier = ref.read(savedResumesProvider.notifier);
                        final list = List.of(notifier.state);
                        list.removeWhere((r) => r.id == resumeId);
                        notifier.state = list;

                        // Exit edit mode if no resumes left
                        if (list.isEmpty) {
                          setState(() => _isEditMode = false);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC2626),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(
                        l10n.confirmDelete,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Duplicates an existing resume with a new unique ID and appended title.
  void _duplicateResume(BuildContext context, AppLocalizations l10n, ResumeEntity original) {
    final resumes = ref.read(savedResumesProvider);
    final isPro = ref.read(isProUserProvider);

    // Check Pro limit for free tier (max 3 resumes)
    if (!isPro && resumes.length >= 3) {
      _showProPaywall(context, l10n);
      return;
    }

    final newTitle = original.title.isEmpty
        ? 'CV (${l10n.copySuffix})'
        : '${original.title} (${l10n.copySuffix})';

    final duplicated = original.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: newTitle,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final list = List<ResumeEntity>.from(resumes)..add(duplicated);
    ref.read(savedResumesProvider.notifier).state = list;

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.resumeDuplicated),
          backgroundColor: AppColors.primaryIndigo,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showProPaywall(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E1B4B), Color(0xFF0F172A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.accentViolet.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentViolet.withValues(alpha: 0.25),
                blurRadius: 30,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentViolet.withValues(alpha: 0.5),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.proRequired,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.proRequiredMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentViolet,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    l10n.upgradeToPro,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  l10n.maybeLater,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
