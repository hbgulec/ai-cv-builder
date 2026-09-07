import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../domain/entities/resume_version.dart';

/// Lets a user select a cloud snapshot before restoring it in the editor.
Future<ResumeVersion?> showResumeVersionHistory(
  BuildContext context, {
  required Future<List<ResumeVersion>> versions,
  required bool isTurkish,
}) {
  return showModalBottomSheet<ResumeVersion>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _ResumeVersionHistorySheet(
      versions: versions,
      isTurkish: isTurkish,
    ),
  );
}

class _ResumeVersionHistorySheet extends StatelessWidget {
  const _ResumeVersionHistorySheet({
    required this.versions,
    required this.isTurkish,
  });

  final Future<List<ResumeVersion>> versions;
  final bool isTurkish;

  @override
  Widget build(BuildContext context) {
    final title = isTurkish ? 'Sürüm geçmişi' : 'Version history';
    final subtitle = isTurkish
        ? 'Her kayıt geri yüklenebilir bir anlık görüntü oluşturur.'
        : 'Every save creates a restorable snapshot.';

    return SafeArea(
      top: false,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 560),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: const BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: FutureBuilder<List<ResumeVersion>>(
          future: versions,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const SizedBox(
                height: 180,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final entries = snapshot.data ?? const <ResumeVersion>[];
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 34,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.glassBorder,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                if (entries.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 28),
                    child: Center(
                      child: Text(
                        isTurkish
                            ? 'Henüz bulutta kayıtlı bir sürüm yok.'
                            : 'No cloud snapshots yet.',
                        style: const TextStyle(color: AppColors.textMuted),
                      ),
                    ),
                  )
                else
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: entries.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 9),
                      itemBuilder: (context, index) {
                        final version = entries[index];
                        final format = DateFormat(
                          'd MMM yyyy, HH:mm',
                          isTurkish ? 'tr' : 'en',
                        );
                        final versionTitle = isTurkish
                            ? 'Kayıt ${entries.length - index}'
                            : 'Save ${entries.length - index}';
                        return GlassCard(
                          showShadow: false,
                          blur: 10,
                          padding: const EdgeInsets.all(12),
                          onTap: () => Navigator.of(context).pop(version),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: const Icon(
                                  Icons.history_rounded,
                                  color: AppColors.primaryLight,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      versionTitle,
                                      style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      format.format(version.createdAt),
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                isTurkish ? 'Geri yükle' : 'Restore',
                                style: const TextStyle(
                                  color: AppColors.cyan,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
