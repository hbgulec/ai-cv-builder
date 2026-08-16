import 'package:flutter/material.dart';
import 'package:ai_cv_builder/l10n/generated/app_localizations.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/glass_card.dart';

/// Anti-hallucination AI Diff Review Modal dialog.
/// Displays original user input side-by-side with AI-generated text,
/// highlighting changes and requiring explicit human approval before committing.
class AiDiffModal extends StatelessWidget {
  final String originalText;
  final String aiGeneratedText;
  final String? featureTitle;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const AiDiffModal({
    super.key,
    required this.originalText,
    required this.aiGeneratedText,
    this.featureTitle,
    required this.onAccept,
    required this.onReject,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String originalText,
    required String aiGeneratedText,
    String? featureTitle,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AiDiffModal(
        originalText: originalText,
        aiGeneratedText: aiGeneratedText,
        featureTitle: featureTitle,
        onAccept: () => Navigator.of(context).pop(true),
        onReject: () => Navigator.of(context).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = featureTitle ?? l10n.aiModalTitle;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: GlassCard(
        padding: const EdgeInsets.all(28),
        child: SizedBox(
          width: 700,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.accentViolet.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.auto_awesome, color: AppColors.accentViolet, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          l10n.aiModalSub,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Side-by-Side Diff Comparison
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Original Text Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.redAccent.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(l10n.original, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            originalText.isEmpty ? '(Empty)' : originalText,
                            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // AI Suggested Text Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.successGreen.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.successGreen.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.successGreen.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(l10n.aiSuggestion, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.successGreen)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            aiGeneratedText,
                            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.4, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: onReject,
                    child: Text(l10n.keepOriginal, style: const TextStyle(color: AppColors.textSecondary)),
                  ),
                  const SizedBox(width: 12),
                  AppButton(
                    text: l10n.acceptAiSuggestion,
                    icon: Icons.check_circle_outline,
                    onPressed: onAccept,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
