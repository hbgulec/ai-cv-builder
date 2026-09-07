import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../template_engine/domain/entities/template_config.dart';
import '../../../template_engine/resume_page_data.dart';
import '../../../template_engine/widgets/resume_template_canvas.dart';
import '../providers/resume_provider.dart';

typedef TemplateSaveCallback = Future<void> Function(BuildContext context);
typedef TemplateExportCallback = Future<void> Function(
  BuildContext context,
  Map<String, dynamic> resumeData,
);

/// Document-first template inspection with live, persisted color variants.
class TemplatePreviewSheet extends ConsumerStatefulWidget {
  const TemplatePreviewSheet({
    super.key,
    required this.template,
    required this.onSaveOnly,
    required this.onSaveAndExport,
  });

  final BaseResumeTemplate template;
  final TemplateSaveCallback onSaveOnly;
  final TemplateExportCallback onSaveAndExport;

  @override
  ConsumerState<TemplatePreviewSheet> createState() =>
      _TemplatePreviewSheetState();
}

class _TemplatePreviewSheetState extends ConsumerState<TemplatePreviewSheet> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  _SaveAction? _saveAction;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _runSave(
    _SaveAction action,
    Map<String, dynamic> resumeData,
  ) async {
    if (_saveAction != null) return;
    setState(() => _saveAction = action);
    try {
      if (action == _SaveAction.save) {
        await widget.onSaveOnly(context);
      } else {
        await widget.onSaveAndExport(context, resumeData);
      }
    } finally {
      if (mounted) setState(() => _saveAction = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(resumeEditorProvider);
    final locale = ref.watch(localeProvider);
    final notifier = ref.read(resumeEditorProvider.notifier);
    final resumeData = editorState.resume.toJson()
      ..['photoBytes'] = editorState.photoBytes
      ..['contentLanguage'] = locale.languageCode;
    final pages = ResumePageData.split(resumeData);
    final colorOptions = widget.template.config.colorOptions;
    final selectedColor = editorState.resume.templateColorIndex.clamp(0, 4);
    final isTurkish = locale.languageCode == 'tr';
    final pageLabel = isTurkish ? 'Sayfa' : 'Page';
    final colorOptionLabel = isTurkish ? 'Renk seçeneği' : 'Color option';
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final stateDuration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 180);

    if (_pageIndex >= pages.length) {
      _pageIndex = pages.length - 1;
    }
    final currentPageNumber = _pageIndex + 1;
    final pageCount = pages.length;

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .96,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: DecoratedBox(
          decoration:
              const BoxDecoration(gradient: AppColors.darkBackgroundGradient),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                const SizedBox(height: 9),
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withValues(alpha: .65),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 9, 10, 9),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.template.config.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                if (widget.template.config.isPremium) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.warning
                                          .withValues(alpha: .16),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: AppColors.warning
                                            .withValues(alpha: .72),
                                      ),
                                    ),
                                    child: const Text(
                                      'PRO',
                                      style: TextStyle(
                                        color: AppColors.warning,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: .7,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              isTurkish
                                  ? 'Belgeyi ve renkleri kaydetmeden önce deneyin.'
                                  : 'Inspect the document and colors before saving.',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: IconButton(
                          tooltip: isTurkish ? 'Kapat' : 'Close',
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GlassCard(
                      showShadow: false,
                      blur: 18,
                      borderRadius: 18,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Expanded(
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: pages.length,
                              onPageChanged: (index) =>
                                  setState(() => _pageIndex = index),
                              itemBuilder: (context, index) => Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: ColoredBox(
                                    color: Colors.white,
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      alignment: Alignment.topCenter,
                                      child: ResumeTemplateCanvas(
                                        template: widget.template,
                                        resumeData: pages[index],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (pages.length > 1) ...[
                            const SizedBox(height: 8),
                            Semantics(
                              liveRegion: true,
                              label:
                                  '$pageLabel $currentPageNumber / $pageCount',
                              child: Text(
                                '$pageLabel $currentPageNumber / $pageCount',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isTurkish ? 'Tasarım rengi' : 'Template color',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(colorOptions.length, (index) {
                          final color = colorOptions[index];
                          final isSelected = selectedColor == index;
                          final optionNumber = index + 1;
                          return Semantics(
                            button: true,
                            selected: isSelected,
                            label: '$colorOptionLabel $optionNumber',
                            child: InkWell(
                              onTap: () =>
                                  notifier.setTemplateColorIndex(index),
                              customBorder: const CircleBorder(),
                              child: AnimatedContainer(
                                duration: stateDuration,
                                width: 44,
                                height: 44,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? AppColors.glassBackgroundStrong
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.textPrimary
                                        : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: color,
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: .7),
                                    ),
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: isTurkish ? 'Sadece kaydet' : 'Save only',
                          isSecondary: true,
                          isLoading: _saveAction == _SaveAction.save,
                          onPressed: _saveAction == null
                              ? () => _runSave(_SaveAction.save, resumeData)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: AppButton(
                          text: isTurkish
                              ? 'Kaydet ve PDF indir'
                              : 'Save & download PDF',
                          icon: Icons.picture_as_pdf_outlined,
                          isLoading: _saveAction == _SaveAction.export,
                          onPressed: _saveAction == null
                              ? () => _runSave(_SaveAction.export, resumeData)
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _SaveAction { save, export }
