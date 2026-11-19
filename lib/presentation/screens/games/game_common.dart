import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ads/ads_service.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/voice_lines.dart';
import '../../../domain/entities/alphabet.dart';
import '../../bloc/progress_cubit.dart';
import '../../widgets/basics.dart';
import '../lessons/result_screen.dart';

/// O'yin tugaganda: natija saqlanadi, (kerak bo'lsa) reklama, natija ekrani.
Future<void> finishGame(
  BuildContext context, {
  required String title,
  required Color color,
  required int stars,
  required int correct,
  required int total,
  required Widget Function() retry,
}) async {
  context.read<ProgressCubit>().gamePlayed();
  AudioService.instance.play(Sfx.levelComplete);
  await Future<void>.delayed(const Duration(milliseconds: 600));
  await AdsService.instance.onActivityCompleted();
  if (!context.mounted) return;
  Navigator.of(context).pushReplacement(softRoute(ResultScreen(
    title: title,
    color: color,
    stars: stars,
    correct: correct,
    total: total,
    retry: retry,
  )));
}

/// "«X» harfini top" ovozi — alifbo tiliga mos.
List<Line> findLetterVoice(Alphabet a, Letter l) {
  final key = l.uzKey;
  if (a.id.isUzbek && key != null) {
    final q = uz('Qaysi biri «$key» harfi?');
    return AudioService.instance.hasVoice(q.$1, q.$2) ? [q] : [(l.say, l.sayLang)];
  }
  if (a.voiceLang == VoiceLang.ru) return [ru('Найди букву ${l.upper}')];
  if (a.voiceLang == VoiceLang.en) return [en('Find the letter ${l.say}')];
  return [(l.say, l.sayLang)];
}
