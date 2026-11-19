import 'package:flutter/widgets.dart';

import '../../core/ads/ads_service.dart';
import '../../core/audio/audio_service.dart';

/// Dars, o'yin va ertak sahifalarini o'raydi: shu sahifa ochiq turganda
/// to'liq ekranli reklama chiqmaydi va mos fon musiqasi yoqiladi.
class ActivityScope extends StatefulWidget {
  const ActivityScope({super.key, required this.child, this.music});
  final Widget child;
  final Music? music;

  @override
  State<ActivityScope> createState() => _ActivityScopeState();
}

class _ActivityScopeState extends State<ActivityScope> {
  @override
  void initState() {
    super.initState();
    AdsService.instance.enterActivity();
    AudioService.instance.music(widget.music);
  }

  @override
  void dispose() {
    AdsService.instance.exitActivity();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
