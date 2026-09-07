import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:ai_cv_builder/features/ats_optimizer/domain/services/ats_score_calculator.dart';
import '../../domain/entities/resume_entity.dart';

/// Result of a save operation.
enum SaveResult { success, proRequired }

enum TemplateCatalogFilter { all, free, pro }

/// State class for the active resume editing session.
class ResumeEditorState {
  final ResumeEntity resume;
  final int activeStep;
  final bool isSaving;
  final bool isGeneratingPdf;
  final String? errorMessage;
  final Uint8List? photoBytes;

  const ResumeEditorState({
    required this.resume,
    this.activeStep = 0,
    this.isSaving = false,
    this.isGeneratingPdf = false,
    this.errorMessage,
    this.photoBytes,
  });

  ResumeEditorState copyWith({
    ResumeEntity? resume,
    int? activeStep,
    bool? isSaving,
    bool? isGeneratingPdf,
    String? errorMessage,
    Uint8List? photoBytes,
    bool clearPhotoBytes = false,
  }) {
    return ResumeEditorState(
      resume: resume ?? this.resume,
      activeStep: activeStep ?? this.activeStep,
      isSaving: isSaving ?? this.isSaving,
      isGeneratingPdf: isGeneratingPdf ?? this.isGeneratingPdf,
      errorMessage: errorMessage,
      photoBytes: clearPhotoBytes ? null : (photoBytes ?? this.photoBytes),
    );
  }
}

/// StateNotifier to manage active resume editing state
class ResumeEditorNotifier extends StateNotifier<ResumeEditorState> {
  static const Uuid _uuid = Uuid();

  ResumeEditorNotifier([ResumeEntity? initialResume])
      : super(ResumeEditorState(
          resume: initialResume ?? _createBlankResume(),
        ));

  ResumeEntity get currentResume => state.resume;

  static ResumeEntity _createBlankResume() {
    return ResumeEntity(
      id: _uuid.v4(),
      userId: 'local_user',
      title: '',
      header: const HeaderInfo(
        fullName: '',
        professionalTitle: '',
        email: '',
        phone: '',
        location: '',
      ),
      templateId: 'ats_classic',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Resets the editor state to a brand new resume with a fresh unique ID and blank fields.
  void resetNewResume() {
    state = ResumeEditorState(
      resume: _createBlankResume(),
      activeStep: 0,
    );
  }

  /// Loads an existing saved resume into the editor for editing.
  void loadResume(ResumeEntity resume) {
    Uint8List? bytes;
    if (resume.photoPath != null && resume.photoPath!.isNotEmpty) {
      // Try data URI
      if (resume.photoPath!.startsWith('data:image')) {
        try {
          bytes = base64Decode(resume.photoPath!.split(',').last);
        } catch (_) {}
      }
      // Try raw base64 decode
      if (bytes == null) {
        try {
          final decoded = base64Decode(resume.photoPath!);
          if (decoded.isNotEmpty) bytes = decoded;
        } catch (_) {}
      }
      // File path fallback (native only)
      if (bytes == null && !kIsWeb) {
        try {
          final file = File(resume.photoPath!);
          if (file.existsSync()) {
            bytes = file.readAsBytesSync();
          }
        } catch (_) {}
      }
    }
    state = ResumeEditorState(
      resume: resume,
      activeStep: 0,
      photoBytes: bytes,
    );
  }

  void updateTitle(String title) {
    state = state.copyWith(
      resume: state.resume.copyWith(title: title, updatedAt: DateTime.now()),
    );
  }

  void updateStep(int step) {
    state = state.copyWith(activeStep: step);
  }

  void updateHeader(HeaderInfo header) {
    state = state.copyWith(
      resume: state.resume.copyWith(header: header, updatedAt: DateTime.now()),
    );
  }

  void updateSummary(String summary) {
    state = state.copyWith(
      resume:
          state.resume.copyWith(summary: summary, updatedAt: DateTime.now()),
    );
  }

  void addWorkExperience(WorkExperience exp) {
    final list = List<WorkExperience>.from(state.resume.workExperiences)
      ..add(exp);
    state = state.copyWith(
      resume: state.resume
          .copyWith(workExperiences: list, updatedAt: DateTime.now()),
    );
  }

  void updateWorkExperience(int index, WorkExperience exp) {
    final list = List<WorkExperience>.from(state.resume.workExperiences);
    list[index] = exp;
    state = state.copyWith(
      resume: state.resume
          .copyWith(workExperiences: list, updatedAt: DateTime.now()),
    );
  }

  void removeWorkExperience(int index) {
    final list = List<WorkExperience>.from(state.resume.workExperiences)
      ..removeAt(index);
    state = state.copyWith(
      resume: state.resume
          .copyWith(workExperiences: list, updatedAt: DateTime.now()),
    );
  }

  void addEducation(Education edu) {
    final list = List<Education>.from(state.resume.educationList)..add(edu);
    state = state.copyWith(
      resume:
          state.resume.copyWith(educationList: list, updatedAt: DateTime.now()),
    );
  }

  void removeEducation(int index) {
    final list = List<Education>.from(state.resume.educationList)
      ..removeAt(index);
    state = state.copyWith(
      resume:
          state.resume.copyWith(educationList: list, updatedAt: DateTime.now()),
    );
  }

  void updateEducation(int index, Education edu) {
    final list = List<Education>.from(state.resume.educationList);
    list[index] = edu;
    state = state.copyWith(
      resume:
          state.resume.copyWith(educationList: list, updatedAt: DateTime.now()),
    );
  }

  void addSkill(Skill skill) {
    final list = List<Skill>.from(state.resume.skills)..add(skill);
    state = state.copyWith(
      resume: state.resume.copyWith(skills: list, updatedAt: DateTime.now()),
    );
  }

  void removeSkill(int index) {
    final list = List<Skill>.from(state.resume.skills)..removeAt(index);
    state = state.copyWith(
      resume: state.resume.copyWith(skills: list, updatedAt: DateTime.now()),
    );
  }

  void addLanguage(LanguageProficiency language) {
    final list = List<LanguageProficiency>.from(state.resume.languages)
      ..add(language);
    state = state.copyWith(
      resume: state.resume.copyWith(languages: list, updatedAt: DateTime.now()),
    );
  }

  void removeLanguage(int index) {
    final list = List<LanguageProficiency>.from(state.resume.languages)
      ..removeAt(index);
    state = state.copyWith(
      resume: state.resume.copyWith(languages: list, updatedAt: DateTime.now()),
    );
  }

  void setTemplateId(String templateId) {
    state = state.copyWith(
      resume: state.resume.copyWith(
        templateId: templateId,
        templateColorIndex: 0,
        updatedAt: DateTime.now(),
      ),
    );
  }

  void setTemplateColorIndex(int colorIndex) {
    state = state.copyWith(
      resume: state.resume.copyWith(
        templateColorIndex: colorIndex.clamp(0, 4),
        updatedAt: DateTime.now(),
      ),
    );
  }

  void addProject(Project project) {
    final list = List<Project>.from(state.resume.projects)..add(project);
    state = state.copyWith(
      resume: state.resume.copyWith(projects: list, updatedAt: DateTime.now()),
    );
  }

  void updateProject(int index, Project project) {
    final list = List<Project>.from(state.resume.projects);
    list[index] = project;
    state = state.copyWith(
      resume: state.resume.copyWith(projects: list, updatedAt: DateTime.now()),
    );
  }

  void removeProject(int index) {
    final list = List<Project>.from(state.resume.projects)..removeAt(index);
    state = state.copyWith(
      resume: state.resume.copyWith(projects: list, updatedAt: DateTime.now()),
    );
  }

  void updatePhotoPath(String? path) {
    if (path == null) {
      state = state.copyWith(
        clearPhotoBytes: true,
        resume:
            state.resume.copyWith(photoPath: null, updatedAt: DateTime.now()),
      );
    } else {
      try {
        if (!kIsWeb) {
          final file = File(path);
          if (file.existsSync()) {
            final bytes = file.readAsBytesSync();
            final base64Str = base64Encode(bytes);
            state = state.copyWith(
              photoBytes: bytes,
              resume: state.resume
                  .copyWith(photoPath: base64Str, updatedAt: DateTime.now()),
            );
            return;
          }
        }
      } catch (_) {}
      state = state.copyWith(
        resume:
            state.resume.copyWith(photoPath: path, updatedAt: DateTime.now()),
      );
    }
  }

  void updatePhotoBytes(Uint8List? bytes) {
    if (bytes == null) {
      state = state.copyWith(
        clearPhotoBytes: true,
        resume:
            state.resume.copyWith(photoPath: null, updatedAt: DateTime.now()),
      );
    } else {
      final base64Str = base64Encode(bytes);
      state = state.copyWith(
        photoBytes: bytes,
        resume: state.resume
            .copyWith(photoPath: base64Str, updatedAt: DateTime.now()),
      );
    }
  }

  /// Saves the current editor resume into the saved resumes list with dynamic ATS score calculation.
  /// Returns [SaveResult.proRequired] when a non-PRO user chooses a PRO template.
  SaveResult saveCurrentResume(
      StateController<List<ResumeEntity>> savedNotifier,
      {required bool isPro,
      required bool selectedTemplateIsPremium}) {
    if (selectedTemplateIsPremium && !isPro) {
      return SaveResult.proRequired;
    }

    final computedScore = AtsScoreCalculator.calculateScore(state.resume);
    final resume = state.resume.copyWith(
      atsScore: computedScore,
      updatedAt: DateTime.now(),
    );
    state = state.copyWith(resume: resume);

    final list = List<ResumeEntity>.from(savedNotifier.state);
    final existingIndex = list.indexWhere((r) => r.id == resume.id);
    if (existingIndex >= 0) {
      // Updating existing resume — always allowed
      list[existingIndex] = resume;
    } else {
      // CV creation is free and unlimited; only selected templates are PRO.
      list.add(resume);
    }
    savedNotifier.state = list;
    return SaveResult.success;
  }
}

/// Riverpod provider for active resume editor state
final resumeEditorProvider =
    StateNotifierProvider<ResumeEditorNotifier, ResumeEditorState>((ref) {
  return ResumeEditorNotifier();
});

/// Riverpod provider listing user's saved resumes
final savedResumesProvider = StateProvider<List<ResumeEntity>>((ref) => []);

/// Whether the current user has a Pro subscription.
/// Defaults to false — toggled by purchase flow.
final isProUserProvider = StateProvider<bool>((ref) => false);

/// Current access filter for the mobile template catalogue.
final templateCatalogFilterProvider =
    StateProvider<TemplateCatalogFilter>((ref) => TemplateCatalogFilter.all);
