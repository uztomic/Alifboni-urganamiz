class LetterModel {
  final String character;
  final String name;
  final String exampleWord;
  final String emoji;
  final String ttsLocale;

  const LetterModel({
    required this.character,
    required this.name,
    required this.exampleWord,
    required this.emoji,
    required this.ttsLocale,
  });

  String get id => character;
}
