import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app.dart';
import '../../../core/l10n/strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/basics.dart';
import '../../../data/content/alphabets.dart';
import '../../../domain/entities/alphabet.dart';
import '../../bloc/progress_cubit.dart';
import '../../bloc/settings_cubit.dart';

/// Alifbo tanlash kartochkasi.
class ScriptTile extends StatelessWidget {
  const ScriptTile({super.key, required this.alphabet, required this.selected, required this.onTap, required this.s});
  final Alphabet alphabet;
  final bool selected;
  final VoidCallback onTap;
  final S s;

  @override
  Widget build(BuildContext context) {
    final a = alphabet;
    final learned = context.select<ProgressCubit, int>((c) => c.state.learnedCount(a.id));
    final total = a.letters.length;
    return Bouncy(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.tint(a.color, 0.86) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: selected ? a.color : AppColors.line, width: 2.5),
        ),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                gradient: AppColors.gradient(a.color),
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: Text(
                a.badge,
                style: const TextStyle(fontFamily: AppFonts.letters, fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s.t(a.titleKey), style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(
                    a.id == ScriptId.uzNew ? s.t('newAlphabetNote') : s.t('lettersCount', [total]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13.5, color: AppColors.inkSoft),
                  ),
                  if (learned > 0) ...[
                    const SizedBox(height: 6),
                    StepBar(value: learned / total, color: a.color),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (selected) Icon(Icons.check_circle_rounded, color: a.color, size: 28),
          ],
        ),
      ),
    );
  }
}

/// Pastdan chiqadigan alifbo tanlash oynasi.
Future<void> showScriptPicker(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
    builder: (ctx) {
      final s = ctx.s;
      final current = ctx.watch<SettingsCubit>().state.script;
      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.85),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(height: 14),
              Text(s.t('chooseScript'), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(height: 14),
              for (final a in allAlphabets)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ScriptTile(
                    alphabet: a,
                    selected: a.id == current,
                    s: s,
                    onTap: () {
                      ctx.read<SettingsCubit>().setScript(a.id);
                      Navigator.of(ctx).pop();
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}
