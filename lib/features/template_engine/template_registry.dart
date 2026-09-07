import 'domain/entities/template_config.dart';
import 'templates/ats_classic_template.dart';

import 'templates/modern_clean_template.dart';

import 'templates/executive_pro_template.dart';
import 'templates/global_templates.dart';
import 'templates/signature_resume_templates.dart';

/// Central registry managing international standard resume templates.
/// Free tier favors ATS readability; PRO adds executive and editorial layouts.
class TemplateRegistry {
  static final List<BaseResumeTemplate> _templates = [
    AucklandTemplate(),
    EdinburghTemplate(),
    PrincetonTemplate(),
    OtagoTemplate(),
    BerkeleyTemplate(),
    CambridgeTemplate(),
    AtsClassicTemplate(),
    ModernCleanTemplate(),
    SignatureResumeTemplate.lisbon(),
    SignatureResumeTemplate.toronto(),
    HarvardTemplate(),
    StanfordTemplate(),
    OxfordTemplate(),
    ExecutiveProTemplate(),
    SignatureResumeTemplate.monaco(),
    SignatureResumeTemplate.tokyo(),
  ];

  static const int freeTemplateCount = 10;
  static const int premiumTemplateCount = 6;

  /// Returns all available templates
  static List<BaseResumeTemplate> getAll() => _templates;

  /// Returns only free-tier templates
  static List<BaseResumeTemplate> getFreeTemplates() =>
      _templates.where((t) => !t.config.isPremium).toList();

  /// Returns only premium-tier templates
  static List<BaseResumeTemplate> getPremiumTemplates() =>
      _templates.where((t) => t.config.isPremium).toList();

  /// Returns a specific template by ID
  static BaseResumeTemplate getTemplate(String templateId) {
    return _templates.firstWhere(
      (t) => t.config.id == templateId,
      orElse: () => _templates.first, // fallback
    );
  }

  /// Returns all template configs (for template picker UI)
  static List<TemplateConfig> getAllConfigs() =>
      _templates.map((t) => t.config).toList();
}
