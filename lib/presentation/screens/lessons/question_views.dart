import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/audio/audio_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/services/lesson_engine.dart';
import '../../widgets/basics.dart';
import '../alphabet/trace_pad.dart';

/// Xato bosilganda chayqaladigan qobiq.
class Shake extends StatefulWidget {
  const Shake({super.key, required this.trigger, required this.child});
  final int trigger;
  final Widget child;

  @override
  State<Shake> createState() => _ShakeState();
}

class _ShakeState extends State<Shake> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));

  @override
  void didUpdateWidget(covariant Shake old) {
    super.didUpdateWidget(old);
    if (old.trigger != widget.trigger) _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _c,
        builder: (_, child) => Transform.translate(
          offset: Offset(math.sin(_c.value * math.pi * 6) * 10 * (1 - _c.value), 0),
          child: child,
        ),
        child: widget.child,
      );
}

// ---------------------------------------------------------------------------
// Tanlov savoli
// ---------------------------------------------------------------------------

class ChoiceView extends StatelessWidget {
  const ChoiceView({
    super.key,
    required this.q,
    required this.color,
    required this.wrongPicks,
    required this.solvedIndex,
    required this.onPick,
    required this.shakeCount,
  });

  final ChoiceQuestion q;
  final Color color;
  final Set<int> wrongPicks;
  final int? solvedIndex;
  final ValueChanged<int> onPick;
  final int shakeCount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final heroH = (c.maxHeight * 0.36).clamp(120.0, 240.0);
      return Column(
        children: [
          if (q.hero != null) ...[
            SizedBox(height: heroH, child: HeroView(hero: q.hero!, color: color, onCorrect: solvedIndex != null)),
            const SizedBox(height: 16),
          ],
          Expanded(child: Center(child: _options(context, c.maxWidth))),
        ],
      );
    });
  }

  _OptionState _stateOf(int i) {
    if (solvedIndex == i) return _OptionState.correct;
    if (wrongPicks.contains(i)) return _OptionState.wrong;
    if (solvedIndex != null) return _OptionState.faded;
    return _OptionState.idle;
  }

  Widget _options(BuildContext context, double width) {
    switch (q.style) {
      case OptionStyle.letter:
        final n = q.options.length;
        final cols = n <= 3 ? n : 2;
        final size = ((width - 16 * (cols + 1)) / cols).clamp(80.0, 150.0);
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: [
            for (var i = 0; i < n; i++)
              _OptionShell(
                state: _stateOf(i),
                shake: wrongPicks.contains(i) ? shakeCount : 0,
                color: color,
                onTap: () => onPick(i),
                width: size,
                height: size,
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      q.options[i].label,
                      style: TextStyle(
                        fontFamily: AppFonts.letters,
                        fontSize: 72,
                        fontWeight: FontWeight.w700,
                        color: _stateOf(i) == _OptionState.correct ? Colors.white : AppColors.ink,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      case OptionStyle.picture:
        final size = ((width - 16 * 4) / 3).clamp(84.0, 140.0);
        return Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: [
            for (var i = 0; i < q.options.length; i++)
              _OptionShell(
                state: _stateOf(i),
                shake: wrongPicks.contains(i) ? shakeCount : 0,
                color: color,
                onTap: () => onPick(i),
                width: size,
                height: size,
                child: PictureBadge(emoji: q.options[i].emoji, swatch: q.options[i].swatch, size: size * 0.7),
              ),
          ],
        );
      case OptionStyle.word:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < q.options.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _OptionShell(
                  state: _stateOf(i),
                  shake: wrongPicks.contains(i) ? shakeCount : 0,
                  color: color,
                  onTap: () => onPick(i),
                  width: math.min(width - 32, 420),
                  height: 78,
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      if (q.options[i].emoji.isNotEmpty) PictureBadge(emoji: q.options[i].emoji, size: 52),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          q.options[i].label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: _stateOf(i) == _OptionState.correct ? Colors.white : AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
    }
  }
}

enum _OptionState { idle, correct, wrong, faded }

class _OptionShell extends StatelessWidget {
  const _OptionShell({
    required this.state,
    required this.shake,
    required this.color,
    required this.onTap,
    required this.width,
    required this.height,
    required this.child,
  });

  final _OptionState state;
  final int shake;
  final Color color;
  final VoidCallback onTap;
  final double width, height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final (bg, border, shadow) = switch (state) {
      _OptionState.correct => (AppColors.correct, AppColors.correct, AppColors.shade(AppColors.correct)),
      _OptionState.wrong => (const Color(0xFFFFE9E7), AppColors.wrong, const Color(0xFFF5C2BD)),
      _OptionState.faded => (Colors.white, AppColors.line, AppColors.line),
      _OptionState.idle => (Colors.white, AppColors.tint(color, 0.6), AppColors.tint(color, 0.5)),
    };
    return Shake(
      trigger: shake,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: state == _OptionState.faded ? 0.45 : 1,
        child: Bouncy(
          onTap: state == _OptionState.idle ? onTap : null,
          sound: null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: border, width: 3),
              boxShadow: [BoxShadow(color: shadow, offset: const Offset(0, 5))],
            ),
            alignment: Alignment.center,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Savolning yuqori qismi: katta harf, "A → ?", rasm yoki matn.
class HeroView extends StatelessWidget {
  const HeroView({super.key, required this.hero, required this.color, this.onCorrect = false});
  final QuestionHero hero;
  final Color color;
  final bool onCorrect;

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (hero.letter != null) {
      content = AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.gradient(color),
            borderRadius: BorderRadius.circular(34),
            boxShadow: [BoxShadow(color: AppColors.shade(color), offset: const Offset(0, 6))],
          ),
          alignment: Alignment.center,
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Text(hero.letter!,
                  style: const TextStyle(
                      fontFamily: AppFonts.letters, fontSize: 120, fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),
        ),
      );
    } else if (hero.arrowFrom != null) {
      content = FittedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _box(hero.arrowFrom!, color, filled: true),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Icon(Icons.arrow_forward_rounded, size: 56, color: AppColors.inkSoft),
            ),
            _box('?', color, filled: false),
          ],
        ),
      );
    } else if (hero.emoji != null || hero.swatch != null) {
      content = AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(34),
            boxShadow: [BoxShadow(color: AppColors.line, offset: const Offset(0, 6))],
          ),
          alignment: Alignment.center,
          child: LayoutBuilder(
            builder: (_, c) => PictureBadge(emoji: hero.emoji ?? '', swatch: hero.swatch, size: c.maxWidth * 0.72),
          ),
        ),
      );
    } else {
      content = Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: onCorrect ? AppColors.correct : AppColors.tint(color, 0.6), width: 3),
          boxShadow: [BoxShadow(color: AppColors.line, offset: const Offset(0, 6))],
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(
              hero.text ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontFamily: AppFonts.letters, fontSize: 44, fontWeight: FontWeight.w700, color: AppColors.ink, height: 1.3),
            ),
          ),
        ),
      );
    }
    return Center(child: content);
  }

  Widget _box(String t, Color c, {required bool filled}) => Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          color: filled ? c : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: c, width: 4),
        ),
        alignment: Alignment.center,
        child: Text(t,
            style: TextStyle(
                fontFamily: AppFonts.letters, fontSize: 72, fontWeight: FontWeight.w700, color: filled ? Colors.white : c)),
      );
}

// ---------------------------------------------------------------------------
// Yig'ish savoli (harflar yoki bo'g'inlar)
// ---------------------------------------------------------------------------

class BuildView extends StatefulWidget {
  const BuildView({super.key, required this.q, required this.color, required this.onDone, required this.onMistake});
  final BuildQuestion q;
  final Color color;
  final VoidCallback onDone;
  final VoidCallback onMistake;

  @override
  State<BuildView> createState() => _BuildViewState();
}

class _BuildViewState extends State<BuildView> {
  final List<int> _placed = []; // pool indekslari
  int _shakeIndex = -1;
  int _shake = 0;

  bool get _done => _placed.length == widget.q.target.length;

  void _tap(int poolIndex) {
    if (_done || _placed.contains(poolIndex)) return;
    final need = widget.q.target[_placed.length];
    final got = widget.q.pool[poolIndex];
    if (got.toLowerCase() == need.toLowerCase()) {
      AudioService.instance.play(Sfx.pop);
      setState(() => _placed.add(poolIndex));
      if (_done) {
        AudioService.instance.play(Sfx.correct);
        widget.onDone();
      }
    } else {
      AudioService.instance.play(Sfx.wrong);
      setState(() {
        _shakeIndex = poolIndex;
        _shake++;
      });
      widget.onMistake();
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.q;
    final tileW = q.syllables ? 92.0 : 64.0;
    return LayoutBuilder(builder: (context, c) {
      final pic = (c.maxHeight * 0.3).clamp(90.0, 180.0);
      return Column(
        children: [
          PictureBadge(emoji: q.emoji, size: pic),
          const SizedBox(height: 18),
          // Slotlar
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < q.target.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: tileW,
                  height: 70,
                  decoration: BoxDecoration(
                    color: i < _placed.length ? (_done ? AppColors.correct : widget.color) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: i == _placed.length ? widget.color : AppColors.line,
                      width: i == _placed.length ? 3 : 2,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: i < _placed.length
                      ? Text(q.target[i],
                          style: const TextStyle(
                              fontFamily: AppFonts.letters, fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white))
                      : null,
                ),
            ],
          ),
          const Spacer(),
          // Bo'laklar
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              for (var i = 0; i < q.pool.length; i++)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _placed.contains(i) ? 0.15 : 1,
                  child: Shake(
                    trigger: _shakeIndex == i ? _shake : 0,
                    child: Bouncy(
                      onTap: _placed.contains(i) || _done ? null : () => _tap(i),
                      sound: null,
                      child: Container(
                        width: tileW,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.tint(widget.color, 0.55), width: 2.5),
                          boxShadow: [BoxShadow(color: AppColors.tint(widget.color, 0.5), offset: const Offset(0, 5))],
                        ),
                        alignment: Alignment.center,
                        child: Text(q.pool[i],
                            style: const TextStyle(
                                fontFamily: AppFonts.letters, fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.ink)),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      );
    });
  }
}

// ---------------------------------------------------------------------------
// Yozish savoli
// ---------------------------------------------------------------------------

class TraceView extends StatelessWidget {
  const TraceView({super.key, required this.q, required this.color, required this.onDone, this.onOutside});
  final TraceQuestion q;
  final Color color;
  final VoidCallback onDone;
  final VoidCallback? onOutside;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final size = math.min(c.maxWidth - 16, c.maxHeight - 16).clamp(200.0, 380.0);
      return Center(
        child: TracePad(glyph: q.glyph, color: color, size: size, onSuccess: onDone, onStrokeOutside: onOutside),
      );
    });
  }
}

// ---------------------------------------------------------------------------
// Tanishuv kartochkasi
// ---------------------------------------------------------------------------

class IntroView extends StatelessWidget {
  const IntroView({super.key, required this.q, required this.color, required this.onReplay});
  final IntroQuestion q;
  final Color color;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    final l = q.letter;
    final w = l.mainWord;
    return LayoutBuilder(builder: (context, c) {
      final box = (c.maxHeight * 0.5).clamp(150.0, 280.0);
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Bouncy(
            onTap: onReplay,
            sound: null,
            child: Container(
              width: box * 1.25,
              height: box,
              decoration: BoxDecoration(
                gradient: AppColors.gradient(l.isVowel ? AppColors.coral : color),
                borderRadius: BorderRadius.circular(36),
                boxShadow: [BoxShadow(color: AppColors.shade(l.isVowel ? AppColors.coral : color), offset: const Offset(0, 7))],
              ),
              alignment: Alignment.center,
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    l.upper == l.lower ? l.upper : '${l.upper} ${l.lower}',
                    style: const TextStyle(fontFamily: AppFonts.letters, fontSize: 120, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          if (w != null) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PictureBadge(emoji: w.emoji, size: 72),
                const SizedBox(width: 12),
                Text(w.text,
                    style: const TextStyle(fontFamily: AppFonts.letters, fontSize: 36, fontWeight: FontWeight.w700)),
              ],
            ),
          ],
        ],
      );
    });
  }
}
