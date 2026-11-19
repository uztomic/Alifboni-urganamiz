import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../../app.dart';
import '../../../core/ads/ads_service.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/voice_lines.dart';
import '../../../data/content/tales.dart';
import '../../bloc/progress_cubit.dart';
import '../../widgets/activity_scope.dart';
import '../../widgets/banner_ad_view.dart';
import '../../widgets/basics.dart';

/// Ertaklar ro'yxati (tungi uslubda).
class TalesScreen extends StatelessWidget {
  const TalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Scaffold(
      backgroundColor: AppColors.night,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(title: s.t('talesTitle'), color: Colors.white),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                itemCount: tales.length + 1,
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        children: [
                          const Ziko(mood: ZikoMood.sleep, size: 80),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(s.t('talesIntro'),
                                style: TextStyle(fontSize: 15, color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    );
                  }
                  final t = tales[i - 1];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Bouncy(
                      onTap: () => go<void>(context, TalePlayerScreen(index: i - 1)),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF34307A),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(color: const Color(0xFF433E95), borderRadius: BorderRadius.circular(18)),
                              alignment: Alignment.center,
                              child: PictureBadge(emoji: t.emoji, size: 48),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(s.uzText(t.title),
                                      maxLines: 2,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                                  Text(s.t('minutesShort', [(t.seconds / 60).ceil()]),
                                      style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.6))),
                                ],
                              ),
                            ),
                            const Icon(Icons.play_circle_fill_rounded, color: AppColors.sun, size: 40),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const BannerAdView(),
          ],
        ),
      ),
    );
  }
}

/// Ertak tinglash.
class TalePlayerScreen extends StatefulWidget {
  const TalePlayerScreen({super.key, required this.index});
  final int index;

  @override
  State<TalePlayerScreen> createState() => _TalePlayerScreenState();
}

class _TalePlayerScreenState extends State<TalePlayerScreen> {
  final _player = AudioPlayer();
  late int _index = widget.index;
  StreamSubscription<PlayerState>? _sub;
  bool _counted = false;

  Tale get tale => tales[_index];

  @override
  void initState() {
    super.initState();
    AudioService.instance.stopVoice();
    _sub = _player.playerStateStream.listen((st) {
      if (st.processingState == ProcessingState.completed) _onEnd();
    });
    _load();
  }

  Future<void> _load() async {
    _counted = false;
    try {
      await _player.setAsset(tale.asset);
      await _player.play();
    } catch (_) {}
  }

  Future<void> _onEnd() async {
    if (_counted) return;
    _counted = true;
    await _player.pause();
    await _player.seek(Duration.zero);
    if (!mounted) return;
    context.read<ProgressCubit>().taleListened();
    AudioService.instance.say(Lines.taleEnd.$1);
    AdsService.instance.onActivityCompleted();
  }

  void _goTo(int i) {
    if (i < 0 || i >= tales.length) return;
    setState(() => _index = i);
    _load();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _player.dispose();
    super.dispose();
  }

  String _fmt(Duration d) => '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return ActivityScope(
      music: null,
      child: Scaffold(
        backgroundColor: AppColors.night,
        body: SafeArea(
          child: Column(
            children: [
              ScreenHeader(title: s.t('talesTitle'), color: Colors.white),
              const Spacer(),
              StreamBuilder<bool>(
                stream: _player.playingStream,
                builder: (_, snap) => Ziko(mood: snap.data == true ? ZikoMood.hello : ZikoMood.sleep, size: 170),
              ),
              const SizedBox(height: 16),
              PictureBadge(emoji: tale.emoji, size: 72),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(s.uzText(tale.title),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white)),
              ),
              const Spacer(),
              StreamBuilder<Duration>(
                stream: _player.positionStream,
                builder: (_, snap) {
                  final pos = snap.data ?? Duration.zero;
                  final total = _player.duration ?? Duration(seconds: tale.seconds);
                  final v = total.inMilliseconds == 0 ? 0.0 : (pos.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColors.sun,
                            inactiveTrackColor: Colors.white24,
                            thumbColor: AppColors.sun,
                            trackHeight: 6,
                          ),
                          child: Slider(
                            value: v,
                            onChanged: (x) => _player.seek(Duration(milliseconds: (x * total.inMilliseconds).round())),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_fmt(pos), style: const TextStyle(color: Colors.white70)),
                            Text(_fmt(total), style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundButton(
                      icon: Icons.skip_previous_rounded,
                      onTap: _index > 0 ? () => _goTo(_index - 1) : null,
                      size: 58,
                    ),
                    const SizedBox(width: 22),
                    StreamBuilder<bool>(
                      stream: _player.playingStream,
                      builder: (_, snap) {
                        final playing = snap.data ?? false;
                        return RoundButton(
                          icon: playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          color: AppColors.sun,
                          iconColor: AppColors.night,
                          size: 84,
                          onTap: () {
                            if (playing) {
                              _player.pause();
                            } else {
                              AudioService.instance.stopVoice();
                              _player.play();
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 22),
                    RoundButton(
                      icon: Icons.skip_next_rounded,
                      onTap: _index < tales.length - 1 ? () => _goTo(_index + 1) : null,
                      size: 58,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
