import 'package:hive_flutter/hive_flutter.dart';

/// Barcha ma'lumotlar bitta Hive qutisida, oddiy kalit-qiymat ko'rinishida
/// saqlanadi. Internet va hisob kerak emas.
class Storage {
  Storage._();
  static final Storage instance = Storage._();

  late Box<dynamic> _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<dynamic>('alifbo_v2');
  }

  T get<T>(String key, T fallback) {
    final v = _box.get(key);
    return v is T ? v : fallback;
  }

  Future<void> set(String key, Object? value) => _box.put(key, value);

  Map<String, int> getIntMap(String key) {
    final raw = _box.get(key);
    if (raw is Map) {
      return {
        for (final e in raw.entries)
          if (e.value is int) '${e.key}': e.value as int,
      };
    }
    return {};
  }

  Set<String> getStringSet(String key) {
    final raw = _box.get(key);
    if (raw is List) return raw.map((e) => '$e').toSet();
    return {};
  }

  Future<void> setStringSet(String key, Set<String> value) =>
      _box.put(key, value.toList());

  Future<void> clearProgress() async {
    for (final k in const [
      'lessonStars',
      'seenLetters',
      'tracedLetters',
      'gamesPlayed',
      'streakDays',
      'lastActiveDay',
      'quizStars',
      'talesListened',
    ]) {
      await _box.delete(k);
    }
  }
}
