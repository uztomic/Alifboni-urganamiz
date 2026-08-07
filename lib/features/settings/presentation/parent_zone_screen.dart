import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../alphabet/data/alphabet_data.dart';
import '../../vocabulary/data/vocabulary_data.dart';
import '../../vocabulary/presentation/category_titles.dart';
import '../bloc/settings_cubit.dart';
import 'pin_dialog.dart';

class ParentZoneScreen extends StatelessWidget {
  const ParentZoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    var rowIndex = 0;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.parentZoneProgressTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l10n.homeAlphabetModule,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          ...kAllAlphabets.map((alphabet) {
            final learned = StorageService.instance.learnedCountForAlphabet(
              alphabet.id.name,
              alphabet.letters.map((l) => l.character).toList(),
            );
            return FadeSlideIn(
              index: rowIndex++,
              baseDelay: const Duration(milliseconds: 35),
              child: _ProgressRow(
                emoji: alphabet.flagEmoji,
                label: alphabet.selfName,
                text: l10n.parentZoneStatsAlphabet(learned, alphabet.letters.length),
                ratio: alphabet.letters.isEmpty ? 0 : learned / alphabet.letters.length,
                color: alphabet.color,
              ),
            );
          }),
          const SizedBox(height: 24),
          Text(l10n.homeVocabularyModule,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          ...kAllCategories.where((c) => c.available).map((category) {
            final words = wordsForCategory(category.id);
            final learned = StorageService.instance
                .learnedCountForCategory(words.map((w) => w.id).toList());
            return FadeSlideIn(
              index: rowIndex++,
              baseDelay: const Duration(milliseconds: 35),
              child: _ProgressRow(
                emoji: category.emoji,
                label: categoryTitle(l10n, category.id),
                text: l10n.parentZoneStatsVocabulary(learned, words.length),
                ratio: words.isEmpty ? 0 : learned / words.length,
                color: category.color,
              ),
            );
          }),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            icon: const Icon(Icons.lock_reset_rounded),
            label: Text(l10n.parentZoneSetPin),
            onPressed: () async {
              final pin = await showPinDialog(context, title: l10n.parentZoneSetPin, confirm: true);
              if (pin != null && context.mounted) {
                await context.read<SettingsCubit>().setParentPin(pin);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String emoji;
  final String label;
  final String text;
  final double ratio;
  final Color color;

  const _ProgressRow({
    required this.emoji,
    required this.label,
    required this.text,
    required this.ratio,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: ratio.clamp(0, 1)),
                    duration: const Duration(milliseconds: 700),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, _) => LinearProgressIndicator(
                      value: value,
                      minHeight: 8,
                      backgroundColor: AppColors.background,
                      valueColor: AlwaysStoppedAnimation(color),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }
}
