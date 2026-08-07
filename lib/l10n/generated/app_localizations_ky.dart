// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kirghiz Kyrgyz (`ky`).
class AppLocalizationsKy extends AppLocalizations {
  AppLocalizationsKy([String locale = 'ky']) : super(locale);

  @override
  String get appTitle => 'Алфавит жана Сөздүк';

  @override
  String get onboardingChooseLanguage => 'Тилиңизди тандаңыз';

  @override
  String get onboardingContinue => 'Улантуу';

  @override
  String get homeAlphabetModule => 'Алфавит';

  @override
  String get homeAlphabetModuleSubtitle => 'Тамгаларды үйрөнөбүз';

  @override
  String get homeVocabularyModule => 'Сөздүк';

  @override
  String get homeVocabularyModuleSubtitle => 'Сөздөрдү үйрөнөбүз';

  @override
  String get homeNatureModule => 'Табигат';

  @override
  String get homeNatureModuleSubtitle => 'Жаныбарлар жана өсүмдүктөр';

  @override
  String homeStreakLabel(int count) {
    return '$count күндүк катар';
  }

  @override
  String get homeSettings => 'Жөндөөлөр';

  @override
  String get alphabetSelectTitle => 'Алфавитти тандаңыз';

  @override
  String alphabetProgress(int learned, int total) {
    return '$learned/$total үйрөнүлдү';
  }

  @override
  String get letterGridTitle => 'Тамгалар';

  @override
  String get letterDetailListen => 'Угуу';

  @override
  String get letterDetailTrace => 'Жазуу';

  @override
  String get letterDetailView => 'Көрүү';

  @override
  String get letterDetailExampleWords => 'Мисал сөздөр';

  @override
  String get traceInstructions => 'Тамганы манжаңыз менен сызыңыз';

  @override
  String get traceSuccess => 'Мыкты!';

  @override
  String get traceTryAgain => 'Кайра аракет кылыңыз';

  @override
  String get quizTitle => 'Мини-викторина';

  @override
  String get quizQuestionLetter => 'Кайсы тамга угулду?';

  @override
  String get quizCorrect => 'Туура!';

  @override
  String get quizIncorrect => 'Туура эмес, кайра аракет кылыңыз';

  @override
  String get quizFinished => 'Викторина бүттү!';

  @override
  String quizScore(int score, int total) {
    return 'Натыйжа: $score/$total';
  }

  @override
  String get vocabularyCategoriesTitle => 'Категориялар';

  @override
  String get categoryAnimals => 'Жаныбарлар';

  @override
  String get categoryColors => 'Түстөр';

  @override
  String get categoryNumbers => 'Сандар';

  @override
  String get categoryFamily => 'Үй-бүлө';

  @override
  String get categoryFood => 'Тамак-аш';

  @override
  String get categoryClothes => 'Кийимдер';

  @override
  String get categoryTransport => 'Транспорт';

  @override
  String get categoryNature => 'Табият';

  @override
  String get flashcardListen => 'Угуу';

  @override
  String get flashcardNext => 'Кийинки';

  @override
  String get flashcardWritePractice => 'Жазып көрүү';

  @override
  String get vocabQuizChooseWord => 'Туура сөздү тандаңыз';

  @override
  String get vocabQuizChooseImage => 'Туура сүрөттү тандаңыз';

  @override
  String get settingsTitle => 'Жөндөөлөр';

  @override
  String get settingsInterfaceLanguage => 'Интерфейс тили';

  @override
  String get settingsSoundEnabled => 'Үн';

  @override
  String get settingsVoiceSpeed => 'Үн ылдамдыгы';

  @override
  String get settingsNotificationTime => 'Эскертүү убактысы';

  @override
  String get settingsParentZone => 'Ата-эне аймагы';

  @override
  String get parentZoneEnterPin => 'PIN кодду киргизиңиз';

  @override
  String get parentZoneWrongPin => 'PIN туура эмес';

  @override
  String get parentZoneSetPin => 'PIN кодду коюу';

  @override
  String get parentZoneProgressTitle => 'Балаңыздын прогресси';

  @override
  String parentZoneStatsAlphabet(int learned, int total) {
    return 'Алфавит: $learned/$total тамга';
  }

  @override
  String parentZoneStatsVocabulary(int learned, int total) {
    return 'Сөздүк: $learned/$total сөз';
  }

  @override
  String get notificationReminderTitle => 'Көнүгүү убактысы!';

  @override
  String get notificationReminderBody => 'Сиз бүгүн азырынча көнүккөн жоксуз!';

  @override
  String get commonBack => 'Артка';

  @override
  String get commonNext => 'Кийинки';

  @override
  String get commonClose => 'Жабуу';

  @override
  String get commonYes => 'Ооба';

  @override
  String get commonNo => 'Жок';

  @override
  String get commonStart => 'Баштоо';

  @override
  String get commonRetry => 'Кайталоо';

  @override
  String get commonCongrats => 'Куттуктайбыз!';

  @override
  String get natureCategoryTitle => 'Табигат темасын тандаңыз';

  @override
  String get natureAnimals => 'Жаныбарлар';

  @override
  String get naturePlants => 'Өсүмдүктөр';

  @override
  String get natureBirds => 'Куштар';

  @override
  String get natureVehicles => 'Транспорт';

  @override
  String get natureProfessions => 'Кесиптер';

  @override
  String get noInternetTitle => 'Интернет байланышы жок';

  @override
  String get noInternetBody =>
      'Колдонмо иштеши үчүн интернетке туташыңыз. Байланыш калыбына келгенде, бет автоматтык түрдө улантылат.';

  @override
  String get noInternetChecking => 'Текшерилүүдө...';

  @override
  String get unlockWithAdTitle => 'Бул бөлүм кулпуланган';

  @override
  String get unlockWithAdBody =>
      'Бул бөлүмдү биротоло ачуу үчүн жарнаманы көрүңүз';

  @override
  String get unlockWithAdButton => 'Жарнаманы көрүү';

  @override
  String get unlockWithAdNotReady =>
      'Жарнама али даяр эмес, бир аздан кийин кайра аракет кылыңыз';

  @override
  String get categoryUnlocked => 'Бөлүм ачылды!';
}
