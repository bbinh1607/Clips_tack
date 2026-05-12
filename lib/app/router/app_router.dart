import 'package:clips_tack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:clips_tack/features/auth/presentation/screen/login_scren.dart';
import 'package:clips_tack/features/auth/presentation/screen/register_screen.dart';
import 'package:clips_tack/features/home/models/clip_editor_payload.dart';
import 'package:clips_tack/features/home/presentation/clip_editor_screen.dart';
import 'package:clips_tack/features/home/presentation/clip_stack_shell.dart';
import 'package:clips_tack/features/home/presentation/clipboard_list_screen.dart';
import 'package:clips_tack/features/home/presentation/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

abstract final class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const history = '/history';
  static const starred = '/starred';
  static const settings = '/settings';
  static const editor = '/editor';
}

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AuthenticatedRouteGuard(
            child: ClipStackShell(navigationShell: navigationShell),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.history,
                name: AppRoutes.history,
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
                name: AppRoutes.starred,
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
                name: AppRoutes.settings,
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
    ],
  );
}

class AuthenticatedRouteGuard extends StatelessWidget {
  const AuthenticatedRouteGuard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      listener: (context, state) {
        state.whenOrNull(
          unauthenticated: () => context.goNamed(AppRoutes.login),
        );
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isUnauthenticated = state.maybeWhen(
            unauthenticated: () => true,
            orElse: () => false,
          );

          if (isUnauthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                context.goNamed(AppRoutes.login);
              }
            });

            return const SizedBox.shrink();
          }

          return child;
        },
      ),
    );
  }
}
