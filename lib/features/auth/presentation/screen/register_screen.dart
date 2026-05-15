import 'package:clips_tack/app/router/app_router.dart';
import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_scaffold.dart';
import 'package:clips_tack/core/widgets/app_snack_bar.dart';
import 'package:clips_tack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:clips_tack/features/auth/presentation/widgets/register_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    context.read<AuthBloc>().add(const AuthEvent.checkLogin());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    context.hideKeyboard();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final email = _emailController.text.trim();

    context.read<AuthBloc>().add(
      AuthEvent.register(
        email,
        _passwordController.text,
        _nameController.text.trim(),
        null,
        email.split('@').first,
      ),
    );
  }

  void _loginWithGoogle() {
    context.hideKeyboard();
    context.read<AuthBloc>().add(const AuthEvent.loginWithGoogle());
  }

  void _goToLogin() {
    context.goNamed(AppRoutes.login);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return context.l10n.registerNameRequired;
    }

    if (name.length < 2) {
      return context.l10n.registerNameTooShort;
    }

    return null;
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) {
      return context.l10n.loginEmailRequired;
    }

    final isValid = RegExp(
      r'^[^@\s]+@gmail\.com$',
      caseSensitive: false,
    ).hasMatch(email);
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

  String? _validateConfirmPassword(String? value) {
    if ((value ?? '').isEmpty) {
      return context.l10n.registerConfirmPasswordRequired;
    }

    if (value != _passwordController.text) {
      return context.l10n.registerPasswordsDoNotMatch;
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
                    child: RegisterForm(
                      formKey: _formKey,
                      nameController: _nameController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      obscurePassword: _obscurePassword,
                      obscureConfirmPassword: _obscureConfirmPassword,
                      isLoading: isLoading,
                      onRegister: _register,
                      onLoginWithGoogle: _loginWithGoogle,
                      onLogin: _goToLogin,
                      onTogglePasswordVisibility: _togglePasswordVisibility,
                      onToggleConfirmPasswordVisibility:
                          _toggleConfirmPasswordVisibility,
                      validateName: _validateName,
                      validateEmail: _validateEmail,
                      validatePassword: _validatePassword,
                      validateConfirmPassword: _validateConfirmPassword,
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
