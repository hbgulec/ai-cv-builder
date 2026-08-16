import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:ai_cv_builder/l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/resume_entity.dart';
import '../providers/resume_provider.dart';

/// Interactive Resume Editor screen with Form Wizard on the left
/// and full dynamic EN/TR localization.
class ResumeEditorScreen extends ConsumerStatefulWidget {
  final String? resumeId;

  const ResumeEditorScreen({super.key, this.resumeId});

  @override
  ConsumerState<ResumeEditorScreen> createState() => _ResumeEditorScreenState();
}

class _ResumeEditorScreenState extends ConsumerState<ResumeEditorScreen> {
  late TextEditingController _cvTitleController;
  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _summaryController;

  @override
  void initState() {
    super.initState();

    // If resumeId is provided, load the saved resume into the editor
    if (widget.resumeId != null) {
      final savedResumes = ref.read(savedResumesProvider);
      final savedResume = savedResumes.where((r) => r.id == widget.resumeId).firstOrNull;
      if (savedResume != null) {
        // Schedule post-frame to avoid modifying provider during build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(resumeEditorProvider.notifier).loadResume(savedResume);
        });
        // Initialize controllers with saved data
        _cvTitleController = TextEditingController(text: savedResume.title);
        _nameController = TextEditingController(text: savedResume.header.fullName);
        _titleController = TextEditingController(text: savedResume.header.professionalTitle ?? '');
        _emailController = TextEditingController(text: savedResume.header.email ?? '');
        _phoneController = TextEditingController(text: savedResume.header.phone ?? '');
        _locationController = TextEditingController(text: savedResume.header.location ?? '');
        _summaryController = TextEditingController(text: savedResume.summary);
        return;
      }
    }

    // If no resumeId is provided, initialize a brand new blank resume with a fresh unique ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(resumeEditorProvider.notifier).resetNewResume();
    });
    _cvTitleController = TextEditingController(text: '');
    _nameController = TextEditingController(text: '');
    _titleController = TextEditingController(text: '');
    _emailController = TextEditingController(text: '');
    _phoneController = TextEditingController(text: '');
    _locationController = TextEditingController(text: '');
    _summaryController = TextEditingController(text: '');
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.darkBackgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.glassBackground,
                  border: Border(bottom: BorderSide(color: AppColors.glassBorder)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                          onPressed: () => context.pop(),
                        ),
                        const SizedBox(width: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              editorState.resume.title.isNotEmpty ? editorState.resume.title : l10n.personalInfo,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              l10n.autoSavedLocally,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Full Width Form Workspace
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Step Navigation Tabs
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _stepTab(0, l10n.headerStep, Icons.person_outline, editorState, notifier),
                            _stepTab(1, l10n.experienceStep, Icons.work_outline_rounded, editorState, notifier),
                            _stepTab(2, l10n.educationStep, Icons.school_outlined, editorState, notifier),
                            _stepTab(3, l10n.projectsStep, Icons.folder_special_outlined, editorState, notifier),
                            _stepTab(4, l10n.skillsStep, Icons.stars_rounded, editorState, notifier),
                            _stepTab(5, l10n.summaryStep, Icons.subject_rounded, editorState, notifier),
                            _stepTab(6, l10n.photoStep, Icons.photo_camera_outlined, editorState, notifier),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Step Form Content Card
                      Expanded(
                        child: GlassCard(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Expanded(
                                child: IndexedStack(
                                  index: editorState.activeStep,
                                  children: [
                                    _buildHeaderForm(notifier, l10n),
                                    _buildExperienceForm(editorState, notifier, l10n),
                                    _buildEducationForm(editorState, notifier, l10n),
                                    _buildProjectsForm(editorState, notifier, l10n),
                                    _buildSkillsForm(editorState, notifier, l10n),
                                    _buildSummaryForm(notifier, l10n),
                                    _buildPhotoForm(editorState, notifier, l10n),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              
                              // Form Step Bottom Controls
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (editorState.activeStep > 0)
                                    OutlinedButton.icon(
                                      onPressed: () => notifier.updateStep(editorState.activeStep - 1),
                                      icon: const Icon(Icons.arrow_back, size: 16, color: AppColors.textSecondary),
                                      label: Text(l10n.previous, style: const TextStyle(color: AppColors.textSecondary)),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: AppColors.glassBorder),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                    )
                                  else
                                    const SizedBox.shrink(),

                                  if (editorState.activeStep < 6)
                                    ElevatedButton.icon(
                                      onPressed: () => notifier.updateStep(editorState.activeStep + 1),
                                      icon: const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                                      label: Text(l10n.nextStep, style: const TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primaryIndigo,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                    )
                                  else
                                    AppButton(
                                      text: l10n.viewTemplatesFinish,
                                      icon: Icons.check_circle_outline_rounded,
                                      onPressed: () => context.push('/template-select'),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepTab(int stepIndex, String title, IconData icon, ResumeEditorState state, ResumeEditorNotifier notifier) {
    final isActive = state.activeStep == stepIndex;
    return GestureDetector(
      onTap: () => notifier.updateStep(stepIndex),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryIndigo : AppColors.glassBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.primaryIndigo : AppColors.glassBorder,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isActive ? Colors.white : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderForm(ResumeEditorNotifier notifier, AppLocalizations l10n) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.personalInfo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 16),
          _inputField(l10n.cvTitleLabel, _cvTitleController, (val) {
            notifier.updateTitle(val);
          }),
          _inputField(l10n.fullName, _nameController, (val) {
            notifier.updateHeader(ref.read(resumeEditorProvider).resume.header.copyWith(fullName: val));
          }),
          _inputField(l10n.professionalTitle, _titleController, (val) {
            notifier.updateHeader(ref.read(resumeEditorProvider).resume.header.copyWith(professionalTitle: val));
          }),
          _inputField(l10n.email, _emailController, (val) {
            notifier.updateHeader(ref.read(resumeEditorProvider).resume.header.copyWith(email: val));
          }),
          _inputField(l10n.phone, _phoneController, (val) {
            notifier.updateHeader(ref.read(resumeEditorProvider).resume.header.copyWith(phone: val));
          }),
          _inputField(l10n.location, _locationController, (val) {
            notifier.updateHeader(ref.read(resumeEditorProvider).resume.header.copyWith(location: val));
          }),
        ],
      ),
    );
  }

  Widget _buildSummaryForm(ResumeEditorNotifier notifier, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.summary, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            TextButton.icon(
              onPressed: () {
                final currentResume = ref.read(resumeEditorProvider).resume;
                final isTurkish = Localizations.localeOf(context).languageCode == 'tr';
                final generated = _generateSmartSummary(currentResume, isTurkish);
                _summaryController.text = generated;
                notifier.updateSummary(generated);
              },
              icon: const Icon(Icons.auto_awesome, size: 14, color: AppColors.accentViolet),
              label: Text(l10n.enhanceWithAi, style: const TextStyle(fontSize: 12, color: AppColors.accentViolet)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: TextField(
            controller: _summaryController,
            maxLines: null,
            expands: true,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
            decoration: InputDecoration(
              hintText: l10n.summaryHint,
              hintStyle: const TextStyle(color: AppColors.textMuted),
              filled: true,
              fillColor: Colors.black.withValues(alpha: 0.2),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.glassBorder)),
            ),
            onChanged: (val) => notifier.updateSummary(val),
          ),
        ),
      ],
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

      if (topSkills.isNotEmpty) {
        buffer.write('Özellikle $topSkills konularında derinlemesine bilgi ve yetkinliğe sahibim. ');
      }

      if (degree.isNotEmpty || inst.isNotEmpty) {
        final eduStr = [degree, inst].where((s) => s.isNotEmpty).join(' - ');
        buffer.write('$eduStr eğitimi ile güçlü bir teknik altyapı edindim. ');
      }

      if (projList.isNotEmpty) {
        buffer.write('Geliştirdiğim yenilikçi projelerle ölçeklenebilir ve yüksek performanslı çözümler ürettim. ');
      } else {
        buffer.write('Karmaşık problemleri analiz edip kullanıcı odaklı ve sürdürülebilir çözümler sunmaya odaklanıyorum. ');
      }

      buffer.write('Takım çalışmasına yatkın, sürekli öğrenmeye açık ve projelere değer katmayı hedefleyen bir yapıya sahibim.');
      return buffer.toString();
    } else {
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
        buffer.write('Proficient in $topSkills with expertise in building scalable applications. ');
      }

      if (degree.isNotEmpty || inst.isNotEmpty) {
        final eduStr = [degree, inst].where((s) => s.isNotEmpty).join(' from ');
        buffer.write('Holds an academic background in $eduStr. ');
      }

      if (projList.isNotEmpty) {
        buffer.write('Demonstrated ability to design and deliver high-impact end-to-end projects. ');
      } else {
        buffer.write('Passionate about continuous learning, problem-solving, and team collaboration. ');
      }

      return buffer.toString();
    }
  }

  Widget _buildExperienceForm(ResumeEditorState state, ResumeEditorNotifier notifier, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.workExperience, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            IconButton(
              icon: const Icon(Icons.add_circle, color: AppColors.primaryIndigo),
              onPressed: () {
                notifier.addWorkExperience(
                  WorkExperience(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    jobTitle: '',
                    company: '',
                    location: '',
                    bulletPoints: const [],
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: state.resume.workExperiences.length,
            itemBuilder: (context, index) {
              final exp = state.resume.workExperiences[index];
              return _WorkExperienceCard(
                key: ValueKey(exp.id.isNotEmpty ? exp.id : index),
                experience: exp,
                l10n: l10n,
                onUpdate: (updated) => notifier.updateWorkExperience(index, updated),
                onDelete: () => notifier.removeWorkExperience(index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEducationForm(ResumeEditorState state, ResumeEditorNotifier notifier, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.education, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            IconButton(
              icon: const Icon(Icons.add_circle, color: AppColors.primaryIndigo),
              onPressed: () {
                notifier.addEducation(
                  Education(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    degree: '',
                    institution: '',
                    location: '',
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: state.resume.educationList.length,
            itemBuilder: (context, index) {
              final edu = state.resume.educationList[index];
              return _EducationCard(
                key: ValueKey(edu.id.isNotEmpty ? edu.id : index),
                education: edu,
                l10n: l10n,
                onUpdate: (updated) => notifier.updateEducation(index, updated),
                onDelete: () => notifier.removeEducation(index),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsForm(ResumeEditorState state, ResumeEditorNotifier notifier, AppLocalizations l10n) {
    final skillController = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.skillsCompetencies, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: skillController,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  hintText: l10n.skillHint,
                  hintStyle: const TextStyle(color: AppColors.textMuted),
                  filled: true,
                  fillColor: Colors.black.withValues(alpha: 0.2),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.glassBorder)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            AppButton(
              text: l10n.addSkill,
              onPressed: () {
                if (skillController.text.trim().isNotEmpty) {
                  notifier.addSkill(Skill(name: skillController.text.trim(), id: DateTime.now().millisecondsSinceEpoch.toString()));
                  skillController.clear();
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: state.resume.skills.asMap().entries.map((entry) {
            final idx = entry.key;
            final skill = entry.value;
            return Chip(
              label: Text(skill.name, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
              backgroundColor: AppColors.glassBackground,
              side: BorderSide(color: AppColors.glassBorder),
              deleteIcon: const Icon(Icons.close, size: 14, color: AppColors.textMuted),
              onDeleted: () => notifier.removeSkill(idx),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildProjectsForm(ResumeEditorState state, ResumeEditorNotifier notifier, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.projects, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            IconButton(
              icon: const Icon(Icons.add_circle, color: AppColors.primaryIndigo),
              onPressed: () {
                notifier.addProject(
                  Project(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: '',
                    description: '',
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: state.resume.projects.isEmpty
              ? Center(
                  child: Text(
                    l10n.noProjectsYet,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                )
              : ListView.builder(
                  itemCount: state.resume.projects.length,
                  itemBuilder: (context, index) {
                    final project = state.resume.projects[index];
                    return _ProjectCard(
                      key: ValueKey(project.id.isNotEmpty ? project.id : index),
                      project: project,
                      l10n: l10n,
                      onUpdate: (updated) => notifier.updateProject(index, updated),
                      onDelete: () => notifier.removeProject(index),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildPhotoForm(ResumeEditorState state, ResumeEditorNotifier notifier, AppLocalizations l10n) {
    final photoBytes = state.photoBytes;
    final photoPath = state.resume.photoPath;
    final bool hasPhoto;
    if (kIsWeb) {
      hasPhoto = photoBytes != null && photoBytes.isNotEmpty;
    } else {
      hasPhoto = (photoBytes != null && photoBytes.isNotEmpty) ||
          (photoPath != null && photoPath.isNotEmpty && File(photoPath).existsSync());
    }

    Widget photoWidget;
    if (hasPhoto) {
      if (photoBytes != null && photoBytes.isNotEmpty) {
        photoWidget = Image.memory(
          photoBytes,
          fit: BoxFit.cover,
          width: 130,
          height: 130,
        );
      } else if (!kIsWeb && photoPath != null && photoPath.isNotEmpty) {
        photoWidget = Image.file(
          File(photoPath),
          fit: BoxFit.cover,
          width: 130,
          height: 130,
        );
      } else {
        photoWidget = const Icon(
          Icons.person_rounded,
          size: 70,
          color: AppColors.textMuted,
        );
      }
    } else {
      photoWidget = const Icon(
        Icons.person_rounded,
        size: 70,
        color: AppColors.textMuted,
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 12),
          Text(
            l10n.profilePhotoOptional,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.photoDisclaimer,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Center(
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.3),
                border: Border.all(color: AppColors.primaryIndigo, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryIndigo.withValues(alpha: 0.3),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: ClipOval(child: photoWidget),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    final bytes = await pickedFile.readAsBytes();
                    notifier.updatePhotoBytes(bytes);
                    if (!kIsWeb) {
                      notifier.updatePhotoPath(pickedFile.path);
                    }
                  }
                },
                icon: const Icon(Icons.photo_library_rounded, size: 18, color: Colors.white),
                label: Text(hasPhoto ? l10n.changePhoto : l10n.uploadPhoto, style: const TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryIndigo,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              if (hasPhoto) ...[
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    notifier.updatePhotoBytes(null);
                    notifier.updatePhotoPath(null);
                  },
                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                  label: Text(l10n.removePhoto, style: const TextStyle(color: Colors.redAccent)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black.withValues(alpha: 0.2),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.glassBorder)),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

String _formatDateForInput(DateTime? dt) {
  if (dt == null) return '';
  return '${dt.month.toString().padLeft(2, '0')}/${dt.year}';
}

DateTime? _parseDateString(String text) {
  final str = text.trim();
  if (str.isEmpty) return null;
  try {
    return DateTime.parse(str);
  } catch (_) {}

  final cleanStr = str.replaceAll(RegExp(r'[/\.\-\s]+'), '/');
  final parts = cleanStr.split('/');

  if (parts.length == 2) {
    final p1 = int.tryParse(parts[0].trim());
    final p2 = int.tryParse(parts[1].trim());

    if (p1 != null && p2 != null) {
      if (p1 >= 1 && p1 <= 12 && p2 > 1000) {
        return DateTime(p2, p1);
      }
      if (p1 > 1000 && p2 >= 1 && p2 <= 12) {
        return DateTime(p1, p2);
      }
    }
  } else if (parts.length == 3) {
    final p1 = int.tryParse(parts[0].trim());
    final p2 = int.tryParse(parts[1].trim());
    final p3 = int.tryParse(parts[2].trim());
    if (p1 != null && p2 != null && p3 != null) {
      if (p3 > 1000 && p2 >= 1 && p2 <= 12) {
        return DateTime(p3, p2, p1 > 31 ? 1 : p1);
      }
      if (p1 > 1000 && p2 >= 1 && p2 <= 12) {
        return DateTime(p1, p2, p3 > 31 ? 1 : p3);
      }
    }
  }

  final y = int.tryParse(str);
  if (y != null && y > 1900 && y < 2100) {
    return DateTime(y, 1);
  }

  return null;
}

/// Editable card for a single Work Experience entry
class _WorkExperienceCard extends StatefulWidget {
  final WorkExperience experience;
  final AppLocalizations l10n;
  final ValueChanged<WorkExperience> onUpdate;
  final VoidCallback onDelete;

  const _WorkExperienceCard({
    super.key,
    required this.experience,
    required this.l10n,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<_WorkExperienceCard> createState() => _WorkExperienceCardState();
}

class _WorkExperienceCardState extends State<_WorkExperienceCard> {
  late TextEditingController _jobTitleController;
  late TextEditingController _companyController;
  late TextEditingController _locationController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _bulletPointsController;
  late bool _isCurrent;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _jobTitleController = TextEditingController(text: widget.experience.jobTitle);
    _companyController = TextEditingController(text: widget.experience.company);
    _locationController = TextEditingController(text: widget.experience.location);
    _startDateController = TextEditingController(text: _formatDateForInput(widget.experience.startDate));
    _endDateController = TextEditingController(text: _formatDateForInput(widget.experience.endDate));
    _isCurrent = widget.experience.isCurrent;
    _bulletPointsController = TextEditingController(
      text: widget.experience.bulletPoints.join('\n'),
    );
    if (widget.experience.jobTitle.isEmpty && widget.experience.company.isEmpty) {
      _isExpanded = true;
    }
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _bulletPointsController.dispose();
    super.dispose();
  }

  void _emitUpdate() {
    final bulletPoints = _bulletPointsController.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    widget.onUpdate(widget.experience.copyWith(
      jobTitle: _jobTitleController.text,
      company: _companyController.text,
      location: _locationController.text,
      startDate: _parseDateString(_startDateController.text),
      endDate: _isCurrent ? null : _parseDateString(_endDateController.text),
      isCurrent: _isCurrent,
      bulletPoints: bulletPoints,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final hasContent = _jobTitleController.text.isNotEmpty || _companyController.text.isNotEmpty;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          // Header row — tap to expand/collapse
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasContent ? _jobTitleController.text : widget.l10n.newExperience,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: hasContent ? AppColors.textPrimary : AppColors.textMuted,
                          ),
                        ),
                        if (_companyController.text.isNotEmpty || _locationController.text.isNotEmpty)
                          Text(
                            [_companyController.text, _locationController.text]
                                .where((s) => s.isNotEmpty)
                                .join(' • '),
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
            ),
          ),
          // Editable fields
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                children: [
                  _cardField(widget.l10n.jobTitle, _jobTitleController, widget.l10n.jobTitleHint),
                  _cardField(widget.l10n.company, _companyController, widget.l10n.companyHint),
                  _cardField(widget.l10n.location, _locationController, widget.l10n.locationHint),
                  Row(
                    children: [
                      Expanded(
                        child: _cardField(widget.l10n.startDate, _startDateController, '01/2022'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _cardField(
                          widget.l10n.endDate,
                          _endDateController,
                          _isCurrent ? widget.l10n.currentlyWorkHere : '12/2023',
                          enabled: !_isCurrent,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _isCurrent,
                        activeColor: AppColors.primaryIndigo,
                        onChanged: (val) {
                          setState(() {
                            _isCurrent = val ?? false;
                          });
                          _emitUpdate();
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isCurrent = !_isCurrent;
                          });
                          _emitUpdate();
                        },
                        child: Text(
                          widget.l10n.currentlyWorkHere,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _bulletPointsController,
                    maxLines: 3,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                    decoration: InputDecoration(
                      labelText: widget.l10n.bulletPointsLabel,
                      labelStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                      hintText: widget.l10n.bulletPointsHint,
                      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                      filled: true,
                      fillColor: Colors.black.withValues(alpha: 0.15),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.glassBorder)),
                    ),
                    onChanged: (_) => _emitUpdate(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _cardField(String label, TextEditingController controller, String hint, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        enabled: enabled,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          filled: true,
          fillColor: enabled ? Colors.black.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.05),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.glassBorder)),
        ),
        onChanged: (_) => _emitUpdate(),
      ),
    );
  }
}

/// Editable card for a single Education entry
class _EducationCard extends StatefulWidget {
  final Education education;
  final AppLocalizations l10n;
  final ValueChanged<Education> onUpdate;
  final VoidCallback onDelete;

  const _EducationCard({
    super.key,
    required this.education,
    required this.l10n,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<_EducationCard> createState() => _EducationCardState();
}

class _EducationCardState extends State<_EducationCard> {
  late TextEditingController _degreeController;
  late TextEditingController _institutionController;
  late TextEditingController _locationController;
  late TextEditingController _gpaController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late bool _isCurrent;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _degreeController = TextEditingController(text: widget.education.degree);
    _institutionController = TextEditingController(text: widget.education.institution);
    _locationController = TextEditingController(text: widget.education.location);
    _gpaController = TextEditingController(text: widget.education.gpa ?? '');
    _startDateController = TextEditingController(text: _formatDateForInput(widget.education.startDate));
    _endDateController = TextEditingController(text: _formatDateForInput(widget.education.endDate));
    _isCurrent = widget.education.isCurrent;
    if (widget.education.degree.isEmpty && widget.education.institution.isEmpty) {
      _isExpanded = true;
    }
  }

  @override
  void dispose() {
    _degreeController.dispose();
    _institutionController.dispose();
    _locationController.dispose();
    _gpaController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void _emitUpdate() {
    widget.onUpdate(widget.education.copyWith(
      degree: _degreeController.text,
      institution: _institutionController.text,
      location: _locationController.text,
      gpa: _gpaController.text.isEmpty ? null : _gpaController.text,
      startDate: _parseDateString(_startDateController.text),
      endDate: _isCurrent ? null : _parseDateString(_endDateController.text),
      isCurrent: _isCurrent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final hasContent = _degreeController.text.isNotEmpty || _institutionController.text.isNotEmpty;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          // Header row — tap to expand/collapse
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasContent ? _degreeController.text : widget.l10n.newEducation,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: hasContent ? AppColors.textPrimary : AppColors.textMuted,
                          ),
                        ),
                        if (_institutionController.text.isNotEmpty)
                          Text(
                            _institutionController.text,
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
            ),
          ),
          // Editable fields
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                children: [
                  _cardField(widget.l10n.degree, _degreeController, widget.l10n.degreeHint),
                  _cardField(widget.l10n.institution, _institutionController, widget.l10n.institutionHint),
                  _cardField(widget.l10n.location, _locationController, widget.l10n.locationHint),
                  _cardField(widget.l10n.gpaOptional, _gpaController, widget.l10n.gpaHint),
                  Row(
                    children: [
                      Expanded(
                        child: _cardField(widget.l10n.startDate, _startDateController, '09/2018'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _cardField(
                          widget.l10n.endDate,
                          _endDateController,
                          _isCurrent ? widget.l10n.currentlyStudyHere : '06/2022',
                          enabled: !_isCurrent,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _isCurrent,
                        activeColor: AppColors.primaryIndigo,
                        onChanged: (val) {
                          setState(() {
                            _isCurrent = val ?? false;
                          });
                          _emitUpdate();
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isCurrent = !_isCurrent;
                          });
                          _emitUpdate();
                        },
                        child: Text(
                          widget.l10n.currentlyStudyHere,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _cardField(String label, TextEditingController controller, String hint, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        enabled: enabled,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          filled: true,
          fillColor: enabled ? Colors.black.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.05),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.glassBorder)),
        ),
        onChanged: (_) => _emitUpdate(),
      ),
    );
  }
}

/// Editable card for a single Project entry
class _ProjectCard extends StatefulWidget {
  final Project project;
  final AppLocalizations l10n;
  final ValueChanged<Project> onUpdate;
  final VoidCallback onDelete;

  const _ProjectCard({
    super.key,
    required this.project,
    required this.l10n,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _urlController;
  late TextEditingController _techController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project.title);
    _descriptionController = TextEditingController(text: widget.project.description);
    _urlController = TextEditingController(text: widget.project.url ?? '');
    _techController = TextEditingController(text: widget.project.technologies.join(', '));

    if (widget.project.title.isEmpty) {
      _isExpanded = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    _techController.dispose();
    super.dispose();
  }

  void _emitUpdate() {
    final techs = _techController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    widget.onUpdate(widget.project.copyWith(
      title: _titleController.text,
      description: _descriptionController.text,
      url: _urlController.text.isEmpty ? null : _urlController.text,
      technologies: techs,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final hasContent = _titleController.text.isNotEmpty;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          // Header row — tap to expand/collapse
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasContent ? _titleController.text : widget.l10n.newProject,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: hasContent ? AppColors.textPrimary : AppColors.textMuted,
                          ),
                        ),
                        if (_techController.text.isNotEmpty)
                          Text(
                            _techController.text,
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
            ),
          ),
          // Editable fields
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                children: [
                  _cardField(widget.l10n.projectTitle, _titleController, widget.l10n.projectTitleHint),
                  _cardField(widget.l10n.projectUrl, _urlController, widget.l10n.projectUrlHint),
                  _cardField(widget.l10n.technologiesUsed, _techController, widget.l10n.technologiesHint),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                    decoration: InputDecoration(
                      labelText: widget.l10n.projectDescription,
                      labelStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                      hintText: widget.l10n.projectDescHint,
                      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                      filled: true,
                      fillColor: Colors.black.withValues(alpha: 0.15),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.glassBorder)),
                    ),
                    onChanged: (_) => _emitUpdate(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _cardField(String label, TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          filled: true,
          fillColor: Colors.black.withValues(alpha: 0.15),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.glassBorder)),
        ),
        onChanged: (_) => _emitUpdate(),
      ),
    );
  }
}
