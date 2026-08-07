enum NatureCategoryType { animals, plants, birds, vehicles, professions }

class NatureEntry {
  final String id;
  final NatureCategoryType category;

  /// English Wikipedia article title, used to look up a real photo via
  /// [WikipediaImageService]. Not shown to the user.
  final String wikipediaTitle;

  /// Shown while the real photo is loading, or if it fails (offline,
  /// article has no lead image, etc).
  final String emoji;

  final Map<String, String> names;
  final Map<String, String> descriptions;

  const NatureEntry({
    required this.id,
    required this.category,
    required this.wikipediaTitle,
    required this.emoji,
    required this.names,
    required this.descriptions,
  });

  String nameFor(String languageCode) =>
      names[languageCode] ?? names['en'] ?? names.values.first;

  String descriptionFor(String languageCode) =>
      descriptions[languageCode] ?? descriptions['en'] ?? descriptions.values.first;
}
