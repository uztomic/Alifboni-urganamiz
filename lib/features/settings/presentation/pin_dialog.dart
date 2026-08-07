import 'package:flutter/material.dart';
import '../../../l10n/generated/app_localizations.dart';

/// Shows a 4-digit PIN entry dialog. Returns the entered PIN, or null if
/// cancelled. When [confirm] is true, the user must type it twice
/// (used the first time a parent sets their PIN).
Future<String?> showPinDialog(
  BuildContext context, {
  required String title,
  bool confirm = false,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final controller = TextEditingController();
  final confirmController = TextEditingController();
  String? error;

  return showDialog<String>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  autofocus: true,
                  decoration: const InputDecoration(counterText: ''),
                ),
                if (confirm)
                  TextField(
                    controller: confirmController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    maxLength: 4,
                    decoration: const InputDecoration(counterText: ''),
                  ),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(error!, style: const TextStyle(color: Colors.red)),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.commonClose),
              ),
              ElevatedButton(
                onPressed: () {
                  final pin = controller.text.trim();
                  if (pin.length != 4) {
                    setState(() => error = '4 ta raqam kiriting');
                    return;
                  }
                  if (confirm && pin != confirmController.text.trim()) {
                    setState(() => error = l10n.parentZoneWrongPin);
                    return;
                  }
                  Navigator.of(context).pop(pin);
                },
                child: Text(l10n.commonNext),
              ),
            ],
          );
        },
      );
    },
  );
}
