import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../bloc/progress_cubit.dart';
import '../bloc/settings_cubit.dart';
import 'basics.dart';
import 'parent_gate.dart';

/// Bir nechta dars/o'yindan keyin ota-onalardan Play Market'da baho va
/// izoh qoldirishni so'raydi. Ota-ona tekshiruvidan o'tadi.
///
/// Muhim: Google Play qoidasi baho/izoh evaziga mukofot berishni
/// TAQIQLAYDI (ilova o'chirilishi mumkin), shuning uchun bu yerda mukofot
/// yo'q — faqat iliq so'rov.
Future<void> maybeAskForReview(BuildContext context) async {
  final settings = context.read<SettingsCubit>();
  final activities = context.read<ProgressCubit>().state.activities;
  if (!settings.shouldAskReview(activities)) return;
  settings.markReviewAsked(activities);
  await askForReview(context, S(settings.state.lang));
}

/// So'rovni darhol ko'rsatadi (sozlamalardagi "Ilovani baholash" tugmasi).
Future<void> askForReview(BuildContext context, S s, {bool skipPrompt = false}) async {
  if (!skipPrompt) {
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Ziko(mood: ZikoMood.happy, size: 110),
              const SizedBox(height: 10),
              Text(s.t('reviewTitle'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [StarRow(stars: 5, max: 5, size: 30)],
              ),
              const SizedBox(height: 10),
              Text(s.t('reviewBody'), textAlign: TextAlign.center, style: const TextStyle(color: AppColors.inkSoft)),
              const SizedBox(height: 18),
              ChunkyButton(label: s.t('reviewYes'), color: AppColors.sun, icon: Icons.star_rounded, onTap: () => Navigator.pop(ctx, true)),
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(s.t('reviewLater'))),
            ],
          ),
        ),
      ),
    );
    if (yes != true || !context.mounted) return;
  }
  final ok = await showParentGate(context, s);
  if (!ok) return;
  final review = InAppReview.instance;
  try {
    if (await review.isAvailable()) {
      await review.requestReview();
    } else {
      await review.openStoreListing();
    }
  } catch (_) {
    try {
      await review.openStoreListing();
    } catch (_) {}
  }
}
