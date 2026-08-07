import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_page_route.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/rewarded_gate_sheet.dart';
import '../../../core/widgets/star_rating.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../bloc/alphabet_bloc.dart';
import '../bloc/alphabet_event.dart';
import '../bloc/alphabet_state.dart';
import '../data/models/alphabet_model.dart';
import 'alphabet_quiz_screen.dart';
import 'letter_detail_screen.dart';

/// After 5 free letter opens, the 6th requires a rewarded ad (see
/// StorageService.letterOpenCount / TZ-inspired monetization request).
Future<void> _openLetter(
  BuildContext context, {
  required AlphabetModel alphabet,
  required int letterIndex,
  required AlphabetBloc bloc,
}) async {
  final storage = StorageService.instance;
  if (storage.letterOpenCount >= 5) {
    final letter = alphabet.letters[letterIndex];
    final earned = await showRewardedGateSheet(context, emoji: letter.emoji);
    if (!earned) return;
    await storage.resetLetterOpenCount();
  }
  await storage.incrementLetterOpenCount();
  if (!context.mounted) return;
  pushAnimated(
    context,
    BlocProvider.value(
      value: bloc,
      child: LetterDetailScreen(alphabet: alphabet, letterIndex: letterIndex),
    ),
  );
}

class LetterGridScreen extends StatelessWidget {
  final AlphabetId alphabetId;
  const LetterGridScreen({super.key, required this.alphabetId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlphabetBloc()..add(LoadAlphabet(alphabetId)),
      child: const _LetterGridView(),
    );
  }
}

class _LetterGridView extends StatelessWidget {
  const _LetterGridView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<AlphabetBloc, AlphabetState>(
      builder: (context, state) {
        final alphabet = state.alphabet;
        if (alphabet == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('${alphabet.flagEmoji}  ${alphabet.selfName}'),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () =>
                pushAnimated(context, AlphabetQuizScreen(alphabet: alphabet)),
            backgroundColor: alphabet.color,
            icon: const Icon(Icons.quiz_rounded),
            label: Text(l10n.quizTitle),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: alphabet.letters.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final letter = alphabet.letters[index];
                final stars = state.stars[letter.character] ?? 0;
                return FadeSlideIn(
                  index: index > 14 ? 14 : index,
                  baseDelay: const Duration(milliseconds: 25),
                  child: _LetterTile(
                    character: letter.character,
                    stars: stars,
                    color: alphabet.color,
                    onTap: () => _openLetter(
                      context,
                      alphabet: alphabet,
                      letterIndex: index,
                      bloc: context.read<AlphabetBloc>(),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _LetterTile extends StatefulWidget {
  final String character;
  final int stars;
  final Color color;
  final VoidCallback onTap;

  const _LetterTile({
    required this.character,
    required this.stars,
    required this.color,
    required this.onTap,
  });

  @override
  State<_LetterTile> createState() => _LetterTileState();
}

class _LetterTileState extends State<_LetterTile> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.92),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 110),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            gradient: widget.stars > 0
                ? AppColors.gradientFor(widget.color)
                : LinearGradient(colors: [AppColors.surface, AppColors.surface]),
            borderRadius: BorderRadius.circular(20),
            border: widget.stars > 0
                ? null
                : Border.all(color: widget.color.withValues(alpha: 0.35), width: 2),
            boxShadow: [
              BoxShadow(
                color: widget.stars > 0
                    ? widget.color.withValues(alpha: 0.4)
                    : Colors.black12,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.character,
                style: GoogleFonts.baloo2(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: widget.stars > 0 ? Colors.white : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              StarRating(stars: widget.stars, size: 12),
            ],
          ),
        ),
      ),
    );
  }
}
