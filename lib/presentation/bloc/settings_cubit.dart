import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/audio/audio_service.dart';
import '../../core/l10n/strings.dart';
import '../../domain/entities/alphabet.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsState extends Equatable {
  const SettingsState({
    required this.lang,
    required this.script,
    required this.voice,
    required this.sfx,
    required this.music,
    required this.childName,
    required this.onboarded,
  });

  final UiLang lang;
  final ScriptId script;
  final bool voice;
  final bool sfx;
  final bool music;
  final String childName;
  final bool onboarded;

  S get s => S(lang);

  SettingsState copyWith({
    UiLang? lang,
    ScriptId? script,
    bool? voice,
    bool? sfx,
    bool? music,
    String? childName,
    bool? onboarded,
  }) =>
      SettingsState(
        lang: lang ?? this.lang,
        script: script ?? this.script,
        voice: voice ?? this.voice,
        sfx: sfx ?? this.sfx,
        music: music ?? this.music,
        childName: childName ?? this.childName,
        onboarded: onboarded ?? this.onboarded,
      );

  @override
  List<Object?> get props => [lang, script, voice, sfx, music, childName, onboarded];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._repo) : super(_load(_repo));

  final SettingsRepository _repo;

  static SettingsState _load(SettingsRepository r) => SettingsState(
        lang: UiLang.fromCode(r.uiLang),
        script: ScriptIdX.fromName(r.script),
        voice: r.voice,
        sfx: r.sfx,
        music: r.music,
        childName: r.childName,
        onboarded: r.onboarded,
      );

  /// "Tanishuv" darsi har safar keyingi 6 ta harfdan boshlanadi.
  int takeIntroOffset() {
    final v = _repo.introOffset;
    _repo.introOffset = v + 1;
    return v;
  }

  /// Ilovani baholashni so'rash vaqti keldimi (tugatilgan faoliyatlar soni
  /// bo'yicha). Bir marta so'ralgandan keyin yana 25 ta faoliyatdan so'ng.
  bool shouldAskReview(int completedActivities) {
    final last = _repo.reviewAskedAt;
    if (completedActivities < 4) return false;
    return last == 0 || completedActivities - last >= 25;
  }

  void markReviewAsked(int completedActivities) => _repo.reviewAskedAt = completedActivities;

  void setLang(UiLang l) {
    _repo.uiLang = l.code;
    emit(state.copyWith(lang: l));
  }

  void setScript(ScriptId id) {
    _repo.script = id.name;
    emit(state.copyWith(script: id));
  }

  void setVoice(bool v) {
    _repo.voice = v;
    AudioService.instance.voiceOn = v;
    if (!v) AudioService.instance.stopVoice();
    emit(state.copyWith(voice: v));
  }

  void setSfx(bool v) {
    _repo.sfx = v;
    AudioService.instance.sfxOn = v;
    emit(state.copyWith(sfx: v));
  }

  void setMusic(bool v) {
    _repo.music = v;
    AudioService.instance.setMusicOn(v);
    emit(state.copyWith(music: v));
  }

  void setChildName(String name) {
    final n = name.trim();
    _repo.childName = n;
    emit(state.copyWith(childName: n));
  }

  void finishOnboarding() {
    _repo.onboarded = true;
    emit(state.copyWith(onboarded: true));
  }
}
