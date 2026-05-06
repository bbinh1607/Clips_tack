import 'package:clips_tack/app/router/app_router.dart';
import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_scaffold.dart';
import 'package:clips_tack/core/widgets/app_snack_bar.dart';
import 'package:clips_tack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:clips_tack/features/auth/presentation/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    context.read<AuthBloc>().add(const AuthEvent.checkLogin());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    context.hideKeyboard();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    context.read<AuthBloc>().add(
      AuthEvent.login(_emailController.text.trim(), _passwordController.text),
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _forgotPassword() {
    _showSnackBar(
      context.l10n.loginForgotPasswordUnavailable,
      type: AppSnackBarType.info,
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return context.l10n.loginEmailRequired;
    }

    final isValid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
    if (!isValid) {
      return context.l10n.loginEmailInvalid;
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if ((value ?? '').isEmpty) {
      return context.l10n.loginPasswordRequired;
    }

    if (value!.length < 6) {
      return context.l10n.loginPasswordTooShort;
    }

    return null;
  }

  void _showSnackBar(
    String message, {
    AppSnackBarType type = AppSnackBarType.error,
  }) {
    AppSnackBar.show(context, message: message, type: type);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          authenticated: (_) => context.goNamed(AppRoutes.history),
          error: _showSnackBar,
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return AppScaffold(
          useSafeArea: true,
          resizeToAvoidBottomInset: true,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: context.hideKeyboard,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(
                      context.colors.surface,
                      context.colors.primary,
                      context.isDark ? 0.24 : 0.12,
                    )!,
                    context.colors.surface,
                    Color.lerp(
                      context.colors.surface,
                      context.colors.secondary,
                      context.isDark ? 0.22 : 0.10,
                    )!,
                  ],
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  padding: AppInsets.page,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: LoginForm(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      obscurePassword: _obscurePassword,
                      isLoading: isLoading,
                      onLogin: _login,
                      onForgotPassword: _forgotPassword,
                      onTogglePasswordVisibility: _togglePasswordVisibility,
                      validateEmail: _validateEmail,
                      validatePassword: _validatePassword,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
