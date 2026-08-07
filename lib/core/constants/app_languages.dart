import 'package:flutter/material.dart';

/// A supported interface language. `locale` matches an ARB file under lib/l10n.
class InterfaceLanguage {
  final Locale locale;
  final String nativeName;
  final String flag;

  const InterfaceLanguage({
    required this.locale,
    required this.nativeName,
    required this.flag,
  });
}

const List<InterfaceLanguage> kInterfaceLanguages = [
  InterfaceLanguage(locale: Locale('uz'), nativeName: "O'zbekcha", flag: '🇺🇿'),
  InterfaceLanguage(
    locale: Locale.fromSubtags(languageCode: 'uz', scriptCode: 'Cyrl'),
    nativeName: 'Ўзбекча',
    flag: '🇺🇿',
  ),
  InterfaceLanguage(locale: Locale('ru'), nativeName: 'Русский', flag: '🇷🇺'),
  InterfaceLanguage(locale: Locale('en'), nativeName: 'English', flag: '🇬🇧'),
  InterfaceLanguage(locale: Locale('ar'), nativeName: 'العربية', flag: '🇸🇦'),
  InterfaceLanguage(locale: Locale('tr'), nativeName: 'Türkçe', flag: '🇹🇷'),
  InterfaceLanguage(locale: Locale('kk'), nativeName: 'Қазақша', flag: '🇰🇿'),
  InterfaceLanguage(locale: Locale('tg'), nativeName: 'Тоҷикӣ', flag: '🇹🇯'),
  InterfaceLanguage(locale: Locale('ky'), nativeName: 'Кыргызча', flag: '🇰🇬'),
  InterfaceLanguage(locale: Locale('fr'), nativeName: 'Français', flag: '🇫🇷'),
];

const List<Locale> kSupportedLocales = [
  Locale('uz'),
  Locale.fromSubtags(languageCode: 'uz', scriptCode: 'Cyrl'),
  Locale('ru'),
  Locale('en'),
  Locale('ar'),
  Locale('tr'),
  Locale('kk'),
  Locale('tg'),
  Locale('ky'),
  Locale('fr'),
];
