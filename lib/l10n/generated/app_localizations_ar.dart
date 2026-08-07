// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'الأبجدية والقاموس';

  @override
  String get onboardingChooseLanguage => 'اختر لغتك';

  @override
  String get onboardingContinue => 'متابعة';

  @override
  String get homeAlphabetModule => 'الأبجدية';

  @override
  String get homeAlphabetModuleSubtitle => 'نتعلم الحروف';

  @override
  String get homeVocabularyModule => 'القاموس';

  @override
  String get homeVocabularyModuleSubtitle => 'نتعلم الكلمات';

  @override
  String get homeNatureModule => 'الطبيعة';

  @override
  String get homeNatureModuleSubtitle => 'الحيوانات والنباتات';

  @override
  String homeStreakLabel(int count) {
    return '$count أيام متتالية';
  }

  @override
  String get homeSettings => 'الإعدادات';

  @override
  String get alphabetSelectTitle => 'اختر الأبجدية';

  @override
  String alphabetProgress(int learned, int total) {
    return '$learned/$total تم تعلمها';
  }

  @override
  String get letterGridTitle => 'الحروف';

  @override
  String get letterDetailListen => 'استماع';

  @override
  String get letterDetailTrace => 'كتابة';

  @override
  String get letterDetailView => 'عرض';

  @override
  String get letterDetailExampleWords => 'كلمات مثال';

  @override
  String get traceInstructions => 'ارسم الحرف بإصبعك';

  @override
  String get traceSuccess => 'أحسنت!';

  @override
  String get traceTryAgain => 'حاول مرة أخرى';

  @override
  String get quizTitle => 'اختبار قصير';

  @override
  String get quizQuestionLetter => 'ما هو الحرف الذي سمعته؟';

  @override
  String get quizCorrect => 'إجابة صحيحة!';

  @override
  String get quizIncorrect => 'غير صحيح، حاول مرة أخرى';

  @override
  String get quizFinished => 'انتهى الاختبار!';

  @override
  String quizScore(int score, int total) {
    return 'النتيجة: $score/$total';
  }

  @override
  String get vocabularyCategoriesTitle => 'الفئات';

  @override
  String get categoryAnimals => 'الحيوانات';

  @override
  String get categoryColors => 'الألوان';

  @override
  String get categoryNumbers => 'الأرقام';

  @override
  String get categoryFamily => 'العائلة';

  @override
  String get categoryFood => 'الطعام';

  @override
  String get categoryClothes => 'الملابس';

  @override
  String get categoryTransport => 'المواصلات';

  @override
  String get categoryNature => 'الطبيعة';

  @override
  String get flashcardListen => 'استماع';

  @override
  String get flashcardNext => 'التالي';

  @override
  String get flashcardWritePractice => 'اكتبها';

  @override
  String get vocabQuizChooseWord => 'اختر الكلمة الصحيحة';

  @override
  String get vocabQuizChooseImage => 'اختر الصورة الصحيحة';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsInterfaceLanguage => 'لغة الواجهة';

  @override
  String get settingsSoundEnabled => 'الصوت';

  @override
  String get settingsVoiceSpeed => 'سرعة الصوت';

  @override
  String get settingsNotificationTime => 'وقت التذكير';

  @override
  String get settingsParentZone => 'منطقة الوالدين';

  @override
  String get parentZoneEnterPin => 'أدخل رمز PIN';

  @override
  String get parentZoneWrongPin => 'رمز PIN غير صحيح';

  @override
  String get parentZoneSetPin => 'تعيين رمز PIN';

  @override
  String get parentZoneProgressTitle => 'تقدم طفلك';

  @override
  String parentZoneStatsAlphabet(int learned, int total) {
    return 'الأبجدية: $learned/$total حرف';
  }

  @override
  String parentZoneStatsVocabulary(int learned, int total) {
    return 'القاموس: $learned/$total كلمة';
  }

  @override
  String get notificationReminderTitle => 'حان وقت التدريب!';

  @override
  String get notificationReminderBody => 'لم تتدرب اليوم بعد!';

  @override
  String get commonBack => 'رجوع';

  @override
  String get commonNext => 'التالي';

  @override
  String get commonClose => 'إغلاق';

  @override
  String get commonYes => 'نعم';

  @override
  String get commonNo => 'لا';

  @override
  String get commonStart => 'ابدأ';

  @override
  String get commonRetry => 'إعادة المحاولة';

  @override
  String get commonCongrats => 'تهانينا!';

  @override
  String get natureCategoryTitle => 'اختر موضوع الطبيعة';

  @override
  String get natureAnimals => 'الحيوانات';

  @override
  String get naturePlants => 'النباتات';

  @override
  String get natureBirds => 'الطيور';

  @override
  String get natureVehicles => 'المركبات';

  @override
  String get natureProfessions => 'المهن';

  @override
  String get noInternetTitle => 'لا يوجد اتصال بالإنترنت';

  @override
  String get noInternetBody =>
      'يرجى الاتصال بالإنترنت لاستخدام التطبيق. سيستمر تلقائيًا بمجرد عودة الاتصال.';

  @override
  String get noInternetChecking => 'جارٍ التحقق...';

  @override
  String get unlockWithAdTitle => 'هذا القسم مقفل';

  @override
  String get unlockWithAdBody => 'شاهد إعلانًا لفتح هذا القسم نهائيًا';

  @override
  String get unlockWithAdButton => 'مشاهدة الإعلان';

  @override
  String get unlockWithAdNotReady =>
      'الإعلان غير جاهز بعد، حاول مرة أخرى بعد قليل';

  @override
  String get categoryUnlocked => 'تم فتح القسم!';
}
