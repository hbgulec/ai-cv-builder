import 'package:flutter/material.dart';
import 'package:ai_cv_builder/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/soft_glass_shell.dart';
import '../../data/services/supabase_resume_sync_service.dart';
import '../../domain/entities/resume_entity.dart';
import '../providers/resume_provider.dart';
import '../widgets/resume_version_history_sheet.dart';

class ResumeEditorScreen extends ConsumerStatefulWidget {
  final String? resumeId;

  const ResumeEditorScreen({super.key, this.resumeId});

  @override
  ConsumerState<ResumeEditorScreen> createState() => _ResumeEditorScreenState();
}

class _ResumeEditorScreenState extends ConsumerState<ResumeEditorScreen> {
  static const _totalSteps = 8;
  late final TextEditingController _cvTitleController;
  late final TextEditingController _nameController;
  late final TextEditingController _titleController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;
  late final TextEditingController _summaryController;

  @override
  void initState() {
    super.initState();

    if (widget.resumeId != null) {
      final savedResumes = ref.read(savedResumesProvider);
      ResumeEntity? savedResume;
      for (final resume in savedResumes) {
        if (resume.id == widget.resumeId) {
          savedResume = resume;
          break;
        }
      }
      if (savedResume != null) {
        final loadedResume = savedResume;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(resumeEditorProvider.notifier).loadResume(loadedResume);
        });
        _cvTitleController = TextEditingController(text: loadedResume.title);
        _nameController =
            TextEditingController(text: loadedResume.header.fullName);
        _titleController = TextEditingController(
            text: loadedResume.header.professionalTitle ?? '');
        _emailController =
            TextEditingController(text: loadedResume.header.email ?? '');
        _phoneController =
            TextEditingController(text: loadedResume.header.phone ?? '');
        _locationController =
            TextEditingController(text: loadedResume.header.location ?? '');
        _summaryController = TextEditingController(text: loadedResume.summary);
        return;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(resumeEditorProvider.notifier).resetNewResume();
    });
    _cvTitleController = TextEditingController();
    _nameController = TextEditingController();
    _titleController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _locationController = TextEditingController();
    _summaryController = TextEditingController();
  }

  @override
  void dispose() {
    _cvTitleController.dispose();
    _nameController.dispose();
    _titleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(resumeEditorProvider);
    final notifier = ref.read(resumeEditorProvider.notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SoftGlassBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.arrow_back_rounded,
                            color: AppColors.textPrimary)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            editorState.resume.title.isNotEmpty
                                ? editorState.resume.title
                                : l10n.personalInfo,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(l10n.autoSavedLocally,
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
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.glassBorder)),
                      child: Text(
                        l10n.stepProgress(
                            editorState.activeStep + 1, _totalSteps),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
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
                      Container(
                        width: 42,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.cyan, width: 2),
                        ),
                        child: Text(
                          '${editorState.resume.atsScore}',
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.atsScoreLabel,
                              style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 7),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value:
                                    (editorState.activeStep + 1) / _totalSteps,
                                minHeight: 4,
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.1),
                                valueColor: const AlwaysStoppedAnimation(
                                    AppColors.cyan),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              l10n.stepProgress(
                                  editorState.activeStep + 1, _totalSteps),
                              style: const TextStyle(
                                  color: AppColors.textSecondary, fontSize: 9),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () => context.push('/template-select'),
                        tooltip: l10n.viewTemplatesFinish,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.glassBackground,
                          side: const BorderSide(color: AppColors.glassBorder),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.layers_outlined,
                            size: 18, color: AppColors.textPrimary),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        onPressed: _openVersionHistory,
                        tooltip:
                            Localizations.localeOf(context).languageCode == 'tr'
                                ? 'Sürüm geçmişi'
                                : 'Version history',
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.glassBackground,
                          side: const BorderSide(color: AppColors.glassBorder),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.history_rounded,
                            size: 18, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _stepChip(0, l10n.headerStep, editorState, notifier),
                      _stepChip(1, l10n.experienceStep, editorState, notifier),
                      _stepChip(2, l10n.educationStep, editorState, notifier),
                      _stepChip(3, l10n.skillsStep, editorState, notifier),
                      _stepChip(
                        4,
                        Localizations.localeOf(context).languageCode == 'tr'
                            ? 'Diller'
                            : 'Languages',
                        editorState,
                        notifier,
                      ),
                      _stepChip(5, l10n.projectsStep, editorState, notifier),
                      _stepChip(6, l10n.photoStep, editorState, notifier),
                      _stepChip(7, l10n.summaryStep, editorState, notifier),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: GlassCard(
                    borderRadius: 12,
                    blur: 14,
                    padding: const EdgeInsets.all(14),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        final offset = Tween<Offset>(
                          begin: const Offset(0.04, 0),
                          end: Offset.zero,
                        ).animate(animation);
                        return FadeTransition(
                          opacity: animation,
                          child:
                              SlideTransition(position: offset, child: child),
                        );
                      },
                      child: IndexedStack(
                        key: ValueKey(editorState.activeStep),
                        index: editorState.activeStep.clamp(0, _totalSteps - 1),
                        children: [
                          _HeaderStep(
                              notifier: notifier,
                              header: editorState.resume.header,
                              l10n: l10n,
                              cvTitleController: _cvTitleController,
                              nameController: _nameController,
                              titleController: _titleController,
                              emailController: _emailController,
                              phoneController: _phoneController,
                              locationController: _locationController),
                          _ExperienceStep(
                              editorState: editorState,
                              notifier: notifier,
                              l10n: l10n),
                          _EducationStep(
                              editorState: editorState,
                              notifier: notifier,
                              l10n: l10n),
                          _SkillsStep(
                              editorState: editorState,
                              notifier: notifier,
                              l10n: l10n),
                          _LanguagesStep(
                              editorState: editorState,
                              notifier: notifier,
                              l10n: l10n),
                          _ProjectsStep(
                              editorState: editorState,
                              notifier: notifier,
                              l10n: l10n),
                          _PhotoStep(
                              editorState: editorState,
                              notifier: notifier,
                              l10n: l10n),
                          _SummaryStep(
                              editorState: editorState,
                              notifier: notifier,
                              l10n: l10n,
                              summaryController: _summaryController,
                              onGenerate: () {
                                final currentResume =
                                    ref.read(resumeEditorProvider).resume;
                                final isTurkish =
                                    Localizations.localeOf(context)
                                            .languageCode ==
                                        'tr';
                                final generated = _generateSmartSummary(
                                    currentResume, isTurkish);
                                _summaryController.text = generated;
                                notifier.updateSummary(generated);
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: editorState.activeStep == 0
                            ? null
                            : () =>
                                notifier.updateStep(editorState.activeStep - 1),
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: Text(l10n.previous),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: editorState.activeStep < _totalSteps - 1
                            ? () =>
                                notifier.updateStep(editorState.activeStep + 1)
                            : () => context.push('/template-select'),
                        icon: Icon(
                          editorState.activeStep < _totalSteps - 1
                              ? Icons.arrow_forward_rounded
                              : Icons.check_circle_outline_rounded,
                        ),
                        label: Text(
                          editorState.activeStep < _totalSteps - 1
                              ? l10n.nextStep
                              : l10n.viewTemplatesFinish,
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

  Future<void> _openVersionHistory() async {
    final currentResume = ref.read(resumeEditorProvider).resume;
    final isTurkish = Localizations.localeOf(context).languageCode == 'tr';
    final syncService = ref.read(supabaseResumeSyncServiceProvider);
    final version = await showResumeVersionHistory(
      context,
      versions: syncService.loadVersions(currentResume.id),
      isTurkish: isTurkish,
    );
    if (!mounted || version == null) {
      return;
    }

    final restoredResume = await syncService.restoreVersion(version);
    if (!mounted) {
      return;
    }

    final saved = ref.read(savedResumesProvider.notifier);
    final resumes = List<ResumeEntity>.from(saved.state);
    final existingIndex =
        resumes.indexWhere((item) => item.id == restoredResume.id);
    if (existingIndex >= 0) {
      resumes[existingIndex] = restoredResume;
    } else {
      resumes.add(restoredResume);
    }
    saved.state = resumes;
    ref.read(resumeEditorProvider.notifier).loadResume(restoredResume);
    _updateControllers(restoredResume);
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

  void _updateControllers(ResumeEntity resume) {
    _cvTitleController.text = resume.title;
    _nameController.text = resume.header.fullName;
    _titleController.text = resume.header.professionalTitle ?? '';
    _emailController.text = resume.header.email ?? '';
    _phoneController.text = resume.header.phone ?? '';
    _locationController.text = resume.header.location ?? '';
    _summaryController.text = resume.summary;
  }

  Widget _stepChip(int index, String label, ResumeEditorState state,
      ResumeEditorNotifier notifier) {
    final active = state.activeStep == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        selected: active,
        onSelected: (_) => notifier.updateStep(index),
        label: Text(label),
        labelStyle: TextStyle(
            color: active ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w700,
            fontSize: 12),
        selectedColor: AppColors.primaryIndigo,
        backgroundColor: AppColors.glassBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
              color: active ? AppColors.primaryLight : AppColors.glassBorder),
        ),
        showCheckmark: false,
      ),
    );
  }

  String _generateSmartSummary(ResumeEntity resume, bool isTurkish) {
    final header = resume.header;
    final title = header.professionalTitle?.trim().isNotEmpty == true
        ? header.professionalTitle!.trim()
        : (isTurkish ? 'Yazılım Uzmanı' : 'Software Professional');
    final expList = resume.workExperiences;
    final latestExp = expList.isNotEmpty ? expList.first : null;
    final company = latestExp?.company.trim() ?? '';
    final jobTitle = latestExp?.jobTitle.trim() ?? '';
    final skillsList = resume.skills
        .map((s) => s.name.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    final topSkills = skillsList.take(5).join(', ');
    final eduList = resume.educationList;
    final topEdu = eduList.isNotEmpty ? eduList.first : null;
    final degree = topEdu?.degree.trim() ?? '';
    final inst = topEdu?.institution.trim() ?? '';
    final projList = resume.projects;

    if (isTurkish) {
      final buffer = StringBuffer();
      buffer.write('Son derece motivasyonlu, ');
      if (jobTitle.isNotEmpty && company.isNotEmpty) {
        buffer.write('$company bünyesinde $jobTitle olarak deneyim kazanmış ');
      } else if (jobTitle.isNotEmpty) {
        buffer.write('$jobTitle alanında deneyimli ');
      } else {
        buffer.write('$title olarak kariyerine devam eden ');
      }
      buffer.write('bir profesyonelim. ');
      if (topSkills.isNotEmpty) {
        buffer.write(
            'Özellikle $topSkills konularında derinlemesine bilgi ve yetkinliğe sahibim. ');
      }
      if (degree.isNotEmpty || inst.isNotEmpty) {
        buffer.write('${[
          degree,
          inst
        ].where((s) => s.isNotEmpty).join(' - ')} eğitimi ile güçlü bir teknik altyapı edindim. ');
      }
      if (projList.isNotEmpty) {
        buffer.write(
            'Geliştirdiğim yenilikçi projelerle ölçeklenebilir ve yüksek performanslı çözümler ürettim. ');
      } else {
        buffer.write(
            'Karmaşık problemleri analiz edip kullanıcı odaklı ve sürdürülebilir çözümler sunmaya odaklanıyorum. ');
      }
      buffer.write(
          'Takım çalışmasına yatkın, sürekli öğrenmeye açık ve projelere değer katmayı hedefleyen bir yapıya sahibim.');
      return buffer.toString();
    }

    final buffer = StringBuffer();
    buffer.write('Results-driven ');
    if (jobTitle.isNotEmpty && company.isNotEmpty) {
      buffer.write('$jobTitle with hands-on experience at $company. ');
    } else if (jobTitle.isNotEmpty) {
      buffer.write('$jobTitle with a proven track record. ');
    } else {
      buffer.write('$title with a solid technical background. ');
    }
    if (topSkills.isNotEmpty) {
      buffer.write(
          'Proficient in $topSkills with expertise in building scalable applications. ');
    }
    if (degree.isNotEmpty || inst.isNotEmpty) {
      buffer.write('Holds an academic background in ${[
        degree,
        inst
      ].where((s) => s.isNotEmpty).join(' from ')}. ');
    }
    if (projList.isNotEmpty) {
      buffer.write(
          'Demonstrated ability to design and deliver high-impact end-to-end projects. ');
    } else {
      buffer.write(
          'Passionate about continuous learning, problem-solving, and team collaboration. ');
    }
    return buffer.toString();
  }
}

class _HeaderStep extends StatelessWidget {
  final ResumeEditorNotifier notifier;
  final HeaderInfo header;
  final AppLocalizations l10n;
  final TextEditingController cvTitleController;
  final TextEditingController nameController;
  final TextEditingController titleController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController locationController;

  const _HeaderStep(
      {required this.notifier,
      required this.header,
      required this.l10n,
      required this.cvTitleController,
      required this.nameController,
      required this.titleController,
      required this.emailController,
      required this.phoneController,
      required this.locationController});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(l10n.personalInfo,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        _field(l10n.cvTitleLabel, cvTitleController,
            (val) => notifier.updateTitle(val)),
        _field(l10n.fullName, nameController,
            (val) => notifier.updateHeader(header.copyWith(fullName: val))),
        _field(
            l10n.professionalTitle,
            titleController,
            (val) =>
                notifier.updateHeader(header.copyWith(professionalTitle: val))),
        _field(l10n.email, emailController,
            (val) => notifier.updateHeader(header.copyWith(email: val))),
        _field(l10n.phone, phoneController,
            (val) => notifier.updateHeader(header.copyWith(phone: val))),
        _field(l10n.location, locationController,
            (val) => notifier.updateHeader(header.copyWith(location: val))),
      ],
    );
  }

  Widget _field(String label, TextEditingController controller,
      ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        hintLocales: [Locale(l10n.localeName)],
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

class _CollapsedEntryCard extends StatelessWidget {
  const _CollapsedEntryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.margin,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final EdgeInsets margin;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: margin,
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryLight, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ),
          const Icon(Icons.edit_rounded,
              color: AppColors.textSecondary, size: 18),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.date,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final DateTime? date;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final value = date == null
        ? label
        : '${date!.day.toString().padLeft(2, '0')}/${date!.month.toString().padLeft(2, '0')}/${date!.year}';
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          enabled: enabled,
          suffixIcon: const Icon(Icons.calendar_today_outlined, size: 17),
        ),
        child: Text(
          value,
          style: TextStyle(
            color: enabled ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _ExperienceStep extends StatelessWidget {
  final ResumeEditorState editorState;
  final ResumeEditorNotifier notifier;
  final AppLocalizations l10n;

  const _ExperienceStep(
      {required this.editorState, required this.notifier, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.experienceStep,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800)),
            IconButton(
              onPressed: () => notifier.addWorkExperience(WorkExperience(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  jobTitle: '',
                  company: '',
                  location: '',
                  bulletPoints: const [])),
              icon: const Icon(Icons.add_circle_rounded,
                  color: AppColors.primaryLight),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (editorState.resume.workExperiences.isEmpty)
          Text(l10n.noExperiencesYet,
              style: const TextStyle(color: AppColors.textSecondary))
        else
          ...editorState.resume.workExperiences.asMap().entries.map((entry) =>
              _ExperienceCard(
                  key: ValueKey(entry.value.id),
                  index: entry.key,
                  exp: entry.value,
                  notifier: notifier,
                  l10n: l10n)),
      ],
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  const _ExperienceCard({
    super.key,
    required this.index,
    required this.exp,
    required this.notifier,
    required this.l10n,
  });

  final int index;
  final WorkExperience exp;
  final ResumeEditorNotifier notifier;
  final AppLocalizations l10n;

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  late final TextEditingController _job;
  late final TextEditingController _company;
  late final TextEditingController _location;
  late final TextEditingController _bullets;
  late DateTime? _startDate;
  late DateTime? _endDate;
  late bool _isCurrent;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _job = TextEditingController(text: widget.exp.jobTitle);
    _company = TextEditingController(text: widget.exp.company);
    _location = TextEditingController(text: widget.exp.location);
    _bullets = TextEditingController(text: widget.exp.bulletPoints.join('\n'));
    _startDate = widget.exp.startDate;
    _endDate = widget.exp.endDate;
    _isCurrent = widget.exp.isCurrent;
    _isExpanded = widget.exp.jobTitle.trim().isEmpty &&
        widget.exp.company.trim().isEmpty &&
        widget.exp.location.trim().isEmpty &&
        widget.exp.bulletPoints.isEmpty;
  }

  @override
  void dispose() {
    _job.dispose();
    _company.dispose();
    _location.dispose();
    _bullets.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isExpanded) {
      return _CollapsedEntryCard(
        title: _job.text.trim().isEmpty
            ? widget.l10n.experienceStep
            : _job.text.trim(),
        subtitle: [_company.text.trim(), _location.text.trim()]
            .where((value) => value.isNotEmpty)
            .join(' - '),
        icon: Icons.work_outline_rounded,
        margin: const EdgeInsets.only(bottom: 12),
        onTap: () => setState(() => _isExpanded = true),
      );
    }

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      borderRadius: 12,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _input(widget.l10n.jobTitle, _job),
          _input(widget.l10n.company, _company),
          _input(widget.l10n.location, _location),
          Row(
            children: [
              Expanded(
                child: _DateField(
                  label: Localizations.localeOf(context).languageCode == 'tr'
                      ? 'Başlangıç tarihi'
                      : 'Start date',
                  date: _startDate,
                  enabled: true,
                  onTap: () => _pickDate(start: true),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DateField(
                  label: Localizations.localeOf(context).languageCode == 'tr'
                      ? 'Bitiş tarihi'
                      : 'End date',
                  date: _endDate,
                  enabled: !_isCurrent,
                  onTap: () => _pickDate(start: false),
                ),
              ),
            ],
          ),
          CheckboxListTile(
            value: _isCurrent,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              Localizations.localeOf(context).languageCode == 'tr'
                  ? 'Halen çalışıyorum'
                  : 'I currently work here',
              style:
                  const TextStyle(color: AppColors.textPrimary, fontSize: 13),
            ),
            onChanged: (value) => setState(() {
              _isCurrent = value ?? false;
              if (_isCurrent) _endDate = null;
            }),
          ),
          _input(widget.l10n.bulletPointsLabel, _bullets, maxLines: 4),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () =>
                      widget.notifier.removeWorkExperience(widget.index),
                  child: Text(widget.l10n.delete),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveExperience,
                  child: Text(widget.l10n.save),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveExperience() {
    widget.notifier.updateWorkExperience(
      widget.index,
      widget.exp.copyWith(
        jobTitle: _job.text.trim(),
        company: _company.text.trim(),
        location: _location.text.trim(),
        startDate: _startDate,
        endDate: _isCurrent ? null : _endDate,
        isCurrent: _isCurrent,
        bulletPoints: _bullets.text
            .split('\n')
            .map((value) => value.trim())
            .where((value) => value.isNotEmpty)
            .toList(),
      ),
    );
    setState(() => _isExpanded = false);
  }

  Future<void> _pickDate({required bool start}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: (start ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (selected == null || !mounted) return;
    setState(() {
      if (start) {
        _startDate = selected;
      } else {
        _endDate = selected;
      }
    });
  }

  Widget _input(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        hintLocales: [Localizations.localeOf(context)],
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

class _EducationStep extends StatelessWidget {
  final ResumeEditorState editorState;
  final ResumeEditorNotifier notifier;
  final AppLocalizations l10n;

  const _EducationStep(
      {required this.editorState, required this.notifier, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.educationStep,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800)),
            IconButton(
              onPressed: () => notifier.addEducation(Education(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  degree: '',
                  institution: '',
                  location: '',
                  startDate: DateTime.now(),
                  endDate: null,
                  isCurrent: false)),
              icon: const Icon(Icons.add_circle_rounded,
                  color: AppColors.primaryLight),
            ),
          ],
        ),
        if (editorState.resume.educationList.isEmpty)
          Text(l10n.noEducationYet,
              style: const TextStyle(color: AppColors.textSecondary))
        else
          ...editorState.resume.educationList.asMap().entries.map((entry) =>
              _EducationCardRow(
                  key: ValueKey(entry.value.id),
                  index: entry.key,
                  education: entry.value,
                  notifier: notifier,
                  l10n: l10n)),
      ],
    );
  }
}

class _EducationCardRow extends StatefulWidget {
  const _EducationCardRow({
    super.key,
    required this.index,
    required this.education,
    required this.notifier,
    required this.l10n,
  });

  final int index;
  final Education education;
  final ResumeEditorNotifier notifier;
  final AppLocalizations l10n;

  @override
  State<_EducationCardRow> createState() => _EducationCardRowState();
}

class _EducationCardRowState extends State<_EducationCardRow> {
  late final TextEditingController _degree;
  late final TextEditingController _institution;
  late DateTime? _startDate;
  late DateTime? _endDate;
  late bool _isCurrent;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _degree = TextEditingController(text: widget.education.degree);
    _institution = TextEditingController(text: widget.education.institution);
    _startDate = widget.education.startDate;
    _endDate = widget.education.endDate;
    _isCurrent = widget.education.isCurrent;
    _isExpanded = widget.education.degree.trim().isEmpty &&
        widget.education.institution.trim().isEmpty;
  }

  @override
  void dispose() {
    _degree.dispose();
    _institution.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isExpanded) {
      return _CollapsedEntryCard(
        title: _degree.text.trim().isEmpty
            ? widget.l10n.educationStep
            : _degree.text.trim(),
        subtitle: _institution.text.trim(),
        icon: Icons.school_outlined,
        margin: const EdgeInsets.only(top: 12),
        onTap: () => setState(() => _isExpanded = true),
      );
    }

    return GlassCard(
      margin: const EdgeInsets.only(top: 12),
      borderRadius: 12,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            controller: _degree,
            hintLocales: [Localizations.localeOf(context)],
            decoration: InputDecoration(labelText: widget.l10n.degree),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _institution,
            hintLocales: [Localizations.localeOf(context)],
            decoration: InputDecoration(labelText: widget.l10n.institution),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _DateField(
                  label: Localizations.localeOf(context).languageCode == 'tr'
                      ? 'Başlangıç tarihi'
                      : 'Start date',
                  date: _startDate,
                  enabled: true,
                  onTap: () => _pickDate(start: true),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DateField(
                  label: Localizations.localeOf(context).languageCode == 'tr'
                      ? 'Bitiş tarihi'
                      : 'End date',
                  date: _endDate,
                  enabled: !_isCurrent,
                  onTap: () => _pickDate(start: false),
                ),
              ),
            ],
          ),
          CheckboxListTile(
            value: _isCurrent,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              Localizations.localeOf(context).languageCode == 'tr'
                  ? 'Halen okuyorum'
                  : 'I currently study here',
              style:
                  const TextStyle(color: AppColors.textPrimary, fontSize: 13),
            ),
            onChanged: (value) => setState(() {
              _isCurrent = value ?? false;
              if (_isCurrent) _endDate = null;
            }),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () =>
                      widget.notifier.removeEducation(widget.index),
                  child: Text(widget.l10n.delete),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveEducation,
                  child: Text(widget.l10n.save),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveEducation() {
    widget.notifier.updateEducation(
      widget.index,
      widget.education.copyWith(
        degree: _degree.text.trim(),
        institution: _institution.text.trim(),
        startDate: _startDate,
        endDate: _isCurrent ? null : _endDate,
        isCurrent: _isCurrent,
      ),
    );
    setState(() => _isExpanded = false);
  }

  Future<void> _pickDate({required bool start}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: (start ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (selected == null || !mounted) return;
    setState(() {
      if (start) {
        _startDate = selected;
      } else {
        _endDate = selected;
      }
    });
  }
}

class _SkillsStep extends StatelessWidget {
  final ResumeEditorState editorState;
  final ResumeEditorNotifier notifier;
  final AppLocalizations l10n;
  const _SkillsStep(
      {required this.editorState, required this.notifier, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final skillController = TextEditingController();
    return ListView(
      children: [
        Text(l10n.skillsStep,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        TextField(
          controller: skillController,
          hintLocales: [Localizations.localeOf(context)],
          decoration: InputDecoration(labelText: l10n.skill),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            final text = skillController.text.trim();
            if (text.isNotEmpty) {
              notifier.addSkill(Skill(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: text,
                  level: 'Intermediate'));
            }
          },
          icon: const Icon(Icons.add_rounded),
          label: Text(l10n.addSkill),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: editorState.resume.skills
              .map((skill) => Chip(label: Text(skill.name)))
              .toList(),
        ),
      ],
    );
  }
}

class _LanguagesStep extends StatelessWidget {
  const _LanguagesStep({
    required this.editorState,
    required this.notifier,
    required this.l10n,
  });

  final ResumeEditorState editorState;
  final ResumeEditorNotifier notifier;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final languageController = TextEditingController();
    final isTurkish = Localizations.localeOf(context).languageCode == 'tr';
    return ListView(
      children: [
        Text(
          isTurkish ? 'Diller' : 'Languages',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: languageController,
          hintLocales: [Localizations.localeOf(context)],
          decoration: InputDecoration(
            labelText: isTurkish ? 'Dil' : 'Language',
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            final text = languageController.text.trim();
            if (text.isNotEmpty) {
              notifier.addLanguage(
                LanguageProficiency(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  language: text,
                ),
              );
              languageController.clear();
            }
          },
          icon: const Icon(Icons.add_rounded),
          label: Text(isTurkish ? 'Dil ekle' : 'Add language'),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: editorState.resume.languages.asMap().entries.map((entry) {
            return InputChip(
              label: Text(entry.value.language),
              onDeleted: () => notifier.removeLanguage(entry.key),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ProjectsStep extends StatelessWidget {
  final ResumeEditorState editorState;
  final ResumeEditorNotifier notifier;
  final AppLocalizations l10n;

  const _ProjectsStep({
    required this.editorState,
    required this.notifier,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.projects,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            IconButton(
              onPressed: () => notifier.addProject(
                Project(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: '',
                  description: '',
                ),
              ),
              icon: const Icon(
                Icons.add_circle_rounded,
                color: AppColors.primaryLight,
              ),
              tooltip: l10n.addProject,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (editorState.resume.projects.isEmpty)
          Text(
            l10n.noProjectsYet,
            style: const TextStyle(color: AppColors.textSecondary),
          )
        else
          ...editorState.resume.projects.asMap().entries.map(
                (entry) => _ProjectCard(
                  key: ValueKey(entry.value.id),
                  index: entry.key,
                  project: entry.value,
                  notifier: notifier,
                  l10n: l10n,
                ),
              ),
      ],
    );
  }
}

class _ProjectCard extends StatefulWidget {
  const _ProjectCard({
    super.key,
    required this.index,
    required this.project,
    required this.notifier,
    required this.l10n,
  });

  final int index;
  final Project project;
  final ResumeEditorNotifier notifier;
  final AppLocalizations l10n;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  late final TextEditingController _titleController;
  late final TextEditingController _urlController;
  late final TextEditingController _technologiesController;
  late final TextEditingController _descriptionController;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project.title);
    _urlController = TextEditingController(text: widget.project.url ?? '');
    _technologiesController =
        TextEditingController(text: widget.project.technologies.join(', '));
    _descriptionController =
        TextEditingController(text: widget.project.description);
    _isExpanded = widget.project.title.trim().isEmpty &&
        widget.project.description.trim().isEmpty &&
        (widget.project.url ?? '').trim().isEmpty &&
        widget.project.technologies.isEmpty;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _technologiesController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isExpanded) {
      return _CollapsedEntryCard(
        title: _titleController.text.trim().isEmpty
            ? 'Project'
            : _titleController.text.trim(),
        subtitle: _technologiesController.text.trim(),
        icon: Icons.account_tree_outlined,
        margin: const EdgeInsets.only(top: 12),
        onTap: () => setState(() => _isExpanded = true),
      );
    }

    return GlassCard(
      margin: const EdgeInsets.only(top: 12),
      borderRadius: 12,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _input(widget.l10n.projectTitle, _titleController),
          _input(widget.l10n.projectUrl, _urlController),
          _input(widget.l10n.technologiesUsed, _technologiesController),
          _input(
            widget.l10n.projectDescription,
            _descriptionController,
            maxLines: 4,
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => widget.notifier.removeProject(widget.index),
                  child: Text(widget.l10n.delete),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveProject,
                  child: Text(widget.l10n.save),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveProject() {
    final url = _urlController.text.trim();
    widget.notifier.updateProject(
      widget.index,
      widget.project.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        url: url.isEmpty ? null : url,
        technologies: _technologiesController.text
            .split(',')
            .map((technology) => technology.trim())
            .where((technology) => technology.isNotEmpty)
            .toList(),
      ),
    );
    setState(() => _isExpanded = false);
  }

  Widget _input(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        hintLocales: [Localizations.localeOf(context)],
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

class _PhotoStep extends StatelessWidget {
  final ResumeEditorState editorState;
  final ResumeEditorNotifier notifier;
  final AppLocalizations l10n;

  const _PhotoStep({
    required this.editorState,
    required this.notifier,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final hasPhoto = editorState.photoBytes != null;

    return ListView(
      children: [
        Text(
          l10n.profilePhotoOptional,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.photoDisclaimer,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        Center(
          child: Container(
            width: 132,
            height: 132,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryLight, width: 1.5),
              color: AppColors.glassBackground,
            ),
            child: ClipOval(
              child: hasPhoto
                  ? Image.memory(editorState.photoBytes!, fit: BoxFit.cover)
                  : const ColoredBox(
                      color: AppColors.glassBackgroundStrong,
                      child: Icon(
                        Icons.person_outline_rounded,
                        color: AppColors.textSecondary,
                        size: 48,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () => _pickPhoto(),
          icon: Icon(
            hasPhoto ? Icons.photo_camera_outlined : Icons.upload_rounded,
          ),
          label: Text(hasPhoto ? l10n.changePhoto : l10n.uploadPhoto),
        ),
        if (hasPhoto) ...[
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => notifier.updatePhotoBytes(null),
            icon: const Icon(Icons.delete_outline_rounded),
            label: Text(l10n.removePhoto),
          ),
        ],
      ],
    );
  }

  Future<void> _pickPhoto() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1200,
    );
    if (image == null) {
      return;
    }

    notifier.updatePhotoBytes(await image.readAsBytes());
  }
}

class _SummaryStep extends StatelessWidget {
  final ResumeEditorState editorState;
  final ResumeEditorNotifier notifier;
  final AppLocalizations l10n;
  final TextEditingController summaryController;
  final VoidCallback onGenerate;
  const _SummaryStep(
      {required this.editorState,
      required this.notifier,
      required this.l10n,
      required this.summaryController,
      required this.onGenerate});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.summaryStep,
                style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800)),
            TextButton.icon(
                onPressed: onGenerate,
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: Text(l10n.enhanceWithAi)),
          ],
        ),
        TextField(
          controller: summaryController,
          maxLines: 10,
          hintLocales: [Localizations.localeOf(context)],
          decoration: InputDecoration(labelText: l10n.summaryHint),
          onChanged: notifier.updateSummary,
        ),
      ],
    );
  }
}
