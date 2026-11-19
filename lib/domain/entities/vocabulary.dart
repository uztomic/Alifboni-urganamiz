import 'package:flutter/material.dart';

/// Lug'at so'zi: o'zbekcha (lotin), ruscha va inglizcha tarjimasi bilan.
/// Rasm — emoji yoki rang namunasi ([swatch]).
class VocabWord {
  const VocabWord(this.uz, this.ru, this.en, this.emoji, {this.swatch});
  final String uz;
  final String ru;
  final String en;
  final String emoji;
  final Color? swatch;
}

class VocabCategory {
  const VocabCategory(this.id, this.icon, this.color, this.words);
  final String id; // 'c_animals' — matn kaliti ham shu
  final String icon; // assets/images/icons/<icon>.png
  final Color color;
  final List<VocabWord> words;
}

