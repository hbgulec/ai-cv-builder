// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AI CV Builder';

  @override
  String get atsOptimizedSub => 'ATS-Optimized Resumes';

  @override
  String get dashboardTitle => 'My Resumes';

  @override
  String get createNewCv => 'New Resume';

  @override
  String aiCreditsRemaining(Object count) {
    return '$count AI Credits Left';
  }

  @override
  String stepProgress(Object current, Object total) {
    return 'Step $current of $total';
  }

  @override
  String get enhanceWithAi => 'AI Enhance';

  @override
  String get generatingAiSummary => 'Crafting professional summary...';

  @override
  String get aiDiffOriginal => 'Original Text';

  @override
  String get aiDiffSuggested => 'AI Polished Suggestion';

  @override
  String get applySuggestion => 'Apply Suggestion';

  @override
  String get cancel => 'Cancel';

  @override
  String get atsScoreLabel => 'ATS Match Score';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String get offlineWarning =>
      'You are currently offline. AI features require an internet connection.';

  @override
  String get paywallTitle => 'Unlock AI CV Builder Pro';

  @override
  String get heroBadge => '⚡ AI POWERED';

  @override
  String get heroTitle => 'Craft a Job-Winning Resume';

  @override
  String get heroSubtitle =>
      'Choose from 6 ATS-compliant templates, enhance bullet points with AI, and export print-ready PDFs without UI lag.';

  @override
  String get yourResumes => 'Your Resumes';

  @override
  String resumesSavedCount(Object count) {
    return '$count saved';
  }

  @override
  String get noResumesYet => 'No resumes created yet';

  @override
  String get createFirstResume => 'Create First Resume';

  @override
  String get edit => 'Edit';

  @override
  String get downloadPdf => 'Download PDF';

  @override
  String get view => 'View';

  @override
  String get delete => 'Delete';

  @override
  String get headerStep => 'Contact Info';

  @override
  String get summaryStep => 'Summary';

  @override
  String get experienceStep => 'Experience';

  @override
  String get educationStep => 'Education';

  @override
  String get skillsStep => 'Skills';

  @override
  String get projectsStep => 'Projects';

  @override
  String get photoStep => 'Photo';

  @override
  String get previous => 'Previous';

  @override
  String get nextStep => 'Next Step';

  @override
  String get viewTemplatesFinish => 'View Templates & Finish';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get cvTitleLabel => 'CV Name / Title';

  @override
  String get cvTitleHint => 'e.g. Senior Software Engineer CV';

  @override
  String get fullName => 'Full Name';

  @override
  String get professionalTitle => 'Professional Title';

  @override
  String get email => 'Email Address';

  @override
  String get phone => 'Phone Number';

  @override
  String get location => 'City, Country';

  @override
  String get autoSavedLocally => 'Auto-saved locally';

  @override
  String get summary => 'Professional Summary';

  @override
  String get summaryHint =>
      'Summarize your career highlights and top achievements...';

  @override
  String get workExperience => 'Work Experience';

  @override
  String get newExperience => 'New Experience';

  @override
  String get jobTitle => 'Job Position';

  @override
  String get jobTitleHint => 'e.g. Senior Software Engineer';

  @override
  String get company => 'Company / Organization';

  @override
  String get companyHint => 'e.g. Acme Tech Solutions';

  @override
  String get locationHint => 'e.g. San Francisco, CA';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get currentlyWorkHere => 'I currently work here';

  @override
  String get bulletPointsLabel =>
      'Achievements / Responsibilities (one per line)';

  @override
  String get bulletPointsHint =>
      'e.g. Engineered high-performance cross-platform Flutter applications.';

  @override
  String get addExperience => 'Add Work Experience';

  @override
  String get education => 'Education';

  @override
  String get newEducation => 'New Education';

  @override
  String get degree => 'Degree / Major';

  @override
  String get degreeHint => 'e.g. B.S. in Computer Science';

  @override
  String get institution => 'School / University';

  @override
  String get institutionHint => 'e.g. Stanford University';

  @override
  String get gpaOptional => 'GPA (Optional)';

  @override
  String get gpaHint => 'e.g. 3.8/4.0';

  @override
  String get addEducation => 'Add Education';

  @override
  String get currentlyStudyHere => 'I currently study here';

  @override
  String get skillsCompetencies => 'Skills & Competencies';

  @override
  String get skillHint => 'Add a skill (e.g. Flutter, Dart, Riverpod)...';

  @override
  String get addSkill => 'Add';

  @override
  String get skills => 'Skills & Technologies';

  @override
  String get projects => 'Projects';

  @override
  String get addProject => 'Add Project';

  @override
  String get newProject => 'New Project';

  @override
  String get noProjectsYet =>
      'No projects added yet.\nTap \'+\' to add a project.';

  @override
  String get projectTitle => 'Project Title';

  @override
  String get projectTitleHint => 'e.g. AI Mobile Resume App';

  @override
  String get projectUrl => 'Project / GitHub Link (Optional)';

  @override
  String get projectUrlHint => 'e.g. https://github.com/...';

  @override
  String get technologiesUsed => 'Technologies Used (Comma separated)';

  @override
  String get technologiesHint => 'e.g. Flutter, Dart, Riverpod';

  @override
  String get projectDescription => 'Project Description & Highlights';

  @override
  String get projectDescHint =>
      'Describe your role, architecture, and achievements...';

  @override
  String get profilePhotoOptional => 'Profile Photo (Optional)';

  @override
  String get photoDisclaimer =>
      'Used automatically when choosing photo-enabled CV templates.';

  @override
  String get changePhoto => 'Change Photo';

  @override
  String get uploadPhoto => 'Upload Photo';

  @override
  String get removePhoto => 'Remove Photo';

  @override
  String get selectDesign => 'Choose Resume Template';

  @override
  String get standardizedTemplates => 'Standardized Global Resume Templates';

  @override
  String get selectedDesign => 'Selected Design';

  @override
  String get saveAndPdf => 'Save & Download PDF';

  @override
  String get saveOnly => 'Save Only';

  @override
  String get cvSavedDownloading => 'Resume Saved! Preparing PDF download...';

  @override
  String get cvSavedSuccess => 'Resume Saved Successfully!';

  @override
  String get aiModalTitle => 'AI Bullet Point Optimization';

  @override
  String get aiModalSub =>
      'Review AI-suggested changes before applying to your resume';

  @override
  String get original => 'ORIGINAL';

  @override
  String get aiSuggestion => 'AI SUGGESTION';

  @override
  String get keepOriginal => 'Keep Original';

  @override
  String get acceptAiSuggestion => 'Accept AI Suggestion';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get turkish => 'Türkçe';

  @override
  String get editYourResumes => 'Edit';

  @override
  String get done => 'Done';

  @override
  String get deleteResumeTitle => 'Delete Resume';

  @override
  String get deleteResumeMessage =>
      'Are you sure you want to delete this resume? This action cannot be undone.';

  @override
  String get confirmDelete => 'Delete';

  @override
  String get proRequired => 'Upgrade to Pro';

  @override
  String get proRequiredMessage =>
      'Free users can save up to 3 resumes. Upgrade to AI CV Builder Pro to save unlimited resumes and unlock premium templates.';

  @override
  String get upgradeToPro => 'Upgrade to Pro';

  @override
  String get maybeLater => 'Maybe Later';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get resumeDuplicated => 'Resume duplicated successfully!';

  @override
  String get copySuffix => 'Copy';
}
