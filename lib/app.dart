import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/ads/ads_service.dart';
import 'core/l10n/strings.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/local_progress_repository.dart';
import 'data/repositories/local_settings_repository.dart';
import 'data/sources/local_storage.dart';
import 'presentation/screens/splash/splash_screen.dart';
import 'presentation/bloc/progress_cubit.dart';
import 'presentation/bloc/settings_cubit.dart';

class AlifboApp extends StatefulWidget {
  const AlifboApp({super.key});

  @override
  State<AlifboApp> createState() => _AlifboAppState();
}

class _AlifboAppState extends State<AlifboApp> {
  late final AppLifecycleListener _life = AppLifecycleListener(
    onHide: AdsService.instance.onBackground,
    onShow: AdsService.instance.onForeground,
  );

  @override
  void initState() {
    super.initState();
    _life; // tinglovchini ishga tushiradi
  }

  @override
  void dispose() {
    _life.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SettingsCubit(LocalSettingsRepository(Storage.instance))),
        BlocProvider(create: (_) => ProgressCubit(LocalProgressRepository(Storage.instance))),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (a, b) => a.lang != b.lang,
        builder: (context, settings) => MaterialApp(
          title: "Alifboni o'rganamiz",
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          locale: settings.lang.locale,
          supportedLocales: const [Locale('uz'), Locale('ru'), Locale('en')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          // Katta shrift sozlamasi bo'lgan telefonlarda ham bolalar
          // interfeysi buzilmasligi uchun matn kattalashishini cheklaymiz.
          builder: (context, child) {
            final mq = MediaQuery.of(context);
            return MediaQuery(
              data: mq.copyWith(textScaler: mq.textScaler.clamp(maxScaleFactor: 1.2)),
              child: child!,
            );
          },
          home: const SplashScreen(),
        ),
      ),
    );
  }
}

/// Qisqa yozuv: `context.s.t('key')`.
extension SX on BuildContext {
  S get s => S(watch<SettingsCubit>().state.lang);
  S get sRead => S(read<SettingsCubit>().state.lang);
  UiLang get uiLang => read<SettingsCubit>().state.lang;
}
