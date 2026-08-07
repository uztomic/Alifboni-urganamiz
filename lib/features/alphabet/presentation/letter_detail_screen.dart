import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/celebration_burst.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../core/widgets/trace_canvas.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../progress/bloc/progress_cubit.dart';
import '../bloc/alphabet_bloc.dart';
import '../bloc/alphabet_event.dart';
import '../data/models/alphabet_model.dart';
import '../data/models/letter_model.dart';

class LetterDetailScreen extends StatefulWidget {
  final AlphabetModel alphabet;
  final int letterIndex;

  const LetterDetailScreen({
    super.key,
    required this.alphabet,
    required this.letterIndex,
  });

  @override
  State<LetterDetailScreen> createState() => _LetterDetailScreenState();
}

class _LetterDetailScreenState extends State<LetterDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _celebrate = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakLetter());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _speakLetter() {
    final letter = widget.alphabet.letters[widget.letterIndex];
    TtsService.instance.speak(letter.character, locale: letter.ttsLocale);
  }

  void _onTraceSuccess() {
    final letter = widget.alphabet.letters[widget.letterIndex];
    context.read<AlphabetBloc>().add(MarkLetterStars(letter.character, 3));
    context.read<ProgressCubit>().recordPractice();
    TtsService.instance.speak(letter.exampleWord, locale: letter.ttsLocale);
    setState(() => _celebrate = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.traceSuccess),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final letter = widget.alphabet.letters[widget.letterIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(letter.character),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.letterDetailListen, icon: const Icon(Icons.volume_up_rounded)),
            Tab(text: l10n.letterDetailTrace, icon: const Icon(Icons.brush_rounded)),
            Tab(text: l10n.letterDetailView, icon: const Icon(Icons.image_rounded)),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              _ListenTab(letter: letter, alphabet: widget.alphabet),
              _TraceTab(letter: letter, onSuccess: _onTraceSuccess),
              _ViewTab(letter: letter, l10n: l10n),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CelebrationBurst(
              play: _celebrate,
              onDone: () => setState(() => _celebrate = false),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListenTab extends StatefulWidget {
  final LetterModel letter;
  final AlphabetModel alphabet;
  const _ListenTab({required this.letter, required this.alphabet});

  @override
  State<_ListenTab> createState() => _ListenTabState();
}

class _ListenTabState extends State<_ListenTab> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _pulse = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.12)
          .chain(CurveTween(curve: Curves.easeOutBack)), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.12, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOut)), weight: 40),
    ]).animate(_pulseController);
    _pulseController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _speak() {
    TtsService.instance.speak(widget.letter.character, locale: widget.letter.ttsLocale);
    _pulseController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _speak,
            child: ScaleTransition(
              scale: _pulse,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  gradient: AppColors.gradientFor(widget.alphabet.color),
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: widget.alphabet.color.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.letter.character,
                    style: GoogleFonts.baloo2(
                      fontSize: 90,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _speak,
            icon: const Icon(Icons.volume_up_rounded),
            label: Text(l10n.letterDetailListen),
          ),
        ],
      ),
    );
  }
}

class _TraceTab extends StatelessWidget {
  final LetterModel letter;
  final VoidCallback onSuccess;
  const _TraceTab({required this.letter, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            l10n.traceInstructions,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          TraceCanvas(text: letter.character, onSuccess: onSuccess),
        ],
      ),
    );
  }
}

class _ViewTab extends StatelessWidget {
  final LetterModel letter;
  final AppLocalizations l10n;
  const _ViewTab({required this.letter, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeSlideIn(
            child: Text(letter.emoji, style: const TextStyle(fontSize: 90)),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.letterDetailExampleWords,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            letter.exampleWord,
            style: GoogleFonts.baloo2(fontSize: 26, fontWeight: FontWeight.w800, color: AppColors.textDark),
          ),
          const SizedBox(height: 16),
          IconButton(
            iconSize: 32,
            icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary),
            onPressed: () =>
                TtsService.instance.speak(letter.exampleWord, locale: letter.ttsLocale),
          ),
        ],
      ),
    );
  }
}
