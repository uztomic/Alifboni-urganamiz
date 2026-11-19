import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app.dart';
import 'core/ads/ads_service.dart';
import 'core/audio/audio_service.dart';
import 'core/utils/pictures.dart';
import 'data/sources/local_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Color(0xFFFFF6E9),
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  await Storage.instance.init();
  await Pictures.init();
  final st = Storage.instance;
  await AudioService.instance.init(
    voice: st.get<bool>('voice', true),
    sfx: st.get<bool>('sfx', true),
    music: st.get<bool>('music', true),
  );
  // Reklama birinchi kadrni kutmasin.
  unawaited(AdsService.instance.init());

  runApp(const AlifboApp());
}
