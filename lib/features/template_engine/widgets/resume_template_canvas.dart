import 'package:flutter/material.dart';

import '../domain/entities/template_config.dart';

/// Keeps every document preview on the same logical A4 canvas.
class ResumeTemplateCanvas extends StatelessWidget {
  const ResumeTemplateCanvas({
    super.key,
    required this.template,
    required this.resumeData,
  });

  static const double logicalWidth = 380;
  static const double logicalHeight = 540;

  final BaseResumeTemplate template;
  final Map<String, dynamic> resumeData;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: logicalWidth,
      height: logicalHeight,
      child: DefaultTextStyle(
        key: const ValueKey('resume-unicode-font-fallback'),
        style: const TextStyle(
          inherit: false,
          color: Colors.black,
          fontSize: 9,
          fontWeight: FontWeight.normal,
          fontFamily: 'Roboto',
          fontFamilyFallback: ['Noto Sans', 'Arial'],
        ),
        child: MediaQuery.withNoTextScaling(
          child: template.buildPreview(resumeData),
        ),
      ),
    );
  }
}
