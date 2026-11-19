import '../../domain/repositories/progress_repository.dart';
import '../sources/local_storage.dart';

class LocalProgressRepository implements ProgressRepository {
  LocalProgressRepository(this._st);
  final Storage _st;

  @override
  Map<String, int> get lessonStars => _st.getIntMap('lessonStars');
  @override
  set lessonStars(Map<String, int> v) => _st.set('lessonStars', v);

  @override
  Map<String, int> get quizStars => _st.getIntMap('quizStars');
  @override
  set quizStars(Map<String, int> v) => _st.set('quizStars', v);

  @override
  Set<String> get seenLetters => _st.getStringSet('seenLetters');
  @override
  set seenLetters(Set<String> v) => _st.setStringSet('seenLetters', v);

  @override
  Set<String> get tracedLetters => _st.getStringSet('tracedLetters');
  @override
  set tracedLetters(Set<String> v) => _st.setStringSet('tracedLetters', v);

  @override
  int get gamesPlayed => _st.get<int>('gamesPlayed', 0);
  @override
  set gamesPlayed(int v) => _st.set('gamesPlayed', v);

  @override
  int get streakDays => _st.get<int>('streakDays', 0);
  @override
  set streakDays(int v) => _st.set('streakDays', v);

  @override
  String get lastActiveDay => _st.get<String>('lastActiveDay', '');
  @override
  set lastActiveDay(String v) => _st.set('lastActiveDay', v);

  @override
  int get talesListened => _st.get<int>('talesListened', 0);
  @override
  set talesListened(int v) => _st.set('talesListened', v);

  @override
  Future<void> clear() => _st.clearProgress();
}
