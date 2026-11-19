import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/progress_repository.dart';
import '../../domain/entities/alphabet.dart';

class ProgressState extends Equatable {
  const ProgressState({
    required this.lessonStars,
    required this.quizStars,
    required this.seenLetters,
    required this.tracedLetters,
    required this.gamesPlayed,
    required this.streak,
    this.talesListened = 0,
  });

  /// "uzLatin:find" → 0..3
  final Map<String, int> lessonStars;

  /// "z_professions" → 0..3
  final Map<String, int> quizStars;

  /// "uzLatin:Sh" — bolaga ko'rsatilgan/eshittirilgan harflar.
  final Set<String> seenLetters;

  /// "uzLatin:Sh" — chizib yozilgan harflar.
  final Set<String> tracedLetters;
  final int gamesPlayed;
  final int streak;
  final int talesListened;

  /// Tugatilgan barcha faoliyatlar (dars, test, o'yin, ertak).
  int get activities =>
      lessonStars.values.where((v) => v > 0).length + quizStars.length + gamesPlayed + talesListened;

  int starsFor(ScriptId s, String lessonId) => lessonStars['${s.name}:$lessonId'] ?? 0;

  int get totalStars =>
      lessonStars.values.fold(0, (a, b) => a + b) + quizStars.values.fold(0, (a, b) => a + b);

  int lessonsDone(ScriptId s) =>
      lessonStars.entries.where((e) => e.key.startsWith('${s.name}:') && e.value > 0).length;

  int get lessonsDoneAll => lessonStars.values.where((v) => v > 0).length;

  int learnedCount(ScriptId s) =>
      {...seenLetters, ...tracedLetters}.where((k) => k.startsWith('${s.name}:')).length;

  bool isLearned(ScriptId s, String upper) =>
      seenLetters.contains('${s.name}:$upper') || tracedLetters.contains('${s.name}:$upper');

  bool isTraced(ScriptId s, String upper) => tracedLetters.contains('${s.name}:$upper');

  @override
  List<Object?> get props => [lessonStars, quizStars, seenLetters, tracedLetters, gamesPlayed, streak, talesListened];
}

class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit(this._repo) : super(_load(_repo)) {
    _touchStreak();
  }

  final ProgressRepository _repo;

  static ProgressState _load(ProgressRepository r) => ProgressState(
        lessonStars: r.lessonStars,
        quizStars: r.quizStars,
        seenLetters: r.seenLetters,
        tracedLetters: r.tracedLetters,
        gamesPlayed: r.gamesPlayed,
        streak: r.streakDays,
        talesListened: r.talesListened,
      );

  static String _day(DateTime d) => '${d.year}-${d.month}-${d.day}';

  /// Har kuni birinchi ochilganda ketma-ket kunlar sonini yangilaydi.
  void _touchStreak() {
    final today = _day(DateTime.now());
    final last = _repo.lastActiveDay;
    if (last == today) return;
    final yesterday = _day(DateTime.now().subtract(const Duration(days: 1)));
    final streak = last == yesterday ? state.streak + 1 : 1;
    _repo.lastActiveDay = today;
    _repo.streakDays = streak;
    emit(_copy(streak: streak));
  }

  ProgressState _copy({
    Map<String, int>? lessonStars,
    Map<String, int>? quizStars,
    Set<String>? seenLetters,
    Set<String>? tracedLetters,
    int? gamesPlayed,
    int? streak,
    int? talesListened,
  }) =>
      ProgressState(
        lessonStars: lessonStars ?? state.lessonStars,
        quizStars: quizStars ?? state.quizStars,
        seenLetters: seenLetters ?? state.seenLetters,
        tracedLetters: tracedLetters ?? state.tracedLetters,
        gamesPlayed: gamesPlayed ?? state.gamesPlayed,
        streak: streak ?? state.streak,
        talesListened: talesListened ?? state.talesListened,
      );

  void markSeen(ScriptId s, String upper) {
    final key = '${s.name}:$upper';
    if (state.seenLetters.contains(key)) return;
    final next = {...state.seenLetters, key};
    _repo.seenLetters = next;
    emit(_copy(seenLetters: next));
  }

  void markTraced(ScriptId s, String upper) {
    final key = '${s.name}:$upper';
    if (state.tracedLetters.contains(key)) return;
    final next = {...state.tracedLetters, key};
    _repo.tracedLetters = next;
    emit(_copy(tracedLetters: next));
  }

  /// Faqat yaxshiroq natija saqlanadi.
  void saveLesson(ScriptId s, String lessonId, int stars) {
    final key = '${s.name}:$lessonId';
    if ((state.lessonStars[key] ?? 0) >= stars) return;
    final next = {...state.lessonStars, key: stars};
    _repo.lessonStars = next;
    emit(_copy(lessonStars: next));
  }

  void saveQuiz(String topicId, int stars) {
    if ((state.quizStars[topicId] ?? 0) >= stars) return;
    final next = {...state.quizStars, topicId: stars};
    _repo.quizStars = next;
    emit(_copy(quizStars: next));
  }

  void gamePlayed() {
    final n = state.gamesPlayed + 1;
    _repo.gamesPlayed = n;
    emit(_copy(gamesPlayed: n));
  }

  void taleListened() {
    final n = state.talesListened + 1;
    _repo.talesListened = n;
    emit(_copy(talesListened: n));
  }

  Future<void> reset() async {
    await _repo.clear();
    _repo.lastActiveDay = _day(DateTime.now());
    _repo.streakDays = 1;
    emit(const ProgressState(
      lessonStars: {},
      quizStars: {},
      seenLetters: {},
      tracedLetters: {},
      gamesPlayed: 0,
      streak: 1,
    ));
  }
}
