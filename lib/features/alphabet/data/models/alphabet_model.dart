import 'package:flutter/material.dart';
import 'letter_model.dart';

enum AlphabetId { uzLatin, korean, russian, english, arabic, turkish }

class AlphabetModel {
  final AlphabetId id;
  final String selfName;
  final String flagEmoji;
  final Color color;
  final List<LetterModel> letters;

  const AlphabetModel({
    required this.id,
    required this.selfName,
    required this.flagEmoji,
    required this.color,
    required this.letters,
  });
}
