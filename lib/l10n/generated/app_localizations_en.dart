// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Alphabet & Vocabulary';

  @override
  String get onboardingChooseLanguage => 'Choose your language';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get homeAlphabetModule => 'Alphabet';

  @override
  String get homeAlphabetModuleSubtitle => 'Learn letters';

  @override
  String get homeVocabularyModule => 'Vocabulary';

  @override
  String get homeVocabularyModuleSubtitle => 'Learn words';

  @override
  String get homeNatureModule => 'Nature';

  @override
  String get homeNatureModuleSubtitle => 'Animals and plants';

  @override
  String homeStreakLabel(int count) {
    return '$count-day streak';
  }

  @override
  String get homeSettings => 'Settings';

  @override
  String get alphabetSelectTitle => 'Choose an alphabet';

  @override
  String alphabetProgress(int learned, int total) {
    return '$learned/$total learned';
  }

  @override
  String get letterGridTitle => 'Letters';

  @override
  String get letterDetailListen => 'Listen';

  @override
  String get letterDetailTrace => 'Trace';

  @override
  String get letterDetailView => 'View';

  @override
  String get letterDetailExampleWords => 'Example words';

  @override
  String get traceInstructions => 'Trace the letter with your finger';

  @override
  String get traceSuccess => 'Great job!';

  @override
  String get traceTryAgain => 'Try again';

  @override
  String get quizTitle => 'Mini quiz';

  @override
  String get quizQuestionLetter => 'Which letter did you hear?';

  @override
  String get quizCorrect => 'Correct!';

  @override
  String get quizIncorrect => 'Not quite, try again';

  @override
  String get quizFinished => 'Quiz finished!';

  @override
  String quizScore(int score, int total) {
    return 'Score: $score/$total';
  }

  @override
  String get vocabularyCategoriesTitle => 'Categories';

  @override
  String get categoryAnimals => 'Animals';

  @override
  String get categoryColors => 'Colors';

  @override
  String get categoryNumbers => 'Numbers';

  @override
  String get categoryFamily => 'Family';

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryClothes => 'Clothes';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryNature => 'Nature';

  @override
  String get flashcardListen => 'Listen';

  @override
  String get flashcardNext => 'Next';

  @override
  String get flashcardWritePractice => 'Write it';

  @override
  String get vocabQuizChooseWord => 'Choose the right word';

  @override
  String get vocabQuizChooseImage => 'Choose the right picture';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsInterfaceLanguage => 'Interface language';

  @override
  String get settingsSoundEnabled => 'Sound';

  @override
  String get settingsVoiceSpeed => 'Voice speed';

  @override
  String get settingsNotificationTime => 'Reminder time';

  @override
  String get settingsParentZone => 'Parent zone';

  @override
  String get parentZoneEnterPin => 'Enter PIN code';

  @override
  String get parentZoneWrongPin => 'Wrong PIN';

  @override
  String get parentZoneSetPin => 'Set PIN code';

  @override
  String get parentZoneProgressTitle => 'Your child\'s progress';

  @override
  String parentZoneStatsAlphabet(int learned, int total) {
    return 'Alphabet: $learned/$total letters';
  }

  @override
  String parentZoneStatsVocabulary(int learned, int total) {
    return 'Vocabulary: $learned/$total words';
  }

  @override
  String get notificationReminderTitle => 'Time to practice!';

  @override
  String get notificationReminderBody => 'You haven\'t practiced today yet!';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNext => 'Next';

  @override
  String get commonClose => 'Close';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonStart => 'Start';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCongrats => 'Congratulations!';

  @override
  String get natureCategoryTitle => 'Choose a nature topic';

  @override
  String get natureAnimals => 'Animals';

  @override
  String get naturePlants => 'Plants';

  @override
  String get natureBirds => 'Birds';

  @override
  String get natureVehicles => 'Vehicles';

  @override
  String get natureProfessions => 'Professions';

  @override
  String get noInternetTitle => 'No internet connection';

  @override
  String get noInternetBody =>
      'Please connect to the internet to use the app. It will continue automatically once the connection is back.';

  @override
  String get noInternetChecking => 'Checking...';

  @override
  String get unlockWithAdTitle => 'This section is locked';

  @override
  String get unlockWithAdBody => 'Watch an ad to unlock this section for good';

  @override
  String get unlockWithAdButton => 'Watch ad';

  @override
  String get unlockWithAdNotReady =>
      'The ad isn\'t ready yet, try again in a moment';

  @override
  String get categoryUnlocked => 'Section unlocked!';
}
