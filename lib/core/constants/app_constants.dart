import 'package:flutter/material.dart';

abstract final class AppSpace {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 6;
  static const double md = 8;
  static const double base = 10;
  static const double lg = 12;
  static const double dashGap = 7;
  static const double xl = 14;
  static const double xxl = 16;
  static const double xxxl = 18;
  static const double screen = 20;
  static const double section = 24;
  static const double panel = 28;
  static const double emptyState = 34;
  static const double fabClearance = 96;
  static const double pageBottom = 120;
}

abstract final class AppInsets {
  static const EdgeInsets page = EdgeInsets.fromLTRB(
    AppSpace.screen,
    AppSpace.xxl,
    AppSpace.screen,
    AppSpace.screen,
  );

  static const EdgeInsets pageWithBottomNav = EdgeInsets.fromLTRB(
    AppSpace.screen,
    AppSpace.xxl,
    AppSpace.screen,
    AppSpace.pageBottom,
  );

  static const EdgeInsets listWithFab = EdgeInsets.fromLTRB(
    AppSpace.screen,
    AppSpace.md,
    AppSpace.screen,
    AppSpace.fabClearance,
  );

  static const EdgeInsets sectionHeader = EdgeInsets.fromLTRB(
    AppSpace.screen,
    AppSpace.xxl,
    AppSpace.screen,
    AppSpace.lg,
  );

  static const EdgeInsets sheet = EdgeInsets.fromLTRB(
    AppSpace.md,
    AppSpace.xs,
    AppSpace.md,
    AppSpace.lg,
  );

  static const EdgeInsets panel = EdgeInsets.all(AppSpace.xxxl);
  static const EdgeInsets chip = EdgeInsets.symmetric(
    horizontal: AppSpace.base,
    vertical: AppSpace.sm,
  );
  static const EdgeInsets badge = EdgeInsets.symmetric(
    horizontal: AppSpace.lg,
    vertical: AppSpace.md,
  );
  static const EdgeInsets emptyState = EdgeInsets.symmetric(
    horizontal: AppSpace.panel,
    vertical: AppSpace.emptyState,
  );
  static const EdgeInsets inputContent = EdgeInsets.symmetric(
    horizontal: AppSpace.xxxl,
    vertical: AppSpace.xxl,
  );
  static const EdgeInsets iconButton = EdgeInsets.all(AppSpace.md);
  static const EdgeInsets drawerTileSpacing = EdgeInsets.only(
    bottom: AppSpace.md,
  );
}

abstract final class AppRadius {
  static const double smallValue = 14;
  static const double mediumValue = 18;
  static const double largeValue = 24;
  static const double fieldValue = 28;
  static const double pillValue = 999;

  static const BorderRadius small = BorderRadius.all(
    Radius.circular(smallValue),
  );
  static const BorderRadius medium = BorderRadius.all(
    Radius.circular(mediumValue),
  );
  static const BorderRadius large = BorderRadius.all(
    Radius.circular(largeValue),
  );
  static const BorderRadius field = BorderRadius.all(
    Radius.circular(fieldValue),
  );
  static const BorderRadius pill = BorderRadius.all(Radius.circular(pillValue));
}

abstract final class AppSize {
  static const double iconSmall = 14;
  static const double iconMedium = 18;
  static const double iconLarge = 36;
  static const double emptyStateIcon = 50;
  static const double iconContainer = 44;
  static const double iconButton = 44;
  static const double appBarActionPlaceholder = 48;
  static const double primaryButtonHeight = 54;
}

abstract final class AppDuration {
  static const Duration short = Duration(milliseconds: 200);
  static const Duration clipExpand = Duration(milliseconds: 430);
  static const Duration clipCollapse = Duration(milliseconds: 280);
  static const Duration clipDetailContent = Duration(milliseconds: 240);
  static const Duration clipboardPolling = Duration(seconds: 1);
  static const Duration relativeTimeTicker = Duration(minutes: 1);
}

abstract final class AppStroke {
  static const double regular = 1.4;
}

abstract final class AppOpacity {
  static const double inputFillLight = 0.08;
  static const double inputFillDark = 0.18;
  static const double subtleSurface = 0.05;
  static const double softSurface = 0.06;
  static const double tintedSurface = 0.12;
  static const double selectedSurface = 0.14;
  static const double mutedText = 0.35;
  static const double softOutline = 0.35;
  static const double mediumOutline = 0.45;
  static const double strongOutline = 0.55;
  static const double snackBlend = 0.2;
}

abstract final class AppTypography {
  static const double timestampLetterSpacing = 1.1;
  static const double contentLineHeight = 1.35;
}

abstract final class AppTime {
  static const int justNowThresholdSeconds = 45;
  static const int minutesPerHour = 60;
  static const int hoursPerDay = 24;
  static const int daysPerWeek = 7;
}
