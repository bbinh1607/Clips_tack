import 'package:clips_tack/app/router/app_router.dart';
import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_button.dart';
import 'package:clips_tack/core/widgets/app_scaffold.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/clipboard/cubit/clipboard_cubit.dart';
import 'package:clips_tack/features/home/models/clip_editor_payload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ClipStackShell extends StatefulWidget {
  const ClipStackShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<ClipStackShell> createState() => _ClipStackShellState();
}

class _ClipStackShellState extends State<ClipStackShell> {
  bool get _isSettingsTab => widget.navigationShell.currentIndex == 2;

  Future<void> _openEditor() async {
    final draft = await context.read<ClipboardCubit>().loadClipboardDraft();
    if (!mounted) {
      return;
    }

    final message = await context.pushNamed<String>(
      AppRoutes.editor,
      extra: ClipEditorPayload(initialContent: draft ?? ''),
    );

    if (!mounted || message == null) {
      return;
    }

    _showSnackBar(message);
  }

  void _onDestinationSelected(int index) {
    context.hideKeyboard();
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  void _showSnackBar(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: AppText.bodyMedium(message)));
  }

  @override
  Widget build(BuildContext context) {
    final clipboardState = context.watch<ClipboardCubit>().state;
    final l10n = context.l10n;

    return AppScaffold(
      drawer: ClipStackDrawer(
        currentIndex: widget.navigationShell.currentIndex,
        totalCount: clipboardState.items.length,
        pinnedCount: clipboardState.pinnedCount,
      ),
      titleWidget: AppText.titleLarge(
        _isSettingsTab ? l10n.settingsTitle : l10n.appName,
        color: _isSettingsTab
            ? context.colors.onSurface
            : context.colors.primary,
      ),
      actions: [
        if (_isSettingsTab)
          const SizedBox(width: AppSize.appBarActionPlaceholder)
        else
          AppButton.icon(
            icon: Icons.settings_rounded,
            onPressed: () => context.go(AppRoutes.settings),
            tooltip: l10n.settingsTooltip,
          ),
      ],
      body: widget.navigationShell,
      floatingActionButton: _isSettingsTab
          ? null
          : FloatingActionButton(
              onPressed: _openEditor,
              tooltip: l10n.saveClipTooltip,
              child: const Icon(Icons.content_paste_rounded),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.history_rounded),
            label: l10n.historyTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.star_rounded),
            label: l10n.starredTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_rounded),
            label: l10n.settingsTitle,
          ),
        ],
      ),
    );
  }
}

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
