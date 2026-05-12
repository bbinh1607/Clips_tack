import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'ClipStack'**
  String get appName;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @saveClipTooltip.
  ///
  /// In en, this message translates to:
  /// **'Save Clip'**
  String get saveClipTooltip;

  /// No description provided for @historyTab.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTab;

  /// No description provided for @starredTab.
  ///
  /// In en, this message translates to:
  /// **'Starred'**
  String get starredTab;

  /// No description provided for @drawerDescription.
  ///
  /// In en, this message translates to:
  /// **'Your copied snippets stay organized and ready to reuse.'**
  String get drawerDescription;

  /// No description provided for @savedPinnedSummary.
  ///
  /// In en, this message translates to:
  /// **'{savedCount} saved | {pinnedCount} pinned'**
  String savedPinnedSummary(int savedCount, int pinnedCount);

  /// No description provided for @searchClipboardPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search clipboard...'**
  String get searchClipboardPlaceholder;

  /// No description provided for @clearSearchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearchTooltip;

  /// No description provided for @recentSnippetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent snippets'**
  String get recentSnippetsTitle;

  /// No description provided for @recentSnippetsHelper.
  ///
  /// In en, this message translates to:
  /// **'Tap to copy instantly, or long press for more actions.'**
  String get recentSnippetsHelper;

  /// No description provided for @pinnedSnippetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pinned snippets'**
  String get pinnedSnippetsTitle;

  /// No description provided for @pinnedSnippetsHelper.
  ///
  /// In en, this message translates to:
  /// **'Your starred clips stay at the top for quick reuse.'**
  String get pinnedSnippetsHelper;

  /// No description provided for @itemCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String itemCount(int count);

  /// No description provided for @copiedMessage.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copiedMessage;

  /// No description provided for @copyAction.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyAction;

  /// No description provided for @pinAction.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get pinAction;

  /// No description provided for @unpinAction.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get unpinAction;

  /// No description provided for @pinnedMessage.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get pinnedMessage;

  /// No description provided for @unpinnedMessage.
  ///
  /// In en, this message translates to:
  /// **'Unpinned'**
  String get unpinnedMessage;

  /// No description provided for @editAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editAction;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @deletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deletedMessage;

  /// No description provided for @savedMessage.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get savedMessage;

  /// No description provided for @updatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updatedMessage;

  /// No description provided for @duplicateClipMessage.
  ///
  /// In en, this message translates to:
  /// **'That clip is already in your stack'**
  String get duplicateClipMessage;

  /// No description provided for @saveClipTitle.
  ///
  /// In en, this message translates to:
  /// **'Save Clip'**
  String get saveClipTitle;

  /// No description provided for @editClipTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Clip'**
  String get editClipTitle;

  /// No description provided for @saveClipButton.
  ///
  /// In en, this message translates to:
  /// **'Save Clip'**
  String get saveClipButton;

  /// No description provided for @updateClipButton.
  ///
  /// In en, this message translates to:
  /// **'Update Clip'**
  String get updateClipButton;

  /// No description provided for @editorCreateDescription.
  ///
  /// In en, this message translates to:
  /// **'Save the current clipboard text or write a new snippet.'**
  String get editorCreateDescription;

  /// No description provided for @editorEditDescription.
  ///
  /// In en, this message translates to:
  /// **'Refine the snippet and keep it ready to reuse.'**
  String get editorEditDescription;

  /// No description provided for @editorHint.
  ///
  /// In en, this message translates to:
  /// **'Paste or type text here'**
  String get editorHint;

  /// No description provided for @settingsIntro.
  ///
  /// In en, this message translates to:
  /// **'Tune the experience and keep clipboard capture running smoothly.'**
  String get settingsIntro;

  /// No description provided for @appearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceTitle;

  /// No description provided for @darkModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkModeTitle;

  /// No description provided for @darkModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Switch between the light and dark workspace.'**
  String get darkModeSubtitle;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageVietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get languageVietnamese;

  /// No description provided for @clipboardSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Clipboard'**
  String get clipboardSectionTitle;

  /// No description provided for @autoTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto tracking'**
  String get autoTrackingTitle;

  /// No description provided for @autoTrackingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'On while the app is open'**
  String get autoTrackingSubtitle;

  /// No description provided for @savedSnippetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved snippets'**
  String get savedSnippetsTitle;

  /// No description provided for @savedSnippetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} in your history'**
  String savedSnippetsSubtitle(int count);

  /// No description provided for @pinnedSnippetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{count} ready at the top'**
  String pinnedSnippetsSubtitle(int count);

  /// No description provided for @duplicateProtectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Duplicate protection'**
  String get duplicateProtectionTitle;

  /// No description provided for @duplicateProtectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Repeated text is skipped automatically'**
  String get duplicateProtectionSubtitle;

  /// No description provided for @emptyClipboardDescription.
  ///
  /// In en, this message translates to:
  /// **'Items you copy will appear here as curated snippets.'**
  String get emptyClipboardDescription;

  /// No description provided for @pinClipPrompt.
  ///
  /// In en, this message translates to:
  /// **'Pin a clip to keep it close.'**
  String get pinClipPrompt;

  /// No description provided for @noSearchResultsMessage.
  ///
  /// In en, this message translates to:
  /// **'No clipboard snippets match your search yet.'**
  String get noSearchResultsMessage;

  /// No description provided for @linkChip.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get linkChip;

  /// No description provided for @phoneChip.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneChip;

  /// No description provided for @pinnedChip.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get pinnedChip;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute ago} other{{count} minutes ago}}'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String hoursAgo(int count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String daysAgo(int count);

  /// No description provided for @weeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 week ago} other{{count} weeks ago}}'**
  String weeksAgo(int count);

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @loginWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome back to ClipStack'**
  String get loginWelcomeMessage;

  /// No description provided for @loginEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Gmail'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'name@gmail.com'**
  String get loginEmailHint;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordHint;

  /// No description provided for @loginShowPasswordTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get loginShowPasswordTooltip;

  /// No description provided for @loginHidePasswordTooltip.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get loginHidePasswordTooltip;

  /// No description provided for @loginForgotPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get loginForgotPasswordButton;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Gmail'**
  String get loginButton;

  /// No description provided for @loginLoadingButton.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get loginLoadingButton;

  /// No description provided for @loginGoogleButton.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get loginGoogleButton;

  /// No description provided for @loginPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Keep your personal clipboard data protected.'**
  String get loginPrivacyNote;

  /// No description provided for @loginBrandTagline.
  ///
  /// In en, this message translates to:
  /// **'Manage quick notes neatly and safely'**
  String get loginBrandTagline;

  /// No description provided for @loginForgotPasswordUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Password recovery will be available soon'**
  String get loginForgotPasswordUnavailable;

  /// No description provided for @loginEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your Gmail'**
  String get loginEmailRequired;

  /// No description provided for @loginEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Gmail address'**
  String get loginEmailInvalid;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get loginPasswordRequired;

  /// No description provided for @loginPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get loginPasswordTooShort;

  /// No description provided for @loginRegisterPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get loginRegisterPrompt;

  /// No description provided for @loginRegisterAction.
  ///
  /// In en, this message translates to:
  /// **'Register now'**
  String get loginRegisterAction;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerTitle;

  /// No description provided for @registerWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Register with your Gmail to start saving clips'**
  String get registerWelcomeMessage;

  /// No description provided for @registerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get registerNameLabel;

  /// No description provided for @registerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get registerNameHint;

  /// No description provided for @registerNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get registerNameRequired;

  /// No description provided for @registerNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get registerNameTooShort;

  /// No description provided for @registerConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get registerConfirmPasswordLabel;

  /// No description provided for @registerConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password again'**
  String get registerConfirmPasswordHint;

  /// No description provided for @registerConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get registerConfirmPasswordRequired;

  /// No description provided for @registerPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get registerPasswordsDoNotMatch;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register with Gmail'**
  String get registerButton;

  /// No description provided for @registerLoadingButton.
  ///
  /// In en, this message translates to:
  /// **'Creating account...'**
  String get registerLoadingButton;

  /// No description provided for @registerGoToLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get registerGoToLoginButton;

  /// No description provided for @textOr.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get textOr;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
