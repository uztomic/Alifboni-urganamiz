import '../../../l10n/generated/app_localizations.dart';
import '../data/models/category_model.dart';

String categoryTitle(AppLocalizations l10n, VocabCategoryId id) {
  switch (id) {
    case VocabCategoryId.animals:
      return l10n.categoryAnimals;
    case VocabCategoryId.colors:
      return l10n.categoryColors;
    case VocabCategoryId.numbers:
      return l10n.categoryNumbers;
    case VocabCategoryId.family:
      return l10n.categoryFamily;
    case VocabCategoryId.food:
      return l10n.categoryFood;
    case VocabCategoryId.clothes:
      return l10n.categoryClothes;
    case VocabCategoryId.transport:
      return l10n.categoryTransport;
    case VocabCategoryId.nature:
      return l10n.categoryNature;
  }
}
