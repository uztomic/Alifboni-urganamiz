import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_page_route.dart';
import '../../../core/widgets/banner_ad_widget.dart';
import '../../../core/widgets/big_action_card.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/models/nature_entry.dart';
import 'nature_list_screen.dart';

class NatureCategoryScreen extends StatelessWidget {
  const NatureCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final categories = [
      (NatureCategoryType.animals, '🦁', l10n.natureAnimals, AppColors.green),
      (NatureCategoryType.plants, '🌻', l10n.naturePlants, AppColors.secondary),
      (NatureCategoryType.birds, '🦜', l10n.natureBirds, AppColors.pink),
      (NatureCategoryType.vehicles, '🚗', l10n.natureVehicles, AppColors.blue),
      (NatureCategoryType.professions, '👩‍🏫', l10n.natureProfessions, AppColors.primary),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.natureCategoryTitle)),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  final (type, emoji, title, color) = categories[index];
                  return FadeSlideIn(
                    index: index,
                    baseDelay: const Duration(milliseconds: 55),
                    child: BigActionCard(
                      emoji: emoji,
                      title: title,
                      color: color,
                      onTap: () => pushAnimated(context, NatureListScreen(category: type)),
                    ),
                  );
                },
              ),
            ),
          ),
          const BannerAdWidget(),
        ],
      ),
    );
  }
}
