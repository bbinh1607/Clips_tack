import 'package:clips_tack/features/home/models/clip_editor_payload.dart';
import 'package:clips_tack/features/home/presentation/clip_editor_screen.dart';
import 'package:clips_tack/features/home/presentation/clip_stack_shell.dart';
import 'package:clips_tack/features/home/presentation/clipboard_list_screen.dart';
import 'package:clips_tack/features/home/presentation/settings_screen.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRoutes {
  static const history = '/history';
  static const starred = '/starred';
  static const settings = '/settings';
  static const editor = '/editor';

  static const historyName = 'history';
  static const starredName = 'starred';
  static const settingsName = 'settings';
  static const editorName = 'editor';
}

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.history,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ClipStackShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                name: AppRoutes.historyName,
                pageBuilder: (context, state) {
                  return const NoTransitionPage(
                    child: ClipboardListScreen(mode: ClipboardListMode.history),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.starred,
                name: AppRoutes.starredName,
                pageBuilder: (context, state) {
                  return const NoTransitionPage(
                    child: ClipboardListScreen(mode: ClipboardListMode.starred),
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                name: AppRoutes.settingsName,
                pageBuilder: (context, state) {
                  return const NoTransitionPage(child: SettingsScreen());
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.editor,
        name: AppRoutes.editorName,
        builder: (context, state) {
          final payload = state.extra is ClipEditorPayload
              ? state.extra! as ClipEditorPayload
              : const ClipEditorPayload();

          return ClipEditorScreen(payload: payload);
        },
      ),
    ],
  );
}
