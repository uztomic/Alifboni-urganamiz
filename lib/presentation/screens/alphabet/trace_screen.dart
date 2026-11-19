import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/voice_lines.dart';
import '../../widgets/basics.dart';
import '../../../domain/entities/alphabet.dart';
import '../../bloc/progress_cubit.dart';
import 'trace_pad.dart';

/// Harfni yozish: avval katta, keyin kichik harf.
class TraceScreen extends StatefulWidget {
  const TraceScreen({super.key, required this.alphabet, required this.letter});
  final Alphabet alphabet;
  final Letter letter;

  @override
  State<TraceScreen> createState() => _TraceScreenState();
}

class _TraceScreenState extends State<TraceScreen> {
  final _padKey = GlobalKey<TracePadState>();
  late final List<String> _glyphs = [
    widget.letter.upper,
    if (widget.letter.lower != widget.letter.upper) widget.letter.lower,
  ];
  int _step = 0;
  int _confetti = 0;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AudioService.instance.sayAll([
        (widget.letter.say, widget.letter.sayLang),
        if (widget.alphabet.id.isUzbek) Lines.traceHow,
      ]);
    });
  }

  @override
  void dispose() {
    AudioService.instance.stopVoice();
    super.dispose();
  }

  void _onSuccess() {
    final ui = context.uiLang;
    setState(() => _confetti++);
    final praise = Praise.good(ui);
    AudioService.instance.say(praise.$1, lang: praise.$2);
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (!mounted) return;
      if (_step < _glyphs.length - 1) {
        setState(() => _step++);
      } else {
        context.read<ProgressCubit>().markTraced(widget.alphabet.id, widget.letter.upper);
        AudioService.instance.play(Sfx.levelComplete);
        setState(() => _finished = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final color = widget.letter.isVowel ? AppColors.coral : widget.alphabet.color;
    final padSize = (MediaQuery.of(context).size.width - 48).clamp(220.0, 360.0);

    return Scaffold(
      body: SoftBackground(
        accent: color,
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  ScreenHeader(title: s.t('tabWrite')),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        for (var i = 0; i < _glyphs.length; i++)
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 10,
                              decoration: BoxDecoration(
                                color: i < _step || _finished ? AppColors.correct : (i == _step ? color : AppColors.line),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _finished ? s.t('traceGood') : s.t('traceHint'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Center(
                      child: _finished
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Ziko(mood: ZikoMood.happy, size: 150),
                                const SizedBox(height: 12),
                                Text(
                                  _glyphs.join(' '),
                                  style: TextStyle(
                                      fontFamily: AppFonts.letters, fontSize: 64, fontWeight: FontWeight.w700, color: color),
                                ),
                              ],
                            )
                          : TracePad(
                              key: _padKey,
                              glyph: _glyphs[_step],
                              color: color,
                              size: padSize,
                              onSuccess: _onSuccess,
                              onStrokeOutside: () {
                                if (widget.alphabet.id.isUzbek) {
                                  AudioService.instance.say(Lines.traceOut.$1);
                                }
                              },
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                    child: _finished
                        ? Row(
                            children: [
                              Expanded(
                                child: ChunkyButton(
                                  label: s.t('again'),
                                  color: AppColors.sky,
                                  icon: Icons.refresh_rounded,
                                  onTap: () => setState(() {
                                    _finished = false;
                                    _step = 0;
                                  }),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ChunkyButton(
                                  label: s.t('done'),
                                  icon: Icons.check_rounded,
                                  onTap: () => Navigator.of(context).pop(),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RoundButton(
                                icon: Icons.volume_up_rounded,
                                onTap: () => AudioService.instance
                                    .say(widget.letter.say, lang: widget.letter.sayLang),
                              ),
                              const SizedBox(width: 16),
                              ChunkyButton(
                                label: s.t('clear'),
                                icon: Icons.cleaning_services_rounded,
                                color: AppColors.inkSoft,
                                expand: false,
                                onTap: () => _padKey.currentState?.reset(),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
              Positioned.fill(child: Confetti(trigger: _confetti)),
            ],
          ),
        ),
      ),
    );
  }
}
