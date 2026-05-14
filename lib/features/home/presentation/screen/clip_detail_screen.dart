import 'package:clips_tack/app/router/app_router.dart';
import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/clipboard/models/clipboard_item.dart';
import 'package:clips_tack/features/clipboard/presentation/bloc/clipboard_bloc.dart';
import 'package:clips_tack/features/home/models/clip_editor_payload.dart';
import 'package:clips_tack/features/home/presentation/utils/relative_time_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ClipDetailScreen extends StatelessWidget {
  const ClipDetailScreen({required this.initialItem, super.key});

  final ClipboardItem initialItem;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClipboardBloc, ClipboardState>(
      builder: (context, state) {
        final item = _findItem(state.items, initialItem.id) ?? initialItem;

        return _ClipDetailView(key: ValueKey(item.id), item: item);
      },
    );
  }

  ClipboardItem? _findItem(List<ClipboardItem> items, String id) {
    for (final item in items) {
      if (item.id == id) {
        return item;
      }
    }

    return null;
  }
}

class _ClipDetailView extends StatefulWidget {
  const _ClipDetailView({required this.item, super.key});

  final ClipboardItem item;

  @override
  State<_ClipDetailView> createState() => _ClipDetailViewState();
}

class _ClipDetailViewState extends State<_ClipDetailView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _contentController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _contentController = AnimationController(
      vsync: this,
      duration: AppDuration.clipDetailContent,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(_fadeAnimation);

    Future<void>.delayed(const Duration(milliseconds: 170), () {
      if (mounted) {
        _contentController.forward();
      }
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _copyItem() async {
    await context.read<ClipboardBloc>().copyClip(widget.item);
    if (!mounted) {
      return;
    }

    _showSnackBar(context.l10n.copiedMessage);
  }

  void _togglePin() {
    context.read<ClipboardBloc>().togglePin(widget.item.id);
    _showSnackBar(
      widget.item.isPinned
          ? context.l10n.unpinnedMessage
          : context.l10n.pinnedMessage,
    );
  }

  Future<void> _editItem() async {
    final message = await context.pushNamed<String>(
      AppRoutes.editor,
      extra: ClipEditorPayload(
        clipId: widget.item.id,
        initialContent: widget.item.content,
      ),
    );

    if (!mounted || message == null) {
      return;
    }

    _showSnackBar(message);
  }

  void _deleteItem() {
    context.read<ClipboardBloc>().deleteClip(widget.item.id);
    context.pop(context.l10n.deletedMessage);
  }

  void _showSnackBar(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: AppText.bodyMedium(message)));
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final l10n = context.l10n;
    final contentStyle = context.text.bodyLarge?.copyWith(
      height: 1.55,
      color: item.kind == ClipKind.link
          ? context.colors.primary
          : context.colors.onSurface,
      fontWeight: FontWeight.w500,
      decoration: item.kind == ClipKind.link
          ? TextDecoration.underline
          : TextDecoration.none,
      decorationColor: context.colors.primary,
    );

    return Scaffold(
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpace.md,
                    AppSpace.sm,
                    AppSpace.md,
                    AppSpace.xs,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: MaterialLocalizations.of(
                          context,
                        ).backButtonTooltip,
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () => context.pop(),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: l10n.copyAction,
                        icon: const Icon(Icons.copy_rounded),
                        onPressed: _copyItem,
                      ),
                      IconButton(
                        tooltip: item.isPinned
                            ? l10n.unpinAction
                            : l10n.pinAction,
                        icon: Icon(
                          item.isPinned
                              ? Icons.push_pin_outlined
                              : Icons.push_pin_rounded,
                        ),
                        onPressed: _togglePin,
                      ),
                      IconButton(
                        tooltip: l10n.editAction,
                        icon: const Icon(Icons.edit_rounded),
                        onPressed: _editItem,
                      ),
                      IconButton(
                        tooltip: l10n.deleteAction,
                        color: context.colors.error,
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: _deleteItem,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpace.screen,
                          AppSpace.lg,
                          AppSpace.screen,
                          AppSpace.section,
                        ),
                        sliver: SliverList.list(
                          children: [
                            Wrap(
                              spacing: AppSpace.md,
                              runSpacing: AppSpace.md,
                              children: [
                                _DetailChip(
                                  icon: Icons.schedule_rounded,
                                  label: formatRelativeTime(
                                    context,
                                    item.createdAt,
                                    DateTime.now(),
                                  ),
                                ),
                                if (item.kind == ClipKind.link)
                                  _DetailChip(
                                    icon: Icons.link_rounded,
                                    label: l10n.linkChip,
                                  ),
                                if (item.kind == ClipKind.phone)
                                  _DetailChip(
                                    icon: Icons.phone_rounded,
                                    label: l10n.phoneChip,
                                  ),
                                if (item.isPinned)
                                  _DetailChip(
                                    icon: Icons.push_pin_rounded,
                                    label: l10n.pinnedChip,
                                  ),
                              ],
                            ),
                            const SizedBox(height: AppSpace.section),
                            SelectableText(item.content, style: contentStyle),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.chip,
      decoration: BoxDecoration(
        color: Color.lerp(
          context.colors.surface,
          context.colors.primary,
          AppOpacity.tintedSurface,
        ),
        borderRadius: AppRadius.pill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: AppSize.iconSmall, color: context.colors.primary),
          const SizedBox(width: AppSpace.sm),
          AppText.bodySmall(
            label,
            color: context.colors.primary,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
