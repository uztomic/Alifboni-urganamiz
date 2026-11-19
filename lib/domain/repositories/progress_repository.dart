/// Natijalarni saqlash shartnomasi.
abstract interface class ProgressRepository {
  Map<String, int> get lessonStars;
  set lessonStars(Map<String, int> v);
  Map<String, int> get quizStars;
  set quizStars(Map<String, int> v);
  Set<String> get seenLetters;
  set seenLetters(Set<String> v);
  Set<String> get tracedLetters;
  set tracedLetters(Set<String> v);
  int get gamesPlayed;
  set gamesPlayed(int v);
  int get streakDays;
  set streakDays(int v);
  String get lastActiveDay;
  set lastActiveDay(String v);
  int get talesListened;
  set talesListened(int v);
  Future<void> clear();
}
