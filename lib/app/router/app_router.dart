import 'dart:ui';

import 'package:clips_tack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:clips_tack/features/auth/presentation/screen/login_scren.dart';
import 'package:clips_tack/features/auth/presentation/screen/register_screen.dart';
import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/features/home/models/clip_detail_payload.dart';
import 'package:clips_tack/features/home/models/clip_editor_payload.dart';
import 'package:clips_tack/features/home/presentation/screen/clip_detail_screen.dart';
import 'package:clips_tack/features/home/presentation/screen/clip_editor_screen.dart';
import 'package:clips_tack/features/home/presentation/screen/clip_stack_shell.dart';
import 'package:clips_tack/features/home/presentation/screen/clipboard_list_screen.dart';
import 'package:clips_tack/features/home/presentation/screen/settings_screen.dart';
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
  static const clipDetail = '/clip-detail';
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
        path: AppRoutes.clipDetail,
        name: AppRoutes.clipDetail,
        pageBuilder: (context, state) {
          final payload = state.extra is ClipDetailPayload
              ? state.extra! as ClipDetailPayload
              : null;

          if (payload == null) {
            return const NoTransitionPage(child: SizedBox.shrink());
          }

          return CustomTransitionPage<String>(
            key: state.pageKey,
            transitionDuration: AppDuration.clipExpand,
            reverseTransitionDuration: AppDuration.clipCollapse,
            child: AuthenticatedRouteGuard(
              child: ClipDetailScreen(initialItem: payload.item),
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return _ClipDetailRouteTransition(
                    animation: animation,
                    sourceRect: payload.sourceRect,
                    child: child,
                  );
                },
          );
        },
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

class _ClipDetailRouteTransition extends StatelessWidget {
  const _ClipDetailRouteTransition({
    required this.animation,
    required this.child,
    this.sourceRect,
  });

  final Animation<double> animation;
  final Rect? sourceRect;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final source = sourceRect;
    if (source == null ||
        source.isEmpty ||
        !source.isFinite ||
        source.width <= 0 ||
        source.height <= 0) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        ),
        child: child,
      );
    }

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final curve = animation.status == AnimationStatus.reverse
            ? Curves.easeInCubic
            : Curves.easeOutCubic;
        final value = curve.transform(animation.value);
        final screenRect = Offset.zero & MediaQuery.sizeOf(context);
        final rect = Rect.lerp(source, screenRect, value)!;
        final radius = lerpDouble(AppRadius.largeValue, 0, value)!;

        return Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: value * 0.28),
            ),
            Positioned.fromRect(
              rect: rect,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: OverflowBox(
                  alignment: Alignment.topLeft,
                  minWidth: screenRect.width,
                  maxWidth: screenRect.width,
                  minHeight: screenRect.height,
                  maxHeight: screenRect.height,
                  child: SizedBox.fromSize(size: screenRect.size, child: child),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
