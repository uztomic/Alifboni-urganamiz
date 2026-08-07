import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/celebration_burst.dart';
import '../../../core/widgets/trace_canvas.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../progress/bloc/progress_cubit.dart';

class WritePracticeScreen extends StatefulWidget {
  final String text;
  const WritePracticeScreen({super.key, required this.text});

  @override
  State<WritePracticeScreen> createState() => _WritePracticeScreenState();
}

class _WritePracticeScreenState extends State<WritePracticeScreen> {
  bool _celebrate = false;

  void _onSuccess() {
    context.read<ProgressCubit>().recordPractice();
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
    return Scaffold(
      appBar: AppBar(title: Text(l10n.flashcardWritePractice)),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    l10n.traceInstructions,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  TraceCanvas(text: widget.text, onSuccess: _onSuccess, size: 300),
                ],
              ),
            ),
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
