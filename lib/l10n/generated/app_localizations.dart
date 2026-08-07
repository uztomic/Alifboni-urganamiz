import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_ky.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tg.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uz.dart';

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
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
    Locale('kk'),
    Locale('ky'),
    Locale('ru'),
    Locale('tg'),
    Locale('tr'),
    Locale('uz'),
    Locale.fromSubtags(languageCode: 'uz', scriptCode: 'Cyrl'),
  ];

  /// App name shown on splash/onboarding
  ///
  /// In uz, this message translates to:
  /// **'Alifbo & Lug\'at'**
  String get appTitle;

  /// No description provided for @onboardingChooseLanguage.
  ///
  /// In uz, this message translates to:
  /// **'Tilni tanlang'**
  String get onboardingChooseLanguage;

  /// No description provided for @onboardingContinue.
  ///
  /// In uz, this message translates to:
  /// **'Davom etish'**
  String get onboardingContinue;

  /// No description provided for @homeAlphabetModule.
  ///
  /// In uz, this message translates to:
  /// **'Alifbo'**
  String get homeAlphabetModule;

  /// No description provided for @homeAlphabetModuleSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Harflarni o\'rganamiz'**
  String get homeAlphabetModuleSubtitle;

  /// No description provided for @homeVocabularyModule.
  ///
  /// In uz, this message translates to:
  /// **'Lug\'at'**
  String get homeVocabularyModule;

  /// No description provided for @homeVocabularyModuleSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'So\'zlarni o\'rganamiz'**
  String get homeVocabularyModuleSubtitle;

  /// No description provided for @homeNatureModule.
  ///
  /// In uz, this message translates to:
  /// **'Tabiat'**
  String get homeNatureModule;

  /// No description provided for @homeNatureModuleSubtitle.
  ///
  /// In uz, this message translates to:
  /// **'Hayvonlar va o\'simliklar'**
  String get homeNatureModuleSubtitle;

  /// No description provided for @homeStreakLabel.
  ///
  /// In uz, this message translates to:
  /// **'{count} kunlik olov'**
  String homeStreakLabel(int count);

  /// No description provided for @homeSettings.
  ///
  /// In uz, this message translates to:
  /// **'Sozlamalar'**
  String get homeSettings;

  /// No description provided for @alphabetSelectTitle.
  ///
  /// In uz, this message translates to:
  /// **'Alifboni tanlang'**
  String get alphabetSelectTitle;

  /// No description provided for @alphabetProgress.
  ///
  /// In uz, this message translates to:
  /// **'{learned}/{total} o\'rganildi'**
  String alphabetProgress(int learned, int total);

  /// No description provided for @letterGridTitle.
  ///
  /// In uz, this message translates to:
  /// **'Harflar'**
  String get letterGridTitle;

  /// No description provided for @letterDetailListen.
  ///
  /// In uz, this message translates to:
  /// **'Eshitish'**
  String get letterDetailListen;

  /// No description provided for @letterDetailTrace.
  ///
  /// In uz, this message translates to:
  /// **'Chizish'**
  String get letterDetailTrace;

  /// No description provided for @letterDetailView.
  ///
  /// In uz, this message translates to:
  /// **'Ko\'rish'**
  String get letterDetailView;

  /// No description provided for @letterDetailExampleWords.
  ///
  /// In uz, this message translates to:
  /// **'Misol so\'zlar'**
  String get letterDetailExampleWords;

  /// No description provided for @traceInstructions.
  ///
  /// In uz, this message translates to:
  /// **'Barmog\'ingiz bilan harfni chizing'**
  String get traceInstructions;

  /// No description provided for @traceSuccess.
  ///
  /// In uz, this message translates to:
  /// **'Ajoyib!'**
  String get traceSuccess;

  /// No description provided for @traceTryAgain.
  ///
  /// In uz, this message translates to:
  /// **'Yana urinib ko\'ring'**
  String get traceTryAgain;

  /// No description provided for @quizTitle.
  ///
  /// In uz, this message translates to:
  /// **'Mini-viktorina'**
  String get quizTitle;

  /// No description provided for @quizQuestionLetter.
  ///
  /// In uz, this message translates to:
  /// **'Qaysi harf tovushi eshitildi?'**
  String get quizQuestionLetter;

  /// No description provided for @quizCorrect.
  ///
  /// In uz, this message translates to:
  /// **'To\'g\'ri!'**
  String get quizCorrect;

  /// No description provided for @quizIncorrect.
  ///
  /// In uz, this message translates to:
  /// **'Noto\'g\'ri, yana urinib ko\'ring'**
  String get quizIncorrect;

  /// No description provided for @quizFinished.
  ///
  /// In uz, this message translates to:
  /// **'Viktorina tugadi!'**
  String get quizFinished;

  /// No description provided for @quizScore.
  ///
  /// In uz, this message translates to:
  /// **'Natija: {score}/{total}'**
  String quizScore(int score, int total);

  /// No description provided for @vocabularyCategoriesTitle.
  ///
  /// In uz, this message translates to:
  /// **'Kategoriyalar'**
  String get vocabularyCategoriesTitle;

  /// No description provided for @categoryAnimals.
  ///
  /// In uz, this message translates to:
  /// **'Hayvonlar'**
  String get categoryAnimals;

  /// No description provided for @categoryColors.
  ///
  /// In uz, this message translates to:
  /// **'Ranglar'**
  String get categoryColors;

  /// No description provided for @categoryNumbers.
  ///
  /// In uz, this message translates to:
  /// **'Sonlar'**
  String get categoryNumbers;

  /// No description provided for @categoryFamily.
  ///
  /// In uz, this message translates to:
  /// **'Oila'**
  String get categoryFamily;

  /// No description provided for @categoryFood.
  ///
  /// In uz, this message translates to:
  /// **'Ovqatlar'**
  String get categoryFood;

  /// No description provided for @categoryClothes.
  ///
  /// In uz, this message translates to:
  /// **'Kiyimlar'**
  String get categoryClothes;

  /// No description provided for @categoryTransport.
  ///
  /// In uz, this message translates to:
  /// **'Transport'**
  String get categoryTransport;

  /// No description provided for @categoryNature.
  ///
  /// In uz, this message translates to:
  /// **'Tabiat'**
  String get categoryNature;

  /// No description provided for @flashcardListen.
  ///
  /// In uz, this message translates to:
  /// **'Tinglash'**
  String get flashcardListen;

  /// No description provided for @flashcardNext.
  ///
  /// In uz, this message translates to:
  /// **'Keyingisi'**
  String get flashcardNext;

  /// No description provided for @flashcardWritePractice.
  ///
  /// In uz, this message translates to:
  /// **'Yozib ko\'rish'**
  String get flashcardWritePractice;

  /// No description provided for @vocabQuizChooseWord.
  ///
  /// In uz, this message translates to:
  /// **'To\'g\'ri so\'zni tanlang'**
  String get vocabQuizChooseWord;

  /// No description provided for @vocabQuizChooseImage.
  ///
  /// In uz, this message translates to:
  /// **'To\'g\'ri rasmni tanlang'**
  String get vocabQuizChooseImage;

  /// No description provided for @settingsTitle.
  ///
  /// In uz, this message translates to:
  /// **'Sozlamalar'**
  String get settingsTitle;

  /// No description provided for @settingsInterfaceLanguage.
  ///
  /// In uz, this message translates to:
  /// **'Interfeys tili'**
  String get settingsInterfaceLanguage;

  /// No description provided for @settingsSoundEnabled.
  ///
  /// In uz, this message translates to:
  /// **'Ovoz'**
  String get settingsSoundEnabled;

  /// No description provided for @settingsVoiceSpeed.
  ///
  /// In uz, this message translates to:
  /// **'Ovoz tezligi'**
  String get settingsVoiceSpeed;

  /// No description provided for @settingsNotificationTime.
  ///
  /// In uz, this message translates to:
  /// **'Eslatma vaqti'**
  String get settingsNotificationTime;

  /// No description provided for @settingsParentZone.
  ///
  /// In uz, this message translates to:
  /// **'Ota-ona zonasi'**
  String get settingsParentZone;

  /// No description provided for @parentZoneEnterPin.
  ///
  /// In uz, this message translates to:
  /// **'PIN kodni kiriting'**
  String get parentZoneEnterPin;

  /// No description provided for @parentZoneWrongPin.
  ///
  /// In uz, this message translates to:
  /// **'PIN noto\'g\'ri'**
  String get parentZoneWrongPin;

  /// No description provided for @parentZoneSetPin.
  ///
  /// In uz, this message translates to:
  /// **'PIN kod o\'rnatish'**
  String get parentZoneSetPin;

  /// No description provided for @parentZoneProgressTitle.
  ///
  /// In uz, this message translates to:
  /// **'Farzandingiz progressi'**
  String get parentZoneProgressTitle;

  /// No description provided for @parentZoneStatsAlphabet.
  ///
  /// In uz, this message translates to:
  /// **'Alifbo: {learned}/{total} harf'**
  String parentZoneStatsAlphabet(int learned, int total);

  /// No description provided for @parentZoneStatsVocabulary.
  ///
  /// In uz, this message translates to:
  /// **'Lug\'at: {learned}/{total} so\'z'**
  String parentZoneStatsVocabulary(int learned, int total);

  /// No description provided for @notificationReminderTitle.
  ///
  /// In uz, this message translates to:
  /// **'Vaqt keldi!'**
  String get notificationReminderTitle;

  /// No description provided for @notificationReminderBody.
  ///
  /// In uz, this message translates to:
  /// **'Bugun hali mashq qilmadingiz!'**
  String get notificationReminderBody;

  /// No description provided for @commonBack.
  ///
  /// In uz, this message translates to:
  /// **'Orqaga'**
  String get commonBack;

  /// No description provided for @commonNext.
  ///
  /// In uz, this message translates to:
  /// **'Keyingi'**
  String get commonNext;

  /// No description provided for @commonClose.
  ///
  /// In uz, this message translates to:
  /// **'Yopish'**
  String get commonClose;

  /// No description provided for @commonYes.
  ///
  /// In uz, this message translates to:
  /// **'Ha'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In uz, this message translates to:
  /// **'Yo\'q'**
  String get commonNo;

  /// No description provided for @commonStart.
  ///
  /// In uz, this message translates to:
  /// **'Boshlash'**
  String get commonStart;

  /// No description provided for @commonRetry.
  ///
  /// In uz, this message translates to:
  /// **'Qayta urinish'**
  String get commonRetry;

  /// No description provided for @commonCongrats.
  ///
  /// In uz, this message translates to:
  /// **'Tabriklaymiz!'**
  String get commonCongrats;

  /// No description provided for @natureCategoryTitle.
  ///
  /// In uz, this message translates to:
  /// **'Tabiatni tanlang'**
  String get natureCategoryTitle;

  /// No description provided for @natureAnimals.
  ///
  /// In uz, this message translates to:
  /// **'Hayvonlar'**
  String get natureAnimals;

  /// No description provided for @naturePlants.
  ///
  /// In uz, this message translates to:
  /// **'O\'simliklar'**
  String get naturePlants;

  /// No description provided for @natureBirds.
  ///
  /// In uz, this message translates to:
  /// **'Qushlar'**
  String get natureBirds;

  /// No description provided for @natureVehicles.
  ///
  /// In uz, this message translates to:
  /// **'Transport'**
  String get natureVehicles;

  /// No description provided for @natureProfessions.
  ///
  /// In uz, this message translates to:
  /// **'Kasblar'**
  String get natureProfessions;

  /// No description provided for @noInternetTitle.
  ///
  /// In uz, this message translates to:
  /// **'Internet aloqasi yo\'q'**
  String get noInternetTitle;

  /// No description provided for @noInternetBody.
  ///
  /// In uz, this message translates to:
  /// **'Ilova ishlashi uchun internetga ulaning. Aloqa tiklansa, sahifa avtomatik davom etadi.'**
  String get noInternetBody;

  /// No description provided for @noInternetChecking.
  ///
  /// In uz, this message translates to:
  /// **'Tekshirilmoqda...'**
  String get noInternetChecking;

  /// No description provided for @unlockWithAdTitle.
  ///
  /// In uz, this message translates to:
  /// **'Bu bo\'lim qulflangan'**
  String get unlockWithAdTitle;

  /// No description provided for @unlockWithAdBody.
  ///
  /// In uz, this message translates to:
  /// **'Reklama ko\'rib, ushbu bo\'limni butunlay oching'**
  String get unlockWithAdBody;

  /// No description provided for @unlockWithAdButton.
  ///
  /// In uz, this message translates to:
  /// **'Reklama ko\'rish'**
  String get unlockWithAdButton;

  /// No description provided for @unlockWithAdNotReady.
  ///
  /// In uz, this message translates to:
  /// **'Reklama hali tayyor emas, birozdan keyin urinib ko\'ring'**
  String get unlockWithAdNotReady;

  /// No description provided for @categoryUnlocked.
  ///
  /// In uz, this message translates to:
  /// **'Bo\'lim ochildi!'**
  String get categoryUnlocked;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'en',
    'fr',
    'kk',
    'ky',
    'ru',
    'tg',
    'tr',
    'uz',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'uz':
      {
        switch (locale.scriptCode) {
          case 'Cyrl':
            return AppLocalizationsUzCyrl();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'kk':
      return AppLocalizationsKk();
    case 'ky':
      return AppLocalizationsKy();
    case 'ru':
      return AppLocalizationsRu();
    case 'tg':
      return AppLocalizationsTg();
    case 'tr':
      return AppLocalizationsTr();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
