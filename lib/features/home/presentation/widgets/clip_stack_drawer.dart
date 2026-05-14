import 'package:clips_tack/app/router/app_router.dart';
import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ClipStackDrawer extends StatelessWidget {
  const ClipStackDrawer({
    required this.currentIndex,
    required this.totalCount,
    required this.pinnedCount,
    super.key,
  });

  final int currentIndex;
  final int totalCount;
  final int pinnedCount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: AppInsets.page,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: AppInsets.panel,
                decoration: BoxDecoration(
                  color: Color.lerp(
                    context.colors.surface,
                    context.colors.primary,
                    AppOpacity.tintedSurface,
                  ),
                  borderRadius: AppRadius.large,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.titleLarge(
                      l10n.appName,
                      color: context.colors.primary,
                    ),
                    const SizedBox(height: AppSpace.sm),
                    AppText.bodyMedium(l10n.drawerDescription),
                  ],
                ),
              ),
              const SizedBox(height: AppSpace.section),
              _DrawerTile(
                icon: Icons.history_rounded,
                label: l10n.historyTab,
                selected: currentIndex == 0,
                onTap: () {
                  Navigator.of(context).pop();
                  context.go(AppRoutes.history);
                },
              ),
              _DrawerTile(
                icon: Icons.star_rounded,
                label: l10n.starredTab,
                selected: currentIndex == 1,
                onTap: () {
                  Navigator.of(context).pop();
                  context.go(AppRoutes.starred);
                },
              ),
              _DrawerTile(
                icon: Icons.settings_rounded,
                label: l10n.settingsTitle,
                selected: currentIndex == 2,
                onTap: () {
                  Navigator.of(context).pop();
                  context.go(AppRoutes.settings);
                },
              ),
              const Spacer(),
              const Divider(),
              _DrawerTile(
                icon: Icons.logout_rounded,
                label: l10n.logoutAction,
                selected: false,
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<AuthBloc>().add(const AuthEvent.logout());
                },
              ),
              const SizedBox(height: AppSpace.lg),
              AppText.bodySmall(
                l10n.savedPinnedSummary(totalCount, pinnedCount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final background = selected
        ? Color.lerp(
            context.colors.surface,
            context.colors.primary,
            AppOpacity.selectedSurface,
          )
        : Colors.transparent;

    return Padding(
      padding: AppInsets.drawerTileSpacing,
      child: ListTile(
        onTap: onTap,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
        tileColor: background,
        leading: Icon(
          icon,
          color: selected ? context.colors.primary : context.colors.onSurface,
        ),
        title: AppText.bodyLarge(
          label,
          color: selected ? context.colors.primary : context.colors.onSurface,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
