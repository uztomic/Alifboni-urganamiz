import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/services/lesson_engine.dart';

enum LessonPhase { intro, playing, finished }

class LessonState extends Equatable {
  const LessonState({
    required this.questions,
    this.phase = LessonPhase.intro,
    this.index = 0,
    this.firstTryCorrect = 0,
    this.mistakesHere = 0,
    this.wrongPicks = const {},
    this.solved = false,
    this.solvedIndex,
  });

  final List<Question> questions;
  final LessonPhase phase;
  final int index;
  final int firstTryCorrect;

  /// Joriy savoldagi xatolar soni.
  final int mistakesHere;

  /// Joriy savolda noto'g'ri tanlangan variantlar (qizil bo'lib qoladi).
  final Set<int> wrongPicks;

  /// Joriy savol yechildimi (keyingisiga o'tishni kutyapti).
  final bool solved;
  final int? solvedIndex;

  Question get current => questions[index];
  int get total => questions.length;
  double get progress => total == 0 ? 0 : (index + (solved ? 1 : 0)) / total;

  /// 0..3 yulduz: deyarli hammasi birinchi urinishda to'g'ri — 3.
  int get stars {
    if (total == 0) return 0;
    final ratio = firstTryCorrect / total;
    if (ratio >= 0.85) return 3;
    if (ratio >= 0.6) return 2;
    return 1;
  }

  LessonState copyWith({
    LessonPhase? phase,
    int? index,
    int? firstTryCorrect,
    int? mistakesHere,
    Set<int>? wrongPicks,
    bool? solved,
    int? Function()? solvedIndex,
  }) =>
      LessonState(
        questions: questions,
        phase: phase ?? this.phase,
        index: index ?? this.index,
        firstTryCorrect: firstTryCorrect ?? this.firstTryCorrect,
        mistakesHere: mistakesHere ?? this.mistakesHere,
        wrongPicks: wrongPicks ?? this.wrongPicks,
        solved: solved ?? this.solved,
        solvedIndex: solvedIndex != null ? solvedIndex() : this.solvedIndex,
      );

  @override
  List<Object?> get props => [questions, phase, index, firstTryCorrect, mistakesHere, wrongPicks, solved, solvedIndex];
}

/// Dars (yoki Bilimdon testi) jarayonini boshqaradi. Ekran faqat holatni
/// chizadi va hodisalarni yuboradi — mantiq shu yerda.
class LessonCubit extends Cubit<LessonState> {
  LessonCubit(List<Question> questions, {bool skipIntro = false})
      : super(LessonState(
          questions: questions,
          phase: skipIntro ? LessonPhase.playing : LessonPhase.intro,
        ));

  void start() => emit(state.copyWith(phase: LessonPhase.playing));

  /// Tanlov savoliga javob. To'g'ri bo'lsa `true` qaytaradi.
  bool choose(int option) {
    final q = state.current;
    if (state.solved || q is! ChoiceQuestion) return false;
    if (option == q.correct) {
      _solve(option);
      return true;
    }
    if (state.wrongPicks.contains(option)) return false;
    emit(state.copyWith(
      mistakesHere: state.mistakesHere + 1,
      wrongPicks: {...state.wrongPicks, option},
    ));
    return false;
  }

  /// Yig'ish/yozish/tanishuv savollari uchun: savol yechildi.
  void complete({int mistakes = 0}) {
    if (state.solved) return;
    if (mistakes > 0) emit(state.copyWith(mistakesHere: state.mistakesHere + mistakes));
    _solve(null);
  }

  /// Yig'ish savolida xato bo'lak bosilganda.
  void mistake() => emit(state.copyWith(mistakesHere: state.mistakesHere + 1));

  void _solve(int? option) {
    emit(state.copyWith(
      solved: true,
      solvedIndex: () => option,
      firstTryCorrect: state.firstTryCorrect + (state.mistakesHere == 0 ? 1 : 0),
    ));
  }

  /// Keyingi savolga o'tadi; oxirgisi bo'lsa — yakunlaydi.
  void next() {
    if (!state.solved) return;
    if (state.index >= state.total - 1) {
      emit(state.copyWith(phase: LessonPhase.finished));
      return;
    }
    emit(state.copyWith(
      index: state.index + 1,
      mistakesHere: 0,
      wrongPicks: const {},
      solved: false,
      solvedIndex: () => null,
    ));
  }
}
