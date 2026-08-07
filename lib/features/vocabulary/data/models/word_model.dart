import 'package:flutter/material.dart';
import 'category_model.dart';

class WordModel {
  final String id;
  final VocabCategoryId category;
  final String emoji;
  final Color? swatchColor;

  /// Spelling of the word in a given learning alphabet, keyed by
  /// [AlphabetId.name] (e.g. "uzLatin", "english").
  final Map<String, String> spellings;

  /// Translation of the word, keyed by interface language code
  /// (e.g. "uz", "ru", "en").
  final Map<String, String> translations;

  const WordModel({
    required this.id,
    required this.category,
    required this.emoji,
    this.swatchColor,
    required this.spellings,
    required this.translations,
  });

  String spellingFor(String alphabetKey) =>
      spellings[alphabetKey] ?? spellings.values.first;

  String translationFor(String languageCode) =>
      translations[languageCode] ?? translations['en'] ?? translations.values.first;
}
