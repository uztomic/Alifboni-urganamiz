import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import 'basics.dart';

/// Ota-onalar bo'limiga kirishdan oldingi oddiy tekshiruv
/// (Google Play "Families" talabi): ko'paytirish misoli.
Future<bool> showParentGate(BuildContext context, S s) async {
  final r = Random();
  final a = 3 + r.nextInt(6);
  final b = 3 + r.nextInt(6);
  final answer = a * b;
  final options = <int>{answer};
  while (options.length < 4) {
    final delta = (r.nextInt(9) + 1) * (r.nextBool() ? 1 : -1);
    final v = answer + delta;
    if (v > 0) options.add(v);
  }
  final list = options.toList()..shuffle(r);

  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => _GateDialog(s: s, a: a, b: b, answer: answer, options: list),
  );
  return ok ?? false;
}

class _GateDialog extends StatefulWidget {
  const _GateDialog({required this.s, required this.a, required this.b, required this.answer, required this.options});
  final S s;
  final int a, b, answer;
  final List<int> options;

  @override
  State<_GateDialog> createState() => _GateDialogState();
}

class _GateDialogState extends State<_GateDialog> {
  bool _wrong = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_rounded, color: AppColors.inkSoft, size: 36),
            const SizedBox(height: 8),
            Text(s.t('gateTitle'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text(s.t('gateBody'), textAlign: TextAlign.center, style: const TextStyle(color: AppColors.inkSoft)),
            const SizedBox(height: 16),
            Text('${widget.a} × ${widget.b} = ?',
                style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: AppColors.ink)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                for (final o in widget.options)
                  SizedBox(
                    width: 96,
                    child: ChunkyButton(
                      label: '$o',
                      height: 54,
                      color: AppColors.sky,
                      onTap: () {
                        if (o == widget.answer) {
                          Navigator.of(context).pop(true);
                        } else {
                          setState(() => _wrong = true);
                        }
                      },
                    ),
                  ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: _wrong
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(s.t('gateWrong'), style: const TextStyle(color: AppColors.wrong)),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(s.t('cancel')),
            ),
          ],
        ),
      ),
    );
  }
}
