// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'ClipStack';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String get saveClipTooltip => 'Save Clip';

  @override
  String get historyTab => 'History';

  @override
  String get starredTab => 'Starred';

  @override
  String get drawerDescription =>
      'Your copied snippets stay organized and ready to reuse.';

  @override
  String savedPinnedSummary(int savedCount, int pinnedCount) {
    return '$savedCount saved | $pinnedCount pinned';
  }

  @override
  String get searchClipboardPlaceholder => 'Search clipboard...';

  @override
  String get clearSearchTooltip => 'Clear search';

  @override
  String get recentSnippetsTitle => 'Recent snippets';

  @override
  String get recentSnippetsHelper =>
      'Tap to copy instantly, or long press for more actions.';

  @override
  String get pinnedSnippetsTitle => 'Pinned snippets';

  @override
  String get pinnedSnippetsHelper =>
      'Your starred clips stay at the top for quick reuse.';

  @override
  String itemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get copiedMessage => 'Copied';

  @override
  String get copyAction => 'Copy';

  @override
  String get pinAction => 'Pin';

  @override
  String get unpinAction => 'Unpin';

  @override
  String get pinnedMessage => 'Pinned';

  @override
  String get unpinnedMessage => 'Unpinned';

  @override
  String get editAction => 'Edit';

  @override
  String get deleteAction => 'Delete';

  @override
  String get moreActionsTooltip => 'More actions';

  @override
  String get deletedMessage => 'Deleted';

  @override
  String get savedMessage => 'Saved';

  @override
  String get updatedMessage => 'Updated';

  @override
  String get duplicateClipMessage => 'That clip is already in your stack';

  @override
  String get saveClipTitle => 'Save Clip';

  @override
  String get editClipTitle => 'Edit Clip';

  @override
  String get saveClipButton => 'Save Clip';

  @override
  String get updateClipButton => 'Update Clip';

  @override
  String get editorCreateDescription =>
      'Save the current clipboard text or write a new snippet.';

  @override
  String get editorEditDescription =>
      'Refine the snippet and keep it ready to reuse.';

  @override
  String get editorHint => 'Paste or type text here';

  @override
  String get settingsIntro =>
      'Tune the experience and keep clipboard capture running smoothly.';

  @override
  String get appearanceTitle => 'Appearance';

  @override
  String get darkModeTitle => 'Dark mode';

  @override
  String get darkModeSubtitle => 'Switch between the light and dark workspace.';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageVietnamese => 'Vietnamese';

  @override
  String get overlaySectionTitle => 'Floating access';

  @override
  String get overlayBubbleTitle => 'ClipStack bubble';

  @override
  String get overlayBubbleSubtitleOn => 'Showing over other apps';

  @override
  String get overlayBubbleSubtitleOff =>
      'Show a draggable bubble over other apps.';

  @override
  String get overlayBubblePermissionSubtitle =>
      'Allow display over other apps to use the bubble.';

  @override
  String get overlayPermissionMessage =>
      'Turn on Display over other apps for ClipStack, then return here.';

  @override
  String get overlayStartedMessage => 'Bubble is showing';

  @override
  String get overlayStoppedMessage => 'Bubble is hidden';

  @override
  String get clipboardSectionTitle => 'Clipboard';

  @override
  String get autoTrackingTitle => 'Auto tracking';

  @override
  String get autoTrackingSubtitle => 'On while the app is open';

  @override
  String get savedSnippetsTitle => 'Saved snippets';

  @override
  String savedSnippetsSubtitle(int count) {
    return '$count in your history';
  }

  @override
  String pinnedSnippetsSubtitle(int count) {
    return '$count ready at the top';
  }

  @override
  String get duplicateProtectionTitle => 'Duplicate protection';

  @override
  String get duplicateProtectionSubtitle =>
      'Repeated text is skipped automatically';

  @override
  String get emptyClipboardDescription =>
      'Items you copy will appear here as curated snippets.';

  @override
  String get pinClipPrompt => 'Pin a clip to keep it close.';

  @override
  String get noSearchResultsMessage =>
      'No clipboard snippets match your search yet.';

  @override
  String get linkChip => 'Link';

  @override
  String get phoneChip => 'Phone';

  @override
  String get pinnedChip => 'Pinned';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String weeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks ago',
      one: '1 week ago',
    );
    return '$_temp0';
  }

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginWelcomeMessage => 'Welcome back to ClipStack';

  @override
  String get loginEmailLabel => 'Gmail';

  @override
  String get loginEmailHint => 'name@gmail.com';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordHint => 'Enter your password';

  @override
  String get loginShowPasswordTooltip => 'Show password';

  @override
  String get loginHidePasswordTooltip => 'Hide password';

  @override
  String get loginForgotPasswordButton => 'Forgot password?';

  @override
  String get loginButton => 'Sign in';

  @override
  String get loginLoadingButton => 'Signing in...';

  @override
  String get loginGoogleButton => 'Continue with Google';

  @override
  String get loginPrivacyNote => 'Keep your personal clipboard data protected.';

  @override
  String get loginBrandTagline => 'Manage quick notes neatly and safely';

  @override
  String get loginForgotPasswordUnavailable =>
      'Password recovery will be available soon';

  @override
  String get loginEmailRequired => 'Please enter your Gmail';

  @override
  String get loginEmailInvalid => 'Please enter a valid Gmail address';

  @override
  String get loginPasswordRequired => 'Please enter your password';

  @override
  String get loginPasswordTooShort => 'Password must be at least 6 characters';

  @override
  String get loginRegisterPrompt => 'Don\'t have an account?';

  @override
  String get loginRegisterAction => 'Register now';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerWelcomeMessage =>
      'Register with your Gmail to start saving clips';

  @override
  String get registerNameLabel => 'Full name';

  @override
  String get registerNameHint => 'Your name';

  @override
  String get registerNameRequired => 'Please enter your name';

  @override
  String get registerNameTooShort => 'Name must be at least 2 characters';

  @override
  String get registerConfirmPasswordLabel => 'Confirm password';

  @override
  String get registerConfirmPasswordHint => 'Enter your password again';

  @override
  String get registerConfirmPasswordRequired => 'Please confirm your password';

  @override
  String get registerPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get registerButton => 'Create account';

  @override
  String get registerLoadingButton => 'Creating account...';

  @override
  String get registerGoToLoginButton => 'Already have an account? Sign in';

  @override
  String get accountSectionTitle => 'Account';

  @override
  String get logoutAction => 'Log out';

  @override
  String get logoutSubtitle => 'Sign out and return to the login screen';

  @override
  String get textOr => 'Or';
}
