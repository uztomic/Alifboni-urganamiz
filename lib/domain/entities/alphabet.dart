import 'package:flutter/material.dart';

import 'voice_lang.dart';

/// O'rganiladigan alifbolar.
enum ScriptId { uzLatin, uzNew, uzCyrl, ru, en }

extension ScriptIdX on ScriptId {
  bool get isUzbek =>
      this == ScriptId.uzLatin || this == ScriptId.uzNew || this == ScriptId.uzCyrl;

  static ScriptId fromName(String? n) => ScriptId.values
      .firstWhere((s) => s.name == n, orElse: () => ScriptId.uzLatin);
}

enum LetterKind { vowel, consonant, sign, digraph }

/// Rasmli so'z. [text] — ko'rsatiladigan yozuv, [say] — ovoz kaliti
/// (o'zbekcha so'zlar uchun har doim joriy lotin yozuvida).
class Word {
  const Word(this.text, this.emoji, {required this.say, required this.lang, this.syllables});
  final String text;
  final String emoji;
  final String say;
  final VoiceLang lang;

  /// Bo'g'inlarga ajratilgan ko'rinishi (masalan "ol-ma"), bo'lsa.
  final String? syllables;
}

class Letter {
  const Letter({
    required this.upper,
    required this.lower,
    required this.say,
    required this.sayLang,
    required this.kind,
    required this.words,
    this.uzKey,
  });

  final String upper;
  final String lower;

  /// Harf nomini o'qish uchun matn (ovoz kaliti).
  final String say;
  final VoiceLang sayLang;
  final LetterKind kind;
  final List<Word> words;

  /// O'zbek alifbolarida — harfning joriy lotindagi ko'rinishi ("Oʻ", "Sh").
  /// Ovozli savol shablonlari shu kalit bilan quriladi.
  final String? uzKey;

  String get pair => upper == lower ? upper : '$upper$lower';
  bool get isVowel => kind == LetterKind.vowel;
  bool get isConsonant => kind == LetterKind.consonant;
  bool get isLetter => kind == LetterKind.vowel || kind == LetterKind.consonant;
  Word? get mainWord => words.isEmpty ? null : words.first;
}

class Alphabet {
  const Alphabet({
    required this.id,
    required this.titleKey,
    required this.shortKey,
    required this.badge,
    required this.color,
    required this.voiceLang,
    required this.letters,
  });

  final ScriptId id;
  final String titleKey;
  final String shortKey;
  final String badge;
  final Color color;

  /// Savollar qaysi tilda ovozlanadi.
  final VoiceLang voiceLang;
  final List<Letter> letters;

  /// Darslar va o'yinlar uchun faqat haqiqiy harflar (belgilarsiz).
  List<Letter> get realLetters => letters.where((l) => l.isLetter).toList();
  List<Letter> get vowels => letters.where((l) => l.isVowel).toList();
  List<Letter> get consonants => letters.where((l) => l.isConsonant).toList();
}
