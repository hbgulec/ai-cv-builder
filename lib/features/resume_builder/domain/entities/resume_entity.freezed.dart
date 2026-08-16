// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resume_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ResumeEntity _$ResumeEntityFromJson(Map<String, dynamic> json) {
  return _ResumeEntity.fromJson(json);
}

/// @nodoc
mixin _$ResumeEntity {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get contentLanguage =>
      throw _privateConstructorUsedError; // 'en' or 'tr'
  String get templateId => throw _privateConstructorUsedError;
  HeaderInfo get header => throw _privateConstructorUsedError;
  List<WorkExperience> get workExperiences =>
      throw _privateConstructorUsedError;
  List<Education> get educationList => throw _privateConstructorUsedError;
  List<Skill> get skills => throw _privateConstructorUsedError;
  List<Project> get projects => throw _privateConstructorUsedError;
  List<Certification> get certifications => throw _privateConstructorUsedError;
  List<LanguageProficiency> get languages => throw _privateConstructorUsedError;
  List<CustomSection> get customSections => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  String? get photoPath => throw _privateConstructorUsedError;
  bool get isSynced => throw _privateConstructorUsedError;
  int get schemaVersion => throw _privateConstructorUsedError;
  int get atsScore => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResumeEntityCopyWith<ResumeEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResumeEntityCopyWith<$Res> {
  factory $ResumeEntityCopyWith(
          ResumeEntity value, $Res Function(ResumeEntity) then) =
      _$ResumeEntityCopyWithImpl<$Res, ResumeEntity>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      String contentLanguage,
      String templateId,
      HeaderInfo header,
      List<WorkExperience> workExperiences,
      List<Education> educationList,
      List<Skill> skills,
      List<Project> projects,
      List<Certification> certifications,
      List<LanguageProficiency> languages,
      List<CustomSection> customSections,
      DateTime createdAt,
      DateTime updatedAt,
      String summary,
      String? photoPath,
      bool isSynced,
      int schemaVersion,
      int atsScore});

  $HeaderInfoCopyWith<$Res> get header;
}

/// @nodoc
class _$ResumeEntityCopyWithImpl<$Res, $Val extends ResumeEntity>
    implements $ResumeEntityCopyWith<$Res> {
  _$ResumeEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? contentLanguage = null,
    Object? templateId = null,
    Object? header = null,
    Object? workExperiences = null,
    Object? educationList = null,
    Object? skills = null,
    Object? projects = null,
    Object? certifications = null,
    Object? languages = null,
    Object? customSections = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? summary = null,
    Object? photoPath = freezed,
    Object? isSynced = null,
    Object? schemaVersion = null,
    Object? atsScore = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      contentLanguage: null == contentLanguage
          ? _value.contentLanguage
          : contentLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      header: null == header
          ? _value.header
          : header // ignore: cast_nullable_to_non_nullable
              as HeaderInfo,
      workExperiences: null == workExperiences
          ? _value.workExperiences
          : workExperiences // ignore: cast_nullable_to_non_nullable
              as List<WorkExperience>,
      educationList: null == educationList
          ? _value.educationList
          : educationList // ignore: cast_nullable_to_non_nullable
              as List<Education>,
      skills: null == skills
          ? _value.skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<Skill>,
      projects: null == projects
          ? _value.projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<Project>,
      certifications: null == certifications
          ? _value.certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<Certification>,
      languages: null == languages
          ? _value.languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<LanguageProficiency>,
      customSections: null == customSections
          ? _value.customSections
          : customSections // ignore: cast_nullable_to_non_nullable
              as List<CustomSection>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      photoPath: freezed == photoPath
          ? _value.photoPath
          : photoPath // ignore: cast_nullable_to_non_nullable
              as String?,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      schemaVersion: null == schemaVersion
          ? _value.schemaVersion
          : schemaVersion // ignore: cast_nullable_to_non_nullable
              as int,
      atsScore: null == atsScore
          ? _value.atsScore
          : atsScore // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $HeaderInfoCopyWith<$Res> get header {
    return $HeaderInfoCopyWith<$Res>(_value.header, (value) {
      return _then(_value.copyWith(header: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ResumeEntityImplCopyWith<$Res>
    implements $ResumeEntityCopyWith<$Res> {
  factory _$$ResumeEntityImplCopyWith(
          _$ResumeEntityImpl value, $Res Function(_$ResumeEntityImpl) then) =
      __$$ResumeEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      String contentLanguage,
      String templateId,
      HeaderInfo header,
      List<WorkExperience> workExperiences,
      List<Education> educationList,
      List<Skill> skills,
      List<Project> projects,
      List<Certification> certifications,
      List<LanguageProficiency> languages,
      List<CustomSection> customSections,
      DateTime createdAt,
      DateTime updatedAt,
      String summary,
      String? photoPath,
      bool isSynced,
      int schemaVersion,
      int atsScore});

  @override
  $HeaderInfoCopyWith<$Res> get header;
}

/// @nodoc
class __$$ResumeEntityImplCopyWithImpl<$Res>
    extends _$ResumeEntityCopyWithImpl<$Res, _$ResumeEntityImpl>
    implements _$$ResumeEntityImplCopyWith<$Res> {
  __$$ResumeEntityImplCopyWithImpl(
      _$ResumeEntityImpl _value, $Res Function(_$ResumeEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? contentLanguage = null,
    Object? templateId = null,
    Object? header = null,
    Object? workExperiences = null,
    Object? educationList = null,
    Object? skills = null,
    Object? projects = null,
    Object? certifications = null,
    Object? languages = null,
    Object? customSections = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? summary = null,
    Object? photoPath = freezed,
    Object? isSynced = null,
    Object? schemaVersion = null,
    Object? atsScore = null,
  }) {
    return _then(_$ResumeEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      contentLanguage: null == contentLanguage
          ? _value.contentLanguage
          : contentLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      header: null == header
          ? _value.header
          : header // ignore: cast_nullable_to_non_nullable
              as HeaderInfo,
      workExperiences: null == workExperiences
          ? _value._workExperiences
          : workExperiences // ignore: cast_nullable_to_non_nullable
              as List<WorkExperience>,
      educationList: null == educationList
          ? _value._educationList
          : educationList // ignore: cast_nullable_to_non_nullable
              as List<Education>,
      skills: null == skills
          ? _value._skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<Skill>,
      projects: null == projects
          ? _value._projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<Project>,
      certifications: null == certifications
          ? _value._certifications
          : certifications // ignore: cast_nullable_to_non_nullable
              as List<Certification>,
      languages: null == languages
          ? _value._languages
          : languages // ignore: cast_nullable_to_non_nullable
              as List<LanguageProficiency>,
      customSections: null == customSections
          ? _value._customSections
          : customSections // ignore: cast_nullable_to_non_nullable
              as List<CustomSection>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String,
      photoPath: freezed == photoPath
          ? _value.photoPath
          : photoPath // ignore: cast_nullable_to_non_nullable
              as String?,
      isSynced: null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      schemaVersion: null == schemaVersion
          ? _value.schemaVersion
          : schemaVersion // ignore: cast_nullable_to_non_nullable
              as int,
      atsScore: null == atsScore
          ? _value.atsScore
          : atsScore // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ResumeEntityImpl implements _ResumeEntity {
  const _$ResumeEntityImpl(
      {required this.id,
      this.userId = 'local_user',
      required this.title,
      this.contentLanguage = 'en',
      this.templateId = 'ats_classic',
      required this.header,
      final List<WorkExperience> workExperiences = const [],
      final List<Education> educationList = const [],
      final List<Skill> skills = const [],
      final List<Project> projects = const [],
      final List<Certification> certifications = const [],
      final List<LanguageProficiency> languages = const [],
      final List<CustomSection> customSections = const [],
      required this.createdAt,
      required this.updatedAt,
      this.summary = '',
      this.photoPath,
      this.isSynced = false,
      this.schemaVersion = 1,
      this.atsScore = 85})
      : _workExperiences = workExperiences,
        _educationList = educationList,
        _skills = skills,
        _projects = projects,
        _certifications = certifications,
        _languages = languages,
        _customSections = customSections;

  factory _$ResumeEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResumeEntityImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String userId;
  @override
  final String title;
  @override
  @JsonKey()
  final String contentLanguage;
// 'en' or 'tr'
  @override
  @JsonKey()
  final String templateId;
  @override
  final HeaderInfo header;
  final List<WorkExperience> _workExperiences;
  @override
  @JsonKey()
  List<WorkExperience> get workExperiences {
    if (_workExperiences is EqualUnmodifiableListView) return _workExperiences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_workExperiences);
  }

  final List<Education> _educationList;
  @override
  @JsonKey()
  List<Education> get educationList {
    if (_educationList is EqualUnmodifiableListView) return _educationList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_educationList);
  }

  final List<Skill> _skills;
  @override
  @JsonKey()
  List<Skill> get skills {
    if (_skills is EqualUnmodifiableListView) return _skills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skills);
  }

  final List<Project> _projects;
  @override
  @JsonKey()
  List<Project> get projects {
    if (_projects is EqualUnmodifiableListView) return _projects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projects);
  }

  final List<Certification> _certifications;
  @override
  @JsonKey()
  List<Certification> get certifications {
    if (_certifications is EqualUnmodifiableListView) return _certifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_certifications);
  }

  final List<LanguageProficiency> _languages;
  @override
  @JsonKey()
  List<LanguageProficiency> get languages {
    if (_languages is EqualUnmodifiableListView) return _languages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_languages);
  }

  final List<CustomSection> _customSections;
  @override
  @JsonKey()
  List<CustomSection> get customSections {
    if (_customSections is EqualUnmodifiableListView) return _customSections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customSections);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final String summary;
  @override
  final String? photoPath;
  @override
  @JsonKey()
  final bool isSynced;
  @override
  @JsonKey()
  final int schemaVersion;
  @override
  @JsonKey()
  final int atsScore;

  @override
  String toString() {
    return 'ResumeEntity(id: $id, userId: $userId, title: $title, contentLanguage: $contentLanguage, templateId: $templateId, header: $header, workExperiences: $workExperiences, educationList: $educationList, skills: $skills, projects: $projects, certifications: $certifications, languages: $languages, customSections: $customSections, createdAt: $createdAt, updatedAt: $updatedAt, summary: $summary, photoPath: $photoPath, isSynced: $isSynced, schemaVersion: $schemaVersion, atsScore: $atsScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResumeEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.contentLanguage, contentLanguage) ||
                other.contentLanguage == contentLanguage) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.header, header) || other.header == header) &&
            const DeepCollectionEquality()
                .equals(other._workExperiences, _workExperiences) &&
            const DeepCollectionEquality()
                .equals(other._educationList, _educationList) &&
            const DeepCollectionEquality().equals(other._skills, _skills) &&
            const DeepCollectionEquality().equals(other._projects, _projects) &&
            const DeepCollectionEquality()
                .equals(other._certifications, _certifications) &&
            const DeepCollectionEquality()
                .equals(other._languages, _languages) &&
            const DeepCollectionEquality()
                .equals(other._customSections, _customSections) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.photoPath, photoPath) ||
                other.photoPath == photoPath) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced) &&
            (identical(other.schemaVersion, schemaVersion) ||
                other.schemaVersion == schemaVersion) &&
            (identical(other.atsScore, atsScore) ||
                other.atsScore == atsScore));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        title,
        contentLanguage,
        templateId,
        header,
        const DeepCollectionEquality().hash(_workExperiences),
        const DeepCollectionEquality().hash(_educationList),
        const DeepCollectionEquality().hash(_skills),
        const DeepCollectionEquality().hash(_projects),
        const DeepCollectionEquality().hash(_certifications),
        const DeepCollectionEquality().hash(_languages),
        const DeepCollectionEquality().hash(_customSections),
        createdAt,
        updatedAt,
        summary,
        photoPath,
        isSynced,
        schemaVersion,
        atsScore
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResumeEntityImplCopyWith<_$ResumeEntityImpl> get copyWith =>
      __$$ResumeEntityImplCopyWithImpl<_$ResumeEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResumeEntityImplToJson(
      this,
    );
  }
}

abstract class _ResumeEntity implements ResumeEntity {
  const factory _ResumeEntity(
      {required final String id,
      final String userId,
      required final String title,
      final String contentLanguage,
      final String templateId,
      required final HeaderInfo header,
      final List<WorkExperience> workExperiences,
      final List<Education> educationList,
      final List<Skill> skills,
      final List<Project> projects,
      final List<Certification> certifications,
      final List<LanguageProficiency> languages,
      final List<CustomSection> customSections,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String summary,
      final String? photoPath,
      final bool isSynced,
      final int schemaVersion,
      final int atsScore}) = _$ResumeEntityImpl;

  factory _ResumeEntity.fromJson(Map<String, dynamic> json) =
      _$ResumeEntityImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get title;
  @override
  String get contentLanguage;
  @override // 'en' or 'tr'
  String get templateId;
  @override
  HeaderInfo get header;
  @override
  List<WorkExperience> get workExperiences;
  @override
  List<Education> get educationList;
  @override
  List<Skill> get skills;
  @override
  List<Project> get projects;
  @override
  List<Certification> get certifications;
  @override
  List<LanguageProficiency> get languages;
  @override
  List<CustomSection> get customSections;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String get summary;
  @override
  String? get photoPath;
  @override
  bool get isSynced;
  @override
  int get schemaVersion;
  @override
  int get atsScore;
  @override
  @JsonKey(ignore: true)
  _$$ResumeEntityImplCopyWith<_$ResumeEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HeaderInfo _$HeaderInfoFromJson(Map<String, dynamic> json) {
  return _HeaderInfo.fromJson(json);
}

/// @nodoc
mixin _$HeaderInfo {
  String get fullName => throw _privateConstructorUsedError;
  String? get professionalTitle => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get linkedinUrl => throw _privateConstructorUsedError;
  String? get githubUrl => throw _privateConstructorUsedError;
  String? get portfolioUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HeaderInfoCopyWith<HeaderInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HeaderInfoCopyWith<$Res> {
  factory $HeaderInfoCopyWith(
          HeaderInfo value, $Res Function(HeaderInfo) then) =
      _$HeaderInfoCopyWithImpl<$Res, HeaderInfo>;
  @useResult
  $Res call(
      {String fullName,
      String? professionalTitle,
      String? email,
      String? phone,
      String? location,
      String? linkedinUrl,
      String? githubUrl,
      String? portfolioUrl});
}

/// @nodoc
class _$HeaderInfoCopyWithImpl<$Res, $Val extends HeaderInfo>
    implements $HeaderInfoCopyWith<$Res> {
  _$HeaderInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? professionalTitle = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? location = freezed,
    Object? linkedinUrl = freezed,
    Object? githubUrl = freezed,
    Object? portfolioUrl = freezed,
  }) {
    return _then(_value.copyWith(
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      professionalTitle: freezed == professionalTitle
          ? _value.professionalTitle
          : professionalTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedinUrl: freezed == linkedinUrl
          ? _value.linkedinUrl
          : linkedinUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      githubUrl: freezed == githubUrl
          ? _value.githubUrl
          : githubUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      portfolioUrl: freezed == portfolioUrl
          ? _value.portfolioUrl
          : portfolioUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HeaderInfoImplCopyWith<$Res>
    implements $HeaderInfoCopyWith<$Res> {
  factory _$$HeaderInfoImplCopyWith(
          _$HeaderInfoImpl value, $Res Function(_$HeaderInfoImpl) then) =
      __$$HeaderInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String fullName,
      String? professionalTitle,
      String? email,
      String? phone,
      String? location,
      String? linkedinUrl,
      String? githubUrl,
      String? portfolioUrl});
}

/// @nodoc
class __$$HeaderInfoImplCopyWithImpl<$Res>
    extends _$HeaderInfoCopyWithImpl<$Res, _$HeaderInfoImpl>
    implements _$$HeaderInfoImplCopyWith<$Res> {
  __$$HeaderInfoImplCopyWithImpl(
      _$HeaderInfoImpl _value, $Res Function(_$HeaderInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? professionalTitle = freezed,
    Object? email = freezed,
    Object? phone = freezed,
    Object? location = freezed,
    Object? linkedinUrl = freezed,
    Object? githubUrl = freezed,
    Object? portfolioUrl = freezed,
  }) {
    return _then(_$HeaderInfoImpl(
      fullName: null == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      professionalTitle: freezed == professionalTitle
          ? _value.professionalTitle
          : professionalTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      linkedinUrl: freezed == linkedinUrl
          ? _value.linkedinUrl
          : linkedinUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      githubUrl: freezed == githubUrl
          ? _value.githubUrl
          : githubUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      portfolioUrl: freezed == portfolioUrl
          ? _value.portfolioUrl
          : portfolioUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HeaderInfoImpl implements _HeaderInfo {
  const _$HeaderInfoImpl(
      {required this.fullName,
      this.professionalTitle,
      this.email,
      this.phone,
      this.location,
      this.linkedinUrl,
      this.githubUrl,
      this.portfolioUrl});

  factory _$HeaderInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$HeaderInfoImplFromJson(json);

  @override
  final String fullName;
  @override
  final String? professionalTitle;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? location;
  @override
  final String? linkedinUrl;
  @override
  final String? githubUrl;
  @override
  final String? portfolioUrl;

  @override
  String toString() {
    return 'HeaderInfo(fullName: $fullName, professionalTitle: $professionalTitle, email: $email, phone: $phone, location: $location, linkedinUrl: $linkedinUrl, githubUrl: $githubUrl, portfolioUrl: $portfolioUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HeaderInfoImpl &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.professionalTitle, professionalTitle) ||
                other.professionalTitle == professionalTitle) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.linkedinUrl, linkedinUrl) ||
                other.linkedinUrl == linkedinUrl) &&
            (identical(other.githubUrl, githubUrl) ||
                other.githubUrl == githubUrl) &&
            (identical(other.portfolioUrl, portfolioUrl) ||
                other.portfolioUrl == portfolioUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, fullName, professionalTitle,
      email, phone, location, linkedinUrl, githubUrl, portfolioUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HeaderInfoImplCopyWith<_$HeaderInfoImpl> get copyWith =>
      __$$HeaderInfoImplCopyWithImpl<_$HeaderInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HeaderInfoImplToJson(
      this,
    );
  }
}

abstract class _HeaderInfo implements HeaderInfo {
  const factory _HeaderInfo(
      {required final String fullName,
      final String? professionalTitle,
      final String? email,
      final String? phone,
      final String? location,
      final String? linkedinUrl,
      final String? githubUrl,
      final String? portfolioUrl}) = _$HeaderInfoImpl;

  factory _HeaderInfo.fromJson(Map<String, dynamic> json) =
      _$HeaderInfoImpl.fromJson;

  @override
  String get fullName;
  @override
  String? get professionalTitle;
  @override
  String? get email;
  @override
  String? get phone;
  @override
  String? get location;
  @override
  String? get linkedinUrl;
  @override
  String? get githubUrl;
  @override
  String? get portfolioUrl;
  @override
  @JsonKey(ignore: true)
  _$$HeaderInfoImplCopyWith<_$HeaderInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WorkExperience _$WorkExperienceFromJson(Map<String, dynamic> json) {
  return _WorkExperience.fromJson(json);
}

/// @nodoc
mixin _$WorkExperience {
  String get id => throw _privateConstructorUsedError;
  String get jobTitle => throw _privateConstructorUsedError;
  String get company => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  bool get isCurrent => throw _privateConstructorUsedError;
  List<String> get bulletPoints => throw _privateConstructorUsedError;
  bool get isAiRefined => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WorkExperienceCopyWith<WorkExperience> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkExperienceCopyWith<$Res> {
  factory $WorkExperienceCopyWith(
          WorkExperience value, $Res Function(WorkExperience) then) =
      _$WorkExperienceCopyWithImpl<$Res, WorkExperience>;
  @useResult
  $Res call(
      {String id,
      String jobTitle,
      String company,
      String location,
      DateTime? startDate,
      DateTime? endDate,
      bool isCurrent,
      List<String> bulletPoints,
      bool isAiRefined});
}

/// @nodoc
class _$WorkExperienceCopyWithImpl<$Res, $Val extends WorkExperience>
    implements $WorkExperienceCopyWith<$Res> {
  _$WorkExperienceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? jobTitle = null,
    Object? company = null,
    Object? location = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isCurrent = null,
    Object? bulletPoints = null,
    Object? isAiRefined = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      jobTitle: null == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String,
      company: null == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCurrent: null == isCurrent
          ? _value.isCurrent
          : isCurrent // ignore: cast_nullable_to_non_nullable
              as bool,
      bulletPoints: null == bulletPoints
          ? _value.bulletPoints
          : bulletPoints // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isAiRefined: null == isAiRefined
          ? _value.isAiRefined
          : isAiRefined // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkExperienceImplCopyWith<$Res>
    implements $WorkExperienceCopyWith<$Res> {
  factory _$$WorkExperienceImplCopyWith(_$WorkExperienceImpl value,
          $Res Function(_$WorkExperienceImpl) then) =
      __$$WorkExperienceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String jobTitle,
      String company,
      String location,
      DateTime? startDate,
      DateTime? endDate,
      bool isCurrent,
      List<String> bulletPoints,
      bool isAiRefined});
}

/// @nodoc
class __$$WorkExperienceImplCopyWithImpl<$Res>
    extends _$WorkExperienceCopyWithImpl<$Res, _$WorkExperienceImpl>
    implements _$$WorkExperienceImplCopyWith<$Res> {
  __$$WorkExperienceImplCopyWithImpl(
      _$WorkExperienceImpl _value, $Res Function(_$WorkExperienceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? jobTitle = null,
    Object? company = null,
    Object? location = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isCurrent = null,
    Object? bulletPoints = null,
    Object? isAiRefined = null,
  }) {
    return _then(_$WorkExperienceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      jobTitle: null == jobTitle
          ? _value.jobTitle
          : jobTitle // ignore: cast_nullable_to_non_nullable
              as String,
      company: null == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCurrent: null == isCurrent
          ? _value.isCurrent
          : isCurrent // ignore: cast_nullable_to_non_nullable
              as bool,
      bulletPoints: null == bulletPoints
          ? _value._bulletPoints
          : bulletPoints // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isAiRefined: null == isAiRefined
          ? _value.isAiRefined
          : isAiRefined // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WorkExperienceImpl implements _WorkExperience {
  const _$WorkExperienceImpl(
      {this.id = '',
      required this.jobTitle,
      required this.company,
      this.location = '',
      this.startDate,
      this.endDate,
      this.isCurrent = false,
      final List<String> bulletPoints = const [],
      this.isAiRefined = false})
      : _bulletPoints = bulletPoints;

  factory _$WorkExperienceImpl.fromJson(Map<String, dynamic> json) =>
      _$$WorkExperienceImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  final String jobTitle;
  @override
  final String company;
  @override
  @JsonKey()
  final String location;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  @JsonKey()
  final bool isCurrent;
  final List<String> _bulletPoints;
  @override
  @JsonKey()
  List<String> get bulletPoints {
    if (_bulletPoints is EqualUnmodifiableListView) return _bulletPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bulletPoints);
  }

  @override
  @JsonKey()
  final bool isAiRefined;

  @override
  String toString() {
    return 'WorkExperience(id: $id, jobTitle: $jobTitle, company: $company, location: $location, startDate: $startDate, endDate: $endDate, isCurrent: $isCurrent, bulletPoints: $bulletPoints, isAiRefined: $isAiRefined)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkExperienceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.jobTitle, jobTitle) ||
                other.jobTitle == jobTitle) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isCurrent, isCurrent) ||
                other.isCurrent == isCurrent) &&
            const DeepCollectionEquality()
                .equals(other._bulletPoints, _bulletPoints) &&
            (identical(other.isAiRefined, isAiRefined) ||
                other.isAiRefined == isAiRefined));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      jobTitle,
      company,
      location,
      startDate,
      endDate,
      isCurrent,
      const DeepCollectionEquality().hash(_bulletPoints),
      isAiRefined);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkExperienceImplCopyWith<_$WorkExperienceImpl> get copyWith =>
      __$$WorkExperienceImplCopyWithImpl<_$WorkExperienceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WorkExperienceImplToJson(
      this,
    );
  }
}

abstract class _WorkExperience implements WorkExperience {
  const factory _WorkExperience(
      {final String id,
      required final String jobTitle,
      required final String company,
      final String location,
      final DateTime? startDate,
      final DateTime? endDate,
      final bool isCurrent,
      final List<String> bulletPoints,
      final bool isAiRefined}) = _$WorkExperienceImpl;

  factory _WorkExperience.fromJson(Map<String, dynamic> json) =
      _$WorkExperienceImpl.fromJson;

  @override
  String get id;
  @override
  String get jobTitle;
  @override
  String get company;
  @override
  String get location;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  bool get isCurrent;
  @override
  List<String> get bulletPoints;
  @override
  bool get isAiRefined;
  @override
  @JsonKey(ignore: true)
  _$$WorkExperienceImplCopyWith<_$WorkExperienceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Education _$EducationFromJson(Map<String, dynamic> json) {
  return _Education.fromJson(json);
}

/// @nodoc
mixin _$Education {
  String get id => throw _privateConstructorUsedError;
  String get degree => throw _privateConstructorUsedError;
  String get institution => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  bool get isCurrent => throw _privateConstructorUsedError;
  String? get gpa => throw _privateConstructorUsedError;
  List<String> get highlights => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EducationCopyWith<Education> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EducationCopyWith<$Res> {
  factory $EducationCopyWith(Education value, $Res Function(Education) then) =
      _$EducationCopyWithImpl<$Res, Education>;
  @useResult
  $Res call(
      {String id,
      String degree,
      String institution,
      String location,
      DateTime? startDate,
      DateTime? endDate,
      bool isCurrent,
      String? gpa,
      List<String> highlights});
}

/// @nodoc
class _$EducationCopyWithImpl<$Res, $Val extends Education>
    implements $EducationCopyWith<$Res> {
  _$EducationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? degree = null,
    Object? institution = null,
    Object? location = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isCurrent = null,
    Object? gpa = freezed,
    Object? highlights = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      degree: null == degree
          ? _value.degree
          : degree // ignore: cast_nullable_to_non_nullable
              as String,
      institution: null == institution
          ? _value.institution
          : institution // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCurrent: null == isCurrent
          ? _value.isCurrent
          : isCurrent // ignore: cast_nullable_to_non_nullable
              as bool,
      gpa: freezed == gpa
          ? _value.gpa
          : gpa // ignore: cast_nullable_to_non_nullable
              as String?,
      highlights: null == highlights
          ? _value.highlights
          : highlights // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EducationImplCopyWith<$Res>
    implements $EducationCopyWith<$Res> {
  factory _$$EducationImplCopyWith(
          _$EducationImpl value, $Res Function(_$EducationImpl) then) =
      __$$EducationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String degree,
      String institution,
      String location,
      DateTime? startDate,
      DateTime? endDate,
      bool isCurrent,
      String? gpa,
      List<String> highlights});
}

/// @nodoc
class __$$EducationImplCopyWithImpl<$Res>
    extends _$EducationCopyWithImpl<$Res, _$EducationImpl>
    implements _$$EducationImplCopyWith<$Res> {
  __$$EducationImplCopyWithImpl(
      _$EducationImpl _value, $Res Function(_$EducationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? degree = null,
    Object? institution = null,
    Object? location = null,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? isCurrent = null,
    Object? gpa = freezed,
    Object? highlights = null,
  }) {
    return _then(_$EducationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      degree: null == degree
          ? _value.degree
          : degree // ignore: cast_nullable_to_non_nullable
              as String,
      institution: null == institution
          ? _value.institution
          : institution // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isCurrent: null == isCurrent
          ? _value.isCurrent
          : isCurrent // ignore: cast_nullable_to_non_nullable
              as bool,
      gpa: freezed == gpa
          ? _value.gpa
          : gpa // ignore: cast_nullable_to_non_nullable
              as String?,
      highlights: null == highlights
          ? _value._highlights
          : highlights // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EducationImpl implements _Education {
  const _$EducationImpl(
      {this.id = '',
      required this.degree,
      required this.institution,
      this.location = '',
      this.startDate,
      this.endDate,
      this.isCurrent = false,
      this.gpa,
      final List<String> highlights = const []})
      : _highlights = highlights;

  factory _$EducationImpl.fromJson(Map<String, dynamic> json) =>
      _$$EducationImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  final String degree;
  @override
  final String institution;
  @override
  @JsonKey()
  final String location;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  @JsonKey()
  final bool isCurrent;
  @override
  final String? gpa;
  final List<String> _highlights;
  @override
  @JsonKey()
  List<String> get highlights {
    if (_highlights is EqualUnmodifiableListView) return _highlights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_highlights);
  }

  @override
  String toString() {
    return 'Education(id: $id, degree: $degree, institution: $institution, location: $location, startDate: $startDate, endDate: $endDate, isCurrent: $isCurrent, gpa: $gpa, highlights: $highlights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EducationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.degree, degree) || other.degree == degree) &&
            (identical(other.institution, institution) ||
                other.institution == institution) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.isCurrent, isCurrent) ||
                other.isCurrent == isCurrent) &&
            (identical(other.gpa, gpa) || other.gpa == gpa) &&
            const DeepCollectionEquality()
                .equals(other._highlights, _highlights));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      degree,
      institution,
      location,
      startDate,
      endDate,
      isCurrent,
      gpa,
      const DeepCollectionEquality().hash(_highlights));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EducationImplCopyWith<_$EducationImpl> get copyWith =>
      __$$EducationImplCopyWithImpl<_$EducationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EducationImplToJson(
      this,
    );
  }
}

abstract class _Education implements Education {
  const factory _Education(
      {final String id,
      required final String degree,
      required final String institution,
      final String location,
      final DateTime? startDate,
      final DateTime? endDate,
      final bool isCurrent,
      final String? gpa,
      final List<String> highlights}) = _$EducationImpl;

  factory _Education.fromJson(Map<String, dynamic> json) =
      _$EducationImpl.fromJson;

  @override
  String get id;
  @override
  String get degree;
  @override
  String get institution;
  @override
  String get location;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  bool get isCurrent;
  @override
  String? get gpa;
  @override
  List<String> get highlights;
  @override
  @JsonKey(ignore: true)
  _$$EducationImplCopyWith<_$EducationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Skill _$SkillFromJson(Map<String, dynamic> json) {
  return _Skill.fromJson(json);
}

/// @nodoc
mixin _$Skill {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get level =>
      throw _privateConstructorUsedError; // beginner, intermediate, advanced, expert
  bool get isAiSuggested => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SkillCopyWith<Skill> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SkillCopyWith<$Res> {
  factory $SkillCopyWith(Skill value, $Res Function(Skill) then) =
      _$SkillCopyWithImpl<$Res, Skill>;
  @useResult
  $Res call({String id, String name, String level, bool isAiSuggested});
}

/// @nodoc
class _$SkillCopyWithImpl<$Res, $Val extends Skill>
    implements $SkillCopyWith<$Res> {
  _$SkillCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? level = null,
    Object? isAiSuggested = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      isAiSuggested: null == isAiSuggested
          ? _value.isAiSuggested
          : isAiSuggested // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SkillImplCopyWith<$Res> implements $SkillCopyWith<$Res> {
  factory _$$SkillImplCopyWith(
          _$SkillImpl value, $Res Function(_$SkillImpl) then) =
      __$$SkillImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String level, bool isAiSuggested});
}

/// @nodoc
class __$$SkillImplCopyWithImpl<$Res>
    extends _$SkillCopyWithImpl<$Res, _$SkillImpl>
    implements _$$SkillImplCopyWith<$Res> {
  __$$SkillImplCopyWithImpl(
      _$SkillImpl _value, $Res Function(_$SkillImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? level = null,
    Object? isAiSuggested = null,
  }) {
    return _then(_$SkillImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String,
      isAiSuggested: null == isAiSuggested
          ? _value.isAiSuggested
          : isAiSuggested // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SkillImpl implements _Skill {
  const _$SkillImpl(
      {this.id = '',
      required this.name,
      this.level = 'intermediate',
      this.isAiSuggested = false});

  factory _$SkillImpl.fromJson(Map<String, dynamic> json) =>
      _$$SkillImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  final String name;
  @override
  @JsonKey()
  final String level;
// beginner, intermediate, advanced, expert
  @override
  @JsonKey()
  final bool isAiSuggested;

  @override
  String toString() {
    return 'Skill(id: $id, name: $name, level: $level, isAiSuggested: $isAiSuggested)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkillImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.isAiSuggested, isAiSuggested) ||
                other.isAiSuggested == isAiSuggested));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, level, isAiSuggested);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SkillImplCopyWith<_$SkillImpl> get copyWith =>
      __$$SkillImplCopyWithImpl<_$SkillImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SkillImplToJson(
      this,
    );
  }
}

abstract class _Skill implements Skill {
  const factory _Skill(
      {final String id,
      required final String name,
      final String level,
      final bool isAiSuggested}) = _$SkillImpl;

  factory _Skill.fromJson(Map<String, dynamic> json) = _$SkillImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get level;
  @override // beginner, intermediate, advanced, expert
  bool get isAiSuggested;
  @override
  @JsonKey(ignore: true)
  _$$SkillImplCopyWith<_$SkillImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Project _$ProjectFromJson(Map<String, dynamic> json) {
  return _Project.fromJson(json);
}

/// @nodoc
mixin _$Project {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  List<String> get technologies => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProjectCopyWith<Project> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjectCopyWith<$Res> {
  factory $ProjectCopyWith(Project value, $Res Function(Project) then) =
      _$ProjectCopyWithImpl<$Res, Project>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String? url,
      List<String> technologies});
}

/// @nodoc
class _$ProjectCopyWithImpl<$Res, $Val extends Project>
    implements $ProjectCopyWith<$Res> {
  _$ProjectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? url = freezed,
    Object? technologies = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      technologies: null == technologies
          ? _value.technologies
          : technologies // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjectImplCopyWith<$Res> implements $ProjectCopyWith<$Res> {
  factory _$$ProjectImplCopyWith(
          _$ProjectImpl value, $Res Function(_$ProjectImpl) then) =
      __$$ProjectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      String? url,
      List<String> technologies});
}

/// @nodoc
class __$$ProjectImplCopyWithImpl<$Res>
    extends _$ProjectCopyWithImpl<$Res, _$ProjectImpl>
    implements _$$ProjectImplCopyWith<$Res> {
  __$$ProjectImplCopyWithImpl(
      _$ProjectImpl _value, $Res Function(_$ProjectImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? url = freezed,
    Object? technologies = null,
  }) {
    return _then(_$ProjectImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      technologies: null == technologies
          ? _value._technologies
          : technologies // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjectImpl implements _Project {
  const _$ProjectImpl(
      {this.id = '',
      required this.title,
      required this.description,
      this.url,
      final List<String> technologies = const []})
      : _technologies = technologies;

  factory _$ProjectImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjectImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String? url;
  final List<String> _technologies;
  @override
  @JsonKey()
  List<String> get technologies {
    if (_technologies is EqualUnmodifiableListView) return _technologies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_technologies);
  }

  @override
  String toString() {
    return 'Project(id: $id, title: $title, description: $description, url: $url, technologies: $technologies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjectImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.url, url) || other.url == url) &&
            const DeepCollectionEquality()
                .equals(other._technologies, _technologies));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description, url,
      const DeepCollectionEquality().hash(_technologies));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjectImplCopyWith<_$ProjectImpl> get copyWith =>
      __$$ProjectImplCopyWithImpl<_$ProjectImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjectImplToJson(
      this,
    );
  }
}

abstract class _Project implements Project {
  const factory _Project(
      {final String id,
      required final String title,
      required final String description,
      final String? url,
      final List<String> technologies}) = _$ProjectImpl;

  factory _Project.fromJson(Map<String, dynamic> json) = _$ProjectImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  String? get url;
  @override
  List<String> get technologies;
  @override
  @JsonKey(ignore: true)
  _$$ProjectImplCopyWith<_$ProjectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Certification _$CertificationFromJson(Map<String, dynamic> json) {
  return _Certification.fromJson(json);
}

/// @nodoc
mixin _$Certification {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get issuer => throw _privateConstructorUsedError;
  DateTime? get issueDate => throw _privateConstructorUsedError;
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  String? get credentialUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CertificationCopyWith<Certification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CertificationCopyWith<$Res> {
  factory $CertificationCopyWith(
          Certification value, $Res Function(Certification) then) =
      _$CertificationCopyWithImpl<$Res, Certification>;
  @useResult
  $Res call(
      {String id,
      String name,
      String issuer,
      DateTime? issueDate,
      DateTime? expiryDate,
      String? credentialUrl});
}

/// @nodoc
class _$CertificationCopyWithImpl<$Res, $Val extends Certification>
    implements $CertificationCopyWith<$Res> {
  _$CertificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? issuer = null,
    Object? issueDate = freezed,
    Object? expiryDate = freezed,
    Object? credentialUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      issuer: null == issuer
          ? _value.issuer
          : issuer // ignore: cast_nullable_to_non_nullable
              as String,
      issueDate: freezed == issueDate
          ? _value.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      credentialUrl: freezed == credentialUrl
          ? _value.credentialUrl
          : credentialUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CertificationImplCopyWith<$Res>
    implements $CertificationCopyWith<$Res> {
  factory _$$CertificationImplCopyWith(
          _$CertificationImpl value, $Res Function(_$CertificationImpl) then) =
      __$$CertificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String issuer,
      DateTime? issueDate,
      DateTime? expiryDate,
      String? credentialUrl});
}

/// @nodoc
class __$$CertificationImplCopyWithImpl<$Res>
    extends _$CertificationCopyWithImpl<$Res, _$CertificationImpl>
    implements _$$CertificationImplCopyWith<$Res> {
  __$$CertificationImplCopyWithImpl(
      _$CertificationImpl _value, $Res Function(_$CertificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? issuer = null,
    Object? issueDate = freezed,
    Object? expiryDate = freezed,
    Object? credentialUrl = freezed,
  }) {
    return _then(_$CertificationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      issuer: null == issuer
          ? _value.issuer
          : issuer // ignore: cast_nullable_to_non_nullable
              as String,
      issueDate: freezed == issueDate
          ? _value.issueDate
          : issueDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      credentialUrl: freezed == credentialUrl
          ? _value.credentialUrl
          : credentialUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CertificationImpl implements _Certification {
  const _$CertificationImpl(
      {this.id = '',
      required this.name,
      required this.issuer,
      this.issueDate,
      this.expiryDate,
      this.credentialUrl});

  factory _$CertificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$CertificationImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  final String name;
  @override
  final String issuer;
  @override
  final DateTime? issueDate;
  @override
  final DateTime? expiryDate;
  @override
  final String? credentialUrl;

  @override
  String toString() {
    return 'Certification(id: $id, name: $name, issuer: $issuer, issueDate: $issueDate, expiryDate: $expiryDate, credentialUrl: $credentialUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CertificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.issuer, issuer) || other.issuer == issuer) &&
            (identical(other.issueDate, issueDate) ||
                other.issueDate == issueDate) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.credentialUrl, credentialUrl) ||
                other.credentialUrl == credentialUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, issuer, issueDate, expiryDate, credentialUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CertificationImplCopyWith<_$CertificationImpl> get copyWith =>
      __$$CertificationImplCopyWithImpl<_$CertificationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CertificationImplToJson(
      this,
    );
  }
}

abstract class _Certification implements Certification {
  const factory _Certification(
      {final String id,
      required final String name,
      required final String issuer,
      final DateTime? issueDate,
      final DateTime? expiryDate,
      final String? credentialUrl}) = _$CertificationImpl;

  factory _Certification.fromJson(Map<String, dynamic> json) =
      _$CertificationImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get issuer;
  @override
  DateTime? get issueDate;
  @override
  DateTime? get expiryDate;
  @override
  String? get credentialUrl;
  @override
  @JsonKey(ignore: true)
  _$$CertificationImplCopyWith<_$CertificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LanguageProficiency _$LanguageProficiencyFromJson(Map<String, dynamic> json) {
  return _LanguageProficiency.fromJson(json);
}

/// @nodoc
mixin _$LanguageProficiency {
  String get id => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  String get proficiency => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LanguageProficiencyCopyWith<LanguageProficiency> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LanguageProficiencyCopyWith<$Res> {
  factory $LanguageProficiencyCopyWith(
          LanguageProficiency value, $Res Function(LanguageProficiency) then) =
      _$LanguageProficiencyCopyWithImpl<$Res, LanguageProficiency>;
  @useResult
  $Res call({String id, String language, String proficiency});
}

/// @nodoc
class _$LanguageProficiencyCopyWithImpl<$Res, $Val extends LanguageProficiency>
    implements $LanguageProficiencyCopyWith<$Res> {
  _$LanguageProficiencyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? language = null,
    Object? proficiency = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      proficiency: null == proficiency
          ? _value.proficiency
          : proficiency // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LanguageProficiencyImplCopyWith<$Res>
    implements $LanguageProficiencyCopyWith<$Res> {
  factory _$$LanguageProficiencyImplCopyWith(_$LanguageProficiencyImpl value,
          $Res Function(_$LanguageProficiencyImpl) then) =
      __$$LanguageProficiencyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String language, String proficiency});
}

/// @nodoc
class __$$LanguageProficiencyImplCopyWithImpl<$Res>
    extends _$LanguageProficiencyCopyWithImpl<$Res, _$LanguageProficiencyImpl>
    implements _$$LanguageProficiencyImplCopyWith<$Res> {
  __$$LanguageProficiencyImplCopyWithImpl(_$LanguageProficiencyImpl _value,
      $Res Function(_$LanguageProficiencyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? language = null,
    Object? proficiency = null,
  }) {
    return _then(_$LanguageProficiencyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      proficiency: null == proficiency
          ? _value.proficiency
          : proficiency // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LanguageProficiencyImpl implements _LanguageProficiency {
  const _$LanguageProficiencyImpl(
      {this.id = '',
      required this.language,
      this.proficiency = 'Intermediate'});

  factory _$LanguageProficiencyImpl.fromJson(Map<String, dynamic> json) =>
      _$$LanguageProficiencyImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  final String language;
  @override
  @JsonKey()
  final String proficiency;

  @override
  String toString() {
    return 'LanguageProficiency(id: $id, language: $language, proficiency: $proficiency)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LanguageProficiencyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.proficiency, proficiency) ||
                other.proficiency == proficiency));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, language, proficiency);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LanguageProficiencyImplCopyWith<_$LanguageProficiencyImpl> get copyWith =>
      __$$LanguageProficiencyImplCopyWithImpl<_$LanguageProficiencyImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LanguageProficiencyImplToJson(
      this,
    );
  }
}

abstract class _LanguageProficiency implements LanguageProficiency {
  const factory _LanguageProficiency(
      {final String id,
      required final String language,
      final String proficiency}) = _$LanguageProficiencyImpl;

  factory _LanguageProficiency.fromJson(Map<String, dynamic> json) =
      _$LanguageProficiencyImpl.fromJson;

  @override
  String get id;
  @override
  String get language;
  @override
  String get proficiency;
  @override
  @JsonKey(ignore: true)
  _$$LanguageProficiencyImplCopyWith<_$LanguageProficiencyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CustomSection _$CustomSectionFromJson(Map<String, dynamic> json) {
  return _CustomSection.fromJson(json);
}

/// @nodoc
mixin _$CustomSection {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<String> get items => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CustomSectionCopyWith<CustomSection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomSectionCopyWith<$Res> {
  factory $CustomSectionCopyWith(
          CustomSection value, $Res Function(CustomSection) then) =
      _$CustomSectionCopyWithImpl<$Res, CustomSection>;
  @useResult
  $Res call({String id, String title, List<String> items});
}

/// @nodoc
class _$CustomSectionCopyWithImpl<$Res, $Val extends CustomSection>
    implements $CustomSectionCopyWith<$Res> {
  _$CustomSectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? items = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomSectionImplCopyWith<$Res>
    implements $CustomSectionCopyWith<$Res> {
  factory _$$CustomSectionImplCopyWith(
          _$CustomSectionImpl value, $Res Function(_$CustomSectionImpl) then) =
      __$$CustomSectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String title, List<String> items});
}

/// @nodoc
class __$$CustomSectionImplCopyWithImpl<$Res>
    extends _$CustomSectionCopyWithImpl<$Res, _$CustomSectionImpl>
    implements _$$CustomSectionImplCopyWith<$Res> {
  __$$CustomSectionImplCopyWithImpl(
      _$CustomSectionImpl _value, $Res Function(_$CustomSectionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? items = null,
  }) {
    return _then(_$CustomSectionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomSectionImpl implements _CustomSection {
  const _$CustomSectionImpl(
      {this.id = '', required this.title, final List<String> items = const []})
      : _items = items;

  factory _$CustomSectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomSectionImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  final String title;
  final List<String> _items;
  @override
  @JsonKey()
  List<String> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'CustomSection(id: $id, title: $title, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomSectionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, const DeepCollectionEquality().hash(_items));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomSectionImplCopyWith<_$CustomSectionImpl> get copyWith =>
      __$$CustomSectionImplCopyWithImpl<_$CustomSectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomSectionImplToJson(
      this,
    );
  }
}

abstract class _CustomSection implements CustomSection {
  const factory _CustomSection(
      {final String id,
      required final String title,
      final List<String> items}) = _$CustomSectionImpl;

  factory _CustomSection.fromJson(Map<String, dynamic> json) =
      _$CustomSectionImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  List<String> get items;
  @override
  @JsonKey(ignore: true)
  _$$CustomSectionImplCopyWith<_$CustomSectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
