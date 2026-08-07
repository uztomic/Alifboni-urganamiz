// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get appTitle => 'Әліпби және Сөздік';

  @override
  String get onboardingChooseLanguage => 'Тіліңізді таңдаңыз';

  @override
  String get onboardingContinue => 'Жалғастыру';

  @override
  String get homeAlphabetModule => 'Әліпби';

  @override
  String get homeAlphabetModuleSubtitle => 'Әріптерді үйренейік';

  @override
  String get homeVocabularyModule => 'Сөздік';

  @override
  String get homeVocabularyModuleSubtitle => 'Сөздерді үйренейік';

  @override
  String get homeNatureModule => 'Табиғат';

  @override
  String get homeNatureModuleSubtitle => 'Жануарлар мен өсімдіктер';

  @override
  String homeStreakLabel(int count) {
    return '$count күндік серия';
  }

  @override
  String get homeSettings => 'Баптаулар';

  @override
  String get alphabetSelectTitle => 'Әліпбиді таңдаңыз';

  @override
  String alphabetProgress(int learned, int total) {
    return '$learned/$total үйренілді';
  }

  @override
  String get letterGridTitle => 'Әріптер';

  @override
  String get letterDetailListen => 'Тыңдау';

  @override
  String get letterDetailTrace => 'Жазу';

  @override
  String get letterDetailView => 'Көру';

  @override
  String get letterDetailExampleWords => 'Мысал сөздер';

  @override
  String get traceInstructions => 'Әріпті саусағыңызбен сызыңыз';

  @override
  String get traceSuccess => 'Керемет!';

  @override
  String get traceTryAgain => 'Қайта көріңіз';

  @override
  String get quizTitle => 'Мини-викторина';

  @override
  String get quizQuestionLetter => 'Қай әріп дыбысталды?';

  @override
  String get quizCorrect => 'Дұрыс!';

  @override
  String get quizIncorrect => 'Дұрыс емес, қайта көріңіз';

  @override
  String get quizFinished => 'Викторина аяқталды!';

  @override
  String quizScore(int score, int total) {
    return 'Нәтиже: $score/$total';
  }

  @override
  String get vocabularyCategoriesTitle => 'Санаттар';

  @override
  String get categoryAnimals => 'Жануарлар';

  @override
  String get categoryColors => 'Түстер';

  @override
  String get categoryNumbers => 'Сандар';

  @override
  String get categoryFamily => 'Отбасы';

  @override
  String get categoryFood => 'Тағамдар';

  @override
  String get categoryClothes => 'Киімдер';

  @override
  String get categoryTransport => 'Көлік';

  @override
  String get categoryNature => 'Табиғат';

  @override
  String get flashcardListen => 'Тыңдау';

  @override
  String get flashcardNext => 'Келесі';

  @override
  String get flashcardWritePractice => 'Жазып көру';

  @override
  String get vocabQuizChooseWord => 'Дұрыс сөзді таңдаңыз';

  @override
  String get vocabQuizChooseImage => 'Дұрыс суретті таңдаңыз';

  @override
  String get settingsTitle => 'Баптаулар';

  @override
  String get settingsInterfaceLanguage => 'Интерфейс тілі';

  @override
  String get settingsSoundEnabled => 'Дыбыс';

  @override
  String get settingsVoiceSpeed => 'Дауыс жылдамдығы';

  @override
  String get settingsNotificationTime => 'Еске салу уақыты';

  @override
  String get settingsParentZone => 'Ата-ана аймағы';

  @override
  String get parentZoneEnterPin => 'PIN кодты енгізіңіз';

  @override
  String get parentZoneWrongPin => 'PIN қате';

  @override
  String get parentZoneSetPin => 'PIN кодты орнату';

  @override
  String get parentZoneProgressTitle => 'Балаңыздың үлгерімі';

  @override
  String parentZoneStatsAlphabet(int learned, int total) {
    return 'Әліпби: $learned/$total әріп';
  }

  @override
  String parentZoneStatsVocabulary(int learned, int total) {
    return 'Сөздік: $learned/$total сөз';
  }

  @override
  String get notificationReminderTitle => 'Жаттығу уақыты!';

  @override
  String get notificationReminderBody => 'Сіз бүгін әлі жаттықпадыңыз!';

  @override
  String get commonBack => 'Артқа';

  @override
  String get commonNext => 'Келесі';

  @override
  String get commonClose => 'Жабу';

  @override
  String get commonYes => 'Иә';

  @override
  String get commonNo => 'Жоқ';

  @override
  String get commonStart => 'Бастау';

  @override
  String get commonRetry => 'Қайталау';

  @override
  String get commonCongrats => 'Құттықтаймыз!';

  @override
  String get natureCategoryTitle => 'Табиғат тақырыбын таңдаңыз';

  @override
  String get natureAnimals => 'Жануарлар';

  @override
  String get naturePlants => 'Өсімдіктер';

  @override
  String get natureBirds => 'Құстар';

  @override
  String get natureVehicles => 'Көліктер';

  @override
  String get natureProfessions => 'Мамандықтар';

  @override
  String get noInternetTitle => 'Интернет байланысы жоқ';

  @override
  String get noInternetBody =>
      'Қолданбаны пайдалану үшін интернетке қосылыңыз. Байланыс қалпына келгенде, бет автоматты түрде жалғасады.';

  @override
  String get noInternetChecking => 'Тексерілуде...';

  @override
  String get unlockWithAdTitle => 'Бұл бөлім құлыпталған';

  @override
  String get unlockWithAdBody =>
      'Бұл бөлімді біржола ашу үшін жарнаманы көріңіз';

  @override
  String get unlockWithAdButton => 'Жарнаманы көру';

  @override
  String get unlockWithAdNotReady =>
      'Жарнама әлі дайын емес, сәлден кейін қайталап көріңіз';

  @override
  String get categoryUnlocked => 'Бөлім ашылды!';
}
