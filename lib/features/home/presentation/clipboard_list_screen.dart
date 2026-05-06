import 'dart:async';

import 'package:clips_tack/app/router/app_router.dart';
import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_button.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:clips_tack/features/clipboard/cubit/clipboard_cubit.dart';
import 'package:clips_tack/features/clipboard/cubit/clipboard_state.dart';
import 'package:clips_tack/features/clipboard/models/clipboard_item.dart';
import 'package:clips_tack/features/home/models/clip_editor_payload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

enum ClipboardListMode { history, starred }

class ClipboardListScreen extends StatefulWidget {
  const ClipboardListScreen({required this.mode, super.key});

  final ClipboardListMode mode;

  @override
  State<ClipboardListScreen> createState() => _ClipboardListScreenState();
}

class _ClipboardListScreenState extends State<ClipboardListScreen> {
  late final TextEditingController _searchController;
  Timer? _clockTimer;
  DateTime _now = DateTime.now();

  bool get _pinnedOnly => widget.mode == ClipboardListMode.starred;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: context.read<ClipboardCubit>().state.searchQuery,
    )..addListener(_onSearchChanged);

    _clockTimer = Timer.periodic(AppDuration.relativeTimeTicker, (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<ClipboardCubit>().setSearchQuery(_searchController.text);
  }

  Future<void> _copyItem(ClipboardItem item) async {
    await context.read<ClipboardCubit>().copyClip(item);
    if (!mounted) {
      return;
    }

    _showSnackBar(context.l10n.copiedMessage);
  }

  Future<void> _showItemActions(ClipboardItem item) async {
    final action = await showModalBottomSheet<_ClipboardItemAction>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (sheetContext) {
        final l10n = sheetContext.l10n;

        return SafeArea(
          child: Padding(
            padding: AppInsets.sheet,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ActionTile(
                  icon: Icons.copy_rounded,
                  label: l10n.copyAction,
                  onTap: () =>
                      Navigator.of(sheetContext).pop(_ClipboardItemAction.copy),
                ),
                _ActionTile(
                  icon: item.isPinned
                      ? Icons.push_pin_outlined
                      : Icons.push_pin_rounded,
                  label: item.isPinned ? l10n.unpinAction : l10n.pinAction,
                  onTap: () =>
                      Navigator.of(sheetContext).pop(_ClipboardItemAction.pin),
                ),
                _ActionTile(
                  icon: Icons.edit_rounded,
                  label: l10n.editAction,
                  onTap: () =>
                      Navigator.of(sheetContext).pop(_ClipboardItemAction.edit),
                ),
                _ActionTile(
                  icon: Icons.delete_outline_rounded,
                  label: l10n.deleteAction,
                  destructive: true,
                  onTap: () => Navigator.of(
                    sheetContext,
                  ).pop(_ClipboardItemAction.delete),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || action == null) {
      return;
    }

    final cubit = context.read<ClipboardCubit>();

    switch (action) {
      case _ClipboardItemAction.copy:
        await _copyItem(item);
      case _ClipboardItemAction.pin:
        cubit.togglePin(item.id);
        _showSnackBar(
          item.isPinned
              ? context.l10n.unpinnedMessage
              : context.l10n.pinnedMessage,
        );
      case _ClipboardItemAction.delete:
        cubit.deleteClip(item.id);
        _showSnackBar(context.l10n.deletedMessage);
      case _ClipboardItemAction.edit:
        final message = await context.pushNamed<String>(
          AppRoutes.editorName,
          extra: ClipEditorPayload(
            clipId: item.id,
            initialContent: item.content,
          ),
        );

        if (!context.mounted || message == null) {
          return;
        }

        _showSnackBar(message);
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
    return BlocListener<ClipboardCubit, ClipboardState>(
      listenWhen: (previous, current) =>
          previous.searchQuery != current.searchQuery &&
          current.searchQuery != _searchController.text,
      listener: (context, state) {
        _searchController.value = TextEditingValue(
          text: state.searchQuery,
          selection: TextSelection.collapsed(offset: state.searchQuery.length),
        );
      },
      child: BlocBuilder<ClipboardCubit, ClipboardState>(
        builder: (context, state) {
          final l10n = context.l10n;
          final source = _pinnedOnly ? state.pinnedItems : state.items;
          final visibleItems = state.visibleItems(pinnedOnly: _pinnedOnly);
          final label = _pinnedOnly
              ? l10n.pinnedSnippetsTitle
              : l10n.recentSnippetsTitle;
          final helper = _pinnedOnly
              ? l10n.pinnedSnippetsHelper
              : l10n.recentSnippetsHelper;

          return Column(
            children: [
              Padding(
                padding: AppInsets.sectionHeader,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: l10n.searchClipboardPlaceholder,
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: state.hasSearchQuery
                            ? AppButton.icon(
                                icon: Icons.close_rounded,
                                onPressed: _searchController.clear,
                                tooltip: l10n.clearSearchTooltip,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: AppSpace.xxxl),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.titleMedium(label),
                              const SizedBox(height: AppSpace.xs),
                              AppText.bodySmall(
                                helper,
                                color: Color.lerp(
                                  context.colors.onSurface,
                                  context.colors.surface,
                                  AppOpacity.mutedText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _CountBadge(label: l10n.itemCount(visibleItems.length)),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: AppDuration.short,
                  child: _buildContent(
                    context: context,
                    allItemsEmpty: state.items.isEmpty,
                    source: source,
                    visibleItems: visibleItems,
                    hasSearchQuery: state.hasSearchQuery,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required bool allItemsEmpty,
    required List<ClipboardItem> source,
    required List<ClipboardItem> visibleItems,
    required bool hasSearchQuery,
  }) {
    final l10n = context.l10n;

    if (allItemsEmpty) {
      return Padding(
        key: const ValueKey('empty-history'),
        padding: AppInsets.listWithFab,
        child: const _EmptyStateCard(),
      );
    }

    if (source.isEmpty && _pinnedOnly) {
      return Center(
        key: const ValueKey('empty-starred'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.panel),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.star_border_rounded,
                size: AppSize.iconLarge,
                color: Color.lerp(
                  context.colors.onSurface,
                  context.colors.surface,
                  AppOpacity.mutedText,
                ),
              ),
              const SizedBox(height: AppSpace.xl),
              AppText.bodyLarge(
                l10n.pinClipPrompt,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (visibleItems.isEmpty) {
      final message = hasSearchQuery
          ? l10n.noSearchResultsMessage
          : l10n.pinClipPrompt;

      return Center(
        key: const ValueKey('no-results'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.panel),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: AppSize.iconLarge,
                color: Color.lerp(
                  context.colors.onSurface,
                  context.colors.surface,
                  AppOpacity.mutedText,
                ),
              ),
              const SizedBox(height: AppSpace.xl),
              AppText.bodyLarge(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      key: ValueKey('list-${widget.mode.name}'),
      padding: AppInsets.listWithFab,
      itemBuilder: (context, index) {
        final item = visibleItems[index];
        return _ClipboardCard(
          item: item,
          relativeTime: _formatRelativeTime(context, item.createdAt, _now),
          onTap: () => _copyItem(item),
          onLongPress: () => _showItemActions(item),
        );
      },
      separatorBuilder: (_, _) => const SizedBox(height: AppSpace.lg),
      itemCount: visibleItems.length,
    );
  }
}

class _ClipboardCard extends StatelessWidget {
  const _ClipboardCard({
    required this.item,
    required this.relativeTime,
    required this.onTap,
    required this.onLongPress,
  });

  final ClipboardItem item;
  final String relativeTime;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final borderColor = Color.lerp(
      context.colors.outline,
      context.colors.surface,
      AppOpacity.strongOutline,
    )!;
    final surfaceTint = Color.lerp(
      context.colors.surface,
      context.colors.primary,
      item.isPinned ? AppOpacity.tintedSurface : AppOpacity.subtleSurface,
    )!;
    final kindIcon = switch (item.kind) {
      ClipKind.link => Icons.link_rounded,
      ClipKind.phone => Icons.phone_rounded,
      ClipKind.text => null,
    };
    final contentStyle = context.text.bodyLarge?.copyWith(
      height: AppTypography.contentLineHeight,
      color: item.kind == ClipKind.link
          ? context.colors.primary
          : context.colors.onSurface,
      fontWeight: FontWeight.w500,
      decoration: item.kind == ClipKind.link
          ? TextDecoration.underline
          : TextDecoration.none,
      decorationColor: context.colors.primary,
    );
    final chips = <Widget>[
      if (item.kind == ClipKind.link) _MetaChip(label: context.l10n.linkChip),
      if (item.kind == ClipKind.phone) _MetaChip(label: context.l10n.phoneChip),
      if (item.isPinned)
        _MetaChip(label: context.l10n.pinnedChip, icon: Icons.push_pin_rounded),
    ];

    return Material(
      color: surfaceTint,
      borderRadius: AppRadius.large,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: AppRadius.large,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: AppRadius.large,
            border: Border.all(color: borderColor),
          ),
          child: Padding(
            padding: AppInsets.panel,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppText.bodySmall(
                        relativeTime,
                        fontWeight: FontWeight.w600,
                        letterSpacing: AppTypography.timestampLetterSpacing,
                        color: Color.lerp(
                          context.colors.onSurface,
                          context.colors.surface,
                          AppOpacity.mutedText,
                        ),
                      ),
                    ),
                    if (kindIcon != null) ...[
                      Icon(
                        kindIcon,
                        size: AppSize.iconMedium,
                        color: context.colors.primary,
                      ),
                      const SizedBox(width: AppSpace.md),
                    ],
                    if (item.isPinned)
                      Icon(
                        Icons.push_pin_rounded,
                        size: AppSize.iconMedium,
                        color: context.colors.primary,
                      ),
                  ],
                ),
                const SizedBox(height: AppSpace.lg),
                Text(
                  item.preview,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: contentStyle,
                ),
                if (chips.isNotEmpty) ...[
                  const SizedBox(height: AppSpace.xl),
                  Wrap(
                    spacing: AppSpace.md,
                    runSpacing: AppSpace.md,
                    children: chips,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label, this.icon});

  final String label;
  final IconData? icon;

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
          if (icon != null) ...[
            Icon(icon, size: AppSize.iconSmall, color: context.colors.primary),
            const SizedBox(width: AppSpace.sm),
          ],
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

class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppInsets.badge,
      decoration: BoxDecoration(
        color: Color.lerp(
          context.colors.surface,
          context.colors.primary,
          AppOpacity.tintedSurface,
        ),
        borderRadius: AppRadius.pill,
      ),
      child: AppText.bodySmall(
        label,
        color: context.colors.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color = destructive ? context.colors.error : context.colors.onSurface;

    return ListTile(
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
      leading: Icon(icon, color: color),
      title: AppText.bodyLarge(label, color: color),
      onTap: onTap,
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRoundedRectPainter(color: context.colors.outline),
      child: Container(
        width: double.infinity,
        padding: AppInsets.emptyState,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_rounded,
              size: AppSize.emptyStateIcon,
              color: context.colors.primary,
            ),
            const SizedBox(height: AppSpace.xxl),
            AppText.bodyLarge(
              context.l10n.emptyClipboardDescription,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedRoundedRectPainter extends CustomPainter {
  const _DashedRoundedRectPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = AppStroke.regular
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          const Radius.circular(AppRadius.fieldValue),
        ),
      );

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      const dashWidth = AppSpace.base;
      const dashGap = AppSpace.dashGap;

      while (distance < metric.length) {
        final end = distance + dashWidth;
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedRectPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

String _formatRelativeTime(
  BuildContext context,
  DateTime createdAt,
  DateTime now,
) {
  final l10n = context.l10n;
  final difference = now.difference(createdAt);

  if (difference.isNegative ||
      difference.inSeconds < AppTime.justNowThresholdSeconds) {
    return l10n.justNow.toUpperCase();
  }

  if (difference.inMinutes < AppTime.minutesPerHour) {
    return l10n.minutesAgo(difference.inMinutes).toUpperCase();
  }

  if (difference.inHours < AppTime.hoursPerDay) {
    return l10n.hoursAgo(difference.inHours).toUpperCase();
  }

  if (difference.inDays < AppTime.daysPerWeek) {
    return l10n.daysAgo(difference.inDays).toUpperCase();
  }

  final weeks = (difference.inDays / AppTime.daysPerWeek).floor();
  return l10n.weeksAgo(weeks).toUpperCase();
}

enum _ClipboardItemAction { copy, pin, delete, edit }
