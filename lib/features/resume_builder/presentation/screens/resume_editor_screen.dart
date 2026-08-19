import 'package:flutter/material.dart';
import 'package:ai_cv_builder/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/soft_glass_shell.dart';
import '../../domain/entities/resume_entity.dart';
import '../providers/resume_provider.dart';

class ResumeEditorScreen extends ConsumerStatefulWidget {
  final String? resumeId;

  const ResumeEditorScreen({super.key, this.resumeId});

  @override
  ConsumerState<ResumeEditorScreen> createState() => _ResumeEditorScreenState();
}

class _ResumeEditorScreenState extends ConsumerState<ResumeEditorScreen> {
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
        _nameController = TextEditingController(text: loadedResume.header.fullName);
        _titleController = TextEditingController(text: loadedResume.header.professionalTitle ?? '');
        _emailController = TextEditingController(text: loadedResume.header.email ?? '');
        _phoneController = TextEditingController(text: loadedResume.header.phone ?? '');
        _locationController = TextEditingController(text: loadedResume.header.location ?? '');
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
                    IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            editorState.resume.title.isNotEmpty ? editorState.resume.title : l10n.personalInfo,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(l10n.autoSavedLocally, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: AppColors.glassBackground, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.glassBorder)),
                      child: Text('Step ${editorState.activeStep + 1}/5', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 11)),
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
                          style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.atsScoreLabel,
                              style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 7),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: (editorState.activeStep + 1) / 5,
                                minHeight: 4,
                                backgroundColor: Colors.white.withValues(alpha: 0.1),
                                valueColor: const AlwaysStoppedAnimation(AppColors.cyan),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              l10n.stepProgress(editorState.activeStep + 1, 5),
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 9),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.layers_outlined, size: 18, color: AppColors.textPrimary),
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
                      _stepChip(4, l10n.summaryStep, editorState, notifier),
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
                          child: SlideTransition(position: offset, child: child),
                        );
                      },
                      child: IndexedStack(
                        key: ValueKey(editorState.activeStep),
                        index: editorState.activeStep.clamp(0, 4),
                        children: [
                          _HeaderStep(notifier: notifier, header: editorState.resume.header, l10n: l10n, cvTitleController: _cvTitleController, nameController: _nameController, titleController: _titleController, emailController: _emailController, phoneController: _phoneController, locationController: _locationController),
                          _ExperienceStep(editorState: editorState, notifier: notifier, l10n: l10n),
                          _EducationStep(editorState: editorState, notifier: notifier, l10n: l10n),
                          _SkillsStep(editorState: editorState, notifier: notifier, l10n: l10n),
                          _SummaryStep(editorState: editorState, notifier: notifier, l10n: l10n, summaryController: _summaryController, onGenerate: () {
                            final currentResume = ref.read(resumeEditorProvider).resume;
                            final isTurkish = Localizations.localeOf(context).languageCode == 'tr';
                            final generated = _generateSmartSummary(currentResume, isTurkish);
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
                        onPressed: editorState.activeStep == 0 ? null : () => notifier.updateStep(editorState.activeStep - 1),
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: Text(l10n.previous),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: editorState.activeStep < 4 ? () => notifier.updateStep(editorState.activeStep + 1) : () => context.push('/template-select'),
                        icon: Icon(editorState.activeStep < 4 ? Icons.arrow_forward_rounded : Icons.check_circle_outline_rounded),
                        label: Text(editorState.activeStep < 4 ? l10n.nextStep : l10n.viewTemplatesFinish),
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

  Widget _stepChip(int index, String label, ResumeEditorState state, ResumeEditorNotifier notifier) {
    final active = state.activeStep == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        selected: active,
        onSelected: (_) => notifier.updateStep(index),
        label: Text(label),
        labelStyle: TextStyle(color: active ? Colors.white : AppColors.textSecondary, fontWeight: FontWeight.w700, fontSize: 12),
        selectedColor: AppColors.primaryIndigo,
        backgroundColor: AppColors.glassBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: active ? AppColors.primaryLight : AppColors.glassBorder),
        ),
        showCheckmark: false,
      ),
    );
  }

  String _generateSmartSummary(ResumeEntity resume, bool isTurkish) {
    final header = resume.header;
    final title = header.professionalTitle?.trim().isNotEmpty == true ? header.professionalTitle!.trim() : (isTurkish ? 'Yazılım Uzmanı' : 'Software Professional');
    final expList = resume.workExperiences;
    final latestExp = expList.isNotEmpty ? expList.first : null;
    final company = latestExp?.company.trim() ?? '';
    final jobTitle = latestExp?.jobTitle.trim() ?? '';
    final skillsList = resume.skills.map((s) => s.name.trim()).where((s) => s.isNotEmpty).toList();
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
      if (topSkills.isNotEmpty) buffer.write('Özellikle $topSkills konularında derinlemesine bilgi ve yetkinliğe sahibim. ');
      if (degree.isNotEmpty || inst.isNotEmpty) buffer.write('${[degree, inst].where((s) => s.isNotEmpty).join(' - ')} eğitimi ile güçlü bir teknik altyapı edindim. ');
      if (projList.isNotEmpty) {
        buffer.write('Geliştirdiğim yenilikçi projelerle ölçeklenebilir ve yüksek performanslı çözümler ürettim. ');
      } else {
        buffer.write('Karmaşık problemleri analiz edip kullanıcı odaklı ve sürdürülebilir çözümler sunmaya odaklanıyorum. ');
      }
      buffer.write('Takım çalışmasına yatkın, sürekli öğrenmeye açık ve projelere değer katmayı hedefleyen bir yapıya sahibim.');
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
    if (topSkills.isNotEmpty) buffer.write('Proficient in $topSkills with expertise in building scalable applications. ');
    if (degree.isNotEmpty || inst.isNotEmpty) buffer.write('Holds an academic background in ${[degree, inst].where((s) => s.isNotEmpty).join(' from ')}. ');
    if (projList.isNotEmpty) {
      buffer.write('Demonstrated ability to design and deliver high-impact end-to-end projects. ');
    } else {
      buffer.write('Passionate about continuous learning, problem-solving, and team collaboration. ');
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

  const _HeaderStep({required this.notifier, required this.header, required this.l10n, required this.cvTitleController, required this.nameController, required this.titleController, required this.emailController, required this.phoneController, required this.locationController});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(l10n.personalInfo, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        _field(l10n.cvTitleLabel, cvTitleController, (val) => notifier.updateTitle(val)),
        _field(l10n.fullName, nameController, (val) => notifier.updateHeader(header.copyWith(fullName: val))),
        _field(l10n.professionalTitle, titleController, (val) => notifier.updateHeader(header.copyWith(professionalTitle: val))),
        _field(l10n.email, emailController, (val) => notifier.updateHeader(header.copyWith(email: val))),
        _field(l10n.phone, phoneController, (val) => notifier.updateHeader(header.copyWith(phone: val))),
        _field(l10n.location, locationController, (val) => notifier.updateHeader(header.copyWith(location: val))),
      ],
    );
  }

  Widget _field(String label, TextEditingController controller, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

class _ExperienceStep extends StatelessWidget {
  final ResumeEditorState editorState;
  final ResumeEditorNotifier notifier;
  final AppLocalizations l10n;

  const _ExperienceStep({required this.editorState, required this.notifier, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Experience', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
            IconButton(
              onPressed: () => notifier.addWorkExperience(WorkExperience(id: DateTime.now().millisecondsSinceEpoch.toString(), jobTitle: '', company: '', location: '', bulletPoints: const [])),
              icon: const Icon(Icons.add_circle_rounded, color: AppColors.primaryLight),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (editorState.resume.workExperiences.isEmpty)
          const Text('Tap + to add your first role.', style: TextStyle(color: AppColors.textSecondary))
        else
          ...editorState.resume.workExperiences.asMap().entries.map((entry) => _ExperienceCard(index: entry.key, exp: entry.value, notifier: notifier, l10n: l10n)),
      ],
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  final int index;
  final WorkExperience exp;
  final ResumeEditorNotifier notifier;
  final AppLocalizations l10n;
  const _ExperienceCard({required this.index, required this.exp, required this.notifier, required this.l10n});
  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  late final TextEditingController _job;
  late final TextEditingController _company;
  late final TextEditingController _location;
  late final TextEditingController _bullets;

  @override
  void initState() {
    super.initState();
    _job = TextEditingController(text: widget.exp.jobTitle);
    _company = TextEditingController(text: widget.exp.company);
    _location = TextEditingController(text: widget.exp.location);
    _bullets = TextEditingController(text: widget.exp.bulletPoints.join('\n'));
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
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      borderRadius: 12,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _input(widget.l10n.jobTitle, _job),
          _input(widget.l10n.company, _company),
          _input(widget.l10n.location, _location),
          _input(widget.l10n.bulletPointsLabel, _bullets, maxLines: 4),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => widget.notifier.removeWorkExperience(widget.index),
                  child: const Text('Delete'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.notifier.updateWorkExperience(
                      widget.index,
                      widget.exp.copyWith(
                        jobTitle: _job.text,
                        company: _company.text,
                        location: _location.text,
                        bulletPoints: _bullets.text.split('\n').where((s) => s.trim().isNotEmpty).toList(),
                      ),
                    );
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _input(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

class _EducationStep extends StatelessWidget {
  final ResumeEditorState editorState;
  final ResumeEditorNotifier notifier;
  final AppLocalizations l10n;

  const _EducationStep({required this.editorState, required this.notifier, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Education', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
            IconButton(
              onPressed: () => notifier.addEducation(Education(id: DateTime.now().millisecondsSinceEpoch.toString(), degree: '', institution: '', location: '', startDate: DateTime.now(), endDate: null, isCurrent: false)),
              icon: const Icon(Icons.add_circle_rounded, color: AppColors.primaryLight),
            ),
          ],
        ),
        if (editorState.resume.educationList.isEmpty)
          const Text('Tap + to add education.', style: TextStyle(color: AppColors.textSecondary))
        else
          ...editorState.resume.educationList.asMap().entries.map((entry) => _EducationCardRow(index: entry.key, education: entry.value, notifier: notifier, l10n: l10n)),
      ],
    );
  }
}

class _EducationCardRow extends StatelessWidget {
  final int index;
  final Education education;
  final ResumeEditorNotifier notifier;
  final AppLocalizations l10n;
  const _EducationCardRow({required this.index, required this.education, required this.notifier, required this.l10n});
  @override
  Widget build(BuildContext context) {
    final degree = TextEditingController(text: education.degree);
    final institution = TextEditingController(text: education.institution);
    return GlassCard(
      margin: const EdgeInsets.only(top: 12),
      borderRadius: 12,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(controller: degree, decoration: InputDecoration(labelText: l10n.degree)),
          const SizedBox(height: 10),
          TextField(controller: institution, decoration: InputDecoration(labelText: l10n.institution)),
          Row(
            children: [
              Expanded(child: TextButton(onPressed: () => notifier.removeEducation(index), child: const Text('Delete'))),
              Expanded(child: ElevatedButton(onPressed: () => notifier.updateEducation(index, education.copyWith(degree: degree.text, institution: institution.text)), child: const Text('Save'))),
            ],
          ),
        ],
      ),
    );
  }
}

class _SkillsStep extends StatelessWidget {
  final ResumeEditorState editorState;
  final ResumeEditorNotifier notifier;
  final AppLocalizations l10n;
  const _SkillsStep({required this.editorState, required this.notifier, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final skillController = TextEditingController();
    return ListView(
      children: [
        const Text('Skills', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        TextField(controller: skillController, decoration: const InputDecoration(labelText: 'Skill')),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            final text = skillController.text.trim();
            if (text.isNotEmpty) notifier.addSkill(Skill(id: DateTime.now().millisecondsSinceEpoch.toString(), name: text, level: 'Intermediate'));
          },
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add skill'),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: editorState.resume.skills.map((skill) => Chip(label: Text(skill.name))).toList(),
        ),
      ],
    );
  }
}

class _SummaryStep extends StatelessWidget {
  final ResumeEditorState editorState;
  final ResumeEditorNotifier notifier;
  final AppLocalizations l10n;
  final TextEditingController summaryController;
  final VoidCallback onGenerate;
  const _SummaryStep({required this.editorState, required this.notifier, required this.l10n, required this.summaryController, required this.onGenerate});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Summary', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w800)),
            TextButton.icon(onPressed: onGenerate, icon: const Icon(Icons.auto_awesome, size: 16), label: Text(l10n.enhanceWithAi)),
          ],
        ),
        TextField(
          controller: summaryController,
          maxLines: 10,
          decoration: InputDecoration(labelText: l10n.summaryHint),
          onChanged: notifier.updateSummary,
        ),
      ],
    );
  }
}
