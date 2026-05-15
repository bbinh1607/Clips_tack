import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:clips_tack/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ClipboardEmptyHistory extends StatelessWidget {
  const ClipboardEmptyHistory({super.key});

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

class ClipboardEmptyStarred extends StatelessWidget {
  const ClipboardEmptyStarred({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
              context.l10n.pinClipPrompt,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ClipboardNoResults extends StatelessWidget {
  const ClipboardNoResults({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
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
