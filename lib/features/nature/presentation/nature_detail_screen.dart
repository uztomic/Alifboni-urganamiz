import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/tts_locales.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../progress/bloc/progress_cubit.dart';
import '../data/models/nature_entry.dart';
import 'nature_thumbnail.dart';

class NatureDetailScreen extends StatefulWidget {
  final NatureEntry entry;
  const NatureDetailScreen({super.key, required this.entry});

  @override
  State<NatureDetailScreen> createState() => _NatureDetailScreenState();
}

class _NatureDetailScreenState extends State<NatureDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProgressCubit>().recordPractice();
  }

  void _speak(String localeCode) {
    final entry = widget.entry;
    final text = '${entry.nameFor(localeCode)}. ${entry.descriptionFor(localeCode)}';
    TtsService.instance.speak(text, locale: ttsLocaleForLanguage(localeCode));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeCode = Localizations.localeOf(context).languageCode;
    final entry = widget.entry;

    return Scaffold(
      appBar: AppBar(title: Text(entry.nameFor(localeCode))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FadeSlideIn(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: AspectRatio(
                  aspectRatio: 1.2,
                  child: NatureThumbnail(entry: entry, borderRadius: 28),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeSlideIn(
              baseDelay: const Duration(milliseconds: 80),
              child: Text(
                entry.nameFor(localeCode),
                textAlign: TextAlign.center,
                style: GoogleFonts.baloo2(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textDark),
              ),
            ),
            const SizedBox(height: 12),
            FadeSlideIn(
              baseDelay: const Duration(milliseconds: 140),
              child: Text(
                entry.descriptionFor(localeCode),
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(fontSize: 16, height: 1.5, color: AppColors.textDark),
              ),
            ),
            const SizedBox(height: 28),
            _BigListenButton(
              label: l10n.flashcardListen,
              color: AppColors.primary,
              onTap: () => _speak(localeCode),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _BigListenButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _BigListenButton({required this.label, required this.color, required this.onTap});

  @override
  State<_BigListenButton> createState() => _BigListenButtonState();
}

class _BigListenButtonState extends State<_BigListenButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.95),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 110),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: AppColors.gradientFor(widget.color),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 2),
            boxShadow: [
              BoxShadow(color: widget.color.withValues(alpha: 0.4), blurRadius: 14, offset: const Offset(0, 7)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.volume_up_rounded, color: Colors.white, size: 30),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: GoogleFonts.baloo2(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
