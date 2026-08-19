import 'package:go_router/go_router.dart';
import '../../../features/resume_builder/presentation/screens/soft_glass_dashboard_screen.dart';
import '../../../features/resume_builder/presentation/screens/resume_editor_screen.dart';
import '../../../features/resume_builder/presentation/screens/soft_glass_template_selection_screen.dart';
import '../../../features/resume_builder/presentation/screens/resume_view_screen.dart';

/// GoRouter-based navigation configuration for AI CV Builder.
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'dashboard',
        builder: (context, state) => const SoftGlassDashboardScreen(),
      ),
      GoRoute(
        path: '/editor',
        name: 'editor',
        builder: (context, state) {
          final resumeId = state.uri.queryParameters['id'];
          return ResumeEditorScreen(resumeId: resumeId);
        },
      ),
      GoRoute(
        path: '/template-select',
        name: 'template-select',
        builder: (context, state) => const SoftGlassTemplateSelectionScreen(),
      ),
      GoRoute(
        path: '/view',
        name: 'view',
        builder: (context, state) {
          final resumeId = state.uri.queryParameters['id'] ?? '';
          return ResumeViewScreen(resumeId: resumeId);
        },
      ),
    ],
  );
}
