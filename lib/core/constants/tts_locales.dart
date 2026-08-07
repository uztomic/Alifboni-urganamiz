/// Maps an interface language code to a BCP-47 tag for on-device TTS.
/// Some of these (tg, ky) may not have an installed voice on a given
/// device — TtsService already fails silently in that case.
const Map<String, String> kTtsLocaleForLanguage = {
  'uz': 'uz-UZ',
  'ru': 'ru-RU',
  'en': 'en-US',
  'ar': 'ar-SA',
  'tr': 'tr-TR',
  'kk': 'kk-KZ',
  'tg': 'tg-TJ',
  'ky': 'ky-KG',
  'fr': 'fr-FR',
};

String ttsLocaleForLanguage(String languageCode) =>
    kTtsLocaleForLanguage[languageCode] ?? 'en-US';
