import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/banner_ad_view.dart';
import '../../widgets/basics.dart';
import '../../../data/content/alphabets.dart';
import '../../../domain/entities/alphabet.dart';
import '../../bloc/progress_cubit.dart';
import '../../bloc/settings_cubit.dart';
import 'letter_screen.dart';

/// Alifbo taxtasi: tanlangan alifboning barcha harflari.
class AlphabetScreen extends StatelessWidget {
  const AlphabetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final scriptId = context.watch<SettingsCubit>().state.script;
    final a = alphabetOf(scriptId);
    final progress = context.watch<ProgressCubit>().state;

    return Scaffold(
      body: SoftBackground(
        accent: a.color,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              ScreenHeader(title: s.t('secAlphabet')),
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    for (final alpha in allAlphabets)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _ScriptChip(
                          label: s.t(alpha.shortKey),
                          badge: alpha.badge,
                          color: alpha.color,
                          selected: alpha.id == scriptId,
                          onTap: () => context.read<SettingsCubit>().setScript(alpha.id),
                        ),
                      ),
                  ],
                ),
              ),
              if (a.id == ScriptId.uzNew)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.tint(a.color, 0.85),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_rounded, color: a.color),
                        const SizedBox(width: 8),
                        Expanded(child: Text(s.t('newAlphabetNote'), style: const TextStyle(fontSize: 13.5))),
                      ],
                    ),
                  ),
                ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 96,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: a.letters.length,
                  itemBuilder: (context, i) {
                    final l = a.letters[i];
                    return LetterTile(
                      letter: l,
                      color: a.color,
                      learned: progress.isLearned(a.id, l.upper),
                      onTap: () => go<void>(context, LetterScreen(alphabet: a, initialIndex: i)),
                    );
                  },
                ),
              ),
              const BannerAdView(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScriptChip extends StatelessWidget {
  const _ScriptChip({required this.label, required this.badge, required this.color, required this.selected, required this.onTap});
  final String label, badge;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Bouncy(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.fromLTRB(6, 6, 14, 6),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: selected ? color : AppColors.line, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: selected ? Colors.white : AppColors.tint(color, 0.8),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(badge,
                  style: TextStyle(fontFamily: AppFonts.letters, fontSize: 14, fontWeight: FontWeight.w700, color: color)),
            ),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: selected ? Colors.white : AppColors.ink)),
          ],
        ),
      ),
    );
  }
}

/// Alifbo taxtasidagi bitta harf.
class LetterTile extends StatelessWidget {
  const LetterTile({super.key, required this.letter, required this.color, required this.learned, required this.onTap});
  final Letter letter;
  final Color color;
  final bool learned;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final vowel = letter.isVowel;
    final base = vowel ? AppColors.coral : color;
    final isSign = letter.kind == LetterKind.sign || letter.kind == LetterKind.digraph;
    return Bouncy(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isSign ? const Color(0xFFF3EEE6) : Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.tint(base, 0.6), width: 2),
              boxShadow: [BoxShadow(color: AppColors.tint(base, 0.5), offset: const Offset(0, 4))],
            ),
            alignment: Alignment.center,
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  letter.upper == letter.lower ? letter.upper : '${letter.upper}${letter.lower}',
                  style: TextStyle(
                    fontFamily: AppFonts.letters,
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: AppColors.shade(base, 0.15),
                  ),
                ),
              ),
            ),
          ),
          if (learned)
            const Positioned(
              right: -4,
              top: -4,
              child: CircleAvatar(
                radius: 11,
                backgroundColor: AppColors.leaf,
                child: Icon(Icons.check_rounded, size: 15, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
