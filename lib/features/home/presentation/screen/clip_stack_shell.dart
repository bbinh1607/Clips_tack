import 'package:clips_tack/app/router/app_router.dart';
import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_button.dart';
import 'package:clips_tack/core/widgets/app_scaffold.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/clipboard/presentation/bloc/clipboard_bloc.dart';
import 'package:clips_tack/features/home/models/clip_editor_payload.dart';
import 'package:clips_tack/features/home/presentation/widgets/clip_stack_drawer.dart';
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
    final draft = await context.read<ClipboardBloc>().loadClipboardDraft();
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
    final clipboardState = context.watch<ClipboardBloc>().state;
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
