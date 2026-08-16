import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'AI CV Builder'**
  String get appTitle;

  /// No description provided for @atsOptimizedSub.
  ///
  /// In en, this message translates to:
  /// **'ATS-Optimized Resumes'**
  String get atsOptimizedSub;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'My Resumes'**
  String get dashboardTitle;

  /// No description provided for @createNewCv.
  ///
  /// In en, this message translates to:
  /// **'New Resume'**
  String get createNewCv;

  /// No description provided for @aiCreditsRemaining.
  ///
  /// In en, this message translates to:
  /// **'{count} AI Credits Left'**
  String aiCreditsRemaining(Object count);

  /// No description provided for @stepProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String stepProgress(Object current, Object total);

  /// No description provided for @enhanceWithAi.
  ///
  /// In en, this message translates to:
  /// **'AI Enhance'**
  String get enhanceWithAi;

  /// No description provided for @generatingAiSummary.
  ///
  /// In en, this message translates to:
  /// **'Crafting professional summary...'**
  String get generatingAiSummary;

  /// No description provided for @aiDiffOriginal.
  ///
  /// In en, this message translates to:
  /// **'Original Text'**
  String get aiDiffOriginal;

  /// No description provided for @aiDiffSuggested.
  ///
  /// In en, this message translates to:
  /// **'AI Polished Suggestion'**
  String get aiDiffSuggested;

  /// No description provided for @applySuggestion.
  ///
  /// In en, this message translates to:
  /// **'Apply Suggestion'**
  String get applySuggestion;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @atsScoreLabel.
  ///
  /// In en, this message translates to:
  /// **'ATS Match Score'**
  String get atsScoreLabel;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @offlineWarning.
  ///
  /// In en, this message translates to:
  /// **'You are currently offline. AI features require an internet connection.'**
  String get offlineWarning;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock AI CV Builder Pro'**
  String get paywallTitle;

  /// No description provided for @heroBadge.
  ///
  /// In en, this message translates to:
  /// **'⚡ AI POWERED'**
  String get heroBadge;

  /// No description provided for @heroTitle.
  ///
  /// In en, this message translates to:
  /// **'Craft a Job-Winning Resume'**
  String get heroTitle;

  /// No description provided for @heroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose from 6 ATS-compliant templates, enhance bullet points with AI, and export print-ready PDFs without UI lag.'**
  String get heroSubtitle;

  /// No description provided for @yourResumes.
  ///
  /// In en, this message translates to:
  /// **'Your Resumes'**
  String get yourResumes;

  /// No description provided for @resumesSavedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} saved'**
  String resumesSavedCount(Object count);

  /// No description provided for @noResumesYet.
  ///
  /// In en, this message translates to:
  /// **'No resumes created yet'**
  String get noResumesYet;

  /// No description provided for @createFirstResume.
  ///
  /// In en, this message translates to:
  /// **'Create First Resume'**
  String get createFirstResume;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @downloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get downloadPdf;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @headerStep.
  ///
  /// In en, this message translates to:
  /// **'Contact Info'**
  String get headerStep;

  /// No description provided for @summaryStep.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summaryStep;

  /// No description provided for @experienceStep.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experienceStep;

  /// No description provided for @educationStep.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get educationStep;

  /// No description provided for @skillsStep.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skillsStep;

  /// No description provided for @projectsStep.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projectsStep;

  /// No description provided for @photoStep.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photoStep;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'Next Step'**
  String get nextStep;

  /// No description provided for @viewTemplatesFinish.
  ///
  /// In en, this message translates to:
  /// **'View Templates & Finish'**
  String get viewTemplatesFinish;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @cvTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'CV Name / Title'**
  String get cvTitleLabel;

  /// No description provided for @cvTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Senior Software Engineer CV'**
  String get cvTitleHint;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @professionalTitle.
  ///
  /// In en, this message translates to:
  /// **'Professional Title'**
  String get professionalTitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'City, Country'**
  String get location;

  /// No description provided for @autoSavedLocally.
  ///
  /// In en, this message translates to:
  /// **'Auto-saved locally'**
  String get autoSavedLocally;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Professional Summary'**
  String get summary;

  /// No description provided for @summaryHint.
  ///
  /// In en, this message translates to:
  /// **'Summarize your career highlights and top achievements...'**
  String get summaryHint;

  /// No description provided for @workExperience.
  ///
  /// In en, this message translates to:
  /// **'Work Experience'**
  String get workExperience;

  /// No description provided for @newExperience.
  ///
  /// In en, this message translates to:
  /// **'New Experience'**
  String get newExperience;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Position'**
  String get jobTitle;

  /// No description provided for @jobTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Senior Software Engineer'**
  String get jobTitleHint;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company / Organization'**
  String get company;

  /// No description provided for @companyHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Acme Tech Solutions'**
  String get companyHint;

  /// No description provided for @locationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. San Francisco, CA'**
  String get locationHint;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @currentlyWorkHere.
  ///
  /// In en, this message translates to:
  /// **'I currently work here'**
  String get currentlyWorkHere;

  /// No description provided for @bulletPointsLabel.
  ///
  /// In en, this message translates to:
  /// **'Achievements / Responsibilities (one per line)'**
  String get bulletPointsLabel;

  /// No description provided for @bulletPointsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Engineered high-performance cross-platform Flutter applications.'**
  String get bulletPointsHint;

  /// No description provided for @addExperience.
  ///
  /// In en, this message translates to:
  /// **'Add Work Experience'**
  String get addExperience;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @newEducation.
  ///
  /// In en, this message translates to:
  /// **'New Education'**
  String get newEducation;

  /// No description provided for @degree.
  ///
  /// In en, this message translates to:
  /// **'Degree / Major'**
  String get degree;

  /// No description provided for @degreeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. B.S. in Computer Science'**
  String get degreeHint;

  /// No description provided for @institution.
  ///
  /// In en, this message translates to:
  /// **'School / University'**
  String get institution;

  /// No description provided for @institutionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Stanford University'**
  String get institutionHint;

  /// No description provided for @gpaOptional.
  ///
  /// In en, this message translates to:
  /// **'GPA (Optional)'**
  String get gpaOptional;

  /// No description provided for @gpaHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 3.8/4.0'**
  String get gpaHint;

  /// No description provided for @addEducation.
  ///
  /// In en, this message translates to:
  /// **'Add Education'**
  String get addEducation;

  /// No description provided for @currentlyStudyHere.
  ///
  /// In en, this message translates to:
  /// **'I currently study here'**
  String get currentlyStudyHere;

  /// No description provided for @skillsCompetencies.
  ///
  /// In en, this message translates to:
  /// **'Skills & Competencies'**
  String get skillsCompetencies;

  /// No description provided for @skillHint.
  ///
  /// In en, this message translates to:
  /// **'Add a skill (e.g. Flutter, Dart, Riverpod)...'**
  String get skillHint;

  /// No description provided for @addSkill.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get addSkill;

  /// No description provided for @skills.
  ///
  /// In en, this message translates to:
  /// **'Skills & Technologies'**
  String get skills;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// No description provided for @addProject.
  ///
  /// In en, this message translates to:
  /// **'Add Project'**
  String get addProject;

  /// No description provided for @newProject.
  ///
  /// In en, this message translates to:
  /// **'New Project'**
  String get newProject;

  /// No description provided for @noProjectsYet.
  ///
  /// In en, this message translates to:
  /// **'No projects added yet.\nTap \'+\' to add a project.'**
  String get noProjectsYet;

  /// No description provided for @projectTitle.
  ///
  /// In en, this message translates to:
  /// **'Project Title'**
  String get projectTitle;

  /// No description provided for @projectTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. AI Mobile Resume App'**
  String get projectTitleHint;

  /// No description provided for @projectUrl.
  ///
  /// In en, this message translates to:
  /// **'Project / GitHub Link (Optional)'**
  String get projectUrl;

  /// No description provided for @projectUrlHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. https://github.com/...'**
  String get projectUrlHint;

  /// No description provided for @technologiesUsed.
  ///
  /// In en, this message translates to:
  /// **'Technologies Used (Comma separated)'**
  String get technologiesUsed;

  /// No description provided for @technologiesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Flutter, Dart, Riverpod'**
  String get technologiesHint;

  /// No description provided for @projectDescription.
  ///
  /// In en, this message translates to:
  /// **'Project Description & Highlights'**
  String get projectDescription;

  /// No description provided for @projectDescHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your role, architecture, and achievements...'**
  String get projectDescHint;

  /// No description provided for @profilePhotoOptional.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo (Optional)'**
  String get profilePhotoOptional;

  /// No description provided for @photoDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Used automatically when choosing photo-enabled CV templates.'**
  String get photoDisclaimer;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get changePhoto;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// No description provided for @removePhoto.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhoto;

  /// No description provided for @selectDesign.
  ///
  /// In en, this message translates to:
  /// **'Choose Resume Template'**
  String get selectDesign;

  /// No description provided for @standardizedTemplates.
  ///
  /// In en, this message translates to:
  /// **'Standardized Global Resume Templates'**
  String get standardizedTemplates;

  /// No description provided for @selectedDesign.
  ///
  /// In en, this message translates to:
  /// **'Selected Design'**
  String get selectedDesign;

  /// No description provided for @saveAndPdf.
  ///
  /// In en, this message translates to:
  /// **'Save & Download PDF'**
  String get saveAndPdf;

  /// No description provided for @saveOnly.
  ///
  /// In en, this message translates to:
  /// **'Save Only'**
  String get saveOnly;

  /// No description provided for @cvSavedDownloading.
  ///
  /// In en, this message translates to:
  /// **'Resume Saved! Preparing PDF download...'**
  String get cvSavedDownloading;

  /// No description provided for @cvSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Resume Saved Successfully!'**
  String get cvSavedSuccess;

  /// No description provided for @aiModalTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Bullet Point Optimization'**
  String get aiModalTitle;

  /// No description provided for @aiModalSub.
  ///
  /// In en, this message translates to:
  /// **'Review AI-suggested changes before applying to your resume'**
  String get aiModalSub;

  /// No description provided for @original.
  ///
  /// In en, this message translates to:
  /// **'ORIGINAL'**
  String get original;

  /// No description provided for @aiSuggestion.
  ///
  /// In en, this message translates to:
  /// **'AI SUGGESTION'**
  String get aiSuggestion;

  /// No description provided for @keepOriginal.
  ///
  /// In en, this message translates to:
  /// **'Keep Original'**
  String get keepOriginal;

  /// No description provided for @acceptAiSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Accept AI Suggestion'**
  String get acceptAiSuggestion;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @turkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get turkish;

  /// No description provided for @editYourResumes.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editYourResumes;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @deleteResumeTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Resume'**
  String get deleteResumeTitle;

  /// No description provided for @deleteResumeMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this resume? This action cannot be undone.'**
  String get deleteResumeMessage;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get confirmDelete;

  /// No description provided for @proRequired.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get proRequired;

  /// No description provided for @proRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Free users can save up to 3 resumes. Upgrade to AI CV Builder Pro to save unlimited resumes and unlock premium templates.'**
  String get proRequiredMessage;

  /// No description provided for @upgradeToPro.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get upgradeToPro;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// No description provided for @resumeDuplicated.
  ///
  /// In en, this message translates to:
  /// **'Resume duplicated successfully!'**
  String get resumeDuplicated;

  /// No description provided for @copySuffix.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copySuffix;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
