import 'package:flutter/material.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/widgets/app_page_route.dart';
import '../../../core/widgets/banner_ad_widget.dart';
import '../../../core/widgets/big_action_card.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../data/alphabet_data.dart';
import 'letter_grid_screen.dart';

class AlphabetSelectScreen extends StatelessWidget {
  const AlphabetSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.alphabetSelectTitle)),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                itemCount: kAllAlphabets.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  final alphabet = kAllAlphabets[index];
                  final learned = StorageService.instance.learnedCountForAlphabet(
                    alphabet.id.name,
                    alphabet.letters.map((l) => l.character).toList(),
                  );
                  return FadeSlideIn(
                    index: index,
                    baseDelay: const Duration(milliseconds: 60),
                    child: BigActionCard(
                      emoji: alphabet.flagEmoji,
                      title: alphabet.selfName,
                      subtitle: l10n.alphabetProgress(learned, alphabet.letters.length),
                      color: alphabet.color,
                      onTap: () =>
                          pushAnimated(context, LetterGridScreen(alphabetId: alphabet.id)),
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
