import 'package:freezed_annotation/freezed_annotation.dart';

part 'resume_entity.freezed.dart';
part 'resume_entity.g.dart';

/// Root domain model for an entire resume profile.
/// Decoupled from any template, language, or rendering concern.
@freezed
class ResumeEntity with _$ResumeEntity {
  const factory ResumeEntity({
    required String id,
    @Default('local_user') String userId,
    required String title,
    @Default('en') String contentLanguage, // 'en' or 'tr'
    @Default('ats_classic') String templateId,
    @Default(0) int templateColorIndex,
    required HeaderInfo header,
    @Default([]) List<WorkExperience> workExperiences,
    @Default([]) List<Education> educationList,
    @Default([]) List<Skill> skills,
    @Default([]) List<Project> projects,
    @Default([]) List<Certification> certifications,
    @Default([]) List<LanguageProficiency> languages,
    @Default([]) List<CustomSection> customSections,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('') String summary,
    String? photoPath,
    @Default(false) bool isSynced,
    @Default(1) int schemaVersion,
    @Default(85) int atsScore,
  }) = _ResumeEntity;

  factory ResumeEntity.fromJson(Map<String, dynamic> json) =>
      _$ResumeEntityFromJson(json);
}

/// Contact & header block for the resume
@freezed
class HeaderInfo with _$HeaderInfo {
  const factory HeaderInfo({
    required String fullName,
    String? professionalTitle,
    String? email,
    String? phone,
    String? location,
    String? linkedinUrl,
    String? githubUrl,
    String? portfolioUrl,
  }) = _HeaderInfo;

  factory HeaderInfo.fromJson(Map<String, dynamic> json) =>
      _$HeaderInfoFromJson(json);
}

/// Single work experience entry
@freezed
class WorkExperience with _$WorkExperience {
  const factory WorkExperience({
    @Default('') String id,
    required String jobTitle,
    required String company,
    @Default('') String location,
    DateTime? startDate,
    DateTime? endDate,
    @Default(false) bool isCurrent,
    @Default([]) List<String> bulletPoints,
    @Default(false) bool isAiRefined,
  }) = _WorkExperience;

  factory WorkExperience.fromJson(Map<String, dynamic> json) =>
      _$WorkExperienceFromJson(json);
}

/// Education entry
@freezed
class Education with _$Education {
  const factory Education({
    @Default('') String id,
    required String degree,
    required String institution,
    @Default('') String location,
    DateTime? startDate,
    DateTime? endDate,
    @Default(false) bool isCurrent,
    String? gpa,
    @Default([]) List<String> highlights,
  }) = _Education;

  factory Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);
}

/// Individual skill with optional proficiency level
@freezed
class Skill with _$Skill {
  const factory Skill({
    @Default('') String id,
    required String name,
    @Default('intermediate')
    String level, // beginner, intermediate, advanced, expert
    @Default(false) bool isAiSuggested,
  }) = _Skill;

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);
}

/// Project entry for portfolio/project sections
@freezed
class Project with _$Project {
  const factory Project({
    @Default('') String id,
    required String title,
    required String description,
    String? url,
    @Default([]) List<String> technologies,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}

/// Certification entry
@freezed
class Certification with _$Certification {
  const factory Certification({
    @Default('') String id,
    required String name,
    required String issuer,
    DateTime? issueDate,
    DateTime? expiryDate,
    String? credentialUrl,
  }) = _Certification;

  factory Certification.fromJson(Map<String, dynamic> json) =>
      _$CertificationFromJson(json);
}

/// Language proficiency entry (spoken/written languages, NOT programming)
@freezed
class LanguageProficiency with _$LanguageProficiency {
  const factory LanguageProficiency({
    @Default('') String id,
    required String language,
    @Default('')
    String proficiency, // Native, Fluent, Advanced, Intermediate, Basic
  }) = _LanguageProficiency;

  factory LanguageProficiency.fromJson(Map<String, dynamic> json) =>
      _$LanguageProficiencyFromJson(json);
}

/// Custom user-defined section (Volunteering, Publications, etc.)
@freezed
class CustomSection with _$CustomSection {
  const factory CustomSection({
    @Default('') String id,
    required String title,
    @Default([]) List<String> items,
  }) = _CustomSection;

  factory CustomSection.fromJson(Map<String, dynamic> json) =>
      _$CustomSectionFromJson(json);
}
