import 'package:clips_tack/core/assets/app_svg.dart';
import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_button.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/auth/presentation/widgets/login_brand.dart';
import 'package:clips_tack/features/auth/presentation/widgets/login_panel.dart';
import 'package:clips_tack/features/auth/presentation/widgets/login_text_field.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.onLogin,
    required this.onLoginWithGoogle,
    required this.onRegister,
    required this.onForgotPassword,
    required this.onTogglePasswordVisibility,
    required this.validateEmail,
    required this.validatePassword,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final VoidCallback onLogin;
  final VoidCallback onLoginWithGoogle;
  final VoidCallback onRegister;
  final VoidCallback onForgotPassword;
  final VoidCallback onTogglePasswordVisibility;
  final FormFieldValidator<String> validateEmail;
  final FormFieldValidator<String> validatePassword;

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
                  l10n.loginTitle,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpace.md),
                AppText.bodyMedium(
                  l10n.loginWelcomeMessage,
                  color: Color.lerp(
                    context.colors.onSurface,
                    context.colors.surface,
                    AppOpacity.mutedText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpace.panel),
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
                  textInputAction: TextInputAction.done,
                  validator: validatePassword,
                  enabled: !isLoading,
                  onFieldSubmitted: (_) {
                    if (!isLoading) {
                      onLogin();
                    }
                  },
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
                const SizedBox(height: AppSpace.lg),
                Align(
                  alignment: Alignment.centerRight,
                  child: AppButton.text(
                    label: l10n.loginForgotPasswordButton,
                    expanded: false,
                    onPressed: isLoading ? null : onForgotPassword,
                  ),
                ),
                const SizedBox(height: AppSpace.xxl),
                AppButton.primary(
                  label: isLoading ? l10n.loginLoadingButton : l10n.loginButton,
                  leadingIcon: isLoading ? null : Icons.login_rounded,
                  onPressed: isLoading ? null : onLogin,
                ),
                const SizedBox(height: AppSpace.xxl),
                _DividerLabel(label: l10n.textOr),
                const SizedBox(height: AppSpace.xxl),
                _GoogleSignInButton(
                  label: l10n.loginGoogleButton,
                  onPressed: isLoading ? null : onLoginWithGoogle,
                ),
                const SizedBox(height: AppSpace.xxl),
                Divider(
                  color: Color.lerp(
                    context.colors.onSurface,
                    context.colors.surface,
                    AppOpacity.inputFillDark,
                  ),
                ),
                const SizedBox(height: AppSpace.lg),
                _RegisterPrompt(
                  prompt: l10n.loginRegisterPrompt,
                  actionLabel: l10n.loginRegisterAction,
                  onPressed: isLoading ? null : onRegister,
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

class _DividerLabel extends StatelessWidget {
  const _DividerLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final dividerColor = Color.lerp(
      context.colors.onSurface,
      context.colors.surface,
      AppOpacity.inputFillDark,
    );

    return Row(
      children: [
        Expanded(child: Divider(color: dividerColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
          child: AppText.bodySmall(
            label,
            color: Color.lerp(
              context.colors.onSurface,
              context.colors.surface,
              AppOpacity.mutedText,
            ),
          ),
        ),
        Expanded(child: Divider(color: dividerColor)),
      ],
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: const ButtonStyle(
        minimumSize: WidgetStatePropertyAll(
          Size(0, AppSize.primaryButtonHeight),
        ),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: AppSpace.xxl),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AppSvgImage(
            asset: AppSvg.iconGoogle,
            width: AppSize.iconMedium,
            height: AppSize.iconMedium,
          ),
          const SizedBox(width: AppSpace.lg),
          Flexible(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

class _RegisterPrompt extends StatelessWidget {
  const _RegisterPrompt({
    required this.prompt,
    required this.actionLabel,
    required this.onPressed,
  });

  final String prompt;
  final String actionLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpace.xs,
      children: [
        AppText.bodySmall(
          prompt,
          color: Color.lerp(
            context.colors.onSurface,
            context.colors.surface,
            AppOpacity.mutedText,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpace.md,
              vertical: AppSpace.sm,
            ),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(actionLabel),
        ),
      ],
    );
  }
}
