import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/widgets/app_page_route.dart';
import '../../../core/widgets/big_action_card.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/native_ad_card.dart';
import '../../../core/widgets/rewarded_gate_sheet.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/models/category_model.dart';
import '../data/vocabulary_data.dart';
import 'category_titles.dart';
import 'flashcard_screen.dart';

class CategorySelectScreen extends StatefulWidget {
  const CategorySelectScreen({super.key});

  @override
  State<CategorySelectScreen> createState() => _CategorySelectScreenState();
}

class _CategorySelectScreenState extends State<CategorySelectScreen> {
  Future<void> _handleTap(CategoryModel category) async {
    if (!category.available) return;

    if (category.requiresUnlock &&
        !StorageService.instance.isCategoryUnlocked(category.id.name)) {
      final earned = await showRewardedGateSheet(context, emoji: category.emoji);
      if (earned) {
        await StorageService.instance.unlockCategory(category.id.name);
        if (!mounted) return;
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.categoryUnlocked)),
        );
      }
      return;
    }

    if (!mounted) return;
    pushAnimated(context, FlashcardScreen(categoryId: category.id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.vocabularyCategoriesTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: kAllCategories.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            if (index == kAllCategories.length) {
              return const NativeAdCard();
            }
            final category = kAllCategories[index];
            final words = wordsForCategory(category.id);
            final unlocked = !category.requiresUnlock ||
                StorageService.instance.isCategoryUnlocked(category.id.name);
            final learned = StorageService.instance
                .learnedCountForCategory(words.map((w) => w.id).toList());
            final locked = !category.available || (category.requiresUnlock && !unlocked);

            return FadeSlideIn(
              index: index,
              baseDelay: const Duration(milliseconds: 55),
              child: BigActionCard(
                emoji: category.emoji,
                title: categoryTitle(l10n, category.id),
                subtitle: !category.available
                    ? null
                    : (unlocked ? '$learned/${words.length}' : null),
                color: category.color,
                locked: locked,
                onTap: category.available ? () => _handleTap(category) : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
