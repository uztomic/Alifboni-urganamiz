// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tajik (`tg`).
class AppLocalizationsTg extends AppLocalizations {
  AppLocalizationsTg([String locale = 'tg']) : super(locale);

  @override
  String get appTitle => 'Алифбо ва Луғат';

  @override
  String get onboardingChooseLanguage => 'Забони худро интихоб кунед';

  @override
  String get onboardingContinue => 'Идома';

  @override
  String get homeAlphabetModule => 'Алифбо';

  @override
  String get homeAlphabetModuleSubtitle => 'Ҳарфҳоро меомӯзем';

  @override
  String get homeVocabularyModule => 'Луғат';

  @override
  String get homeVocabularyModuleSubtitle => 'Калимаҳоро меомӯзем';

  @override
  String get homeNatureModule => 'Табиат';

  @override
  String get homeNatureModuleSubtitle => 'Ҳайвонот ва растаниҳо';

  @override
  String homeStreakLabel(int count) {
    return '$count рӯзи пай дар пай';
  }

  @override
  String get homeSettings => 'Танзимот';

  @override
  String get alphabetSelectTitle => 'Алифборо интихоб кунед';

  @override
  String alphabetProgress(int learned, int total) {
    return '$learned/$total омӯхта шуд';
  }

  @override
  String get letterGridTitle => 'Ҳарфҳо';

  @override
  String get letterDetailListen => 'Гӯш кардан';

  @override
  String get letterDetailTrace => 'Навиштан';

  @override
  String get letterDetailView => 'Дидан';

  @override
  String get letterDetailExampleWords => 'Калимаҳои намуна';

  @override
  String get traceInstructions => 'Ҳарфро бо ангушт кашед';

  @override
  String get traceSuccess => 'Офарин!';

  @override
  String get traceTryAgain => 'Бори дигар кӯшиш кунед';

  @override
  String get quizTitle => 'Мини-викторина';

  @override
  String get quizQuestionLetter => 'Кадом ҳарф садо дод?';

  @override
  String get quizCorrect => 'Дуруст!';

  @override
  String get quizIncorrect => 'Нодуруст, боз кӯшиш кунед';

  @override
  String get quizFinished => 'Викторина ба анҷом расид!';

  @override
  String quizScore(int score, int total) {
    return 'Натиҷа: $score/$total';
  }

  @override
  String get vocabularyCategoriesTitle => 'Категорияҳо';

  @override
  String get categoryAnimals => 'Ҳайвонот';

  @override
  String get categoryColors => 'Рангҳо';

  @override
  String get categoryNumbers => 'Ададҳо';

  @override
  String get categoryFamily => 'Оила';

  @override
  String get categoryFood => 'Хӯрок';

  @override
  String get categoryClothes => 'Либос';

  @override
  String get categoryTransport => 'Нақлиёт';

  @override
  String get categoryNature => 'Табиат';

  @override
  String get flashcardListen => 'Гӯш кардан';

  @override
  String get flashcardNext => 'Баъдӣ';

  @override
  String get flashcardWritePractice => 'Навиштан';

  @override
  String get vocabQuizChooseWord => 'Калимаи дурустро интихоб кунед';

  @override
  String get vocabQuizChooseImage => 'Тасвири дурустро интихоб кунед';

  @override
  String get settingsTitle => 'Танзимот';

  @override
  String get settingsInterfaceLanguage => 'Забони интерфейс';

  @override
  String get settingsSoundEnabled => 'Садо';

  @override
  String get settingsVoiceSpeed => 'Суръати садо';

  @override
  String get settingsNotificationTime => 'Вақти ёдоварӣ';

  @override
  String get settingsParentZone => 'Минтақаи волидайн';

  @override
  String get parentZoneEnterPin => 'Рамзи PIN-ро ворид кунед';

  @override
  String get parentZoneWrongPin => 'PIN нодуруст аст';

  @override
  String get parentZoneSetPin => 'Танзими рамзи PIN';

  @override
  String get parentZoneProgressTitle => 'Пешрафти фарзандатон';

  @override
  String parentZoneStatsAlphabet(int learned, int total) {
    return 'Алифбо: $learned/$total ҳарф';
  }

  @override
  String parentZoneStatsVocabulary(int learned, int total) {
    return 'Луғат: $learned/$total калима';
  }

  @override
  String get notificationReminderTitle => 'Вақти машқ расид!';

  @override
  String get notificationReminderBody => 'Шумо имрӯз ҳанӯз машқ накардаед!';

  @override
  String get commonBack => 'Бозгашт';

  @override
  String get commonNext => 'Баъдӣ';

  @override
  String get commonClose => 'Пӯшидан';

  @override
  String get commonYes => 'Ҳа';

  @override
  String get commonNo => 'Не';

  @override
  String get commonStart => 'Оғоз';

  @override
  String get commonRetry => 'Такрор';

  @override
  String get commonCongrats => 'Табрик!';

  @override
  String get natureCategoryTitle => 'Мавзӯи табиатро интихоб кунед';

  @override
  String get natureAnimals => 'Ҳайвонот';

  @override
  String get naturePlants => 'Растаниҳо';

  @override
  String get natureBirds => 'Паррандагон';

  @override
  String get natureVehicles => 'Нақлиёт';

  @override
  String get natureProfessions => 'Касбҳо';

  @override
  String get noInternetTitle => 'Алоқаи интернет нест';

  @override
  String get noInternetBody =>
      'Барои кор кардани барнома ба интернет пайваст шавед. Пас аз барқарор шудани алоқа, саҳифа худкор идома меёбад.';

  @override
  String get noInternetChecking => 'Тафтиш шуда истодааст...';

  @override
  String get unlockWithAdTitle => 'Ин бахш қулф аст';

  @override
  String get unlockWithAdBody => 'Барои кушодани ин бахш реклама тамошо кунед';

  @override
  String get unlockWithAdButton => 'Тамошои реклама';

  @override
  String get unlockWithAdNotReady =>
      'Реклама ҳанӯз омода нест, баъд аз каме бори дигар кӯшиш кунед';

  @override
  String get categoryUnlocked => 'Бахш кушода шуд!';
}
