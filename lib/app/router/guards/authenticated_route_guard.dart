import 'package:clips_tack/app/router/app_routes.dart';
import 'package:clips_tack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthenticatedRouteGuard extends StatelessWidget {
  const AuthenticatedRouteGuard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType &&
          current.maybeWhen(
            unauthenticated: () => true,
            error: (_) => true,
            orElse: () => false,
          ),
      listener: (context, state) {
        state.whenOrNull(
          unauthenticated: () => context.goNamed(AppRoutes.login),
          error: (_) => context.goNamed(AppRoutes.login),
        );
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isAuthenticated = state.maybeWhen(
            authenticated: (_) => true,
            orElse: () => false,
          );
          final shouldGoToLogin = state.maybeWhen(
            unauthenticated: () => true,
            error: (_) => true,
            orElse: () => false,
          );

          if (isAuthenticated) {
            return child;
          }

          if (shouldGoToLogin) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                context.goNamed(AppRoutes.login);
              }
            });

            return const SizedBox.shrink();
          }

          return const Center(child: CircularProgressIndicator.adaptive());
        },
      ),
    );
  }
}
