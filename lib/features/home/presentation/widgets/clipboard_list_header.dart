import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_button.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ClipboardListHeader extends StatelessWidget {
  const ClipboardListHeader({
    required this.searchController,
    required this.hasSearchQuery,
    required this.title,
    required this.helper,
    required this.countLabel,
    super.key,
  });

  final TextEditingController searchController;
  final bool hasSearchQuery;
  final String title;
  final String helper;
  final String countLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: AppInsets.sectionHeader,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: searchController,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: l10n.searchClipboardPlaceholder,
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: hasSearchQuery
                  ? AppButton.icon(
                      icon: Icons.close_rounded,
                      onPressed: searchController.clear,
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
                    AppText.titleMedium(title),
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
              _CountBadge(label: countLabel),
            ],
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
