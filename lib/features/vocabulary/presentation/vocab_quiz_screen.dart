import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/celebration_burst.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../progress/bloc/progress_cubit.dart';
import '../data/models/category_model.dart';
import '../data/models/word_model.dart';

class VocabQuizScreen extends StatefulWidget {
  final CategoryModel category;
  final List<WordModel> words;
  const VocabQuizScreen({super.key, required this.category, required this.words});

  @override
  State<VocabQuizScreen> createState() => _VocabQuizScreenState();
}

class _Question {
  final WordModel answer;
  final List<WordModel> options;
  _Question({required this.answer, required this.options});
}

class _VocabQuizScreenState extends State<VocabQuizScreen> {
  static const _questionCount = 6;
  final _random = Random();
  late final List<_Question> _questions;
  int _index = 0;
  int _score = 0;
  String? _selectedId;
  bool? _correct;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _questions = _buildQuestions();
  }

  List<_Question> _buildQuestions() {
    final pool = List<WordModel>.from(widget.words)..shuffle(_random);
    final count = min(_questionCount, pool.length);
    return List.generate(count, (i) {
      final answer = pool[i];
      final distractors = (List<WordModel>.from(widget.words)
            ..remove(answer)
            ..shuffle(_random))
          .take(min(3, widget.words.length - 1))
          .toList();
      final options = [answer, ...distractors]..shuffle(_random);
      return _Question(answer: answer, options: options);
    });
  }

  void _select(WordModel option, String localeCode) {
    if (_selectedId != null) return;
    final q = _questions[_index];
    final correct = option.id == q.answer.id;
    setState(() {
      _selectedId = option.id;
      _correct = correct;
      if (correct) _score++;
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      if (_index + 1 < _questions.length) {
        setState(() {
          _index++;
          _selectedId = null;
          _correct = null;
        });
      } else {
        context.read<ProgressCubit>().recordPractice();
        setState(() => _finished = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;

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
              l10n.vocabQuizChooseWord,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            TweenAnimationBuilder<double>(
              key: ValueKey(q.answer.id),
              tween: Tween(begin: 0.3, end: 1.0),
              duration: const Duration(milliseconds: 450),
              curve: Curves.easeOutBack,
              builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
              child: q.answer.swatchColor != null
                  ? Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(color: q.answer.swatchColor, shape: BoxShape.circle),
                    )
                  : Text(q.answer.emoji, style: const TextStyle(fontSize: 90)),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2.2,
                children: q.options.asMap().entries.map((entry) {
                  final option = entry.value;
                  final isSelected = _selectedId == option.id;
                  Color color = widget.category.color;
                  if (isSelected) {
                    color = (_correct ?? false) ? AppColors.success : AppColors.error;
                  }
                  return FadeSlideIn(
                    index: entry.key,
                    baseDelay: const Duration(milliseconds: 60),
                    child: AnimatedScale(
                      scale: isSelected && (_correct ?? false) ? 1.06 : 1.0,
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
                            onTap: () => _select(option, localeCode),
                            child: Center(
                              child: Text(
                                option.translationFor(localeCode),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.baloo2(
                                  fontSize: 18,
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
