// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Alphabet & Vocabulaire';

  @override
  String get onboardingChooseLanguage => 'Choisissez votre langue';

  @override
  String get onboardingContinue => 'Continuer';

  @override
  String get homeAlphabetModule => 'Alphabet';

  @override
  String get homeAlphabetModuleSubtitle => 'Apprenons les lettres';

  @override
  String get homeVocabularyModule => 'Vocabulaire';

  @override
  String get homeVocabularyModuleSubtitle => 'Apprenons les mots';

  @override
  String get homeNatureModule => 'Nature';

  @override
  String get homeNatureModuleSubtitle => 'Animaux et plantes';

  @override
  String homeStreakLabel(int count) {
    return '$count jours de suite';
  }

  @override
  String get homeSettings => 'Paramètres';

  @override
  String get alphabetSelectTitle => 'Choisissez un alphabet';

  @override
  String alphabetProgress(int learned, int total) {
    return '$learned/$total appris';
  }

  @override
  String get letterGridTitle => 'Lettres';

  @override
  String get letterDetailListen => 'Écouter';

  @override
  String get letterDetailTrace => 'Tracer';

  @override
  String get letterDetailView => 'Voir';

  @override
  String get letterDetailExampleWords => 'Mots d\'exemple';

  @override
  String get traceInstructions => 'Trace la lettre avec ton doigt';

  @override
  String get traceSuccess => 'Bravo !';

  @override
  String get traceTryAgain => 'Réessaie';

  @override
  String get quizTitle => 'Mini quiz';

  @override
  String get quizQuestionLetter => 'Quelle lettre as-tu entendue ?';

  @override
  String get quizCorrect => 'Correct !';

  @override
  String get quizIncorrect => 'Pas tout à fait, réessaie';

  @override
  String get quizFinished => 'Quiz terminé !';

  @override
  String quizScore(int score, int total) {
    return 'Score : $score/$total';
  }

  @override
  String get vocabularyCategoriesTitle => 'Catégories';

  @override
  String get categoryAnimals => 'Animaux';

  @override
  String get categoryColors => 'Couleurs';

  @override
  String get categoryNumbers => 'Nombres';

  @override
  String get categoryFamily => 'Famille';

  @override
  String get categoryFood => 'Nourriture';

  @override
  String get categoryClothes => 'Vêtements';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryNature => 'Nature';

  @override
  String get flashcardListen => 'Écouter';

  @override
  String get flashcardNext => 'Suivant';

  @override
  String get flashcardWritePractice => 'Écrire';

  @override
  String get vocabQuizChooseWord => 'Choisis le bon mot';

  @override
  String get vocabQuizChooseImage => 'Choisis la bonne image';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsInterfaceLanguage => 'Langue de l\'interface';

  @override
  String get settingsSoundEnabled => 'Son';

  @override
  String get settingsVoiceSpeed => 'Vitesse de la voix';

  @override
  String get settingsNotificationTime => 'Heure du rappel';

  @override
  String get settingsParentZone => 'Espace parents';

  @override
  String get parentZoneEnterPin => 'Entrez le code PIN';

  @override
  String get parentZoneWrongPin => 'Code PIN incorrect';

  @override
  String get parentZoneSetPin => 'Définir le code PIN';

  @override
  String get parentZoneProgressTitle => 'Progrès de votre enfant';

  @override
  String parentZoneStatsAlphabet(int learned, int total) {
    return 'Alphabet : $learned/$total lettres';
  }

  @override
  String parentZoneStatsVocabulary(int learned, int total) {
    return 'Vocabulaire : $learned/$total mots';
  }

  @override
  String get notificationReminderTitle => 'C\'est l\'heure de s\'entraîner !';

  @override
  String get notificationReminderBody =>
      'Tu n\'as pas encore pratiqué aujourd\'hui !';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonNext => 'Suivant';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonYes => 'Oui';

  @override
  String get commonNo => 'Non';

  @override
  String get commonStart => 'Commencer';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonCongrats => 'Félicitations !';

  @override
  String get natureCategoryTitle => 'Choisis un thème nature';

  @override
  String get natureAnimals => 'Animaux';

  @override
  String get naturePlants => 'Plantes';

  @override
  String get natureBirds => 'Oiseaux';

  @override
  String get natureVehicles => 'Véhicules';

  @override
  String get natureProfessions => 'Métiers';

  @override
  String get noInternetTitle => 'Pas de connexion internet';

  @override
  String get noInternetBody =>
      'Connecte-toi à internet pour utiliser l\'application. Elle reprendra automatiquement dès que la connexion sera rétablie.';

  @override
  String get noInternetChecking => 'Vérification...';

  @override
  String get unlockWithAdTitle => 'Cette section est verrouillée';

  @override
  String get unlockWithAdBody =>
      'Regarde une publicité pour déverrouiller cette section définitivement';

  @override
  String get unlockWithAdButton => 'Regarder la pub';

  @override
  String get unlockWithAdNotReady =>
      'La publicité n\'est pas encore prête, réessaie dans un instant';

  @override
  String get categoryUnlocked => 'Section déverrouillée !';
}
