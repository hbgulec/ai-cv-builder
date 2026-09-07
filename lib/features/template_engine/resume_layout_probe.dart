import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'domain/entities/template_config.dart';
import 'widgets/resume_template_canvas.dart';

/// Lays out the actual template without painting or attaching it to the screen.
/// Reuses one tree while the paginator tries successive content prefixes.
class ResumeLayoutProbe {
  ResumeLayoutProbe(this.template) {
    _container.attach(_pipeline);
  }

  final BaseResumeTemplate template;
  final _pipeline = PipelineOwner();
  final _owner = BuildOwner(focusManager: FocusManager());
  final _container = RenderPositionedBox(alignment: Alignment.topLeft);
  RenderObjectToWidgetElement<RenderBox>? _element;

  bool fits(Map<String, dynamic> page) {
    _element = RenderObjectToWidgetAdapter<RenderBox>(
      container: _container,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: ResumeTemplateCanvas(template: template, resumeData: page),
        ),
      ),
    ).attachToRenderTree(_owner, _element);
    _owner.buildScope(_element!);
    _container.layout(const BoxConstraints.tightFor(
      width: ResumeTemplateCanvas.logicalWidth,
      height: ResumeTemplateCanvas.logicalHeight,
    ));
    _pipeline.flushLayout();
    _owner.finalizeTree();
    return !overflows(_container);
  }

  /// Checks child bounds in release builds too; debug paint warnings alone
  /// cannot decide where a production document should break.
  static bool overflows(RenderObject node) {
    var overflow = false;
    node.visitChildren((child) {
      if (overflow) return;
      if ((node is RenderFlex || node is RenderWrap) &&
          node is RenderBox &&
          child is RenderBox) {
        final offset = (child.parentData! as BoxParentData).offset;
        const tolerance = .01;
        overflow = offset.dx < -tolerance ||
            offset.dy < -tolerance ||
            offset.dx + child.size.width > node.size.width + tolerance ||
            offset.dy + child.size.height > node.size.height + tolerance;
      }
      overflow = overflow || overflows(child);
    });
    return overflow;
  }

  void dispose() {
    if (_element != null) {
      RenderObjectToWidgetAdapter<RenderBox>(container: _container)
          .attachToRenderTree(_owner, _element);
      _owner.buildScope(_element!);
      _owner.finalizeTree();
    }
    _container.detach();
    _container.dispose();
    _pipeline.dispose();
    _owner.focusManager.dispose();
  }
}
