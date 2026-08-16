import 'domain/entities/template_config.dart';
import 'templates/ats_classic_template.dart';
import 'templates/ats_pure_template.dart';
import 'templates/modern_clean_template.dart';
import 'templates/modern_creative_template.dart';
import 'templates/executive_minimal_template.dart';
import 'templates/executive_pro_template.dart';
import 'templates/global_templates.dart';

/// Central registry managing international standard resume templates.
/// Free Tier: Auckland, Edinburgh, Princeton, ATS Classic, ATS Pure
/// Premium Tier: Otago, Berkeley, Harvard, Stanford, Cambridge, Oxford, Modern Clean, Executive Pro
class TemplateRegistry {
  static final List<BaseResumeTemplate> _templates = [
    AucklandTemplate(),
    EdinburghTemplate(),
    PrincetonTemplate(),
    OtagoTemplate(),
    BerkeleyTemplate(),
    HarvardTemplate(),
    StanfordTemplate(),
    CambridgeTemplate(),
    OxfordTemplate(),
    AtsClassicTemplate(),
    ModernCleanTemplate(),
    ExecutiveProTemplate(),
  ];

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
