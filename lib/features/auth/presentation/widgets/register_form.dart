import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_button.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/auth/presentation/widgets/login_brand.dart';
import 'package:clips_tack/features/auth/presentation/widgets/login_panel.dart';
import 'package:clips_tack/features/auth/presentation/widgets/login_text_field.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.isLoading,
    required this.onRegister,
    required this.onLogin,
    required this.onTogglePasswordVisibility,
    required this.onToggleConfirmPasswordVisibility,
    required this.validateName,
    required this.validateEmail,
    required this.validatePassword,
    required this.validateConfirmPassword,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final bool isLoading;
  final VoidCallback onRegister;
  final VoidCallback onLogin;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleConfirmPasswordVisibility;
  final FormFieldValidator<String> validateName;
  final FormFieldValidator<String> validateEmail;
  final FormFieldValidator<String> validatePassword;
  final FormFieldValidator<String> validateConfirmPassword;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const LoginBrand(),
          const SizedBox(height: AppSpace.panel),
          LoginPanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppText.titleLarge(
                  l10n.registerTitle,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpace.md),
                AppText.bodyMedium(
                  l10n.registerWelcomeMessage,
                  color: Color.lerp(
                    context.colors.onSurface,
                    context.colors.surface,
                    AppOpacity.mutedText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpace.panel),
                LoginTextField(
                  controller: nameController,
                  label: l10n.registerNameLabel,
                  hintText: l10n.registerNameHint,
                  icon: Icons.person_outline_rounded,
                  textInputAction: TextInputAction.next,
                  validator: validateName,
                  enabled: !isLoading,
                ),
                const SizedBox(height: AppSpace.xxl),
                LoginTextField(
                  controller: emailController,
                  label: l10n.loginEmailLabel,
                  hintText: l10n.loginEmailHint,
                  icon: Icons.alternate_email_rounded,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: validateEmail,
                  enabled: !isLoading,
                ),
                const SizedBox(height: AppSpace.xxl),
                LoginTextField(
                  controller: passwordController,
                  label: l10n.loginPasswordLabel,
                  hintText: l10n.loginPasswordHint,
                  icon: Icons.lock_outline_rounded,
                  obscureText: obscurePassword,
                  textInputAction: TextInputAction.next,
                  validator: validatePassword,
                  enabled: !isLoading,
                  suffixIcon: AppButton.icon(
                    icon: obscurePassword
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    onPressed: isLoading ? null : onTogglePasswordVisibility,
                    tooltip: obscurePassword
                        ? l10n.loginShowPasswordTooltip
                        : l10n.loginHidePasswordTooltip,
                  ),
                ),
                const SizedBox(height: AppSpace.xxl),
                LoginTextField(
                  controller: confirmPasswordController,
                  label: l10n.registerConfirmPasswordLabel,
                  hintText: l10n.registerConfirmPasswordHint,
                  icon: Icons.lock_reset_rounded,
                  obscureText: obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  validator: validateConfirmPassword,
                  enabled: !isLoading,
                  onFieldSubmitted: (_) {
                    if (!isLoading) {
                      onRegister();
                    }
                  },
                  suffixIcon: AppButton.icon(
                    icon: obscureConfirmPassword
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                    onPressed: isLoading
                        ? null
                        : onToggleConfirmPasswordVisibility,
                    tooltip: obscureConfirmPassword
                        ? l10n.loginShowPasswordTooltip
                        : l10n.loginHidePasswordTooltip,
                  ),
                ),
                const SizedBox(height: AppSpace.xxl),
                AppButton.primary(
                  label: isLoading
                      ? l10n.registerLoadingButton
                      : l10n.registerButton,
                  leadingIcon: isLoading ? null : Icons.person_add_alt_rounded,
                  onPressed: isLoading ? null : onRegister,
                ),
                const SizedBox(height: AppSpace.lg),
                AppButton.text(
                  label: l10n.registerGoToLoginButton,
                  onPressed: isLoading ? null : onLogin,
                  expanded: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.xxl),
          AppText.bodySmall(
            l10n.loginPrivacyNote,
            color: Color.lerp(
              context.colors.onSurface,
              context.colors.surface,
              AppOpacity.mutedText,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
