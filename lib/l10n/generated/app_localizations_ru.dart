// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Алфавит и Словарь';

  @override
  String get onboardingChooseLanguage => 'Выберите язык';

  @override
  String get onboardingContinue => 'Продолжить';

  @override
  String get homeAlphabetModule => 'Алфавит';

  @override
  String get homeAlphabetModuleSubtitle => 'Учим буквы';

  @override
  String get homeVocabularyModule => 'Словарь';

  @override
  String get homeVocabularyModuleSubtitle => 'Учим слова';

  @override
  String get homeNatureModule => 'Природа';

  @override
  String get homeNatureModuleSubtitle => 'Животные и растения';

  @override
  String homeStreakLabel(int count) {
    return '$count дней подряд';
  }

  @override
  String get homeSettings => 'Настройки';

  @override
  String get alphabetSelectTitle => 'Выберите алфавит';

  @override
  String alphabetProgress(int learned, int total) {
    return '$learned/$total изучено';
  }

  @override
  String get letterGridTitle => 'Буквы';

  @override
  String get letterDetailListen => 'Слушать';

  @override
  String get letterDetailTrace => 'Писать';

  @override
  String get letterDetailView => 'Смотреть';

  @override
  String get letterDetailExampleWords => 'Примеры слов';

  @override
  String get traceInstructions => 'Обведите букву пальцем';

  @override
  String get traceSuccess => 'Отлично!';

  @override
  String get traceTryAgain => 'Попробуйте ещё раз';

  @override
  String get quizTitle => 'Мини-викторина';

  @override
  String get quizQuestionLetter => 'Какая буква прозвучала?';

  @override
  String get quizCorrect => 'Правильно!';

  @override
  String get quizIncorrect => 'Неправильно, попробуйте ещё раз';

  @override
  String get quizFinished => 'Викторина завершена!';

  @override
  String quizScore(int score, int total) {
    return 'Результат: $score/$total';
  }

  @override
  String get vocabularyCategoriesTitle => 'Категории';

  @override
  String get categoryAnimals => 'Животные';

  @override
  String get categoryColors => 'Цвета';

  @override
  String get categoryNumbers => 'Числа';

  @override
  String get categoryFamily => 'Семья';

  @override
  String get categoryFood => 'Еда';

  @override
  String get categoryClothes => 'Одежда';

  @override
  String get categoryTransport => 'Транспорт';

  @override
  String get categoryNature => 'Природа';

  @override
  String get flashcardListen => 'Слушать';

  @override
  String get flashcardNext => 'Далее';

  @override
  String get flashcardWritePractice => 'Написать';

  @override
  String get vocabQuizChooseWord => 'Выберите правильное слово';

  @override
  String get vocabQuizChooseImage => 'Выберите правильную картинку';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsInterfaceLanguage => 'Язык интерфейса';

  @override
  String get settingsSoundEnabled => 'Звук';

  @override
  String get settingsVoiceSpeed => 'Скорость голоса';

  @override
  String get settingsNotificationTime => 'Время напоминания';

  @override
  String get settingsParentZone => 'Родительская зона';

  @override
  String get parentZoneEnterPin => 'Введите PIN-код';

  @override
  String get parentZoneWrongPin => 'Неверный PIN';

  @override
  String get parentZoneSetPin => 'Установить PIN-код';

  @override
  String get parentZoneProgressTitle => 'Прогресс вашего ребёнка';

  @override
  String parentZoneStatsAlphabet(int learned, int total) {
    return 'Алфавит: $learned/$total букв';
  }

  @override
  String parentZoneStatsVocabulary(int learned, int total) {
    return 'Словарь: $learned/$total слов';
  }

  @override
  String get notificationReminderTitle => 'Пора заниматься!';

  @override
  String get notificationReminderBody => 'Вы ещё не занимались сегодня!';

  @override
  String get commonBack => 'Назад';

  @override
  String get commonNext => 'Далее';

  @override
  String get commonClose => 'Закрыть';

  @override
  String get commonYes => 'Да';

  @override
  String get commonNo => 'Нет';

  @override
  String get commonStart => 'Начать';

  @override
  String get commonRetry => 'Повторить';

  @override
  String get commonCongrats => 'Поздравляем!';

  @override
  String get natureCategoryTitle => 'Выберите раздел природы';

  @override
  String get natureAnimals => 'Животные';

  @override
  String get naturePlants => 'Растения';

  @override
  String get natureBirds => 'Птицы';

  @override
  String get natureVehicles => 'Транспорт';

  @override
  String get natureProfessions => 'Профессии';

  @override
  String get noInternetTitle => 'Нет подключения к интернету';

  @override
  String get noInternetBody =>
      'Для работы приложения подключитесь к интернету. Как только соединение появится, страница продолжит работу автоматически.';

  @override
  String get noInternetChecking => 'Проверка...';

  @override
  String get unlockWithAdTitle => 'Этот раздел заблокирован';

  @override
  String get unlockWithAdBody =>
      'Посмотрите рекламу, чтобы открыть этот раздел навсегда';

  @override
  String get unlockWithAdButton => 'Посмотреть рекламу';

  @override
  String get unlockWithAdNotReady =>
      'Реклама ещё не готова, попробуйте чуть позже';

  @override
  String get categoryUnlocked => 'Раздел открыт!';
}
