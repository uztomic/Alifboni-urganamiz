import 'dart:async';
import 'package:flutter/material.dart';
import '../services/ads_service.dart';
import '../../l10n/generated/app_localizations.dart';

/// Shows a bottom sheet offering to unlock something by watching a
/// rewarded ad. Returns true only once the user has actually watched the
/// ad to completion and earned the reward; false if they dismissed the
/// sheet, no rewarded ad was ready, or they backed out of the ad early.
///
/// This genuinely waits for the whole ad-watching flow to finish (not
/// just for the bottom sheet to close, and not just for the ad to open —
/// see AdsService.showRewarded for why the latter used to make this gate
/// never actually unlock).
Future<bool> showRewardedGateSheet(
  BuildContext context, {
  required String emoji,
  String? title,
  String? body,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final completer = Completer<bool>();
  var buttonPressed = false;
  var isChecking = false;

  unawaited(
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 56)),
                  const SizedBox(height: 12),
                  Text(
                    title ?? l10n.unlockWithAdTitle,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    body ?? l10n.unlockWithAdBody,
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  isChecking
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton.icon(
                          icon: const Icon(Icons.play_circle_fill_rounded),
                          label: Text(l10n.unlockWithAdButton),
                          onPressed: () async {
                            // Rewarded ads are prefetched on a backoff loop
                            // (up to 60s between retries), so a child
                            // opening this sheet right between attempts
                            // would otherwise always see "not ready" even
                            // though a fresh ad often loads within a
                            // couple of seconds. Give it a short chance
                            // before giving up.
                            if (!AdsService.instance.isRewardedReady) {
                              setSheetState(() => isChecking = true);
                              final ready =
                                  await AdsService.instance.ensureRewardedReady();
                              setSheetState(() => isChecking = false);
                              if (!ready) {
                                buttonPressed = true;
                                if (sheetContext.mounted) {
                                  Navigator.of(sheetContext).pop();
                                }
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(l10n.unlockWithAdNotReady)),
                                  );
                                }
                                if (!completer.isCompleted) completer.complete(false);
                                return;
                              }
                            }

                            buttonPressed = true;
                            if (sheetContext.mounted) {
                              Navigator.of(sheetContext).pop();
                            }

                            final earned =
                                await AdsService.instance.showRewarded(onReward: () {});
                            if (!completer.isCompleted) completer.complete(earned);
                          },
                        ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      // Sheet dismissed by tapping outside / swiping down, without ever
      // pressing the "watch ad" button.
      if (!buttonPressed && !completer.isCompleted) {
        completer.complete(false);
      }
    }),
  );

  return completer.future;
}
