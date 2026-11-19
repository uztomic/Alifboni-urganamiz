import 'lessons.dart';
import 'quizzes.dart';
import 'words.dart';

final Map<String, String> _vocabEmoji = {
  for (final c in vocabulary)
    for (final w in c.words)
      if (w.emoji.isNotEmpty) w.uz: w.emoji,
};

/// O'zbekcha so'z uchun rasm (emoji kaliti) — bo'lmasa bo'sh satr.
String emojiForWord(String uzWord) =>
    sentenceEmoji[uzWord] ?? quizEmoji[uzWord] ?? _vocabEmoji[uzWord] ?? '';
