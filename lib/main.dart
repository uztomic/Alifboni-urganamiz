import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_languages.dart';
import 'core/localization/material_locale_fallback.dart';
import 'core/services/ads_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/storage_service.dart';
import 'core/services/tts_service.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_open_ad_observer.dart';
import 'core/widgets/connectivity_gate.dart';
import 'features/progress/bloc/progress_cubit.dart';
import 'features/splash/presentation/splash_screen.dart';
import 'features/settings/bloc/settings_cubit.dart';
import 'l10n/generated/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.instance.init();
  await TtsService.instance.init(
    enabled: StorageService.instance.soundEnabled,
    speed: StorageService.instance.voiceSpeed,
  );
  await NotificationService.instance.init();
  // Ads init can be slow and isn't needed for the first frame, so it
  // doesn't block startup (TZ 10: <2s launch time).
  AdsService.instance.init();

  runApp(const AlifboApp());
}

class AlifboApp extends StatelessWidget {
  const AlifboApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SettingsCubit()),
        BlocProvider(create: (_) => ProgressCubit()),
      ],
      child: Builder(
        builder: (context) {
          final settings = context.watch<SettingsCubit>().state;
          return MaterialApp(
            title: "Alifbo & Lug'at",
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            locale: settings.locale,
            supportedLocales: kSupportedLocales,
            localizationsDelegates: [
              ...AppLocalizations.localizationsDelegates,
              ...materialLocaleFallbackDelegates,
            ],
            localeResolutionCallback: (locale, supported) {
              for (final l in supported) {
                if (l.languageCode == locale?.languageCode &&
                    l.scriptCode == locale?.scriptCode) {
                  return l;
                }
              }
              return supported.first;
            },
            builder: (context, child) => AppOpenAdObserver(
              child: ConnectivityGate(child: child!),
            ),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
