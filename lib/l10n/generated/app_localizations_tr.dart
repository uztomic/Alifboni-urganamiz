// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Alfabe & Sözlük';

  @override
  String get onboardingChooseLanguage => 'Dilinizi seçin';

  @override
  String get onboardingContinue => 'Devam et';

  @override
  String get homeAlphabetModule => 'Alfabe';

  @override
  String get homeAlphabetModuleSubtitle => 'Harfleri öğreniyoruz';

  @override
  String get homeVocabularyModule => 'Sözlük';

  @override
  String get homeVocabularyModuleSubtitle => 'Kelimeleri öğreniyoruz';

  @override
  String get homeNatureModule => 'Doğa';

  @override
  String get homeNatureModuleSubtitle => 'Hayvanlar ve bitkiler';

  @override
  String homeStreakLabel(int count) {
    return '$count günlük seri';
  }

  @override
  String get homeSettings => 'Ayarlar';

  @override
  String get alphabetSelectTitle => 'Bir alfabe seçin';

  @override
  String alphabetProgress(int learned, int total) {
    return '$learned/$total öğrenildi';
  }

  @override
  String get letterGridTitle => 'Harfler';

  @override
  String get letterDetailListen => 'Dinle';

  @override
  String get letterDetailTrace => 'Yaz';

  @override
  String get letterDetailView => 'Görüntüle';

  @override
  String get letterDetailExampleWords => 'Örnek kelimeler';

  @override
  String get traceInstructions => 'Harfi parmağınla çiz';

  @override
  String get traceSuccess => 'Harika!';

  @override
  String get traceTryAgain => 'Tekrar dene';

  @override
  String get quizTitle => 'Mini test';

  @override
  String get quizQuestionLetter => 'Hangi harfi duydun?';

  @override
  String get quizCorrect => 'Doğru!';

  @override
  String get quizIncorrect => 'Yanlış, tekrar dene';

  @override
  String get quizFinished => 'Test bitti!';

  @override
  String quizScore(int score, int total) {
    return 'Puan: $score/$total';
  }

  @override
  String get vocabularyCategoriesTitle => 'Kategoriler';

  @override
  String get categoryAnimals => 'Hayvanlar';

  @override
  String get categoryColors => 'Renkler';

  @override
  String get categoryNumbers => 'Sayılar';

  @override
  String get categoryFamily => 'Aile';

  @override
  String get categoryFood => 'Yiyecekler';

  @override
  String get categoryClothes => 'Kıyafetler';

  @override
  String get categoryTransport => 'Ulaşım';

  @override
  String get categoryNature => 'Doğa';

  @override
  String get flashcardListen => 'Dinle';

  @override
  String get flashcardNext => 'Sonraki';

  @override
  String get flashcardWritePractice => 'Yaz';

  @override
  String get vocabQuizChooseWord => 'Doğru kelimeyi seç';

  @override
  String get vocabQuizChooseImage => 'Doğru resmi seç';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsInterfaceLanguage => 'Arayüz dili';

  @override
  String get settingsSoundEnabled => 'Ses';

  @override
  String get settingsVoiceSpeed => 'Ses hızı';

  @override
  String get settingsNotificationTime => 'Hatırlatma saati';

  @override
  String get settingsParentZone => 'Ebeveyn bölgesi';

  @override
  String get parentZoneEnterPin => 'PIN kodunu girin';

  @override
  String get parentZoneWrongPin => 'Yanlış PIN';

  @override
  String get parentZoneSetPin => 'PIN kodu belirle';

  @override
  String get parentZoneProgressTitle => 'Çocuğunuzun ilerlemesi';

  @override
  String parentZoneStatsAlphabet(int learned, int total) {
    return 'Alfabe: $learned/$total harf';
  }

  @override
  String parentZoneStatsVocabulary(int learned, int total) {
    return 'Sözlük: $learned/$total kelime';
  }

  @override
  String get notificationReminderTitle => 'Alıştırma zamanı!';

  @override
  String get notificationReminderBody => 'Bugün henüz alıştırma yapmadın!';

  @override
  String get commonBack => 'Geri';

  @override
  String get commonNext => 'İleri';

  @override
  String get commonClose => 'Kapat';

  @override
  String get commonYes => 'Evet';

  @override
  String get commonNo => 'Hayır';

  @override
  String get commonStart => 'Başla';

  @override
  String get commonRetry => 'Tekrar dene';

  @override
  String get commonCongrats => 'Tebrikler!';

  @override
  String get natureCategoryTitle => 'Bir doğa konusu seçin';

  @override
  String get natureAnimals => 'Hayvanlar';

  @override
  String get naturePlants => 'Bitkiler';

  @override
  String get natureBirds => 'Kuşlar';

  @override
  String get natureVehicles => 'Taşıtlar';

  @override
  String get natureProfessions => 'Meslekler';

  @override
  String get noInternetTitle => 'İnternet bağlantısı yok';

  @override
  String get noInternetBody =>
      'Uygulamayı kullanmak için internete bağlanın. Bağlantı geri geldiğinde otomatik olarak devam eder.';

  @override
  String get noInternetChecking => 'Kontrol ediliyor...';

  @override
  String get unlockWithAdTitle => 'Bu bölüm kilitli';

  @override
  String get unlockWithAdBody =>
      'Bu bölümü kalıcı olarak açmak için bir reklam izleyin';

  @override
  String get unlockWithAdButton => 'Reklamı izle';

  @override
  String get unlockWithAdNotReady =>
      'Reklam henüz hazır değil, biraz sonra tekrar deneyin';

  @override
  String get categoryUnlocked => 'Bölüm açıldı!';
}
