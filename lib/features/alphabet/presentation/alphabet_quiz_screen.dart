import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/celebration_burst.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../progress/bloc/progress_cubit.dart';
import '../data/models/alphabet_model.dart';
import '../data/models/letter_model.dart';

class AlphabetQuizScreen extends StatefulWidget {
  final AlphabetModel alphabet;
  const AlphabetQuizScreen({super.key, required this.alphabet});

  @override
  State<AlphabetQuizScreen> createState() => _AlphabetQuizScreenState();
}

class _QuizQuestion {
  final LetterModel answer;
  final List<LetterModel> options;
  _QuizQuestion({required this.answer, required this.options});
}

class _AlphabetQuizScreenState extends State<AlphabetQuizScreen> {
  static const _questionCount = 8;
  final _random = Random();
  late final List<_QuizQuestion> _questions;
  int _index = 0;
  int _score = 0;
  bool? _correctSelected;
  String? _selectedChar;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _questions = _buildQuestions();
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakCurrent());
  }

  List<_QuizQuestion> _buildQuestions() {
    final letters = List<LetterModel>.from(widget.alphabet.letters)..shuffle(_random);
    final count = min(_questionCount, letters.length);
    return List.generate(count, (i) {
      final answer = letters[i];
      final distractors = (List<LetterModel>.from(widget.alphabet.letters)
            ..remove(answer)
            ..shuffle(_random))
          .take(3)
          .toList();
      final options = [answer, ...distractors]..shuffle(_random);
      return _QuizQuestion(answer: answer, options: options);
    });
  }

  void _speakCurrent() {
    final q = _questions[_index];
    TtsService.instance.speak(q.answer.character, locale: q.answer.ttsLocale);
  }

  void _select(LetterModel option) {
    if (_selectedChar != null) return;
    final q = _questions[_index];
    final correct = option.character == q.answer.character;
    setState(() {
      _selectedChar = option.character;
      _correctSelected = correct;
      if (correct) _score++;
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      if (_index + 1 < _questions.length) {
        setState(() {
          _index++;
          _selectedChar = null;
          _correctSelected = null;
        });
        _speakCurrent();
      } else {
        context.read<ProgressCubit>().recordPractice();
        setState(() => _finished = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_finished) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.quizTitle)),
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.3, end: 1.0),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutBack,
                    builder: (context, scale, child) =>
                        Transform.scale(scale: scale, child: child),
                    child: const Text('🎉', style: TextStyle(fontSize: 64)),
                  ),
                  const SizedBox(height: 12),
                  FadeSlideIn(
                    child: Text(l10n.quizFinished,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                  ),
                  const SizedBox(height: 8),
                  FadeSlideIn(
                    baseDelay: const Duration(milliseconds: 100),
                    child: Text(l10n.quizScore(_score, _questions.length),
                        style: const TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.commonClose),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: CelebrationBurst(play: true),
            ),
          ],
        ),
      );
    }

    final q = _questions[_index];
    return Scaffold(
      appBar: AppBar(title: Text('${l10n.quizTitle} (${_index + 1}/${_questions.length})')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              l10n.quizQuestionLetter,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            IconButton(
              iconSize: 48,
              icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary),
              onPressed: _speakCurrent,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.3,
                children: q.options.asMap().entries.map((entry) {
                  final option = entry.value;
                  final isSelected = _selectedChar == option.character;
                  Color color = widget.alphabet.color;
                  if (isSelected) {
                    color = (_correctSelected ?? false) ? AppColors.success : AppColors.error;
                  }
                  return FadeSlideIn(
                    index: entry.key,
                    baseDelay: const Duration(milliseconds: 60),
                    child: AnimatedScale(
                      scale: isSelected && (_correctSelected ?? false) ? 1.06 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        decoration: BoxDecoration(
                          gradient: AppColors.gradientFor(color),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
                          boxShadow: [
                            BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 5)),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => _select(option),
                            child: Center(
                              child: Text(
                                option.character,
                                style: GoogleFonts.baloo2(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
