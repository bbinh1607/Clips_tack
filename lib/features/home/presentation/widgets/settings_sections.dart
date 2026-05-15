import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/home/presentation/controllers/overlay_bubble_controller.dart';
import 'package:clips_tack/features/home/presentation/widgets/settings_action_tile.dart';
import 'package:clips_tack/features/home/presentation/widgets/settings_card.dart';
import 'package:clips_tack/features/home/presentation/widgets/settings_overlay_bubble_tile.dart';
import 'package:clips_tack/features/home/presentation/widgets/settings_stats_tile.dart';
import 'package:flutter/material.dart';

class SettingsAppearanceSection extends StatelessWidget {
  const SettingsAppearanceSection({
    required this.themeMode,
    required this.onToggleTheme,
    super.key,
  });

  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SettingsCard(
      title: l10n.appearanceTitle,
      child: SwitchListTile.adaptive(
        value: themeMode == ThemeMode.dark,
        onChanged: (_) => onToggleTheme(),
        contentPadding: EdgeInsets.zero,
        title: AppText.bodyLarge(l10n.darkModeTitle),
        subtitle: AppText.bodySmall(l10n.darkModeSubtitle),
      ),
    );
  }
}

class SettingsLanguageSection extends StatelessWidget {
  const SettingsLanguageSection({
    required this.locale,
    required this.onLocaleSelected,
    super.key,
  });

  final Locale locale;
  final ValueChanged<Locale> onLocaleSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SettingsCard(
      title: l10n.languageTitle,
      child: Wrap(
        spacing: AppSpace.base,
        runSpacing: AppSpace.base,
        children: [
          ChoiceChip(
            label: AppText.bodyMedium(l10n.languageEnglish),
            selected: locale.languageCode == 'en',
            onSelected: (_) => onLocaleSelected(const Locale('en')),
          ),
          ChoiceChip(
            label: AppText.bodyMedium(l10n.languageVietnamese),
            selected: locale.languageCode == 'vi',
            onSelected: (_) => onLocaleSelected(const Locale('vi')),
          ),
        ],
      ),
    );
  }
}

class SettingsOverlayBubbleSection extends StatelessWidget {
  const SettingsOverlayBubbleSection({
    required this.state,
    required this.onChanged,
    super.key,
  });

  final OverlayBubbleSettingsState state;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: context.l10n.overlaySectionTitle,
      child: SettingsOverlayBubbleTile(state: state, onChanged: onChanged),
    );
  }
}

class SettingsClipboardSection extends StatelessWidget {
  const SettingsClipboardSection({
    required this.totalCount,
    required this.pinnedCount,
    super.key,
  });

  final int totalCount;
  final int pinnedCount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SettingsCard(
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
            subtitle: l10n.savedSnippetsSubtitle(totalCount),
          ),
          const SizedBox(height: AppSpace.lg),
          SettingsStatsTile(
            icon: Icons.push_pin_rounded,
            title: l10n.pinnedSnippetsTitle,
            subtitle: l10n.pinnedSnippetsSubtitle(pinnedCount),
          ),
          const SizedBox(height: AppSpace.lg),
          SettingsStatsTile(
            icon: Icons.copy_all_rounded,
            title: l10n.duplicateProtectionTitle,
            subtitle: l10n.duplicateProtectionSubtitle,
          ),
        ],
      ),
    );
  }
}

class SettingsAccountSection extends StatelessWidget {
  const SettingsAccountSection({
    required this.isLoading,
    required this.onLogout,
    super.key,
  });

  final bool isLoading;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SettingsCard(
      title: l10n.accountSectionTitle,
      child: SettingsActionTile(
        icon: Icons.logout_rounded,
        title: l10n.logoutAction,
        subtitle: l10n.logoutSubtitle,
        onTap: isLoading ? null : onLogout,
      ),
    );
  }
}
