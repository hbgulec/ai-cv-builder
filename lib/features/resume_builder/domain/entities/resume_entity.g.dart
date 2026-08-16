// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ResumeEntityImpl _$$ResumeEntityImplFromJson(Map<String, dynamic> json) =>
    _$ResumeEntityImpl(
      id: json['id'] as String,
      userId: json['userId'] as String? ?? 'local_user',
      title: json['title'] as String,
      contentLanguage: json['contentLanguage'] as String? ?? 'en',
      templateId: json['templateId'] as String? ?? 'ats_classic',
      header: HeaderInfo.fromJson(json['header'] as Map<String, dynamic>),
      workExperiences: (json['workExperiences'] as List<dynamic>?)
              ?.map((e) => WorkExperience.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      educationList: (json['educationList'] as List<dynamic>?)
              ?.map((e) => Education.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      projects: (json['projects'] as List<dynamic>?)
              ?.map((e) => Project.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      certifications: (json['certifications'] as List<dynamic>?)
              ?.map((e) => Certification.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) =>
                  LanguageProficiency.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      customSections: (json['customSections'] as List<dynamic>?)
              ?.map((e) => CustomSection.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      summary: json['summary'] as String? ?? '',
      photoPath: json['photoPath'] as String?,
      isSynced: json['isSynced'] as bool? ?? false,
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
      atsScore: (json['atsScore'] as num?)?.toInt() ?? 85,
    );

Map<String, dynamic> _$$ResumeEntityImplToJson(_$ResumeEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'contentLanguage': instance.contentLanguage,
      'templateId': instance.templateId,
      'header': instance.header,
      'workExperiences': instance.workExperiences,
      'educationList': instance.educationList,
      'skills': instance.skills,
      'projects': instance.projects,
      'certifications': instance.certifications,
      'languages': instance.languages,
      'customSections': instance.customSections,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'summary': instance.summary,
      'photoPath': instance.photoPath,
      'isSynced': instance.isSynced,
      'schemaVersion': instance.schemaVersion,
      'atsScore': instance.atsScore,
    };

_$HeaderInfoImpl _$$HeaderInfoImplFromJson(Map<String, dynamic> json) =>
    _$HeaderInfoImpl(
      fullName: json['fullName'] as String,
      professionalTitle: json['professionalTitle'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      location: json['location'] as String?,
      linkedinUrl: json['linkedinUrl'] as String?,
      githubUrl: json['githubUrl'] as String?,
      portfolioUrl: json['portfolioUrl'] as String?,
    );

Map<String, dynamic> _$$HeaderInfoImplToJson(_$HeaderInfoImpl instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'professionalTitle': instance.professionalTitle,
      'email': instance.email,
      'phone': instance.phone,
      'location': instance.location,
      'linkedinUrl': instance.linkedinUrl,
      'githubUrl': instance.githubUrl,
      'portfolioUrl': instance.portfolioUrl,
    };

_$WorkExperienceImpl _$$WorkExperienceImplFromJson(Map<String, dynamic> json) =>
    _$WorkExperienceImpl(
      id: json['id'] as String? ?? '',
      jobTitle: json['jobTitle'] as String,
      company: json['company'] as String,
      location: json['location'] as String? ?? '',
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      isCurrent: json['isCurrent'] as bool? ?? false,
      bulletPoints: (json['bulletPoints'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isAiRefined: json['isAiRefined'] as bool? ?? false,
    );

Map<String, dynamic> _$$WorkExperienceImplToJson(
        _$WorkExperienceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jobTitle': instance.jobTitle,
      'company': instance.company,
      'location': instance.location,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'isCurrent': instance.isCurrent,
      'bulletPoints': instance.bulletPoints,
      'isAiRefined': instance.isAiRefined,
    };

_$EducationImpl _$$EducationImplFromJson(Map<String, dynamic> json) =>
    _$EducationImpl(
      id: json['id'] as String? ?? '',
      degree: json['degree'] as String,
      institution: json['institution'] as String,
      location: json['location'] as String? ?? '',
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      isCurrent: json['isCurrent'] as bool? ?? false,
      gpa: json['gpa'] as String?,
      highlights: (json['highlights'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$EducationImplToJson(_$EducationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'degree': instance.degree,
      'institution': instance.institution,
      'location': instance.location,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'isCurrent': instance.isCurrent,
      'gpa': instance.gpa,
      'highlights': instance.highlights,
    };

_$SkillImpl _$$SkillImplFromJson(Map<String, dynamic> json) => _$SkillImpl(
      id: json['id'] as String? ?? '',
      name: json['name'] as String,
      level: json['level'] as String? ?? 'intermediate',
      isAiSuggested: json['isAiSuggested'] as bool? ?? false,
    );

Map<String, dynamic> _$$SkillImplToJson(_$SkillImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'level': instance.level,
      'isAiSuggested': instance.isAiSuggested,
    };

_$ProjectImpl _$$ProjectImplFromJson(Map<String, dynamic> json) =>
    _$ProjectImpl(
      id: json['id'] as String? ?? '',
      title: json['title'] as String,
      description: json['description'] as String,
      url: json['url'] as String?,
      technologies: (json['technologies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ProjectImplToJson(_$ProjectImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'url': instance.url,
      'technologies': instance.technologies,
    };

_$CertificationImpl _$$CertificationImplFromJson(Map<String, dynamic> json) =>
    _$CertificationImpl(
      id: json['id'] as String? ?? '',
      name: json['name'] as String,
      issuer: json['issuer'] as String,
      issueDate: json['issueDate'] == null
          ? null
          : DateTime.parse(json['issueDate'] as String),
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      credentialUrl: json['credentialUrl'] as String?,
    );

Map<String, dynamic> _$$CertificationImplToJson(_$CertificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'issuer': instance.issuer,
      'issueDate': instance.issueDate?.toIso8601String(),
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'credentialUrl': instance.credentialUrl,
    };

_$LanguageProficiencyImpl _$$LanguageProficiencyImplFromJson(
        Map<String, dynamic> json) =>
    _$LanguageProficiencyImpl(
      id: json['id'] as String? ?? '',
      language: json['language'] as String,
      proficiency: json['proficiency'] as String? ?? 'Intermediate',
    );

Map<String, dynamic> _$$LanguageProficiencyImplToJson(
        _$LanguageProficiencyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'language': instance.language,
      'proficiency': instance.proficiency,
    };

_$CustomSectionImpl _$$CustomSectionImplFromJson(Map<String, dynamic> json) =>
    _$CustomSectionImpl(
      id: json['id'] as String? ?? '',
      title: json['title'] as String,
      items:
          (json['items'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$CustomSectionImplToJson(_$CustomSectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'items': instance.items,
    };
