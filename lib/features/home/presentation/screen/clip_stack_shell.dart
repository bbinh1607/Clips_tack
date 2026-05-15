import 'dart:async';

import 'package:clips_tack/app/router/app_router.dart';
import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/platform/mobile_shortcut_channel.dart';
import 'package:clips_tack/core/widgets/app_button.dart';
import 'package:clips_tack/core/widgets/app_scaffold.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/clipboard/presentation/bloc/clipboard_bloc.dart';
import 'package:clips_tack/features/clipboard/presentation/models/clip_editor_payload.dart';
import 'package:clips_tack/features/home/presentation/widgets/clip_stack_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ClipStackShell extends StatefulWidget {
  const ClipStackShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<ClipStackShell> createState() => _ClipStackShellState();
}

class _ClipStackShellState extends State<ClipStackShell> {
  StreamSubscription<String>? _shortcutSubscription;

  bool get _isSettingsTab => widget.navigationShell.currentIndex == 2;

  @override
  void initState() {
    super.initState();
    MobileShortcutChannel.initialize();
    _shortcutSubscription = MobileShortcutChannel.actions.listen(
      _handleMobileShortcut,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleInitialMobileShortcut();
    });
  }

  @override
  void dispose() {
    _shortcutSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handleInitialMobileShortcut() async {
    final action = await MobileShortcutChannel.getInitialAction();

    if (!mounted || action == null || action.isEmpty) {
      return;
    }

    await MobileShortcutChannel.clearInitialAction();
    _handleMobileShortcut(action);
  }

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

  void _handleMobileShortcut(String action) {
    switch (action) {
      case MobileShortcutAction.createClip:
        _openEditor();
        break;
      case MobileShortcutAction.searchClips:
        _onDestinationSelected(0);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          MobileShortcutChannel.requestSearchFocus();
        });
        break;
      case MobileShortcutAction.openPinned:
        _onDestinationSelected(1);
        break;
      case MobileShortcutAction.openHome:
        _onDestinationSelected(0);
        break;
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
    final clipboardState = context.watch<ClipboardBloc>().state;
    final l10n = context.l10n;

    return Focus(
      autofocus: true,
      child: CallbackShortcuts(
        bindings: <ShortcutActivator, VoidCallback>{
          const SingleActivator(LogicalKeyboardKey.keyN, control: true):
              _openEditor,
          const SingleActivator(LogicalKeyboardKey.keyN, meta: true):
              _openEditor,
          const SingleActivator(LogicalKeyboardKey.digit1, control: true): () =>
              _onDestinationSelected(0),
          const SingleActivator(LogicalKeyboardKey.digit1, meta: true): () =>
              _onDestinationSelected(0),
          const SingleActivator(LogicalKeyboardKey.digit2, control: true): () =>
              _onDestinationSelected(1),
          const SingleActivator(LogicalKeyboardKey.digit2, meta: true): () =>
              _onDestinationSelected(1),
          const SingleActivator(LogicalKeyboardKey.digit3, control: true): () =>
              _onDestinationSelected(2),
          const SingleActivator(LogicalKeyboardKey.digit3, meta: true): () =>
              _onDestinationSelected(2),
        },
        child: AppScaffold(
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
        ),
      ),
    );
  }
}
