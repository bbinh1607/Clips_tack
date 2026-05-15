import 'dart:ui';

import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class ClipDetailRouteTransition extends StatelessWidget {
  const ClipDetailRouteTransition({
    required this.animation,
    required this.child,
    this.sourceRect,
    super.key,
  });

  final Animation<double> animation;
  final Rect? sourceRect;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final source = sourceRect;
    if (source == null ||
        source.isEmpty ||
        !source.isFinite ||
        source.width <= 0 ||
        source.height <= 0) {
      return _FadeClipDetailRouteTransition(animation: animation, child: child);
    }

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final curve = animation.status == AnimationStatus.reverse
            ? Curves.easeInOutCubic
            : Curves.easeOutCubic;
        final value = curve.transform(animation.value);
        final screenRect = Offset.zero & MediaQuery.sizeOf(context);
        final rect = Rect.lerp(source, screenRect, value)!;
        final radius = lerpDouble(AppRadius.largeValue, 0, value)!;

        return Stack(
          fit: StackFit.expand,
          children: [
            _ClipDetailRouteBackdrop(progress: value),
            Positioned.fromRect(
              rect: rect,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: OverflowBox(
                  alignment: Alignment.topLeft,
                  minWidth: screenRect.width,
                  maxWidth: screenRect.width,
                  minHeight: screenRect.height,
                  maxHeight: screenRect.height,
                  child: SizedBox.fromSize(size: screenRect.size, child: child),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FadeClipDetailRouteTransition extends StatelessWidget {
  const _FadeClipDetailRouteTransition({
    required this.animation,
    required this.child,
  });

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final value = Curves.easeOutCubic.transform(animation.value);

        return Stack(
          fit: StackFit.expand,
          children: [
            _ClipDetailRouteBackdrop(progress: value),
            FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
                reverseCurve: Curves.easeInCubic,
              ),
              child: child,
            ),
          ],
        );
      },
    );
  }
}

class _ClipDetailRouteBackdrop extends StatelessWidget {
  const _ClipDetailRouteBackdrop({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: progress * 6, sigmaY: progress * 6),
      child: ColoredBox(
        color: colorScheme.scrim.withValues(alpha: progress * 0.26),
      ),
    );
  }
}
