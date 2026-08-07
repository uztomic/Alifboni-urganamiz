// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appTitle => 'Alifbo & Lug\'at';

  @override
  String get onboardingChooseLanguage => 'Tilni tanlang';

  @override
  String get onboardingContinue => 'Davom etish';

  @override
  String get homeAlphabetModule => 'Alifbo';

  @override
  String get homeAlphabetModuleSubtitle => 'Harflarni o\'rganamiz';

  @override
  String get homeVocabularyModule => 'Lug\'at';

  @override
  String get homeVocabularyModuleSubtitle => 'So\'zlarni o\'rganamiz';

  @override
  String get homeNatureModule => 'Tabiat';

  @override
  String get homeNatureModuleSubtitle => 'Hayvonlar va o\'simliklar';

  @override
  String homeStreakLabel(int count) {
    return '$count kunlik olov';
  }

  @override
  String get homeSettings => 'Sozlamalar';

  @override
  String get alphabetSelectTitle => 'Alifboni tanlang';

  @override
  String alphabetProgress(int learned, int total) {
    return '$learned/$total o\'rganildi';
  }

  @override
  String get letterGridTitle => 'Harflar';

  @override
  String get letterDetailListen => 'Eshitish';

  @override
  String get letterDetailTrace => 'Chizish';

  @override
  String get letterDetailView => 'Ko\'rish';

  @override
  String get letterDetailExampleWords => 'Misol so\'zlar';

  @override
  String get traceInstructions => 'Barmog\'ingiz bilan harfni chizing';

  @override
  String get traceSuccess => 'Ajoyib!';

  @override
  String get traceTryAgain => 'Yana urinib ko\'ring';

  @override
  String get quizTitle => 'Mini-viktorina';

  @override
  String get quizQuestionLetter => 'Qaysi harf tovushi eshitildi?';

  @override
  String get quizCorrect => 'To\'g\'ri!';

  @override
  String get quizIncorrect => 'Noto\'g\'ri, yana urinib ko\'ring';

  @override
  String get quizFinished => 'Viktorina tugadi!';

  @override
  String quizScore(int score, int total) {
    return 'Natija: $score/$total';
  }

  @override
  String get vocabularyCategoriesTitle => 'Kategoriyalar';

  @override
  String get categoryAnimals => 'Hayvonlar';

  @override
  String get categoryColors => 'Ranglar';

  @override
  String get categoryNumbers => 'Sonlar';

  @override
  String get categoryFamily => 'Oila';

  @override
  String get categoryFood => 'Ovqatlar';

  @override
  String get categoryClothes => 'Kiyimlar';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryNature => 'Tabiat';

  @override
  String get flashcardListen => 'Tinglash';

  @override
  String get flashcardNext => 'Keyingisi';

  @override
  String get flashcardWritePractice => 'Yozib ko\'rish';

  @override
  String get vocabQuizChooseWord => 'To\'g\'ri so\'zni tanlang';

  @override
  String get vocabQuizChooseImage => 'To\'g\'ri rasmni tanlang';

  @override
  String get settingsTitle => 'Sozlamalar';

  @override
  String get settingsInterfaceLanguage => 'Interfeys tili';

  @override
  String get settingsSoundEnabled => 'Ovoz';

  @override
  String get settingsVoiceSpeed => 'Ovoz tezligi';

  @override
  String get settingsNotificationTime => 'Eslatma vaqti';

  @override
  String get settingsParentZone => 'Ota-ona zonasi';

  @override
  String get parentZoneEnterPin => 'PIN kodni kiriting';

  @override
  String get parentZoneWrongPin => 'PIN noto\'g\'ri';

  @override
  String get parentZoneSetPin => 'PIN kod o\'rnatish';

  @override
  String get parentZoneProgressTitle => 'Farzandingiz progressi';

  @override
  String parentZoneStatsAlphabet(int learned, int total) {
    return 'Alifbo: $learned/$total harf';
  }

  @override
  String parentZoneStatsVocabulary(int learned, int total) {
    return 'Lug\'at: $learned/$total so\'z';
  }

  @override
  String get notificationReminderTitle => 'Vaqt keldi!';

  @override
  String get notificationReminderBody => 'Bugun hali mashq qilmadingiz!';

  @override
  String get commonBack => 'Orqaga';

  @override
  String get commonNext => 'Keyingi';

  @override
  String get commonClose => 'Yopish';

  @override
  String get commonYes => 'Ha';

  @override
  String get commonNo => 'Yo\'q';

  @override
  String get commonStart => 'Boshlash';

  @override
  String get commonRetry => 'Qayta urinish';

  @override
  String get commonCongrats => 'Tabriklaymiz!';

  @override
  String get natureCategoryTitle => 'Tabiatni tanlang';

  @override
  String get natureAnimals => 'Hayvonlar';

  @override
  String get naturePlants => 'O\'simliklar';

  @override
  String get natureBirds => 'Qushlar';

  @override
  String get natureVehicles => 'Transport';

  @override
  String get natureProfessions => 'Kasblar';

  @override
  String get noInternetTitle => 'Internet aloqasi yo\'q';

  @override
  String get noInternetBody =>
      'Ilova ishlashi uchun internetga ulaning. Aloqa tiklansa, sahifa avtomatik davom etadi.';

  @override
  String get noInternetChecking => 'Tekshirilmoqda...';

  @override
  String get unlockWithAdTitle => 'Bu bo\'lim qulflangan';

  @override
  String get unlockWithAdBody =>
      'Reklama ko\'rib, ushbu bo\'limni butunlay oching';

  @override
  String get unlockWithAdButton => 'Reklama ko\'rish';

  @override
  String get unlockWithAdNotReady =>
      'Reklama hali tayyor emas, birozdan keyin urinib ko\'ring';

  @override
  String get categoryUnlocked => 'Bo\'lim ochildi!';
}

/// The translations for Uzbek, using the Cyrillic script (`uz_Cyrl`).
class AppLocalizationsUzCyrl extends AppLocalizationsUz {
  AppLocalizationsUzCyrl() : super('uz_Cyrl');

  @override
  String get appTitle => 'Алифбо & Луғат';

  @override
  String get onboardingChooseLanguage => 'Тилни танланг';

  @override
  String get onboardingContinue => 'Давом этиш';

  @override
  String get homeAlphabetModule => 'Алифбо';

  @override
  String get homeAlphabetModuleSubtitle => 'Ҳарфларни ўрганамиз';

  @override
  String get homeVocabularyModule => 'Луғат';

  @override
  String get homeVocabularyModuleSubtitle => 'Сўзларни ўрганамиз';

  @override
  String get homeNatureModule => 'Табиат';

  @override
  String get homeNatureModuleSubtitle => 'Ҳайвонлар ва ўсимликлар';

  @override
  String homeStreakLabel(int count) {
    return '$count кунлик олов';
  }

  @override
  String get homeSettings => 'Созламалар';

  @override
  String get alphabetSelectTitle => 'Алифбони танланг';

  @override
  String alphabetProgress(int learned, int total) {
    return '$learned/$total ўрганилди';
  }

  @override
  String get letterGridTitle => 'Ҳарфлар';

  @override
  String get letterDetailListen => 'Эшитиш';

  @override
  String get letterDetailTrace => 'Чизиш';

  @override
  String get letterDetailView => 'Кўриш';

  @override
  String get letterDetailExampleWords => 'Мисол сўзлар';

  @override
  String get traceInstructions => 'Бармоғингиз билан ҳарфни чизинг';

  @override
  String get traceSuccess => 'Ажойиб!';

  @override
  String get traceTryAgain => 'Яна уриниб кўринг';

  @override
  String get quizTitle => 'Мини-викторина';

  @override
  String get quizQuestionLetter => 'Қайси ҳарф товуши эшитилди?';

  @override
  String get quizCorrect => 'Тўғри!';

  @override
  String get quizIncorrect => 'Нотўғри, яна уриниб кўринг';

  @override
  String get quizFinished => 'Викторина тугади!';

  @override
  String quizScore(int score, int total) {
    return 'Натижа: $score/$total';
  }

  @override
  String get vocabularyCategoriesTitle => 'Категориялар';

  @override
  String get categoryAnimals => 'Ҳайвонлар';

  @override
  String get categoryColors => 'Ранглар';

  @override
  String get categoryNumbers => 'Сонлар';

  @override
  String get categoryFamily => 'Оила';

  @override
  String get categoryFood => 'Овқатлар';

  @override
  String get categoryClothes => 'Кийимлар';

  @override
  String get categoryTransport => 'Транспорт';

  @override
  String get categoryNature => 'Табиат';

  @override
  String get flashcardListen => 'Тинглаш';

  @override
  String get flashcardNext => 'Кейингиси';

  @override
  String get flashcardWritePractice => 'Ёзиб кўриш';

  @override
  String get vocabQuizChooseWord => 'Тўғри сўзни танланг';

  @override
  String get vocabQuizChooseImage => 'Тўғри расмни танланг';

  @override
  String get settingsTitle => 'Созламалар';

  @override
  String get settingsInterfaceLanguage => 'Интерфейс тили';

  @override
  String get settingsSoundEnabled => 'Овоз';

  @override
  String get settingsVoiceSpeed => 'Овоз тезлиги';

  @override
  String get settingsNotificationTime => 'Эслатма вақти';

  @override
  String get settingsParentZone => 'Ота-она зонаси';

  @override
  String get parentZoneEnterPin => 'PIN кодни киритинг';

  @override
  String get parentZoneWrongPin => 'PIN нотўғри';

  @override
  String get parentZoneSetPin => 'PIN код ўрнатиш';

  @override
  String get parentZoneProgressTitle => 'Фарзандингиз прогресси';

  @override
  String parentZoneStatsAlphabet(int learned, int total) {
    return 'Алифбо: $learned/$total ҳарф';
  }

  @override
  String parentZoneStatsVocabulary(int learned, int total) {
    return 'Луғат: $learned/$total сўз';
  }

  @override
  String get notificationReminderTitle => 'Вақт келди!';

  @override
  String get notificationReminderBody => 'Бугун ҳали машқ қилмадингиз!';

  @override
  String get commonBack => 'Орқага';

  @override
  String get commonNext => 'Кейинги';

  @override
  String get commonClose => 'Ёпиш';

  @override
  String get commonYes => 'Ҳа';

  @override
  String get commonNo => 'Йўқ';

  @override
  String get commonStart => 'Бошлаш';

  @override
  String get commonRetry => 'Қайта уриниш';

  @override
  String get commonCongrats => 'Табриклаймиз!';

  @override
  String get natureCategoryTitle => 'Табиатни танланг';

  @override
  String get natureAnimals => 'Ҳайвонлар';

  @override
  String get naturePlants => 'Ўсимликлар';

  @override
  String get natureBirds => 'Қушлар';

  @override
  String get natureVehicles => 'Транспорт';

  @override
  String get natureProfessions => 'Касблар';

  @override
  String get noInternetTitle => 'Интернет алоқаси йўқ';

  @override
  String get noInternetBody =>
      'Илова ишлаши учун интернетга уланинг. Алоқа тикланса, саҳифа автоматик давом этади.';

  @override
  String get noInternetChecking => 'Текширилмоқда...';

  @override
  String get unlockWithAdTitle => 'Бу бўлим қулфланган';

  @override
  String get unlockWithAdBody => 'Реклама кўриб, ушбу бўлимни бутунлай очинг';

  @override
  String get unlockWithAdButton => 'Реклама кўриш';

  @override
  String get unlockWithAdNotReady =>
      'Реклама ҳали тайёр эмас, бироздан кейин уриниб кўринг';

  @override
  String get categoryUnlocked => 'Бўлим очилди!';
}
