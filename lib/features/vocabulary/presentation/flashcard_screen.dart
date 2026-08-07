import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_page_route.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../alphabet/data/alphabet_data.dart';
import '../../alphabet/data/models/alphabet_model.dart';
import '../../progress/bloc/progress_cubit.dart';
import '../bloc/vocabulary_bloc.dart';
import '../bloc/vocabulary_event.dart';
import '../bloc/vocabulary_state.dart';
import '../data/models/category_model.dart';
import '../data/models/word_model.dart';
import 'category_titles.dart';
import 'vocab_quiz_screen.dart';
import 'write_practice_screen.dart';

/// Alphabets with real per-word spellings authored in vocabulary_data.dart.
/// Other alphabets can be added later by extending WordModel.spellings.
const _spellingAlphabets = [AlphabetId.uzLatin, AlphabetId.english];

class FlashcardScreen extends StatelessWidget {
  final VocabCategoryId categoryId;
  const FlashcardScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VocabularyBloc()..add(LoadCategory(categoryId)),
      child: const _FlashcardView(),
    );
  }
}

class _FlashcardView extends StatefulWidget {
  const _FlashcardView();

  @override
  State<_FlashcardView> createState() => _FlashcardViewState();
}

class _FlashcardViewState extends State<_FlashcardView> {
  final _pageController = PageController();
  AlphabetId _alphabetId = AlphabetId.uzLatin;
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _speak(WordModel word) {
    final alphabet = alphabetById(_alphabetId);
    final locale = alphabet.letters.first.ttsLocale;
    TtsService.instance.speak(word.spellingFor(_alphabetId.name), locale: locale);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return BlocBuilder<VocabularyBloc, VocabularyState>(
      builder: (context, state) {
        final words = state.words;
        if (state.category == null || words.isEmpty) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(categoryTitle(l10n, state.category!.id)),
            actions: [
              IconButton(
                icon: const Icon(Icons.quiz_rounded),
                onPressed: () => pushAnimated(
                  context,
                  BlocProvider.value(
                    value: context.read<VocabularyBloc>(),
                    child: VocabQuizScreen(category: state.category!, words: words),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Wrap(
                  spacing: 8,
                  children: _spellingAlphabets.map((id) {
                    final alphabet = alphabetById(id);
                    final selected = id == _alphabetId;
                    return ChoiceChip(
                      label: Text(
                        '${alphabet.flagEmoji} ${alphabet.selfName}',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w700,
                          color: selected ? Colors.white : AppColors.textDark,
                        ),
                      ),
                      selected: selected,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      onSelected: (_) => setState(() => _alphabetId = id),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: words.length,
                  onPageChanged: (i) {
                    setState(() => _currentIndex = i);
                    _speak(words[i]);
                    context.read<VocabularyBloc>().add(MarkWordPracticed(words[i].id));
                    context.read<ProgressCubit>().recordPractice();
                  },
                  itemBuilder: (context, i) {
                    final word = words[i];
                    return FadeSlideIn(
                      key: ValueKey(word.id),
                      child: _FlashcardCard(
                        word: word,
                        color: state.category!.color,
                        alphabetId: _alphabetId,
                        localeCode: locale,
                        onListen: () => _speak(word),
                        onWrite: () => pushAnimated(
                          context,
                          WritePracticeScreen(text: word.spellingFor(_alphabetId.name)),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  '${_currentIndex + 1} / ${words.length}',
                  style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black45),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FlashcardCard extends StatelessWidget {
  final WordModel word;
  final Color color;
  final AlphabetId alphabetId;
  final String localeCode;
  final VoidCallback onListen;
  final VoidCallback onWrite;

  const _FlashcardCard({
    required this.word,
    required this.color,
    required this.alphabetId,
    required this.localeCode,
    required this.onListen,
    required this.onWrite,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36),
            decoration: BoxDecoration(
              gradient: AppColors.gradientFor(color),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                TweenAnimationBuilder<double>(
                  key: ValueKey(word.id),
                  tween: Tween(begin: 0.3, end: 1.0),
                  duration: const Duration(milliseconds: 450),
                  curve: Curves.easeOutBack,
                  builder: (context, scale, child) =>
                      Transform.scale(scale: scale, child: child),
                  child: word.swatchColor != null
                      ? Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: word.swatchColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                        )
                      : Text(word.emoji, style: const TextStyle(fontSize: 90)),
                ),
                const SizedBox(height: 20),
                Text(
                  word.spellingFor(alphabetId.name),
                  style: GoogleFonts.baloo2(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  word.translationFor(localeCode),
                  style: GoogleFonts.nunito(fontSize: 18, color: Colors.white70, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: onListen,
                icon: const Icon(Icons.volume_up_rounded),
                label: Text(l10n.flashcardListen),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                onPressed: onWrite,
                icon: const Icon(Icons.edit_rounded),
                label: Text(l10n.flashcardWritePractice),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
