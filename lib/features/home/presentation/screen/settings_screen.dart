import 'package:clips_tack/app/cubit/app_settings_cubit.dart';
import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:clips_tack/features/clipboard/presentation/bloc/clipboard_bloc.dart';
import 'package:clips_tack/features/home/data/overlay_bubble_channel.dart';
import 'package:clips_tack/features/home/presentation/widgets/settings_action_tile.dart';
import 'package:clips_tack/features/home/presentation/widgets/settings_card.dart';
import 'package:clips_tack/features/home/presentation/widgets/settings_stats_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with WidgetsBindingObserver {
  static const _overlayBubble = OverlayBubbleChannel();
  static const _overlayBubbleEnabledKey = 'overlay_bubble_enabled';

  bool _hasOverlayPermission = false;
  bool _isBubbleRunning = false;
  bool _isOverlayBusy = true;
  bool _shouldShowBubble = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshOverlayState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshOverlayState();
    }
  }

  Future<void> _refreshOverlayState() async {
    final prefs = await SharedPreferences.getInstance();
    final shouldShowBubble = prefs.getBool(_overlayBubbleEnabledKey) ?? false;
    final hasPermission = await _overlayBubble.hasPermission();
    var isRunning = await _overlayBubble.isBubbleRunning();

    if (hasPermission && shouldShowBubble && !isRunning) {
      await _overlayBubble.startBubble();
      await Future<void>.delayed(const Duration(milliseconds: 250));
      isRunning = await _overlayBubble.isBubbleRunning();
      if (mounted && isRunning) {
        _showSnackBar(context.l10n.overlayStartedMessage);
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _shouldShowBubble = shouldShowBubble;
      _hasOverlayPermission = hasPermission;
      _isBubbleRunning = isRunning;
      _isOverlayBusy = false;
    });
  }

  Future<void> _setBubbleEnabled(bool value) async {
    setState(() {
      _isOverlayBusy = true;
      _shouldShowBubble = value;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_overlayBubbleEnabledKey, value);

    if (!value) {
      await _overlayBubble.stopBubble();

      if (!mounted) {
        return;
      }

      setState(() {
        _isBubbleRunning = false;
        _isOverlayBusy = false;
      });
      _showSnackBar(context.l10n.overlayStoppedMessage);
      return;
    }

    if (value && !_hasOverlayPermission) {
      final shouldRequestPermission = await _confirmOverlayPermission();
      if (!mounted) {
        return;
      }

      if (!shouldRequestPermission) {
        await prefs.setBool(_overlayBubbleEnabledKey, false);
        if (!mounted) {
          return;
        }

        setState(() {
          _shouldShowBubble = false;
          _isOverlayBusy = false;
        });
        return;
      }

      final alreadyAllowed = await _overlayBubble.requestPermission();

      if (!mounted) {
        return;
      }

      if (alreadyAllowed) {
        await _overlayBubble.startBubble();
        await Future<void>.delayed(const Duration(milliseconds: 250));
        final started = await _overlayBubble.isBubbleRunning();
        if (!mounted) {
          return;
        }

        setState(() {
          _hasOverlayPermission = true;
          _isBubbleRunning = started;
          _isOverlayBusy = false;
        });
        _showSnackBar(
          started
              ? context.l10n.overlayStartedMessage
              : context.l10n.overlayPermissionMessage,
        );
        return;
      }

      _showSnackBar(context.l10n.overlayPermissionMessage);
      setState(() {
        _isOverlayBusy = false;
      });
      return;
    }

    await _overlayBubble.startBubble();
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final success = await _overlayBubble.isBubbleRunning();

    if (!mounted) {
      return;
    }

    setState(() {
      _isBubbleRunning = success;
      _isOverlayBusy = false;
    });
    _showSnackBar(
      value
          ? context.l10n.overlayStartedMessage
          : context.l10n.overlayStoppedMessage,
    );
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

  void _showSnackBar(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: AppText.bodyMedium(message)));
  }

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<AppSettingsCubit>().state;
    final clipboardState = context.watch<ClipboardBloc>().state;
    final isAuthLoading = context.watch<AuthBloc>().state.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );
    final l10n = context.l10n;

    return ListView(
      padding: AppInsets.pageWithBottomNav,
      children: [
        AppText.bodyLarge(l10n.settingsIntro),
        const SizedBox(height: AppSpace.screen),
        SettingsCard(
          title: l10n.appearanceTitle,
          child: SwitchListTile.adaptive(
            value: settingsState.themeMode == ThemeMode.dark,
            onChanged: (_) => context.read<AppSettingsCubit>().toggleTheme(),
            contentPadding: EdgeInsets.zero,
            title: AppText.bodyLarge(l10n.darkModeTitle),
            subtitle: AppText.bodySmall(l10n.darkModeSubtitle),
          ),
        ),
        const SizedBox(height: AppSpace.xxl),
        SettingsCard(
          title: l10n.languageTitle,
          child: Wrap(
            spacing: AppSpace.base,
            runSpacing: AppSpace.base,
            children: [
              ChoiceChip(
                label: AppText.bodyMedium(l10n.languageEnglish),
                selected: settingsState.locale.languageCode == 'en',
                onSelected: (_) {
                  context.read<AppSettingsCubit>().setLocale(
                    const Locale('en'),
                  );
                },
              ),
              ChoiceChip(
                label: AppText.bodyMedium(l10n.languageVietnamese),
                selected: settingsState.locale.languageCode == 'vi',
                onSelected: (_) {
                  context.read<AppSettingsCubit>().setLocale(
                    const Locale('vi'),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.xxl),
        SettingsCard(
          title: l10n.overlaySectionTitle,
          child: _OverlayBubbleTile(
            shouldShowBubble: _shouldShowBubble,
            hasPermission: _hasOverlayPermission,
            isRunning: _isBubbleRunning,
            isBusy: _isOverlayBusy,
            onChanged: _setBubbleEnabled,
          ),
        ),
        const SizedBox(height: AppSpace.xxl),
        SettingsCard(
          title: l10n.clipboardSectionTitle,
          child: Column(
            children: [
              SettingsStatsTile(
                icon: Icons.bolt_rounded,
                title: l10n.autoTrackingTitle,
                subtitle: l10n.autoTrackingSubtitle,
              ),
              const SizedBox(height: AppSpace.lg),
              SettingsStatsTile(
                icon: Icons.layers_rounded,
                title: l10n.savedSnippetsTitle,
                subtitle: l10n.savedSnippetsSubtitle(
                  clipboardState.items.length,
                ),
              ),
              const SizedBox(height: AppSpace.lg),
              SettingsStatsTile(
                icon: Icons.push_pin_rounded,
                title: l10n.pinnedSnippetsTitle,
                subtitle: l10n.pinnedSnippetsSubtitle(
                  clipboardState.pinnedCount,
                ),
              ),
              const SizedBox(height: AppSpace.lg),
              SettingsStatsTile(
                icon: Icons.copy_all_rounded,
                title: l10n.duplicateProtectionTitle,
                subtitle: l10n.duplicateProtectionSubtitle,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpace.xxl),
        SettingsCard(
          title: l10n.accountSectionTitle,
          child: SettingsActionTile(
            icon: Icons.logout_rounded,
            title: l10n.logoutAction,
            subtitle: l10n.logoutSubtitle,
            onTap: isAuthLoading
                ? null
                : () => context.read<AuthBloc>().add(const AuthEvent.logout()),
          ),
        ),
      ],
    );
  }
}

class _OverlayBubbleTile extends StatelessWidget {
  const _OverlayBubbleTile({
    required this.shouldShowBubble,
    required this.hasPermission,
    required this.isRunning,
    required this.isBusy,
    required this.onChanged,
  });

  final bool shouldShowBubble;
  final bool hasPermission;
  final bool isRunning;
  final bool isBusy;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final subtitle = !hasPermission
        ? l10n.overlayBubblePermissionSubtitle
        : isRunning
        ? l10n.overlayBubbleSubtitleOn
        : l10n.overlayBubbleSubtitleOff;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        height: AppSize.iconContainer,
        width: AppSize.iconContainer,
        decoration: BoxDecoration(
          color: Color.lerp(
            context.colors.surface,
            context.colors.primary,
            AppOpacity.tintedSurface,
          ),
          borderRadius: AppRadius.small,
        ),
        child: Icon(Icons.bubble_chart_rounded, color: context.colors.primary),
      ),
      title: AppText.titleMedium(l10n.overlayBubbleTitle),
      subtitle: AppText.bodySmall(subtitle),
      trailing: Switch.adaptive(
        value: shouldShowBubble && hasPermission && isRunning,
        onChanged: isBusy ? null : onChanged,
      ),
    );
  }
}
