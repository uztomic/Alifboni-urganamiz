import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/voice_lines.dart';
import '../../widgets/basics.dart';
import '../../../domain/entities/alphabet.dart';
import '../../../domain/services/text_units.dart';
import '../../bloc/progress_cubit.dart';
import 'trace_screen.dart';

/// Bitta harf sahifasi. Chapga-o'ngga surib keyingi harfga o'tiladi.
class LetterScreen extends StatefulWidget {
  const LetterScreen({super.key, required this.alphabet, required this.initialIndex});
  final Alphabet alphabet;
  final int initialIndex;

  @override
  State<LetterScreen> createState() => _LetterScreenState();
}

class _LetterScreenState extends State<LetterScreen> {
  late final PageController _pc = PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;

  Alphabet get a => widget.alphabet;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _present(_index));
  }

  @override
  void dispose() {
    AudioService.instance.stopVoice();
    _pc.dispose();
    super.dispose();
  }

  void _present(int i) {
    final l = a.letters[i];
    context.read<ProgressCubit>().markSeen(a.id, l.upper);
    final lines = <Line>[(l.say, l.sayLang)];
    final w = l.mainWord;
    if (w != null) lines.add((w.say, w.lang));
    AudioService.instance.sayAll(lines);
  }

  void _goto(int i) {
    if (i < 0 || i >= a.letters.length) return;
    _pc.animateToPage(i, duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final l = a.letters[_index];
    return Scaffold(
      body: SoftBackground(
        accent: a.color,
        child: SafeArea(
          child: Column(
            children: [
              ScreenHeader(
                title: s.t(a.titleKey),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Text('${_index + 1} / ${a.letters.length}',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pc,
                  itemCount: a.letters.length,
                  onPageChanged: (i) {
                    setState(() => _index = i);
                    AudioService.instance.play(Sfx.swipe);
                    _present(i);
                  },
                  itemBuilder: (context, i) => _LetterPage(alphabet: a, letter: a.letters[i]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                child: Row(
                  children: [
                    RoundButton(
                      icon: Icons.chevron_left_rounded,
                      onTap: _index > 0 ? () => _goto(_index - 1) : null,
                      size: 58,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ChunkyButton(
                        label: s.t('tabWrite'),
                        icon: Icons.draw_rounded,
                        color: a.color,
                        onTap: l.isLetter || l.kind == LetterKind.digraph
                            ? () => go<void>(context, TraceScreen(alphabet: a, letter: l))
                            : null,
                      ),
                    ),
                    const SizedBox(width: 14),
                    RoundButton(
                      icon: Icons.chevron_right_rounded,
                      onTap: _index < a.letters.length - 1 ? () => _goto(_index + 1) : null,
                      size: 58,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LetterPage extends StatefulWidget {
  const _LetterPage({required this.alphabet, required this.letter});
  final Alphabet alphabet;
  final Letter letter;

  @override
  State<_LetterPage> createState() => _LetterPageState();
}

class _LetterPageState extends State<_LetterPage> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 450));

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _sayLetter() {
    _pulse.forward(from: 0);
    AudioService.instance.say(widget.letter.say, lang: widget.letter.sayLang);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final l = widget.letter;
    final a = widget.alphabet;
    final color = l.isVowel ? AppColors.coral : a.color;
    final kindLabel = switch (l.kind) {
      LetterKind.vowel => s.t('vowel'),
      LetterKind.consonant => s.t('consonant'),
      LetterKind.sign => s.t('sign'),
      LetterKind.digraph => s.t('digraph'),
    };

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      children: [
        // --- Katta harf ---
        Bouncy(
          onTap: _sayLetter,
          sound: null,
          child: AnimatedBuilder(
            animation: _pulse,
            builder: (_, child) {
              final t = Curves.easeOut.transform(_pulse.value);
              final scale = 1 + 0.08 * (1 - (2 * t - 1).abs());
              return Transform.scale(scale: scale, child: child);
            },
            child: Container(
              height: 230,
              decoration: BoxDecoration(
                gradient: AppColors.gradient(color),
                borderRadius: BorderRadius.circular(36),
                boxShadow: [BoxShadow(color: AppColors.shade(color), offset: const Offset(0, 7))],
              ),
              child: Stack(
                children: [
                  Center(
                    child: FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text.rich(
                          TextSpan(children: [
                            TextSpan(text: l.upper),
                            if (l.upper != l.lower)
                              TextSpan(
                                text: ' ${l.lower}',
                                style: TextStyle(color: Colors.white.withValues(alpha: 0.82)),
                              ),
                          ]),
                          style: const TextStyle(
                            fontFamily: AppFonts.letters,
                            fontSize: 150,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 14,
                    top: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(kindLabel,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14)),
                    ),
                  ),
                  const Positioned(
                    right: 14,
                    bottom: 14,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.volume_up_rounded, color: AppColors.ink),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        // --- So'zlar ---
        if (l.words.isNotEmpty) _MainWordCard(word: l.words.first, letter: l, alphabet: a, color: color),
        if (l.words.length > 1) ...[
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              for (final w in l.words.skip(1))
                Bouncy(
                  onTap: () => AudioService.instance.say(w.say, lang: w.lang),
                  sound: null,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(10, 8, 16, 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [BoxShadow(color: AppColors.line, offset: const Offset(0, 3))],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PictureBadge(emoji: w.emoji, size: 38),
                        const SizedBox(width: 8),
                        _HighlightedWord(word: w.text, letter: l, alphabet: a, color: color, fontSize: 20),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
        if (l.kind == LetterKind.sign && l.words.isEmpty)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              s.uzText(a.id.isUzbek ? "Tutuq belgisi soʻz ichida tovushni ajratib koʻrsatadi: maʼno, sanʼat." : ''),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: AppColors.inkSoft),
            ),
          ),
      ],
    );
  }
}

class _MainWordCard extends StatelessWidget {
  const _MainWordCard({required this.word, required this.letter, required this.alphabet, required this.color});
  final Word word;
  final Letter letter;
  final Alphabet alphabet;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Bouncy(
      onTap: () => AudioService.instance.say(word.say, lang: word.lang),
      sound: null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: AppColors.line, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(color: AppColors.tint(color, 0.88), borderRadius: BorderRadius.circular(24)),
              alignment: Alignment.center,
              child: PictureBadge(emoji: word.emoji, size: 72),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: _HighlightedWord(word: word.text, letter: letter, alphabet: alphabet, color: color, fontSize: 38),
              ),
            ),
            const Icon(Icons.volume_up_rounded, color: AppColors.inkSoft),
          ],
        ),
      ),
    );
  }
}

/// So'zdagi shu harfni rangli qilib ko'rsatadi.
class _HighlightedWord extends StatelessWidget {
  const _HighlightedWord({
    required this.word,
    required this.letter,
    required this.alphabet,
    required this.color,
    required this.fontSize,
  });
  final String word;
  final Letter letter;
  final Alphabet alphabet;
  final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final target = letter.lower.toLowerCase();
    final List<String> units;
    if (letter.kind == LetterKind.digraph) {
      // "bodring" ichidagi "ng" ni ajratamiz
      final idx = word.toLowerCase().indexOf(target);
      units = idx < 0
          ? [word]
          : [word.substring(0, idx), word.substring(idx, idx + target.length), word.substring(idx + target.length)];
    } else {
      units = splitUnits(word, alphabet);
    }
    return Text.rich(
      TextSpan(children: [
        for (final u in units)
          TextSpan(
            text: u,
            style: u.toLowerCase() == target ? TextStyle(color: color, fontWeight: FontWeight.w700) : null,
          ),
      ]),
      style: TextStyle(fontFamily: AppFonts.letters, fontSize: fontSize, color: AppColors.ink, fontWeight: FontWeight.w400),
    );
  }
}
