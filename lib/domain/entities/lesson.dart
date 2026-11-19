import 'package:flutter/material.dart';

import 'voice_lang.dart';

/// "Harflar vodiysi" — Ziyrak'dagi harf darslari asosida 12 ta dars.
/// Darslar qulflanmaydi, lekin tavsiya etilgan tartibda ko'rsatiladi.
enum LessonType {
  intro,
  find,
  vowels,
  consonants,
  bigSmall,
  order,
  firstLetter,
  syllables,
  buildWord,
  read,
  sentence,
  write,
}

class LessonDef {
  const LessonDef(this.type, this.titleKey, this.icon, this.color, this.uzIntro);
  final LessonType type;
  final String titleKey;
  final String icon;
  final Color color;

  /// Dars boshida o'qiladigan tushuntirish (o'zbek alifbolari uchun).
  final List<Line> Function() uzIntro;

  String get id => type.name;
}

/// "Gapni to'ldir" mashqlari (o'zbek tilida, hammasi ovozli).
class SentenceItem {
  const SentenceItem(this.prompt, this.answer, this.wrong, this.full);
  final Line prompt; // "Gapni toʻldir: Baliq ___ suzadi."
  final String answer;
  final List<String> wrong;
  final Line full; // "Baliq suvda suzadi."

  /// Ekranda ko'rsatiladigan gap ("Gapni toʻldir:" qismisiz).
  String get display => prompt.$1.replaceFirst('Gapni toʻldir: ', '');
}

