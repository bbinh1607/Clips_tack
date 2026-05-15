import 'package:clips_tack/core/constants/app_constants.dart';
import 'package:clips_tack/core/extensions/context_ext.dart';
import 'package:flutter/material.dart';

String formatRelativeTime(
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
