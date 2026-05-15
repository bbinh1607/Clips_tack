import 'package:clips_tack/app/cubit/app_settings_cubit.dart';
import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:clips_tack/features/clipboard/presentation/bloc/clipboard_bloc.dart';
import 'package:clips_tack/features/home/presentation/controllers/overlay_bubble_controller.dart';
import 'package:clips_tack/features/home/presentation/widgets/settings_account_identity_tile.dart';
import 'package:clips_tack/features/home/presentation/widgets/settings_sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with WidgetsBindingObserver {
  late final OverlayBubbleController _overlayBubbleController;

  @override
  void initState() {
    super.initState();
    _overlayBubbleController = OverlayBubbleController();
    WidgetsBinding.instance.addObserver(this);
    _refreshOverlayState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _overlayBubbleController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshOverlayState();
    }
  }

  Future<void> _refreshOverlayState() async {
    final feedback = await _overlayBubbleController.refresh();

    if (!mounted) {
      return;
    }

    _showOverlayFeedback(feedback);
  }

  Future<void> _setBubbleEnabled(bool value) async {
    final feedback = await _overlayBubbleController.setBubbleEnabled(
      value,
      confirmPermission: _confirmOverlayPermission,
    );

    if (!mounted) {
      return;
    }

    _showOverlayFeedback(feedback);
  }

  Future<bool> _confirmOverlayPermission() async {
    final materialL10n = MaterialLocalizations.of(context);

    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: AppText.titleMedium(context.l10n.overlayBubbleTitle),
              content: AppText.bodyMedium(
                context.l10n.overlayPermissionMessage,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: Text(materialL10n.cancelButtonLabel),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: Text(materialL10n.okButtonLabel),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _showOverlayFeedback(OverlayBubbleFeedback? feedback) {
    if (feedback == null) {
      return;
    }

    switch (feedback) {
      case OverlayBubbleFeedback.started:
        _showSnackBar(context.l10n.overlayStartedMessage);
      case OverlayBubbleFeedback.stopped:
        _showSnackBar(context.l10n.overlayStoppedMessage);
      case OverlayBubbleFeedback.permissionNeeded:
        _showSnackBar(context.l10n.overlayPermissionMessage);
    }
  }

  void _showSnackBar(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: AppText.bodyMedium(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _overlayBubbleController,
      builder: (context, child) {
        final settingsState = context.watch<AppSettingsCubit>().state;
        final clipboardState = context.watch<ClipboardBloc>().state;
        final authState = context.watch<AuthBloc>().state;
        final authUser = authState.maybeWhen(
          authenticated: (user) => user,
          orElse: () => null,
        );
        final isAuthLoading = authState.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
        final l10n = context.l10n;

        return ListView(
          padding: AppInsets.pageWithBottomNav,
          children: [
            SettingsAccountIdentityTile(user: authUser),
            const SizedBox(height: AppSpace.screen),
            AppText.bodyLarge(l10n.settingsIntro),
            const SizedBox(height: AppSpace.screen),
            SettingsAppearanceSection(
              themeMode: settingsState.themeMode,
              onToggleTheme: context.read<AppSettingsCubit>().toggleTheme,
            ),
            const SizedBox(height: AppSpace.xxl),
            SettingsLanguageSection(
              locale: settingsState.locale,
              onLocaleSelected: context.read<AppSettingsCubit>().setLocale,
            ),
            const SizedBox(height: AppSpace.xxl),
            SettingsOverlayBubbleSection(
              state: _overlayBubbleController.state,
              onChanged: _setBubbleEnabled,
            ),
            const SizedBox(height: AppSpace.xxl),
            SettingsClipboardSection(
              totalCount: clipboardState.items.length,
              pinnedCount: clipboardState.pinnedCount,
            ),
            const SizedBox(height: AppSpace.xxl),
            SettingsAccountSection(
              isLoading: isAuthLoading,
              onLogout: () =>
                  context.read<AuthBloc>().add(const AuthEvent.logout()),
            ),
          ],
        );
      },
    );
  }
}
