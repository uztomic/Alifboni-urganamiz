import 'package:hive_flutter/hive_flutter.dart';

/// Thin wrapper around Hive boxes. No custom TypeAdapters are needed:
/// everything is stored as primitive maps/values, which Hive supports
/// natively and keeps the storage layer simple and dependency-free.
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  static const _settingsBoxName = 'settings';
  static const _alphabetProgressBoxName = 'alphabet_progress';
  static const _vocabProgressBoxName = 'vocab_progress';

  late Box _settingsBox;
  late Box _alphabetProgressBox;
  late Box _vocabProgressBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _settingsBox = await Hive.openBox(_settingsBoxName);
    _alphabetProgressBox = await Hive.openBox(_alphabetProgressBoxName);
    _vocabProgressBox = await Hive.openBox(_vocabProgressBoxName);
  }

  // ---- Settings ----
  String? get interfaceLanguageCode => _settingsBox.get('interfaceLanguage');
  Future<void> setInterfaceLanguageCode(String code) =>
      _settingsBox.put('interfaceLanguage', code);

  bool get soundEnabled => _settingsBox.get('soundEnabled', defaultValue: true);
  Future<void> setSoundEnabled(bool v) => _settingsBox.put('soundEnabled', v);

  double get voiceSpeed => _settingsBox.get('voiceSpeed', defaultValue: 0.45);
  Future<void> setVoiceSpeed(double v) => _settingsBox.put('voiceSpeed', v);

  String? get parentPinHash => _settingsBox.get('parentPinHash');
  Future<void> setParentPinHash(String? hash) =>
      _settingsBox.put('parentPinHash', hash);

  int get streakCount => _settingsBox.get('streakCount', defaultValue: 0);
  Future<void> setStreakCount(int v) => _settingsBox.put('streakCount', v);

  String? get lastPracticedDate => _settingsBox.get('lastPracticedDate');
  Future<void> setLastPracticedDate(String isoDate) =>
      _settingsBox.put('lastPracticedDate', isoDate);

  // ---- Alphabet progress ----
  /// Stars (0-3) for a letter, keyed as "`alphabetId`_`letterChar`".
  int starsForLetter(String alphabetId, String letterChar) {
    return _alphabetProgressBox.get('${alphabetId}_$letterChar', defaultValue: 0);
  }

  Future<void> setStarsForLetter(
      String alphabetId, String letterChar, int stars) async {
    final key = '${alphabetId}_$letterChar';
    final current = _alphabetProgressBox.get(key, defaultValue: 0) as int;
    if (stars > current) {
      await _alphabetProgressBox.put(key, stars);
    }
  }

  int learnedCountForAlphabet(String alphabetId, List<String> allLetters) {
    return allLetters
        .where((l) => starsForLetter(alphabetId, l) > 0)
        .length;
  }

  // ---- Vocabulary progress ----
  int timesPracticedForWord(String wordId) =>
      _vocabProgressBox.get(wordId, defaultValue: 0);

  Future<void> incrementWordPracticed(String wordId) async {
    final current = timesPracticedForWord(wordId);
    await _vocabProgressBox.put(wordId, current + 1);
  }

  int learnedCountForCategory(List<String> wordIds) {
    return wordIds.where((id) => timesPracticedForWord(id) > 0).length;
  }

  // ---- Rewarded-ad category unlocks ----
  bool isCategoryUnlocked(String categoryId) =>
      _settingsBox.get('unlocked_$categoryId', defaultValue: false);

  Future<void> unlockCategory(String categoryId) =>
      _settingsBox.put('unlocked_$categoryId', true);

  // ---- Rewarded-ad letter-open gate ----
  /// Free letter-detail opens since the counter last reset. After 5 free
  /// opens, the 6th requires watching a rewarded ad (see
  /// LetterGridScreen), then the counter resets for another 5 free opens.
  int get letterOpenCount => _settingsBox.get('letterOpenCount', defaultValue: 0);

  Future<void> incrementLetterOpenCount() =>
      _settingsBox.put('letterOpenCount', letterOpenCount + 1);

  Future<void> resetLetterOpenCount() => _settingsBox.put('letterOpenCount', 0);
}
