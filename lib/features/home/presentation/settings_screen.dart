import 'package:clips_tack/app/cubit/app_settings_cubit.dart';
import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/clipboard/cubit/clipboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<AppSettingsCubit>().state;
    final clipboardState = context.watch<ClipboardCubit>().state;
    final l10n = context.l10n;

    return ListView(
      padding: AppInsets.pageWithBottomNav,
      children: [
        AppText.bodyLarge(l10n.settingsIntro),
        const SizedBox(height: AppSpace.screen),
        _SettingsCard(
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
        _SettingsCard(
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
        _SettingsCard(
          title: l10n.clipboardSectionTitle,
          child: Column(
            children: [
              _StatsTile(
                icon: Icons.bolt_rounded,
                title: l10n.autoTrackingTitle,
                subtitle: l10n.autoTrackingSubtitle,
              ),
              const SizedBox(height: AppSpace.lg),
              _StatsTile(
                icon: Icons.layers_rounded,
                title: l10n.savedSnippetsTitle,
                subtitle: l10n.savedSnippetsSubtitle(
                  clipboardState.items.length,
                ),
              ),
              const SizedBox(height: AppSpace.lg),
              _StatsTile(
                icon: Icons.push_pin_rounded,
                title: l10n.pinnedSnippetsTitle,
                subtitle: l10n.pinnedSnippetsSubtitle(
                  clipboardState.pinnedCount,
                ),
              ),
              const SizedBox(height: AppSpace.lg),
              _StatsTile(
                icon: Icons.copy_all_rounded,
                title: l10n.duplicateProtectionTitle,
                subtitle: l10n.duplicateProtectionSubtitle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.panel,
      decoration: BoxDecoration(
        color: Color.lerp(
          context.colors.surface,
          context.colors.primary,
          AppOpacity.softSurface,
        ),
        borderRadius: AppRadius.large,
        border: Border.all(
          color: Color.lerp(
            context.colors.outline,
            context.colors.surface,
            AppOpacity.mediumOutline,
          )!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.titleMedium(title),
          const SizedBox(height: AppSpace.lg),
          child,
        ],
      ),
    );
  }
}

class _StatsTile extends StatelessWidget {
  const _StatsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
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
          child: Icon(icon, color: context.colors.primary),
        ),
        const SizedBox(width: AppSpace.xl),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.titleMedium(title),
              const SizedBox(height: AppSpace.xxs),
              AppText.bodySmall(subtitle),
            ],
          ),
        ),
      ],
    );
  }
}
