import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_languages.dart';
import '../../../core/services/ads_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/widgets/app_page_route.dart';
import '../../../core/widgets/fade_slide_in.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../bloc/settings_cubit.dart';
import '../bloc/settings_state.dart';
import 'parent_zone_screen.dart';
import 'pin_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _openParentZone(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SettingsCubit>();
    final hasPin = cubit.state.parentPinSet;

    if (!hasPin) {
      final pin = await showPinDialog(context, title: l10n.parentZoneSetPin, confirm: true);
      if (pin == null) return;
      await cubit.setParentPin(pin);
    } else {
      final pin = await showPinDialog(context, title: l10n.parentZoneEnterPin);
      if (pin == null) return;
      if (!cubit.verifyParentPin(pin)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l10n.parentZoneWrongPin)));
        }
        return;
      }
    }

    // Per TZ 8.2: show an interstitial before entering the parent zone.
    await AdsService.instance.showInterstitial();

    if (context.mounted) {
      pushAnimated(context, const ParentZoneScreen());
    }
  }

  Future<void> _pickNotificationTime(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 18, minute: 0),
    );
    if (time == null) return;
    await NotificationService.instance.requestPermission();
    await NotificationService.instance.scheduleDailyReminder(
      hour: time.hour,
      minute: time.minute,
      title: l10n.notificationReminderTitle,
      body: l10n.notificationReminderBody,
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.settingsNotificationTime}: ${time.format(context)}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(l10n.settingsInterfaceLanguage,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: kInterfaceLanguages.asMap().entries.map((entry) {
                  final lang = entry.value;
                  final selected = lang.locale == state.locale;
                  return FadeSlideIn(
                    index: entry.key,
                    baseDelay: const Duration(milliseconds: 30),
                    child: ChoiceChip(
                      label: Text(
                        '${lang.flag} ${lang.nativeName}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: selected ? Colors.white : AppColors.textDark,
                        ),
                      ),
                      selected: selected,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      onSelected: (_) => context.read<SettingsCubit>().changeLanguage(lang.locale),
                    ),
                  );
                }).toList(),
              ),
              const Divider(height: 40),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settingsSoundEnabled),
                value: state.soundEnabled,
                onChanged: (v) => context.read<SettingsCubit>().toggleSound(v),
              ),
              Text(l10n.settingsVoiceSpeed,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              Slider(
                value: state.voiceSpeed,
                min: 0.2,
                max: 0.8,
                onChanged: (v) => context.read<SettingsCubit>().changeVoiceSpeed(v),
              ),
              const Divider(height: 24),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.notifications_active_rounded),
                title: Text(l10n.settingsNotificationTime),
                onTap: () => _pickNotificationTime(context),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.family_restroom_rounded),
                title: Text(l10n.settingsParentZone),
                onTap: () => _openParentZone(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
