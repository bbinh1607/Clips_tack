import 'package:clips_tack/app/router/app_routes.dart';
import 'package:clips_tack/app/router/guards/authenticated_route_guard.dart';
import 'package:clips_tack/app/router/transitions/clip_detail_route_transition.dart';
import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/features/auth/presentation/screen/login_scren.dart';
import 'package:clips_tack/features/auth/presentation/screen/register_screen.dart';
import 'package:clips_tack/features/clipboard/presentation/models/clip_detail_payload.dart';
import 'package:clips_tack/features/clipboard/presentation/models/clip_editor_payload.dart';
import 'package:clips_tack/features/clipboard/presentation/screen/clip_detail_screen.dart';
import 'package:clips_tack/features/clipboard/presentation/screen/clip_editor_screen.dart';
import 'package:clips_tack/features/clipboard/presentation/screen/clipboard_list_screen.dart';
import 'package:clips_tack/features/home/presentation/screen/clip_stack_shell.dart';
import 'package:clips_tack/features/home/presentation/screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

List<RouteBase> buildAppRouteTree() {
  return [..._authRoutes(), _appShellRoute(), ..._clipboardRoutes()];
}

List<RouteBase> _authRoutes() {
  return [
    GoRoute(
      path: AppRoutes.login,
      name: AppRoutes.login,
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: LoginScreen());
      },
    ),
    GoRoute(
      path: AppRoutes.register,
      name: AppRoutes.register,
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: RegisterScreen());
      },
    ),
  ];
}

StatefulShellRoute _appShellRoute() {
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return AuthenticatedRouteGuard(
        child: ClipStackShell(navigationShell: navigationShell),
      );
    },
    branches: [
      _shellBranch(
        path: AppRoutes.history,
        child: const ClipboardListScreen(mode: ClipboardListMode.history),
      ),
      _shellBranch(
        path: AppRoutes.starred,
        child: const ClipboardListScreen(mode: ClipboardListMode.starred),
      ),
      _shellBranch(path: AppRoutes.settings, child: const SettingsScreen()),
    ],
  );
}

StatefulShellBranch _shellBranch({
  required String path,
  required Widget child,
}) {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: path,
        name: path,
        pageBuilder: (context, state) {
          return NoTransitionPage(child: child);
        },
      ),
    ],
  );
}

List<RouteBase> _clipboardRoutes() {
  return [
    GoRoute(
      path: AppRoutes.clipDetail,
      name: AppRoutes.clipDetail,
      pageBuilder: _buildClipDetailPage,
    ),
    GoRoute(
      path: AppRoutes.editor,
      name: AppRoutes.editor,
      builder: (context, state) {
        final payload = state.extra is ClipEditorPayload
            ? state.extra! as ClipEditorPayload
            : const ClipEditorPayload();

        return AuthenticatedRouteGuard(
          child: ClipEditorScreen(payload: payload),
        );
      },
    ),
  ];
}

Page<String> _buildClipDetailPage(BuildContext context, GoRouterState state) {
  final payload = state.extra is ClipDetailPayload
      ? state.extra! as ClipDetailPayload
      : null;

  if (payload == null) {
    return const NoTransitionPage(child: SizedBox.shrink());
  }

  return CustomTransitionPage<String>(
    key: state.pageKey,
    opaque: false,
    transitionDuration: AppDuration.clipExpand,
    reverseTransitionDuration: AppDuration.clipExpand,
    child: AuthenticatedRouteGuard(
      child: ClipDetailScreen(
        initialItem: payload.item,
        initialItems: payload.items,
      ),
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return ClipDetailRouteTransition(
        animation: animation,
        sourceRect: payload.sourceRect,
        child: child,
      );
    },
  );
}
