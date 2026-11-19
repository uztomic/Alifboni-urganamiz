import 'dart:math';

import '../../core/l10n/strings.dart';
import '../../core/voice_lines.dart';
import '../entities/quiz.dart';
import 'lesson_engine.dart';

/// "Bilimdon" mavzusidan 8 ta tanlov savoli tuzadi.
List<Question> buildQuiz(
  QuizTopic topic, {
  required S s,
  required String Function(String word) emojiFor,
  int count = 8,
  Random? random,
}) {
  final r = random ?? Random();
  final items = [...topic.items]..shuffle(r);
  return [
    for (final it in items.take(count))
      () {
        final opts = [it.answer, ...it.wrong]..shuffle(r);
        return ChoiceQuestion(
          text: s.uzText(it.question),
          voice: [uz(it.question)],
          style: OptionStyle.word,
          correct: opts.indexOf(it.answer),
          onCorrect: uz(it.answer),
          options: [
            for (final o in opts) Option(label: s.uzText(o), emoji: emojiFor(o), say: uz(o)),
          ],
        );
      }(),
  ];
}
